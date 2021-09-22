using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Coolite.Ext.Web;
using DMS.Website.Common;
using DMS.Business;
using DMS.Model;
using DMS.Common;
using System.Collections;
using System.Data;
using DMS.Business.Cache;
using DMS.Model.Data;
using Lafite.RoleModel.Security;
using Microsoft.Practices.Unity;
using System.Xml;
using System.Xml.Xsl;
using System.IO;
using DMS.Common.Common;
using NPOI.HSSF.UserModel;
using NPOI.SS.UserModel;

namespace DMS.Website.Pages.Shipment
{

    [AjaxMethodProxyID(IDMode = AjaxMethodProxyIDMode.None)]
    public partial class ShipmentList : BasePage
    {
        private static HSSFWorkbook hssfworkbook;
        #region 公用
        IRoleModelContext _context = RoleModelContext.Current;
        private IPurchaseOrderBLL _logbll = null;
        private IShipmentBLL _business = null;
        private IAttachmentBLL _attachBll = null;
        private IDealerMasters _dealers = Global.ApplicationContainer.Resolve<IDealerMasters>();
        private ITIWcDealerBarcodeqRcodeScanBLL _remarks = new TIWcDealerBarcodeqRcodeScanBLL();
        [Dependency]
        public IShipmentBLL business
        {
            get { return _business; }
            set { _business = value; }
        }

        [Dependency]
        public IPurchaseOrderBLL logbll
        {
            get { return _logbll; }
            set { _logbll = value; }
        }

        [Dependency]
        public IAttachmentBLL attachBll
        {
            get { return _attachBll; }
            set { _attachBll = value; }
        }
        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                this.hiddenIsAdmin.Text = IsAdmin ? "1" : "0";

                this.btnUploadFile.Visible = IsDealer;
                this.btnUploadInvoice.Visible = IsDealer;
                //this.BaoTaiButton.Visible = false;
                this.btnInsert.Visible = IsDealer;
                this.btnInsertJS.Visible = IsDealer;
                this.btnInsertBorrow.Visible = IsDealer;
                this.btnConfirm.Visible = IsDealer;
                if (business.IsAdminRole() || IsDealer)
                {
                    this.btnUpdate.Visible = true;
                }
                else {
                    this.btnUpdate.Visible = false;
                }
               
                this.btnUpdateConsignment.Visible = business.IsAdminRole();
                // this.btnUpdate.Visible = false;
                if (business.IsAdminRole())
                {
                    this.RevokeButton.Visible = false;
                }


                this.Bind_DealerListByFilter(DealerStore, true);
                this.Bind_ProductLine(ProductLineStore);
                this.Bind_Dictionary(ShipmentOrderTypeStore, SR.Consts_ShipmentOrder_Type.ToString());
                this.Bind_OrderStatus(this.OrderStatusStore);
                //this.Bind_Hospital(this.HospitalWinStore, "", DateTime.MinValue);

                if (IsDealer)
                {
                    if (RoleModelContext.Current.User.CorpType == DealerType.LP.ToString() || RoleModelContext.Current.User.CorpType == DealerType.LS.ToString())
                    {
                        this.cbDealer.Disabled = false;
                    }
                    else
                    {
                        this.cbDealer.Disabled = true;
                    }
                    this.hiddenInitDealerId.Text = RoleModelContext.Current.User.CorpId.Value.ToString();
                    this.cbDealer.SelectedItem.Value = RoleModelContext.Current.User.CorpId.Value.ToString();
                    DealerOperationLogDLL.instance.writeLog(SR.CONST_MODULE_SHIPMENT);
                    DataSet ds = _remarks.selectremark(this.cbDealer.SelectedItem.Value);
                    if (ds.Tables[0].Rows[0]["cnt"].ToString() != "0")
                    {

                        this.Remark.Hidden = false;
                    }
                    else
                    {
                        this.Remark.Hidden = true;
                    }
                }
                else
                {
                    //控制查询按钮
                    Permissions pers = this._context.User.GetPermissions();
                    this.btnSearch.Visible = pers.IsPermissible(Business.ShipmentBLL.Action_DealerShipment, PermissionType.Read);
                }
            }

        }

        protected void Page_Init(object sender, EventArgs e)
        {
            this.ShipmentDialog1.GridStore = this.DetailStore;
            //this.ShipmentDialog1.GridConsignmentStore = this.ConsignmentDetailStore;
        }

        protected void UploadClick(object sender, AjaxEventArgs e)
        {
            if (this.FileUploadField1.HasFile)
            {

                bool error = false;

                string fileName = FileUploadField1.PostedFile.FileName;
                string fileExtention = string.Empty;
                string fileExt = string.Empty;
                if (fileName.LastIndexOf(".") < 0)
                {
                    error = true;
                }
                else
                {
                    fileExtention = fileName.Substring(fileName.LastIndexOf("\\") + 1);
                    fileExt = fileName.Substring(fileName.LastIndexOf(".") + 1).ToLower();
                }

                if (error)
                {
                    Ext.Msg.Show(new MessageBox.Config
                    {
                        Buttons = MessageBox.Button.OK,
                        Icon = MessageBox.Icon.INFO,
                        Title = "文件错误",
                        Message = "请上传正确的文件！"
                    });

                    return;
                }

                //构造文件名称

                string newFileName = DateTime.Now.ToFileTime().ToString() + "." + fileExt;

                //上传文件在Upload文件夹

                string file = Server.MapPath("\\Upload\\UploadFile\\ShipmentAttachment\\" + newFileName);


                //文件上传
                FileUploadField1.PostedFile.SaveAs(file);

                this.hiddenFileName.Text = newFileName;

                Attachment attach = new Attachment();
                attach.Id = Guid.NewGuid();
                attach.MainId = new Guid(this.hiddenOrderId.Text);
                attach.Name = fileExtention;
                attach.Url = newFileName;
                attach.Type = AttachmentType.ShipmentToHospital.ToString();
                attach.UploadDate = DateTime.Now;
                attach.UploadUser = new Guid(_context.User.Id);

                attachBll.AddAttachment(attach);

                Ext.Msg.Show(new MessageBox.Config
                {
                    Buttons = MessageBox.Button.OK,
                    Icon = MessageBox.Icon.INFO,
                    Title = "上传成功",
                    Message = "已成功上传文件！"
                });
            }
            else
            {
                Ext.Msg.Show(new MessageBox.Config
                {
                    Buttons = MessageBox.Button.OK,
                    Icon = MessageBox.Icon.ERROR,
                    Title = "上传失败",
                    Message = "文件未被成功上传！"
                });
            }
        }

        protected void ExportDetail(object sender, EventArgs e)
        {
            Hashtable param = new Hashtable();

            if (!string.IsNullOrEmpty(this.cbProductLine.SelectedItem.Value))
            {
                param.Add("ProductLine", this.cbProductLine.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.cbDealer.SelectedItem.Value))
            {
                param.Add("DealerId", this.cbDealer.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.txtHospital.Text))
            {
                param.Add("HospitalName", this.txtHospital.Text);
            }
            if (!this.txtStartDate.IsNull)
            {
                param.Add("ShipmentDateStart", this.txtStartDate.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!this.txtEndDate.IsNull)
            {
                param.Add("ShipmentDateEnd", this.txtEndDate.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!string.IsNullOrEmpty(this.txtOrderNumber.Text))
            {
                param.Add("OrderNumber", this.txtOrderNumber.Text);
            }
            if (!string.IsNullOrEmpty(this.cbOrderStatus.SelectedItem.Value))
            {
                param.Add("Status", this.cbOrderStatus.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.txtCFN.Text))
            {
                param.Add("Cfn", this.txtCFN.Text);
            }
            if (!string.IsNullOrEmpty(this.txtUPN.Text))
            {
                param.Add("Upn", this.txtUPN.Text);
            }
            if (!string.IsNullOrEmpty(this.txtLotNumber.Text))
            {
                param.Add("LotNumber", this.txtLotNumber.Text);
            }

            if (!string.IsNullOrEmpty(this.cbShipmentOrderTypeWin.SelectedItem.Value))
            {
                param.Add("Type", this.cbShipmentOrderTypeWin.SelectedItem.Value);
            }

            if (!this.txtSubmitDateStart.IsNull)
            {
                param.Add("SubmitDateStart", this.txtSubmitDateStart.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!this.txtSubmitDateEnd.IsNull)
            {
                param.Add("SubmitDateEnd", this.txtSubmitDateEnd.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!string.IsNullOrEmpty(this.cbInvoiceStatus.SelectedItem.Value))
            {
                param.Add("InvoiceStatus", this.cbInvoiceStatus.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.txtInvoiceNo.Text))
            {
                param.Add("InvoiceNo", this.txtInvoiceNo.Text);
            }
            if (!string.IsNullOrEmpty(this.cbInvoiceState.SelectedItem.Value))
            {
                param.Add("InvoiceState", this.cbInvoiceState.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.cbInvoiceState.SelectedItem.Value))
            {
                param.Add("InvoiceNocheck", "1");
            }
            else
            {
                param.Add("InvoiceNocheck", "0");
            }
            if (!this.txtInvoiceDateStart.IsNull)
            {
                param.Add("txtInvoiceDateStart", this.txtInvoiceDateStart.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!this.txtInvoiceDateStart.IsNull)
            {
                param.Add("txtInvoiceDateend", this.txtInvoiceDateStart.SelectedDate.ToString("yyyyMMdd"));
            }
            DataSet queryDs = business.ExportShipmentByFilter(param);

            DataTable dt = queryDs.Tables[0].Copy();

            DataSet ds = new DataSet("经销商销售数据");

            #region 构造日志信息Table

            DataTable dtData = dt;
            dtData.TableName = "经销商销售数据";
            if (null != dtData)
            {
                #region 调整列的顺序,并重命名列名

                Dictionary<string, string> dict = new Dictionary<string, string>
                        {
                            {"DealerName", "经销商"},
                            {"DealerCode", "经销商ERP Code"},
                            {"OrderNumber", "销售单号"},
                            {"HospitalName", "医院名称"},
                            {"ShipmentDate", "销售日期"},
                            {"ShipmentName", "上报人"},
                            {"ATTRIBUTE_NAME", "产品线"},
                            {"StatusName", "单据状态"},
                            {"WarehouseName", "仓库"},
                            {"WarehouseTypeName", "仓库类型"},
                            {"CFN", "产品型号"},
                            {"LotNumber", "批次"},
                            {"QRCode", "二维码"},
                            {"ShipmentQty", "销售数量"},
                            {"ConvertFactor", "单位数量"},
                            {"Annexsource","附件来源"},
                            {"Remark", "备注"},
                            {"AttachmentList", "附件信息"}
                        };

                CommonFunction.SetColumnIndexAndRemoveColumn(dtData, dict);

                #endregion 调整列的顺序,并重命名列名

                ds.Tables.Add(dtData);
            }

            #endregion 构造日志信息Table

            ExcelExporter.ExportDataSetToExcel(ds);
        }
        protected void Bind_OrderStatus(Store store)
        {
            // IDictionary<string, string> dicts = DictionaryHelper.GetDictionary(SR.Consts_ShipmentOrder_Status);
            IDictionary<string, string> dicts = business.SelectShipmentOrderStatus();
            // var query = from t in dicts where t.Key != ShipmentOrderStatus.Cancelled.ToString() select t;
            var query = from t in dicts select t;
            if (RoleModelContext.Current.User.CorpType == DealerType.T2.ToString())
            {
                query = from t in query where t.Key != ShipmentOrderStatus.Submitted.ToString() select t;
                query = from t in query where t.Key != ShipmentOrderStatus.Cancelled.ToString() select t;
            }
            store.DataSource = query;
            store.DataBind();

        }

        public void Bind_Hospital(Store store, string ProductLine, DateTime ShipmentDate)
        {
            Hashtable param = new Hashtable();

            param.Add("DealerId", string.IsNullOrEmpty(this.hiddenDealerId.Value.ToString()) ? cbDealerWin.SelectedItem.Value : this.hiddenDealerId.Value);

            if (!string.IsNullOrEmpty(ProductLine))
            {
                param.Add("ProductLine", ProductLine);
            }
            if (ShipmentDate == DateTime.MinValue)
            {
                store.DataSource = new DataTable();
                store.DataBind();
            }
            else
            {
                param.Add("ShipmentDate", ShipmentDate);
                DealerMasters dm = new DealerMasters();
                DataSet ds = dm.SelectHospitalForDealerByShipmentDate(param);
                store.DataSource = ds;
                store.DataBind();
            }
        }

        /// <summary>
        /// 补用量：经销商集合去除管理员
        /// </summary>
        /// <param name="store"></param>
        protected void Bind_Dealer(Store store)
        {
            // IDictionary<string, string> dicts = DictionaryHelper.GetDictionary(SR.Consts_ShipmentOrder_Status);
            //           IDictionary<string, string> dicts = DealerStore.DataSource;
            //;
            //           // var query = from t in dicts where t.Key != ShipmentOrderStatus.Cancelled.ToString() select t;
            //           var query = from t in dicts select t;
            //           if (RoleModelContext.Current.User.CorpType == DealerType.T2.ToString())
            //           {
            //               query = from t in query where t.Key != ShipmentOrderStatus.Submitted.ToString() select t;
            //               query = from t in query where t.Key != ShipmentOrderStatus.Cancelled.ToString() select t;
            //           }
            //           store.DataSource = query;
            //           store.DataBind();

        }

        protected void Store_RefreshProductLineWin(object sender, StoreRefreshDataEventArgs e)
        {
            Guid DealerId = Guid.Empty;

            if (!business.IsAdminRole())
            {
                if (e.Parameters["DealerId"] != null && !string.IsNullOrEmpty(e.Parameters["DealerId"].ToString()))
                {
                    DealerId = new Guid(e.Parameters["DealerId"].ToString());
                }
            }
            else
            {
                if (!string.IsNullOrEmpty(cbDealerWin.SelectedItem.Value.ToString()))
                {
                    DealerId = new Guid(cbDealerWin.SelectedItem.Value.ToString());
                }
                else
                {
                    if (!string.IsNullOrEmpty(this.hiddenDealerId.Text))
                    {
                        DealerId = new Guid(this.hiddenDealerId.Text);
                    }
                }
            }
            DealerMasters dm = new DealerMasters();
            DataSet ds = dm.GetNoLimitProductLineByDealer(DealerId);

            if (sender is Store)
            {
                Store store1 = (sender as Store);
                store1.DataSource = ds;
                store1.DataBind();
            }
        }

        protected void OrderLogStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            Guid tid = new Guid(this.hiddenOrderId.Text);
            int totalCount = 0;
            DataSet ds = _logbll.QueryPurchaseOrderLogByHeaderId(tid, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBarLog.PageSize : e.Limit), out totalCount);
            e.TotalCount = totalCount;

            this.OrderLogStore.DataSource = ds;
            this.OrderLogStore.DataBind();
        }

        protected void AttachmentStore_Refresh(object sender, StoreRefreshDataEventArgs e)
        {
            Guid tid = new Guid(this.hiddenOrderId.Text);
            int totalCount = 0;

            DataSet ds = attachBll.GetAttachmentByMainId(tid, AttachmentType.ShipmentToHospital, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBarAttachement.PageSize : e.Limit), out totalCount);
            e.TotalCount = totalCount;

            AttachmentStore.DataSource = ds;
            AttachmentStore.DataBind();
        }


        protected void Store_RefreshHospitalWin(object sender, StoreRefreshDataEventArgs e)
        {
            Guid DealerId = Guid.Empty;
            Guid ProductLineId = Guid.Empty;
            Hashtable param = new Hashtable();
            if (!business.IsAdminRole())
            {
                if (e.Parameters["DealerId"] != null && !string.IsNullOrEmpty(e.Parameters["DealerId"].ToString()))
                {
                    DealerId = new Guid(e.Parameters["DealerId"].ToString());
                    param.Add("DealerId", DealerId);
                }
            }
            else
            {
                if (!string.IsNullOrEmpty(cbDealerWin.SelectedItem.Value.ToString()))
                {
                    DealerId = new Guid(cbDealerWin.SelectedItem.Value.ToString());
                    param.Add("DealerId", DealerId);
                }
            }
            if (e.Parameters["ProductLineId"] != null && !string.IsNullOrEmpty(e.Parameters["ProductLineId"].ToString()))
            {
                ProductLineId = new Guid(e.Parameters["ProductLineId"].ToString());
                param.Add("ProductLine", ProductLineId);
            }
            DealerMasters dm = new DealerMasters();
            DataSet ds = null;



            if (sender is Store)
            {
                Store store1 = (sender as Store);

                if (cbIsAuthWin.Checked)
                {
                    ds = dm.GetHospitalForDealer();

                }
                else
                {
                    ds = dm.GetHospitalForDealerByFilter(param);
                }
                //int totalCount = 0;
                //store1.DataSource = dm.SelectHospitalForDealerByFilterNew(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.cbHospitalWin.PageSize : e.Limit), out totalCount);
                store1.DataSource = ds;
                store1.DataBind();
                //e.TotalCount = totalCount;
            }
        }
        [AjaxMethod]
        public void SetShipmentData()
        {
            DealerMaster dmst = new DealerMaster();
            if (IsDealer)
            {
                dmst = _dealers.SelectDealerMasterParentTypebyId(RoleModelContext.Current.User.CorpId.Value);
            }
            else
            {
                dmst = _dealers.SelectDealerMasterParentTypebyId(new Guid(this.cbDealerWin.SelectedItem.Value));
            }
            //int IsSix = 0;
            //if ((dmst.Taxpayer == "红海" && hiddenProductLineId.Text == "8f15d92a-47e4-462f-a603-f61983d61b7b" && dmst.DealerType == "T2") || (hiddenProductLineId.Text == "8f15d92a-47e4-462f-a603-f61983d61b7b" && dmst.DealerType == "T1"))
            //{
            //    //如果经销是红海，且产品线为Endo要判断是否在6和工作日之内,如在本月6个工作日之内则日期只可选择上个月最后一条否则还是按照原来的逻辑 lije add 20160922
            //    IsSix = _business.GetCalendarDateSix();
            //}

            if (_business.GetCalendarDateSix() > 0)
            {
                //如果经销是红海，且产品线为Endo在6和工作日之内
                DateTime dttim = DateTime.Now;


                this.txtShipmentDateWin.MinDate = dttim.AddDays(1 - dttim.Day).AddMonths(-1).Date;
                this.txtShipmentDateWin.MaxDate = dttim.AddDays(1 - dttim.Day).AddDays(-1).Date;

            }
            else
            {

            }

            if (this.hiddenShipmentStatus.Text == ShipmentOrderStatus.Draft.ToString())
            {
                //草稿状态用量日期可编辑
                txtShipmentDateWin.Disabled = false;
            }
        }
        [AjaxMethod]
        public void ReLoadHositalStore()
        {
            if (this.txtOrderStatusWin.Text == "草稿")
            {
                this.hiddenHospitalId.Text = "";
                OnHospitalChange();
                this.HospitalWinStore.DataBind();
            }
        }

        protected void ResultStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            //IShipmentBLL business = new ShipmentBLL();

            int totalCount = 0;

            Hashtable param = new Hashtable();

            if (!string.IsNullOrEmpty(this.cbProductLine.SelectedItem.Value))
            {
                param.Add("ProductLine", this.cbProductLine.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.cbDealer.SelectedItem.Value))
            {
                param.Add("DealerId", this.cbDealer.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.txtHospital.Text))
            {
                param.Add("HospitalName", this.txtHospital.Text);
            }
            if (!this.txtStartDate.IsNull)
            {
                param.Add("ShipmentDateStart", this.txtStartDate.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!this.txtEndDate.IsNull)
            {
                param.Add("ShipmentDateEnd", this.txtEndDate.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!string.IsNullOrEmpty(this.txtOrderNumber.Text))
            {
                param.Add("OrderNumber", this.txtOrderNumber.Text);
            }
            if (!string.IsNullOrEmpty(this.cbOrderStatus.SelectedItem.Value))
            {
                param.Add("Status", this.cbOrderStatus.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.txtCFN.Text))
            {
                param.Add("Cfn", this.txtCFN.Text);
            }
            if (!string.IsNullOrEmpty(this.txtUPN.Text))
            {
                param.Add("Upn", this.txtUPN.Text);
            }
            if (!string.IsNullOrEmpty(this.txtLotNumber.Text))
            {
                param.Add("LotNumber", this.txtLotNumber.Text);
            }

            if (!string.IsNullOrEmpty(this.cbShipmentOrderTypeWin.SelectedItem.Value))
            {
                param.Add("Type", this.cbShipmentOrderTypeWin.SelectedItem.Value);
            }

            if (!this.txtSubmitDateStart.IsNull)
            {
                param.Add("SubmitDateStart", this.txtSubmitDateStart.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!this.txtSubmitDateEnd.IsNull)
            {
                param.Add("SubmitDateEnd", this.txtSubmitDateEnd.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!string.IsNullOrEmpty(this.cbInvoiceStatus.SelectedItem.Value))
            {
                param.Add("InvoiceStatus", this.cbInvoiceStatus.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.txtInvoiceNo.Text))
            {
                param.Add("InvoiceNo", this.txtInvoiceNo.Text);
            }
            if (!string.IsNullOrEmpty(this.cbInvoiceState.SelectedItem.Value))
            {
                param.Add("InvoiceState", this.cbInvoiceState.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.cbInvoiceState.SelectedItem.Value))
            {
                param.Add("InvoiceNocheck", "1");
            }
            else
            {
                param.Add("InvoiceNocheck", "0");
            }
            if (!this.txtInvoiceDateStart.IsNull)
            {
                param.Add("txtInvoiceDateStart", this.txtInvoiceDateStart.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!this.txtInvoiceDateend.IsNull)
            {
                param.Add("txtInvoiceDateend", this.txtInvoiceDateend.SelectedDate.ToString("yyyyMMdd"));
            }
            DataSet ds = business.QueryShipmentHeader(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);

            e.TotalCount = totalCount;

            this.ResultStore.DataSource = ds;
            this.ResultStore.DataBind();
        }


        protected void CheckSubmitResultStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {

            if (!String.IsNullOrEmpty(this.hiddenOrderId.Text) && !String.IsNullOrEmpty(this.hiddenShipmentDate.Text))
            {
                Guid tid = new Guid(this.hiddenOrderId.Text);

                //int totalCount = 0;

                Hashtable param = new Hashtable();

                param.Add("SphId", tid);



                DataSet ds = business.GetHospitalShipmentbscBeforeSubmitInitByCondition(param);

                //this.txtTotalAmount.Text = business.GetShipmentTotalAmount(tid).ToString();
                //this.txtTotalQty.Text = business.GetShipmentTotalQty(tid).ToString();

                //更新表头的记录
                DataSet dsSum = business.GetHospitalShipmentSumBeforeSubmitInitByCondition(param);
                this.lblWrongCnt.Text = "错误记录数：" + dsSum.Tables[0].Rows[0]["ErrorCnt"].ToString() + "条";
                this.lblCorrectCnt.Text = "正确记录数:" + dsSum.Tables[0].Rows[0]["CorrectCnt"].ToString() + "条";
                this.lblSumQty.Text = "销售总数量:" + dsSum.Tables[0].Rows[0]["TotalQty"].ToString();
                this.lblSumPrice.Text = "销售总金额:" + dsSum.Tables[0].Rows[0]["TotalPrice"].ToString();

                //e.TotalCount = totalCount;

                this.CheckSubmitResultStore.DataSource = ds;
                this.CheckSubmitResultStore.DataBind();
            }
        }

        protected void DetailStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            if (!String.IsNullOrEmpty(this.hiddenOrderId.Text) && !String.IsNullOrEmpty(this.hiddenShipmentDate.Text))
            {
                Guid tid = new Guid(this.hiddenOrderId.Text);

                //int totalCount = 0;

                Hashtable param = new Hashtable();

                param.Add("HeaderId", tid);
                param.Add("ShipmentDate", this.hiddenShipmentDate.Text);

                //DataSet ds = business.QueryShipmentLot(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar2.PageSize : e.Limit), out totalCount);
                DataSet ds = business.QueryShipmentLot(param);
                DataSet dsSum = business.QueryShipmentLotSum(param);

                //this.txtTotalAmount.Text = business.GetShipmentTotalAmount(tid).ToString();
                //this.txtTotalQty.Text = business.GetShipmentTotalQty(tid).ToString();
                this.lbGP2SumQty.Text = "销售总数量:" + dsSum.Tables[0].Rows[0]["TotalQty"].ToString();
                this.lbGP2SumPrice.Text = "销售总金额:" + dsSum.Tables[0].Rows[0]["TotalPrice"].ToString();
                this.lbGP2SumQty.Icon = Icon.Sum;
                this.lbGP2SumQty.Icon = Icon.Sum;

                //e.TotalCount = totalCount;

                this.DetailStore.DataSource = ds;
                this.DetailStore.DataBind();
            }
        }

        protected void UpdateOrderPriceStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            if (!String.IsNullOrEmpty(this.hiddenOrderId.Text) && !String.IsNullOrEmpty(this.hiddenShipmentDate.Text))
            {
                Guid tid = new Guid(this.hiddenOrderId.Text);
                Hashtable param = new Hashtable();

                param.Add("HeaderId", tid);
                param.Add("ShipmentDate", this.hiddenShipmentDate.Text);

                DataSet ds = business.QueryShipmentLot(param);

                this.UpdateOrderPriceStore.DataSource = ds;
                this.UpdateOrderPriceStore.DataBind();
            }
        }

        //protected void ConsignmentDetailStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        //{
        //    if (!String.IsNullOrEmpty(this.hiddenOrderId.Text) && !String.IsNullOrEmpty(this.hiddenShipmentDate.Text))
        //    {
        //        Guid tid = new Guid(this.hiddenOrderId.Text);

        //        int totalCount = 0;

        //        Hashtable param = new Hashtable();

        //        param.Add("HeaderId", tid);
        //        param.Add("ShipmentDate", this.hiddenShipmentDate.Text);

        //        if (this.hiddenDealerType.Text == DealerType.T2.ToString() && this.hiddenShipmentType.Text == "Consignment")
        //        {
        //            param.Add("DealerId", this.hiddenDealerId.Text);
        //            param.Add("WarehouseTypes", string.Format("{0},{1}", WarehouseType.Consignment.ToString(), WarehouseType.LP_Consignment.ToString()).Split(','));

        //            DataSet ds = business.QueryShipmentConsignment(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar4.PageSize : e.Limit), out totalCount);

        //            e.TotalCount = totalCount;
        //            this.ConsignmentDetailStore.DataSource = ds;
        //            this.ConsignmentDetailStore.DataBind();

        //            ShipmentHeader header = business.GetShipmentHeaderById(tid);
        //            //if (header.Status == ShipmentOrderStatus.Draft.ToString())
        //            //{
        //            //    this.txtTotalAmount.Text = business.GetConsignmentShipmentTotalAmount(tid).ToString();
        //            //    this.txtTotalQty.Text = business.GetConsignmentShipmentTotalQty(tid).ToString();
        //            //}
        //        }
        //    }
        //}


        protected void ShowDialog(object sender, AjaxEventArgs e)
        {
            //判断是否符合打开对话框的条件
            //1、产品线 2、销售医院
            if (string.IsNullOrEmpty(this.cbProductLineWin.SelectedItem.Value) || string.IsNullOrEmpty(this.cbHospitalWin.SelectedItem.Value))
            {
                Ext.Msg.Alert(GetLocalResourceObject("ShowDialog.Alert.Title").ToString(), GetLocalResourceObject("ShowDialog.Alert.Body").ToString()).Show();
                return;
            }
            //用量日期
            if (this.txtShipmentDateWin.SelectedDate == DateTime.MinValue)
            {
                Ext.Msg.Alert(GetLocalResourceObject("ShowDialog.Alert.Title").ToString(), GetLocalResourceObject("ShowDialog.Alert.Body2").ToString()).Show();
                return;
            }

            string SaleType = e.ExtraParams["DealerWarehouseType"].ToString();
            int IsAuth = this.cbIsAuthWin.Checked == true ? 1 : 0;
            string ShipmentDate = Convert.ToDateTime(e.ExtraParams["ShipmentDate"]).ToString("yyyy-MM-dd");
            if (business.IsAdminRole()|| this.hiddenIsShipmentUpdate.Value.ToString().Equals("UpdateShipment"))
            {
                ShowAdminShipmentDialog(sender, e);
                //this.ShipmentDialog1.Show(new Guid(this.hiddenOrderId.Text), new Guid(this.cbDealerWin.SelectedItem.Value), new Guid(this.cbProductLineWin.SelectedItem.Value), new Guid(this.cbHospitalWin.SelectedItem.Value), SaleType, IsAuth, ShipmentDate);
            }
            else
            {
                this.ShipmentDialog1.Show(new Guid(this.hiddenOrderId.Text), new Guid(this.hiddenDealerId.Text), new Guid(this.hiddenProductLineId.Text), new Guid(this.hiddenHospitalId.Text), SaleType, IsAuth, ShipmentDate);
            }
        }

        protected void ShowAttachmentWindow(object sender, AjaxEventArgs e)
        {
            this.hidRtnVal.Clear();
            this.hidRtnMsg.Clear();
            this.AttachmentWindow.Show();
        }


        protected void ShowDetails(object sender, AjaxEventArgs e)
        {

            if (business.IsAdminRole()||this.hiddenIsShipmentUpdate.Value.ToString().Equals("UpdateShipment"))
            {
                this.ShowDetailsUpdate(sender, e);
                return;

            }

            this.SubmitButton.Text = GetLocalResourceObject("UpdateInvoiceInfo").ToString();

            Renderer r = new Renderer();
            r.Fn = "SetCellCssEditable";

            this.GridPanel2.ColumnModel.SetRenderer(10, r); //单价
            this.GridPanel2.ColumnModel.SetRenderer(12, r); //数量
            /*this.GridPanel2.ColumnModel.SetRenderer(14, r);*/ //二维码
            //初始化detail窗口,因为只有dealer才可以新增，因此打开页面默认选中session中的经销商
            this.hiddenOrderId.Text = string.Empty;
            this.hiddenDealerId.Text = string.Empty;
            this.hiddenProductLineId.Text = string.Empty;
            this.hiddenHospitalId.Text = string.Empty;

            this.txtOrderNumberWin.Text = string.Empty;
            this.txtShipmentDateWin.Clear();
            this.txtOrderStatusWin.Text = string.Empty;
            this.txtMemoWin.Text = string.Empty;
            //this.txtTotalAmount.Text = string.Empty;
            //this.txtTotalQty.Text = string.Empty;
            this.txtInvoiceDateWin.Clear();
            //added by hxw 20130705
            this.txtOfficeWin.Text = string.Empty;
            this.txtInvoiceTitleWin.Text = string.Empty;
            this.txtShipmentOrderTypeWin.Text = string.Empty;
            this.cbIsAuthWin.Checked = false;
            //added by bozhenfei on 20100607
            this.hiddenCurrentEditShipmentId.Text = string.Empty;
            this.hiddenIsEditting.Text = string.Empty;
            //end


            //added by songweiming on 20100617
            this.txtInvoice.Text = string.Empty;

            //Added By Song Yuqi On 20140317 Begin
            r.Fn = "SetCellCssEditable";
            //this.GridPanel3.ColumnModel.SetRenderer(8, r);
            //this.GridPanel3.ColumnModel.SetRenderer(9, r);
            this.TabPanel1.ActiveTabIndex = 0;
            this.TabSearch.Disabled = false;
            //this.TabConsignment.Disabled = true;

            this.hiddenDealerType.Text = string.Empty;
            //Added By Song Yuqi On 20140317 End

            //Add By Songweiming on 2015-08-25 For GSP
            this.hiddenHospitalId.Text = string.Empty;
            this.hiddenShipmentDate.Text = string.Empty;
            this.hiddenIsFirstShipmentDate.Text = string.Empty;
            this.hidRtnVal.Clear();
            this.hidRtnMsg.Clear();

            Guid id = new Guid(e.ExtraParams["OrderId"].ToString());


            //IShipmentBLL business = new ShipmentBLL();
            ShipmentHeader mainData = null;

            //若id为空，说明为新增，则生成新的id，并新增一条记录
            if (id == Guid.Empty)
            {
                id = Guid.NewGuid();
                this.hiddenOrderId.Text = id.ToString();
                mainData = new ShipmentHeader();
                mainData.Id = id;
                mainData.DealerDmaId = RoleModelContext.Current.User.CorpId.Value;
                mainData.Status = ShipmentOrderStatus.Draft.ToString();
                mainData.UpdateDate = DateTime.Now;// added by songweiming on 20100628
                mainData.Type = e.ExtraParams["Type"].ToString(); //added by hxw

                business.InsertShipmentHeader(mainData);

                //New 经销商为操作人的Corp
                this.hiddenDealerType.Text = _context.User.CorpType; // Added By Song Yuqi On 20140317
                this.hiddenShipmentType.Text = mainData.Type;
            }
            //根据ID查询主表数据，并初始化页面
            mainData = business.GetShipmentHeaderById(id);
            this.hiddenOrderId.Text = mainData.Id.ToString();
            this.hiddenShipmentStatus.Text = mainData.Status;
            if (mainData.DealerDmaId != null)
            {
                this.cbDealerWin.SelectedItem.Value = mainData.DealerDmaId.ToString();
                this.hiddenDealerId.Text = mainData.DealerDmaId.ToString();
            }

            //Added By Song Yuqi On 20140317 Begin
            //获得明细单中经销商的类型
            DealerMaster dma = new DealerMasters().GetDealerMaster(new Guid(this.hiddenDealerId.Text));
            this.hiddenDealerType.Text = dma.DealerType;


            if (mainData.ProductLineBumId != null)
            {
                this.hiddenProductLineId.Text = mainData.ProductLineBumId.Value.ToString();
            }



            this.txtOrderNumberWin.Text = mainData.ShipmentNbr;
            if (mainData.ShipmentDate != null)
            {
                this.txtShipmentDateWin.SelectedDate = mainData.ShipmentDate.Value;
                this.hiddenShipmentDate.Text = mainData.ShipmentDate.Value.ToString("yyyy-MM-dd");

            }

            if (mainData.HospitalHosId != null)
            {
                this.hiddenHospitalId.Text = mainData.HospitalHosId.Value.ToString();
            }


            if (mainData.InvoiceDate != null)
            {
                this.txtInvoiceDateWin.SelectedDate = mainData.InvoiceDate.Value;

            }

            //added by songweiming on 20100617
            if (mainData.InvoiceNo != null)
            {
                this.txtInvoice.Text = mainData.InvoiceNo;
            }

            if (mainData.Office != null)
            {
                this.txtOfficeWin.Text = mainData.Office;
            }
            if (mainData.InvoiceTitle != null)
            {
                this.txtInvoiceTitleWin.Text = mainData.InvoiceTitle;
            }

            if (mainData.IsAuth != null)
            {
                this.cbIsAuthWin.Checked = mainData.IsAuth.Value;
            }
            //Added By Song Yuqi On 20140317 Begin
            if (mainData.Type != null)
            {
                this.hiddenShipmentType.Text = mainData.Type;
            }
            //Added By Song Yuqi On 20140317 End

            this.txtOrderStatusWin.Text = DictionaryCacheHelper.GetDictionaryNameById(SR.Consts_ShipmentOrder_Status, mainData.Status);
            this.txtMemoWin.Text = mainData.NoteForPumpSerialNbr;
            //added by hxw
            if (mainData.Type != null)
                this.txtShipmentOrderTypeWin.Text = DictionaryCacheHelper.GetDictionaryNameById(SR.Consts_ShipmentOrder_Type, mainData.Type);
            //this.cbDealerWin.ReadOnly = true;
            this.cbDealerWin.Disabled = true;


            //this.GridPanel2.ColumnModel.Columns[10].ToString();
            //this.GridPanel2.
            this.GridPanel2.ColumnModel.SetEditable(10, false); //单价

            this.GridPanel2.ColumnModel.SetEditable(11, false); //采购价
            this.GridPanel2.ColumnModel.SetHidden(11, true); //采购价

            this.GridPanel2.ColumnModel.SetEditable(12, false); //数量
            this.GridPanel2.ColumnModel.SetEditable(13, false); //实际用量日期
            this.GridPanel2.ColumnModel.SetEditable(14, false); //二维码
            this.GridPanel2.ColumnModel.SetEditable(15, false); //备注
            this.GridPanel2.ColumnModel.SetEditable(18, false); //短期寄售申请单号
            this.GridPanel2.ColumnModel.SetHidden(18, true); //短期寄售申请单号
            this.GridPanel2.ColumnModel.SetHidden(19, true); //删除

            //Edit by SongWeiming on 2015-08-21 实际用量日期不使用
            this.GridPanel2.ColumnModel.SetHidden(13, true);    //实际用量日期

            //Edit By SongWeiming on 2015-08-25 附件下载列不显示         
            this.gpAttachment.ColumnModel.SetHidden(7, true);

            this.cbProductLineWin.Disabled = true;
            this.cbHospitalWin.Disabled = true;
            //this.txtMemoWin.Disabled = true;
            this.txtMemoWin.ReadOnly = true;
            this.txtOfficeWin.ReadOnly = true;
            this.txtInvoiceTitleWin.ReadOnly = true;
            this.txtInvoiceDateWin.Disabled = true;
            this.txtInvoice.ReadOnly = true;
            //this.txtInvoiceTitleWin.Disabled = true;
            this.DraftButton.Disabled = true;
            this.DeleteButton.Disabled = true;
            this.SubmitButton.Disabled = true;
            this.RevokeButton.Disabled = true;
            this.AddItemsButton.Disabled = true;
            this.PriceButton.Disabled = true;

            this.BtnReason.Hidden = true;
            //this.btnShowAdminShipment.Disabled = true;//Added By Song Yuqi On 2016-03-29 

            //this.orderTypeWin.Disabled = true;
            this.txtShipmentDateWin.Disabled = true;
            this.cbIsAuthWin.Disabled = true;

            //Added By Song Yuqi On 20140317 Begin
            //this.GridPanel3.ColumnModel.SetEditable(8, false);
            //this.GridPanel3.ColumnModel.SetEditable(9, false);
            //this.GridPanel3.ColumnModel.SetEditable(10, false);
            //this.GridPanel3.ColumnModel.SetEditable(11, false);
            //this.GridPanel3.ColumnModel.SetHidden(14, true);
            //Edit by SongWeiming on 2015-08-21 实际用量日期不使用
            //this.GridPanel3.ColumnModel.SetHidden(10, true);


            //二级经销商寄售销售单
            //if (this.hiddenDealerType.Text == DealerType.T2.ToString() && mainData.Type == "Consignment")
            //{
            //    if (mainData.Status == ShipmentOrderStatus.Draft.ToString())
            //    {
            //        this.TabPanel1.ActiveTabIndex = 1;
            //        this.TabConsignment.Disabled = false;
            //        this.TabSearch.Disabled = true;
            //    }
            //    else
            //    {
            //        this.TabPanel1.ActiveTabIndex = 1;
            //        this.TabConsignment.Disabled = false;
            //        this.TabSearch.Disabled = false;
            //        this.btnAddConsignment.Disabled = true;
            //    }
            //}
            //Added By Song Yuqi On 20140317 End

            //一级及平台 短期寄售销售
            if ((this.hiddenDealerType.Text == DealerType.T1.ToString() || this.hiddenDealerType.Text == DealerType.LP.ToString() || this.hiddenDealerType.Text == DealerType.LS.ToString())
                && mainData.Type == "Borrow")
            {
                this.GridPanel2.ColumnModel.SetHidden(18, false);   //短期寄售申请单号
            }

            if (IsDealer)
            {
                this.gpAttachment.ColumnModel.SetHidden(7, false);

                if (mainData.Status == ShipmentOrderStatus.Draft.ToString())
                {
                    this.SubmitButton.Text = GetLocalResourceObject("DetailWindow.SubmitButton.Text").ToString();
                    this.cbProductLineWin.Disabled = false;
                    this.cbHospitalWin.Disabled = false;
                    this.txtOrderStatusWin.Text = "草稿";
                    //this.txtMemoWin.Disabled = false;
                    this.txtMemoWin.ReadOnly = false;
                    this.txtInvoiceTitleWin.ReadOnly = false;
                    this.txtOfficeWin.ReadOnly = false;
                    this.txtInvoice.ReadOnly = false;
                    this.txtInvoiceDateWin.Disabled = false;
                    //this.txtInvoiceTitleWin.Disabled = false;
                    this.DraftButton.Disabled = false;
                    this.DeleteButton.Disabled = false;
                    this.SubmitButton.Disabled = false;
                    this.PriceButton.Disabled = true;
                    //this.orderTypeWin.Disabled = false;
                    this.txtShipmentDateWin.Disabled = false;
                    this.GridPanel2.ColumnModel.SetEditable(10, true);  //单价
                    this.GridPanel2.ColumnModel.SetHidden(11, true);  //采购价
                    this.GridPanel2.ColumnModel.SetEditable(12, true);  //数量
                    this.GridPanel2.ColumnModel.SetEditable(13, true);  //实际用量日期
                    this.GridPanel2.ColumnModel.SetEditable(15, true);  //备注
                    this.GridPanel2.ColumnModel.SetEditable(18, true);  //短期寄售申请单号
                    this.GridPanel2.ColumnModel.SetHidden(19, false);   //删除
                    this.GridPanel2.ColumnModel.SetEditable(13, true);  //实际用量日期
                    this.GridPanel2.ColumnModel.SetEditable(14, false);  //二维码
                    this.cbIsAuthWin.Disabled = false;
                    //this.GridPanel2.ColumnModel.SetHidden(10, false);

                    //Edit By SongWeiming on 20150821 草稿状态下，实际用量日期不显示
                    this.GridPanel2.ColumnModel.SetHidden(13, true);    //实际用量日期
                    //Edit By SongWeiming on 20150825 附件下载列不显示


                    //Added By Song Yuqi On 20130317 Begin
                    //this.GridPanel3.ColumnModel.SetEditable(8, true);
                    //this.GridPanel3.ColumnModel.SetEditable(9, true);
                    //this.GridPanel3.ColumnModel.SetEditable(10, true);
                    //this.GridPanel3.ColumnModel.SetEditable(11, true);
                    //this.GridPanel3.ColumnModel.SetHidden(14, false);

                    //Edit By SongWeiming on 20150821 草稿状态下，实际用量日期不显示
                    //this.GridPanel3.ColumnModel.SetHidden(10, true);

                    //Added By huyong On 20161023 End
                    this.BtnReason.Hidden = business.SelectShipmentLimitBUCount(RoleModelContext.Current.User.CorpId.Value).Tables[0].Rows[0]["cnt"].ToString() == "0";

                    //Added By Song Yuqi On 20130317 End



                    if (mainData.ProductLineBumId != null && mainData.HospitalHosId != null)
                    {
                        this.AddItemsButton.Disabled = false;

                        //Added By Song Yuqi On 20130317 Begin
                        //if (this.hiddenDealerType.Text == DealerType.T2.ToString() && mainData.Type == "Consignment")
                        //{
                        //    this.btnAddConsignment.Disabled = false;
                        //}
                        //Added By Song Yuqi On 20130317 End
                    }
                    this.GetShipmentDate();
                }

                if (mainData.Status == ShipmentOrderStatus.Complete.ToString())
                {
                    this.SubmitButton.Text = GetLocalResourceObject("UpdateInvoiceInfo").ToString();
                   
                    if (IsDealer && (_context.User.CorpId.Value.ToString() == mainData.DealerDmaId.ToString()))
                    {
                        this.PriceButton.Disabled = false;
                    }

                    //显示更新发票按钮 added by bozhenfei on 20100709
                    //this.SubmitButton.Text = "更新发票";
                    //this.GridPanel2.ColumnModel.SetHidden(10, true);
                    //冲红操作时间限制校验  added by songweiming on 20100617   
                    // 待审核的单据如果没有审核，不能再次点击冲红按钮。
                    if (GetRevokeDate()
                        && !business.GetSubmittedOrder(mainData.Id))
                    {
                        if (mainData.Type != "Hospital" && !string.IsNullOrEmpty(mainData.Type))
                        {
                            if (RoleModelContext.Current.User.CorpType != DealerType.T2.ToString())
                            {
                                this.RevokeButton.Disabled = false;
                            }

                        }
                        else
                        {
                            this.RevokeButton.Disabled = false;
                        }

                    }
                    //完成状态的单据仍然可以提交保存，但保存仅限于发票号码 added by songweiming on 20100617    
                    this.SubmitButton.Disabled = false;
                    this.txtInvoice.ReadOnly = false;
                    this.txtInvoiceTitleWin.ReadOnly = false;
                    this.txtInvoiceDateWin.Disabled = false;
                    this.GridPanel2.ColumnModel.SetEditable(10, false); //单价
                    this.GridPanel2.ColumnModel.SetEditable(12, false); //数量
                    this.GridPanel2.ColumnModel.SetEditable(13, false); //实际用量日期
                    this.GridPanel2.ColumnModel.SetEditable(15, false); //备注
                    this.GridPanel2.ColumnModel.SetEditable(18, false); //短期寄售申请单号
                    this.GridPanel2.ColumnModel.SetEditable(14, false); //二维码
                }
            }
            else
            {
                //Added By Song Yuqi On 20140317 Begin
                if (mainData.Status == ShipmentOrderStatus.Draft.ToString())
                {

                }
                //Added By Song Yuqi On 20140317 End
                //this.GridPanel2.ColumnModel.SetHidden(10, false);
                this.GridPanel2.ColumnModel.SetEditable(14, false); //二维码
            }

            this.Bind_Hospital(this.HospitalWinStore, this.hiddenProductLineId.Text, this.txtShipmentDateWin.SelectedDate);

            //显示窗口
            this.DetailWindow.Show();
        }



        public void GetShipmentDate()
        {

            ShipmentUtil util = new ShipmentUtil();
            CalendarDate cd = util.GetCalendarDate();

            DealerMasters dm = new DealerMasters();
            DataSet ds = dm.GetProductLineByDealer(RoleModelContext.Current.User.CorpId.Value);

            Nullable<DateTime> EffectiveDate = null;
            Nullable<DateTime> ExpirationDate = null;
            int ActiveFlag;
            int IsShare;
            DataTable dt = util.GetContractDate(RoleModelContext.Current.User.CorpId.Value, this.hiddenProductLineId.Text == "" ? ds.Tables[0].Rows[0]["Id"].ToString() : this.hiddenProductLineId.Text);
            if (cd != null)
            {
                int limitNo = Convert.ToInt32(cd.Date1);

                int day = DateTime.Now.Day - 1;

                if (dt.Rows.Count > 0)
                {
                    EffectiveDate = Convert.ToDateTime(dt.Rows[0]["EffectiveDate"].ToString());
                    ExpirationDate = Convert.ToDateTime(dt.Rows[0]["ExpirationDate"].ToString());
                    ActiveFlag = Convert.ToInt32(dt.Rows[0]["ActiveFlag"].ToString());
                    IsShare = Convert.ToInt32(dt.Rows[0]["IsShare"].ToString());
                    if (ActiveFlag > 0)
                    {
                        if (day >= limitNo)
                        {
                            this.txtShipmentDateWin.MinDate = DateTime.Now.AddDays(-day).Date > EffectiveDate.Value ? DateTime.Now.AddDays(-day).Date : EffectiveDate.Value;

                        }
                        else
                        {
                            this.txtShipmentDateWin.MinDate = DateTime.Now.AddDays(-day).AddMonths(-1).Date > EffectiveDate.Value ? DateTime.Now.AddDays(-day).AddMonths(-1).Date : EffectiveDate.Value;

                        }
                        this.txtShipmentDateWin.MaxDate = DateTime.Now.Date > ExpirationDate.Value ? ExpirationDate.Value : DateTime.Now.Date;
                    }
                    else if (ActiveFlag == 0 && IsShare > 0)
                    {
                        if (day >= limitNo)
                        {
                            this.txtShipmentDateWin.MinDate = DateTime.Now.AddDays(-day).Date;

                        }
                        else
                        {
                            this.txtShipmentDateWin.MinDate = DateTime.Now.AddDays(-day).AddMonths(-1).Date;

                        }
                        this.txtShipmentDateWin.MaxDate = DateTime.Now.Date;
                    }
                    else
                    {
                        this.txtShipmentDateWin.MinDate = EffectiveDate.Value;
                        this.txtShipmentDateWin.MaxDate = ExpirationDate.Value;
                    }
                }
                else
                {
                    if (day >= limitNo)
                    {
                        this.txtShipmentDateWin.MinDate = DateTime.Now.AddDays(-day).Date;

                    }
                    else
                    {
                        this.txtShipmentDateWin.MinDate = DateTime.Now.AddDays(-day).AddMonths(-1).Date;

                    }
                    this.txtShipmentDateWin.MaxDate = DateTime.Now.Date;
                }

            }

        }

        public bool GetRevokeDate()
        {
            ShipmentUtil util = new ShipmentUtil();
            CalendarDate cd = util.GetCalendarDate();
            DateTime minDate = DateTime.MinValue;

            if (cd != null)
            {
                int limitNo = Convert.ToInt32(cd.Date1);

                int day = DateTime.Now.Day - 1;
                if (day >= limitNo)
                {
                    minDate = DateTime.Now.AddDays(-day).Date;

                }
                else
                {
                    minDate = DateTime.Now.AddDays(-day).AddMonths(-1).Date;

                }

            }
            if (DateTime.Compare(minDate, this.txtShipmentDateWin.SelectedDate) > 0)
            {
                return false;
            }
            else
            {
                return true;
            }

        }
        public string saveShipmentLot(string jsonData)
        {
            string rtnMsg = "";
            bool result = false;

            //获取json格式的Store信息，然后将json转换成datatable
            DataTable dtShiplot = JsonHelper.JsonToDataTable(jsonData);

            string qty = null;
            string unitprice = null;
            string sphdate = null;
            string remark = null;
            //string cahid = null;
            string qrCode = null;
            string editQrCode = null;
            string lotNbumber = null;
            string adjAction = null;

            ShipmentLot lot = new ShipmentLot();
            InventoryAdjustBLL iaBll = new InventoryAdjustBLL();


            //遍历datatable，获取数据并更新shipmentlot明细信息
            for (int i = 0; i < dtShiplot.Rows.Count; i++)
            {
                lot = business.GetShipmentLotById(new Guid(dtShiplot.Rows[i]["Id"].ToString()));

                qty = dtShiplot.Rows[i]["ShipmentQty"].ToString();
                unitprice = dtShiplot.Rows[i]["UnitPrice"].ToString();
                sphdate = dtShiplot.Rows[i]["ShipmentDate"].ToString();
                remark = dtShiplot.Rows[i]["Remark"].ToString();
                //cahid = dtShiplot.Rows[i]["字段名"].ToString();
                qrCode = dtShiplot.Rows[i]["QRCode"].ToString();
                editQrCode = dtShiplot.Rows[i]["QRCodeEdit"].ToString();
                lotNbumber = dtShiplot.Rows[i]["LotNumber"].ToString();
                adjAction = dtShiplot.Rows[i]["AdjAction"].ToString();

                if (!string.IsNullOrEmpty(qty) && qty.ToUpper() != "NULL")
                {
                    lot.LotShippedQty = string.IsNullOrEmpty(qty) ? 0 : Convert.ToDouble(qty);
                }

                if (!string.IsNullOrEmpty(unitprice) && unitprice.ToUpper() != "NULL")
                {
                    lot.UnitPrice = Convert.ToDecimal(unitprice);
                }

                if (!string.IsNullOrEmpty(sphdate) && sphdate.ToUpper() != "NULL")
                {
                    lot.ShipmentDate = Convert.ToDateTime(Convert.ToDateTime(sphdate.Substring(0,10)).ToString("yyyy-MM-dd"));
                }

                if (!string.IsNullOrEmpty(adjAction) && adjAction.ToUpper() != "NULL")
                {
                    lot.AdjAction = Convert.ToDecimal(adjAction).ToString("0.000000");
                }

                if (!string.IsNullOrEmpty(remark) && remark.ToUpper() != "NULL")
                {
                    lot.Remark = remark;
                }

                //if (IsGuid(cahid))
                //{
                //    lot.CahId = new Guid(cahid);
                //}

                if (qrCode == "NoQR" && !string.IsNullOrEmpty(editQrCode) && editQrCode.ToUpper() != "NULL")
                {

                    if (iaBll.QueryQrCodeIsExist(editQrCode))
                    {
                        lot.QrLotNumber = lotNbumber + "@@" + editQrCode;
                    }
                    else
                    {
                        rtnMsg = "二维码：" + editQrCode + "，在DMS系统中不存在";
                    }
                }

                //保存明细数据
                result = business.SaveItem(lot, 0.00);
                if (!result)
                {
                    if (string.IsNullOrEmpty(rtnMsg))
                    {
                        rtnMsg = "二维码：" + editQrCode + "记录保存出错";
                    }
                    else
                    {
                        rtnMsg = rtnMsg + "记录保存出错";
                    }
                }
            }

            this.DetailStore.DataBind();
            return rtnMsg;
        }


        [AjaxMethod]
        public void SaveDraft(string jsonData)
        {
            //先更新明细信息 shipmentLot
            //DataTable jShiplot = JsonHelper.JsonToDataTable(jsonData);

            //调用方法更新明细数据
            string rtnUpdate = saveShipmentLot(jsonData);
            if (!string.IsNullOrEmpty(rtnUpdate))
            {
                Ext.Msg.Alert(GetLocalResourceObject("SaveDraft.True.Alert.Title").ToString(), rtnUpdate).Show();
            }
            else
            {
                //IShipmentBLL business = new ShipmentBLL();
                //更新字段
                ShipmentHeader mainData = business.GetShipmentHeaderById(new Guid(this.hiddenOrderId.Text));

                if ((business.IsAdminRole()|| this.hiddenIsShipmentUpdate.Value.ToString().Equals("UpdateShipment")) && !string.IsNullOrEmpty(this.cbDealerWin.SelectedItem.Value))
                {
                    mainData.DealerDmaId = new Guid(this.cbDealerWin.SelectedItem.Value);
                }

                if (!string.IsNullOrEmpty(this.cbProductLineWin.SelectedItem.Value))
                {
                    mainData.ProductLineBumId = new Guid(this.cbProductLineWin.SelectedItem.Value);
                }
                if (!string.IsNullOrEmpty(this.cbHospitalWin.SelectedItem.Value))
                {
                    mainData.HospitalHosId = new Guid(this.cbHospitalWin.SelectedItem.Value);
                }
                if (!string.IsNullOrEmpty(this.txtMemoWin.Text))
                {
                    mainData.NoteForPumpSerialNbr = this.txtMemoWin.Text;
                }

                //added by bozhenfei on 20100608 销售时间
                if (this.txtShipmentDateWin.SelectedDate == DateTime.MinValue)
                {
                    mainData.ShipmentDate = null;
                }
                else
                {
                    mainData.ShipmentDate = this.txtShipmentDateWin.SelectedDate;
                }

                if (this.txtInvoiceDateWin.SelectedDate == DateTime.MinValue)
                {
                    mainData.InvoiceDate = null;
                }
                else
                {
                    mainData.InvoiceDate = this.txtInvoiceDateWin.SelectedDate;
                }

                //added by songweiming on 20100617 发票号码
                if (!string.IsNullOrEmpty(this.txtInvoice.Text))
                {
                    mainData.InvoiceNo = this.txtInvoice.Text;
                }

                if (!string.IsNullOrEmpty(this.txtInvoiceTitleWin.Text))
                {
                    mainData.InvoiceTitle = this.txtInvoiceTitleWin.Text;
                }

                if (!string.IsNullOrEmpty(this.txtOfficeWin.Text))
                {
                    mainData.Office = this.txtOfficeWin.Text;
                }


                mainData.IsAuth = this.cbIsAuthWin.Checked;

                bool result = false;

                try
                {
                    mainData.ShipmentUser = new Guid(this._context.User.Id);
                    result = business.SaveDraft(mainData);
                }
                catch (Exception e)
                {
                    throw new Exception(e.Message);
                }

                if (result)
                {
                    Ext.Msg.Alert(GetLocalResourceObject("SaveDraft.True.Alert.Title").ToString(), GetLocalResourceObject("SaveDraft.True.Alert.Body").ToString()).Show();
                }
                else
                {
                    Ext.Msg.Alert(GetLocalResourceObject("SaveDraft.True.Alert.Title").ToString(), GetLocalResourceObject("SaveDraft.False.Alert.Body").ToString()).Show();
                }
            }
        }

        [AjaxMethod]
        public void DeleteDraft()
        {
            //IShipmentBLL business = new ShipmentBLL();

            bool result = false;

            try
            {
                result = business.DeleteDraft(new Guid(this.hiddenOrderId.Text));

                //删除销售调整中间表
                //Added By Song Yuqi On 2016-03-31
                this.DeleteAllAdjust(new Guid(this.hiddenOrderId.Text));
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }

            if (result)
            {
                Ext.Msg.Alert(GetLocalResourceObject("SaveDraft.True.Alert.Title").ToString(), GetLocalResourceObject("DeleteDraft.True.Alert.Body").ToString()).Show();
            }
            else
            {
                Ext.Msg.Alert(GetLocalResourceObject("SaveDraft.True.Alert.Title").ToString(), GetLocalResourceObject("DeleteDraft.False.Alert.Body").ToString()).Show();
            }
        }

        [AjaxMethod]
        public void OnProductLineChange()
        {
            //IShipmentBLL business = new ShipmentBLL();
            try
            {
                //Edited By Song Yuqi On 20140319 Begin
                //类型为二级经销商寄售销售单，删除ShipmentConsignment
                //if (this.hiddenDealerType.Text == DealerType.T2.ToString() && this.hiddenShipmentType.Text == ShipmentOrderType.Consignment.ToString())
                //{
                //    business.DeleteConsignmentItemByHeaderId(new Guid(this.hiddenOrderId.Text));
                //}
                //else
                //{
                //    //类型为二级经销商寄售销售单，删除ShipmentLine和ShipmentLot
                business.DeleteDetail(new Guid(this.hiddenOrderId.Text));
                //}

                //删除销售调整中数据
                this.DeleteAllAdjust(new Guid(this.hiddenOrderId.Text));

                if (!string.IsNullOrEmpty(cbProductLineWin.SelectedItem.Value))
                {
                    this.hiddenProductLineId.Text = cbProductLineWin.SelectedItem.Value;
                }

                if (!business.IsAdminRole()&& !this.hiddenIsShipmentUpdate.Value.ToString().Equals("UpdateShipment"))
                {
                    this.GetShipmentDate();
                }
                //this.Bind_Hospital(this.HospitalWinStore, this.hiddenProductLineId.Text,DateTime.MinValue);
                //产品线变更，清空医院信息
                Store store = HospitalWinStore;
                store.DataSource = new DataTable();
                store.DataBind();
                //Edited By Song Yuqi On 20140319 End
                //如果为ENDO红海判断是否在6个工作日之内 lijie add
                if (!business.IsAdminRole()&& !this.hiddenIsShipmentUpdate.Value.ToString().Equals("UpdateShipment"))
                {
                    SetShipmentData();
                }
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }


        [AjaxMethod]
        public void OnHospitalChange()
        {
            //IShipmentBLL business = new ShipmentBLL();
            try
            {
                //Edited By Song Yuqi On 20140319 Begin
                //类型为二级经销商寄售销售单，删除ShipmentConsignment
                //if (this.hiddenDealerType.Text == DealerType.T2.ToString() && this.hiddenShipmentType.Text == ShipmentOrderType.Consignment.ToString())
                //{
                //    business.DeleteConsignmentItemByHeaderId(new Guid(this.hiddenOrderId.Text));
                //}
                //else
                //{
                //    //类型为二级经销商寄售销售单，删除ShipmentLine和ShipmentLot
                business.DeleteDetail(new Guid(this.hiddenOrderId.Text));
                //}
                //Edited By Song Yuqi On 20140319 End

                //删除销售调整中数据
                this.DeleteAllAdjust(new Guid(this.hiddenOrderId.Text));
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        [AjaxMethod]
        public void OnHospitalChangeAuth()
        {
            //IShipmentBLL business = new ShipmentBLL();
            try
            {
                Hashtable obj = new Hashtable();
                obj.Add("ShipmentId", this.hiddenOrderId.Text);
                obj.Add("ShipmentType", this.hiddenShipmentType.Text);
                obj.Add("DealerId", this.hiddenDealerId.Text);
                obj.Add("ProductLineId", this.hiddenProductLineId.Text);
                obj.Add("HospitalId", this.cbHospitalWin.SelectedItem.Value.ToString());
                obj.Add("ShipmentDate", this.hiddenShipmentDate.Text);
                string massage = business.DeleteShipmentNotAuthCfn(obj);
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        [AjaxMethod]
        public void DeleteItem()
        {
            //IShipmentBLL business = new ShipmentBLL();
            RowSelectionModel sm = this.GridPanel2.SelectionModel.Primary as RowSelectionModel;

            bool result = false;

            try
            {
                result = business.DeleteItem(new Guid(sm.SelectedRow.RecordID));
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }

            if (result)
            {
                this.DetailStore.DataBind();
            }
            else
            {
                Ext.Msg.Alert(GetLocalResourceObject("SaveDraft.True.Alert.Title").ToString(), GetLocalResourceObject("DeleteItem.Alert.Body").ToString()).Show();
            }
        }

        //[AjaxMethod]
        //public void DeleteConsignmentItem()
        //{
        //    //IShipmentBLL business = new ShipmentBLL();
        //    RowSelectionModel sm = this.GridPanel3.SelectionModel.Primary as RowSelectionModel;

        //    bool result = false;

        //    try
        //    {
        //        result = business.DeleteConsignmentItem(new Guid(sm.SelectedRow.RecordID));
        //    }
        //    catch (Exception e)
        //    {
        //        throw new Exception(e.Message);
        //    }

        //    if (result)
        //    {
        //        this.ConsignmentDetailStore.DataBind();
        //    }
        //    else
        //    {
        //        Ext.Msg.Alert(GetLocalResourceObject("SaveDraft.True.Alert.Title").ToString(), GetLocalResourceObject("DeleteItem.Alert.Body").ToString()).Show();
        //    }
        //}

        [AjaxMethod]
        public void EditItem(String LotId)
        {
            //this.ShipmentEditor1.Show(new Guid(LotId));
        }

        //[AjaxMethod]
        //public void SaveItem(string qty, string unitprice, string sphDate, string remark, string cahid, string QrCode, string EditQrCode, string LotNbumber, string adjAction)
        //{
        //    string messing = "";
        //    bool bl = true;
        //    bool result = false; ;
        //    ShipmentLot lot = business.GetShipmentLotById(new Guid(this.hiddenCurrentEditShipmentId.Text));
        //    lot.LotShippedQty = string.IsNullOrEmpty(qty) ? 0 : Convert.ToDouble(qty);
        //    //lot.UnitPrice = string.IsNullOrEmpty(unitprice) ? 0 : Convert.ToDecimal(unitprice);
        //    if (!string.IsNullOrEmpty(unitprice))
        //    {
        //        lot.UnitPrice = Convert.ToDecimal(unitprice);
        //    }
        //    lot.ShipmentDate = string.IsNullOrEmpty(sphDate) ? lot.ShipmentDate : Convert.ToDateTime(Convert.ToDateTime(sphDate).ToString("yyyy-MM-dd"));

        //    if (!string.IsNullOrEmpty(adjAction))
        //    {
        //        lot.AdjAction = Convert.ToDecimal(adjAction).ToString("0.000000");
        //    }

        //    lot.Remark = remark;
        //    if (IsGuid(cahid))
        //    {
        //        lot.CahId = new Guid(cahid);
        //    }
        //    if (QrCode == "NoQR" && !string.IsNullOrEmpty(EditQrCode))
        //    {
        //        InventoryAdjustBLL bll = new InventoryAdjustBLL();
        //        if (bll.QueryQrCodeIsExist(EditQrCode))
        //        {
        //            lot.QrLotNumber = LotNbumber + "@@" + EditQrCode;
        //        }
        //        else
        //        {
        //            bl = false;
        //            messing = "该二维码不存在";
        //        }
        //    }
        //    if (bl)
        //    {
        //        double price = string.IsNullOrEmpty(unitprice) ? 0 : Convert.ToDouble(unitprice);
        //        result = business.SaveItem(lot, price);
        //        if (!result)
        //        {
        //            Ext.Msg.Alert(GetLocalResourceObject("SaveDraft.True.Alert.Title").ToString(), GetLocalResourceObject("SaveItem.Alert.Body").ToString()).Show();
        //        }
        //        this.DetailStore.DataBind();
        //    }

        //    else
        //    {
        //        Ext.Msg.Alert(GetLocalResourceObject("SaveDraft.True.Alert.Title").ToString(), "该二维码不存在").Show();
        //    }
        //}

        //[AjaxMethod]
        //public void SaveConsignmentItem(string qty, string unitprice, string sphDate, string remark)
        //{
        //    ShipmentConsignment sc = business.GetShipmentConsignmentById(new Guid(this.hiddenCurrentEditShipmentId.Text));
        //    sc.ShippedQty = string.IsNullOrEmpty(qty) ? 0 : Convert.ToDecimal(qty);
        //    sc.UnitPrice = string.IsNullOrEmpty(unitprice) ? 0 : Convert.ToDecimal(unitprice);
        //    sc.ShipmentDate = string.IsNullOrEmpty(sphDate) ? sc.ShipmentDate : Convert.ToDateTime(sphDate);
        //    sc.Remark = remark;

        //    bool result = business.SaveConsignmentItem(sc);

        //    if (result)
        //    {
        //        this.ConsignmentDetailStore.DataBind();
        //    }
        //    else
        //    {
        //        Ext.Msg.Alert(GetLocalResourceObject("SaveDraft.True.Alert.Title").ToString(), GetLocalResourceObject("SaveItem.Alert.Body").ToString()).Show();
        //    }
        //}
        [AjaxMethod]
        public void SaveItemPrice(string unitprice)
        {
            bool result = false; ;
            ShipmentLot lot = business.GetShipmentLotById(new Guid(this.hidPriceDetailId.Text));
            if (!string.IsNullOrEmpty(unitprice))
            {
                lot.UnitPrice = Convert.ToDecimal(unitprice);
            }
           
            double price = string.IsNullOrEmpty(unitprice) ? 0 : Convert.ToDouble(unitprice);
            result = business.SaveItem(lot, price);
            if (!result)
            {
                Ext.Msg.Alert(GetLocalResourceObject("SaveDraft.True.Alert.Title").ToString(), GetLocalResourceObject("SaveItem.Alert.Body").ToString()).Show();
            }
            else
            {
                //记录修改log
                business.SaveUpdateLog(lot);
            }

            this.UpdateOrderPriceStore.DataBind();
        }

        [AjaxMethod]
        public Boolean OperationDateCheck()
        {
            ShipmentHeader mainData = business.GetShipmentHeaderById(new Guid(this.hiddenOrderId.Text));
            //判断当前状态是不是为草稿状态，如果为草稿状态，则可以更新
            if (mainData.Status == ShipmentOrderStatus.Draft.ToString())
            {
                return true;
            }
            else if (mainData.Status == ShipmentOrderStatus.Complete.ToString())
            {
                //判断当前状态是不是已提交状态，如果是已提交状态，则校验时间
                Boolean dateCheck = new ShipmentUtil().GetDateConstraints("OperationDate", mainData.ShipmentDate.Value, mainData.ProductLineBumId.Value);
                return dateCheck;
            }
            else
            {
                //其他状态都不可编辑
                return false;
            }
        }

        public bool ValidateQrUnique(DataTable dt, DataRow row, string type)
        {
            bool result = false;

            DataTable newdt = new DataTable();
            newdt = dt.Clone();
            DataRow[] dr;
            if (type == "EditQrCode")
            {
                dr = dt.Select("EditQrCode='" + row["EditQrCode"].ToString() + "'");
                if (row["EditQrCode"] != null && row["EditQrCode"].ToString() != "" && dr.Count() > 1)
                {
                    result = true;
                }
            }
            else if (type == "QRCode")
            {
                dr = dt.Select("QRCode='" + row["EditQrCode"].ToString() + "'");
                if (row["QRCode"].ToString().ToUpper() == "NOQR" && row["EditQrCode"] != null
                    && row["EditQrCode"].ToString() != "" && dr.Count() > 0)
                {
                    result = true;
                }
            }

            return result;
        }

        [AjaxMethod]
        public string DoSubmit()
        {
            //IShipmentBLL business = new ShipmentBLL();
            //如果是草稿，则提交操作需要先将错误的数据删除
            if (this.txtOrderStatusWin.Text == "草稿")
            {
                Hashtable obj = new Hashtable();
                obj.Add("ShipmentId", this.hiddenOrderId.Text);
                int delRowCnt = business.DeleteErrorShipmentLot(obj);
            }

            Boolean dateCheck = true;
            bool ShiplotCheckde = true;
            string Messing = string.Empty;
            DataSet ds = business.SelectShipmentLotByChecked(this.hiddenOrderId.Text);
            DataSet lotDs = business.SelectShipmentdistictLotid(this.hiddenOrderId.Text);
            if (this.txtOrderStatusWin.Text == "草稿")
            {
                foreach (DataRow row in ds.Tables[0].Rows)
                {
                    //非管理员（经销商）提交的销售需要校验NoQR数据
                    if (!IsAdmin && row["QrCode"].ToString() == "NoQR")
                    {
                        if (string.IsNullOrEmpty(row["EditQrCode"].ToString()) && row["Wtype"].ToString() != "Normal" && row["Wtype"].ToString() != "Frozen" && (row["Wcode"].ToString().ToUpper().IndexOf("NOQR") < 0))
                        {
                            ShiplotCheckde = false;
                            Messing = Messing + "批次号" + row["LotNumber"].ToString() + "的二维码填写错误<BR/>";
                        }
                        else if (row["EditQrCode"] != null && row["EditQrCode"].ToString() != ""
                                && row["ShipmentQty"] != null && decimal.Parse(row["ShipmentQty"].ToString()) > 1)
                        {
                            ShiplotCheckde = false;
                            Messing = Messing + "批次号" + row["LotNumber"].ToString() + "的二维码产品数量不得大于一<BR/>";
                        }
                        else if (ValidateQrUnique(ds.Tables[0], row, "EditQrCode"))
                        {
                            ShiplotCheckde = false;
                            Messing = Messing + "批次号" + row["LotNumber"].ToString() + "的二维码" + row["EditQrCode"].ToString() + "出现多次<BR/>";
                        }
                        else if (ValidateQrUnique(ds.Tables[0], row, "QRCode"))
                        {
                            ShiplotCheckde = false;
                            Messing = Messing + "批次号" + row["LotNumber"].ToString() + "的二维码" + row["EditQrCode"].ToString() + "已被使用<BR/>";
                        }
                    }
                }
                foreach (DataRow row in lotDs.Tables[0].Rows)
                {
                    DataSet qtyDs = business.SelectShipmentLotQty(row["SLT_LOT_ID"].ToString(), this.hiddenOrderId.Text);
                    if (float.Parse((qtyDs.Tables[0].Rows[0]["TotalQty"].ToString())) < float.Parse((qtyDs.Tables[0].Rows[0]["ShipmentQty"].ToString())))
                    {
                        ShiplotCheckde = false;
                        Messing = Messing + "批次号" + qtyDs.Tables[0].Rows[0]["LotNumber"].ToString() + "的库存量小于销售数量<BR/>";
                    }
                }

                //蓝海二级经销商，并且产品线是ENDO和IC,需要上传附件后才能提交
                //if (IsDealer && this._context.User.CorpType == DealerType.T2.ToString())
                //{
                //    DataSet dsAtt = attachBll.GetAttachmentByMainId(new Guid(this.hiddenOrderId.Text), AttachmentType.ShipmentToHospital);
                //    if (dsAtt == null || dsAtt.Tables[0].Rows.Count == 0)
                //    {
                //        if (business.CheckNeedUploadAttachment(this._context.User.CorpId.Value, new Guid(cbProductLineWin.SelectedItem.Value)))
                //    {
                //            ShiplotCheckde = false;
                //            Messing = Messing + "请上传附件后再提交<BR/>";
                //        }
                //    }
                //}
            }



            if (ShiplotCheckde)
            {
                ShipmentHeader mainData = business.GetShipmentHeaderById(new Guid(this.hiddenOrderId.Text));

                //首先判断当前单据的状态，如果是完成状态，则只保存发票号码，草稿状态则保存整张单据
                if (mainData.Status == ShipmentOrderStatus.Complete.ToString())
                {
                    try
                    {
                        mainData.InvoiceNo = this.txtInvoice.Text;
                        if (this.txtInvoiceDateWin.SelectedDate != DateTime.MinValue)
                        {
                            mainData.InvoiceDate = this.txtInvoiceDateWin.SelectedDate;
                        }
                        else
                        {
                            mainData.InvoiceDate = null;
                        }
                        mainData.InvoiceTitle = this.txtInvoiceTitleWin.Text;
                        mainData.UpdateDate = DateTime.Now;// added by songweiming on 20100628
                        if (!string.IsNullOrEmpty(mainData.InvoiceNo) && mainData.InvoiceFirstDate == null)
                        {
                            mainData.InvoiceFirstDate = DateTime.Now;
                        }
                        business.UpdateMainDataInvoiceNo(mainData);
                        Ext.Msg.Alert(GetLocalResourceObject("SaveDraft.True.Alert.Title").ToString(), GetLocalResourceObject("DoSubmit.Alert.Body").ToString()).Show();
                    }
                    catch (Exception e)
                    {
                        throw new Exception(e.Message);
                    }
                    return "Done";
                }
                else
                {

                    //更新字段
                    if ((business.IsAdminRole()||this.hiddenIsShipmentUpdate.Value.ToString().Equals("UpdateShipment") )&& !string.IsNullOrEmpty(this.cbDealerWin.SelectedItem.Value))
                    {
                        mainData.DealerDmaId = new Guid(this.cbDealerWin.SelectedItem.Value);
                    }
                    if (!string.IsNullOrEmpty(this.cbProductLineWin.SelectedItem.Value))
                    {
                        mainData.ProductLineBumId = new Guid(this.cbProductLineWin.SelectedItem.Value);

                    }
                    if (!string.IsNullOrEmpty(this.cbHospitalWin.SelectedItem.Value))
                    {
                        mainData.HospitalHosId = new Guid(this.cbHospitalWin.SelectedItem.Value);
                    }
                    if (!string.IsNullOrEmpty(this.txtMemoWin.Text))
                    {
                        mainData.NoteForPumpSerialNbr = this.txtMemoWin.Text;
                    }
                    //added by songyuqi on 20100707 发票号码
                    if (!string.IsNullOrEmpty(this.txtInvoice.Text))
                    {
                        mainData.InvoiceNo = this.txtInvoice.Text;
                    }

                    //added by hxw
                    if (!string.IsNullOrEmpty(this.txtInvoiceTitleWin.Text))
                    {
                        mainData.InvoiceTitle = this.txtInvoiceTitleWin.Text;
                    }

                    if (!string.IsNullOrEmpty(this.txtOfficeWin.Text))
                    {
                        mainData.Office = this.txtOfficeWin.Text;
                    }

                    if (this.txtInvoiceDateWin.SelectedDate != DateTime.MinValue)
                    {
                        mainData.InvoiceDate = this.txtInvoiceDateWin.SelectedDate;
                    }
                    mainData.IsAuth = this.cbIsAuthWin.Checked;

                    //added by bozhenfei on 20100608 销售时间
                    if (this.txtShipmentDateWin.SelectedDate != DateTime.MinValue)
                    {
                        mainData.ShipmentDate = this.txtShipmentDateWin.SelectedDate;
                        dateCheck = new ShipmentUtil().GetDateConstraints("ShipmentDate", mainData.ShipmentDate.Value, mainData.ProductLineBumId.Value);

                        string result = "";
                        this.txtShipmentDateWin.MinDate = DateTime.Now.AddDays(1);

                        if (dateCheck || business.IsAdminRole()|| this.hiddenIsShipmentUpdate.Value.ToString().Equals("UpdateShipment"))
                        {
                            try
                            {
                                mainData.ShipmentUser = new Guid(this._context.User.Id);
                                result = business.Submit(mainData,this.hiddenIsShipmentUpdate.Value.ToString());
                                //二级经销商寄售提交自动生成补货单
                                string RtnVal = string.Empty;
                                string RtnMsg = string.Empty;
                                string ShipmentType = string.Empty;
                                business.ConsignmentForOrder(mainData, ShipmentType, out RtnVal, out RtnMsg);
                            }
                            catch (Exception e)
                            {
                                throw new Exception(e.Message);
                            }

                            if (result == "Success")
                            {
                                Ext.Msg.Alert(GetLocalResourceObject("SaveDraft.True.Alert.Title").ToString(), GetLocalResourceObject("DoSubmit.dateCheck.True.Alert.Body").ToString()).Show();
                            }
                            else
                            {
                                Ext.Msg.Alert(GetLocalResourceObject("SaveDraft.True.Alert.Title").ToString(), result).Show();
                            }
                        }
                        else
                        {
                            Ext.Msg.Alert(GetLocalResourceObject("SaveDraft.True.Alert.Title").ToString(), GetLocalResourceObject("DoSubmit.Alert.Body1").ToString()).Show();
                            return "DateError";
                        }
                    }
                    else
                    {
                        Ext.Msg.Alert(GetLocalResourceObject("SaveDraft.True.Alert.Title").ToString(), GetLocalResourceObject("DoSubmit.Alert.Body2").ToString()).Show();
                        return "DateError";
                    }

                    return "Done";
                }
            }
            else
            {
                Ext.Msg.Alert(GetLocalResourceObject("SaveDraft.True.Alert.Title").ToString(), Messing).Show();
                return "DateError";
            }
        }


        /// <summary>
        /// 冲红操作 （LP与T1冲红自己的寄售单与借货单后变成待审核状态，HQ审核通过，恢复库存。）
        /// </summary>
        [AjaxMethod]
        public void DoRevoke()
        {
            this.RevokeButton.Disabled = true;
            bool result = false;
            string orderStatus = string.Empty;

            Guid id = new Guid(this.hiddenOrderId.Text);
            ShipmentHeader mainData = business.GetShipmentHeaderById(id);

            if (mainData.Type != "Hospital" && !string.IsNullOrEmpty(mainData.Type))
            {
                if (RoleModelContext.Current.User.CorpType == DealerType.T1.ToString() ||
                       RoleModelContext.Current.User.CorpType == DealerType.LP.ToString() ||
                       RoleModelContext.Current.User.CorpType == DealerType.LS.ToString())
                {
                    orderStatus = "ToApprove";
                }
            }
            //Guid id = new Guid(this.hiddenOrderId.Text);
            //ShipmentHeader mainData = business.GetShipmentHeaderById(id);

            //if (mainData.Type != "Hospital" && !string.IsNullOrEmpty(mainData.Type))
            //{

            //    if (RoleModelContext.Current.User.CorpType == DealerType.T1.ToString() ||
            //        RoleModelContext.Current.User.CorpType == DealerType.LP.ToString())
            //    {
            //        if (mainData.Status == ShipmentOrderStatus.Complete.ToString())
            //        {
            //            //将状态改为待审批
            //            //mainData.Status = ShipmentOrderStatus.Submitted.ToString();
            //            mainData.UpdateDate = DateTime.Now;
            //            result = business.Update(mainData);
            //        }
            //    }

            //}

            try
            {
                result = business.Revoke(new Guid(this.hiddenOrderId.Text), orderStatus);
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }


            if (result)
            {
                Ext.Msg.Alert(GetLocalResourceObject("SaveDraft.True.Alert.Title").ToString(), GetLocalResourceObject("DoRevoke.True.Alert.Body").ToString()).Show();
            }
            else
            {
                Ext.Msg.Alert(GetLocalResourceObject("SaveDraft.True.Alert.Title").ToString(), GetLocalResourceObject("DoRevoke.False.Alert.Bodys").ToString()).Show();
            }
        }

        [AjaxMethod]
        public void DoConfirm()
        {
            business.DoConfirm();
        }

        /// <summary>
        /// 系统管理员增补销售单
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void ShowDetailsUpdate(object sender, AjaxEventArgs e)
        {
            this.SubmitButton.Text = GetLocalResourceObject("UpdateInvoiceInfo").ToString();

            //Renderer r = new Renderer();
            //r.Fn = "SetCellCssEditable";
            //this.GridPanel2.ColumnModel.SetRenderer(9, r);
            //this.GridPanel2.ColumnModel.SetRenderer(10, r);
            ////初始化detail窗口,因为只有dealer才可以新增，因此打开页面默认选中session中的经销商
            this.hiddenOrderId.Text = string.Empty;
            this.hiddenDealerId.Text = string.Empty;
            this.hiddenProductLineId.Text = string.Empty;
            this.hiddenHospitalId.Text = string.Empty;


            this.txtOrderNumberWin.Text = string.Empty;
            this.txtShipmentDateWin.Clear();
            this.txtOrderStatusWin.Text = string.Empty;
            this.txtMemoWin.Text = string.Empty;
            //this.txtTotalAmount.Text = string.Empty;
            //this.txtTotalQty.Text = string.Empty;
            this.txtInvoiceDateWin.Clear();
            this.txtOfficeWin.Text = string.Empty;
            this.txtInvoiceTitleWin.Text = string.Empty;
            this.txtShipmentOrderTypeWin.Clear();
            this.cbIsAuthWin.Checked = false;
            this.hiddenCurrentEditShipmentId.Text = string.Empty;
            this.hiddenIsEditting.Text = string.Empty;

            //this.txtShipmentDateWin.MaxDate = DateTime.Now.Date;
            this.txtShipmentDateWin.MinDate = DateTime.MinValue;
            this.txtInvoice.Text = string.Empty;

            this.TabPanel1.ActiveTabIndex = 0;
            this.TabSearch.Disabled = false;
            //this.TabConsignment.Disabled = true;

            this.hiddenDealerType.Text = string.Empty;

            Guid id = new Guid(e.ExtraParams["OrderId"].ToString());

            ShipmentHeader mainData = null;

            //若id为空，说明为新增，则生成新的id，并新增一条记录
            if (id == Guid.Empty)
            {
                id = Guid.NewGuid();
                this.hiddenOrderId.Text = id.ToString();
                mainData = new ShipmentHeader();
                mainData.Id = id;
                //mainData.DealerDmaId = RoleModelContext.Current.User.CorpId.Value;
                if (!business.IsAdminRole())
                {
                    mainData.DealerDmaId = RoleModelContext.Current.User.CorpId.Value;
                    this.hiddenDealerId.Text = RoleModelContext.Current.User.CorpId.Value.ToString();
                }
                else
                {
                    mainData.DealerDmaId = new Guid("FB62D945-C9D7-4B0F-8D26-4672D2C728B7");
                }
                //new Guid(RoleModelContext.Current.User.Id);
                mainData.Status = ShipmentOrderStatus.Draft.ToString();
                mainData.UpdateDate = DateTime.Now;// added by songweiming on 20100628
                mainData.Type = e.ExtraParams["Type"].ToString(); //added by hxw
                mainData.AdjType = this.hiddenIsShipmentUpdate.Value.ToString();
                business.InsertShipmentHeader(mainData);

                //New 经销商为操作人的Corp
                // this.hiddenDealerType.Text = _context.User.CorpType; // Added By Song Yuqi On 20140317
                this.hiddenShipmentType.Text = mainData.Type;
            }
            //根据ID查询主表数据，并初始化页面
            mainData = business.GetShipmentHeaderById(id);
            this.hiddenOrderId.Text = mainData.Id.ToString();

            if (mainData.DealerDmaId != null)
            {
                this.cbDealerWin.SelectedItem.Value = mainData.DealerDmaId.ToString();
                this.hiddenDealerId.Text = mainData.DealerDmaId.ToString();
            }


            //Added By Song Yuqi On 20140317 Begin
            //获得明细单中经销商的类型
            //DealerMaster dma = new DealerMasters().GetDealerMaster(new Guid(this.hiddenDealerId.Text));
            //this.hiddenDealerType.Text = dma.DealerType;

            if (mainData.ProductLineBumId != null)
            {
                this.hiddenProductLineId.Text = mainData.ProductLineBumId.Value.ToString();
            }
            if (mainData.HospitalHosId != null)
            {
                this.hiddenHospitalId.Text = mainData.HospitalHosId.Value.ToString();
            }
            this.txtOrderNumberWin.Text = mainData.ShipmentNbr;
            if (mainData.ShipmentDate != null)
            {
                this.txtShipmentDateWin.SelectedDate = mainData.ShipmentDate.Value;
                this.hiddenShipmentDate.Text = mainData.ShipmentDate.Value.ToString("yyyy-MM-dd");
            }

            if (mainData.InvoiceDate != null)
            {
                this.txtInvoiceDateWin.SelectedDate = mainData.InvoiceDate.Value;

            }
            if (mainData.InvoiceNo != null)
            {
                this.txtInvoice.Text = mainData.InvoiceNo;
            }

            if (mainData.Office != null)
            {
                this.txtOfficeWin.Text = mainData.Office;
            }
            if (mainData.InvoiceTitle != null)
            {
                this.txtInvoiceTitleWin.Text = mainData.InvoiceTitle;
            }

            if (mainData.IsAuth != null)
            {
                this.cbIsAuthWin.Checked = mainData.IsAuth.Value;
            }
            if (mainData.Type != null)
            {
                this.hiddenShipmentType.Text = mainData.Type;
            }

            this.Bind_Hospital(this.HospitalWinStore, this.hiddenProductLineId.Text, this.txtShipmentDateWin.SelectedDate);

            this.txtOrderStatusWin.Text = DictionaryCacheHelper.GetDictionaryNameById(SR.Consts_ShipmentOrder_Status, mainData.Status);
            this.txtMemoWin.Text = mainData.NoteForPumpSerialNbr;
            if (mainData.Type != null)
                this.txtShipmentOrderTypeWin.Text = DictionaryCacheHelper.GetDictionaryNameById(SR.Consts_ShipmentOrder_Type, mainData.Type);
           
            this.GridPanel2.ColumnModel.SetEditable(10, false); //单价
            this.GridPanel2.ColumnModel.SetHidden(11, true); //采购价
            this.GridPanel2.ColumnModel.SetEditable(11, false); //采购价
            this.GridPanel2.ColumnModel.SetEditable(12, false); //数量
            this.GridPanel2.ColumnModel.SetEditable(13, false); //实际用量日期
            this.GridPanel2.ColumnModel.SetEditable(14, false); //二维码
            this.GridPanel2.ColumnModel.SetHidden(17, true);    //
            this.GridPanel2.ColumnModel.SetHidden(18, true);    //短期寄售申请单号
            this.GridPanel2.ColumnModel.SetHidden(19, true);    //删除

            this.cbProductLineWin.Disabled = true;
            this.cbHospitalWin.Disabled = true;
            this.cbDealerWin.Disabled = true;
            this.txtMemoWin.ReadOnly = true;
            this.txtOfficeWin.ReadOnly = true;
            this.txtInvoiceTitleWin.ReadOnly = true;
            this.txtInvoiceDateWin.Disabled = true;
            this.txtInvoice.ReadOnly = true;
            this.DraftButton.Disabled = true;
            this.DeleteButton.Disabled = true;
            this.SubmitButton.Disabled = true;
            this.RevokeButton.Disabled = true;
            this.AddItemsButton.Disabled = true;
            this.PriceButton.Disabled = true;

            //Added By Song Yuqi On 2016-03-29 Being
            this.GridPanel2.ColumnModel.SetHidden(19, true);    //删除

            //this.btnShowAdminShipment.Disabled = true;
            this.btnAddForAdmin.Disabled = true;

            this.gpHistoryShipment.ColumnModel.SetEditable(13, false);
            this.gpHistoryShipment.ColumnModel.SetHidden(14, true);
            this.gpInventory.ColumnModel.SetEditable(9, false);
            this.gpInventory.ColumnModel.SetEditable(10, false);
            this.gpInventory.ColumnModel.SetHidden(11, true);

            this.btnAddInventory.Disabled = true;
            this.btnAddHistoryShipment.Disabled = true;

            //Added By Song Yuqi On 2016-03-29 End

            //this.orderTypeWin.Disabled = true;
            this.txtShipmentDateWin.Disabled = true;
            this.cbIsAuthWin.Disabled = true;

            //Edit By SongWeiming on 2015-08-25 附件下载列不显示
            this.gpAttachment.ColumnModel.SetHidden(7, true);


            if (mainData.Status == ShipmentOrderStatus.Draft.ToString())
            {
                this.SubmitButton.Text = GetLocalResourceObject("DetailWindow.SubmitButton.Text").ToString();
                this.cbProductLineWin.Disabled = false;
                this.cbHospitalWin.Disabled = false;
                this.cbDealerWin.Disabled = false;
               
                this.txtMemoWin.ReadOnly = false;
                this.txtInvoiceTitleWin.ReadOnly = false;
                this.txtOfficeWin.ReadOnly = false;
                this.txtInvoice.ReadOnly = false;
                this.txtInvoiceDateWin.Disabled = false;
                this.DraftButton.Disabled = false;
                this.DeleteButton.Disabled = false;
                this.SubmitButton.Disabled = false;
                this.PriceButton.Disabled = true;
                //this.orderTypeWin.Disabled = false;
                this.txtShipmentDateWin.Disabled = false;
                //this.GridPanel2.ColumnModel.SetEditable(9, true);
                this.GridPanel2.ColumnModel.SetEditable(10, true);  //单价

                //只有寄售销售单才需要管理员填写采购价
                if (mainData.Type == ShipmentOrderType.Consignment.ToString())
                {
                    this.GridPanel2.ColumnModel.SetHidden(11, false); //采购价
                    this.GridPanel2.ColumnModel.SetEditable(11, true);  //采购价    
                }

                this.GridPanel2.ColumnModel.SetEditable(12, true);  //数量
                this.GridPanel2.ColumnModel.SetEditable(13, true);  //实际用量日期
                //this.GridPanel2.ColumnModel.SetEditable(13, true);
                this.GridPanel2.ColumnModel.SetHidden(16, false);
                this.GridPanel2.ColumnModel.SetHidden(19, false); //删除

                //Edit By SongWeiming on 2015-08-25 附件下载列不显示
                this.gpAttachment.ColumnModel.SetHidden(7, false);

                this.cbIsAuthWin.Disabled = false;
                // this.RevokeButton.Visible = false;

                if (mainData.ProductLineBumId != null && mainData.HospitalHosId != null)
                {
                    this.AddItemsButton.Disabled = false;
                    //this.btnShowAdminShipment.Disabled = false;//Added By Song Yuqi On 2016-03-29
                }

                this.btnAddInventory.Disabled = false;
                this.btnAddHistoryShipment.Disabled = false;
                this.btnAddForAdmin.Disabled = false;

                this.gpHistoryShipment.ColumnModel.SetEditable(13, true);
                this.gpHistoryShipment.ColumnModel.SetHidden(14, false);
                this.gpInventory.ColumnModel.SetEditable(9, true);
                this.gpInventory.ColumnModel.SetEditable(10, true);
                this.gpInventory.ColumnModel.SetHidden(11, false);

            }

            if (mainData.Status == ShipmentOrderStatus.Complete.ToString() && business.SelectAdminRoleAction(mainData.Id))
            {
                this.SubmitButton.Text = GetLocalResourceObject("UpdateInvoiceInfo").ToString();
                this.SubmitButton.Disabled = false;
                this.txtInvoice.ReadOnly = false;
                this.txtInvoiceTitleWin.ReadOnly = false;
                this.txtInvoiceDateWin.Disabled = false;
                this.PriceButton.Disabled = true;

                //this.GridPanel2.ColumnModel.SetEditable(10, false);
                //this.GridPanel2.ColumnModel.SetEditable(11, false);
                //this.GridPanel2.ColumnModel.SetEditable(12, false);
                this.GridPanel2.ColumnModel.SetEditable(15, false); //备注
                
            }
            if (mainData.Status == ShipmentOrderStatus.Complete.ToString() && IsDealer && (_context.User.CorpId.Value.ToString()== mainData.DealerDmaId.ToString()))
            {
                this.PriceButton.Disabled = true;
            }
            if (!this.IsAdmin)
            {
                this.dtShipmentDateForAdjust.Disabled = true;
            }

                //显示窗口
                this.DetailWindow.Show();
        }

        [AjaxMethod]
        public void ChangeShipmentDate()
        {
            //如果更改了用量日期，不能将hiddenHospitalId置为空，应该置为EmptyGuid，避免重新选择医院时，认为是第一次选择医院而没有删除列表中已选择的产品
            //this.hiddenHospitalId.Text = string.Empty;

            //重新绑定医院下拉列表
            Hashtable param = new Hashtable();

            param.Add("DealerId", this.hiddenDealerId.Text);
            //param.Add("DealerId", cbDealerWin.SelectedItem.Value);
            param.Add("ProductLine", this.hiddenProductLineId.Text);
            param.Add("ShipmentDate", this.txtShipmentDateWin.SelectedDate.ToString("yyyy-MM-dd"));

            DealerMasters dm = new DealerMasters();
            DataSet ds = dm.SelectHospitalForDealerByShipmentDate(param);

            Store store = HospitalWinStore;
            store.DataSource = ds;
            store.DataBind();

            this.hiddenShipmentDate.Text = this.txtShipmentDateWin.SelectedDate.ToString("yyyy-MM-dd");

        }

        [AjaxMethod]
        public void DeleteAttachment(string id, string fileName)
        {
            try
            {
                attachBll.DelAttachment(new Guid(id));
                string uploadFile = Server.MapPath("..\\..\\Upload\\UploadFile\\ShipmentAttachment");
                File.Delete(uploadFile + "\\" + fileName);

            }
            catch (Exception ex)
            {
                Ext.Msg.Alert("Error", "删除附件失败，请联系DMS技术支持").Show();
            }
        }

        [AjaxMethod]
        public void InitBtnAddAttach()
        {
            try
            {
                ShipmentHeader mainData = business.GetShipmentHeaderById(new Guid(this.hiddenOrderId.Text));
                //判断当前状态是不是为草稿状态，如果为草稿状态，则可以更新
                if (IsDealer)
                {
                    if (this.TabPanel1.ActiveTabIndex == 3)
                    {
                        this.btnAddAttach.Disabled = false;
                    }
                }
                else if (mainData.Status == ShipmentOrderStatus.Draft.ToString())
                {
                    if (this.TabPanel1.ActiveTabIndex == 3)
                    {
                        this.btnAddAttach.Disabled = false;
                    }
                }
                else
                {
                    if (this.TabPanel1.ActiveTabIndex == 3)
                    {
                        this.btnAddAttach.Disabled = true;
                    }
                }
            }
            catch (Exception ex)
            {


            }
            finally
            {

            }
        }

        [AjaxMethod]
        public void CheckSubmit(string jsonData)
        {
            string rtnUpdate = saveShipmentLot(jsonData);
            if (!string.IsNullOrEmpty(rtnUpdate))
            {
                Ext.Msg.Alert(GetLocalResourceObject("SaveDraft.True.Alert.Title").ToString(), rtnUpdate).Show();
            }

            string rtnVal = string.Empty;
            string rtnMsg = string.Empty;

            Guid sphId = new Guid(this.hiddenOrderId.Text);

            string dealerId = string.Empty;

            if (this.cbDealerWin.SelectedItem != null && !string.IsNullOrEmpty(this.cbDealerWin.SelectedItem.Value))
            {
                dealerId = this.cbDealerWin.SelectedItem.Value;
            }
            else
            {
                dealerId = this.hiddenDealerId.Text;
            }

            bool result = _business.CheckSubmit(sphId
                                            , this.hiddenShipmentDate.Text
                                            , new Guid(this._context.User.Id)
                                            , new Guid(dealerId)
                                            , new Guid(this.cbProductLineWin.SelectedItem.Value)
                                            , new Guid(this.cbHospitalWin.SelectedItem.Value)
                                            , out rtnVal
                                            , out rtnMsg);

            this.hidRtnVal.Text = rtnVal;
            this.hidRtnMsg.Text = rtnMsg;
            //this.hidRtnMsg.Text = rtnMsg.Replace("$$", "");
            if (!rtnVal.Equals("Error"))
            {
                this.CheckSubmitResultWindows.Show();
            } 
            
        }

        #region 短期寄售产品销售

        protected void CongisnmentOrderStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            IInventoryAdjustBLL invAdjust = new InventoryAdjustBLL();
            Hashtable param = new Hashtable();

            param.Add("DealerId", this.hiddenDealerId.Text);
            param.Add("ProductLineId", this.cbProductLineWin.SelectedItem.Value);
            param.Add("LotNumber", this.hiddenLotNumber.Text);
            param.Add("CFN", this.hiddenCFN.Text);

            DataSet ds = new DataSet();
            ds = invAdjust.GetConsignmentOrderNbr(param);

            this.CongisnmentOrderStore.DataSource = ds;
            this.CongisnmentOrderStore.DataBind();
        }

        private bool IsGuid(string strSrc)
        {
            if (String.IsNullOrEmpty(strSrc)) { return false; }

            bool _result = false;
            try
            {
                Guid _t = new Guid(strSrc);
                _result = true;
            }

            catch { }
            return _result;
        }
        #endregion

        #region 销售调整 Added By Song Yuqi On 2016-03-28 
        protected void ShowAdminShipmentDialog(object sender, AjaxEventArgs e)
        {
            //判断是否符合打开对话框的条件
            //1、产品线 2、销售医院
            if (string.IsNullOrEmpty(this.cbProductLineWin.SelectedItem.Value) || string.IsNullOrEmpty(this.cbHospitalWin.SelectedItem.Value))
            {
                Ext.Msg.Alert(GetLocalResourceObject("ShowDialog.Alert.Title").ToString(), GetLocalResourceObject("ShowDialog.Alert.Body").ToString()).Show();
                return;
            }
            //用量日期
            if (this.txtShipmentDateWin.SelectedDate == DateTime.MinValue || this.txtShipmentDateWin.IsNull)
            {
                Ext.Msg.Alert(GetLocalResourceObject("ShowDialog.Alert.Title").ToString(), GetLocalResourceObject("ShowDialog.Alert.Body2").ToString()).Show();
                return;
            }

            string SaleType = e.ExtraParams["DealerWarehouseType"].ToString();
            int IsAuth = 0;
            string ShipmentDate = Convert.ToDateTime(e.ExtraParams["ShipmentDate"]).ToString("yyyy-MM-dd");

            this.tfDealerForAdmin.Text = this.cbDealerWin.SelectedItem.Text;
            this.tfHospitalForAdmin.Text = this.cbHospitalWin.SelectedItem.Text;
            this.tfProductLineForAdmin.Text = this.cbProductLineWin.SelectedItem.Text;
            this.tfShipmentDateForAdmin.Text = ShipmentDate;

            this.ShipmentAdjustWindow.Show();

            ShipmentAdjustLotForShipmentStore.DataBind();
            ShipmentAdjustLotForInventoryStore.DataBind();

        }

        protected void ShipmentAdjustLotForShipmentStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            if (!String.IsNullOrEmpty(this.hiddenOrderId.Text) && !String.IsNullOrEmpty(this.hiddenShipmentDate.Text))
            {
                Guid headId = new Guid(this.hiddenOrderId.Text);

                DataSet ds = business.QueryShipmentAdjustLotForShipmentBySphId(headId);

                this.ShipmentAdjustLotForShipmentStore.DataSource = ds;
                this.ShipmentAdjustLotForShipmentStore.DataBind();
            }
        }

        protected void ShipmentAdjustLotForInventoryStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            if (!String.IsNullOrEmpty(this.hiddenOrderId.Text) && !String.IsNullOrEmpty(this.hiddenShipmentDate.Text))
            {
                Guid headId = new Guid(this.hiddenOrderId.Text);

                DataSet ds = business.QueryShipmentAdjustLotForInventoryBySphId(headId);

                this.ShipmentAdjustLotForInventoryStore.DataSource = ds;
                this.ShipmentAdjustLotForInventoryStore.DataBind();
            }
        }

        protected void ShowShipmentAdjustDialog(object sender, AjaxEventArgs e)
        {
            //判断是否符合打开对话框的条件
            //1、产品线 2、销售医院
            if (string.IsNullOrEmpty(this.cbProductLineWin.SelectedItem.Value) || string.IsNullOrEmpty(this.cbHospitalWin.SelectedItem.Value))
            {
                Ext.Msg.Alert("Error", "请选择产品线和销售医院").Show();
                return;
            }
            //用量日期
            if (this.txtShipmentDateWin.SelectedDate == DateTime.MinValue || this.txtShipmentDateWin.IsNull)
            {
                Ext.Msg.Alert("Error", "请选择用量日期").Show();
                return;
            }

            string dialogType = e.ExtraParams["DialogType"].ToString();
            string SaleType = "";
            if (dialogType.Equals("Inventory") 
                && this.hiddenIsShipmentUpdate.Value.ToString().Equals("UpdateShipment")
                && !business.IsAdminRole() )
            {
                SaleType = "销售出库单医院库";
            }
            else {
                SaleType = e.ExtraParams["DealerWarehouseType"].ToString();
            }
            string ShipmentDate = Convert.ToDateTime(e.ExtraParams["ShipmentDate"]).ToString("yyyy-MM-dd");
            if (business.IsAdminRole() || this.hiddenIsShipmentUpdate.Value.ToString().Equals("UpdateShipment"))
            {
                this.ShipmentCfnDialog1.Show(new Guid(this.hiddenOrderId.Text), new Guid(this.cbDealerWin.SelectedItem.Value), new Guid(this.cbProductLineWin.SelectedItem.Value), new Guid(this.cbHospitalWin.SelectedItem.Value), this.cbHospitalWin.SelectedItem.Text, SaleType, 1, ShipmentDate, dialogType);
            }
        }

        [AjaxMethod]
        public void DeleteAdjustItem(string salId, string lotId)
        {
            bool result = false;
            try
            {
                result = business.DeleteAdjustItem(new Guid(salId), new Guid(this.hiddenOrderId.Text), new Guid(lotId));
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        [AjaxMethod]
        public void SaveAdjustItemForInv(string shipmentQty, string shipmentPrice)
        {
            if (string.IsNullOrEmpty(this.hiddenCurrentEditShipmentId.Text))
            {
                return;
            }

            ShipmentAdjustLot obj = business.GetShipmentAdjustLotById(new Guid(this.hiddenCurrentEditShipmentId.Text));

            if (obj != null)
            {
                obj.ShipmentQty = string.IsNullOrEmpty(shipmentQty) ? obj.ShipmentQty : decimal.Parse(shipmentQty);
                obj.ShipmentPrice = string.IsNullOrEmpty(shipmentPrice) ? obj.ShipmentPrice : decimal.Parse(shipmentPrice);

                business.SaveShipmentAdjust(obj);

                this.ShipmentAdjustLotForInventoryStore.DataBind();
            }
        }

        [AjaxMethod]
        public void SaveAdjustItemForShipment(string shipmentPrice)
        {
            if (string.IsNullOrEmpty(this.hiddenCurrentEditShipmentId.Text))
            {
                return;
            }

            ShipmentAdjustLot obj = business.GetShipmentAdjustLotById(new Guid(this.hiddenCurrentEditShipmentId.Text));

            if (obj != null)
            {
                obj.ShipmentPrice = string.IsNullOrEmpty(shipmentPrice) ? obj.ShipmentPrice : decimal.Parse(shipmentPrice);

                business.SaveShipmentAdjust(obj);

                this.ShipmentAdjustLotForShipmentStore.DataBind();
            }
        }

        [AjaxMethod]
        public void AddShipmentAdjustToShipmentLot()
        {
            string rtnVal = "";
            string rtnMsg = "";

            //if (this.dtShipmentDateForAdjust.IsNull)
            //{
            //    Ext.Msg.Alert("Error", "请选择使用用量日期！").Show();
            //    return;
            //}
            if (this.cbReasonForAdmin.SelectedItem == null || string.IsNullOrEmpty(this.cbReasonForAdmin.SelectedItem.Value))
            {
                Ext.Msg.Alert("Error", "请选择调整原因！").Show();
                return;
            }
            string ShipmentDate = null;
            if (!this.IsAdmin) {
                ShipmentDate = this.txtShipmentDateWin.IsNull ? null : this.txtShipmentDateWin.SelectedDate.ToString("yyyy-MM-dd");
            } else { 
            ShipmentDate = this.dtShipmentDateForAdjust.IsNull ? null : this.dtShipmentDateForAdjust.SelectedDate.ToString("yyyy-MM-dd");
            }
            string Reason = this.cbReasonForAdmin.SelectedItem.Value;
            Guid headId = new Guid(this.hiddenOrderId.Text);
            Guid dealerId = new Guid(this.cbDealerWin.SelectedItem.Value);
            Guid hosId = new Guid(this.cbHospitalWin.SelectedItem.Value);
            string OpsUser = "";
            if (this.hiddenIsShipmentUpdate.Value.ToString().Equals("UpdateShipment")
                && !business.IsAdminRole())
            {
                OpsUser = "Dealer";
            }
            business.AddShipmentAdjustToShipmentLot(headId, dealerId, hosId, ShipmentDate, Reason, OpsUser, out rtnVal, out rtnMsg);

            if (rtnVal == "Success")
            {
                this.txtMemoWin.Text = Reason;

                this.ShipmentAdjustWindow.Hide();
                this.DetailStore.DataBind();
            }
            else if (rtnVal == "Error")
            {
                Ext.Msg.Alert("Error", rtnMsg.Replace("$$", "<BR/>")).Show();
            }
            else
            {
                Ext.Msg.Alert("Failure", rtnMsg).Show();
            }
        }

        private void DeleteAllAdjust(Guid sphId)
        {
            bool result = false;
            try
            {
                result = business.DeleteShipmentAdjustLotBySphId(sphId);
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        #endregion

        #region 经销商上报销量上传文件控制
        protected void ReasonStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            DataSet ds = business.SelectLimitNumber(RoleModelContext.Current.User.CorpId.Value);
            this.ReasonStore.DataSource = ds;
            this.ReasonStore.DataBind();
        }

        protected void ShowReason(object sender, AjaxEventArgs e)
        {

            this.ReasonWindow.Show();
            this.GridPanel4.Reload();
        }
        #endregion

        #region 批量上传附件 Added By Song Yuqi On 2017-05-02
        protected void InvoiceUploadStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            this.InvoiceUploadStore.DataSource = business.QueryShipmentInvoiceInitErrorData((e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar5.PageSize : e.Limit), out totalCount);
            this.InvoiceUploadStore.DataBind();
            e.TotalCount = totalCount;
        }


        [AjaxMethod]
        public string UploadShipmentAttachment(int index, string fileName, string fileUrl)
        {
            string rtnVal;
            string fileNewName;
            fileNewName = fileUrl.Substring(fileUrl.LastIndexOf("/") + 1, fileUrl.Length - fileUrl.LastIndexOf("/") - 1);

            int cn = _business.InsertAttachmentForShipmentUploadFile(fileName, fileNewName);

            rtnVal = string.Format("{0},{1}", index, cn);

            return rtnVal;
        }

        protected void UploadInvoiceClick(object sender, AjaxEventArgs e)
        {
            this.btnInvoiceImport.Disabled = true;
            business.DeleteShipmentInvoiceInitByUser();

            if (this.fufShipmentInvoice.HasFile)
            {
                #region 上传文件至服务器
                System.Diagnostics.Debug.WriteLine("Upload Start : " + DateTime.Now.ToString());
                bool error = false;

                string fileName = fufShipmentInvoice.PostedFile.FileName;
                string fileExtention = string.Empty;
                if (fileName.LastIndexOf(".") < 0)
                {
                    error = true;
                }
                else
                {
                    fileExtention = fileName.Substring(fileName.LastIndexOf(".") + 1).ToLower();
                    if (fileExtention != "xls" && fileExtention != "xlsx")
                    {
                        error = true;
                    }
                }

                if (error)
                {
                    Ext.Msg.Show(new MessageBox.Config
                    {
                        Buttons = MessageBox.Button.OK,
                        Icon = MessageBox.Icon.INFO,
                        Title = "错误",
                        Message = "模板类型不正确，仅支持xls和xlsx的文件格式"
                    });

                    return;
                }

                //构造文件名称

                string newFileName = Guid.NewGuid().ToString() + "." + fileExtention;

                //上传文件在Upload文件夹

                string file = Server.MapPath("\\Upload\\ShipmentInvoiceInit\\" + newFileName);

                //文件上传
                fufShipmentInvoice.PostedFile.SaveAs(file);

                this.hiddenFileName.Text = newFileName;
                System.Diagnostics.Debug.WriteLine("Upload Finish : " + DateTime.Now.ToString());
                #endregion

                #region 读取文件到中间表
                //导入到中间表
                DataTable dt = ExcelHelper.GetDataTable(file, "sheet1");

                //根据列数量判断文件模板是否正确
                if (dt.Columns.Count < 2)
                {
                    Ext.Msg.Alert("Error", "导入模板不正确").Show();
                }
                else
                {
                    if (dt.Rows.Count > 0)
                    {
                        if (business.InvoiceImport(dt, newFileName))
                        {
                            string RtnVal = string.Empty;
                            string RtnMsg = string.Empty;
                            business.InvoiceVerify(0, out RtnVal, out RtnMsg);
                            if (RtnVal == "Success")
                            {
                                this.btnInvoiceImport.Disabled = false;
                                Ext.Msg.Alert("", "上传成功!").Show();
                            }
                            else if (RtnVal == "Error")
                            {
                                Ext.Msg.Alert("Error", "有错误信息，请修改后重新上传!").Show();
                            }
                            else
                            {
                                Ext.Msg.Alert("Error", RtnMsg).Show();
                            }
                        }
                        else
                        {
                            Ext.Msg.Alert("Error", "有错误信息，请修改后重新上传!").Show();
                        }
                    }
                    else
                    {
                        Ext.Msg.Alert("Error", "导入数据为空，请重新上传！").Show();
                    }

                    #endregion

                }
            }
            else
            {
                Ext.Msg.Show(new MessageBox.Config
                {
                    Buttons = MessageBox.Button.OK,
                    Icon = MessageBox.Icon.ERROR,
                    Title = GetLocalResourceObject("UploadClick.Msg.Show.Title").ToString(),
                    Message = GetLocalResourceObject("UploadClick.Msg.Show.Message").ToString()
                });
            }
        }

        protected void UploadInvoiceConfirm(object sender, AjaxEventArgs e)
        {
            string RtnVal = string.Empty;
            string RtnMsg = string.Empty;

            business.InvoiceVerify(1, out RtnVal, out RtnMsg);
            if (RtnVal == "Success")
            {
                business.DeleteShipmentInvoiceInitByUser();
                Ext.Msg.Alert("Error", "导入成功！").Show();
            }
            else if (RtnVal == "Error")
            {
                Ext.Msg.Alert("Error", "有错误信息，请修改后重新上传!").Show();
            }
            else
            {
                Ext.Msg.Alert("Error", RtnMsg).Show();
            }

            this.InvoiceUploadStore.DataBind();
        }
        #endregion


        //销售单发票批量下载
        protected void ExportShipment(object sender, EventArgs e)
        {
            Hashtable param = new Hashtable();

            param.Add("AttachmentUrl", CommonVariable.ShimentAttachmentURL);
            if (!string.IsNullOrEmpty(this.cbProductLine.SelectedItem.Value))
            {
                param.Add("ProductLine", this.cbProductLine.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.cbDealer.SelectedItem.Value))
            {
                param.Add("DealerId", this.cbDealer.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.txtHospital.Text))
            {
                param.Add("HospitalName", this.txtHospital.Text);
            }
            if (!this.txtStartDate.IsNull)
            {
                param.Add("ShipmentDateStart", this.txtStartDate.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!this.txtEndDate.IsNull)
            {
                param.Add("ShipmentDateEnd", this.txtEndDate.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!string.IsNullOrEmpty(this.txtOrderNumber.Text))
            {
                param.Add("OrderNumber", this.txtOrderNumber.Text);
            }
            if (!string.IsNullOrEmpty(this.cbOrderStatus.SelectedItem.Value))
            {
                param.Add("Status", this.cbOrderStatus.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.txtCFN.Text))
            {
                param.Add("Cfn", this.txtCFN.Text);
            }
            if (!string.IsNullOrEmpty(this.txtUPN.Text))
            {
                param.Add("Upn", this.txtUPN.Text);
            }
            if (!string.IsNullOrEmpty(this.txtLotNumber.Text))
            {
                param.Add("LotNumber", this.txtLotNumber.Text);
            }

            if (!string.IsNullOrEmpty(this.cbShipmentOrderTypeWin.SelectedItem.Value))
            {
                param.Add("Type", this.cbShipmentOrderTypeWin.SelectedItem.Value);
            }

            if (!this.txtSubmitDateStart.IsNull)
            {
                param.Add("SubmitDateStart", this.txtSubmitDateStart.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!this.txtSubmitDateEnd.IsNull)
            {
                param.Add("SubmitDateEnd", this.txtSubmitDateEnd.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!string.IsNullOrEmpty(this.cbInvoiceStatus.SelectedItem.Value))
            {
                param.Add("InvoiceStatus", this.cbInvoiceStatus.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.txtInvoiceNo.Text))
            {
                param.Add("InvoiceNo", this.txtInvoiceNo.Text);
            }
            if (!string.IsNullOrEmpty(this.cbInvoiceState.SelectedItem.Value))
            {
                param.Add("InvoiceState", this.cbInvoiceState.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.cbInvoiceState.SelectedItem.Value))
            {
                param.Add("InvoiceNocheck", "1");
            }
            else
            {
                param.Add("InvoiceNocheck", "0");
            }
            if (!this.txtInvoiceDateStart.IsNull)
            {
                param.Add("txtInvoiceDateStart", this.txtInvoiceDateStart.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!this.txtInvoiceDateStart.IsNull)
            {
                param.Add("txtInvoiceDateend", this.txtInvoiceDateStart.SelectedDate.ToString("yyyyMMdd"));
            }

            DataTable dt = business.ExportShipmentAttachment(param).Tables[0];
            string templateName = "";
            templateName = Server.MapPath("\\Upload\\ExcelTemplate\\Template_ExportShipmentAttachment.xls");
            FileStream file = new FileStream(templateName, FileMode.Open, FileAccess.Read);
            hssfworkbook = new HSSFWorkbook(file);
            ISheet dataSheet = hssfworkbook.GetSheetAt(0);//获取excle sheet1
            //dataSheet.setForceFormulaRecalculation(true);
            if (dt.Rows.Count > 0)
            {  //根据下载的数据量生成指定行
                InsertExcelHospitalRows(dataSheet, dt.Rows.Count);
            }
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                string title = "\"附件下载\"";
                string dealername = dt.Rows[i]["经销商名称"].ToString();
                string sapcode = dt.Rows[i]["SAPcode"].ToString();
                string Saleno = dt.Rows[i]["销售单号"].ToString();
                string hospital = dt.Rows[i]["医院名称"].ToString();
                string date = dt.Rows[i]["销售日期"].ToString();
                string uploaduser = dt.Rows[i]["上报人"].ToString();
                string productline = dt.Rows[i]["产品线"].ToString();
                string state = dt.Rows[i]["状态"].ToString();
                string address = dt.Rows[i]["链接"].ToString();
                //string op = "\"http://localhost:12345/Pages/Shipment/ShipmentAttachmentDownload.aspx?ID="+address+"\"";
                //插入数据到Excel
                string url = "\"" + address + "\"";//把参数加上双引号
                dataSheet.GetRow(i + 1).GetCell(0).SetCellValue(dealername);
                dataSheet.GetRow(i + 1).GetCell(1).SetCellValue(sapcode);
                dataSheet.GetRow(i + 1).GetCell(2).SetCellValue(Saleno);
                dataSheet.GetRow(i + 1).GetCell(3).SetCellValue(hospital);
                dataSheet.GetRow(i + 1).GetCell(4).SetCellValue(date);
                dataSheet.GetRow(i + 1).GetCell(5).SetCellValue(uploaduser);
                dataSheet.GetRow(i + 1).GetCell(6).SetCellValue(productline);
                dataSheet.GetRow(i + 1).GetCell(7).SetCellValue(state);
                dataSheet.GetRow(i + 1).GetCell(8).SetCellFormula("HYPERLINK(" + url + "," + title + ")");//插入链接
            }
            Response.ContentType = "application/vnd.ms-excel";
            Response.AddHeader("Content-Disposition", string.Format("attachment;filename={0}", "DealerAuthorization.xls"));
            Response.Clear();
            GetExcelStream().WriteTo(Response.OutputStream);
            Response.Flush();
            Response.End();
        }
        private MemoryStream GetExcelStream()
        {
            MemoryStream file = new MemoryStream();
            hssfworkbook.Write(file);
            return file;
        }

        private void InsertExcelHospitalRows(ISheet dataSheet, int rowCount)
        {
            //将fromRowIndex行以后的所有行向下移动rowCount行，保留行高和格式
            dataSheet.ShiftRows(1, 1, rowCount, true, false);
            // '取得源格式行
            IRow rowSource = dataSheet.GetRow(0);
            ICellStyle rowstyle = rowSource.RowStyle;
            for (int rowIndex = 1; rowIndex < 1 + rowCount; rowIndex++)
            {
                // '新建插入行
                IRow rowInsert = dataSheet.CreateRow(rowIndex);
                rowInsert.Height = rowSource.Height;
                for (int colIndex = 0; colIndex < rowSource.LastCellNum; colIndex++)
                {
                    //'新建插入行的所有单元格，并复制源格式行相应单元格的格式
                    ICell cellSource = rowSource.GetCell(colIndex);
                    ICell cellInsert = rowInsert.CreateCell(colIndex);
                    //cellInsert.CellStyle = cellSource.CellStyle;
                }
            }




        }

        [AjaxMethod]
        protected void ExportSubmitDetail(object sender, EventArgs e)
        {

            if (!String.IsNullOrEmpty(this.hiddenOrderId.Text) )
            {
                Guid tid = new Guid(this.hiddenOrderId.Text);

               

                Hashtable param = new Hashtable();
                param.Add("SphId", tid);
                DataTable dt = business.GetHospitalShipmentbscBeforeSubmitInitForExport(param).Tables[0];
                this.Response.Clear();
                this.Response.Buffer = true;
                this.Response.AppendHeader("Content-Disposition", "attachment;filename=ShipmentError.xls");
                this.Response.ContentEncoding = System.Text.Encoding.UTF8;
                this.Response.ContentType = "application/vnd.ms-excel";
                this.EnableViewState = false;
                this.Response.Write(ExportHelp.AddExcelHead());//显示excel的网格线
                this.Response.Write(ExportHelp.ExportTable(dt));//导出
                this.Response.Write(ExportHelp.AddExcelbottom());//显示excel的网格线
                this.Response.Flush();
                this.Response.End();


            }
           

          
            
        }
    }

}
