using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DMS.Website.Common;
using Coolite.Ext.Web;
using DMS.Business;
using System.Collections;
using System.Data;
using DMS.Model.Data;
using DMS.Model;
using Lafite.RoleModel.Security;
using DMS.Business.Cache;

namespace DMS.Website.Controls
{
    [AjaxMethodProxyID(IDMode = AjaxMethodProxyIDMode.Alias, Alias = "UC")]
    public partial class InventoryAdjustDialog : BaseUserControl
    {
        IRoleModelContext _context = RoleModelContext.Current;

        public Store GridStore
        {
            get;
            set;
        }

        public Store GridConsignmentStore
        {
            get;
            set;
        }

        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void CurrentInvStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            string[] strCriteria;
            int iCriteriaNbr;
            ICurrentInvBLL business = new CurrentInvBLL();

            Hashtable param = new Hashtable();
            if (!string.IsNullOrEmpty(this.hiddenDialogDealerId.Text))
            {
                param.Add("DealerId", this.hiddenDialogDealerId.Text);
            }
            if (!string.IsNullOrEmpty(this.hiddenDialogProductLineId.Text))
            {
                param.Add("ProductLine", this.hiddenDialogProductLineId.Text);
            }
            if (!string.IsNullOrEmpty(this.cbWarehouse.SelectedItem.Value))
            {
                param.Add("WarehouseId", this.cbWarehouse.SelectedItem.Value);
            }
            param.Add("Type", hiddenDialogAdjustType.Text);
            //可以有十个模糊查找的字段
            if (!string.IsNullOrEmpty(this.txtCFN.Text))
            {
                iCriteriaNbr = 0;
                strCriteria = this.PageBase.oneRecord(this.txtCFN.Text);
                foreach (string strCFN in strCriteria)
                {
                    if (!string.IsNullOrEmpty(strCFN))
                    {
                        iCriteriaNbr++;
                        param.Add(string.Format("ProductCFN{0}", iCriteriaNbr), strCFN);
                    }
                }
                if (iCriteriaNbr > 0) param.Add("ProductCFN", "HasCFNCriteria");
            }

            if (!string.IsNullOrEmpty(this.txtUPN.Text))
            {
                iCriteriaNbr = 0;
                strCriteria = this.PageBase.oneRecord(this.txtUPN.Text);
                foreach (string strUPN in strCriteria)
                {
                    if (!string.IsNullOrEmpty(strUPN))
                    {
                        iCriteriaNbr++;
                        param.Add(string.Format("ProductUPN{0}", iCriteriaNbr), strUPN);
                    }
                }
                if (iCriteriaNbr > 0) param.Add("ProductUPN", "HasUPNCriteria");
            }

            if (!string.IsNullOrEmpty(this.txtLotNumber.Text))
            {
                iCriteriaNbr = 0;
                strCriteria = this.PageBase.oneRecord(this.txtLotNumber.Text);
                foreach (string strLot in strCriteria)
                {
                    if (!string.IsNullOrEmpty(strLot))
                    {
                        iCriteriaNbr++;
                        param.Add(string.Format("ProductLotNumber{0}", iCriteriaNbr), strLot);
                    }
                }
                if (iCriteriaNbr > 0) param.Add("ProductLotNumber", "HasLotCriteria");
            }
            //可以有十个模糊查找的字段
            if (!string.IsNullOrEmpty(this.txtQrCode.Text))
            {
                iCriteriaNbr = 0;
                strCriteria = this.PageBase.oneRecord(this.txtQrCode.Text);
                foreach (string strQrCode in strCriteria)
                {
                    if (!string.IsNullOrEmpty(strQrCode))
                    {
                        iCriteriaNbr++;
                        param.Add(string.Format("QrCode{0}", iCriteriaNbr), strQrCode);
                    }
                }
                if (iCriteriaNbr > 0) param.Add("QrCode", "HasQrCodeCriteria");
            }

            //Edited By Song Yuqi On 20140319 Begin
            DataSet ds;
            //二级经、寄售、退货
            if ((this.hiddenDialogAdjustType.Text == AdjustType.Return.ToString() || this.hiddenDialogAdjustType.Text == AdjustType.Exchange.ToString())
                && _context.User.CorpType == DealerType.T2.ToString()
                && this.hiddenWarehouseType.Text == AdjustWarehouseType.Consignment.ToString())
            {
                //平台寄售、波科寄售
                param.Add("QryWarehouseType", string.Format("{0},{1}", WarehouseType.Consignment.ToString(), WarehouseType.LP_Consignment.ToString()).Split(','));
                ds = business.QueryCurrentInvForReturnByT2Consignment(param);
            }
            //else if (this.hiddenDialogAdjustType.Text == AdjustType.StockOut.ToString() 
            //    && _context.User.CorpType == DealerType.LP.ToString() 
            //    && this.hiddenWarehouseType.Text == AdjustWarehouseType.Consignment.ToString())
            //{
            //    param.Add("QryWarehouseType", string.Format("{0},{1}", WarehouseType.Consignment.ToString(), WarehouseType.LP_Consignment.ToString()).Split(','));
            //    ds = business.QueryCurrentInvForReturnByT2Consignment(param);
            //}
            //寄售转销售
            else if (this.hiddenDialogAdjustType.Text == AdjustType.CTOS.ToString() && _context.User.CorpType == DealerType.T2.ToString())
            {
                ds = business.QueryCurrentCTOSInv(param);
            }
            //转移给其他经销商
            else if (this.hiddenDialogAdjustType.Text == AdjustType.Transfer.ToString() && (_context.User.CorpType == DealerType.T1.ToString() || _context.User.CorpType == DealerType.LP.ToString() || _context.User.CorpType == DealerType.LS.ToString()))
            {
                param.Add("QryWarehouseType", string.Format("{0},{1}", WarehouseType.Borrow.ToString(), WarehouseType.LP_Borrow.ToString()).Split(','));
                ds = business.QueryCurrentInvForReturnByT2Consignment(param);
            }
            else
            {
                param.Add("ReturnApplyType", this.hiddenReturnApplyType.Text);
                ds = business.QueryCurrentInv(param);
            }
            //Edited By Song Yuqi On 20140319 End

            this.CurrentInvStore.DataSource = ds;
            this.CurrentInvStore.DataBind();

        }

        protected void CurrentCfnStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            string[] strCriteria;
            int iCriteriaNbr;
            ICurrentInvBLL business = new CurrentInvBLL();

            int totalCount = 0;

            Hashtable param = new Hashtable();

            if (!string.IsNullOrEmpty(this.hiddenDialogProductLineId.Text))
            {
                param.Add("ProductLine", this.hiddenDialogProductLineId.Text);
            }

            if (!string.IsNullOrEmpty(this.txtCFN_CFN.Text))
            {
                iCriteriaNbr = 0;
                strCriteria = this.PageBase.oneRecord(this.txtCFN_CFN.Text);
                foreach (string strCFN in strCriteria)
                {
                    if (!string.IsNullOrEmpty(strCFN))
                    {
                        iCriteriaNbr++;
                        param.Add(string.Format("ProductCFN{0}", iCriteriaNbr), strCFN);
                    }
                }
                if (iCriteriaNbr > 0) param.Add("ProductCFN", "HasCFNCriteria");
            }

            if (!string.IsNullOrEmpty(this.txtUPN_CFN.Text))
            {
                iCriteriaNbr = 0;
                strCriteria = this.PageBase.oneRecord(this.txtUPN_CFN.Text);
                foreach (string strUPN in strCriteria)
                {
                    if (!string.IsNullOrEmpty(strUPN))
                    {
                        iCriteriaNbr++;
                        param.Add(string.Format("ProductUPN{0}", iCriteriaNbr), strUPN);
                    }
                }
                if (iCriteriaNbr > 0) param.Add("ProductUPN", "HasUPNCriteria");
            }

            DataSet ds = new DataSet();
            if (this.chkIsShareCFN.Checked)
            {
                //共享产品查询
                ds = business.QueryCurrentSharedCfn(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar2.PageSize : e.Limit), out totalCount);
            }
            else
            {
                //非共享产品查询
                ds = business.QueryCurrentCfn(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar2.PageSize : e.Limit), out totalCount);
            }
            e.TotalCount = totalCount;

            this.CurrentCfnStore.DataSource = ds;
            this.CurrentCfnStore.DataBind();

        }

        public void Show(Guid AdjustId, Guid DealerId, Guid ProductLineId, string Type, string WarehouseType, string ReturnApplyType)
        {
            if ((Type == AdjustType.Return.ToString() || Type == AdjustType.Exchange.ToString()) && string.IsNullOrEmpty(ReturnApplyType))
            {
                Ext.Msg.Alert("错误！", "请先选择退换货类型").Show();
                return;
            }
            else
            {
                //隐藏是否共享产品
                this.chkIsShareCFN.Visible = false;

                this.hiddenDialogAdjustId.Text = AdjustId.ToString();
                this.hiddenDialogAdjustType.Text = Type.ToString();
                this.hiddenDialogDealerId.Text = DealerId.ToString();
                this.hiddenDialogProductLineId.Text = ProductLineId.ToString();
                this.hiddenWarehouseType.Text = WarehouseType.ToString();
                this.hiddenReturnApplyType.Text = ReturnApplyType.ToString();

                //Added By Song Yuqi On 20140317 Begin
                this.hiddenDealerType.Text = _context.User.CorpType;
                //Added By Song Yuqi On 20140317 End
                this.hiddenReve3.Clear();
                if (Type == AdjustType.StockIn.ToString())
                {
                    this.Bind_WarehouseByDealerAndType(WarehouseStore, DealerId, WarehouseType);

                    this.DialogWindow_CFN.Show();
                }
                else if (Type == AdjustType.StockOut.ToString())
                {
                    this.BindWarehouseStockOut(WarehouseStore, DealerId, WarehouseType);
                    //this.WarehouseStore.DataBind();
                    this.DialogWindow.Show();
                }
                else if (Type == AdjustType.Return.ToString() || Type == AdjustType.Exchange.ToString())
                {
                    //Edited By Song Yuqi On 20140319 Begin
                    this.BindWarehouseWithReturn(WarehouseStore, DealerId, WarehouseType);
                    //Edited By Song Yuqi On 20140319 End
                    //this.Store_AllWarehouseByDealer(DealerId);
                    this.DialogWindow.Show();
                }
                else if (Type == AdjustType.Transfer.ToString())
                {
                    this.Bind_WarehouseByDealerAndType(WarehouseStore, DealerId, "Borrow");
                    //this.WarehouseStore.DataBind();
                    this.DialogWindow.Show();
                }
                else
                {
                    this.Bind_WarehouseByDealerAndType(WarehouseStore, DealerId, WarehouseType);
                    //this.WarehouseStore.DataBind();
                    this.DialogWindow.Show();
                }
            }
        }

        public void ShowConsignment(Guid AdjustId, Guid DealerId, Guid ProductLineId, string Type, string WarehouseType)
        {
            this.hiddenDialogAdjustId.Text = AdjustId.ToString();
            this.hiddenDialogAdjustType.Text = Type.ToString();
            this.hiddenDialogDealerId.Text = DealerId.ToString();
            this.hiddenDialogProductLineId.Text = ProductLineId.ToString();
            this.hiddenWarehouseType.Text = WarehouseType.ToString();

            if (Type == AdjustType.StockIn.ToString())
            {
                this.BindWarehouseWithConsignmengAndBorrow(WarehouseStore, DealerId, WarehouseType);
                this.cbWarehouse2.Value = "";
                this.DialogWindow_CFN.Show();
            }
            else if (Type == AdjustType.Return.ToString() || Type == AdjustType.Exchange.ToString())
            {
                this.Store_AllWarehouseByDealer(DealerId);
                this.DialogWindow.Show();
            }
            else if (Type == AdjustType.CTOS.ToString())
            {
                this.BindWarehouseWithConsignmengAndBorrow(WarehouseStore, DealerId, WarehouseType);
                this.cbWarehouse2.Value = "";
                this.DialogWindow.Show();
            }
            else if (Type == AdjustType.Transfer.ToString())
            {
                this.BindWarehouseWithConsignmengAndBorrow(WarehouseStore, DealerId, WarehouseType);
                //this.WarehouseStore.DataBind();
                this.DialogWindow.Show();
            }
            else
            {
                //this.Bind_WarehouseByDealerAndType(WarehouseStore, DealerId, WarehouseType);
                this.BindWarehouseWithConsignmengAndBorrow(WarehouseStore, DealerId, WarehouseType);
                //this.WarehouseStore.DataBind();
                this.DialogWindow.Show();
            }
        }

        protected void Store_AllWarehouseByDealer(Guid DealerId)
        {
            Warehouses business = new Warehouses();
            IList<Warehouse> list = business.GetAllWarehouseByDealer(DealerId);
            var g = from p in list where p.Type != WarehouseType.SystemHold.ToString() select p;

            WarehouseStore.DataSource = g;
            WarehouseStore.DataBind();

        }

        public void BindWarehouseWithConsignmengAndBorrow(Store store, Guid dealerId, string dealerWarehouseType)
        {
            IRoleModelContext context = RoleModelContext.Current;
            Warehouses business = new Warehouses();
            //取得经销商的所有仓库
            IList<Warehouse> list = business.GetWarehouseByDealer(dealerId);

            if (list == null)
                list = new List<Warehouse>();

            //获得经销商信息
            DealerMaster dealer = DealerCacheHelper.GetDealerById(dealerId);


            if (dealerWarehouseType.Equals("Normal"))
            {
                list = (from t in list where t.Type == WarehouseType.DefaultWH.ToString() || t.Type == WarehouseType.Normal.ToString() select t).ToList<Warehouse>();
            }
            else if (dealerWarehouseType.Equals("Consignment") || dealerWarehouseType.Equals("Borrow"))
            {
                switch ((DealerType)Enum.Parse(typeof(DealerType), dealer.DealerType, true))
                {
                    case DealerType.LP:
                        //平台，显示波科寄售库/借货库
                        list = (from t in list where t.Type == WarehouseType.Consignment.ToString() || t.Type == WarehouseType.Borrow.ToString() select t).ToList<Warehouse>();
                        break;
                    case DealerType.LS:
                        //与平台相同
                        list = (from t in list where t.Type == WarehouseType.Consignment.ToString() || t.Type == WarehouseType.Borrow.ToString() select t).ToList<Warehouse>();
                        break;
                    case DealerType.T1:
                        //T1 ,显示波科寄售库/借货库
                        list = (from t in list where t.Type == WarehouseType.Consignment.ToString() || t.Type == WarehouseType.Borrow.ToString() select t).ToList<Warehouse>();
                        break;
                    case DealerType.T2:
                        //二级经销商，显示平台寄售库/借货库 波科寄售库
                        list = (from t in list where t.Type == WarehouseType.LP_Consignment.ToString() || t.Type == WarehouseType.LP_Borrow.ToString() || t.Type == WarehouseType.Consignment.ToString() select t).ToList<Warehouse>();
                        break;
                    default: break;
                }
            }
            store.DataSource = list;
            store.DataBind();
        }

        public void BindWarehouseStockOut(Store store, Guid dealerId, string dealerWarehouseType)
        {
            IRoleModelContext context = RoleModelContext.Current;
            Warehouses business = new Warehouses();
            //取得经销商的所有仓库
            IList<Warehouse> list = business.GetWarehouseByDealer(dealerId);

            if (list == null)
                list = new List<Warehouse>();

            //获得经销商信息
            DealerMaster dealer = DealerCacheHelper.GetDealerById(dealerId);


            if (dealerWarehouseType.Equals("Normal"))
            {
                list = (from t in list where t.Type == WarehouseType.DefaultWH.ToString() || t.Type == WarehouseType.Normal.ToString() || t.Type == WarehouseType.Frozen.ToString() select t).ToList<Warehouse>();
            }
            else if (dealerWarehouseType.Equals("Consignment") || dealerWarehouseType.Equals("Borrow"))
            {
                switch ((DealerType)Enum.Parse(typeof(DealerType), dealer.DealerType, true))
                {
                    case DealerType.LP:
                        //平台，显示波科寄售库/借货库
                        list = (from t in list where t.Type == WarehouseType.Consignment.ToString() || t.Type == WarehouseType.Borrow.ToString() select t).ToList<Warehouse>();
                        break;
                    case DealerType.LS:
                        //与平台相同
                        list = (from t in list where t.Type == WarehouseType.Consignment.ToString() || t.Type == WarehouseType.Borrow.ToString() select t).ToList<Warehouse>();
                        break;
                    case DealerType.T1:
                        //T1 ,显示波科寄售库/借货库
                        list = (from t in list where t.Type == WarehouseType.Consignment.ToString() || t.Type == WarehouseType.Borrow.ToString() select t).ToList<Warehouse>();
                        break;
                    case DealerType.T2:
                        //二级经销商，显示平台寄售库/借货库 波科寄售库
                        list = (from t in list where t.Type == WarehouseType.LP_Consignment.ToString() || t.Type == WarehouseType.LP_Borrow.ToString() || t.Type == WarehouseType.Consignment.ToString() select t).ToList<Warehouse>();
                        break;
                    default: break;
                }
            }
            store.DataSource = list;
            store.DataBind();
        }

        public void BindWarehouseWithReturn(Store store, Guid dealerId, string dealerWarehouseType)
        {
            IRoleModelContext context = RoleModelContext.Current;
            Warehouses business = new Warehouses();
            //取得经销商的所有仓库
            IList<Warehouse> list = business.GetWarehouseByDealer(dealerId);

            if (list == null)
                list = new List<Warehouse>();

            //获得经销商信息
            DealerMaster dealer = DealerCacheHelper.GetDealerById(dealerId);

            //普通
            if (dealerWarehouseType.Equals(AdjustWarehouseType.Normal.ToString()))
            {
                switch ((DealerType)Enum.Parse(typeof(DealerType), dealer.DealerType, true))
                {
                    case DealerType.LP:
                        //平台，显示所有库存
                        list = (from t in list where t.Type != WarehouseType.SystemHold.ToString() select t).ToList<Warehouse>();
                        break;
                    case DealerType.LS:
                        //与平台相同
                        list = (from t in list where t.Type != WarehouseType.SystemHold.ToString() select t).ToList<Warehouse>();
                        break;
                    case DealerType.T1:
                        //T1 ,显示所有库存
                        list = (from t in list where t.Type != WarehouseType.SystemHold.ToString() select t).ToList<Warehouse>();
                        break;
                    case DealerType.T2:
                        //二级经销商，显示普通、借货
                        list = (from t in list where t.Type != WarehouseType.SystemHold.ToString() && t.Type != WarehouseType.LP_Consignment.ToString() && t.Type != WarehouseType.Consignment.ToString() select t).ToList<Warehouse>();
                        break;
                    default: break;
                }

                //list = (from t in list where t.Type == WarehouseType.DefaultWH.ToString() || t.Type == WarehouseType.Normal.ToString() select t).ToList<Warehouse>();
            }
            else if (dealerWarehouseType.Equals(AdjustWarehouseType.Consignment.ToString()))
            {
                switch ((DealerType)Enum.Parse(typeof(DealerType), dealer.DealerType, true))
                {
                    case DealerType.LP:
                        //平台，显示波科寄售库/借货库
                        list = (from t in list where t.Type == WarehouseType.Consignment.ToString() select t).ToList<Warehouse>();
                        break;
                    case DealerType.LS:
                        //与平台相同
                        list = (from t in list where t.Type == WarehouseType.Consignment.ToString() select t).ToList<Warehouse>();
                        break;
                    case DealerType.T1:
                        //T1 ,显示波科寄售库/借货库
                        list = (from t in list where t.Type == WarehouseType.Consignment.ToString() select t).ToList<Warehouse>();
                        break;
                    case DealerType.T2:
                        //二级经销商，显示平台寄售库/借货库
                        list = (from t in list where t.Type == WarehouseType.LP_Consignment.ToString() || t.Type == WarehouseType.Consignment.ToString() select t).ToList<Warehouse>();
                        break;
                    default: break;
                }
            }
            store.DataSource = list;
            store.DataBind();
        }

        [AjaxMethod]
        public void DoAddItems(string param)
        {
            Ext.Msg.Confirm(GetLocalResourceObject("DoAddItems.Confirm.title").ToString(), GetLocalResourceObject("DoAddItems.Confirm.body").ToString(), new MessageBox.ButtonsConfig
            {
                Yes = new MessageBox.ButtonConfig
                {
                    Handler = "Coolite.AjaxMethods.UC.DoYes('" + param + "')",
                    Text = "Yes"
                },
                No = new MessageBox.ButtonConfig
                {
                    Handler = "Coolite.AjaxMethods.UC.DoNo()",
                    Text = "No"
                }
            }).Show();
        }

        [AjaxMethod]
        public void DoYes(string param)
        {
            System.Diagnostics.Debug.WriteLine("AddItems : Param = " + param);

            param = param.Substring(0, param.Length - 1);

            IInventoryAdjustBLL business = new InventoryAdjustBLL();

            //Edited By Song Yuqi On 20140319 Begin
            bool result = false;

            if ((this.hiddenDialogAdjustType.Text == AdjustType.Return.ToString() || this.hiddenDialogAdjustType.Text == AdjustType.Exchange.ToString())
                   && _context.User.CorpType == DealerType.T2.ToString()
                   && this.hiddenWarehouseType.Text == AdjustWarehouseType.Consignment.ToString())
            {
                result = business.AddItems(this.hiddenDialogAdjustType.Text, new Guid(this.hiddenDialogAdjustId.Text), new Guid(this.hiddenDialogDealerId.Text), this.cbWarehouse.SelectedItem.Value, param.Split(','),this.hiddenReturnApplyType.Text);
            }
            else if (this.hiddenDialogAdjustType.Text == AdjustType.Transfer.ToString() && this.hiddenWarehouseType.Text == AdjustWarehouseType.Borrow.ToString())
            {
                result = business.AddConsignmentItemsInv(new Guid(this.hiddenDialogAdjustId.Text), new Guid(this.hiddenDialogDealerId.Text), param.Split(','));
            }
            else
            {
                result = business.AddItems(this.hiddenDialogAdjustType.Text, new Guid(this.hiddenDialogAdjustId.Text), new Guid(this.hiddenDialogDealerId.Text), this.cbWarehouse2.SelectedItem.Value, param.Split(','), this.hiddenReturnApplyType.Text);
            }
            //Edited By Song Yuqi On 20140319 End

            if (result)
            {
                if ((this.hiddenDialogAdjustType.Text == AdjustType.Return.ToString() || this.hiddenDialogAdjustType.Text == AdjustType.Exchange.ToString())
                    && _context.User.CorpType == DealerType.T2.ToString()
                    && this.hiddenWarehouseType.Text == AdjustWarehouseType.Consignment.ToString())
                {
                    this.GridStore.DataBind();
                }
                else if (this.hiddenDialogAdjustType.Text == AdjustType.Transfer.ToString() && this.hiddenWarehouseType.Text == AdjustWarehouseType.Borrow.ToString())
                {
                    this.GridStore.DataBind();
                    // this.GridConsignmentStore.DataBind();
                }
                else
                {
                    this.GridStore.DataBind();
                }
                //this.GridStore.DataBind();
                //this.DialogWindow.Hide();
                //this.DialogWindow_CFN.Hide();
                //Ext.Msg.Alert(GetLocalResourceObject("DoYes.Alert.true.title").ToString(), GetLocalResourceObject("DoYes.Alert.true.body").ToString()).Show();
            }
            else
            {
                Ext.Msg.Alert(GetLocalResourceObject("DoYes.Alert.false.title").ToString(), GetLocalResourceObject("DoYes.Alert.false.body").ToString()).Show();
            }
        }

        [AjaxMethod]
        public void DoNo()
        {

        }
    }
}