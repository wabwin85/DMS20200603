using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DMS.Website.Common;
using Coolite.Ext.Web;
using DMS.Business.Cache;
using Lafite.RoleModel.Security;
using DMS.Business.DPInfo;
using System.Data;
using DMS.Model;
using System.Collections;
using Fulper.ExpressionParser;

namespace DMS.Website.Pages.DPInfo
{
    using System.Reflection;
    public partial class DPScoreCardInfo : BasePage
    {
        IRoleModelContext _context = RoleModelContext.Current;

        public Guid DealerId
        {
            get
            {
                return new Guid(this.hidDealerId.Text);
            }
            set
            {
                this.hidDealerId.Text = value.ToString();
            }
        }

        public Guid InstanceId
        {
            get
            {
                return new Guid(this.hidInstanceId.Text);
            }
            set
            {
                this.hidInstanceId.Text = value.ToString();
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                //this.btnSubmit.Visible = false;

                if (Request.QueryString["id"] == null || string.IsNullOrEmpty(Request.QueryString["id"].ToString()))
                    throw new Exception("传递参数错误");
                this.DealerId = new Guid(Request.QueryString["id"].ToString());
                this.InstanceId = Guid.NewGuid();
                this.tbCreateDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
                InitData();
            }
        }

        protected void YearMonthStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            DpStatementBLL bll = new DpStatementBLL();
            Hashtable ht = new Hashtable();
            //this.DealerId =new Guid("A00FCD75-951D-4D91-8F24-A29900DA5E85");
            ht.Add("DealerId", this.DealerId);
            this.YearMonthStore.DataSource = bll.GetDealerFinanceStatementYearMonthList(ht);
            this.YearMonthStore.DataBind();
        }

        [AjaxMethod]
        public void Calculation()
        {
            GetFormValues();
        }

        [AjaxMethod]
        public void Save()
        {
            DpStatementScorecardHeader header = new DpStatementScorecardHeader();
            header.Id = this.InstanceId;
            header.DmaId = this.DealerId;
            header.Version = DateTime.Now.ToString("yyyyMMdd-HHmmss");
            header.Status = "已提交";
            header.CreateUser = new Guid(this._context.User.Id);
            header.CreateDate = DateTime.Now;

            DpScoreCardBLL bll = new DpScoreCardBLL();
            bll.Save(header, GetFormValues());
        }

        protected void ExportExcel(object sender, EventArgs e)
        {
            DPScoreCardExport export = new DPScoreCardExport();
            Hashtable tb = GetFormValues();
            export.Export(this.tbDealerCode.Text, this.tbDealerName.Text, this.tbCreateDate.Text, tb);
        }

        private Hashtable GetFormValues()
        {
            DpScoreCardBLL bll1 = new DpScoreCardBLL();
            DpStatementBLL bll2 = new DpStatementBLL();

            Hashtable ht = bll1.CalculateScoreCard(this.DealerId, this.tbSD26.SelectedItem.Value, this.tbSE26.SelectedItem.Value);

            RPNParser parser = new RPNParser();
            this.AddVLookUpItemByType(parser, "CONST_DPStatementScoreCard_C6");
            this.AddVLookUpItemByType(parser, "CONST_DPStatementScoreCard_D6");
            this.AddVLookUpItemByType(parser, "CONST_DPStatementScoreCard_D8");
            this.AddVLookUpItemByType(parser, "CONST_DPStatementScoreCard_E19");
            this.AddVLookUpItemByType(parser, "CONST_DPStatementScoreCard_E20");
            this.AddVLookUpItemByType(parser, "CONST_DPStatementScoreCard_E21");
            this.AddVLookUpItemByType(parser, "CONST_DPStatementScoreCard_E22");
            this.AddVLookUpItemByType(parser, "CONST_DPStatementScoreCard_E23");
            this.AddVLookUpItemByType(parser, "CONST_DPStatementScoreCard_E40");
            this.AddVLookUpItemByType(parser, "CONST_DPStatementScoreCard_E41");
            this.AddVLookUpItemByType(parser, "CONST_DPStatementScoreCard_E42");
            this.AddVLookUpItemByType(parser, "CONST_DPStatementScoreCard_E43");
            this.AddVLookUpItemByType(parser, "CONST_DPStatementScoreCard_G27");
            this.AddVLookUpItemByType(parser, "CONST_DPStatementScoreCard_G28");
            this.AddVLookUpItemByType(parser, "CONST_DPStatementScoreCard_G29");
            this.AddVLookUpItemByType(parser, "CONST_DPStatementScoreCard_G30");
            this.AddVLookUpItemByType(parser, "CONST_DPStatementScoreCard_G32");
            this.AddVLookUpItemByType(parser, "CONST_DPStatementScoreCard_G33");
            this.AddVLookUpItemByType(parser, "CONST_DPStatementScoreCard_G34");
            this.AddVLookUpItemByType(parser, "CONST_DPStatementScoreCard_G35");
            this.AddVLookUpItemByType(parser, "CONST_DPStatementScoreCard_G36");
            this.AddVLookUpItemByType(parser, "CONST_DPStatementScoreCard_G6");

            DataSet ds = bll2.SelectDealerFinanceStatementFieldByType("ScoreCard");
            if (ds != null && ds.Tables[0].Rows.Count > 0)
            {
                object ctrl = null;
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    ctrl = this.Page.FindControl("tb" + dr["Key"].ToString());

                    if (ctrl != null)
                    {
                        if (ctrl is NumberField)
                        {
                            if (dr["Formula"] == DBNull.Value)
                            {
                                (ctrl as NumberField).Text = (ctrl as NumberField).Text.Replace(",", "");
                                ht.Add(dr["Key"].ToString(), string.IsNullOrEmpty((ctrl as NumberField).Text) ? "0" : (ctrl as NumberField).Text);
                            }
                            else
                            {
                                //计算
                                object val = parser.EvaluateExpression(dr["Formula"].ToString(), ht);
                                ht.Add(dr["Key"].ToString(), val.ToString());
                                (ctrl as NumberField).Text = val.ToString();
                            }
                        }

                        if (ctrl is TextField)
                        {
                            if (dr["Formula"] == DBNull.Value)
                            {
                                (ctrl as TextField).Text = (ctrl as TextField).Text.Replace(",", "");
                                ht.Add(dr["Key"].ToString(), string.IsNullOrEmpty((ctrl as TextField).Text) ? "0" : (ctrl as TextField).Text);
                            }
                            else
                            {
                                //计算
                                object val = parser.EvaluateExpression(dr["Formula"].ToString(), ht);
                                ht.Add(dr["Key"].ToString(), val.ToString());
                                (ctrl as TextField).Text = val.ToString();
                            }
                        }

                        if (ctrl is ComboBox)
                        {
                            if (dr["Formula"] == DBNull.Value)
                            {
                                ht.Add(dr["Key"].ToString(), string.IsNullOrEmpty((ctrl as ComboBox).SelectedItem.Value) ? "0" : (ctrl as ComboBox).SelectedItem.Value);
                            }
                            else
                            {
                                //计算
                                object val = parser.EvaluateExpression(dr["Formula"].ToString(), ht);
                                ht.Add(dr["Key"].ToString(), val.ToString());
                                (ctrl as ComboBox).SelectedItem.Value = val.ToString();
                            }
                        }

                        System.Diagnostics.Debug.WriteLine(string.Format("{0} = {1}", dr["Key"].ToString(), ht[dr["Key"].ToString()].ToString()));
                    }
                    else
                    {
                        if (dr["Formula"] == DBNull.Value)
                        {
                            ht.Add(dr["Key"].ToString(), "0");
                        }
                        else
                        {
                            //计算
                            object val = parser.EvaluateExpression(dr["Formula"].ToString(), ht);
                            ht.Add(dr["Key"].ToString(), val.ToString());
                        }
                    }
                }
            }

            return ht;
        }

        private void InitData()
        {
            DealerMaster dealer = DealerCacheHelper.GetDealerById(this.DealerId);
            this.tbDealerCode.Text = dealer.SapCode;
            this.tbDealerName.Text = dealer.ChineseName;

            DpScoreCardBLL bll = new DpScoreCardBLL();
            DpStatementScorecardHeader head = bll.GetCurrentScoreCardVersion(this.DealerId.ToString());
            if (head != null)
            {
                DpStatementScorecard sc = new DpStatementScorecard();
                sc.SthId = head.Id;
                IList<DpStatementScorecard> list = bll.SelectByFilter(sc);
                if (list.Count > 0)
                {
                    foreach (DpStatementScorecard detail in list)
                    {
                        Control c = this.Page.FindControl("tb" + detail.Key);
                        if (c != null && c is TextField)
                        {
                            (c as TextField).Text = detail.Value;
                        }
                        else if (c != null && c is NumberField)
                        {
                            (c as NumberField).Text = detail.Value;
                        }
                        else if (c != null && c is ComboBox)
                        {
                            (c as ComboBox).SelectedItem.Value = detail.Value;
                        }
                    }
                }
            }
            else
            {
                DataTable dt = bll.GetDealerCooperationYears(this.DealerId.ToString());
                if (dt.Rows.Count > 0 && dt.Rows[0]["CooperationYear"] != null && !String.IsNullOrEmpty(dt.Rows[0]["CooperationYear"].ToString()))
                {
                    tbSD42.Text = dt.Rows[0]["CooperationYear"].ToString();
                }
            }
        }

        private void AddVLookUpItemByType(RPNParser parser, string type)
        {
            IDictionary<string, string> dict = DictionaryCacheHelper.GetDictionary(type);
            foreach (var item in dict)
            {
                parser.AddVLookUpItem(new VLookUpItem { Type = type, Key = item.Key, Value = item.Value });
            }
        }
    }
}
