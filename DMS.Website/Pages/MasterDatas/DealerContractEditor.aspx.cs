using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DMS.Website.Pages.MasterDatas
{
    using DMS.Model;
    using DMS.Business;
    using DMS.Business.Cache;
    using DMS.Common;
    using DMS.Website.Common;
    using Coolite.Ext.Web;
    using Lafite.RoleModel.Security;
    using System.Data;
    using DMS.Model.Data;

    public partial class DealerContractEditor : BasePage
    {
        IRoleModelContext _context = RoleModelContext.Current;

        private IDealerContracts _dealerContractBiz = Global.ApplicationContainer.Resolve<IDealerContracts>();

        protected void Page_Load(object sender, EventArgs e)
        {
            if ((!IsPostBack) && (!Ext.IsAjaxRequest))
            {
                this.hiddenContractId.Text = this.Request.QueryString["ct"];
                //this.hiddenProductLine.Text = this.Request.QueryString["pl"];
                this.hiddenDealer.Text = this.Request.QueryString["dr"];

                if (this.hiddenDealer.Text.Trim() != string.Empty)
                {
                    Guid dealerid = new Guid(this.hiddenDealer.Text.Trim());
                    this.plAuthorization.Title = string.Format(GetLocalResourceObject("plAuthorization.TitleFormat").ToString(), DealerCacheHelper.GetDealerName(dealerid));
                }

                this.Bind_Dictionary(this.AuthTypeForSearchStore, SR.CONST_DMS_Authentication_Type);
                this.Bind_AuthTypeForEdit(this.AuthTypeForEditStore);
            }
        }

        private void Bind_AuthTypeForEdit(Store store)
        {
            IDictionary<string, string> dicts = DictionaryHelper.GetDictionary(SR.CONST_DMS_Authentication_Type);

            IList list = dicts.ToList().FindAll(item => item.Key != DealerAuthorizationType.Normal.ToString());

            store.DataSource = list;
            store.DataBind();
        }

        protected void Store1_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            if (this.ContractId != string.Empty)
            {
                Guid conId = new Guid(this.ContractId);

                //Edited By Song Yuqi On 2016-05-23 
                DealerAuthorization param = new DealerAuthorization();
                param.DclId = conId;
                if (!this.dfAuthStartBeginDate.IsNull)
                {
                    param.AuthStartBeginDate = this.dfAuthStartBeginDate.SelectedDate;
                }
                if (!this.dfAuthStartEndDate.IsNull)
                {
                    param.AuthStartEndDate = this.dfAuthStartEndDate.SelectedDate;
                }
                if (!this.dfAuthStopBeginDate.IsNull)
                {
                    param.AuthStopBeginDate = this.dfAuthStopBeginDate.SelectedDate;
                }
                if (!this.dfAuthStopEndDate.IsNull)
                {
                    param.AuthStopEndDate = this.dfAuthStopEndDate.SelectedDate;
                }
                if (!string.IsNullOrEmpty(this.cbAuthType.SelectedItem.Value))
                {
                    param.Type = this.cbAuthType.SelectedItem.Value;
                }
                if (!string.IsNullOrEmpty(this.cbProductLine.SelectedItem.Value))
                {
                    param.ProductLineBumId = new Guid(this.cbProductLine.SelectedItem.Value);
                }

                DataSet query = _dealerContractBiz.GetAuthorizationListForDataSet(param);
                this.AuthorizationStore.DataSource = query;
                this.AuthorizationStore.DataBind();
            }
        }

        protected void Store1_BeforeStoreChanged(object sender, BeforeStoreChangedEventArgs e)
        {
            //you can add own logic for save using one of above data representation and then set e.Cancel=true for canceling Store events

            if (this.ContractId != string.Empty)
            {
                string json = e.DataHandler.JsonData;
                StoreDataHandler dataHandler = new StoreDataHandler(json);

                ChangeRecords<DealerAuthorization> data = dataHandler.CustomObjectData<DealerAuthorization>();

                Guid lineId = new Guid(this.ContractId);

                _dealerContractBiz.SaveAuthorizationOfDealerChanges(data);

                e.Cancel = true;
            }
        }

        protected void Store2_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            if (this.hiddenId.Text != string.Empty)
            {
                Guid conId = new Guid(this.hiddenId.Text);

                IHospitals bll = new Hospitals();

                Hashtable table = new Hashtable();

                if (!string.IsNullOrEmpty(this.tbHospitalName.Text))
                {
                    table.Add("HosHospitalName", this.tbHospitalName.Text);
                }
                if (!this.dfHosStartBeginDate.IsNull)
                {
                    table.Add("HosStartBeginDate", this.dfHosStartBeginDate.SelectedDate.ToString("yyyy-MM-dd"));
                }
                if (!this.dfHosStartEndDate.IsNull)
                {
                    table.Add("HosStartEndDate", this.dfHosStartEndDate.SelectedDate.ToString("yyyy-MM-dd"));
                }
                if (!this.dfHosStopBeginDate.IsNull)
                {
                    table.Add("HosStopBeginDate", this.dfHosStopBeginDate.SelectedDate.ToString("yyyy-MM-dd"));
                }
                if (!this.dfHosStopEndDate.IsNull)
                {
                    table.Add("HosStopEndDate", this.dfHosStopEndDate.SelectedDate.ToString("yyyy-MM-dd"));
                }
                if (this.cbNotHasHosDate.Checked)
                {
                    table.Add("HosNoAuthDate", "1");
                }

                table.Add("AuthorizationId", conId);

                int totalCount = 0;
                IList<Hospital> query = bll.QueryAuthorizationHospitalList(table, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar2.PageSize : e.Limit), out totalCount);

                (this.Store2.Proxy[0] as DataSourceProxy).TotalCount = totalCount;

                this.Store2.DataSource = query;
                this.Store2.DataBind();
            }
        }

        protected void Store2_BeforeStoreChanged(object sender, BeforeStoreChangedEventArgs e)
        {
            //you can add own logic for save using one of above data representation and then set e.Cancel=true for canceling Store events

            if (this.hiddenId.Text != string.Empty)
            {
                Guid datId = new Guid(this.hiddenId.Text);

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

        protected void SetContractId_Click(object sender, AjaxEventArgs e)
        {
            try
            {
                this.hiddenId.Text = NewGuid();
                e.Success = true;
            }
            catch
            {
                e.Success = false;
                throw;
            }
        }

        protected void DeleteAuthorization_Click(object sender, AjaxEventArgs e)
        {

            RowSelectionModel sm = this.gplAuthorization.SelectionModel.Primary as RowSelectionModel;
            string id = sm.SelectedRow.RecordID;
            if (!string.IsNullOrEmpty(id))
            {
                bool isdeleted = _dealerContractBiz.DeleteAuthorization(new Guid(id));
                e.Success = isdeleted;
            }
        }

        public string ContractId
        {
            get
            {
                return this.hiddenContractId.Text.Trim().ToString();
            }
        }

        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);
            this.HospitalSelectorDialog1.AfterSelectedHandler += OnAfterSelectedHospitalRow;
            this.PartsSelectorDialog1.AfterSelectedHandler += OnAfterSelectedClassification;
            this.HospitalSelectdDelDialog1.AfterClosedHandler += OnAfterSelectdDelHospitalClosed;
            this.AuthSelectorDialog1.AfterCopyOkHandler += OnAfterCopyOk;
        }

        /// <summary>
        /// 选择医院后，添加数据
        /// </summary>
        /// <param name="e"></param>
        /// Edited By Song Yuqi On 2016-05-31
        protected void OnAfterSelectedHospitalRow(SelectedEventArgs e)
        {
            if (e.Parameters == null) return;

            SelectTerritoryType selectType = (SelectTerritoryType)Enum.Parse(typeof(SelectTerritoryType), e.Parameters["SelectType"]);

            IDictionary<string, string>[] sellist = e.ToDictionarys();
            IDictionary<string, string>[] disSellist = e.GetDisSelectDictionarys();

            IDictionary<string, string>[] selected = null;

            if (disSellist.Length > 0)
            {
                var query = from p in sellist
                            where disSellist.FirstOrDefault(c => c["Key"] == p["Key"]) == null
                            select p;

                selected = query.ToArray<IDictionary<string, string>>();
            }
            else

                selected = sellist;


            IDealerContracts bll = new DealerContracts();

            Guid datId = new Guid(this.hiddenId.Text);
            string hosProvince = e.Parameters["Province"];
            string hosCity = e.Parameters["City"];
            string hosDistrict = e.Parameters["District"];
            string dept = e.Parameters["Dept"];
            Guid lineId = new Guid(this.hiddenProductLine.Text);

            IList<DealerAuthorization> dealerAuth = bll.GetAuthorizationList(new DealerAuthorization() { Id = datId });

            if (dealerAuth != null && dealerAuth.Count() > 0
                    && dealerAuth.First<DealerAuthorization>().StartDate.HasValue
                    && dealerAuth.First<DealerAuthorization>().EndDate.HasValue)
            {
                bll.SaveHospitalOfAuthorization(datId, selected, selectType, hosProvince, hosCity, hosDistrict, lineId, dept
                    , dealerAuth.First<DealerAuthorization>().StartDate.Value
                    , dealerAuth.First<DealerAuthorization>().EndDate.Value);
            }
            else
            {
                Ext.Msg.Alert("Error", "请先维护授权的开始时间和截止时间").Show();
                return;
            }

            this.gplAuthHospital.Reload();
        }

        protected void OnAfterSelectedClassification(SelectedEventArgs e)
        {
            Guid catagoryId = new Guid();
            if (this.PartsSelectorDialog1.SelectedCatagory == string.Empty)
            {
                catagoryId = new Guid(this.PartsSelectorDialog1.SelectedProductLine);
            }
            else
                catagoryId = new Guid(this.PartsSelectorDialog1.SelectedCatagory);
            Guid dealerId = new Guid(this.hiddenDealer.Text);
            int flag = 0;
            string errormsg = string.Empty;
            if (!_dealerContractBiz.CheckAuthorizationParts(catagoryId, dealerId, out flag))
            {
                switch (flag)
                {
                    case 1: errormsg = GetLocalResourceObject("OnAfterSelectedClassification.ErrorMessage").ToString(); break;
                    case 2: errormsg = GetLocalResourceObject("OnAfterSelectedClassification.ErrorMessage1").ToString(); break;
                    case 3: errormsg = GetLocalResourceObject("OnAfterSelectedClassification.ErrorMessage2").ToString(); break;
                    case 4: errormsg = GetLocalResourceObject("OnAfterSelectedClassification.ErrorMessage3").ToString(); break;
                    case 5: errormsg = GetLocalResourceObject("OnAfterSelectedClassification.ErrorMessage4").ToString(); break;
                    default:
                        errormsg = GetLocalResourceObject("OnAfterSelectedClassification.ErrorMessage.default").ToString();
                        break;
                }
                e.ErrorMessage = errormsg;
                e.Success = false;
                return;
            }
            else
                e.Success = true;



            if (!string.IsNullOrEmpty(this.PartsSelectorDialog1.SelectedCatagory))
            {
                this.txtCatagoryName.Text = this.PartsSelectorDialog1.SelectedCatagoryName;
                this.hiddenCatagoryId.Text = this.PartsSelectorDialog1.SelectedCatagory;
                this.hiddenProductLine.Text = this.PartsSelectorDialog1.SelectedProductLine;
                this.txtProductLine.Text = this.PartsSelectorDialog1.SelectedProductLineName;
            }
            else if (!string.IsNullOrEmpty(this.PartsSelectorDialog1.SelectedProductLine))
            {
                this.txtProductLine.Text = this.PartsSelectorDialog1.SelectedProductLineName;
                this.hiddenCatagoryId.Text = this.PartsSelectorDialog1.SelectedProductLine;
                this.hiddenProductLine.Text = this.PartsSelectorDialog1.SelectedProductLine;
            }
        }

        protected void OnAfterSelectdDelHospitalClosed(SelectedEventArgs e)
        {
            this.gplAuthHospital.Reload();
        }

        protected void OnAfterCopyOk(object sender, EventArgs e)
        {
            this.gplAuthHospital.Reload();
        }
        /// <summary>
        /// Called when [authenticate].
        /// </summary>
        protected override void OnAuthenticate()
        {
            Permissions pers = this._context.User.GetPermissions();

            //正式使用权限时请使用Visible = false, 更安全;

            this.btnDelete.Visible = pers.IsPermissible(Business.DealerContracts.Action_DealerAuthorizations, PermissionType.Delete);
            this.btnAdd.Visible = pers.IsPermissible(Business.DealerContracts.Action_DealerAuthorizations, PermissionType.Write);
            this.btnAddHospital.Visible = this.btnAdd.Visible;
            this.btnDeleteHospital.Visible = this.btnDeleteHospital.Visible;

        }

        [AjaxMethod]
        public void SaveHosAuthDate(string Id, string AuthStartDate, string AuthEndDate)
        {

            if (!string.IsNullOrEmpty(this.hiddenId.Text) && !string.IsNullOrEmpty(Id) && !string.IsNullOrEmpty(AuthStartDate) && !string.IsNullOrEmpty(AuthEndDate))
            {
                Guid datId = new Guid(this.hiddenId.Text);
                _dealerContractBiz.SaveHositalAuthDate(datId, new Guid(Id), DateTime.Parse(AuthStartDate), DateTime.Parse(AuthEndDate));
            }
        }

        [AjaxMethod]
        public string ValidAttachment(string authId)
        {
            if (!string.IsNullOrEmpty(authId))
            {
                AttachmentBLL attachBll = new AttachmentBLL();
                DataSet ds = attachBll.GetAttachmentByMainId(new Guid(authId), AttachmentType.DealerAuthorization);

                if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                {
                    return "Success";
                }
            }

            return "Failure";
        }
    }
}
