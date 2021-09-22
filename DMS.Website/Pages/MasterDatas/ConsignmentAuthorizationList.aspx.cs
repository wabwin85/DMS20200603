using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Collections;
namespace DMS.Website.Pages.MasterDatas
{
    using DMS.Model;
    using DMS.Business;
    using DMS.Business.Cache;
    using DMS.Common;
    using DMS.Website.Common;
    using Coolite.Ext.Web;
    using Lafite.RoleModel.Security;
    
    using Microsoft.Practices.Unity;
    public partial class ConsignmentAuthorizationList : BasePage
    {
        IRoleModelContext _context = RoleModelContext.Current;
        IConsignmentMasterBLL AuthorizationBLL = new ConsignmentMasterBLL();

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
                ConsignmentMasterStoreBind();
                StatusSotreBind();
                this.Bind_ProductLine(this.ProductLineStore);

                this.btnSearch.Enabled = _context.IsInRole("Administrators") || _context.IsInRole("经销商短期寄售管理员");
                this.btnInsert.Enabled = _context.IsInRole("Administrators") || _context.IsInRole("经销商短期寄售管理员");
                this.PagingToolBar1.Enabled = _context.IsInRole("Administrators") || _context.IsInRole("经销商短期寄售管理员");
            }
        }
        public void ClearWindow()
        {
            hidDelare.Clear();
            hidInstanceId.Clear();
            hidProducdId.Clear();
            hidrtnVal.Clear();
            hidrtnMesg.Clear();
            hidAuthorizationStatus.Text=string.Empty;
            cbChoiceConsignmentName.SelectedItem.Value = string.Empty;
            cbChoiceProcductline.SelectedItem.Value = string.Empty;
            cbChoiceDelare.SelectedItem.Value = string.Empty;
            dtStartDate.Clear();
            dtEndDate.Clear();
            cbxstatus.Checked = true;
           


        }
        public void AssingFrom(DataSet ds)
        {
             
            if (ds != null)
            {
                if (ds.Tables[0].Rows.Count > 0)
                {
                    cbChoiceDelare.SelectedItem.Value = ds.Tables[0].Rows[0]["CA_DMA_ID"].ToString();
                    ProductBind();
                    cbChoiceProcductline.SelectedItem.Value = ds.Tables[0].Rows[0]["CA_ProductLine_Id"].ToString();
                    ChoiceConsignmenBind();
                    cbChoiceConsignmentName.SelectedItem.Value = ds.Tables[0].Rows[0]["CA_CM_ID"].ToString();
                    dtStartDate.SelectedDate = Convert.ToDateTime(ds.Tables[0].Rows[0]["CA_StartDate"]);
                    dtEndDate.SelectedDate = Convert.ToDateTime(ds.Tables[0].Rows[0]["CA_EndDate"]);
                    hidAuthorizationStatus.Text = ds.Tables[0].Rows[0]["CA_IsActive"].ToString();
                }
            }
        }
        public void SetAddCfnSetBtnHidden()
        {
            if (hidAuthorizationStatus.Text == "True")
            {
                cbChoiceDelare.Disabled = true;
                cbChoiceProcductline.Disabled = true;
                cbChoiceConsignmentName.Disabled = true;
                dtStartDate.Disabled = true;
                dtEndDate.Disabled = true;
                SaveButton.Hide();
                UpdataButton.Show();
                StopButton.Show();
                Btnrecovery.Hide();
                cbxstatus.Checked = true;
            }
            else if (hidAuthorizationStatus.Text == "False")
            {
                cbChoiceDelare.Disabled = true;
                cbChoiceProcductline.Disabled = true;
                cbChoiceConsignmentName.Disabled = true;
                dtStartDate.Disabled = true;
                dtEndDate.Disabled = true;
                UpdataButton.Hide();
                SaveButton.Hide();
                StopButton.Hide();
                UpdataButton.Hide();
                Btnrecovery.Show();
                cbxstatus.Checked = false;
            }
            else {
                cbChoiceDelare.Disabled = false;
                cbChoiceProcductline.Disabled = false;
                cbChoiceConsignmentName.Disabled = false;
                dtStartDate.Disabled = false;
                dtEndDate.Disabled = false;
                UpdataButton.Hide();
                StopButton.Hide();
                Btnrecovery.Hide();
                SaveButton.Show();
            }
        }
        public void ProductBind()
        {
            cbChoiceProcductline.SelectedItem.Value = string.Empty;
            DataSet ds = AuthorizationBLL.GetDelareProductLineby(cbChoiceDelare.SelectedItem.Value);
            ChoiceProceDuctLine.DataSource = ds;
            ChoiceProceDuctLine.DataBind();
        }
        public void ChoiceConsignmenBind()
        {
            DataSet ds = AuthorizationBLL.GetProductLineConsignmenby(cbChoiceProcductline.SelectedItem.Value, cbChoiceDelare.SelectedItem.Value);
            ChoiceConsignmenStore.DataSource = ds;
            ChoiceConsignmenStore.DataBind();

        }
       
        #region ajax
        [AjaxMethod]
        public void Show(string id)
        {
            ClearWindow();
          
            this.InstanceId = new Guid(id);
            if (this.InstanceId != Guid.Empty)
            {
                DataSet ds = AuthorizationBLL.SelecConsignmentAuthorizationby(this.InstanceId.ToString());
                AssingFrom(ds);
            }
          
            SetAddCfnSetBtnHidden();
            ContractsEditorWindow.Show();
           
        }
        [AjaxMethod]
        public void DelareChang()
        {
            hidProducdId.Clear();
            ProductBind();

        }
        [AjaxMethod]
        public void ProductLineChan()
        {
           
            cbConsignmentName.SelectedItem.Value = string.Empty;
            ChoiceConsignmenBind();
        }
        [AjaxMethod]
        public void Update()
        {
            dtStartDate.Disabled = false;
            dtEndDate.Disabled = false;
            SaveButton.Show();

        }
        [AjaxMethod]
        public void Sumbit()
        {
            bool bl = false;
          
            ConsignmentMaster Cmast = new ConsignmentMaster();
            Cmast = AuthorizationBLL.GetConsignmentMasterKey(new Guid(cbChoiceConsignmentName.SelectedItem.Value));
            if (InstanceId == Guid.Empty)
            {

                Hashtable ht = new Hashtable();
                ht.Add("DMAID", cbChoiceDelare.SelectedItem.Value);
                ht.Add("ProductLineId", cbChoiceProcductline.SelectedItem.Value);
                ht.Add("CMID",cbChoiceConsignmentName.SelectedItem.Value);
                ht.Add("IsActive", true);
                ht.Add("StartDate", dtStartDate.SelectedDate);
                ht.Add("EndDate", dtEndDate.SelectedDate);
                ht.Add("Remark", "");
                ht.Add("UserId", _context.User.Id);
                ht.Add("CMStartDate", Cmast.StartDate);
                ht.Add("CMEndDate", Cmast.EndDate);
                if ((dtStartDate.SelectedDate >= Cmast.StartDate && dtStartDate.SelectedDate <=Cmast.EndDate) && (dtEndDate.SelectedDate >= Cmast.StartDate && dtEndDate.SelectedDate <=Cmast.EndDate))
                {
                    DataSet Cds = AuthorizationBLL.SelecConsignmentAuthorizationCount(ht);
                    if (int.Parse(Cds.Tables[0].Rows[0]["Cnt"].ToString()) == 0)
                    {
                        bl = AuthorizationBLL.InsertConsignmentAuthorizationby(ht);
                        hidrtnVal.Text = "Susses";
                    }
                    else {
                        hidrtnVal.Text = "Error";
                        hidrtnMesg.Text = "该产品线和经销商已经授权";
                    }
                }
                else
                {
                    hidrtnVal.Text = "Error";
                    hidrtnMesg.Text = "开始时间和结束时间必须在寄售规则时间内";
                }

            }
            else {
                if ((dtStartDate.SelectedDate >=Cmast.StartDate && dtStartDate.SelectedDate <= Cmast.EndDate) && (dtEndDate.SelectedDate >= Cmast.StartDate && dtEndDate.SelectedDate <=Cmast.EndDate))
                {
                    Hashtable tb = new Hashtable();
                    tb.Add("StartDate", dtStartDate.SelectedDate);
                    tb.Add("EndDate", dtEndDate.SelectedDate);
                    tb.Add("CAID", this.InstanceId);
                    bl = AuthorizationBLL.UpdateConsignmentAuthorizationby(tb);
                    hidrtnVal.Text = "Susses";
                }
                else {
                    hidrtnVal.Text = "Error";
                    hidrtnMesg.Text = "开始时间和结束时间必须在寄售规则时间内";
                }
            }
        }
        [AjaxMethod]
        public void Stop()
        {
            bool bl = false;
            bl=AuthorizationBLL.Updatstopby(this.InstanceId.ToString());
            if (bl)
            {
                hidrtnVal.Text = "Susses";
            }
            
        }
        [AjaxMethod]
        public void recovery()
        {

            bool bl = false;
            bl = AuthorizationBLL.Updatrecoveryby(this.InstanceId.ToString());
            if (bl)
            {
                hidrtnVal.Text = "Susses";
            }
        }
        #endregion
        public void StatusSotreBind()
        {
            List<status> list = new List<status>();
            status s = new status();
            s.Id = "1";
            s.Name = "发布";
            status s1 = new status();
            s1.Id = "0";
            s1.Name = "取消";
            list.Add(s);
            list.Add(s1);
            StatusSotre.DataSource = list;
            StatusSotre.DataBind();
        }
        public class status
        {
            public string Id;
            public string Name;
        }
        public override void Store_DealerList(object sender, StoreRefreshDataEventArgs e)
        {
            IRoleModelContext context = RoleModelContext.Current;


            IList<DealerMaster> dataSource = DealerCacheHelper.GetDealers();


            //如果是普通用户则检查过滤该用户是否能够看到该Dealer
            if (context.User.IdentityType == IdentityType.User.ToString())
            {

                var query = from p in dataSource
                            where p.ActiveFlag == true
                            select p;

                dataSource = query.ToList<DealerMaster>();

            }

            if (sender is Store)
            {
                Store store1 = (sender as Store);

                store1.DataSource = dataSource;
                store1.DataBind();
            }
        }

        public void ConsignmentMasterStoreBind()
        {
            DataSet ds = AuthorizationBLL.GetConsignmentMasterAll("Submit");
            ConsignmentMasterStore.DataSource = ds;
            ConsignmentMasterStore.DataBind();
        }
        public void Store1_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            Hashtable ht = new Hashtable();
            if (!string.IsNullOrEmpty(cbDealer.SelectedItem.Value))
            {
                ht.Add("DealreId", cbDealer.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(cbProductline.SelectedItem.Value))
            {
                ht.Add("ProductLine", cbProductline.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(cbConsignmentName.SelectedItem.Value))
            {
                ht.Add("CmId", cbConsignmentName.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(cbStatus.SelectedItem.Value))
            {
                ht.Add("IsActive", cbStatus.SelectedItem.Value);
            }
            DataSet ds = AuthorizationBLL.QuqerConsignmentAuthorizationby(ht, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);

            e.TotalCount = totalCount;

            Store1.DataSource = ds;
            Store1.DataBind();
        }

    }
}
