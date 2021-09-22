using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DMS.Website.Pages.Contract
{
    using DMS.Model;
    using DMS.Business;
    using DMS.Business.Cache;
    using DMS.Common;
    using DMS.Website.Common;
    using Coolite.Ext.Web;
    using Lafite.RoleModel.Security;
    using System.Data;
    using System.Collections;
    using System.Text;

    public partial class ContractTerritoryAreaEditor : BasePage
    {
        private IContractCommonBLL _contractCommon = new ContractCommonBLL();
        private IContractMasterBLL _contractMasterBll = new ContractMasterBLL();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (this.Request.QueryString["InstanceID"] != null &&
                    this.Request.QueryString["DivisionID"] != null &&
                    this.Request.QueryString["PartsContractCode"] != null &&
                    this.Request.QueryString["TempDealerID"] != null &&
                    this.Request.QueryString["EffectiveDate"] != null &&
                    this.Request.QueryString["ContractType"] != null)
                {
                    this.hidInstanceID.Text = this.Request.QueryString["InstanceID"];//合同ID
                    this.hidDivisionID.Text = this.Request.QueryString["DivisionID"];//产品线
                    this.hidPartsContractCode.Text = this.Request.QueryString["PartsContractCode"];//合同分类Code
                    this.hidBeginDate.Text = this.Request.QueryString["EffectiveDate"];//合同开始时间
                    this.hidDealerId.Text = this.Request.QueryString["TempDealerID"];//经销商ID
                    this.hidContractType.Text = this.Request.QueryString["ContractType"];//合同类型
                    this.hidProductLineId.Text = ProductLineId(this.Request.QueryString["DivisionID"].ToString()); //获取产品线ID

                    //市场类型
                    if (this.Request.QueryString["IsEmerging"] != null)
                    {   // 0:红海,  1:蓝海,  2:不分红蓝海  
                        this.hidIsEmerging.Text = this.Request.QueryString["IsEmerging"];
                    }
                    else
                    {
                        this.hidIsEmerging.Text = "0";
                    }

                    if (this.Request.QueryString["ProductAmend"] != null)
                    {   //是否修改授权产品分类
                        this.hidProductAmend.Text = this.Request.QueryString["ProductAmend"];
                    }
                    else
                    {
                        this.hidProductAmend.Text = "0";
                    }

                    InsertDealerAuthorizationTableTemp();
                    BuildTree(this.menuTree.Root);
                }
            }
        }

        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);
            this.HospitalSearchDCMSDialog1.AfterSelectedHandler += OnAfterSelectedHospitalRow;
        }

        #region Store

        protected void AreaStore_OnRefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            if (!String.IsNullOrEmpty(this.hidInstanceID.Value.ToString()))
            {
                Hashtable obj = new Hashtable();
                obj.Add("ContractId", this.hidInstanceID.Value.ToString()); //合同ID
                DataTable provinces = _contractMasterBll.GetProvincesForArea(obj).Tables[0];
                AreaStore.DataSource = provinces;
                AreaStore.DataBind();

                string selected = "";
                for (int i = 0; i < provinces.Rows.Count; i++) 
                {
                    if (Convert.ToBoolean(provinces.Rows[i]["Selected"])) 
                    {
                        selected += (provinces.Rows[i]["TerId"].ToString()+",");
                    }
                }
                this.hidAreaSelected.Value = selected;
            }
        }

        protected void Store1_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            if (!String.IsNullOrEmpty(this.hidInstanceID.Value.ToString()))
            {
                Hashtable obj = new Hashtable();
                obj.Add("ContractId", this.hidInstanceID.Value.ToString()); //合同ID
             
                DataSet query = _contractMasterBll.GetPartAreaExcHospitalTemp(obj);

                if (query != null && query.Tables[0].Rows.Count > 0)
                {
                    this.pnlSouth.Title = "第三步：区域内<font color='red' size='3px' >排除</font>医院 (共计：" + query.Tables[0].Rows.Count.ToString() + "家医院)";
                }
                else { this.pnlSouth.Title = "第三步：区域内<font color='red' size='3px' >排除</font>医院 (共计：0 家医院)"; }

                this.Store1.DataSource = query;
                this.Store1.DataBind();
            }
        }

        protected void Store1_BeforeStoreChanged(object sender, BeforeStoreChangedEventArgs e)
        {
            //you can add own logic for save using one of above data representation and then set e.Cancel=true for canceling Store events

            if (this.hidInstanceID.Text != string.Empty)
            {
                string json = e.DataHandler.JsonData;
                StoreDataHandler dataHandler = new StoreDataHandler(json);

                ChangeRecords<Hospital> data = dataHandler.CustomObjectData<Hospital>();

                IList<Hospital> selDeleted = data.Deleted;
                Guid[] hosList = (from p in selDeleted select p.HosId).ToArray<Guid>();

                _contractMasterBll.RemoveAreaHospitalTemp(this.hidInstanceID.Text, hosList);

                e.Cancel = true;
            }
        }
        #endregion
    

        [AjaxMethod]
        public string SubmitAreaSelected(string param)
        {
            try
            {
                param = param.Substring(0, param.Length - 1);
                Hashtable obj = new Hashtable();
                obj.Add("ContractId", this.hidInstanceID.Value.ToString());
                obj.Add("DealerId", this.hidDealerId.Value.ToString());
                obj.Add("ProductLineId", this.hidProductLineId.Value.ToString());
                obj.Add("PartsAuthorizationIdString", param);
                obj.Add("RtnVal", "");
                obj.Add("RtnMsg", "");

                //bll.UpdateRejectStatus(param.Split(','));
                _contractMasterBll.SubmintAreaTemp(obj);
               
                return "Success";

            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        [AjaxMethod]
        public string SubmitClassAuthorization(string param)
        {
            try
            {
                param = param.Replace("Home,", "");

                Hashtable obj = new Hashtable();
                obj.Add("ContractId", this.hidInstanceID.Value.ToString());
                obj.Add("DealerId", this.hidDealerId.Value.ToString());
                obj.Add("ProductLineId", this.hidProductLineId.Value.ToString());
                obj.Add("PartsAuthorizationIdString", param);
                obj.Add("RtnVal", "");
                obj.Add("RtnMsg", "");
                _contractMasterBll.ModifyPartsAuthorizationAreaTemp(obj);


                return "Success";
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }

        }

        [AjaxMethod]
        public string RefreshLines()
        {
            Coolite.Ext.Web.TreeNodeCollection nodes = this.BuildTree(null);
            return nodes.ToJson();
        }

        private Coolite.Ext.Web.TreeNodeCollection BuildTree(Coolite.Ext.Web.TreeNodeCollection nodes)
        {
            if (nodes == null)
            {
                nodes = new Coolite.Ext.Web.TreeNodeCollection();
            }

            Hashtable obj = new Hashtable();
            obj.Add("ContractId", this.hidInstanceID.Text);
            obj.Add("PartsContractCode", this.hidPartsContractCode.Value.ToString()); //合同产品分类

            DataTable dt = _contractMasterBll.GetPartsAuthorizedAreaTemp(obj).Tables[0];

            Coolite.Ext.Web.TreeNode rootNode = new Coolite.Ext.Web.TreeNode();
            rootNode.Text = "授权产品分类";
            rootNode.NodeID = "Home";
            rootNode.Icon = Icon.FolderHome;
            rootNode.Expanded = true;
            rootNode.Checked = ThreeStateBool.False;
            if (this.hidContractType.Value.ToString().Equals("Amendment") && this.hidProductAmend.Value.ToString().Equals("0"))
            {
                rootNode.Disabled = true;
            }
            nodes.Add(rootNode);

            for (int i = 0; i < dt.Rows.Count; i++)
            {
                Coolite.Ext.Web.TreeNode node = new Coolite.Ext.Web.TreeNode();
                node.NodeID = dt.Rows[i]["Id"].ToString();
                node.Text = dt.Rows[i]["Namecn"].ToString();
                node.Icon = Coolite.Ext.Web.Icon.NoteAdd;
                node.Expanded = false;
                if (dt.Rows[i]["IsSelected"].ToString().Equals("1"))
                {
                    node.Checked = ThreeStateBool.True;
                }
                else
                {
                    node.Checked = ThreeStateBool.False;
                }
                if (this.hidContractType.Value.ToString().Equals("Amendment") && this.hidProductAmend.Value.ToString().Equals("0"))
                {
                    node.Disabled = true;
                }

                rootNode.Nodes.Add(node);

            }
            return nodes;
        }

        private void InsertDealerAuthorizationTableTemp()
        {
            Hashtable temp = new Hashtable();
            temp.Add("DclId", this.hidInstanceID.Text);
            DataSet ds = _contractMasterBll.QueryAuthorizationAreaTempList(temp);
            if (ds.Tables[0].Rows.Count == 0)
            {
                //同步正式表授权
                Hashtable obj = new Hashtable();
                obj.Add("ContractId", this.hidInstanceID.Value.ToString());
                obj.Add("DealerId", this.hidDealerId.Value.ToString());
                obj.Add("ProductLineId", this.hidProductLineId.Value.ToString());
                obj.Add("PartsContractCode", this.hidPartsContractCode.Value.ToString());
                obj.Add("MarketType", this.hidIsEmerging.Value.ToString());
                obj.Add("RtnVal", "");
                obj.Add("RtnMsg", "");
                _contractMasterBll.SysFormalAuthorizationAreaToTemp(obj);
            }
        }

        private string ProductLineId(string divisionID)
        {
            string productLineId = "00000000-0000-0000-0000-000000000000";
            Hashtable obj = new Hashtable();
            obj.Add("DivisionID", divisionID);
            obj.Add("IsEmerging", "0");
            DataTable dtProductLine = _contractMasterBll.GetProductLineByDivisionID(obj).Tables[0];
            if (dtProductLine.Rows.Count > 0)
            {
                productLineId = dtProductLine.Rows[0]["AttributeID"].ToString();
            }
            return productLineId;
        }

        /// <summary>
        /// 选择医院后，添加数据
        /// </summary>
        /// <param name="e"></param>
        public void OnAfterSelectedHospitalRow(SelectedEventArgs e)
        {
            if (e.Parameters == null) return;

            SelectTerritoryType selectType = (SelectTerritoryType)Enum.Parse(typeof(SelectTerritoryType), e.Parameters["SelectType"]);

            IDictionary<string, string>[] sellist = e.ToDictionarys();
            IDictionary<string, string>[] disSellist = e.GetDisSelectDictionarys();

            IDictionary<string, string>[] selected = null;

            if (disSellist.Length > 0)
            {
                var query = from p in sellist
                            where disSellist.FirstOrDefault(c => c["HosId"] == p["HosId"]) == null
                            select p;

                selected = query.ToArray<IDictionary<string, string>>();
            }
            else
                selected = sellist;


            string hosProvince = e.Parameters["Province"];
            string hosCity = e.Parameters["City"];
            string hosDistrict = e.Parameters["District"];
            string dept = e.Parameters["Dept"];

            //保存同一Division下所有产品线
            Hashtable obj = new Hashtable();
            obj.Add("DclId", this.hidInstanceID.Text);
            DataTable dtquery = _contractMasterBll.QueryAuthorizationAreaTempList(obj).Tables[0];
            for (int i = 0; i < dtquery.Rows.Count; i++)
            {
                Guid datId = new Guid(dtquery.Rows[i]["Id"].ToString());
                Guid lineId = new Guid(dtquery.Rows[i]["ProductLineBumId"].ToString());
                _contractMasterBll.SaveHospitalOfAuthorizationArea(datId, selected, selectType, hosProvince, hosCity, hosDistrict, lineId, dept);
            }

            this.gplAuthHospital.Reload();
        }

        protected void OnAfterSelectdDelHospitalClosed(SelectedEventArgs e)
        {
            this.gplAuthHospital.Reload();
        }
    }
}
