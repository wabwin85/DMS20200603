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
    [AjaxMethodProxyID(IDMode = AjaxMethodProxyIDMode.Alias, Alias = "PromotionPolicyFactorSearch")]
    public partial class PromotionPolicyFactorSearch : BaseUserControl
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
                return (this.hidWd2IsPageNew.Text == "True" ? true : false);
            }
            set
            {
                this.hidWd2IsPageNew.Text = value.ToString();
            }
        }
        /// <summary>
        /// 因素ID
        /// </summary>
        public string PolicyFactorId
        {
            get
            {
                return this.hidWd2PolicyFactorId.Text ;
            }
            set
            {
                this.hidWd2PolicyFactorId.Text = value.ToString();
            }
        }
        /// <summary>
        /// 政策ID
        /// </summary>
        public string PolicyId
        {
            get
            {
                return this.hidWd2PolicyId.Text;
            }
            set
            {
                this.hidWd2PolicyId.Text = value.ToString();
            }
        }
        /// <summary>
        /// 因素ID隐藏字段，每次修改都是从1增长（默认从3开始（1,2留出给系统默认因素））
        /// </summary>
        public int UsePageId
        {
            get
            {
                return (this.hidWd2UsePageId.Text == "" ? 3 : Convert.ToInt32(this.hidWd2UsePageId.Text));
            }
            set
            {
                this.hidWd2UsePageId.Text = value.ToString();
            }
        }

       
        /// <summary>
        /// 页面修改属性
        /// </summary>
        public string PageType
        {
            get
            {
                return this.hidWd2PageType.Text;
            }
            set
            {
                this.hidWd2PageType.Text = value.ToString();
            }
        }
        /// <summary>
        /// 政策状态属性
        /// </summary>
        public string PromotionState
        {
            get
            {
                return this.hidWd2PromotionState.Text;
            }
            set
            {
                this.hidWd2PromotionState.Text = value.ToString();
            }
        }

        /// <summary>
        /// 是否积分政策
        /// </summary> 
        public string IsPoint
        {
            get
            {
                return this.hidIsPointPolicy.Text == "" ? "N" : this.hidIsPointPolicy.Text;
            }
            set
            {
                this.hidIsPointPolicy.Text = value.ToString();
            }
        }

        /// <summary>
        /// 政策类型小类
        /// </summary> 
        public string IsPointSub
        {
            get
            {
                return this.hidIsPointPolicySub.Text == "" ? "促销赠品" : this.hidIsPointPolicySub.Text;
            }
            set
            {
                this.hidIsPointPolicySub.Text = value.ToString();
            }
        }


        #endregion

        #region 数据绑定
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void PolicyFactorStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            Hashtable obj = new Hashtable();

            if (IsPointSub == "满额送赠品" || IsPointSub == "满额打折")
            {
                obj.Add("IsJMJZ", "Y");
            }
            DataSet ds = _business.QueryPolicyFactorList(obj);
            PolicyFactorStore.DataSource = ds;
            PolicyFactorStore.DataBind();
        }

        //protected void IsGiftStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        //{
        //    IDictionary<string, string> proType = DictionaryHelper.GetDictionary(SR.PRO_YesOrNo);
        //    IsGiftStore.DataSource = proType;
        //    IsGiftStore.DataBind();
        //}

        protected void PolicyFactorRuleStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            Hashtable obj = new Hashtable();
            obj.Add("PolicyFactorId", PolicyFactorId);
            obj.Add("CurrUser", _context.User.Id);

            DataTable query = _business.QueryConditionRuleUi(obj, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount).Tables[0];
            (this.PolicyFactorRuleStore.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
            PolicyFactorRuleStore.DataSource = query;
            PolicyFactorRuleStore.DataBind();
        }

        protected void PolicyFactorRelationStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            Hashtable obj = new Hashtable();
            obj.Add("PolicyFactorId", PolicyFactorId);
            obj.Add("CurrUser", _context.User.Id);

            DataTable query = _business.QueryFactorRelationUi(obj, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBarFactorRelation.PageSize : e.Limit), out totalCount).Tables[0];
            (this.PolicyFactorRuleStore.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
            PolicyFactorRelationStore.DataSource = query;
            PolicyFactorRelationStore.DataBind();
        }
        

        #endregion

        #region Ajax Method
        [AjaxMethod]
        public void Show(string policyId, string PolicyFactorId, string isPoint, string isPointSub, string productLineId, string subBU, string pagetype, string state)
        {
            this.IsPageNew = (PolicyFactorId == String.Empty);
            this.PolicyId = (policyId == String.Empty) ? "" : policyId;
            this.PolicyFactorId = (PolicyFactorId == String.Empty) ? (UsePageId+=1).ToString() : PolicyFactorId;
            
            this.hidWd2ProductLine.Value = (productLineId == String.Empty) ? "" : productLineId;
            this.hidWd2SubBU.Value = (subBU == String.Empty) ? "" : subBU;

            this.IsPoint = (isPoint=="赠品"?"N":"Y");
            this.IsPointSub = isPointSub;
            this.PageType = pagetype;
            this.PromotionState = state;

            this.InitDetailWindow();
            this.wd2PolicyFactor.Show();

        }

        [AjaxMethod]
        public void SavePolicyFactor()
        {
            bool result;
            ProPolicyFactorUi PolicyFactorUi = new ProPolicyFactorUi();
            if (IsPageNew)
            {
                PolicyFactorUi.PolicyFactorId = Convert.ToInt32(PolicyFactorId);
                PolicyFactorUi.PolicyId = Convert.ToInt32(PolicyId);
                PolicyFactorUi.FactId = Convert.ToInt32(this.cbWd2Factor.SelectedItem.Value);
                PolicyFactorUi.FactDesc = this.txaWd2Remark.Text;
                PolicyFactorUi.CurrUser = _context.User.Id;
                string IsGift = this.cbWd2IsGift.SelectedItem.Value.Equals("") ? "N" : this.cbWd2IsGift.SelectedItem.Value;
                string IsPoints = this.cbWd2PointsValue.SelectedItem.Value.Equals("") ? "N" : this.cbWd2PointsValue.SelectedItem.Value;
                result = _business.InsertProPolicyFactorUi(PolicyFactorUi, IsGift, IsPoints);
            }
            else 
            {

            }
        }

        [AjaxMethod]
        public void UpdatePolicyFactor()
        {
            int result;
            ProPolicyFactorUi PolicyFactorUi = new ProPolicyFactorUi();
            
            PolicyFactorUi.PolicyFactorId = Convert.ToInt32(PolicyFactorId);
            PolicyFactorUi.FactDesc = this.txaWd2Remark.Text;
            PolicyFactorUi.CurrUser = _context.User.Id;
            result = _business.UpdateProPolicyFactorUi(PolicyFactorUi);
        }


        [AjaxMethod]
        public string CheckIsGift()
        {
            Hashtable obj=new Hashtable ();
            obj.Add("CurrUser", _context.User.Id);
            string ckGif = _business.CheckIsGift(obj);
            if (ckGif=="1")
            {
                this.cbWd2IsGift.SelectedItem.Value = "N";
            }
            else if (ckGif == "2") 
            {
                this.cbWd2PointsValue.SelectedItem.Value = "N";
            }
            else if (ckGif == "3")
            {
                this.cbWd2IsGift.SelectedItem.Value = "N";
                this.cbWd2PointsValue.SelectedItem.Value = "N";
            }
            return ckGif;
        }

        [AjaxMethod]
        public void FactorRuleDelete(string conditionId, string policyFactorConditionId)
        {
            Hashtable obj=new Hashtable ();
            obj.Add("CurrUser", _context.User.Id);
            obj.Add("PolicyFactorConditionId", policyFactorConditionId);
            obj.Add("ConditionId", conditionId);
            _business.DeleteUIPolicyFactorCondition(obj);
        }

        [AjaxMethod]
        public void FactorRelationDelete(string policyfactorId, string conditionpolicyfactorId)
        {
            Hashtable obj = new Hashtable();
            obj.Add("CurrUser", _context.User.Id);
            obj.Add("PolicyFactorId", policyfactorId);
            obj.Add("ConditionPolicyFactorId", conditionpolicyfactorId);

            _business.DeletePolicyFactorRelation(obj);
        }
        
        #endregion

        #region 页面私有方法
        /// <summary>
        /// 初始化页面
        /// </summary>
        private void InitDetailWindow()
        {
            DataTable dtFactor = new DataTable();
            if (!IsPageNew)
            {
                ProPolicyFactorUi factorUi = new ProPolicyFactorUi();
                factorUi.PolicyFactorId = Convert.ToInt32(PolicyFactorId);
                factorUi.CurrUser = _context.User.Id;
                dtFactor = _business.QueryUIPolicyFactorAndGift(factorUi).Tables[0];
            }
            //页面赋值
            ClearFormValue();
            SetFormValue(dtFactor);
            //页面控件状态
            ClearDetailWindow();
            SetDetailWindow(dtFactor);
        }

        /// <summary>
        /// 清除页面控件的值
        /// </summary>
        private void ClearFormValue()
        {
            this.hidWd2Factor.Clear();
            this.cbWd2Factor.SelectedItem.Value = "";
            this.txaWd2Remark.Clear();
            this.cbWd2IsGift.SelectedItem.Value = "";
            this.cbWd2PointsValue.SelectedItem.Value = "";
        }

        private void SetFormValue(DataTable dtFactor)
        {
            if (dtFactor != null && dtFactor.Rows.Count>0) 
            {
                DataRow drValues = dtFactor.Rows[0];
                //this.cbWd2Factor.SelectedItem.Value = drValues["FactId"].ToString();
                this.hidWd2Factor.Value = drValues["FactId"].ToString();
                this.txaWd2Remark.Text= drValues["FactDesc"] != null ? drValues["FactDesc"].ToString() : "";
                this.cbWd2IsGift.SelectedItem.Value = drValues["IsGift"] != null ? drValues["IsGift"].ToString() : "";
                this.cbWd2PointsValue.SelectedItem.Value = drValues["IsPoint"] != null ? drValues["IsPoint"].ToString() : "";
            }
        }

        /// <summary>
        /// 清除页面控件状态
        /// </summary>
        private void ClearDetailWindow()
        {
            //产品线
            this.cbWd2Factor.Disabled = false;
            //this.txaWd2Remark.Disabled = false;
            this.cbWd2IsGift.Disabled = false;
            this.cbWd2IsGift.Hidden = true;
            this.cbWd2PointsValue.Disabled = false;
            this.cbWd2PointsValue.Hidden = true;
            this.btnWd2AddFactor.Hidden=false;
            this.PanelWd2AddFactorRule.Hidden = true;
            this.PanelWd2AddFactorRule2.Hidden = true;
            this.PanelWd2UploadField.Hidden = true;
            //this.PanelWd2UploadAopRemark.Text = "请上传指定产品指标";

            this.GridWd2FactorRule.ColumnModel.SetHidden(4, false);
            this.btnWd2AddFactorRule.Disabled = false;
            this.GridWd2FactorRule2.ColumnModel.SetHidden(2, false);
            this.btnWd2FactorRule2.Disabled = false;
        }

        /// <summary>
        /// 设定控件状态
        /// </summary>
        private void SetDetailWindow(DataTable dtFactor) 
        {
            if (dtFactor != null && dtFactor.Rows.Count > 0)
            {
                DataRow drValues = dtFactor.Rows[0];
                string factId= drValues["FactId"].ToString();
                this.cbWd2Factor.SelectedItem.Value = factId;

                this.cbWd2Factor.Disabled = true;
                //this.txaWd2Remark.Disabled = true;
                this.cbWd2IsGift.Disabled = true;
                this.cbWd2PointsValue.Disabled = true;
                this.btnWd2AddFactor.Hidden = true;
                if (factId.Equals("1") || factId.Equals("2") || factId.Equals("3")) 
                {
                    this.PanelWd2AddFactorRule.Hidden = false;
                    if (factId.Equals("1")) 
                    {
                        if (IsPointSub == "促销赠品" || IsPointSub == "促销赠品转积分" || IsPointSub == "满额送赠品" || IsPointSub == "满额打折")
                        {
                            this.cbWd2IsGift.Hidden = false;
                        }
                        if (IsPointSub != "促销赠品" && IsPointSub != "满额送赠品" && IsPointSub != "满额打折") 
                        {
                            this.cbWd2PointsValue.Hidden = false;
                        }
                    }
                }
                else if (factId.Equals("6") || factId.Equals("7") || factId.Equals("8") || factId.Equals("9") || factId.Equals("12") || factId.Equals("13") || factId.Equals("14") || factId.Equals("15"))
                {
                    this.PanelWd2AddFactorRule2.Hidden = false;
                    if (factId.Equals("6") || factId.Equals("7") || factId.Equals("14") || factId.Equals("15")) 
                    {
                        this.PanelWd2UploadField.Hidden = false;
                    }
                }

                if (!factId.Equals("2")) //医院可以修改
                {
                    //非医院因素不可以修改
                    if (PageType == "View")
                    {
                        this.GridWd2FactorRule.ColumnModel.SetHidden(4, true);
                        this.btnWd2AddFactorRule.Disabled = true;
                        this.GridWd2FactorRule2.ColumnModel.SetHidden(2, true);
                        this.btnWd2FactorRule2.Disabled = true;
                    }
                    else if (PageType == "Modify" && !PromotionState.Equals(SR.PRO_Status_Approving) && !PromotionState.Equals(SR.PRO_Status_Draft))
                    {
                        this.GridWd2FactorRule.ColumnModel.SetHidden(4, true);
                        this.btnWd2AddFactorRule.Disabled = true;
                        this.GridWd2FactorRule2.ColumnModel.SetHidden(2, true);
                        this.btnWd2FactorRule2.Disabled = true;
                    }
                }
            }
        }

        protected void UploadIndxClick(object sender, AjaxEventArgs e)
        {
            //先删除上传人之前的数据
            _business.DeleteProductIndexByUserId(this.wd2hidProductIndxFactType.Value.ToString(), PolicyFactorId);

            if (this.FileUploadFieldIndx.HasFile)
            {
                #region 上传文件至服务器
                System.Diagnostics.Debug.WriteLine("Upload Start : " + DateTime.Now.ToString());
                bool error = false;

                string fileName = FileUploadFieldIndx.PostedFile.FileName;
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

                string file = Server.MapPath("\\Upload\\PROProductAOPInit\\" + newFileName);


                //文件上传
                FileUploadFieldIndx.PostedFile.SaveAs(file);

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
                        if (_business.ProductIndexImport(dt, PolicyFactorId,this.wd2hidProductIndxFactType.Value.ToString()))
                        {
                            string IsValid = string.Empty;
                            if (_business.VerifyProductIndex(out IsValid, this.wd2hidProductIndxFactType.Value.ToString()))
                            {
                                if (IsValid == "Error")
                                {
                                    Ext.Msg.Alert("", "数据包含错误或警告信息，请确认后导入！").Show();
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

        #region Ajax Method For Product Indx
        [AjaxMethod]
        public void ProductIndxShow(string factorId)
        {
            this.wd2hidProductIndxFactType.Value = factorId;
            this.wd2ProductIndx.Show();
        }
        #endregion

        #region 数据绑定 For Product Indx
        protected void ProductIndxStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            Hashtable obj = new Hashtable();
            obj.Add("PolicyFactorId", PolicyFactorId);
            obj.Add("CurrUser", _context.User.Id);

            DataTable query = _business.QueryPolicyProductIndxUi(obj, this.wd2hidProductIndxFactType.Value.ToString(), (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBarIndx.PageSize : e.Limit), out totalCount).Tables[0];
            (this.ProductIndxStore.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
            ProductIndxStore.DataSource = query;
            ProductIndxStore.DataBind();
        }
        #endregion

    }
}