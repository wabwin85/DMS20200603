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
    [AjaxMethodProxyID(IDMode = AjaxMethodProxyIDMode.Alias, Alias = "PromotionPolicyFactorRuleSearch")]
    public partial class PromotionPolicyFactorRuleSearch : BaseUserControl
    {
        #region 公用
        IRoleModelContext _context = RoleModelContext.Current;
        private IPromotionPolicyBLL _business = new PromotionPolicyBLL();
        #endregion

        #region 公开属性
        public bool IsPageNew
        {
            get
            {
                return (this.hidWd3IsPageNew.Text == "True" ? true : false);
            }
            set
            {
                this.hidWd3IsPageNew.Text = value.ToString();
            }
        }

        /// <summary>
        /// 政策ID
        /// </summary>
        public string PolicyId
        {
            get
            {
                return this.hidWd3PolicyId.Text;
            }
            set
            {
                this.hidWd3PolicyId.Text = value.ToString();
            }
        }

        /// <summary>
        /// 政策因素ID
        /// </summary>
        public string PolicyFactorId
        {
            get
            {
                return this.hidWd3PolicyFactorId.Text;
            }
            set
            {
                this.hidWd3PolicyFactorId.Text = value.ToString();
            }
        }

        /// <summary>
        /// 因素ID
        /// </summary>
        public string FactorId
        {
            get
            {
                return this.hidWd3FactorId.Text;
            }
            set
            {
                this.hidWd3FactorId.Text = value.ToString();
            }
        }


        /// <summary>
        /// 政策因素控制条件
        /// </summary>
        public string FactConditionId
        {
            get
            {
                return this.hidWd3FactConditionId.Text;
            }
            set
            {
                this.hidWd3FactConditionId.Text = value.ToString();
            }
        }

        /// <summary>
        /// 因素ID隐藏字段，每次修改都是从1增长
        /// </summary>
        public int UsePageId
        {
            get
            {
                return (this.hidWd3UsePageId.Text == "" ? 0 : Convert.ToInt32(this.hidWd3UsePageId.Text));
            }
            set
            {
                this.hidWd3UsePageId.Text = value.ToString();
            }
        }


        /// <summary>
        /// 页面修改属性
        /// </summary>
        public string PageType
        {
            get
            {
                return this.hidWd3PageType.Text;
            }
            set
            {
                this.hidWd3PageType.Text = value.ToString();
            }
        }
        /// <summary>
        /// 政策状态属性
        /// </summary>
        public string PromotionState
        {
            get
            {
                return this.hidWd3PromotionState.Text;
            }
            set
            {
                this.hidWd3PromotionState.Text = value.ToString();
            }
        }
        #endregion

        #region 数据绑定
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void FactorConditionStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            DataTable qutry = new DataTable();
            if (FactorId != "")
            {
                qutry = _business.GetFactorConditionByFactorId(FactorId).Tables[0];
            }
            this.FactorConditionStore.DataSource = qutry;
            this.FactorConditionStore.DataBind();
        }

        protected void FactorConditionTypeStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            DataTable qutry = new DataTable();
            if (FactorId != "")
            {
                Hashtable obj = new Hashtable();
                obj.Add("FactId", FactorId);
                obj.Add("ConditionId", this.cbWd3FactorCondition.SelectedItem.Value.Equals("") ? "-1" : this.cbWd3FactorCondition.SelectedItem.Value);
                qutry=_business.GetFactorConditionType(obj).Tables[0];
            }
            this.FactorConditionTypeStore.DataSource = qutry;
            this.FactorConditionTypeStore.DataBind();
        }

        protected void Wd3FactorRelationStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            DataTable qutry = new DataTable();
            if (PolicyId != "")
            {
                Hashtable obj = new Hashtable();
                //obj.Add("PolicyId", PolicyId);
                obj.Add("PolicyFactorId", PolicyFactorId);
                obj.Add("CurrUser", _context.User.Id);
                qutry = _business.GetFactorRelationeUiCan(obj).Tables[0];
            }
            this.Wd3FactorRelationStore.DataSource = qutry;
            this.Wd3FactorRelationStore.DataBind();
        }
        #endregion


        protected void Wd3RuleStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            Hashtable obj = new Hashtable();
            obj.Add("FactConditionId", FactConditionId);
            obj.Add("ProductLineId", this.hidWd3ProductLine.Value);
            obj.Add("SubBU", this.hidWd3SubBU.Value);
            obj.Add("KeyValue", this.txtWd3KeyValue.Text);
            obj.Add("CurrUser", _context.User.Id);
            DataTable query = _business.QueryFactorConditionRuleUiCan(obj, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount).Tables[0];
            (this.Wd3RuleStore.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
            this.Wd3RuleStore.DataSource = query;
            this.Wd3RuleStore.DataBind();
        }

        protected void Wd3RuleSeletedStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            Hashtable obj = new Hashtable();
            obj.Add("FactConditionId", FactConditionId);
            obj.Add("CurrUser", _context.User.Id);
            DataTable query = _business.QueryFactorConditionRuleUiSeleted(obj, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar2.PageSize : e.Limit), out totalCount).Tables[0];
            (this.Wd3RuleSeletedStore.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
            this.Wd3RuleSeletedStore.DataSource = query;
            this.Wd3RuleSeletedStore.DataBind();

        }


        #region Ajax Method
        [AjaxMethod]
        public void Show(string policyId, string policyFactorId, string factId, string factConditionId, string productLineId, string subBU, string pagetype, string state)
        {
            this.IsPageNew = (factConditionId == String.Empty);
            this.PolicyId = (policyId == String.Empty) ? "" : policyId;
            this.PolicyFactorId = (policyFactorId == String.Empty) ? "" : policyFactorId;
            this.FactConditionId = (factConditionId == String.Empty) ? (UsePageId += 1).ToString() : factConditionId;
            this.hidWd3ProductLine.Value = (productLineId == String.Empty) ? "" : productLineId;
            this.hidWd3SubBU.Value = (subBU == String.Empty) ? "" : subBU;
            this.FactorId = factId;

            this.PageType = pagetype;
            this.PromotionState = state;

            this.InitDetailWindow();
            this.wd3PolicyFactorCondition.Show();

        }

        [AjaxMethod]
        public void SavePolicyFactorCondition()
        {
            Hashtable obj = new Hashtable();
            obj.Add("FactConditionId", FactConditionId);
            obj.Add("PolicyFactorId", PolicyFactorId);
            obj.Add("ConditionId", this.cbWd3FactorCondition.SelectedItem.Value);
            obj.Add("ConditionType", this.cbWd3FactorConditionType.SelectedItem.Value);
            obj.Add("CurrUser", _context.User.Id);
            
            _business.InsertUIPolicyFactorCondition(obj);
        }

        [AjaxMethod]
        public void AddRule(string valueId)
        {
            Hashtable obj = new Hashtable();
            obj.Add("FactConditionId", FactConditionId);
            obj.Add("ConditionValueAdd", valueId);
            obj.Add("CurrUser", _context.User.Id);

            int i=_business.FactorConditionRuleUiSet(obj);
        }

        [AjaxMethod]
        public void DeleteRule(string valueId)
        {
            Hashtable obj = new Hashtable();
            obj.Add("FactConditionId", FactConditionId);
            obj.Add("ConditionValueDelete", valueId);
            obj.Add("CurrUser", _context.User.Id);
            _business.FactorConditionRuleUiDelete(obj);
        }

        [AjaxMethod]
        public void SavePolicyFactorRelation()
        {
            Hashtable obj = new Hashtable();
            obj.Add("PolicyFactorId", PolicyFactorId);
            obj.Add("ConditionPolicyFactorId", this.cbWd3PolicyFactorRelation.SelectedItem.Value);
            obj.Add("CurrUser", _context.User.Id);

            _business.InsertPolicyFactorRelation(obj);
        }

        #endregion

        #region 页面私有方法
        /// <summary>
        /// 初始化页面
        /// </summary>
        private void InitDetailWindow()
        {
            DataTable dtFactCondition = new DataTable();
            if (!IsPageNew)
            {
                Hashtable obj = new Hashtable();
                obj.Add("FactConditionId", FactConditionId);
                obj.Add("CurrUser", _context.User.Id);
                dtFactCondition = _business.QueryUIPolicyFactorCondition(obj).Tables[0];
            }
            //页面赋值
            ClearFormValue();
            SetFormValue(dtFactCondition);
            //页面控件状态
            ClearDetailWindow();
            SetDetailWindow(dtFactCondition);
        }

        /// <summary>
        /// 清除页面控件的值
        /// </summary>
        private void ClearFormValue()
        {
            this.cbWd3FactorCondition.SelectedItem.Value = "";
            this.cbWd3FactorConditionType.SelectedItem.Value = "";
            this.cbWd3PolicyFactorRelation.SelectedItem.Value = "";
            this.txtWd3cbWd3RelationRemark.Clear();
        }

        private void SetFormValue(DataTable dtFactCondition)
        {
            if (dtFactCondition != null && dtFactCondition.Rows.Count > 0)
            {
                DataRow drValues = dtFactCondition.Rows[0];
                this.cbWd3FactorCondition.SelectedItem.Value = drValues["ConditionId"].ToString();
                this.cbWd3FactorConditionType.SelectedItem.Value = drValues["OperTag"] != null ? drValues["OperTag"].ToString() : "";
            }
        }

        /// <summary>
        /// 清除页面控件状态
        /// </summary>
        private void ClearDetailWindow()
        {
            //产品线
            this.cbWd3FactorCondition.Disabled = false;
            this.cbWd3FactorConditionType.Disabled = false;
            this.cbWd3PolicyFactorRelation.Disabled = false;
            this.txtWd3KeyValue.Hidden = true;
            this.btnWd3FactorConditionQuery.Hidden = true;
            this.btnWd3UploadHospital.Hidden = true;
            this.btnWd3AddFactorCondition.Hidden = false;
            this.PanelWd3AddFactorCondition.Hidden = true;
            this.PanelWd3AddFactorConditionSelected.Hidden = true;
            this.PanelWd3FactorRelation.Hidden = true;

            this.GridWd3FactorRuleCondition.ColumnModel.SetHidden(2, false);
            this.GridWd3FactorRuleConditionSeleted.ColumnModel.SetHidden(2, false);
            this.ButtonWd3FactorRelation.Disabled = false;
        }

        /// <summary>
        /// 设定控件状态
        /// </summary>
        private void SetDetailWindow(DataTable dtFactCondition)
        {
            if (FactorId == "6" || FactorId == "7" || FactorId == "8" || FactorId == "9" || FactorId == "12" || FactorId == "13" || FactorId == "14" || FactorId == "15")
            {
                this.PanelWd3PolicyFactor.Hidden = true;
                this.PanelWd3AddFactorCondition.Hidden = true;
                this.PanelWd3AddFactorConditionSelected.Hidden = true;
                this.PanelWd3FactorRelation.Hidden = false;
                if (dtFactCondition != null && dtFactCondition.Rows.Count > 0)
                {
                    this.PanelWd3FactorRelation.Disabled = true;
                }
            }
            else 
            {
                this.PanelWd3PolicyFactor.Hidden = false;
                this.PanelWd3AddFactorCondition.Hidden = false;
                this.PanelWd3AddFactorConditionSelected.Hidden = false;
                this.PanelWd3FactorRelation.Hidden = true;
                if (dtFactCondition != null && dtFactCondition.Rows.Count > 0)
                {
                    this.cbWd3FactorCondition.Disabled = true;
                    this.cbWd3FactorConditionType.Disabled = true;
                    this.txtWd3KeyValue.Hidden = false;
                    this.btnWd3AddFactorCondition.Hidden = true;
                    this.btnWd3FactorConditionQuery.Hidden = false;
                    if (dtFactCondition.Rows[0]["ConditionId"].ToString().Equals("4")) 
                    {
                        this.btnWd3UploadHospital.Hidden = false;
                    }
                }
            }

            if (FactorId != "2") 
            {
                //非医院因素不可以修改
                if (PageType == "View")
                {
                    this.GridWd3FactorRuleCondition.ColumnModel.SetHidden(2, true);
                    this.GridWd3FactorRuleConditionSeleted.ColumnModel.SetHidden(2, true);
                    this.ButtonWd3FactorRelation.Disabled = true;
                }
                else if (PageType == "Modify" && !PromotionState.Equals(SR.PRO_Status_Approving) && !PromotionState.Equals(SR.PRO_Status_Draft))
                {
                    this.GridWd3FactorRuleCondition.ColumnModel.SetHidden(2, true);
                    this.GridWd3FactorRuleConditionSeleted.ColumnModel.SetHidden(2, true);
                    this.ButtonWd3FactorRelation.Disabled = true;
                }
            }
           
        }
        
        #endregion


        #region Hospital Upload
        [AjaxMethod]
        public void HospitalShow()
        {
            this.FileUploadFieldHospital.SetValue("");
            this.wd3UploadHospital.Show();
        }
        #endregion

        #region 页面私有方法 (Top Value)
        protected void UploadHospitalClick(object sender, AjaxEventArgs e)
        {
            //先删除上传人之前的数据
            //_business.DeletePolicyHospitalUIByConditionId(_context.User.Id, this.FactConditionId);

            if (this.FileUploadFieldHospital.HasFile)
            {
                #region 上传文件至服务器
                System.Diagnostics.Debug.WriteLine("Upload Start : " + DateTime.Now.ToString());
                bool error = false;

                string fileName = FileUploadFieldHospital.PostedFile.FileName;
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
                FileUploadFieldHospital.PostedFile.SaveAs(file);

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
                        string errmsg = "";
                        if (_business.HospitalImport(dt, FactConditionId, PolicyFactorId, this.cbWd3FactorConditionType.SelectedItem.Value, out errmsg))
                        {
                            
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