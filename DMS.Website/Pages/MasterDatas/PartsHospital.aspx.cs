using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DMS.Website.Pages.MasterDatas
{
    using Coolite.Ext.Web;

    using DMS.Common;
    using DMS.Website.Common;
    using DMS.Model;
    using DMS.Business;
    using Microsoft.Practices.Unity;

    using Lafite.RoleModel.Security;

    public partial class PartsHospital : BasePage
    {
        private IRoleModelContext _context = RoleModelContext.Current;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Ext.IsAjaxRequest && !IsPostBack)
            {
            }
        }



        protected void Store1_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            
            RefreshData();
        }


        private void RefreshData()
        {
            if (this.cbCatories.SelectedItem.Value != string.Empty)
            {
                string hosName = txtSearchHospitalName.Text.Trim();
                Guid lineId = new Guid(this.cbCatories.SelectedItem.Value);
                IList<Hospital> query = HospitalBiz.GetListByProductLine(lineId,hosName);

                this.StoreRecords = query;

                this.Store1.DataSource = query;
                this.Store1.DataBind();
            }
        }

        protected void Store1_BeforeStoreChanged(object sender, BeforeStoreChangedEventArgs e)
        {
            //you can add own logic for save using one of above data representation and then set e.Cancel=true for canceling Store events

            if (!string.IsNullOrEmpty(this.cbCatories.SelectedItem.Value))
            {
                string json = e.DataHandler.JsonData;
                StoreDataHandler dataHandler = new StoreDataHandler(json);

                ChangeRecords<Hospital> data = dataHandler.CustomObjectData<Hospital>();

                Guid lineId = new Guid(this.cbCatories.SelectedItem.Value);
                HospitalBiz.SaveHospitalOfProductLineChanges(data, lineId);

                e.Cancel = true;
            }
        }

        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);
            //Store myStore = this.CreateProductLinesStore(this.Form,this.cbCatories);
            this.HospitalSearchDialog1.AfterSelectedHandler += OnAfterSelectedRow;
        }

        /// <summary>
        /// 选择医院后，添加数据
        /// </summary>
        /// <param name="e"></param>
        protected void OnAfterSelectedRow(SelectedEventArgs e)
        {
            IDictionary<string, string>[] selectedRows = e.ToDictionarys();
            IList<Hospital> sellist = e.ToList<Hospital>();

            //在已选择的数据中排除已经存在的，准备待添加的数据
            var waitingAdd = selectedRows.Where<IDictionary<string, string>>(p => !IsExistsStoreRecords(p["HosId"])).ToArray<IDictionary<string, string>>();

            //更新已有关系的记录集
            if (this.StoreRecords != null)
            {
                var records = sellist.Where<Hospital>(p => !IsExistsStoreRecords(p.HosId.ToString()));
                this.StoreRecords = this.StoreRecords.Concat<Hospital>(records).ToList<Hospital>();
            }

            //添加已选择的数据
            foreach (IDictionary<string, string> row in waitingAdd)
            {
                this.GridPanel1.AddRecord(row);
            }
        }

        /// <summary>
        /// 检查指定hosId是否存在
        /// </summary>
        /// <param name="hosId"></param>
        /// <returns></returns>
        public bool IsExistsStoreRecords(string hosId)
        {
            Hospital hos = null;

            if (this.StoreRecords != null)
            {
                hos = this.StoreRecords.FirstOrDefault(p => p.HosId.ToString() == hosId);
            }
            if (hos != null)
                return true;
            else
                return false;
        }

        public IList<Hospital> StoreRecords
        {
            get
            {
                object obj = this.Session["PartsOfHospital_StoreRecords"];
                return (obj == null) ? null : (IList<Hospital>)this.Session["PartsOfHospital_StoreRecords"];
            }
            set
            {
                this.Session["PartsOfHospital_StoreRecords"] = value;
            }
        }
        private IHospitals _hospitaBiz = null;

        [Dependency]
        public IHospitals HospitalBiz
        {
            get { return _hospitaBiz; }
            set { _hospitaBiz = value; }
        }

        /// <summary>
        /// Called when [authenticate].
        /// </summary>
        protected override void OnAuthenticate()
        {
            Permissions pers = this._context.User.GetPermissions();

            //正式使用权限时请使用Visible = false, 更安全;

            this.btnDelete.Visible = pers.IsPermissible(Business.Hospitals.Action_HospitalsOfProductLine, PermissionType.Write);
            this.btnAdd.Visible = pers.IsPermissible(Business.Hospitals.Action_HospitalsOfProductLine, PermissionType.Write);
            this.btnSave.Visible = pers.IsPermissible(Business.Hospitals.Action_HospitalsOfProductLine, PermissionType.Write);

        }
    }
}
