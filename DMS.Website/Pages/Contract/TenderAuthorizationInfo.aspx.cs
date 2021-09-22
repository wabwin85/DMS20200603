using System;
using System.Collections.Generic;
using System.Linq;
using Coolite.Ext.Web;
using System.Collections;
using DMS.Website.Common;
using Lafite.RoleModel.Security;
using DMS.Business.Contract;
using DMS.Model;
using System.Data;
using DMS.Business;
using Microsoft.Practices.Unity;
using DMS.Common;
using System.IO;

namespace DMS.Website.Pages.Contract
{
    public partial class TenderAuthorizationInfo : BasePage
    {
        #region 公用
        IRoleModelContext _context = RoleModelContext.Current;
        TenderAuthorizationListBLL Bll = new TenderAuthorizationListBLL();
        private IAttachmentBLL _attachmentBLL = null;
        private ITenderAuthorizationList _businessReport = new TenderAuthorizationListBLL();
        private IPromotionPolicyBLL _business = new PromotionPolicyBLL();
        [Dependency]
        public IAttachmentBLL attachmentBLL
        {
            get { return _attachmentBLL; }
            set { _attachmentBLL = value; }
        }
        public bool IsPageNew
        {
            get
            {
                return (this.hidIsPageNew.Text == "True" ? true : false);
            }
            set
            {
                this.hidIsPageNew.Text = value.ToString();
            }
        }
        public string MainStates
        {
            get
            {
                return this.hidStates.Text;
            }
            set
            {
                this.hidStates.Text = value.ToString();
            }
        }
        public string MainId
        {
            get
            {
                return this.hidDtmId.Text;
            }
            set
            {
                this.hidDtmId.Text = value.ToString();
            }
        }
        public string DthId
        {
            get
            {
                return this.hidDthId.Text;
            }
            set
            {
                this.hidDthId.Text = value.ToString();
            }
        }
        #endregion
        protected void Page_Load(object sender, EventArgs e)

        {
            if (!IsPostBack)
            {
                this.Bind_ProductLine(this.ProductLineStore);
                if (!string.IsNullOrEmpty(Request.QueryString["DtmId"]))
                {
                    MainId = Request.QueryString["DtmId"].ToString();
                    this.IsPageNew = false;
                }
                else
                {
                    this.hidDtmId.Clear();
                    MainId = Guid.NewGuid().ToString();
                    this.IsPageNew = true;
                    this.Bind_Authorization(this.AuthorizationInfoStore, SR.Provisional_Authorization);
                }
                BindPage();
            }
        }
        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);
            this.HospitalSearchDialog1.AfterSelectedHandler += OnAfterSelectedHospitalRow;
        }
        protected internal virtual void Bind_Authorization(Store stores, string type)
        {
            IDictionary<string, string> dicts = DictionaryHelper.GetDictionary(type);
            stores.DataSource = dicts;
            stores.DataBind();
        }


        #region PageStore
        //授权医院
        protected void HospitalStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            Hashtable obj = new Hashtable();
            obj.Add("DtmId", MainId);
            DataTable query = Bll.GetTenderHospitalQuery(obj, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount).Tables[0];
            (this.HospitalListStore.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
            HospitalListStore.DataSource = query;
            HospitalListStore.DataBind();
        }
        //授权产品
        protected void ProductStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {

            if (this.DthId != string.Empty)
            {
                Hashtable obj = new Hashtable();
                obj.Add("DthId", this.DthId);
                obj.Add("DtmId", this.MainId);
                obj.Add("BeginDate", this.AtuBeginDate.SelectedDate);
                obj.Add("EndDate", this.AtuEndDate.SelectedDate);
                obj.Add("OperType", "Query");
                obj.Add("start", (e.Start == -1 ? 0 : e.Start / this.PagingToolBar2.PageSize));
                obj.Add("limit", this.PagingToolBar1.PageSize);
                DataSet query = Bll.GetTenderHospitalProductQuery(obj);
                DataTable dtCount = query.Tables[0];
                DataTable dtValue = query.Tables[1];
                (this.ProductStore.Proxy[0] as DataSourceProxy).TotalCount = Convert.ToInt32(dtCount.Rows[0]["CNT"].ToString());
                this.ProductStore.DataSource = dtValue;
                this.ProductStore.DataBind();
            }

        }
        protected void Store_RefreshAttachment(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            Hashtable tb = new Hashtable();
            tb.Add("MainId", MainId);
            DataTable dt = Bll.GetTenderFileQuery(tb, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar3.PageSize : e.Limit), out totalCount).Tables[0];
            (this.AttachmentStore.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
            AttachmentStore.DataSource = dt;
            AttachmentStore.DataBind();
            string i = Request.Url.Host;
        }
        //上传附件信息
        protected void FileTypeStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            IDictionary<string, string> dicts = DictionaryHelper.GetDictionary("CONST_TenderFileType");
            if (this.AtulicenseTypeYes.Checked)
            {
                FileTypeStore.DataSource = (from t in dicts
                                            where (t.Key == "Tender_01" ||
                                                   t.Key == "Tender_02" ||
                                                   t.Key == "Tender_05")
                                            select t);
            }
            else
            {
                FileTypeStore.DataSource = (from t in dicts
                                            where (t.Key == "Tender_01" ||
                                                   t.Key == "Tender_02" ||
                                                   t.Key == "Tender_03" ||
                                                   t.Key == "Tender_04" ||
                                                   t.Key == "Tender_05")
                                            select t);
            }

            FileTypeStore.DataBind();
        }
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
        //Sub_bu
        protected void SubBUStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            this.cbWdSubBU.SelectedItem.Value = "";
            DataSet dsSubBu = _business.GetSubBU(this.hidProductLine.Value.ToString());
            SubBUStore.DataSource = dsSubBu;
            SubBUStore.DataBind();
        }
        //上级平台商
        protected void Bind_SuperiorDealer(object sender, StoreRefreshDataEventArgs e)
        {
            Hashtable obj = new Hashtable();
            DataTable dt = Bll.SelectSuperiorDealer(obj).Tables[0];
            this.SuperiorDealerStore.DataSource = dt;
            this.SuperiorDealerStore.DataBind();
        }
        protected void AllProductStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            Hashtable obj = new Hashtable();
            obj.Add("ProductLindId", this.cbProductLine.SelectedItem.Value);
            obj.Add("SubBu", this.cbWdSubBU.SelectedItem.Value);
            obj.Add("DealerType", this.cbDealerType.SelectedItem.Value);
            DataTable query = Bll.GetTenderAllProduct(obj).Tables[0];

            AllProductStore.DataSource = query;
            AllProductStore.DataBind();
        }
        protected void ProductStore_BeforeStoreChanged(object sender, BeforeStoreChangedEventArgs e)
        {
            if (this.MainId != "")
            {
                string json = e.DataHandler.JsonData;
                StoreDataHandler dataHandler = new StoreDataHandler(json);

                ChangeRecords<Hospital> data = dataHandler.CustomObjectData<Hospital>();
                IList<Hospital> selDeleted = data.Deleted;
                Guid[] hosList = (from p in selDeleted select p.Id).ToArray<Guid>();

                Bll.DeleteTenderProduct(hosList);

                this.gpProduct.Reload();
                e.Cancel = true;
            }
        }
        #endregion PageStore
        protected void DeleteHospital_Click(object sender, AjaxEventArgs e)
        {
            RowSelectionModel sm = this.gpHospitalList.SelectionModel.Primary as RowSelectionModel;
            string id = sm.SelectedRow.RecordID;
            if (!string.IsNullOrEmpty(id))
            {
                Hashtable obj = new Hashtable();
                obj.Add("DtmId", this.MainId);
                obj.Add("DthId", id);
                bool isdeleted = Bll.DeleteTenderHospital(obj);
                e.Success = isdeleted;
            }
        }
        /// <summary>
        /// 选择医院后，添加数据
        /// </summary>
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

            Bll.SaveHospitalOfAuthorization(this.MainId, selected);
            this.gpHospitalList.Reload();
        }
        //经销商重名验证
        [AjaxMethod]
        public string CheckDealerName(string Dealername, string DealerType, string ProductLineId, string cbWdSubBU, string SuperiorDealer)
        {
            string rtnMassage = "";
            Hashtable obj = new Hashtable();
            obj.Add("DealerName", Dealername);
            obj.Add("DealerType", DealerType);
            obj.Add("ProductLineId", ProductLineId);
            obj.Add("SubBU", ProductLineId);
            if (SuperiorDealer != "")
            {
                obj.Add("SupDealer", SuperiorDealer);
            }
            DataTable query = Bll.CheckTenderDealerName(obj).Tables[0];

            if (query.Rows.Count > 0)
            {
                rtnMassage = "系统中已包含同名经销商";
            }
            return rtnMassage;
        }
        [AjaxMethod]
        public void DeleteAttachment(string id, string fileName)
        {
            try
            {
                //逻辑删除
                attachmentBLL.DelAttachment(new Guid(id));
                //物理删除
                string uploadFile = Server.MapPath("..\\..\\Upload\\UploadFile\\TenderFile");
                File.Delete(uploadFile + "\\" + fileName);
            }
            catch (Exception ex)
            {
                Ext.Msg.Alert("Error", "删除失败").Show();
            }
        }
        //清空授权医院
        [AjaxMethod]
        public void ClearHospital()
        {
            string DtmId = this.MainId.ToString();
            Bll.ClearHospitalProduct(DtmId);
            Bll.ClearHospital(DtmId);
                   
        }

        //清空授权产品
        [AjaxMethod]
        public void ClearHospitalProduct()
        {
            string DtmId = this.MainId.ToString();
            Bll.ClearHospitalProduct(DtmId);
        }

        [AjaxMethod]
        public void addProduct(string param)
        {
            param = param.Substring(0, param.Length - 1);
            Hashtable obj = new Hashtable();
            obj.Add("ProductString", param);
            obj.Add("DthId", this.hidDthId.Value);
            Bll.AddTenderProduct(obj);
        }
        [AjaxMethod]
        //提交验证
        public string checkAttachment()
        {
            AuthorizationTenderMain header = this.GetFormValue();
            Hashtable param = ReturnHashtable();
            string retMassage = "errey";
            //判断上传证件
            string retValue = Bll.CheckTenderAttachment(this.MainId);
            if (this.AtulicenseTypeNo.Checked && retValue == "2")
            {
                retMassage = "success";
            }
            else if (retValue == "2" || retValue == "1")
            {
                retMassage = "success";
            }

            return retMassage;
        }

        //获取页面的值
        private Hashtable ReturnHashtable()
        {
            Hashtable param = new Hashtable();
            if (!string.IsNullOrEmpty(this.AtuDealerName.Text))
            {
                param.Add("AtuDealerName", this.AtuDealerName.Text);
            }
            if (!string.IsNullOrEmpty(this.cbDealerType.SelectedItem.Value))
            {
                param.Add("cbDealerType", this.cbDealerType.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.cbProductLine.SelectedItem.Value))
            {
                param.Add("cbProductLine", this.cbProductLine.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.cbWdSubBU.SelectedItem.Value))
            {
                param.Add("cbWdSubBU", this.cbWdSubBU.SelectedItem.Value);
            }
            if (!this.AtuBeginDate.IsNull)
            {
                param.Add("AtuBeginDate", this.AtuBeginDate.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!this.AtuEndDate.IsNull)
            {
                param.Add("AtuEndDate", this.AtuEndDate.SelectedDate.ToString("yyyyMMdd"));
            }
            return param;
        }
        [AjaxMethod]
        public void SaveDraft()
        {
            AuthorizationTenderMain header = this.GetFormValue();
            header.States = "Draft";
            Bll.SaveAuthTenderMain(header, "doSave");
        }
        [AjaxMethod]
        public void DeleteDraft()
        {
            Bll.DeleteAuthTenderMain(this.MainId);
        }
        [AjaxMethod]
        public void SaveSubmint()
        {
            AuthorizationTenderMain header = this.GetFormValue();
            header.States = "InApproval";
            Bll.SaveAuthTenderMain(header, "doSubmit");
        }
        #region Page Event
        //附件上传
        protected void UploadClick(object sender, AjaxEventArgs e)
        {
            try
            {
                if (this.FileUploadField1.HasFile)
                {
                    bool error = false;

                    string fileName = FileUploadField1.PostedFile.FileName;
                    string fileExtention = string.Empty;
                    string fileExt = string.Empty;
                    if (fileName.LastIndexOf(".") < 0)
                    {
                        error = true;
                    }
                    else
                    {
                        fileExtention = fileName.Substring(fileName.LastIndexOf("\\") + 1);
                        fileExt = fileName.Substring(fileName.LastIndexOf(".") + 1).ToLower();
                    }

                    if (error)
                    {
                        Ext.Msg.Show(new MessageBox.Config
                        {
                            Buttons = MessageBox.Button.OK,
                            Icon = MessageBox.Icon.INFO,
                            Title = "文件错误",
                            Message = "请上传正确的文件！"
                        });

                        return;
                    }

                    //构造文件名称

                    string newFileName = DateTime.Now.ToFileTime().ToString() + "." + fileExt;

                    //上传文件在Upload文件夹

                    string file = Server.MapPath("~") + "\\Upload\\UploadFile\\TenderFile\\" + newFileName;


                    //文件上传
                    FileUploadField1.PostedFile.SaveAs(file);

                    Attachment attach = new Attachment();
                    attach.Id = Guid.NewGuid();
                    attach.MainId = new Guid(MainId);
                    attach.Name = fileExtention;
                    attach.Url = newFileName;
                    attach.Type = this.cbFileType.SelectedItem.Value;
                    attach.UploadDate = DateTime.Now;
                    attach.UploadUser = new Guid(_context.User.Id);
                    //维护附件信息
                    bool ckUpload = attachmentBLL.AddAttachment(attach);

                    Ext.Msg.Show(new MessageBox.Config
                    {
                        Buttons = MessageBox.Button.OK,
                        Icon = MessageBox.Icon.INFO,
                        Title = "上传成功",
                        Message = "已成功上传文件！"
                    });
                }
                else
                {
                    Ext.Msg.Show(new MessageBox.Config
                    {
                        Buttons = MessageBox.Button.OK,
                        Icon = MessageBox.Icon.ERROR,
                        Title = "上传失败",
                        Message = "文件未被成功上传！"
                    });
                }
            }
            catch (Exception ex)
            {
                Ext.Msg.Show(new MessageBox.Config
                {
                    Buttons = MessageBox.Button.OK,
                    Icon = MessageBox.Icon.ERROR,
                    Title = "上传失败",
                    Message = ex.ToString()
                });
            }
        }
        #endregion

        #region PageLoad
        public void BindPage()
        {
            PagesValueClear();
            PageStateClear();
            PagesValueSet();
            PageStateSet();
            this.gpHospitalList.Reload();
        }
        public void PagesValueClear()
        {
            this.AtuNo.Clear();
            this.cbProductLine.SelectedItem.Value = "";
            this.cbDealerType.SelectedItem.Value = "";
            this.AtuApplyUser.Clear();
            this.AtuApplyDate.Text = "";
            this.AtuBeginDate.Clear();
            this.AtuEndDate.Clear();
            this.AtulicenseTypeYes.Checked = false;
            this.AtulicenseTypeNo.Checked = false;
            this.AtuDealerName.Clear();
            this.AtuRemark.Clear();
            this.hidDthId.Clear();
            this.hidStates.Clear();
            this.atuDealerRemark.Text = "";
            this.AtuMailAddress.Clear();


        }
        //新增页面加载
        public void PagesValueSet()
        {
            if (!IsPageNew)
            {
                AuthorizationTenderMain Head = Bll.GetTenderMainById(new Guid(MainId));
                if (Head != null)
                {
                    this.AtuNo.Text = Head.No;
                    this.cbProductLine.SelectedItem.Value = Head.ProductLineId.ToString();
                    this.hidProductLine.Value = Head.ProductLineId.ToString();
                    this.cbDealerType.SelectedItem.Value = Head.DealerType;
                    this.AtuApplyUser.Text = Head.CreateUser;

                    if (Head.ProductLineId.ToString() != "")
                    {
                        DataSet dsSubBu = _business.GetSubBU(Head.ProductLineId.ToString());
                        SubBUStore.DataSource = dsSubBu;
                        SubBUStore.DataBind();
                        this.cbWdSubBU.SelectedItem.Value = Head.SubBU;
                        this.hidProductLine.Value = Head.SubBU;
                    }
                    this.MainStates = Head.States;
                    if (MainStates == "Draft" && cbDealerType.SelectedItem.Value == "T2")
                    {
                        this.SuperiorDealer.SelectedItem.Value = Head.SupDealer.ToString();
                        SuperiorDealer.Show();
                    }
                    else
                    {
                        SuperiorDealer.Hide();

                    }

                    if (Head.ApplicType == null)
                    {
                        this.Bind_Authorization(this.AuthorizationInfoStore, SR.Provisional_Authorization);
                    }
                    else
                    {
                        this.Bind_Authorization(this.AuthorizationInfoStore, SR.Provisional_Authorization);
                        this.AuthorizationInfo.SelectedItem.Value = Head.ApplicType;
                    }
                    if (Head.CreateDate != null)
                    {
                        this.AtuApplyDate.Text = Head.CreateDate.Value.ToString();
                    }
                    if (Head.BeginDate != null)
                    {
                        this.AtuBeginDate.SelectedDate = Head.BeginDate.Value;
                    }
                    if (Head.EndDate != null)
                    {
                        this.AtuEndDate.SelectedDate = Head.EndDate.Value;
                    }
                    this.AtuDealerName.Text = Head.DealerName;

                    if (Head.LicenceType != null && !Head.LicenceType.Value)
                    {
                        this.AtulicenseTypeYes.Checked = false;
                        this.AtulicenseTypeNo.Checked = true;
                    }
                    else
                    {
                        this.AtulicenseTypeYes.Checked = true;
                        this.AtulicenseTypeNo.Checked = false;
                    }
                    this.AtuRemark.Text = Head.Remark1;
                    if (Head.DealerType != null)
                    {
                        this.cbDealerType.SelectedItem.Value = Head.DealerType.ToString();
                    }
                    this.AtuMailAddress.Text = Head.DealerAddress;
                    this.MainStates = Head.States;
                    this.atuDealerRemark.Text = Head.Remark2;
                }
            }
            else
            {
                this.MainStates = "Draft";
                this.AtulicenseTypeYes.Checked = true;

                AuthorizationTenderMain Head = new AuthorizationTenderMain();
                Head.Id = new Guid(this.MainId);
                Head.States = this.MainStates;
                Head.LicenceType = true;
                Bll.InsertTenderMain(Head);
            }
        }
        public void PageStateClear()
        {
            this.btnAddHospital.Disabled = true;
            this.btnDeleteHospital.Disabled = true;
            this.BtnAddProduct.Disabled = true;
            this.BtnDelProduct.Disabled = true;
            this.btnAddAttachment.Disabled = true;
            this.gpAttachment.ColumnModel.SetHidden(4, true);
            this.gpAttachment.ColumnModel.SetHidden(5, true);
            this.gpHospitalList.ColumnModel.SetHidden(7, true);
            this.BtnDraft.Hidden = true;
            this.BtnApprove.Hidden = true;
            this.BtnDeleteDraft.Hidden = true;
        }
        public void PageStateSet()
        {
            if (MainStates == "Draft" || MainStates == "Deny")
            {
                this.btnAddHospital.Disabled = false;
                this.BtnAddProduct.Disabled = false;
                this.btnAddAttachment.Disabled = false;
                this.gpAttachment.ColumnModel.SetHidden(4, false);
                this.gpAttachment.ColumnModel.SetHidden(5, false);
                this.gpHospitalList.ColumnModel.SetHidden(7, false);
                this.BtnDraft.Hidden = false;
                this.BtnApprove.Hidden = false;
                this.BtnDeleteDraft.Hidden = false;
            }
        }
        public AuthorizationTenderMain GetFormValue()
        {
            AuthorizationTenderMain main = new AuthorizationTenderMain();
            main.Id = new Guid(MainId);
            main.No = this.AtuNo.Text;
            main.DealerName = this.AtuDealerName.Text;
            if (!string.IsNullOrEmpty(this.cbProductLine.SelectedItem.Value))
            {
                main.ProductLineId = new Guid(this.cbProductLine.SelectedItem.Value);
            }
            if (this.AtuBeginDate.SelectedDate > DateTime.MinValue)
            {
                main.BeginDate = this.AtuBeginDate.SelectedDate;
            }
            if (this.AtuEndDate.SelectedDate > DateTime.MinValue)
            {
                main.EndDate = this.AtuEndDate.SelectedDate;
            }

            main.ApplicType = this.AuthorizationInfo.SelectedItem.Value;
            main.CreateDate = DateTime.Now;
            main.CreateUser = _context.UserName;
            main.LicenceType = this.AtulicenseTypeYes.Checked ? true : false;
            main.DealerAddress = this.AtuMailAddress.Text;
            main.DealerType = this.cbDealerType.SelectedItem.Value;
            main.Remark1 = this.AtuRemark.Text;
            main.SubBU = this.cbWdSubBU.SelectedItem.Value;
            if (!string.IsNullOrEmpty(this.SuperiorDealer.SelectedItem.Value))
            {
                main.SupDealer = new Guid(this.SuperiorDealer.SelectedItem.Value);
            }
            if (!this.AtuDealerName.Text.Equals("") && !this.cbDealerType.SelectedItem.Value.Equals("") && !this.cbProductLine.SelectedItem.Value.Equals(""))
            {
                main.Remark2 = CheckDealerName(this.AtuDealerName.Text, this.cbDealerType.SelectedItem.Value, this.cbProductLine.SelectedItem.Value, this.cbWdSubBU.SelectedItem.Value, this.SuperiorDealer.SelectedItem.Value);
            }
            return main;
        }
        #endregion

        #region HospitalDept
        [AjaxMethod]
        public void HospitalDeptShow(string dthId, string hospitalCode, string hospitalName, string hospitalDept)
        {
            
            this.hidWindowDthId.Clear();
            this.lbWindowHosCode.Text = "";
            this.lbWindowHosName.Text = "";
            this.txtWidnowHosDept.Clear();
         
            this.hidWindowDthId.Value = dthId;
            this.lbWindowHosCode.Text = hospitalCode;
            this.lbWindowHosName.Text = hospitalName;
            this.txtWidnowHosDept.Text = hospitalDept;
            this.HospitalDeptWindow.Show();
        }
        [AjaxMethod]
        public void SaveHospitalDept()
        {
            Hashtable obj = new Hashtable();
            obj.Add("DthId", this.hidWindowDthId.Value);
            obj.Add("DthDept", this.txtWidnowHosDept.Text);
            Bll.UpdateTenderHospitalDept(obj);
        }
        #endregion
        protected void ExportExcel(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(Request.QueryString["DtmId"]))
            {
                string id = Request.QueryString["DtmId"].ToString();
                DataTable dt = Bll.ExportHospitalProduct(id).Tables[0];
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
        }

    }
}