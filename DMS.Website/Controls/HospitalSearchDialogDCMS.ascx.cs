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
    using System.Data;
    using System.Collections;
    //[AjaxMethodProxyID(IDMode = AjaxMethodProxyIDMode.Alias, Alias = "HospitalSearchDCMSDialog")]
    public partial class HospitalSearchDialogDCMS : BaseUserControl
    {
        private IContractMasterBLL _contractBll = new ContractMasterBLL();
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        #region 参数
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
        public string BeginYear
        {
            get
            {
                return (this.hiddenBeginDate.Text.Trim()+"0000").Substring(0,4);
            }
            set
            {
                ;
            }
        }
        #endregion

        #region Store 绑定事件
        protected void HospitalStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            Hidden hiddenIsEmerging = this.Parent.FindControl("hidIsEmerging") as Hidden; 

            IHospitals bll = new Hospitals();
            int totalCount = 0, start = 0, limit = 0;
            limit = this.PagingToolBar1.PageSize;
            if (e.Start > 0)
            {
                start = e.Start;
                limit = e.Limit;
            }

            Hashtable param = new Hashtable();
            param.Add("HosHospitalName", this.txtSearchHospitalName.Text.Trim());
            if (!hiddenIsEmerging.Value.ToString().Equals("2"))
            {
                param.Add("IsEmerging", hiddenIsEmerging.Value.ToString().Equals("") ? "0" : hiddenIsEmerging.Value);
            }
            param.Add("HosProvince", this.cmbProvince.SelectedItem.Text.Trim());
            param.Add("HosCity", this.cmbCity.SelectedItem.Text.Trim());
            param.Add("HosDistrict", this.cmbDistrict.SelectedItem.Text.Trim());
            param.Add("BeginYear", this.BeginYear);
           
            DataSet query = null;

            if (!string.IsNullOrEmpty(this.SelectedProductLine))
            {   //查询当前产品线下所有医院

                Guid lineId = new Guid(this.SelectedProductLine);
                param.Add("ProductLineId", lineId);
                //param.Add("HosDeletedFlag", 0);
                param.Add("HosActiveFlag", 1);
                query = bll.SelectByProductLineForDCMS(param, start, limit, out totalCount);
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

        protected void Store_HospitalGradeDCMS(object sender, StoreRefreshDataEventArgs e)
        {
            Hidden hiddenIsEmerging = this.Parent.FindControl("hidIsEmerging") as Hidden; 
            Hashtable  obj=new Hashtable();
            obj.Add("Type", SR.Consts_Hospital_Grade);

            if (hiddenIsEmerging.Value.Equals("0"))
            {
                obj.Add("KeyType", "0");
            }
            else if (hiddenIsEmerging.Value.Equals("1"))
            {
                obj.Add("KeyType", "1");
            }
            DataTable dt= _contractBll.GetHospitalGrade(obj).Tables[0];

            if (sender is Store)
            {
                Store store1 = (sender as Store);

                store1.DataSource = dt;
                store1.DataBind();
            }
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
          
            if (AfterSelectedHandler != null)
            {
                AfterSelectedHandler(new SelectedEventArgs(json, disSelectJson, paramCollection));
            }

            e.Success = true;
        }

        public AfterSelectedRow AfterSelectedHandler;

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