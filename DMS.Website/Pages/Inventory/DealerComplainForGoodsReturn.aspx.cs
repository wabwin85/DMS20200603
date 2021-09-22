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
using Grapecity.Logging.CallHandlers;
using DMS.DataAccess;
using DMS.Model.EKPWorkflow;
using DMS.Business.EKPWorkflow;

namespace DMS.Website.Pages.Inventory
{
    [AjaxMethodProxyID(IDMode = AjaxMethodProxyIDMode.Alias, Alias = "DealerComplainForGoodsReturn")]
    public partial class DealerComplainForGoodsReturn : BasePage
    {
        #region 公用
        IRoleModelContext _context = RoleModelContext.Current;
        private IDealerComplainBLL _business = new DealerComplainBLL();
        private IPurchaseOrderBLL _orderLogbusiness = new PurchaseOrderBLL();

        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {
            this.hidCorpType.Text = "";
            this.Bind_DealerList(this.DealerStore);
            this.Bind_Status(this.AdjustStatusStore);

            if (IsDealer)
            {
                if (RoleModelContext.Current.User.CorpType.Equals(DealerType.T2.ToString()) 
                    || RoleModelContext.Current.User.CorpType.Equals(DealerType.T1.ToString()) 
                    || RoleModelContext.Current.User.CorpType.Equals(DealerType.LS.ToString()))
                {
                    this.Bind_DealerList(this.DealerStore);
                    this.cbDealer.Disabled = true;
                    this.hidInitDealerId.Value = RoleModelContext.Current.User.CorpId.Value.ToString();
                   
                }
                else if (RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()) )
                {
                    this.Bind_DealerListByFilter(this.DealerStore, false);
                    //this.GridPanel1.ColumnModel.SetHidden(11, false);
                    //this.GridPanel1.ColumnModel.SetHidden(12, false);
                }
                else
                {
                    this.Bind_DealerList(this.DealerStore);
                }

                this.hidCorpType.Text = RoleModelContext.Current.User.CorpType;
                this.btnInsertBSC.Show();
            }
            else
            {
                this.Bind_DealerList(this.DealerStore);
                if (_context.IsInRole("ApplyComplain"))
                {
                    this.btnInsertBSC.Show();
                } else
                {
                    this.btnInsertBSC.Hide();
                    this.GridPanel1.ColumnModel.SetHidden(11, true);
                    this.GridPanel1.ColumnModel.SetHidden(12, true);
                }
            }

            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                //控制查询按钮
                //Permissions pers = this._context.User.GetPermissions();
                //this.btnSearch.Visible = pers.IsPermissible(Business.PurchaseOrderBLL.Action_OrderApply, PermissionType.Read);
            }
        }

        protected void ResultStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;

            Hashtable param = new Hashtable();
            
            if (!string.IsNullOrEmpty(this.cbDealer.SelectedItem.Value))
            {
                param.Add("DealerId", this.cbDealer.SelectedItem.Value);
            }

            if (!string.IsNullOrEmpty(this.cbAdjustStatus.SelectedItem.Value))
            {
                param.Add("Status", this.cbAdjustStatus.SelectedItem.Value);
            }

            if (!string.IsNullOrEmpty(this.txtComplainNumber.Text))
            {
                param.Add("ComplainNumber", this.txtComplainNumber.Text);
            }
            if (!string.IsNullOrEmpty(this.txtDN.Text))
            {
                param.Add("DN", this.txtDN.Text);
            }

            if (!string.IsNullOrEmpty(this.txtUPN.Text))
            {
                param.Add("Upn", this.txtUPN.Text);
            }
            if (!string.IsNullOrEmpty(this.txtLotNumber.Text))
            {
                param.Add("LotNumber", this.txtLotNumber.Text);
            }
            
            if (!this.txtSubmitDateStart.IsNull)
            {
                param.Add("ApplyDateStart", this.txtSubmitDateStart.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!this.txtSubmitDateEnd.IsNull)
            {
                param.Add("ApplyDateEnd", this.txtSubmitDateEnd.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!String.IsNullOrEmpty(this.txtApplyUser.Text))
            {
                param.Add("ApplyUser", this.txtApplyUser.Text);
            }
            //param.Add("CorpId", RoleModelContext.Current.User.CorpId.Value);
            param.Add("ComplainType", "BSC");
            DataSet ds = _business.DealerComplainQuery(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);

            e.TotalCount = totalCount;

            this.ResultStore.DataSource = ds;
            this.ResultStore.DataBind();
        }

        [AjaxMethod]
        protected void ShowBSCEdit(object sender, AjaxEventArgs e)
        {
            Guid id = new Guid(e.ExtraParams["DC_ID"].ToString());

            //若id为空，说明为新增，则生成新的id，并新增一条记录
            if (id == Guid.Empty)
            {
                id = Guid.NewGuid();
            }
            //显示窗口
            this.DealerComplainBSCEdit.Show(Guid.Empty,"New");
        }

        [AjaxMethod]
        protected void ShowCRMEdit(object sender, AjaxEventArgs e)
        {
            Guid id = new Guid(e.ExtraParams["DC_ID"].ToString());

            //若id为空，说明为新增，则生成新的id，并新增一条记录
            if (id == Guid.Empty)
            {
                id = Guid.NewGuid();
            }
            //显示窗口
            //this.DealerComplainCRMEdit.Show(Guid.Empty);
        }

        [AjaxMethod]
        public void Show(string DC_ID, String type)
        {
            Guid id = new Guid(DC_ID);
            this.DealerComplainBSCEdit.Show(id, type);
           
        }

        protected void Bind_Status(Store store1)
        {
            IDictionary<string, string> dicts = DictionaryHelper.GetDictionary(SR.CONST_QAComplainReturn_Status);

            store1.DataSource = dicts;
            store1.DataBind();

        }

        [AjaxMethod]
        public void UpdateDealerComplain(string DC_ID)
        {
        
            Hashtable param = new Hashtable();
            param.Add("DC_ID", DC_ID);
            param.Add("DC_Status", "SendRefund");
            _business.UpdateDealerComplainStatus(param);

            _orderLogbusiness.InsertPurchaseOrderLog(new Guid(DC_ID), new Guid(RoleModelContext.Current.User.Id), PurchaseOrderOperationType.Confirm, "平台确认已换货给T2或寄送退款协议给T2");
            
        }
        [AjaxMethod]
        public void ExpressEditShow(string DC_ID)
        {
            this.hidDcId.Value = DC_ID;
            //修改快递单号和快递公司
            this.ExpressEditWindows.Show();
        }
        [AjaxMethod]
        public void ExpressSave()
        {
            //保存快递单号和快递公司
            Hashtable param = new Hashtable();
            param.Add("DcId", this.hidDcId.Value);
            param.Add("CarrierNumber", this.tfCourierNumber.Text);
            param.Add("CourierCompany", this.tfCourierCompany.Text);
            param.Add("ComplainType", "CNF");
            _business.UpdateDealerComplainCourier(param);

            _orderLogbusiness.InsertPurchaseOrderLog(new Guid(this.hidDcId.Value.ToString()), new Guid(RoleModelContext.Current.User.Id), PurchaseOrderOperationType.Confirm, "快递单号被修改");
        }

        [AjaxMethod]
        public void IANEditShow(string DC_ID)
        {
            this.hidWinDcId.Value = DC_ID;
            //修改全球投诉单号
            if (DC_ID != "")
            {
                DataTable dt = _business.GetDealerComplainBscInfo(new Guid(DC_ID));
                if (dt.Rows.Count > 0 && dt.Rows[0]["COMPLAINTID"] != null)
                {
                    this.txtWinComplaintID.Text = dt.Rows[0]["COMPLAINTID"].ToString();
                }
            }
            this.IANEditWindow.Show();
        }
        [AjaxMethod]
        public void IANSave()
        {
            string strMsg = "";
            Hashtable paramlp = new Hashtable();
            paramlp.Add("DC_ID", this.hidWinDcId.Value);
            paramlp.Add("ComplainType", "BSC");
            var table = _business.DealerComplainInfo(paramlp);
            bool isSave = false;
            if (table.Rows.Count > 0)
            {
                isSave = AutoSubmmitReturnOrder(table.Rows[0], out strMsg);
            }
            if (isSave)
            {
                //保存全球单号
                Hashtable param = new Hashtable();
                param.Add("DcId", this.hidWinDcId.Value);
                param.Add("ComplaintID", this.txtWinComplaintID.Text);
                param.Add("ComplainType", "CNF");
                _business.UpdateDealerComplainIAN(param);

                _orderLogbusiness.InsertPurchaseOrderLog(new Guid(this.hidWinDcId.Value.ToString()), new Guid(RoleModelContext.Current.User.Id), PurchaseOrderOperationType.Confirm, "全球投诉单号被修改");
            }
            else
            {
                throw new Exception(strMsg);
            }
        
        }
        private bool AutoSubmmitReturnOrder(DataRow dr, out string Msg )
        {
            bool bl = true;
            Msg = "";
            IInventoryAdjustBLL business = new InventoryAdjustBLL();
            Guid headID = Guid.NewGuid();
            Guid lineID = Guid.NewGuid();
            try
            {
                AutoNumberBLL auto = new AutoNumberBLL();
                
                IDealerMasters _dms = new DealerMasters();
                DealerMaster dma = _dms.GetDealerMaster(new Guid(Convert.ToString(dr["DC_CorpId"])));
                if (dma != null && (dma.DealerType == DealerType.LP.ToString() || dma.DealerType == DealerType.T1.ToString() || dma.DealerType == DealerType.LS.ToString()))
                {

                    InventoryAdjustHeaderDao mainDao = new InventoryAdjustHeaderDao();
                    InventoryAdjustDetailDao lineDao = new InventoryAdjustDetailDao();
                    InventoryAdjustLotDao lotDao = new InventoryAdjustLotDao();
                    LotDao lotd = new LotDao();
                    ProductDao pmaDao = new ProductDao();
                    Product pdt = new Product();
                    pdt.Upn = Convert.ToString(dr["UPN"]);
                    IList<Product> lproduct = pmaDao.SelectByFilter(pdt);
                    if (lproduct.Count > 0)
                    {
                        pdt = lproduct[0];
                    }
                    InventoryAdjustHeader mainData = new InventoryAdjustHeader();
                    mainData.Id = headID;
                    mainData.ProductLineBumId = pdt.ProductLineBumId;
                    mainData.UserDescription = "由投诉退换货自动生成";
                    mainData.Reason = "ZLReturn";
                    mainData.Rsm = Convert.ToString(dr["FIRSTBSCNAME"]);
                    mainData.ApplyType = "ZLReturn";
                    mainData.DmaId = new Guid(Convert.ToString(dr["DC_CorpId"]));
                    mainData.RetrunReason = "ZLReturn";
                    mainData.Status = AdjustStatus.Draft.ToString();
                    mainData.WarehouseType = "Normal";
                    mainData.InvAdjNbr = auto.GetNextAutoNumber(mainData.DmaId, OrderType.Next_AdjustNbr, mainData.ProductLineBumId.Value);
                    mainData.CreateDate = DateTime.Now;
                    mainData.CreateUser = new Guid(RoleModelContext.Current.User.Id);
                    bool result = true;
                    business.InsertInventoryAdjustHeader(mainData);
                    mainData = business.GetInventoryAdjustById(headID);
                    if (result)
                    {
                        InventoryAdjustDetail line = new InventoryAdjustDetail();
                        line.Id = lineID;
                        line.IahId = headID;
                        line.PmaId = pdt.Id;
                        line.Quantity = 1;
                        line.LineNbr = 1;
                        lineDao.Insert(line);
                        Hashtable htlot = new Hashtable();
                        htlot.Add("WHMID", Convert.ToString(dr["WHM_ID"]));
                        htlot.Add("CFNID", pdt.Cfn);
                        htlot.Add("LotNumber", Convert.ToString(dr["LOT"]));
                        htlot.Add("QRCode", Convert.ToString(dr["QrCode"]));
                        Lot lotr = lotd.SelectLotForReturn(htlot);
                        InventoryAdjustLot lot = new InventoryAdjustLot();
                        lot.Id = Guid.NewGuid();
                        lot.IadId = line.Id;
                        lot.LotId = lotr.Id;
                        lot.LotQty = 1;  //缺省发运数量置为1。 为减少用户的输入量，修改需求 @ 2009/12/3 by Steven
                        lot.WhmId = new Guid(Convert.ToString(dr["WHM_ID"]));
                        lot.LotNumber = Convert.ToString(dr["LOT"]) + "@@" + Convert.ToString(dr["QrCode"]);
                        lot.LtmLot = Convert.ToString(dr["LOT"]);
                        lot.LotQRCode = Convert.ToString(dr["QrCode"]);
                        Hashtable ht = new Hashtable();
                        ht.Add("DealerId", Convert.ToString(dr["DC_CorpId"]));
                        ht.Add("LotNumber", lot.LotNumber);
                        ht.Add("PmaId", pdt.Id);
                        BaseService.AddCommonFilterCondition(ht);
                        DataSet ds = lotDao.SelectReturnCfnPriceForT1AndLP(ht);
                        if (ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0)
                        {
                            if (!string.IsNullOrEmpty(Convert.ToString(ds.Tables[0].Rows[0]["PRL_ExpiredDate"])))
                            {
                                lot.ExpiredDate = Convert.ToDateTime(ds.Tables[0].Rows[0]["PRL_ExpiredDate"]);
                            }
                            if (!string.IsNullOrEmpty(Convert.ToString(ds.Tables[0].Rows[0]["PRL_DOM"])))
                            {
                                lot.DOM = Convert.ToString(ds.Tables[0].Rows[0]["PRL_DOM"]);
                            }
                            if (!string.IsNullOrEmpty(Convert.ToString(ds.Tables[0].Rows[0]["Price"])))
                            {
                                lot.UnitPrice = decimal.Parse(Convert.ToString(ds.Tables[0].Rows[0]["Price"]));
                            }
                            lot.ERPNbr = Convert.ToString(ds.Tables[0].Rows[0]["PRL_ERPNbr"]);
                            lot.ERPLineNbr = Convert.ToString(ds.Tables[0].Rows[0]["PRL_ERPLineNbr"]);
                        }
                        if (string.IsNullOrEmpty(lot.DOM) || lot.ExpiredDate == null || lot.UnitPrice == null)
                        {
                            bl = false;
                            Msg = "在发货数据中未找到相应信息，请导入虚拟发货数据！";
                        }
                        lotDao.Insert(lot);
                    }
                    kmReviewWebserviceBLL ekpBll = new kmReviewWebserviceBLL();
                    InventoryAdjustHeaderDao adjHeaderDao = new InventoryAdjustHeaderDao();
                    DataTable dt = adjHeaderDao.GetInventoryReturnForEkpFormDataById(headID);

                    string docSubject = dt.Rows[0]["docSubject"].ToString();
                    string templateId = DictionaryHelper.GetDictionaryNameById("CONST_TemplateId", "DealerReturn");
                    if (string.IsNullOrEmpty(templateId))
                    {
                        bl = false;
                        Msg = "OA流程ID未配置！";
                    }
                    //Added By Song Yuqi On 2017-08-24 For 普通退换货对接EKP Begin  //
                    ekpBll.DoSubmit(mainData.Rsm, mainData.Id.ToString(), mainData.InvAdjNbr, "DealerReturn", docSubject
                        , EkpModelId.DealerReturn.ToString(), EkpTemplateFormId.DealerReturnTemplate.ToString(), templateId);
                    mainData.Status = AdjustStatus.Submitted.ToString();
                    mainDao.Update(mainData);
                }
            }
            catch(Exception ex)
            {
                business.DeleteDraft(headID);
                bl = false;
                Msg = ex.Message;
            }
            return bl;
        }
        /// <summary>
        /// 导出信息
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void ExportExcel(object sender, EventArgs e)
        {
            Hashtable param = new Hashtable();

            if (!string.IsNullOrEmpty(this.cbDealer.SelectedItem.Value))
            {
                param.Add("DealerId", this.cbDealer.SelectedItem.Value);
            }

            if (!string.IsNullOrEmpty(this.cbAdjustStatus.SelectedItem.Value))
            {
                param.Add("Status", this.cbAdjustStatus.SelectedItem.Value);
            }

            if (!string.IsNullOrEmpty(this.txtComplainNumber.Text))
            {
                param.Add("ComplainNumber", this.txtComplainNumber.Text);
            }
            if (!string.IsNullOrEmpty(this.txtDN.Text))
            {
                param.Add("DN", this.txtDN.Text);
            }

            if (!string.IsNullOrEmpty(this.txtUPN.Text))
            {
                param.Add("Upn", this.txtUPN.Text);
            }
            if (!string.IsNullOrEmpty(this.txtLotNumber.Text))
            {
                param.Add("LotNumber", this.txtLotNumber.Text);
            }

            if (!this.txtSubmitDateStart.IsNull)
            {
                param.Add("ApplyDateStart", this.txtSubmitDateStart.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!this.txtSubmitDateEnd.IsNull)
            {
                param.Add("ApplyDateEnd", this.txtSubmitDateEnd.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!String.IsNullOrEmpty(this.txtApplyUser.Text))
            {
                param.Add("ApplyUser", this.txtApplyUser.Text);
            }
            //param.Add("CorpId", RoleModelContext.Current.User.CorpId.Value);
            param.Add("ComplainType", "BSC");
            DataTable dt = _business.DealerComplainExport(param);

            this.Response.Clear();
            this.Response.Buffer = true;
            this.Response.AppendHeader("Content-Disposition", "attachment;filename=result.xls");
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
