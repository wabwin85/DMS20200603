using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.ComponentModel;

namespace DMS.Website.Controls
{
    using Coolite.Ext.Web;
    using DMS.Website.Common;
    using DMS.Business;
    using DMS.Common;
    using DMS.Model;
    using Lafite.RoleModel.Security;

    public partial class HospitalSearchDialog : BaseUserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

    

        #region 参数 
        ///// <summary>
        ///// 医院与产品线关系
        ///// </summary> 
        //[DefaultValue(ExistsState.All)]
        //[Description("ExistsStatus: =IsExists 查询当前产品线下所有医院, =IsNotExists 查询不包含在当前产品线下医院")]
        //public ExistsState ExistsStatus
        //{
        //    get
        //    {
        //        if (this.ViewState["IsCheckProductLine"] == null)
        //            return ExistsState.All;
        //        else
        //            return (ExistsState)this.ViewState["IsCheckProductLine"];
        //    }
        //    set { this.ViewState["IsCheckProductLine"] = value; }
        //}

        /// <summary>
        /// Gets the selected product line.
        /// </summary>
        /// <value>The selected product line.</value>
        public string SelectedProductLine
        {
            get
            {
                return this.hiddenSelectedProductLine.Text;
            }
            set
            {
                this.hiddenSelectedProductLine.Text = value;
            }
        }


        #endregion

        #region Store 绑定事件
        protected void HospitalStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {

            IHospitals bll = new Hospitals();
            int totalCount = 0, start = 0, limit = 0;
            limit = this.PagingToolBar1.PageSize;
            if (e.Start > 0)
            {
                start = e.Start;
                limit = e.Limit;
            }

            Hospital param = new Hospital();

            //param.HosHospitalShortName = this.txtSearchHospitalName.Text.Trim();
            param.HosHospitalName = this.txtSearchHospitalName.Text.Trim();
            param.HosGrade = this.cmbGrade.SelectedItem.Value;

            param.HosProvince = this.cmbProvince.SelectedItem.Text.Trim();
            param.HosCity = this.cmbCity.SelectedItem.Text.Trim();
            param.HosDistrict = this.cmbDistrict.SelectedItem.Text.Trim();

            IList<Hospital> query = null;

            if (!string.IsNullOrEmpty(this.SelectedProductLine))
            {   //查询当前产品线下所有医院
                Guid lineId = new Guid(this.SelectedProductLine);
                query = bll.SelectByProductLine(param, ExistsState.IsExists, lineId, start, limit, out totalCount);
            }
            else
            {
                if (RoleModelContext.Current.User.IdentityType != SR.Consts_System_Dealer_User)
                {
                    //所有医院
                    query = bll.SelectByFilter(param, start, limit, out totalCount);
                }
                else
                {
                    //经销商的授权医院
                    query = bll.SelectHospitalListOfDealerAuthorized(param, RoleModelContext.Current.User.CorpId.Value, start, limit, out totalCount);
                }

            }

            (this.HospitalSearchDlgStore.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
            this.HospitalSearchDlgStore.DataSource = query;
            this.HospitalSearchDlgStore.DataBind();
        }


        protected void Store_RefreshCities(object sender, StoreRefreshDataEventArgs e)
        {
            e.Parameters["parentId"] = this.cmbProvince.SelectedItem.Value;

            base.Store_RefreshTerritorys(sender, e);
        }

        protected void Store_RefreshDistricts(object sender, StoreRefreshDataEventArgs e)
        {
            e.Parameters["parentId"] = this.cmbCity.SelectedItem.Value;

            base.Store_RefreshTerritorys(sender, e);
        }
        #endregion

        [AjaxMethod]
        public void SetProductLineId(string lineId)
        {
            this.hiddenSelectedProductLine.Text = lineId;
        }

        protected void SubmitSelection(object sender, AjaxEventArgs e)
        {   
            string json = e.ExtraParams["Values"];
            string disSelectJson = "[]";

            if (string.IsNullOrEmpty(json))
            {
                return;
            }
            ParameterCollection paramCollection = new ParameterCollection();
            paramCollection.AddRange(e.ExtraParams);
            paramCollection["SelectType"] = SelectTerritoryType.Default.ToString();
            //IList<Hospital> hostpitalList = JSON.Deserialize<List<Hospital>>(json);

            //IDictionary<string, string>[] hostpitals = JSON.Deserialize<Dictionary<string, string>[]>(json);
            //handle values

            if (AfterSelectedHandler != null)
            {
                //AfterSelectedHandler(new SelectedEventArgs(json));
                AfterSelectedHandler(new SelectedEventArgs(json, disSelectJson, paramCollection));
            }

            e.Success = true;

            //if (this.GridPanel1.SelectionModel.Primary is RowSelectionModel)
            //{
            //    RowSelectionModel selectModel = (RowSelectionModel)this.GridPanel1.SelectionModel.Primary;
            //    selectModel.SelectedRows.Clear();
            //    selectModel.UpdateSelection();

            //}
            //else if (this.GridPanel1.SelectionModel.Primary is CheckboxSelectionModel)
            //{
            //    CheckboxSelectionModel selectModel = (CheckboxSelectionModel)this.GridPanel1.SelectionModel.Primary;
            //    selectModel.SelectedRows.Clear();
            //    selectModel.UpdateSelection();
            //}

        }

        public AfterSelectedRow AfterSelectedHandler;

        //public delegate void AfterSelectedRow(IDictionary<string, string>[] hospitals);

        /// <summary>
        /// 设置选择器
        /// </summary>
        /// <param name="selectorType"></param>
        public void SetSelectionModel(SelectorType selectorType)
        {
            this.GridPanel1.SelectionModel.Clear();

            switch (selectorType)
            {
        
                case SelectorType.RowSelect:
                    {
                        RowSelectionModel selectModel = new RowSelectionModel();
                        //selectModel.AddListener("rowselect", "#{btnOk}.enable();");
                        this.GridPanel1.SelectionModel.Add(selectModel);
                        break; 
                    }
                case SelectorType.CheckboxSelection:
                    {
                        CheckboxSelectionModel selectModel = new CheckboxSelectionModel();
                        //selectModel.AddListener("rowselect", "#{btnOk}.enable();");
                        this.GridPanel1.SelectionModel.Add(selectModel);
                        break;
                    }
                case SelectorType.SingleSelect:
                default:
                    {
                        RowSelectionModel selectModel = new RowSelectionModel();
                        //selectModel.AddListener("rowselect", "#{btnOk}.enable();");
                        selectModel.SingleSelect = true;
                        this.GridPanel1.SelectionModel.Add(selectModel);
                        break;
                    }
            }
        }

    }
}