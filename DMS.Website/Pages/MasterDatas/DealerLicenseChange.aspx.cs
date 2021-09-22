using Coolite.Ext.Web;
using DMS.Business;
using DMS.Model;
using DMS.Model.Data;
using DMS.Website.Common;
using Lafite.RoleModel.Security;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DMS.Website.Pages.MasterDatas
{
    public partial class DealerLicenseChange : BasePage
    {
        IRoleModelContext _context = RoleModelContext.Current;
        private IDealerMasters _dealers = Global.ApplicationContainer.Resolve<IDealerMasters>();
        private IDealerMasters _dealersBLL = new DealerMasters();
        private IAttachmentBLL _attachBll = new AttachmentBLL();
        private IPurchaseOrderBLL _logbll = new PurchaseOrderBLL();

        protected void Page_Load(object sender, EventArgs e)
        {

            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                this.Bind_DealerList(this.DealerStore);

                this.hidDealerId.Text = Request.QueryString["ct"].ToString();
                if (!IsDealer)
                {
                    this.btnInsert.Hidden = true;
                    this.btnsave.Hidden = true;
                    this.btnsubmit.Hidden = true;
                    this.cbDealer.SelectedItem.Value = this.hidDealerId.Text;

                }
                else
                {

                    this.cbDealer.SelectedItem.Value = this.hidDealerId.Text;
                    this.cbDealer.Disabled = true;
                }

            }
        }


        [AjaxMethod]
        public void DetailWindowShow(string id, string Status)
        {
            if (Status != "草稿" && id != ""&& Status != "审批拒绝")
            {
                this.NewCurRespPerson.Disabled = true;
                this.NewCurLegalPerson.Disabled = true;
                this.NewLicenseNo.Disabled = true;
                this.NewLicenseNoValidFrom.Disabled = true;
                this.NewLicenseNoValidTo.Disabled = true;
                this.NewFilingNo.Disabled = true;
                this.NewFilingNoValidFrom.Disabled = true;
                this.NewFilingNoValidTo.Disabled = true;
                this.cbaddresstype.Disabled = true;
                this.txtRemark.Disabled = true;
                this.Addressbtn.Hidden = true;
                this.btnAddCatagory.Hidden = true;
                this.btnAddCatagoryThird.Hidden = true;
                this.btnAddAttach.Hidden = true;
                this.gpNewAttachment.ColumnModel.SetHidden(7, true);
                this.GridPanel2.ColumnModel.SetHidden(4, true);
                this.GridPanel2.ColumnModel.SetHidden(5, true);
                this.btnsubmit.Hidden = true;
                this.btnsave.Hidden = true;
                this.btndelete.Hidden = true;
            }
            else
            {
                this.NewCurRespPerson.Disabled = false;
                this.NewCurLegalPerson.Disabled = false;
                this.NewLicenseNo.Disabled = false;
                this.NewLicenseNoValidFrom.Disabled = false;
                this.NewLicenseNoValidTo.Disabled = false;
                this.NewFilingNo.Disabled = false;
                this.NewFilingNoValidFrom.Disabled = false;
                this.NewFilingNoValidTo.Disabled = false;
                this.cbaddresstype.Disabled = false;
                this.txtRemark.Disabled = false;
                this.Addressbtn.Hidden = false;
                this.btnAddCatagory.Hidden = false;
                this.btnAddCatagoryThird.Hidden = false;
                this.btnAddAttach.Hidden = false;
                this.gpNewAttachment.ColumnModel.SetHidden(7, false);
                this.GridPanel2.ColumnModel.SetHidden(4, false);
                this.GridPanel2.ColumnModel.SetHidden(5, false);
                this.btnsubmit.Hidden = false;
                this.btnsave.Hidden = false;
                this.btndelete.Hidden = false;
            }

            //新增
            if (id == "")
            {
                this.HidApplyStatus.Value = "new";
                this.hiddenNewApplyId.Text = Guid.NewGuid().ToString();
                _dealersBLL.insertShipToAddress(new Guid(this.hiddenNewApplyId.Text), new Guid(this.cbDealer.SelectedItem.Value));
                this.InitDetailWindow();

            }
            else
            {

                this.hiddenNewApplyId.Text = id;
                this.gpNewAttachment.Reload();
                this.InitDetailWindow2();
            }
        }

        public void InitDetailWindow2()
        {
            this.winHidAppNo.Text = "";
            this.winHidSalesRep.Text = "";
            this.NewCurRespPerson.Text = "";
            this.NewCurLegalPerson.Text = "";
            this.NewLicenseNo.Text = "";
            this.NewLicenseNoValidFrom.Clear();
            this.NewLicenseNoValidTo.Clear();
            this.NewFilingNo.Text = "";
            this.NewFilingNoValidFrom.Clear();
            this.NewFilingNoValidTo.Clear();
            this.IssendAddress.Checked = false;
            this.cbaddresstype.SelectedItem.Value = "";
            this.txtRemark.Text = "";
            this.NewSecondClassCatagoryStore.RemoveAll();
            this.NewThirdClassCatagoryStore.RemoveAll();
            this.NewThirdStore.RemoveAll();
            this.NewSecondStore.RemoveAll();
            this.TabPanel1.ActiveTabIndex = 0;


            DataTable dml = _dealersBLL.GetCFDAProcess(this.hiddenNewApplyId.Text.ToString()).Tables[0];
            if (dml != null)
            {
                //给当前的控件赋值
                this.HidApplyStatus.Value = dml.Rows[0]["DML_NewApplyStatus"].ToString();
                this.NewLicenseNo.Text = dml.Rows[0]["DML_NewLicenseNo"].ToString();
                this.NewCurRespPerson.Text = dml.Rows[0]["DML_NewCurRespPerson"].ToString();
                this.NewCurLegalPerson.Text = dml.Rows[0]["DML_NewCurLegalPerson"].ToString();
                if (dml.Rows[0]["DML_NewLicenseValidFrom"] != null && !String.IsNullOrEmpty(dml.Rows[0]["DML_NewLicenseValidFrom"].ToString()))
                {
                    this.NewLicenseNoValidFrom.SelectedDate = Convert.ToDateTime(dml.Rows[0]["DML_NewLicenseValidFrom"]);
                }
                if (dml.Rows[0]["DML_NewLicenseValidTo"] != null && !String.IsNullOrEmpty(dml.Rows[0]["DML_NewLicenseValidTo"].ToString()))
                {
                    this.NewLicenseNoValidTo.SelectedDate = Convert.ToDateTime(dml.Rows[0]["DML_NewLicenseValidTo"]);
                }
                this.NewFilingNo.Text = dml.Rows[0]["DML_NewFilingNo"].ToString();
                if (dml.Rows[0]["DML_NewFilingValidFrom"] != null && !String.IsNullOrEmpty(dml.Rows[0]["DML_NewFilingValidFrom"].ToString()))
                {
                    this.NewFilingNoValidFrom.SelectedDate = Convert.ToDateTime(dml.Rows[0]["DML_NewFilingValidFrom"]);
                }
                if (dml.Rows[0]["DML_NewLicenseValidTo"] != null && !String.IsNullOrEmpty(dml.Rows[0]["DML_NewLicenseValidTo"].ToString()))
                {
                    this.NewLicenseNoValidTo.SelectedDate = Convert.ToDateTime(dml.Rows[0]["DML_NewLicenseValidTo"]);
                }
                //if (dml.Rows[0]["SecondClass2012"] != null)
                //{
                //    this.hidNewSecondClassCatagory.Text = dml.Rows[0]["SecondClass2012"].ToString();
                //    this.Bind_NewSecondClassCatagory(this.hidNewSecondClassCatagory.Text);
                //}
                //if (dml.Rows[0]["DML_NewThirdClassCatagory"] != null)
                //{
                //    this.hidNewThirdClassCatagory.Text = dml.Rows[0]["DML_NewThirdClassCatagory"].ToString();
                //    this.Bind_NewThirdClassCatagory(this.hidNewThirdClassCatagory.Text);
                //}

                if (dml.Rows[0]["SecondClass2012"] != null)
                {
                    this.hiddenSecondClass2012.Text = dml.Rows[0]["SecondClass2012"].ToString();
                    this.Bind_NewSecondClassCatagory(this.hiddenSecondClass2012.Text);
                }

                if (dml.Rows[0]["SecondClass2017"] != null)
                {
                    this.hiddenSecondClass2017.Text = dml.Rows[0]["SecondClass2017"].ToString();
                    this.Bind_NewSecondStore(this.hiddenSecondClass2017.Text);
                }

                if (dml.Rows[0]["ThirdClass2012"] != null)
                {
                    this.hiddenThirdClass2012.Text = dml.Rows[0]["ThirdClass2012"].ToString();
                    this.Bind_NewThirdClassCatagory(this.hiddenThirdClass2012.Text);
                }

                if (dml.Rows[0]["ThirdClass2017"] != null)
                {
                    this.hiddenThirdClass2017.Text = dml.Rows[0]["ThirdClass2017"].ToString();
                    this.Bind_NewThirdStore(this.hiddenThirdClass2017.Text);
                }

                if (dml.Rows[0]["DML_SalesRep"] != null)
                {
                    this.winHidSalesRep.Value = dml.Rows[0]["DML_SalesRep"].ToString();
                }
                if (dml.Rows[0]["DML_NewApplyNO"] != null)
                {
                    this.winHidAppNo.Value = dml.Rows[0]["DML_NewApplyNO"].ToString();
                }

                this.gpNewAttachment.Reload();
                this.GridPanel2.Reload();
                this.DetailWindow.Show();
            }
        }
        public void InitDetailWindow()
        {
            this.winHidSalesRep.Text = "";
            this.hiddenSecondClass2012.Text = "";
            this.hiddenSecondClass2017.Text = "";
            this.hiddenThirdClass2012.Text = "";
            this.hiddenThirdClass2017.Text = "";
            this.NewCurRespPerson.Text = "";
            this.NewCurLegalPerson.Text = "";
            this.NewLicenseNo.Text = "";
            this.NewLicenseNoValidFrom.Clear();
            this.NewLicenseNoValidTo.Clear();
            this.NewFilingNo.Text = "";
            this.NewFilingNoValidFrom.Clear();
            this.NewFilingNoValidTo.Clear();
            this.IssendAddress.Checked = false;
            this.cbaddresstype.SelectedItem.Value = "";
            this.txtRemark.Text = "";
            this.TabPanel1.ActiveTabIndex = 0;

            DataTable licenseTable = _dealersBLL.GetDealerMasterLicenseToTable(this.cbDealer.SelectedItem.Value.ToString()).Tables[0];

            if (licenseTable.Rows.Count>0)
            {
                DataRow licenseRow = licenseTable.Rows[0];
                //给当前的控件赋值
                //this.NewLicenseNo.Text = string.IsNullOrEmpty(dml.CurLicenseNo) ? "" : dml.CurLicenseNo;
                this.NewLicenseNo.Text = licenseRow["CurLicenseNo"]==null ? "" : licenseRow["CurLicenseNo"].ToString();

                //this.NewCurRespPerson.Text = string.IsNullOrEmpty(dml.CurRespPerson) ? "" : dml.CurRespPerson;
                this.NewCurRespPerson.Text = licenseRow["CurRespPerson"] == null ? "" : licenseRow["CurRespPerson"].ToString();

                //this.NewCurLegalPerson.Text = string.IsNullOrEmpty(dml.CurLegalPerson) ? "" : dml.CurLegalPerson;
                this.NewCurLegalPerson.Text = licenseRow["CurLegalPerson"] == null ? "" : licenseRow["CurLegalPerson"].ToString();

                //if (dml.CurLicenseValidFrom != null && !String.IsNullOrEmpty(dml.CurLicenseValidFrom.ToString()))
                //{
                //    NewLicenseNoValidFrom.SelectedDate = Convert.ToDateTime(dml.CurLicenseValidFrom);
                //}
                if (licenseRow["CurLicenseValidFrom"] != null && !String.IsNullOrEmpty(licenseRow["CurLicenseValidFrom"].ToString()))
                {
                    NewLicenseNoValidFrom.SelectedDate = Convert.ToDateTime(licenseRow["CurLicenseValidFrom"]);
                }

                //if (dml.CurLicenseValidTo != null && !String.IsNullOrEmpty(dml.CurLicenseValidTo.ToString()))
                //{
                //    NewLicenseNoValidTo.SelectedDate = Convert.ToDateTime(dml.CurLicenseValidTo);
                //}
                if (licenseRow["CurLicenseValidTo"] != null && !String.IsNullOrEmpty(licenseRow["CurLicenseValidTo"].ToString()))
                {
                    NewLicenseNoValidTo.SelectedDate = Convert.ToDateTime(licenseRow["CurLicenseValidTo"]);
                }

                //this.NewFilingNo.Text = string.IsNullOrEmpty(dml.CurFilingNo) ? "" : dml.CurFilingNo;
                this.NewFilingNo.Text = licenseRow["CurFilingNo"] == null ? "" : licenseRow["CurFilingNo"].ToString();

                //if (dml.CurFilingValidFrom != null && !String.IsNullOrEmpty(dml.CurFilingValidFrom.ToString()))
                //{
                //    NewFilingNoValidFrom.SelectedDate = Convert.ToDateTime(dml.CurFilingValidFrom);
                //}
                if (licenseRow["CurFilingValidFrom"] != null && !String.IsNullOrEmpty(licenseRow["CurFilingValidFrom"].ToString()))
                {
                    NewFilingNoValidFrom.SelectedDate = Convert.ToDateTime(licenseRow["CurFilingValidFrom"]);
                }

                //if (dml.CurFilingValidTo != null && !String.IsNullOrEmpty(dml.CurFilingValidTo.ToString()))
                //{
                //    NewFilingNoValidTo.SelectedDate = Convert.ToDateTime(dml.CurFilingValidTo);
                //}
                if (licenseRow["CurFilingValidFrom"] != null && !String.IsNullOrEmpty(licenseRow["CurFilingValidFrom"].ToString()))
                {
                    NewFilingNoValidTo.SelectedDate = Convert.ToDateTime(licenseRow["CurFilingValidFrom"]);
                }

                //if (!String.IsNullOrEmpty(dml.CurSecondClassCatagory))
                //{
                //    this.hidCurSecondClassCatagory.Text = dml.CurSecondClassCatagory;
                //}
                if (licenseRow["SecondClass2012"] != null)
                {
                    this.hiddenSecondClass2012.Text = licenseRow["SecondClass2012"].ToString();
                }
                this.Bind_NewSecondClassCatagory(this.hiddenSecondClass2012.Text);

                if (licenseRow["SecondClass2017"] != null)
                {
                    this.hiddenSecondClass2017.Text = licenseRow["SecondClass2017"].ToString();
                }
                this.Bind_NewSecondStore(this.hiddenSecondClass2017.Text);

                if (licenseRow["ThirdClass2012"] != null)
                {
                    this.hiddenThirdClass2012.Text = licenseRow["ThirdClass2012"].ToString();
                }
                this.Bind_NewThirdClassCatagory(this.hiddenThirdClass2012.Text);

                if (licenseRow["ThirdClass2017"] != null)
                {
                    this.hiddenThirdClass2017.Text = licenseRow["ThirdClass2017"].ToString();
                }
                this.Bind_NewThirdStore(this.hiddenThirdClass2017.Text);

                //if (!String.IsNullOrEmpty(dml.SalesRep))
                //{
                //    this.winHidSalesRep.Text = dml.SalesRep;
                //}
            }
            this.gpNewAttachment.Reload();
            this.GridPanel2.Reload();
            this.DetailWindow.Show();
        }
        [AjaxMethod]
        public void RefreshNewCatagoryGrid(string strCatId, string catagoryType,string versionNumber)
        {
            if (catagoryType.Equals("三类") && versionNumber.Equals("2002版"))
            {
                this.hiddenThirdClass2012.Text = strCatId;
                this.Bind_NewThirdClassCatagory(strCatId);
            }
            else if (catagoryType.Equals("三类") && versionNumber.Equals("2017版"))
            {
                this.hiddenThirdClass2017.Text = strCatId;
                this.Bind_NewThirdStore(strCatId);
            }
            else if (catagoryType.Equals("二类") && versionNumber.Equals("2002版"))
            {
                this.hiddenSecondClass2012.Text = strCatId;
                this.Bind_NewSecondClassCatagory(strCatId);
            }
            else if (catagoryType.Equals("二类") && versionNumber.Equals("2017版"))
            {
                this.hiddenSecondClass2017.Text = strCatId;
                this.Bind_NewSecondStore(strCatId);
            }

            this.DialogCatagoryWindow.Hide();
        }
        protected void Bind_NewSecondClassCatagory(String strNewSecondCatId)
        {
            DataSet ds = null;
            ds = _dealersBLL.GetDealerLicenseCatagoryByCatId(strNewSecondCatId, LicenseCatagoryLevel.二类.ToString(), "2002版");

            this.NewSecondClassCatagoryStore.DataSource = ds;
            this.NewSecondClassCatagoryStore.DataBind();
        }
        protected void Bind_NewSecondStore(String strNewSecondCatId)
        {
            DataSet ds = null;
            ds = _dealersBLL.GetDealerLicenseCatagoryByCatId(strNewSecondCatId, LicenseCatagoryLevel.二类.ToString(), "2017版");

            this.NewSecondStore.DataSource = ds;
            this.NewSecondStore.DataBind();
        }
        protected void Bind_NewThirdClassCatagory(String strNewThirdCatId)
        {
            DataSet ds = null;
            ds = _dealersBLL.GetDealerLicenseCatagoryByCatId(strNewThirdCatId, LicenseCatagoryLevel.三类.ToString(), "2002版");

            this.NewThirdClassCatagoryStore.DataSource = ds;
            this.NewThirdClassCatagoryStore.DataBind();
        }
        protected void Bind_NewThirdStore(String strNewThirdCatId)
        {
            DataSet ds = null;
            ds = _dealersBLL.GetDealerLicenseCatagoryByCatId(strNewThirdCatId, LicenseCatagoryLevel.三类.ToString(), "2017版");

            this.NewThirdStore.DataSource = ds;
            this.NewThirdStore.DataBind();
        }
        protected void LicenseCatagoryStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            Hashtable param = new Hashtable();

            if (!string.IsNullOrEmpty(this.hiddenDialogCatagoryType.Text))
            {
                param.Add("catType", this.hiddenDialogCatagoryType.Text);
            }
            if (!string.IsNullOrEmpty(this.hiddenDialogCatagoryID.Text))
            {
                param.Add("catId", this.hiddenDialogCatagoryID.Text);
            }
            if (!string.IsNullOrEmpty(this.hiddenDialogCatagoryName.Text))
            {
                param.Add("catName", this.hiddenDialogCatagoryName.Text);
            }
            if (!string.IsNullOrEmpty(this.txtCFN.Text))
            {
                param.Add("catId", this.txtCFN.Text);
            }
            if (!string.IsNullOrEmpty(this.txtLotNumber.Text))
            {
                param.Add("catName", this.txtLotNumber.Text);
            }
            if (!string.IsNullOrEmpty(this.hiddenVersionNumber.Text))
            {
                param.Add("versionNumber", this.hiddenVersionNumber.Text);
            }
            DataSet ds = null;
            ds = _dealersBLL.GetLicenseCatagoryByCatType(param);

            this.LicenseCatagoryStore.DataSource = ds;
            this.LicenseCatagoryStore.DataBind();


        }
        protected void Store1_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;

            Hashtable hs = new Hashtable();
            if (!string.IsNullOrEmpty(this.cbDealer.SelectedItem.Value))
            {
                hs.Add("DmaId", this.cbDealer.SelectedItem.Value.ToString());
            }
            if (!string.IsNullOrEmpty(this.CFDAProcessNo.Value.ToString()))
            {
                hs.Add("NewApplyNO", this.CFDAProcessNo.Value.ToString());
            }
            if (!string.IsNullOrEmpty(this.cbStatus.SelectedItem.Value))
            {

                hs.Add("NewApplyStatus", this.cbStatus.SelectedItem.Value);
            }
            DataSet dt = _dealersBLL.GetCFDAHead(hs, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);
            this.Store1.DataSource = dt;
            this.Store1.DataBind();
        }
        protected void BscSalesStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            Hashtable param = new Hashtable();
            if (!string.IsNullOrEmpty(this.cbDealer.SelectedItem.Value))
            {
                param.Add("DmaId", this.hidDealerId.Text);
            }
            DataSet ds = _dealersBLL.GetSalesRepByParam(param);

            this.BscSalesStore.DataSource = ds;
            this.BscSalesStore.DataBind();


        }
        [AjaxMethod]
        public void AddressWindowshow()
        { //获取当前经销商的有效的shipto的地址
            DataSet dt = _dealersBLL.GetShiptoAddress(new Guid(this.hiddenNewApplyId.Text));
            if (dt.Tables[0].Rows.Count == 1)
            {
                this.hidisshitoaddress.Value = dt.Tables[0].Rows[0]["ST_Address"].ToString();
            }
            if (dt.Tables[0].Rows.Count == 0)
            {
                this.hidisshitoaddress.Value = "N";
            }
            this.IssendAddress.Checked = false;
            this.cbaddresstype.SelectedItem.Value = "";
            this.txtRemark.Text = "";
            this.Hidstate.Value = "NoChecked";
            this.AddressWindow.Show();
        }
        [AjaxMethod]
        public void AddAddress()
        {
            if (this.hidOptType.Value.ToString() == "update")
            {
                _dealersBLL.updateshiptoaddress(new Guid(this.cbDealer.SelectedItem.Value));
            }
            Hashtable hs = new Hashtable();
            hs.Add("id", Guid.NewGuid());
            hs.Add("dealerid", this.cbDealer.SelectedItem.Value.ToString());
            hs.Add("Type", this.cbaddresstype.SelectedItem.Value.ToString());
            hs.Add("Address", this.txtRemark.Value.ToString());
            hs.Add("ActiveFlag", "1");
            hs.Add("MID", this.hiddenNewApplyId.Text.ToString());
            if (this.IssendAddress.Checked)
            {
                hs.Add("IsSendAddress", "1");
            }
            else
                hs.Add("IsSendAddress", "0");
            hs.Add("CreateDate", DateTime.Now);
            _dealersBLL.addaddress(hs);
        }

        [AjaxMethod]
        public void ShowDialog(string dealerId, string catagoryType,string versionNumber)
        {
            this.hiddenDialogCatagoryType.Text = catagoryType;
            this.hiddenVersionNumber.Text = versionNumber;
            this.txtCFN.Text = "";
            this.txtLotNumber.Text = "";
            this.DialogCatagoryWindow.Show();
            this.gpDialogCatagory.Reload();
        }
        protected void NewAttachmentStore_Refresh(object sender, StoreRefreshDataEventArgs e)
        {

            int totalCount = 0;
            DataSet ds = _attachBll.GetAttachmentByMainId(new Guid(this.hiddenNewApplyId.Text), AttachmentType.DealerLicense, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBarNewAttachement.PageSize : e.Limit), out totalCount);
            e.TotalCount = totalCount;
            NewAttachmentStore.DataSource = ds;
            NewAttachmentStore.DataBind();
        }

        protected void ShipToAddress_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            DataSet dt = _dealersBLL.GetAddress(new Guid(this.hiddenNewApplyId.Text), (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBarNewAttachement.PageSize : e.Limit), out totalCount);
            e.TotalCount = totalCount;

            this.ShipToAddress.DataSource = dt;
            this.ShipToAddress.DataBind();
        }
        protected void UploadClick(object sender, AjaxEventArgs e)
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

                string file = Server.MapPath("\\Upload\\UploadFile\\LicenseCatagory\\" + newFileName);


                //文件上传
                FileUploadField1.PostedFile.SaveAs(file);

                this.hiddenFileName.Text = newFileName;

                Attachment attach = new Attachment();
                attach.Id = Guid.NewGuid();
                attach.MainId = new Guid(this.hiddenNewApplyId.Text);
                attach.Name = fileExtention;
                attach.Url = newFileName;
                attach.Type = AttachmentType.DealerLicense.ToString();
                attach.UploadDate = DateTime.Now;
                attach.UploadUser = new Guid(_context.User.Id);

                _attachBll.AddAttachment(attach);

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
        [AjaxMethod]
        public void DeleteAttachment(string id, string fileName)
        {
            try
            {
                _attachBll.DelAttachment(new Guid(id));
                string uploadFile = Server.MapPath("..\\..\\Upload\\UploadFile\\LicenseCatagory");
                File.Delete(uploadFile + "\\" + fileName);

            }
            catch (Exception ex)
            {
                Ext.Msg.Alert("Error", "删除附件失败，请联系DMS技术支持").Show();
            }
        }
        //逻辑删除
        [AjaxMethod]
        public void DeleteAddress(string id, string code)
        {
            if (code == "" || code == null)
            {
                _dealersBLL.DeleteSAPWarehouseAddress_temp(id);

            }
            else
            {
                _dealersBLL.updateaddress(id);
            }
        }
        [AjaxMethod]
        public void setstatue()
        {

            if (this.IssendAddress.Checked)
            {
                this.Hidstate.Value = "Checked";
            }
            else
                this.Hidstate.Value = "NoChecked";

        }

        [AjaxMethod]
        public string SaveDraft()
        {
            string masg = "0";
            DataSet ds = _dealersBLL.SelectSAPWarehouseAddress_temp(new Guid(this.hiddenNewApplyId.Text.ToString()));
            if (this.HidApplyStatus.Value.ToString() == "new" && this.hidsumit.Value.ToString() == "save")
            {
                insert("草稿");
            }
            else if ((this.HidApplyStatus.Value.ToString() == "草稿"|| this.HidApplyStatus.Value.ToString() == "审批拒绝") && this.hidsumit.Value.ToString() == "save")
            {
                update("草稿");
            }

            if (ds.Tables[0].Rows.Count > 1)
            {

                if (this.HidApplyStatus.Value.ToString() == "new" && this.hidsumit.Value.ToString() == "submit")
                {
                    DataSet dt = _dealersBLL.GetCFDAHeadAll(this.cbDealer.SelectedItem.Value.ToString(), "审批中");
                    if (dt.Tables[0].Rows.Count > 0)
                    {
                        masg = "1";
                    }
                    else
                    {
                        insert("审批中");
                    }
                }
                else if ((this.HidApplyStatus.Value.ToString() == "草稿"|| this.HidApplyStatus.Value.ToString() == "审批拒绝") && this.hidsumit.Value.ToString() == "submit")
                {
                    DataSet dt = _dealersBLL.GetCFDAHeadAll(this.cbDealer.SelectedItem.Value.ToString(), "审批中");
                    if (dt.Tables[0].Rows.Count > 0)
                    {
                        masg = "1";
                    }
                    else
                    {
                        update("审批中");
                    }
                }
            }
            else
            {
                masg = "2";
            }
            return masg;
        }

        public void update(string ApplyStatus)
        {
            string appNo = _dealers.GetNextCFDANo("CFDA", "Next_CFDA");
            Hashtable hs = new Hashtable();
            hs.Add("DML_NewCurLegalPerson", this.NewCurLegalPerson.Text);
            hs.Add("DML_NewCurRespPerson", this.NewCurRespPerson.Text);
            hs.Add("DML_MID", new Guid(this.hiddenNewApplyId.Text.ToString()));
            hs.Add("DML_DMA_ID", new Guid(this.cbDealer.SelectedItem.Value.ToString()));
            hs.Add("DML_NewApplyStatus", ApplyStatus);
            if (this.HidApplyStatus.Value.ToString() == "草稿" && this.hidsumit.Value.ToString() == "submit")
            {
                hs.Add("DML_NewApplyNO", appNo);
            }
            else if (this.hidsumit.Value.ToString() == "submit")
            {
                hs.Add("DML_NewApplyNO", this.winHidAppNo.Value);
            }

            hs.Add("DML_NewLicenseNo", this.NewLicenseNo.Text);
            if (!this.NewLicenseNoValidFrom.IsNull && NewLicenseNoValidFrom.SelectedDate != null)
            {
                hs.Add("DML_NewLicenseValidFrom", this.NewLicenseNoValidFrom.SelectedDate.ToString("yyyy-MM-dd"));
            }
            if (!this.NewLicenseNoValidTo.IsNull && NewLicenseNoValidTo.SelectedDate != null)
            {
                hs.Add("DML_NewLicenseValidTo", this.NewLicenseNoValidTo.SelectedDate.ToString("yyyy-MM-dd"));
            }
            hs.Add("DML_NewSecondClassCatagory", this.hiddenSecondClass2012.Text +","+ this.hiddenSecondClass2017.Text);
            hs.Add("DML_NewFilingNo", this.NewFilingNo.Text);
            if (!this.NewFilingNoValidFrom.IsNull && this.NewFilingNoValidFrom.SelectedDate != null)
            {
                hs.Add("DML_NewFilingValidFrom", this.NewFilingNoValidFrom.SelectedDate.ToString("yyyy-MM-dd"));
            }
            if (!this.NewFilingNoValidTo.IsNull && this.NewFilingNoValidTo.SelectedDate != null)
            {
                hs.Add("DML_NewFilingValidTo", this.NewFilingNoValidTo.SelectedDate.ToString("yyyy-MM-dd"));
            }
            hs.Add("DML_NewThirdClassCatagory", this.hiddenThirdClass2012.Text+","+ this.hiddenThirdClass2017.Text);
            hs.Add("DML_NewApplyDate", DateTime.Now);
            hs.Add("DML_NewApplyUser", new Guid(_context.User.Id));
            hs.Add("DML_SalesRep", this.windwcbBscSales.SelectedItem.Value.ToString());
            _dealers.UpdateDealerMasterLicenseModify(hs);

            if (ApplyStatus.Equals("审批中"))
            {
                _dealers.SubmintCfdaMflow(this.hiddenNewApplyId.Text.ToString(), appNo, this.windwcbBscSales.SelectedItem.Value.ToString());
            }
        }

        public void insert(string ApplyStatus)
        {
            string appNo = _dealers.GetNextCFDANo("CFDA", "Next_CFDA");

            Hashtable hs = new Hashtable();
            hs.Add("DML_NewCurLegalPerson", this.NewCurLegalPerson.Text);
            hs.Add("DML_NewCurRespPerson", this.NewCurRespPerson.Text);
            hs.Add("DML_MID", new Guid(this.hiddenNewApplyId.Text.ToString()));
            hs.Add("DML_DMA_ID", new Guid(this.cbDealer.SelectedItem.Value));
            if (this.HidApplyStatus.Value.ToString() == "new" && this.hidsumit.Value.ToString() == "submit")
            {
                hs.Add("DML_NewApplyNO", appNo);
            }
            hs.Add("DML_NewApplyStatus", ApplyStatus);
            hs.Add("DML_NewLicenseNo", this.NewLicenseNo.Text);
            if (!this.NewLicenseNoValidFrom.IsNull && NewLicenseNoValidFrom.SelectedDate != null)
            {
                hs.Add("DML_NewLicenseValidFrom", this.NewLicenseNoValidFrom.SelectedDate.ToString("yyyy-MM-dd"));
            }
            if (!this.NewLicenseNoValidTo.IsNull && NewLicenseNoValidTo.SelectedDate != null)
            {
                hs.Add("DML_NewLicenseValidTo", this.NewLicenseNoValidTo.SelectedDate.ToString("yyyy-MM-dd"));
            }
            hs.Add("DML_NewSecondClassCatagory", this.hiddenSecondClass2012.Text + "," + this.hiddenSecondClass2017.Text);
            hs.Add("DML_NewFilingNo", this.NewFilingNo.Text);
            if (!this.NewFilingNoValidFrom.IsNull && this.NewFilingNoValidFrom.SelectedDate != null)
            {
                hs.Add("DML_NewFilingValidFrom", this.NewFilingNoValidFrom.SelectedDate.ToString("yyyy-MM-dd"));
            }
            if (!this.NewFilingNoValidTo.IsNull && this.NewFilingNoValidTo.SelectedDate != null)
            {
                hs.Add("DML_NewFilingValidTo", this.NewFilingNoValidTo.SelectedDate.ToString("yyyy-MM-dd"));
            }
            hs.Add("DML_NewThirdClassCatagory", this.hiddenThirdClass2012.Text + "," + this.hiddenThirdClass2017.Text);
            hs.Add("DML_NewApplyDate", DateTime.Now);
            hs.Add("DML_NewApplyUser", new Guid(_context.User.Id));
            hs.Add("DML_SalesRep", this.windwcbBscSales.SelectedItem.Value.ToString());
            _dealers.insertDealerMasterLicenseModify(hs);

            if (ApplyStatus.Equals("审批中"))
            {
                _dealers.SubmintCfdaMflow(this.hiddenNewApplyId.Text.ToString(), appNo, this.windwcbBscSales.SelectedItem.Value.ToString());
            }
        }

        //删除草稿
        [AjaxMethod]
        public void delete()
        {
            _dealersBLL.DeleteAttachment(new Guid(this.hiddenNewApplyId.Text));
            _dealersBLL.DeleteShipToAddress(new Guid(this.hiddenNewApplyId.Text));
            _dealersBLL.DeleteDealerMasterLicenseModify(new Guid(this.hiddenNewApplyId.Text));
        }

        [AjaxMethod]
        public void updateshiptoaddressbtn(string ID, string IsSendAddress)
        {
            if (IsSendAddress == "是" && ID != "")
            {
                _dealersBLL.updateshiptoaddressbtn(ID, "0");
            }
            if (IsSendAddress == "否" && ID != "")
            {
                _dealersBLL.updateshiptoaddress(new Guid(this.cbDealer.SelectedItem.Value));
                _dealersBLL.updateshiptoaddressbtn(ID, "1");
            }
        }

    }

}
