using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Collections;

namespace DMS.Website.Pages.MasterDatas
{
    using Coolite.Ext.Web;
    using Lafite.RoleModel.Security;

    using DMS.Website.Common;
    using DMS.Business;
    using DMS.Model;
    using DMS.Common;

    public partial class CFNHospitalPrice : BasePage
    {
        #region 公共
        IRoleModelContext _context = RoleModelContext.Current;
        private ICFNHospitalPriceBLL _bll = Global.ApplicationContainer.Resolve<ICFNHospitalPriceBLL>();
        #endregion

        #region 当前属性
        public bool IsPageNew
        {
            get
            {
                return (this.hidIsPageNew.Text == "False" ? false : true);
            }
            set
            {
                this.hidIsPageNew.Text = value.ToString();
            }
        }
        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                Permissions pers = this._context.User.GetPermissions();
                this.btnSearch.Visible = pers.IsPermissible(Business.CFNHospitalPriceBLL.Action_CFNHospitalPrice, PermissionType.Read);
                this.btnInsert.Visible = pers.IsPermissible(Business.CFNHospitalPriceBLL.Action_CFNHospitalPrice, PermissionType.Write);
                this.btnSave.Visible = pers.IsPermissible(Business.CFNHospitalPriceBLL.Action_CFNHospitalPrice, PermissionType.Write);
                this.btnDelete.Visible = pers.IsPermissible(Business.CFNHospitalPriceBLL.Action_CFNHospitalPrice, PermissionType.Write);
            }
        }

        protected override void OnInit(EventArgs e)
        {
                base.OnInit(e);
                this.HospitalSelectorDialog1.AfterSelectedHandler += this.OnAfterSelectedHospitalRow;
        }

        #region 和Controls关联的方法
        protected void OnAfterSelectedHospitalRow(SelectedEventArgs e)
        {
            IDictionary<string, string>[] selectedRows = e.ToDictionarys();
            
            SelectTerritoryType selectType = (SelectTerritoryType)Enum.Parse(typeof(SelectTerritoryType), e.Parameters["SelectType"]); 

            string hosProvince = e.Parameters["Province"];
            string hosCity = e.Parameters["City"];
            string hosDistrict = e.Parameters["District"];

            string product = hiddenProductLine.Text;
            //添加已选择的数据

            IList<Hospital> hoslist = _bll.getHospitalList(new Guid(product), selectedRows, selectType, hosProvince, hosCity, hosDistrict);

            IList<Hospital> waitingAdd = hoslist.Where<Hospital>(p => !this.IsExistsStoreRecords(p.HosId)).ToList<Hospital>();

            IList<CfnHospitalPrice> sellist = new List<CfnHospitalPrice>();
            foreach (Hospital hos in waitingAdd)
            {
                CfnHospitalPrice item = new CfnHospitalPrice();
                item.Id = new Guid();
                item.HosId = hos.HosId;
                item.HospitalName = hos.HosHospitalName;
                item.Province = hos.HosProvince;
                item.City = hos.HosCity;
                item.District = hos.HosDistrict;
                item.Grade = hos.HosGrade;
                item.Price = 0;
                sellist.Add(item);
            }
            //更新已有关系的记录集
            if (this.StoreRecords != null)
            {
                this.StoreRecords = this.StoreRecords.Concat<CfnHospitalPrice>(sellist).ToList<CfnHospitalPrice>();

            }
            else
            {
                this.StoreRecords = sellist;
            }

            foreach (Hospital hos in waitingAdd)
            {
                IDictionary<string, string> newRow = new Dictionary<string, string>();
                //Id
                newRow.Add("Id", Guid.NewGuid().ToString());
                //HosId 
                newRow.Add("HosId", hos.HosId.ToString());
                //HospitalName
                newRow.Add("HospitalName", hos.HosHospitalName);
                //Province
                newRow.Add("Province", hos.HosProvince);
                //City
                newRow.Add("City", hos.HosCity);
                //District
                newRow.Add("District", hos.HosDistrict);
                //Grade
                newRow.Add("Grade", hos.HosGrade);
                //Price
                newRow.Add("Price", "0");
                this.DetailPanel.AddRecord(newRow);
            }

        }
        #endregion

        #region store
        protected void Store1_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;

            Hashtable param = new Hashtable();

            if (this.cbProduct.SelectedItem.Value != "" && this.cbProduct.SelectedItem.Text.Trim() != "")
            {
                param.Add("ProductLineBumId", new Guid(this.cbProduct.SelectedItem.Value));
            }
            if (!string.IsNullOrEmpty(this.txtArtNum.Text.Trim()))
            {
                param.Add("CustomerFaceNbr", this.txtArtNum.Text.Trim());
            }
            if (!string.IsNullOrEmpty(this.txtHospitalName.Text.Trim()))
            {
                param.Add("HospitalName", this.txtHospitalName.Text.Trim());
            }
            param.Add("DeletedFlag", "0");

            IList<CfnHospitalPrice> query = _bll.SelectByFilter(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar2.PageSize : e.Limit), out totalCount);

            e.TotalCount = totalCount;

            this.Store1.DataSource = query;
            this.Store1.DataBind();
        }

        protected void DetailStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {

            setDetailValue();

            int totalCount = 0;

            Hashtable param = new Hashtable();


            if (this.txtProduct.SelectedItem.Value != "" && this.txtProduct.SelectedItem.Text.Trim() != "")
            {
                param.Add("ProductLineBumId", new Guid(this.txtProduct.SelectedItem.Value));
            }
            if (!string.IsNullOrEmpty(this.txtArticleNumber.Text.Trim()))
            {
                param.Add("CustomerFaceNbr", this.txtArticleNumber.Text.Trim());
            }

            param.Add("DeletedFlag", "0");

            IList<CfnHospitalPrice> query = _bll.SelectByFilter(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar2.PageSize : e.Limit), out totalCount);

            e.TotalCount = totalCount;

            StoreRecords = query;

            this.Store2.DataSource = query;
            this.Store2.DataBind();
        }

        protected void DetailStore_BeforeStoreChanged(object sender, BeforeStoreChangedEventArgs e)
        {
            string json = e.DataHandler.JsonData;
            StoreDataHandler dataHandler = new StoreDataHandler(json);

            ChangeRecords<CfnHospitalPrice> data = dataHandler.CustomObjectData<CfnHospitalPrice>();

            _bll.SaveChanges(data, new Guid(this.hiddenProductLine.Text), new Guid(this.hiddenCFNId.Text));

            e.Cancel = true;
        }

        protected void Store1_BeforeStoreChanged(object sender, BeforeStoreChangedEventArgs e)
        {
            //you can add own logic for save using one of above data representation and then set e.Cancel=true for canceling Store events

            string json = e.DataHandler.JsonData;
            StoreDataHandler dataHandler = new StoreDataHandler(json);

            ChangeRecords<CfnHospitalPrice> data = dataHandler.CustomObjectData<CfnHospitalPrice>();

            _bll.SaveChanges(data);

            e.Cancel = true;

        }

        #endregion

        #region AjaxMethod

        [AjaxMethod]
        public void Show()
        {
            ClearValue(true);
        }
        [AjaxMethod]
        public void ChangeProductLine(string flag)
        {
            ClearValue(Convert.ToBoolean(flag));
        }

        [AjaxMethod]
        public void DeleteItem(String id)
        {
            this.StoreRecords.Remove(this.StoreRecords.First<CfnHospitalPrice>(p => p.HosId.ToString() == id));
            this.DetailPanel.DeleteSelected();
        }
        #endregion

        #region 私有方法

        private bool IsExistsStoreRecords(Guid id)
        {
            //Hospital hos = null;
            CfnHospitalPrice hos = null;

            if (this.StoreRecords != null)
            {
                hos = this.StoreRecords.FirstOrDefault(p => p.HosId.Value == id);
            }

            if (hos != null)
                return true;
            else
                return false;
        }

        private IList<CfnHospitalPrice> StoreRecords
        {
            get
            {
                object obj = this.Session["HosptialOfCatagory_StoreRecords"];
                return (obj == null) ? null : (IList<CfnHospitalPrice>)this.Session["HosptialOfCatagory_StoreRecords"];
            }
            set
            {
                this.Session["HosptialOfCatagory_StoreRecords"] = value;
            }
        }

        private void ClearValue(bool flag)
        {
            this.txtChineseName.Clear();
            this.txtEnglishName.Clear();
            this.txtDescription.Clear();
            this.btnAddItem.Disabled = true;
            this.hiddenProductLine.Clear();
            this.hiddenCFNId.Clear();
            this.hidIsModified.Clear();
            this.txtArticleNumber.Clear();
            if (flag)
            {
                this.txtProduct.SelectedItem.Text = "";
            }
        }

        private void setDetailValue()
        {
            Cfn param = new Cfn();
            param.CustomerFaceNbr = this.txtArticleNumber.Text.Trim();
            param.DeletedFlag = false;
            IList<Cfn> List = (new Cfns()).SelectByCustomerFaceNbr(param);

            if (List.Count > 0)
            {
                Cfn cfn = List.First<Cfn>();

                this.txtChineseName.Text = !string.IsNullOrEmpty(cfn.ChineseName) ? cfn.ChineseName : "";
                this.txtEnglishName.Text = !string.IsNullOrEmpty(cfn.EnglishName) ? cfn.EnglishName : "";
                this.txtDescription.Text = !string.IsNullOrEmpty(cfn.Description) ? cfn.Description : "";

                this.hiddenCFNId.Text = !string.IsNullOrEmpty(cfn.Id.ToString()) ? cfn.Id.ToString() : "";
                this.hiddenProductLine.Text = !string.IsNullOrEmpty(txtProduct.SelectedItem.Value) ? txtProduct.SelectedItem.Value : "";
                this.btnAddItem.Disabled = false;
            }
        }
        #endregion
    }
}
