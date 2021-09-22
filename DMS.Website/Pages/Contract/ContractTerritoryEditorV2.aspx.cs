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

    public partial class ContractTerritoryEditorV2 : BasePage
    {
        private IContractMasterBLL _contractMasterBll = new ContractMasterBLL();
        private IContractCommonBLL _contractCommon = new ContractCommonBLL();

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
        protected void Store1_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            //int totalCount = 0;
            if (!String.IsNullOrEmpty(this.hidInstanceID.Value.ToString()))
            {
                DateTime EffectiveDate = new DateTime();
                if (this.hidBeginDate.Text != string.Empty) EffectiveDate = Convert.ToDateTime(this.hidBeginDate.Text);
                string marketType = this.hidIsEmerging.Value.ToString();

                Hashtable obj = new Hashtable();
                obj.Add("ContractId", this.hidInstanceID.Value.ToString()); //合同ID
                obj.Add("ProductLineId", this.hidProductLineId.Value.ToString()); //产品线ID
                obj.Add("PartsContractCode", this.hidPartsContractCode.Value.ToString()); //合同产品分类
                obj.Add("MarketType", marketType); //合同产品分类
                obj.Add("DealerId", this.hidDealerId.Value.ToString());//当前经销商ID
              
                if (marketType.Equals("2"))
                {
                    //产品线分红蓝海，合同分类不分红蓝海
                    //query = _contractCommon.GetPartAuthorizationHospitalTempNoBR(obj, 0, 2000, out totalCount);
                    obj.Add("BRType", "NoBR");
                    
                }
                else 
                {
                    //合同分类分红蓝海
                    //query = _contractCommon.GetPartAuthorizationHospitalTemp(obj, 0, 2000, out totalCount);
                    obj.Add("BRType", "BR");
                }
                DataSet query = _contractCommon.GetPartAuthorizationHospitalTempP(obj, (e.Start == -1 ? 0 : e.Start / this.PagingToolBar1.PageSize), this.PagingToolBar1.PageSize);

                DataTable dtCount = query.Tables[0];
                DataTable dtValue = query.Tables[1];

                if (dtValue != null && dtValue.Rows.Count > 0)
                {
                    this.pnlSouth.Title = "包含医院: <img src='/resources/images/icons/flag_ch.png' > </img> 代表本次新授权医院 (共计：" + dtValue.Rows[0]["HospitalCount"].ToString() + "家医院)";
                }
                else { this.pnlSouth.Title = "包含医院: <img src='/resources/images/icons/flag_ch.png' > </img> 代表本次新授权医院 (共计：0 家医院)"; }

                (this.Store1.Proxy[0] as DataSourceProxy).TotalCount = Convert.ToInt32(dtCount.Rows[0]["CNT"].ToString());
                this.Store1.DataSource = dtValue;
                this.Store1.DataBind();
            }
        }

        protected void StoreUpdate_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            if (!String.IsNullOrEmpty(this.hidInstanceID.Value.ToString()))
            {
                DateTime EffectiveDate = new DateTime();
                if (this.hidBeginDate.Text != string.Empty) EffectiveDate = Convert.ToDateTime(this.hidBeginDate.Text);
                string marketType = this.hidIsEmerging.Value.ToString();

                Hashtable obj = new Hashtable();
                obj.Add("ContractId", this.hidInstanceID.Value.ToString()); //合同ID
            
                DataSet query = _contractCommon.GetPartAuthorizationHospitalTempNoBR(obj, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar2.PageSize : e.Limit), out totalCount);
                (this.StoreUpdate.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
                this.StoreUpdate.DataSource = query;
                this.StoreUpdate.DataBind();
            }
        }

        protected void HospitalDepartStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            Hashtable obj = new Hashtable();
            obj.Add("Type", "HospitalDepart");
            obj.Add("DivisionCode", this.hidDivisionID.Text);
            DataSet dsHospitalDepartment = _contractMasterBll.GetHospitalDepartment(obj);
            if (dsHospitalDepartment.Tables[0].Rows.Count > 0)
            {
                this.HospitalDepartStore.DataSource = dsHospitalDepartment;
                this.HospitalDepartStore.DataBind();
            }
            else
            {
                this.txtHospitalDepartType.Visible = false;
                this.txtHospitalDepartType.Hidden = true;
            }
        }

        //删除医院
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
                
                _contractCommon.RemoveAuthorizationTemp(this.hidInstanceID.Text, hosList);

                string hospitalString = "";
                for (int i = 0; i < hosList.Length; i++)
                {
                    hospitalString += (hosList[i].ToString() + ",");
                }
                if (!hospitalString.Equals(""))
                {
                    Hashtable obj = new Hashtable();
                    obj.Add("ContractId", this.hidInstanceID.Text);
                    obj.Add("PartsContractCode", this.hidPartsContractCode.Value.ToString()); //合同产品分类
                    obj.Add("HospitalString", hospitalString);
                    obj.Add("RtnVal", "");
                    obj.Add("RtnMsg", "");
                    _contractMasterBll.DeleteAuthorizationAOP(obj);
                }

                e.Cancel = true;
            }
        }

        //protected void AuthorizationStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        //{
        //    Hashtable obj = new Hashtable();
        //    obj.Add("ContractId", this.hidInstanceID.Text);
        //    obj.Add("PartsContractCode", this.hidPartsContractCode.Value.ToString()); //合同产品分类

        //    DataTable tbPartsAuthorization = _contractCommon.GetPartsAuthorizedTemp(obj).Tables[0];
        //    this.AuthorizationStore.DataSource = tbPartsAuthorization;
        //    this.AuthorizationStore.DataBind();
        //}
        #endregion

        #region Event
        protected void EditTerritory_Click(object sender, AjaxEventArgs e)
        {
            try
            {
                this.txtGPHospitalUpdate.Reload();
                SetGridSelect();

                this.txtHospitalName.Text = "";
                this.txtHospitalDepartment.Text = "";
                //this.hidHosListId.Clear();
                this.txtHidHosId.Clear();
                this.txtHospitalDepartType.SetValue("");
                this.txtHospitalRemark.Text = "";

                string editData = e.ExtraParams["editData"];
                SelectedEventArgs editArgs = new SelectedEventArgs(editData);
                IDictionary<string, string>[] sellist = editArgs.ToDictionarys();
                if (sellist != null && sellist.Length > 0)
                {
                    //this.hidHosListId.Value = new Guid(sellist[0]["TerritoryId"]);
                    this.txtHidHosId.Value = sellist[0]["HosId"].ToString();
                    this.txtHospitalName.Text = sellist[0]["HosHospitalName"].ToString();
                    this.txtHospitalDepartment.Text = sellist[0]["HosDepart"].ToString();
                    this.txtHospitalDepartType.SelectedItem.Value = sellist[0]["HosDepartType"].ToString();
                    this.txtHospitalRemark.Text = sellist[0]["HosDepartRemark"].ToString();
                    
                    
                    this.EditHospitalDepWindow.Show();
                    e.Success = true;
                }
            }
            catch
            {
                e.Success = false;
            }
        }
        protected void RowSelect(object sender, AjaxEventArgs e)
        {
            try
            {
                this.txtHospitalName.Text = "";
                this.txtHospitalDepartment.Text = "";
                //this.hidHosListId.Clear();
                this.txtHidHosId.Clear();
                this.txtHospitalDepartType.SetValue("");
                this.txtHospitalRemark.Text = "";

                string editData = e.ExtraParams["HospitalDepartEdite"];
                SelectedEventArgs editArgs = new SelectedEventArgs(editData);
                IDictionary<string, string>[] sellist = editArgs.ToDictionarys();
                if (sellist != null && sellist.Length > 0)
                {
                    //this.hidHosListId.Value = new Guid(sellist[0]["TerritoryId"]);
                    this.txtHidHosId.Value = sellist[0]["HosId"].ToString();
                    this.txtHospitalName.Text = sellist[0]["HosHospitalName"].ToString();
                    this.txtHospitalDepartment.Text = sellist[0]["HosDepart"].ToString();
                    this.txtHospitalDepartType.SelectedItem.Value = sellist[0]["HosDepartType"].ToString();
                    this.txtHospitalRemark.Text = sellist[0]["HosDepartRemark"].ToString();

                    e.Success = true;
                }
            }
            catch
            {
                e.Success = false;
            }
        }
        protected void SaveTerritoryDepart_Click(object sender, AjaxEventArgs e)
        {
            try
            {
                Hashtable obj = new Hashtable();
                obj.Add("ContractId", this.hidInstanceID.Value.ToString());
                obj.Add("HosId", this.txtHidHosId.Text);
                obj.Add("HlaDep", this.txtHospitalDepartment.Text);
                obj.Add("HlaDepType", this.txtHospitalDepartType.SelectedItem.Value);
                obj.Add("HlaDepRemark", this.txtHospitalRemark.Text);
                _contractCommon.UpdateContractTerritoryDepartment(obj);
                e.Success = true;
            }
            catch
            {
                e.Success = false;
            }
        }

        [AjaxMethod]
        public string SubmitClassAuthorization(string param)
        {
            try
            {
                param = param.Replace("Home,", "");

                Hashtable obj=new Hashtable ();
                obj.Add("ContractId", this.hidInstanceID.Value.ToString());
                obj.Add("DealerId", this.hidDealerId.Value.ToString());
                obj.Add("ProductLineId", this.hidProductLineId.Value.ToString());
                obj.Add("PartsAuthorizationIdString", param);
                obj.Add("RtnVal", "");
                obj.Add("RtnMsg", "");
                _contractCommon.ModifyPartsAuthorizationTemp(obj);


                return "Success";
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
            
        }
        #endregion


        #region Function
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
            Guid conId = new Guid(this.hidInstanceID.Text);
            DataTable dtquery = _contractMasterBll.QueryAuthorizationTempListForDataSet(conId).Tables[0];
            for (int i = 0; i < dtquery.Rows.Count; i++)
            {
                Guid datId = new Guid(dtquery.Rows[i]["Id"].ToString());
                Guid lineId = new Guid(dtquery.Rows[i]["ProductLineBumId"].ToString());
                _contractMasterBll.SaveHospitalOfAuthorization(datId, selected, selectType, hosProvince, hosCity, hosDistrict, lineId, dept);
            }

            this.gplAuthHospital.Reload();
            this.txtGPHospitalUpdate.Reload();
        }

        protected void OnAfterSelectdDelHospitalClosed(SelectedEventArgs e)
        {
            this.gplAuthHospital.Reload();
            this.txtGPHospitalUpdate.Reload();
        }

        //获取产品线ID
        private string ProductLineId(string divisionID) 
        {
            string productLineId = "00000000-0000-0000-0000-000000000000";
            Hashtable obj = new Hashtable();
            obj.Add("DivisionID", divisionID);
            obj.Add("IsEmerging", "0");
            DataTable dtProductLine = _contractMasterBll.GetProductLineByDivisionID(obj).Tables[0];
            if(dtProductLine.Rows.Count>0){
                productLineId = dtProductLine.Rows[0]["AttributeID"].ToString();
            }
            return productLineId;
        }

        private void SetGridSelect()
        {
            RowSelectionModel sm = this.txtGPHospitalUpdate.SelectionModel.Primary as RowSelectionModel;
            sm.SelectedRows.Clear();
            sm.UpdateSelection();
            //sm.SelectedRows.Add(new SelectedRow(Id));
            //sm.UpdateSelection();
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

            DataTable dt = _contractCommon.GetPartsAuthorizedTemp(obj).Tables[0];

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
            Guid conId = new Guid(this.hidInstanceID.Text);
            DataSet ds = _contractMasterBll.QueryAuthorizationTempListForDataSet(conId);
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
                _contractCommon.SysFormalAuthorizationToTemp(obj);
            }
        }

        protected void ExportExcel(object sender, EventArgs e)
        {
            DataTable dt = _contractMasterBll.GetExcelTerritoryByContractId(new Guid(this.hidInstanceID.Value.ToString())).Tables[0];//dt是从后台生成的要导出的datatable
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


        #endregion


    }
}
