using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DMS.Website.Pages.MasterDatas
{
    using DMS.Website.Common;
    using DMS.Common;
    using Coolite.Ext.Web;
    using Lafite.RoleModel.Security;
    using DMS.Model.Data;
    using System.Collections;
    using System.Data;
    using DMS.Business;
    using DMS.Model;
    using Microsoft.Practices.EnterpriseLibrary.Caching;
    using Model.DataInterface;

    public partial class DealerMaintainList : BasePage
    {
        public const string DealerCachekey = "cache-all-dealers";
        private IRoleModelContext _context = RoleModelContext.Current;
        private IDealerMasters _dealers = Global.ApplicationContainer.Resolve<IDealerMasters>();
        private IAttachmentBLL _attachmentBLL = new AttachmentBLL();


        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                if (IsDealer)
                {
                    this.GridDealerInfor.ColumnModel.SetHidden(13, true);
                    if (RoleModelContext.Current.User.CorpType.Equals(DealerType.T2.ToString()))
                    {

                        this.Bind_DealerList(this.DealerStore);
                        this.cbDealer.Disabled = true;
                        this.hidInitDealerId.Value = RoleModelContext.Current.User.CorpId.Value.ToString();
                    }
                    else if (RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()) || RoleModelContext.Current.User.CorpType.Equals(DealerType.T1.ToString()))
                    {

                        this.Bind_DealerListByFilter(this.DealerStore, true);
                        this.cbDealer.SelectedItem.Value = RoleModelContext.Current.User.CorpId.Value.ToString();
                        if (RoleModelContext.Current.User.CorpType.Equals(DealerType.T1.ToString()))
                        {
                            this.cbDealer.Disabled = true;
                        }
                    }
                    else
                    {

                        this.Bind_DealerList(this.DealerStore);
                    }
                }
                else
                {
                    this.Bind_DealerList(this.DealerStore);

                }
            }
        }

        //经销商类型
        protected void DealerTypeStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            IDictionary<string, string> dictsCompanyType = DictionaryHelper.GetDictionary(SR.Consts_Dealer_Type);
            if (sender is Store)
            {
                Store DealerTypeStore = (sender as Store);

                DealerTypeStore.DataSource = dictsCompanyType;
                DealerTypeStore.DataBind();
            }

        }
        //经销商列表
        protected void ResultStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            Hashtable param = RefreshData();

            IList<DealerMaster> query = _dealers.QueryForDealerMasterByAllUser(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);
            (this.ResultStore.Proxy[0] as DataSourceProxy).TotalCount = totalCount;

            this.ResultStore.DataSource = query;
            this.ResultStore.DataBind();
        }

        private Hashtable RefreshData()
        {
            Hashtable param = new Hashtable();
            if (!string.IsNullOrEmpty(this.cbDealer.SelectedItem.Value))
            {
                param.Add("DealerId", this.cbDealer.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.cbDealerType.SelectedItem.Value))
            {
                param.Add("DealerType", this.cbDealerType.SelectedItem.Value);
            }
            if (IsDealer && RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()))
            {
                param.Add("DealerIdLP", this._context.User.CorpId);
            }
            return param;
        }

        [AjaxMethod]
        public void ShowDealerInfo(string Id)
        {
            int totalCount = 0;
            
            IList<Interfacet2ContactInfo> query = _dealers.SelectT2ContactInfoByID(new Guid(Id), 0, this.PagingToolBar2.PageSize , out totalCount);
            
            this.ContractStore.DataSource = query;
            this.ContractStore.DataBind();
            //// 经销商法人
            //this.tfManager.Clear();
            //this.tfManagerContact1.Clear();
            //this.tfManagerContact2.Clear();
            //this.tfManagerMail1.Clear();
            //this.tfManagerMail2.Clear();
            //this.tfManagerOfficeNb1.Clear();
            //this.tfManagerOfficeNb2.Clear();
            //this.tfManagerOfficeAdr1.Clear();
            //this.tfManagerOfficeAdr2.Clear();

            ////商务联系人(2)
            //this.tfBusiness1.Clear();
            //this.tfBusiness2.Clear();
            //this.tfBusinessContact1.Clear();
            //this.tfBusinessContact2.Clear();
            //this.tfBusinessMail1.Clear();
            //this.tfBusinessMail2.Clear();
            //this.tfBusinessNub1.Clear();
            //this.tfBusinessNub2.Clear();

            ////数据联系人
            //this.tfSystemOperator.Clear();
            //this.tfSystemOperatorMail.Clear();
            //this.tfSystemOperatorMail.Clear();

            ////财务联系人
            //this.tfFinance.Clear();
            //this.tfFinanceMail.Clear();
            //this.tfFinanceContact.Clear();

            ////采购联系人
            //this.tfPurchase.Clear();
            //this.tfPurchaseContact.Clear();
            //this.tfPurchaseMail.Clear();

            //this.tfOther.Clear();



            //if (!string.IsNullOrEmpty(Id))
            //{
            //    DealerMaster dmDealer = _dealers.GetDealerMaster(new Guid(Id));
            //    if (dmDealer != null) 
            //    {
            //        this.tfManager.Value = dmDealer.ContactPerson;
            //        this.tfManagerContact1.Value = dmDealer.Phone;
            //        this.tfManagerMail1.Value = dmDealer.Email;
            //        this.tfManagerOfficeNb1.Value = dmDealer.OfficeNb;
            //        this.tfManagerOfficeAdr1.Value = dmDealer.Address;
            //        this.tfManagerContact2.Value = dmDealer.Phone2;
            //        this.tfManagerMail2.Value = dmDealer.Email2;
            //        this.tfManagerOfficeNb2.Value = dmDealer.OfficeNb2;
            //        this.tfManagerOfficeAdr2.Value = dmDealer.Address2;

            //        this.tfFinance.Value = dmDealer.Finance;
            //        this.tfFinanceContact.Value = dmDealer.FinancePhone;
            //        this.tfFinanceMail.Value = dmDealer.FinanceEmail;

            //        this.tfBusiness1.Value = dmDealer.Business1;
            //        this.tfBusinessContact1.Value = dmDealer.BusinessPhone1;
            //        this.tfBusinessMail1.Value = dmDealer.BusinessEmail1;
            //        this.tfBusiness2.Value = dmDealer.Business2;
            //        this.tfBusinessContact2.Value = dmDealer.BusinessPhone2;
            //        this.tfBusinessMail2.Value = dmDealer.BusinessEmail2;
            //        this.tfBusinessNub1.Value = dmDealer.BusinessOfficeNb1;
            //        this.tfBusinessNub2.Value = dmDealer.BusinessOfficeNb2;

            //        this.tfPurchase.Value = dmDealer.Purchase;
            //        this.tfPurchaseContact.Value = dmDealer.PurchasePhone;
            //        this.tfPurchaseMail.Value = dmDealer.PurchaseEmail;

            //        this.tfSystemOperator.Value = dmDealer.SystemOperator;
            //        this.tfSystemOperatorContact.Value = dmDealer.SystemOperatorPhone;
            //        this.tfSystemOperatorMail.Value = dmDealer.SystemOperatorEmail;

            //        this.tfOther.Value = dmDealer.ContactRemark;
            //    }
            //}
        }

        //protected void SaveDealerInfo_Click(object sender, AjaxEventArgs e)
        //{
            
        //    DealerMaster dmDealer = new DealerMaster();
        //    dmDealer.ContactPerson = this.tfManager.Text;
        //    dmDealer.Phone = this.tfManagerContact1.Text;
        //    dmDealer.Email = this.tfManagerMail1.Text;
        //    dmDealer.OfficeNb = this.tfManagerOfficeNb1.Text;
        //    dmDealer.Address = this.tfManagerOfficeAdr1.Text;
        //    dmDealer.Phone2 = this.tfManagerContact2.Text;
        //    dmDealer.Email2 = this.tfManagerMail2.Text.Trim();
        //    dmDealer.OfficeNb2 = this.tfManagerOfficeNb2.Text;
        //    dmDealer.Address2 = this.tfManagerOfficeAdr2.Text;

        //    dmDealer.Finance = this.tfFinance.Text;
        //    dmDealer.FinancePhone = this.tfFinanceContact.Text;
        //    dmDealer.FinanceEmail = this.tfFinanceMail.Text;

        //    dmDealer.Business1 = this.tfBusiness1.Text;
        //    dmDealer.BusinessPhone1 = this.tfBusinessContact1.Text;
        //    dmDealer.BusinessEmail1 = this.tfBusinessMail1.Text;
        //    dmDealer.Business2 = this.tfBusiness2.Text;
        //    dmDealer.BusinessPhone2 = this.tfBusinessContact2.Text;
        //    dmDealer.BusinessEmail2 = this.tfBusinessMail2.Text;
        //    dmDealer.BusinessOfficeNb1 = this.tfBusinessNub1.Text;
        //    dmDealer.BusinessOfficeNb2 = this.tfBusinessNub2.Text;

        //    dmDealer.Purchase = this.tfPurchase.Text;
        //    dmDealer.PurchasePhone = this.tfPurchaseContact.Text;
        //    dmDealer.PurchaseEmail = this.tfPurchaseMail.Text;

        //    dmDealer.SystemOperator = this.tfSystemOperator.Text;
        //    dmDealer.SystemOperatorPhone = this.tfSystemOperatorContact.Text;
        //    dmDealer.SystemOperatorEmail = this.tfSystemOperatorMail.Text;

        //    dmDealer.ContactRemark = this.tfOther.Text;

        //    dmDealer.Id = new Guid(this.hdDealerId.Text);
        //    int i = _dealers.UpdateDealerBaseContact(dmDealer);

        //}


        protected void ExportExcel(object sender, EventArgs e)
        {
            DataTable dt = _dealers.GetExcelDealerMasterByAllUser(RefreshData()).Tables[0];//dt是从后台生成的要导出的datatable
            this.Response.Clear();
            this.Response.Buffer = true;
            this.Response.AppendHeader("Content-Disposition", "attachment;filename=result.xls");
            this.Response.ContentEncoding = System.Text.Encoding.UTF8;
            this.Response.ContentType = "application/vnd.ms-excel";
            this.EnableViewState = false;
            this.Response.Write(ExportHelp.AddExcelHead());//显示excel的网格线
            this.Response.Write(ExportHelp.ExportTable(dt));//导出
            this.Response.Write(ExportHelp.AddExcelbottom());//显示excel的网格线
            this.Response.Flush();
            this.Response.End();
        }

        [AjaxMethod]
        public void ShowResellerRename(string ChineseName, string SapCode, string dealertype, string id)
        {
            this.hddealertype.Value = string.Empty;
            this.NewEnglishName.Value = string.Empty;
            this.NewDealerName.Value = string.Empty;
            this.EnglishName.Value = string.Empty;
            this.hdSapcode.Value = string.Empty;
            this.dealername.Value = string.Empty;
            this.dealername.Text = ChineseName;
            this.hdSapcode.Value = SapCode;
            this.EnglishName.Text = this.hidEnglish.Value.ToString();
            this.hddealertype.Value = dealertype;
            Guid dealerid = new Guid(id);
            this.DealerID.Value = dealerid;
            if (hddealertype.Value.ToString() == "T2")
            {   
                this.EnglishName.Hidden = true;
                this.NewEnglishName.Hidden = true;
               
            }
            else
            {

                this.EnglishName.Hidden = false;
                this.NewEnglishName.Hidden = false;
            }

        }
        [AjaxMethod]
        public void UpdateResellerename()
        {
            if (this.hddealertype.Value.ToString() == "T1")
            {
                if (this.NewEnglishName.Value.ToString() == "" || this.NewDealerName.Value.ToString() == "")
                {
                    Ext.Msg.Alert("提示", "请填写完整").Show();
                    return;
                }
                else
                {
                    update();
                }
            }
            else {
                if (this.NewDealerName.Value.ToString() == "")
                {
                  
                    Ext.Msg.Alert("提示", "请填写完整").Show();
                    return;
                }
                else {
                    update();

                }
            }        
        }

        //清除store 缓存
        public static void RemoveAllCache()
        {
            ICacheManager cache = CacheFactory.GetCacheManager();
            cache.GetData(DealerCachekey);
            cache.Flush();


        }


        public void update()
        {


            string IsValid = string.Empty;
            Hashtable ht = new Hashtable();
            ht.Add("NewDealerName", this.NewDealerName.Value);
            ht.Add("SapCode", this.hdSapcode.Value);
            ht.Add("DealerID", this.DealerID.Value);
            ht.Add("NewDealerEnglishName", this.NewEnglishName.Value);
            ht.Add("DealerType", this.hddealertype.Value);
            ht.Add("UserId", new Guid(_context.User.Id));
            _dealers.UpdateDealerName(ht, out IsValid);
            if (IsValid == "Success")
            {
                Ext.Msg.Show(new MessageBox.Config
                {
                    Buttons = MessageBox.Button.OK,
                    Icon = MessageBox.Icon.INFO,
                    Title = "消息",
                    Message = "修改成功！",
                });
            }
            else
            {

                Ext.Msg.Show(new MessageBox.Config
                {
                    Buttons = MessageBox.Button.OK,
                    Icon = MessageBox.Icon.ERROR,
                    Title = "消息",
                    Message = IsValid,
                });


            }
            this.hddealertype.Clear();
            this.GridDealerInfor.Reload();
            this.ResellerRename.Hidden = true;
            RemoveAllCache();

        }

    }
}
