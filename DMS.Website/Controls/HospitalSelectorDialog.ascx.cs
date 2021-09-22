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

    public partial class HospitalSelectorDialog :BaseUserControl
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

            IDictionary<string, string> storeData = null;

            string hosProvince = this.cmbProvince.SelectedItem.Value;
            string hosCity = this.cmbCity.SelectedItem.Value;
            string hosDistrict = this.cmbDistrict.SelectedItem.Value;
            string hosName = this.txtHospital.Text;

            if (string.IsNullOrEmpty(hosProvince) && string.IsNullOrEmpty(hosName)) return;


            if ((!string.IsNullOrEmpty(hosCity) && !string.IsNullOrEmpty(hosDistrict)) || !string.IsNullOrEmpty(hosName))
            {

                IHospitals bll = new Hospitals();

                Hospital param = new Hospital();

                param.HosProvince = this.cmbProvince.SelectedItem.Text.Trim();
                param.HosCity = this.cmbCity.SelectedItem.Text.Trim();
                param.HosDistrict = this.cmbDistrict.SelectedItem.Text.Trim();
                param.HosHospitalName = this.txtHospital.Text;
                //param.HosHospitalShortName = this.txtHospital.Text;

                IList<Hospital> query = null;

                if (!string.IsNullOrEmpty(this.SelectedProductLine))
                {   //查询当前产品线下所有医院

                    Guid lineId = new Guid(this.SelectedProductLine);
                    query = bll.SelectByProductLine(param, ExistsState.IsExists, lineId);
                }
                else
                {
                    //所有医院

                    query = bll.SelectByFilter(param);
                }
                storeData = query.ToDictionary(c => c.HosId.ToString(), c => c.HosHospitalName);
            }
            else if (!string.IsNullOrEmpty(hosCity))
            {
                ITerritorys bll = new Territorys();

                IList<Territory> cities = bll.GetTerritorysByParent(new Guid(hosCity));
                storeData = cities.ToDictionary(c => c.TerId.ToString(), c => c.Description);
            }
            else
            {
                ITerritorys bll = new Territorys();

                IList<Territory> cities = bll.GetTerritorysByParent(new Guid(hosProvince));
                storeData = cities.ToDictionary(c => c.TerId.ToString(), c => c.Description);
            }

            if (sender is Store)
            {
                Store store1 = (sender as Store);
                store1.DataSource = storeData;
                store1.DataBind();
            }
        }

        protected void BtnQuery_Clicked(object sender, AjaxEventArgs e)
        {
            IDictionary<string, string> storeData = null;

            string hosProvince = this.cmbProvince.SelectedItem.Value;
            string hosCity = this.cmbCity.SelectedItem.Value;
            string hosDistrict = this.cmbDistrict.SelectedItem.Value;
            string hosName = this.txtHospital.Text;

            if (string.IsNullOrEmpty(hosProvince) && string.IsNullOrEmpty(hosName)) return;


            IHospitals bll = new Hospitals();

            Hospital param = new Hospital();

            param.HosProvince = this.cmbProvince.SelectedItem.Text.Trim();
            param.HosCity = this.cmbCity.SelectedItem.Text.Trim();
            param.HosDistrict = this.cmbDistrict.SelectedItem.Text.Trim();
            param.HosHospitalName = this.txtHospital.Text;
            //param.HosHospitalShortName = this.txtHospital.Text;

            IList<Hospital> query = null;

            if (!string.IsNullOrEmpty(this.SelectedProductLine))
            {   //查询当前产品线下所有医院

                Guid lineId = new Guid(this.SelectedProductLine);
                query = bll.SelectByProductLine(param, ExistsState.IsExists, lineId);
            }
            else
            {
                //所有医院

                query = bll.SelectByFilter(param);
            }
            storeData = query.ToDictionary(c => c.HosId.ToString(), c => c.HosHospitalName);

            this.HospitalSelectStore.DataSource = storeData;
            this.HospitalSelectStore.DataBind();
            //this.hospitalSelectorDlg.
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
            string selectJson = e.ExtraParams["SelectValues"];
            string disSelectJson = "[]";// e.ExtraParams["DisSelectValues"];

            if (string.IsNullOrEmpty(selectJson))
            {
                return;
            }

            ParameterCollection paramCollection = new ParameterCollection();
            paramCollection.AddRange(e.ExtraParams);

            //paramCollection["Dept"] = this.txtDept.Text;

            if (this.cmbDistrict.SelectedItem.Value != string.Empty || this.txtHospital.Text != string.Empty)
                paramCollection["SelectType"] = SelectTerritoryType.Default.ToString();
            else
            {
                if(this.cmbCity.SelectedItem.Value == string.Empty)
                    paramCollection["SelectType"] = SelectTerritoryType.City.ToString();
                else
                    paramCollection["SelectType"] = SelectTerritoryType.District.ToString();

                paramCollection["City"] = this.cmbCity.SelectedItem.Text;
                paramCollection["Province"] = this.cmbProvince.SelectedItem.Text;
                paramCollection["District"] = this.cmbDistrict.SelectedItem.Text;
            }

            if (AfterSelectedHandler != null)
            {
                AfterSelectedHandler(new SelectedEventArgs(selectJson,disSelectJson,paramCollection));
            }

            e.Success = true;

        }

        
        public AfterSelectedRow AfterSelectedHandler;
    }
}