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
    public partial class HospitalSelectdDelDialog : BaseUserControl
    {

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        #region Store 绑定事件
        protected void HospitalStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            if (this.hiddenSelectedId.Text != string.Empty)
            {
                Guid conId = new Guid(this.hiddenSelectedId.Text);

                IHospitals bll = new Hospitals();

                int totalCount = 0, start = 0, limit = 0;
                limit = this.PagingToolBar1.PageSize;
                if (e.Start > 0)
                {
                    start = e.Start;
                    limit = e.Limit;
                }
                Hospital param = new Hospital();
                param.HosHospitalName = this.txtSearchHospitalName.Text.Trim();

                param.HosProvince = this.cmbProvince.SelectedItem.Text.Trim();
                param.HosCity = this.cmbCity.SelectedItem.Text.Trim();
                param.HosDistrict = this.cmbDistrict.SelectedItem.Text.Trim();
                IList<Hospital> query = bll.SelectByAsAuthorization(param, conId, start, limit, out totalCount);

                (this.HospitalSearchDlgStore.Proxy[0] as DataSourceProxy).TotalCount = totalCount;

                this.HospitalSearchDlgStore.DataSource = query;
                this.HospitalSearchDlgStore.DataBind();
            }
        }

        protected void HospitalStore_BeforeStoreChanged(object sender, BeforeStoreChangedEventArgs e)
        {
            //you can add own logic for save using one of above data representation and then set e.Cancel=true for canceling Store events

            if (this.hiddenSelectedId.Text != string.Empty)
            {
                Guid datId = new Guid(this.hiddenSelectedId.Text);

                string json = e.DataHandler.JsonData;
                StoreDataHandler dataHandler = new StoreDataHandler(json);

                ChangeRecords<Hospital> data = dataHandler.CustomObjectData<Hospital>();

                IList<Hospital> selDeleted = data.Deleted;
                Guid[] hosList = (from p in selDeleted select p.HosId).ToArray<Guid>();

                IDealerContracts bll = new DealerContracts();
                bll.DetachHospitalFromAuthorization(datId, hosList);

                e.Cancel = true;
            }
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

        protected void SubmitSelection(object sender, AjaxEventArgs e)
        {
            string json = e.ExtraParams["Values"];

            if (AfterClosedHandler != null)
            {
                AfterClosedHandler(new SelectedEventArgs(json));
            }

            e.Success = true;

        }

        public AfterSelectedRow AfterClosedHandler;

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