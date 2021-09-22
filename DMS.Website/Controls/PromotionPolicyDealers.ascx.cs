using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DMS.Website.Common;
using Coolite.Ext.Web;
using DMS.Business;
using System.Collections;
using System.Data;
using DMS.Model.Data;
using DMS.Model;
using Lafite.RoleModel.Security;
using DMS.Business.Cache;
using DMS.Common;
using Microsoft.Practices.Unity;
namespace DMS.Website.Controls
{
    [AjaxMethodProxyID(IDMode = AjaxMethodProxyIDMode.Alias, Alias = "PromotionPolicyDealers")]
    public partial class PromotionPolicyDealers : BaseUserControl
    {
        #region 公用
        IRoleModelContext _context = RoleModelContext.Current;
        private IPromotionPolicyBLL _business = new PromotionPolicyBLL();
        #endregion

        #region 公开属性
        public string ProductLineId
        {
            get
            {
                return this.hidWd7ProductLineId.Text;
            }
            set
            {
                this.hidWd7ProductLineId.Text = value.ToString();
            }
        }

        public string SubBU
        {
            get
            {
                return this.hidWd7SubBuCode.Text;
            }
            set
            {
                this.hidWd7SubBuCode.Text = value.ToString();
            }
        }
        public string PolicyId
        {
            get
            {
                return this.hidWd7PolicyId.Text;
            }
            set
            {
                this.hidWd7PolicyId.Text = value.ToString();
            }
        }

        public string PageType
        {
            get
            {
                return this.hidWd7PageType.Text;
            }
            set
            {
                this.hidWd7PageType.Text = value.ToString();
            }
        }

        public string PromotionState
        {
            get
            {
                return this.hidWd7PromotionState.Text;
            }
            set
            {
                this.hidWd7PromotionState.Text = value.ToString();
            }
        }
        #endregion

        #region 数据绑定
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void PolicyDealerCanStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;

            Hashtable obj = new Hashtable();
            obj.Add("PolicyId", PolicyId);
            obj.Add("CurrUser", _context.User.Id);
            obj.Add("ProductLineId", ProductLineId);
            if (SubBU != "")
            {
                obj.Add("SubBU", SubBU);
            }
            if (!this.txtWd7DealerName.Value.ToString().Equals("")) 
            {
                obj.Add("DealerName", this.txtWd7DealerName.Value.ToString());
            }
            DataSet dsDealer = _business.QueryDealerCan(obj, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBarPolicyDealersCan.PageSize : e.Limit), out totalCount);
            (this.PolicyDealerCanStore.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
            PolicyDealerCanStore.DataSource = dsDealer;
            PolicyDealerCanStore.DataBind();
        }

        protected void PolicyDealerSeletedStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;

            Hashtable obj = new Hashtable();
            obj.Add("PolicyId", PolicyId);
            obj.Add("CurrUser", _context.User.Id);
            obj.Add("WithType", "ByDealer");
            DataSet dsDealer = _business.QueryPolicyDealerSelected(obj, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBarPolicyDealersSelected.PageSize : e.Limit), out totalCount);
            (this.PolicyDealerSeletedStore.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
            PolicyDealerSeletedStore.DataSource = dsDealer;
            PolicyDealerSeletedStore.DataBind();
        }

        protected void UpLoadDealerListStore_RefreshData(object sender, StoreRefreshDataEventArgs e) 
        {
            int totalCount = 0;

            Hashtable obj = new Hashtable();
            obj.Add("CurrUser", _context.User.Id);
            DataSet dsDealer = _business.QueryPolicyDealerUpload(obj, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBarDealer.PageSize : e.Limit), out totalCount);
            (this.UpLoadDealerListStore.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
            UpLoadDealerListStore.DataSource = dsDealer;
            UpLoadDealerListStore.DataBind();
        }
        #endregion

        #region Ajax Method
        [AjaxMethod]
        public void Show(string policyId, string productLineId, string subBu, string pagetype,string state)
        {
            this.PolicyId = (policyId == String.Empty) ? "" : policyId;
            this.ProductLineId = (productLineId == String.Empty) ? "" : productLineId;
            this.SubBU = (subBu == String.Empty) ? "" : subBu;
            this.PageType = pagetype;
            this.PromotionState = state;
            this.InitDetailWindow();
            this.wd7PolicyDealer.Show();
        }

        [AjaxMethod]
        public void DelaerAdd(string dealerId)
        {
            UpdateContainDealers(dealerId, "包含");
        }

        [AjaxMethod]
        public void DelaerExclusive(string dealerId)
        {
            UpdateContainDealers(dealerId, "不包含");
        }

        [AjaxMethod]
        public void DeleteSelectedDealer(string dealerId)
        {
            Hashtable obj = new Hashtable();
            obj.Add("CurrUser", _context.User.Id);
            obj.Add("DEALERID", dealerId);
            _business.DeleteSelectedDealer(obj);
        }

        #endregion

        #region 页面私有方法
        private void InitDetailWindow()
        {
            //页面控件状态
            ClearDetailWindow();
            SetDetailWindow();
        }

        /// <summary>
        /// 清除页面控件状态
        /// </summary>
        private void ClearDetailWindow()
        {
            this.GridWd7PolicyDealer.ColumnModel.SetHidden(2, false);
            this.GridWd7PolicyDealer.ColumnModel.SetHidden(3, false);
            this.GridWd3PolicyDealerSeleted.ColumnModel.SetHidden(3, false);
            this.btnWd7PolicyDealerUpload.Hidden = false;
        }

        /// <summary>
        /// 设定控制状态
        /// </summary>
        private void SetDetailWindow()
        {
            if (PageType == "View")
            {
                this.GridWd7PolicyDealer.ColumnModel.SetHidden(2, true);
                this.GridWd7PolicyDealer.ColumnModel.SetHidden(3, true);
                this.btnWd7PolicyDealerUpload.Hidden = true;
                this.GridWd3PolicyDealerSeleted.ColumnModel.SetHidden(3, true);
            }
            else if (PageType == "Modify" && !PromotionState.Equals(SR.PRO_Status_Approving) && !PromotionState.Equals(SR.PRO_Status_Draft))
            {
                //经销商可以修改
                //this.GridWd7PolicyDealer.ColumnModel.SetHidden(2, true);
                //this.GridWd7PolicyDealer.ColumnModel.SetHidden(3, true);
                //this.GridWd3PolicyDealerSeleted.ColumnModel.SetHidden(3, true);
            }
        }

        private void UpdateContainDealers(string dealerId, string operType)
        {
            Hashtable obj=new Hashtable ();
            obj.Add("DealerId",dealerId);
            obj.Add("OperType", operType);
            obj.Add("WithType", "ByDealer");
            obj.Add("PolicyId", PolicyId);
            obj.Add("CorrUser", _context.User.Id);
            obj.Add("Remark1", "");
            _business.InsertPolicyDealer(obj);
        }

        #endregion


        #region Ajax Method (上传指定经销商)
        [AjaxMethod]
        public void DealerUploadShow() 
        {
            _business.DeleteDealersByUserId();
            this.ButtonWd7Submint.Hidden = true;
            this.wd7DealerUpload.Show();
            this.GridWd7DealerList.Reload();
        }

        [AjaxMethod]
        public void DealerSubmint()
        {
            _business.DealersUiSubmint();
        }

        #endregion

        #region 页面私有方法 (上传指定经销商)
        protected void UploadDealerClick(object sender, AjaxEventArgs e)
        {
            //先删除上传人之前的数据
            _business.DeleteDealersByUserId();

            if (this.FileUploadFieldDealer.HasFile)
            {
                #region 上传文件至服务器
                System.Diagnostics.Debug.WriteLine("Upload Start : " + DateTime.Now.ToString());
                bool error = false;

                string fileName = FileUploadFieldDealer.PostedFile.FileName;
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

                string file = Server.MapPath("\\Upload\\PRODealerInit\\" + newFileName);


                //文件上传
                FileUploadFieldDealer.PostedFile.SaveAs(file);

                System.Diagnostics.Debug.WriteLine("Upload Finish : " + DateTime.Now.ToString());
                #endregion

                #region 读取文件到中间表
                //导入到中间表
                DataTable dt = ExcelHelper.GetDataTable(file, "sheet1");

                //根据列数量判断文件模板是否正确
                if (dt.Columns.Count < 2)
                {
                    Ext.Msg.Alert("错误", "请使用正确的模板!").Show();

                }
                else
                {
                    if (dt.Rows.Count > 0)
                    {
                        if (_business.DealersImport(dt, PolicyId))
                        {
                            string IsValid = string.Empty;
                            if (_business.VerifyDealers(out IsValid, ProductLineId,SubBU))
                            {
                                if (IsValid == "Error")
                                {
                                    Ext.Msg.Alert("错误", "数据包含错误或警告信息，请确认后导入！").Show();
                                    this.ButtonWd7Submint.Hidden = true;
                                }
                                else 
                                {
                                    this.ButtonWd7Submint.Hidden = false;
                                }
                            }
                           
                        }
                        else
                        {
                            Ext.Msg.Alert("错误", "Excel数据格式错误!").Show();
                        }
                    }
                    else
                    {
                        Ext.Msg.Alert("错误", "没有数据可导入!").Show();
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
                    Title = "上传失败",
                    Message = "文件未被成功上传!"
                });


            }
        }
        #endregion
    }
}