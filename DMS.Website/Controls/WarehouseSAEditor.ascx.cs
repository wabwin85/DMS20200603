using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DMS.Website.Controls
{
    using Coolite.Ext.Web;
    using DMS.Model;
    using DMS.Website.Common;
    using DMS.Common;
    using Lafite.RoleModel.Security;
    using DMS.Business;
    using DMS.Model.Data;
    using DMS.Business.Cache;
    using System.Text.RegularExpressions;
    using System.Collections;

    public partial class WarehouseSAEditor : BaseUserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                //如果不是经销商用户不得编辑仓库信息。隐藏Save按钮。

                if (RoleModelContext.Current.User.IdentityType != SR.Consts_System_Dealer_User)
                {
                    //SaveButton.Enabled = false;
                    //btnSearch.Enabled = false;
                    SetWindow();

                }
                else
                {
                    DealerWarehousesStore_RefreshData();
                    this.Bind_WarehouseType(this.WarehouseTypeStoreOnControl);

                }
            }
        }


        public void SetWindow()
        {
            this.Name.ReadOnly = true;
            this.ActiveFlag.ReadOnly = true;
            this.RadioTrue.ReadOnly = true;
            this.RadioFalse.ReadOnly = true;
            this.Bind_WarehouseType(this.WarehouseTypeStoreOnControl);
            this.Type.ReadOnly = true;
            this.Type.Disabled = true;
            //this.SaveButton.Visible = false;
        }

        public void CreateWarehouse()
        {
            //this.Code.ReadOnly = true;
            this.Id1.Text = this.NewGuid();
            this.DmaId.Text = RoleModelContext.Current.User.CorpId.ToString();
        }


        protected void Bind_WarehouseType(Store store)
        {
            Hashtable ht = new Hashtable();
            IList<Warehouse> ws;
            IWarehouses business = new Warehouses();

            ht.Add("DmaId", RoleModelContext.Current.User.CorpId);
            ht.Add("Type", "DefaultWH");
            ws = business.GetWarehousesByHashtable(ht);

            IDictionary<string, string> dictsCompanyType = DictionaryHelper.GetDictionary(SR.Consts_WarehouseType);
            //去掉系统库（SystemHold）项,因为用户不可编辑系统库。

            var query = from t in dictsCompanyType where t.Key != WarehouseType.SystemHold.ToString() select t;

            query = from t in query where t.Key != WarehouseType.LP_Consignment.ToString() select t;
            query = from t in query where t.Key != WarehouseType.Consignment.ToString() select t;
            query = from t in query where t.Key != WarehouseType.LP_Borrow.ToString() select t;
            query = from t in query where t.Key != WarehouseType.Frozen.ToString() select t;
                        
            if (ws.Count >= 1)
            {
                query = from t in query where t.Key != WarehouseType.DefaultWH.ToString() select t;
            }
            string a = this.Type.SelectedItem.Value;

            store.DataSource = query;

            store.DataBind();



        }

        protected void DealerWarehousesStore_RefreshData()
        {
            //非经销商用户不能编辑仓库，不用去判别仓库是否重名。

            if (RoleModelContext.Current.User.IdentityType != SR.Consts_System_Dealer_User)
                return;

            if (this.DmaId.Text == "") return;

            //列出当前数据库中经销商的所有仓库放到Store中，加上新建的仓库去判别是否有重名。

            Hashtable hashtable = new Hashtable();
            hashtable.Clear();
            IWarehouses business = new Warehouses();
            hashtable.Add("DmaId", new Guid(this.DmaId.Text));
            IList<Warehouse> query;
            try
            {
                query = business.GetWarehousesByHashtable(hashtable);
                this.DealerWarehousesStore.DataSource = query;
                this.DealerWarehousesStore.DataBind();
            }
            catch (Exception ex)
            {
                Ext.Msg.Show(new MessageBox.Config
                {
                    Title = GetLocalResourceObject("DealerWarehousesStore_RefreshData.show.Title").ToString(),
                    Message = GetLocalResourceObject("DealerWarehousesStore_RefreshData.show.Message").ToString() + ex.Message + " <br /> Source:" + ex.Source + " <br /> Stack Trace:" + ex.StackTrace,
                    Buttons = MessageBox.Button.OK,
                    Icon = MessageBox.Icon.ERROR
                });
            }


        }

        protected void AjaxEvents_CheckIfEmptyWarehouse(object sender, AjaxEventArgs e)
        {
            IWarehouses wh = new Warehouses();
            IHospitals hos = new Hospitals();
            Hashtable table = new Hashtable();
            table.Add("Name", this.Name.Text);
            table.Add("DmaId", this.DmaId.Text);
            string[] l = this.Code.Text.Split('-');
            if (this.hiddenType.Text == "Add")
            {
                if (wh.duplicateWarehouseName(table))
                {
                    e.Success = false;
                    e.ErrorMessage = GetLocalResourceObject("AjaxEvents_CheckIfEmptyWarehouse.WarehouseName.ErrorMessage").ToString();
                    return;
                }
                if (wh.DuplicateWarehouseCode(this.Code.Text))
                {
                    e.Success = false;
                    e.ErrorMessage = GetLocalResourceObject("AjaxEvents_CheckIfEmptyWarehouse.WarehouseCode.ErrorMessage").ToString();
                    return;
                }
                if (l.Length != 3)
                {
                    e.Success = false;
                    e.ErrorMessage = GetLocalResourceObject("AjaxEvents_CheckIfEmptyWarehouse.WarehouseCode.ErrorMessage1").ToString();
                    return;
                }
                else if(!hos.ExistsHospitalCode(l[1].ToString()))
                {
                    e.Success = false;
                    e.ErrorMessage = GetLocalResourceObject("AjaxEvents_CheckIfEmptyWarehouse.WarehouseCode.ErrorMessage2").ToString();
                    return;
                }
                else if (!l[2].StartsWith("SA"))
                {
                    e.Success = false;
                    e.ErrorMessage = GetLocalResourceObject("AjaxEvents_CheckIfEmptyWarehouse.WarehouseCode.ErrorMessage3").ToString();
                    return;
                }


                //if (wh.DuplicateWarehouseCode(this.Code.Text))
                //{
                //    e.Success = false;
                //    e.ErrorMessage = GetLocalResourceObject("AjaxEvents_CheckIfEmptyWarehouse.WarehouseCode.ErrorMessage").ToString();
                //    return;
                //}
            }

            //if (this.hiddenType.Text == "Update")
            //{
            //    if (wh.DuplicateWarehouseNameUpdate(table))
            //    {
            //        e.Success = false;
            //        e.ErrorMessage = GetLocalResourceObject("AjaxEvents_CheckIfEmptyWarehouse.WarehouseName.ErrorMessage").ToString();
            //        return;
            //    }
            //}
            //如果仓库的状态是有效，则保存修改。否则再去检查库存，有库存就不能将仓库状态设成无效。

            if (this.RadioTrue.Checked)
            {

                string str = this.Id1.Text;
                Match m = Regex.Match(str, @"^[0-9a-f]{8}(-[0-9a-f]{4}){3}-[0-9a-f]{12}$", RegexOptions.IgnoreCase);
                if (!m.Success)
                {
                    this.Id1.Text = this.NewGuid();
                }

                e.Success = true;
            }

            else
            {
                if (!wh.emptyWarehouse(new Guid(this.Id1.Text)))
                {
                    e.Success = false;
                    e.ErrorMessage = GetLocalResourceObject("AjaxEvents_CheckIfEmptyWarehouse.emptyWarehouse.ErrorMessage").ToString();
                    return;
                }
                else
                {
                    e.Success = true;
                }
            }

        }

        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);

        }

        

    }
}