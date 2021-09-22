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
    [AjaxMethodProxyID(IDMode = AjaxMethodProxyIDMode.Alias, Alias = "PromotionPolicyRuleSet")]
    public partial class PromotionPolicyRuleSet : BaseUserControl
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
                return (this.hidWd4IsPageNew.Text == "True" ? true : false);
            }
            set
            {
                this.hidWd4IsPageNew.Text = value.ToString();
            }
        }

        public string PolicyId
        {
            get
            {
                return this.hidWd4PolicyId.Text;
            }
            set
            {
                this.hidWd4PolicyId.Text = value.ToString();
            }
        }

        public string PolicyRuleId
        {
            get
            {
                return this.hidWd4PolicyRuleId.Text;
            }
            set
            {
                this.hidWd4PolicyRuleId.Text = value.ToString();
            }
        }

        /// <summary>
        /// 因素ID隐藏字段，每次修改都是从1增长
        /// </summary>
        public int UsePageId
        {
            get
            {
                return (this.hidWd4UsePageId.Text == "" ? 0 : Convert.ToInt32(this.hidWd4UsePageId.Text));
            }
            set
            {
                this.hidWd4UsePageId.Text = value.ToString();
            }
        }

        public string PageType
        {
            get
            {
                return this.hidWd4PageType.Text;
            }
            set
            {
                this.hidWd4PageType.Text = value.ToString();
            }
        }

        public string PromotionState
        {
            get
            {
                return this.hidWd4PromotionState.Text;
            }
            set
            {
                this.hidWd4PromotionState.Text = value.ToString();
            }
        }

        public string PolicyStyle
        {
            get
            {
                return this.hidWd4PolicyStyle.Text;
            }
            set
            {
                this.hidWd4PolicyStyle.Text = value.ToString();
            }
        }

        public string PolicyStyleSub
        {
            get
            {
                return this.hidWd4PolicyStyleSub.Text;
            }
            set
            {
                this.hidWd4PolicyStyleSub.Text = value.ToString();
            }
        }


        #endregion

        #region 数据绑定
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void PolicyRuleDetailStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            Hashtable obj = new Hashtable();
            //obj.Add("RuleFactorId", "");
            obj.Add("RuleId", PolicyRuleId);
            obj.Add("CurrUser", _context.User.Id);
            DataSet dsRuleUi = _business.QueryUIFactorRuleCondition(obj, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBarRuleDetail.PageSize : e.Limit), out totalCount);
            (this.PolicyRuleDetailStore.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
            PolicyRuleDetailStore.DataSource = dsRuleUi;
            PolicyRuleDetailStore.DataBind();

        }

        protected void PolicyFactorXStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            Hashtable factorUi = new Hashtable();
            factorUi.Add("PolicyId", PolicyId);
            factorUi.Add("CurrUser", _context.User.Id);
            factorUi.Add("PolicyStyleSub", this.PolicyStyleSub);
            DataSet PolicyFactorUiList = _business.GetComputePolicyFactorUi(factorUi);
            PolicyFactorXStore.DataSource = PolicyFactorUiList;
            PolicyFactorXStore.DataBind();
        }

        #endregion


        #region Ajax Method
        [AjaxMethod]
        public void Show(string policyId, string ruleId, string pagetype, string state, string policystyle, string policystylesub)
        {
            this.IsPageNew = (ruleId == String.Empty);
            this.PolicyId = (policyId == String.Empty) ? "" : policyId;
            this.PolicyRuleId = (ruleId == String.Empty) ? (UsePageId += 1).ToString() : ruleId;

            this.PageType = pagetype;
            this.PromotionState = state;
            this.PolicyStyle = policystyle;
            this.PolicyStyleSub = policystylesub;

            this.InitDetailWindow();
            this.wd4PolicyRule.Show();

        }

        [AjaxMethod]
        public void SavePolicyRule()
        {
            ProPolicyRuleUi ruleUi = new ProPolicyRuleUi();
            ruleUi.JudgePolicyFactorId = Convert.ToInt32(this.cbWd4PolicyFactorX.SelectedItem.Value);
            if (!this.txtFactorValueX.Text.Equals(""))
            {
                ruleUi.JudgeValue = Convert.ToDecimal(this.txtFactorValueX.Value.ToString());
            }
            if (!this.txtFactorValueY.Text.Equals(""))
            {
                ruleUi.GiftValue = Convert.ToDecimal(this.txtFactorValueY.Value.ToString());
            }
            ruleUi.RuleId = Convert.ToInt32(PolicyRuleId);
            ruleUi.PolicyId = Convert.ToInt32(PolicyId);
            ruleUi.CurrUser = _context.User.Id;
            ruleUi.CreateBy = _context.User.Id;
            ruleUi.CreateTime = DateTime.Now;
            ruleUi.ModifyBy = _context.User.Id;
            ruleUi.ModifyDate = DateTime.Now;
            ruleUi.RuleDesc = this.areaWd4Desc.Value.ToString();

            if (!this.nbWd4PointValue.Text.Equals(""))
            {
                ruleUi.PointsValue = Convert.ToDecimal(this.nbWd4PointValue.Value.ToString());
            }
            if (this.PolicyStyleSub.Equals("满额送固定积分"))
            {
                ruleUi.PointsType = "固定积分";
            }
            else if (this.PolicyStyleSub.Equals("促销赠品转积分"))
            {
                ruleUi.PointsType = this.cbWd4PointType.SelectedItem.Value.ToString();
            }

            _business.InsertPolicyRuleUi(ruleUi, IsPageNew);
        }

        [AjaxMethod]
        public void FactorRuleConditionDelete(string ruleFactorId)
        {
            Hashtable obj = new Hashtable();
            obj.Add("RuleFactorId", ruleFactorId);
            obj.Add("RuleId", PolicyRuleId);
            obj.Add("CurrUser", _context.User.Id);
            _business.DeleteFactorRuleConditionUi(obj);
        }

        #endregion

        #region 页面私有方法
        /// <summary>
        /// 初始化页面
        /// </summary>
        private void InitDetailWindow()
        {
            DataTable dtRule = new DataTable();
            if (!IsPageNew)
            {
                Hashtable obj = new Hashtable();
                obj.Add("RuleId", PolicyRuleId);
                obj.Add("PolicyId", PolicyId);
                obj.Add("CurrUser", _context.User.Id);
                dtRule = _business.GetPolicyRuleUi(obj).Tables[0];
            }
            //页面赋值
            ClearFormValue();
            SetFormValue(dtRule);
            //页面控件状态
            ClearDetailWindow();
            SetDetailWindow(dtRule);
        }

        /// <summary>
        /// 清除页面控件的值
        /// </summary>
        private void ClearFormValue()
        {
            this.txtFactorValueX.Clear();
            this.txtFactorValueY.Clear();
            this.txtWd4FactorRemarkX.Clear();
            this.txtWd4FactorRemarkY.Clear();
            this.areaWd4Desc.Clear();
            this.cbWd4PolicyRuleType.SelectedItem.Value = "";
            this.cbWd4PolicyFactorX.SelectedItem.Value = "";
            this.cbWd4PolicyFactorY.SelectedItem.Value = "";
            this.hidWd4PolicyFactorX.Value = "";
            this.cbWd4PolicyFactorY.Items.Clear();

            this.cbWd4PointType.SelectedItem.Value = "";
            this.nbWd4PointValue.Clear();

            this.txtFactorValueY.FieldLabel = "Y 值";
        }

        private void SetFormValue(DataTable dtRule)
        {
            this.cbWd4PolicyRuleType.SelectedItem.Value = this.PolicyStyleSub;
            if (dtRule != null && dtRule.Rows.Count > 0)
            {
                DataRow drValues = dtRule.Rows[0];
                //this.cbWd4PolicyFactorX.SelectedItem.Value = drValues["JudgePolicyFactorId"]!=null ? drValues["JudgePolicyFactorId"].ToString():"";
                this.hidWd4PolicyFactorX.Value = drValues["JudgePolicyFactorId"] != null ? drValues["JudgePolicyFactorId"].ToString() : "";
                this.txtWd4FactorRemarkX.Text = drValues["FactDesc"] != null ? drValues["FactDesc"].ToString() : "";
                this.txtFactorValueX.Text = drValues["JudgeValue"] != null ? drValues["JudgeValue"].ToString() : "";
                this.txtFactorValueY.Text = drValues["GiftValue"] != null ? drValues["GiftValue"].ToString() : "";
                this.areaWd4Desc.Text = drValues["RuleDesc"] != null ? drValues["RuleDesc"].ToString() : "";
                this.nbWd4PointValue.Text = drValues["PointsValue"] != null ? drValues["PointsValue"].ToString() : "";
                this.cbWd4PointType.SelectedItem.Value = drValues["PointsType"] != null ? drValues["PointsType"].ToString() : "";
            }
            Hashtable obj = new Hashtable();
            obj.Add("CurrUser", _context.User.Id);
            DataTable dtGift = _business.GetIsGift(obj).Tables[0];
            if (dtGift != null && dtGift.Rows.Count > 0)
            {
                this.cbWd4PolicyFactorY.AddItem(dtGift.Rows[0]["FactName"].ToString(), dtGift.Rows[0]["GiftPolicyFactorId"].ToString());
                this.cbWd4PolicyFactorY.SelectedItem.Value = dtGift.Rows[0]["GiftPolicyFactorId"].ToString();
                this.txtWd4FactorRemarkY.Text = dtGift.Rows[0]["FactDesc"] != null ? dtGift.Rows[0]["FactDesc"].ToString() : "";
            }
            if (this.PolicyStyleSub.Equals("金额百分比积分"))
            {
                this.txtFactorValueY.FieldLabel = "赠送比例";
            }
        }

        /// <summary>
        /// 清除页面控件状态
        /// </summary>
        private void ClearDetailWindow()
        {
            this.cbWd4PolicyRuleType.Disabled = true;
            this.cbWd4PolicyFactorX.Disabled = false;
            this.cbWd4PolicyFactorY.Disabled = true;
            this.txtWd4FactorRemarkX.Disabled = false;
            this.txtWd4FactorRemarkY.Disabled = false;

            this.GridWd4RuleDetail.ColumnModel.SetHidden(5, false);
            this.btnWd4AddFactorRule.Disabled = false;
            this.btnWd4AddFactor.Disabled = false;

            //积分控制
            this.cbWd4PolicyFactorX.Hidden = false;
            this.txtWd4FactorRemarkX.Hidden = false;
            this.cbWd4PolicyFactorY.Hidden = false;
            this.txtWd4FactorRemarkY.Hidden = false;
            this.txtFactorValueX.Hidden = false;
            this.txtFactorValueY.Hidden = false;
            this.cbWd4PointType.Hidden = false;
            this.nbWd4PointValue.Hidden = false;
            this.btnWd4StandardPrice.Hidden = true;

            //this.nbWd4PointValue.Disabled = true;


        }

        /// <summary>
        /// 设定控件状态
        /// </summary>
        private void SetDetailWindow(DataTable dtRule)
        {
            if (this.PolicyStyleSub.Equals("促销赠品"))
            {
                this.cbWd4PointType.Hidden = true;
                this.nbWd4PointValue.Hidden = true;
            }
            else if (this.PolicyStyleSub.Equals("满额送固定积分"))
            {
                this.cbWd4PolicyFactorY.Hidden = true;
                this.txtWd4FactorRemarkY.Hidden = true;
                this.txtFactorValueY.Hidden = true;

                this.cbWd4PointType.Hidden = true;
            }
            else if (this.PolicyStyleSub.Equals("金额百分比积分"))
            {
                this.cbWd4PolicyFactorY.Hidden = true;
                this.txtWd4FactorRemarkY.Hidden = true;
                this.txtFactorValueX.Hidden = true;

                this.cbWd4PointType.Hidden = true;
                this.nbWd4PointValue.Hidden = true;
            }
            else if (this.PolicyStyleSub.Equals("促销赠品转积分"))
            {
                this.nbWd4PointValue.Hidden = true;

                if (dtRule != null && dtRule.Rows.Count > 0)
                {
                    DataRow drRule = dtRule.Rows[0];
                    if (drRule["PointsType"] != null && drRule["PointsType"].ToString().Equals("经销商固定积分"))
                    {
                        this.btnWd4StandardPrice.Hidden = false;
                    }
                }
            }
            else if (this.PolicyStyleSub.Equals("满额送赠品"))
            {
                this.cbWd4PointType.Hidden = true;
                this.nbWd4PointValue.Hidden = true;
            }
            else if (this.PolicyStyleSub.Equals("满额打折"))
            {
                this.cbWd4PolicyFactorY.Hidden = true;
                this.txtWd4FactorRemarkY.Hidden = true;
                this.txtFactorValueX.Hidden = true;

                this.cbWd4PointType.Hidden = true;
                this.nbWd4PointValue.Hidden = true;
            }

            if (PageType == "View")
            {
                this.GridWd4RuleDetail.ColumnModel.SetHidden(5, true);
                this.btnWd4AddFactorRule.Disabled = true;
                this.btnWd4AddFactor.Disabled = true;
            }
            else if (PageType == "Modify" && !PromotionState.Equals(SR.PRO_Status_Approving) && !PromotionState.Equals(SR.PRO_Status_Draft))
            {
                this.GridWd4RuleDetail.ColumnModel.SetHidden(5, true);
                this.btnWd4AddFactorRule.Disabled = true;
                this.btnWd4AddFactor.Disabled = true;
            }
        }
        #endregion

        #region Ajax Method For Standard Price
        [AjaxMethod]
        public void StandardPriceShow()
        {
            this.windowStandardPrice.Show();
        }
        #endregion

        #region 数据绑定 For Standard Price
        protected void ProductStandardPriceStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            Hashtable obj = new Hashtable();
            obj.Add("PolicyId", PolicyId);
            obj.Add("CurrUser", _context.User.Id);
            DataTable query = _business.QueryStandardPrice(obj, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBarStandardPrice.PageSize : e.Limit), out totalCount).Tables[0];
            (this.ProductStandardPriceStore.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
            ProductStandardPriceStore.DataSource = query;
            ProductStandardPriceStore.DataBind();
        }
        #endregion

        #region 私有方法 For Standard Price
        protected void UploadStandardPriceClick(object sender, AjaxEventArgs e)
        {
            //先删除上传人之前的数据
            _business.DeleteProductStandardPriceByUserId();
            if (this.FileUploadFieldStandardPrice.HasFile)
            {
                #region 上传文件至服务器
                System.Diagnostics.Debug.WriteLine("Upload Start : " + DateTime.Now.ToString());
                bool error = false;

                string fileName = FileUploadFieldStandardPrice.PostedFile.FileName;
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
                FileUploadFieldStandardPrice.PostedFile.SaveAs(file);

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
                        if (_business.ProductStandardPriceImport(dt, PolicyId))
                        {
                            string IsValid = string.Empty;
                            if (_business.VerifyStandardPrice(out IsValid))
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

    }
}