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
using System.IO;
using DMS.Business.Contract;

namespace DMS.Website.Pages.Promotion
{
    [AjaxMethodProxyID(IDMode = AjaxMethodProxyIDMode.Alias, Alias = "InitialPointApply")]
    public partial class InitialPointApply : BasePage
    {
        #region 公开属性
        IRoleModelContext _context = RoleModelContext.Current;
        private IGiftMaintainBLL _business = new GiftMaintainBLL();
        private IPromotionPolicyBLL _businessPolicy = new PromotionPolicyBLL();
        TenderAuthorizationListBLL Bll = new TenderAuthorizationListBLL();

        public string FLowId
        {
            get { return this.hidFLowId.Text; }
            set { this.hidFLowId.Text = value.ToString(); }
        }
        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                this.hidUserId.Value = _context.User.Id;
                this.Bind_ProductLine(this.ProductLineStore);
            }
        }

        protected void ResultStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            Hashtable param = new Hashtable();
            if (!string.IsNullOrEmpty(this.cbProductLine.SelectedItem.Value))
            {
                param.Add("BU", this.cbProductLine.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.cbApplyStatus.SelectedItem.Value))
            {
                param.Add("Status", this.cbApplyStatus.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.cbPointsType.SelectedItem.Value))
            {
                param.Add("PointType", this.cbPointsType.SelectedItem.Value);
            }
            //if (!string.IsNullOrEmpty(this.txtApplyNo.Text))
            //{
            //    param.Add("ApplyNo", this.txtApplyNo.Text);
            //}
            param.Add("UserId", _context.User.Id);

            DataTable query = _business.QueryInitialPointsList(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount).Tables[0];

            (this.ResultStore.Proxy[0] as DataSourceProxy).TotalCount = totalCount;

            this.ResultStore.DataSource = query;
            this.ResultStore.DataBind();
        }

        protected void InitPointStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            Hashtable param = new Hashtable();
            if (!string.IsNullOrEmpty(this.cbProductLine.SelectedItem.Value))
            {
                param.Add("BU", this.cbProductLine.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.cbApplyStatus.SelectedItem.Value))
            {
                param.Add("Status", this.cbApplyStatus.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.cbPointsType.SelectedItem.Value))
            {
                param.Add("PointType", this.cbPointsType.SelectedItem.Value);
            }
            param.Add("UserId", _context.User.Id);

            DataTable query = _business.QueryInitialPointsList(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar2.PageSize : e.Limit), out totalCount).Tables[0];

            (this.InitPointStore.Proxy[0] as DataSourceProxy).TotalCount = totalCount;

            this.InitPointStore.DataSource = query;
            this.InitPointStore.DataBind();
        }

        protected void InitImportPointStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            DataTable query = _business.GetImportPoint(this.hidFLowId.Text).Tables[0];

            this.InitImportPointStore.DataSource = query;
            this.InitImportPointStore.DataBind();
        }

        #region AjaxMethod
        [AjaxMethod]
        public void Show()
        {
            this.hidFLowId.Text = "";
            this.InitDetailWindow();
            this.WindowPoints.Show();
        }

        [AjaxMethod]
        public void ImportShow()
        {
            ImportWindow.Show();
        }

        [AjaxMethod]
        public string CheckProductSet()
        {
            string massage = "false";

            Hashtable obj = new Hashtable();
            obj.Add("FlowId", FLowId.ToString());
            DataTable query = _business.QueryUseRangeSeleted(obj).Tables[0];
            if (query.Rows.Count > 0)
            {
                massage = "true";
            }
            return massage;
        }

        [AjaxMethod]
        public string SubmitCheck()
        {
            string massage = "FALSE";
            DataTable PointsDetail = _business.GetInitialPointsDetail(FLowId.ToString()).Tables[0];
            if (PointsDetail.Rows.Count > 0)
            {
                massage = "";
            }
            return massage;
        }
        #endregion

        #region 私有方法
        public void InitDetailWindow()
        {
            DataTable PointsHrader = null;
            _business.CreateInitialPoints(_context.User.Id);
            this.hidFLowId.Text = _business.GetMaxFlowId(_context.User.Id) != null ? _business.GetMaxFlowId(_context.User.Id).Rows[0]["FlowId"].ToString() : "1";


            //页面赋值
            ClearFormValue();
            SetFormValue(PointsHrader);
            //页面控件状态
            ClearStateWindow();
            SetDetailWindow(PointsHrader);
        }

        /// <summary>
        /// 清理页面赋值
        /// </summary>
        private void ClearFormValue()
        {
            this.txtWdApplyNo.Clear();
            this.areWdDescription.Clear();
            this.txtImportTotal.Clear();
            this.cbMarketType.SelectedItem.Value = "";
            this.cbWdProductLine.SelectedItem.Value = "";
            this.cbWdPointType.SelectedItem.Value = "";
            this.cbWdPointUseRangeType.SelectedItem.Value = "";
        }

        private void SetFormValue(DataTable PointsHrader)
        {
            if (PointsHrader != null && PointsHrader.Rows.Count > 0)
            {
                DataRow PointsDr = PointsHrader.Rows[0];
                this.txtWdApplyNo.Text = (PointsDr["FlowNo"] == null) ? "" : PointsDr["FlowNo"].ToString();
                this.areWdDescription.Text = (PointsDr["Description"] == null) ? "" : PointsDr["Description"].ToString();
                this.cbWdProductLine.SelectedItem.Value = (PointsDr["ProductLineId"] == null) ? "" : PointsDr["ProductLineId"].ToString();
                this.cbWdPointType.SelectedItem.Value = (PointsDr["PointType"] == null) ? "" : PointsDr["PointType"].ToString();
                this.cbWdPointUseRangeType.SelectedItem.Value = (PointsDr["PointUseRangeType"] == null) ? "" : PointsDr["PointUseRangeType"].ToString();
            }
        }

        /// <summary>
        ///清理页面控制状态 
        /// </summary>
        private void ClearStateWindow()
        {
            this.btnWdPointUseRange.Hidden = true;
        }

        private void SetDetailWindow(DataTable PointsHrader)
        {
            cbMarketType.Disabled = true;
            cbMarketType.SelectedItem.Value = "0";
            if (PointsHrader != null && PointsHrader.Rows.Count > 0)
            {
                DataRow PointsDr = PointsHrader.Rows[0];
                if (PointsDr["PointUseRange"] != null && PointsDr["PointUseRangeType"].ToString().Equals("SpecialProduct"))
                {
                    this.btnWdPointUseRange.Hidden = false;
                }
                Button1.Hidden = !PointsDr["Status"].Equals("草稿");
                //SaveFileButton.Hidden = !PointsDr["Status"].Equals("草稿");
                //ResetButton.Hidden = !PointsDr["Status"].Equals("草稿");
                //DownloadButton.Hidden = !PointsDr["Status"].Equals("草稿");
            }
            else
            {
                Button1.Hidden = false;
                //SaveFileButton.Hidden = false;
                //ResetButton.Hidden = false;
                //DownloadButton.Hidden = false;
            }
        }

        protected void UploadClick(object sender, AjaxEventArgs e)
        {
            //先删除上传人之前的数据
            Hashtable obj = new Hashtable();
            obj.Add("FlowId", this.hidFLowId.Text);
            _business.DeleteInitPoint(obj);

            if (this.FileUploadField.HasFile)
            {
                #region 上传文件至服务器
                System.Diagnostics.Debug.WriteLine("Upload Start : " + DateTime.Now.ToString());
                bool error = false;

                string fileName = FileUploadField.PostedFile.FileName;
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
                        Title = "文件错误",
                        Message = "请使用正确的模板文件，模板文件为EXCEL文件!"
                    });

                    return;
                }



                //构造文件名称

                string newFileName = Guid.NewGuid().ToString() + "." + fileExtention;

                //上传文件在Upload文件夹
                string file = Server.MapPath("\\Upload\\PROOther\\" + newFileName);

                //文件上传
                FileUploadField.PostedFile.SaveAs(file);

                System.Diagnostics.Debug.WriteLine("Upload Finish : " + DateTime.Now.ToString());
                #endregion

                #region 读取文件到中间表
                //导入到中间表
                DataTable dt = ExcelHelper.GetDataTable(file, "sheet1");

                //根据列数量判断文件模板是否正确
                if (dt.Columns.Count < 6)
                {
                    Ext.Msg.Alert("错误", "请使用正确的模板!").Show();

                }
                else
                {
                    if (dt.Rows.Count > 0)
                    {
                        string errmsg = "";
                        if (_business.DetailImport(dt, this.hidFLowId.Text, out errmsg))
                        {
                            if (!string.IsNullOrEmpty(errmsg))
                            {
                                Ext.Msg.Alert("错误", errmsg.ToString()).Show();
                            }
                        }
                        else
                        {
                            Ext.Msg.Alert("错误", errmsg.ToString()).Show();
                        }
                    }
                    else
                    {
                        Ext.Msg.Alert("错误", "没有数据可导入!").Show();
                    }

                    this.InitImportPointStore.DataSource = _business.GetImportPoint(this.hidFLowId.Text);
                    this.InitImportPointStore.DataBind();
                    this.txtImportTotal.Text = _business.GetTotalPointByFlowId(this.hidFLowId.Text);
                    #endregion

                }
            }

            else
            {
                Ext.Msg.Show(new MessageBox.Config
                {
                    Buttons = MessageBox.Button.OK,
                    Icon = MessageBox.Icon.ERROR,
                    Title = "上传失败",
                    Message = "文件未被成功上传!"
                });


            }
        }

        [AjaxMethod]
        public string Submit()
        {
            string massage = "";
            if (this.cbWdProType.SelectedItem.Value == "积分")
            {
                ProInitPointFlow header = new ProInitPointFlow();
                header.FlowId = Convert.ToInt32(this.hidFLowId.Text);
                header.Status = "已提交";
                header.Bu = cbWdProductLine.SelectedItem.Text;
                header.PointType = cbWdPointType.SelectedItem.Value;
                header.PointUseRangeType = cbWdPointUseRangeType.SelectedItem.Value;
                header.Description = areWdDescription.Text;
                //header.MarketType = Convert.ToInt32(this.cbMarketType.SelectedItem.Value);
                header.MarketType = 0;
                header.Instanceid = Guid.NewGuid();
                header.FlowNo = Bll.GetNextAutoNumberForTender(this.cbWdProductLine.SelectedItem.Value, "IPI", "SysSalesUploader");
                //header.ReasonType = cbPriceTypeReason.SelectedItem.Value;

                Save(header, out massage);
            }
            else {

            }
            return massage;



        }

        private bool Save(ProInitPointFlow initpointflow, out string massage)
        {
            bool ret = true;
            string Result = string.Empty;
            massage = "";

            string ProductLineId = cbWdProductLine.SelectedItem.Value;
            //更新主表内容
            _business.UpdateInitialPoints(initpointflow);

            _business.UpdateFormsStatus(initpointflow.FlowId.ToString(), ProductLineId);//直接审核通过

            //生成给EF的HTML,并更新到HtmlStr字段
            // _business.GetInitPointEWorkFlowHtml(initpointflow.FlowId);

            //向EKP发起流程申请
            //_business.SendEKPEWorkflow(initpointflow);
            return ret;
        }

        [AjaxMethod]
        public void DeleteDraft()
        {
            _business.DeleteDraft(FLowId);
        }

        [AjaxMethod]
        public void DeleteAttachment(string id, string fileName)
        {
            try
            {
                //逻辑删除
                _businessPolicy.DeletePolicyAttachment(id);
                //物理删除
                string uploadFile = Server.MapPath("..\\..\\Upload\\UploadFile\\Promotion");
                File.Delete(uploadFile + "\\" + fileName);
            }
            catch (Exception ex)
            {
                Ext.Msg.Alert("Error", "删除失败").Show();
            }
        }
        protected void AttachmentStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            Hashtable obj = new Hashtable();
            obj.Add("PolicyId", this.hidFLowId.Text);
            obj.Add("Type", "GiftInit");
            int totalCount = 0;
            this.AttachmentStore.DataSource = _business.InitialPointAttachment(obj, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar3.PageSize : e.Limit), out totalCount);
            this.AttachmentStore.DataBind();
            e.TotalCount = totalCount;
        }
        protected void UploadAttachmentClick(object sender, AjaxEventArgs e)
        {
            if (this.ufUploadAttachment.HasFile)
            {

                bool error = false;

                string fileName = ufUploadAttachment.PostedFile.FileName;
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

                string file = Server.MapPath("\\Upload\\UploadFile\\Promotion\\" + newFileName);


                //文件上传
                ufUploadAttachment.PostedFile.SaveAs(file);

                Hashtable obj = new Hashtable();
                obj.Add("PolicyId", this.hidFLowId.Text);
                obj.Add("Name", fileExtention);
                obj.Add("Url", newFileName);
                obj.Add("UploadUser", _context.User.Id);
                obj.Add("UploadDate", DateTime.Now.ToShortDateString());
                obj.Add("Type", "GiftInit");
                //维护附件信息
                _businessPolicy.InsertPolicyAttachment(obj);

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
        #endregion

    }
}
