using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Collections;
using System.Data;
using Microsoft.Practices.Unity;
using Coolite.Ext.Web;
using Lafite.RoleModel.Security;

using DMS.Website.Common;
using DMS.Business;
using DMS.Model;
using DMS.Common;

namespace DMS.Website.Pages.MasterDatas
{

    public partial class CfnSetList : BasePage
    {
        #region 公用
        IRoleModelContext _context = RoleModelContext.Current;
        private ICfnSetBLL _business = null;

        [Dependency]
        public ICfnSetBLL business
        {
            get { return _business; }
            set { _business = value; }
        }
        #endregion

        #region AjaxMethod

        [AjaxMethod]
        public void OnProductLineChange()
        {
            //try
            //{
            //    business.DeleteDetail(new Guid(this.hiddenCFNSID.Text));
            //}
            //catch (Exception e)
            //{
            //    throw new Exception(e.Message);
            //}
        }

        [AjaxMethod]
        public void DeleteItem(String id)
        {
            this.StoreRecords.Remove(this.StoreRecords.First<Cfn>(p => p.Id.ToString() == id));
            this.GridPanel2.DeleteSelected();
        }

        [AjaxMethod]
        public void SaveMainData()
        {
            //获取成套产品主表的数据：mainData
            CfnSet mainData = new CfnSet();

            if (!string.IsNullOrEmpty(this.cbProductLineWin.SelectedItem.Value))
            {
                mainData.ProductLineBumId = new Guid(this.cbProductLineWin.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.txtChineseNameWin.Text))
            {
                mainData.ChineseName = this.txtChineseNameWin.Text;
            }
            if (!string.IsNullOrEmpty(this.txtEnglishNameWin.Text))
            {
                mainData.EnglishName = this.txtEnglishNameWin.Text;
            }
            if (!string.IsNullOrEmpty(this.hiddenCFNSID.Value.ToString()))
            {
                mainData.Id = new Guid(this.hiddenCFNSID.Value.ToString());
            }
            
            try
            {
                business.SaveMainData(mainData);
                Ext.Msg.Alert(GetLocalResourceObject("SaveMainData.Alert.Title").ToString(), GetLocalResourceObject("SaveMainData.Alert.Body").ToString()).Show();
                this.DetailWindow.Hide();
                this.GridPanel1.Reload();
            }
            catch (Exception ex)
            {
                Ext.Msg.Alert(GetLocalResourceObject("SaveMainData.Alert.Exception.Title").ToString(), GetLocalResourceObject("SaveMainData.Alert.Exception.Body").ToString()).Show();
                throw new Exception(ex.Message);
            }
        }

        [AjaxMethod]
        public void Cancel()
        {

        }
        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                Permissions pers = this._context.User.GetPermissions();
                this.btnSearch.Visible = pers.IsPermissible(Business.CfnSetBLL.Action_CFNSet, PermissionType.Read);
                this.btnInsert.Visible = pers.IsPermissible(Business.CfnSetBLL.Action_CFNSet, PermissionType.Write);
                this.btnDelete.Visible = pers.IsPermissible(Business.CfnSetBLL.Action_CFNSet, PermissionType.Write);
            }
        }

        protected void CFNSet_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int start = e.Start == -1 ? 0 : e.Start;
            int limit = e.Limit == -1 ? this.PagingToolBar2.PageSize : e.Limit;
            RefreshData(start, limit);
        }


        private void RefreshData(int start, int limit)
        {
            int totalCount = 0;

            Hashtable param = new Hashtable();
            if (!string.IsNullOrEmpty(this.cbProductLine.SelectedItem.Value.ToString().Trim()))
            {
                param.Add("ProductLineBumId", this.cbProductLine.SelectedItem.Value.ToString().Trim());
            }

            if (!string.IsNullOrEmpty(this.txtCFNSCName.Text.Trim()))
            {
                param.Add("CfnSetName", this.txtCFNSCName.Text.Trim());
            }

            if (!string.IsNullOrEmpty(this.txtCustomerFaceNbr.Text.Trim()))
            {
                param.Add("CustomerFaceNbr", this.txtCustomerFaceNbr.Text.Trim());
            }

            DataSet query = business.QueryDataByFilterCfnSet(param, start, limit, out totalCount);

            (this.CFNSetStore.Proxy[0] as DataSourceProxy).TotalCount = totalCount;

            this.CFNSetStore.DataSource = query;
            this.CFNSetStore.DataBind();

        }

        protected void CFNSet_BeforeStoreChanged(object sender, BeforeStoreChangedEventArgs e)
        {
            //只有删除操作一种
            string json = e.DataHandler.JsonData;
            StoreDataHandler dataHandler = new StoreDataHandler(json);
            ChangeRecords<CfnSet> data = dataHandler.CustomObjectData<CfnSet>();

            bool result = false;
            try
            {
                result = business.SaveCfnSet(data);
                //this.DetailWindow.Hide();
                this.GridPanel1.Reload();
                Ext.Msg.Alert(GetLocalResourceObject("CFNSet_BeforeStoreChanged.Alert.Title").ToString(), GetLocalResourceObject("CFNSet_BeforeStoreChanged.Alert.Body").ToString()).Show();
            }
            catch (Exception ex)
            {
                Ext.Msg.Alert(GetLocalResourceObject("CFNSet_BeforeStoreChanged.Alert.Exception.Title").ToString(), GetLocalResourceObject("CFNSet_BeforeStoreChanged.Alert.Exception.Body").ToString()).Show();
                throw new Exception(ex.Message);
            }

            e.Cancel = true;

        }

        protected void DetailStore_BeforeStoreChanged(object sender, BeforeStoreChangedEventArgs e)
        {
            //获取成套产品主表的数据：mainData
            CfnSet mainData = new CfnSet();

            if (!string.IsNullOrEmpty(this.cbProductLineWin.SelectedItem.Value))
            {
                mainData.ProductLineBumId = new Guid(this.cbProductLineWin.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.txtChineseNameWin.Text))
            {
                mainData.ChineseName = this.txtChineseNameWin.Text;
            }
            if (!string.IsNullOrEmpty(this.txtEnglishNameWin.Text))
            {
                mainData.EnglishName = this.txtEnglishNameWin.Text;
            }
            if (!string.IsNullOrEmpty(this.hiddenCFNSID.Value.ToString()))
            {
                mainData.Id = new Guid(this.hiddenCFNSID.Value.ToString());
            }
            //获取成套产品明细表的数据：detailData
            string json = e.DataHandler.JsonData;
            StoreDataHandler dataHandler = new StoreDataHandler(json);
            ChangeRecords<CfnSetDetail> detailData = dataHandler.CustomObjectData<CfnSetDetail>();

            bool result = false;
            try
            {
                result = business.SaveCfnSet(detailData, mainData);
                Ext.Msg.Alert(GetLocalResourceObject("DetailStore_BeforeStoreChanged.Alert.Title").ToString(), GetLocalResourceObject("DetailStore_BeforeStoreChanged.Alert.Body").ToString()).Show();
                this.DetailWindow.Hide();
                this.GridPanel1.Reload();
            }
            catch (Exception ex)
            {
                Ext.Msg.Alert(GetLocalResourceObject("DetailStore_BeforeStoreChanged.Alert.Exception.Title").ToString(), GetLocalResourceObject("DetailStore_BeforeStoreChanged.Alert.Exception.Body").ToString()).Show();
                throw new Exception(ex.Message);
            }

            e.Cancel = true;
        }


        #region 包含产品操作
        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);
            this.CFNSearchDialog1.AfterSelectedHandler += OnAfterSelectedRow;
        }

        /// <summary>
        /// 选择后，添加数据
        /// </summary>
        /// <param name="e"></param>
        protected void OnAfterSelectedRow(SelectedEventArgs e)
        {
            IDictionary<string, string>[] selectedRows = e.ToDictionarys();
            IList<Cfn> sellist = e.ToList<Cfn>();

            //在已选择的数据中排除已经存在的，准备待添加的数据
            var waitingAdd = selectedRows.Where<IDictionary<string, string>>(p => !IsExistsStoreRecords(p["Id"])).ToArray<IDictionary<string, string>>();

            //更新已有关系的记录集
            if (this.StoreRecords != null)
            {
                var records = sellist.Where<Cfn>(p => !IsExistsStoreRecords(p.Id.ToString()));
                this.StoreRecords = this.StoreRecords.Concat<Cfn>(records).ToList<Cfn>();
            }

            //添加已选择的数据

            foreach (IDictionary<string, string> row in waitingAdd)
            {
                IDictionary<string, string> newRow = new Dictionary<string, string>();
                if (row["ProductLineBumId"] == this.cbProductLineWin.SelectedItem.Value)
                {
                    //Id 
                    newRow.Add("Id", Guid.NewGuid().ToString());
                    //CFNSID
                    newRow.Add("CFNSID", (new Guid()).ToString());
                    //DefaultQuantity
                    newRow.Add("DefaultQuantity", "0");
                    //CFNID
                    newRow.Add("CFNID", row["Id"]);
                    //EnglishName
                    newRow.Add("EnglishName", row["EnglishName"]);
                    //ChineseName
                    newRow.Add("ChineseName", row["ChineseName"]);
                    //CustomerFaceNbr
                    newRow.Add("CustomerFaceNbr", row["CustomerFaceNbr"]);
                    this.GridPanel2.AddRecord(newRow);
                }
                else
                {
                    Ext.Msg.Show(new MessageBox.Config
                    {
                        Buttons = MessageBox.Button.OK,
                        Icon = MessageBox.Icon.INFO,
                        Title = GetLocalResourceObject("OnAfterSelectedRow.Alert.Title").ToString(),
                        Message = GetLocalResourceObject("OnAfterSelectedRow.Alert.Body").ToString()
                    });
                    return;
                }
            }
        }

        /// <summary>
        /// 检查指定Id是否存在
        /// </summary>
        /// <param name="hosId"></param>
        /// <returns></returns>
        public bool IsExistsStoreRecords(string id)
        {
            Cfn hos = null;

            if (this.StoreRecords != null)
            {
                hos = this.StoreRecords.FirstOrDefault(p => p.Id.ToString() == id);
            }
            
            if (hos != null)
                return true;
            else
                return false;
        }

        public IList<Cfn> StoreRecords
        {
            get
            {
                object obj = this.Session["CfnOfCatagory_StoreRecords"];
                return (obj == null) ? null : (IList<Cfn>)this.Session["CfnOfCatagory_StoreRecords"];
            }
            set
            {
                this.Session["CfnOfCatagory_StoreRecords"] = value;
            }
        }

        protected string SelectedLine
        {
            get
            {
                return this.cbProductLineWin.SelectedItem.Value;
            }
        }

        #endregion

        [AjaxMethod]
        public void SearchData()
        {
            if (this.cbProductLine.SelectedItem.Value == "" || this.cbProductLine.SelectedItem.Text.Trim() == "")
            {
                Ext.Msg.Show(new MessageBox.Config
                {
                    Buttons = MessageBox.Button.OK,
                    Icon = MessageBox.Icon.INFO,
                    Title = GetLocalResourceObject("SearchData.Alert.Title").ToString(),
                    Message = GetLocalResourceObject("SearchData.Alert.Body").ToString()
                });
                return;
            }

            this.PagingToolBar1.PageIndex = 1;
            RefreshData(0, PagingToolBar1.PageSize);
        }

        protected void DetailStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {


            Hashtable param = new Hashtable();
            Guid cfnsId = new Guid(this.hiddenCFNSID.Text);
            int start = e.Start == -1 ? 0 : e.Start;
            int limit = e.Limit == -1 ? this.PagingToolBar2.PageSize : e.Limit;
            int totalCount = 0;

            DataSet ds = business.QueryCfnSetDetailByCFNSID(cfnsId, start, limit, out totalCount);

            DataTable dt = ds.Tables[0];
            IList<Cfn> result = new List<Cfn>();
            for (int j = 0; j < dt.Rows.Count; j++)
            {
                Cfn cfn = new Cfn();
                cfn.Id = new Guid(dt.Rows[j][3].ToString());
                result.Add(cfn);

            }
            this.StoreRecords = result;
            e.TotalCount = totalCount;

            this.DetailStore.DataSource = ds;
            this.DetailStore.DataBind();
        }

        protected void ShowDetails(object sender, AjaxEventArgs e)
        {
            
            //清空内容
            this.txtChineseNameWin.Text = "";
            this.txtEnglishNameWin.Text = "";
            this.cbProductLineWin.Disabled = false;
            this.StoreRecords = new List<Cfn>();

            Guid id = new Guid(e.ExtraParams["CFNSID"].ToString());
            this.hiddenCFNSID.Text = id.ToString();
            //显示窗口
            this.DetailWindow.Show();
            this.GridPanel2.Reload();
            if (!id.Equals(Guid.Empty))
            {
                IList<CfnSet> cnfSet = business.QueryCfnSetByID(e.ExtraParams["CFNSID"].ToString());
                this.txtChineseNameWin.Text = cnfSet[0].ChineseName;
                this.txtEnglishNameWin.Text = cnfSet[0].EnglishName;
                this.cbProductLineWin.SelectedItem.Value = cnfSet[0].ProductLineBumId.ToString();
                this.cbProductLineWin.Disabled = true;
            }
            else
            {
                this.cbProductLineWin.SelectedItem.Value = this.cbProductLine.SelectedItem.Value;
            }

        }

        protected void ShowDialog(object sender, AjaxEventArgs e)
        {


        }

        /// <summary>
        /// Called when [authenticate].
        /// </summary>
        protected override void OnAuthenticate()
        {
            Permissions pers = this._context.User.GetPermissions();

            //正式使用权限时请使用Visible = false, 更安全;

            //this.btnDelete.Visible = pers.IsPermissible(Business.Cfns.Action_Cfns, PermissionType.Delete);
            //this.btnInsert.Visible = pers.IsPermissible(Business.Cfns.Action_Cfns, PermissionType.Write);            
            //this.btnSearch.Visible = pers.IsPermissible(Business.Cfns.Action_Cfns, PermissionType.Read);


        }
    }
}
