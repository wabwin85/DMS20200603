using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Coolite.Ext.Web;
using DMS.Website.Common;
using DMS.Common;
using System.Collections;
using System.Data;
using Lafite.RoleModel.Security;
using DMS.Business.Contract;
using DMS.Model.EKPWorkflow;
using DMS.Business.EKPWorkflow;
using DMS.Common.Common;
using System.IO;
using DMS.Model.TenderAuthorizationList;
using DMS.Common.Office;
using System.Text;
using ThoughtWorks.QRCode.Codec;

namespace DMS.Website.Pages.Contract
{
    public partial class TenderAuthorizationList : BasePage
    {
        public EkpWorkflowBLL ekpBLL = new EkpWorkflowBLL();
        IRoleModelContext _context = RoleModelContext.Current;
        private ITenderAuthorizationList _businessReport = new TenderAuthorizationListBLL();
        TenderAuthorizationListBLL Bll = new TenderAuthorizationListBLL();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                this.hidUserCode.Value = _context.UserName;
                this.Bind_OrderStatusForTier2(this.StatesStore, SR.CONST_TenderType);
                this.Bind_Authorization(this.AuthorizationStore, SR.Provisional_Authorization); 
                if (IsDealer )
                {
                    if (_context.User.CorpId.ToString() != "688162F4-46A2-492F-87C0-0216D9A69C42")
                    {
                        this.btninsert.Hide();
                    }
                }
            }
        }
        protected internal virtual void Bind_OrderStatusForTier2(Store store, string type)
        {
            IDictionary<string, string> dicts = DictionaryHelper.GetDictionary(type);
            store.DataSource = dicts;
            store.DataBind();
        }
        protected internal virtual void Bind_Authorization(Store stores, string type)
        {
            IDictionary<string, string> dicts = DictionaryHelper.GetDictionary(type);
            stores.DataSource = dicts;
            stores.DataBind();
        }

        protected void ResultStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            Hashtable param = ReturnHashtable();
            DataTable dt = _businessReport.GetTenderAuthorizationList(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount).Tables[0];
            e.TotalCount = totalCount;
            this.ResultStore.DataSource = dt;
            this.ResultStore.DataBind();

        }


        protected void HospitalStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            DataTable dt = _businessReport.ExportHospital(this.HiddenID.Value.ToString(), (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount).Tables[0];
            e.TotalCount = totalCount;
            this.HospitalStore.DataSource = dt;
            this.HospitalStore.DataBind();

        }

        //授权类型
        protected internal virtual void Bind_ExpAuthorizationStore(Store stores, string type)
        {
            IDictionary<string, string> dicts = DictionaryHelper.GetDictionary(type);
            stores.DataSource = dicts;
            stores.DataBind();
        }

        [AjaxMethod]
        public string CheckApply(string mainId)
        {
            string massage = "";
            FormInstanceMaster om = ekpBLL.GetFormInstanceMasterByApplyId(Request.QueryString["FormId"]);
            List<EkpOperParam> operationList = ekpBLL.GetEkpParamList(_context.User.LoginId, Request.QueryString["FormId"]);
            if ((om == null || om.CreateUser.Trim().ToUpper() != _context.User.LoginId.Trim().ToUpper()) && (operationList == null || operationList.Count() == 0))
            {
                massage = "您无权限查看当前单据";
            }
            return massage;
        }

        protected void ExportToExcel(object sender, EventArgs e)
        {
            Hashtable param = ReturnHashtable();
            DataTable dt = _businessReport.ExcelTenderAuthorization(param).Tables[0];
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

        private Hashtable ReturnHashtable()
        {
            Hashtable param = new Hashtable();
            if (!string.IsNullOrEmpty(this.AuthorizationNo.Text))
            {
                param.Add("AuthorizationNo", this.AuthorizationNo.Text);
            }
            if (!this.StartBeginsDate.IsNull)
            {
                param.Add("StartBeginsDate", this.StartBeginsDate.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!this.StopBeginsDate.IsNull)
            {
                param.Add("StopBeginsDate", this.StopBeginsDate.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!this.StartEndDate.IsNull)
            {
                param.Add("StartEndDate", this.StartEndDate.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!this.StopEndDate.IsNull)
            {
                param.Add("StopEndDate", this.StopEndDate.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!this.BeginApprovedDate.IsNull)
            {
                param.Add("BeginApprovedDate", this.BeginApprovedDate.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!this.EndApprovedDate.IsNull)
            {
                param.Add("EndApprovedDate", this.EndApprovedDate.SelectedDate.ToString("yyyyMMdd"));
            }

            if (!string.IsNullOrEmpty(this.dealer.Text))
            {
                param.Add("dealer", this.dealer.Text);
            }
            if (!string.IsNullOrEmpty(this.cbStatesType.SelectedItem.Value))
            {
                param.Add("cbStatesType", this.cbStatesType.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.Authorization.SelectedItem.Value))
            {
                param.Add("Authorization", this.Authorization.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.Hospital.Text))
            {
                param.Add("Hospital", this.Hospital.Text);
            }
            if (IsDealer)
            {
                param.Add("PmaDealerId", this._context.User.CorpId);
            }

            param.Add("OwnerIdentityType", this._context.User.IdentityType);
            if (RoleModelContext.Current.User.Roles.Contains(SR.Const_UserRole_TenderAdmin.ToString()) || RoleModelContext.Current.User.Roles.Contains(SR.Const_UserRole_Admin.ToString()))
            {
                param.Add("UserType", "TenderAdmin");
                param.Add("OwnerId", new Guid(this._context.User.Id));
            }
            else
            {
                param.Add("UserType", "TenderUser");
                param.Add("OwnerId", new Guid(this._context.User.Id));
            }
            return param;
        }
        //合同类型
        [AjaxMethod]
        public void ExportWindowShow(string DTM_ID)
        {
            this.DTM_NO.Text = "";
            this.cbFileType.SelectedItem.Value = "";
            this.ExpHospital.Value = "";
            this.ApplicType.Clear();
            DataTable dt = Bll.ExpApplicType(DTM_ID).Tables[0];
            this.ApplicType.Text = dt.Rows[0]["DTM_ApplicType"].ToString();
            this.DTM_NO.Value = dt.Rows[0]["DTM_NO"].ToString();
            string DealerType = dt.Rows[0]["DTM_DealerType"].ToString();

            if (DealerType == "T2")
            {
                if (IsDealer)
                {   //有二级并且为平台只有lp
                    this.Bind_ExpAuthorizationStore(this.ExpAuthorizationStore, SR.Tender_AuthorizationLP);
                }
                else
                {    //有二级都lp/bsc可以选
                    this.Bind_ExpAuthorizationStore(this.ExpAuthorizationStore, SR.Tender_Authorization);
                }
            }
            else
            {   //无二级只有bsc
                this.Bind_ExpAuthorizationStore(this.ExpAuthorizationStore, SR.Tender_AuthorizationBSC);
            }
            this.ExportWindow.Show();
        }
        [AjaxMethod] //导出WORD
        public string BtnDownloadPDF()
        {
            TenderAuthorizationListVO model = new TenderAuthorizationListVO();
            string pdfname = "";
            try
            {
                string ApplicType = this.ApplicType.Text;
                string cbFileType = this.cbFileType.SelectedItem.Value;
                string ExpHospital = this.ExpHospital.Value.ToString();
                string Newpath = string.Empty;
                string TempFile = "TenderAuthorization";
                string fullpath = BuildPath();
                Newpath = Path.Combine(fullpath, TempFile);
                if (!Directory.Exists(Newpath))
                {
                    Directory.CreateDirectory(Newpath);
                }
                string newfileName = Guid.NewGuid().ToString() + ".docx";
                string filepath = "";
                if (ApplicType == "临时授权" && cbFileType == "Tender_AuthorizationBSC")
                {
                    filepath = "~/Upload/TenderAuthorizationListDownLoad/临时授权书-BSC.docx";
                }
                else if (ApplicType == "临时授权" && cbFileType == "Tender_AuthorizationLP")
                {
                    filepath = "~/Upload/TenderAuthorizationListDownLoad/授权书LP-临时模板.docx";
                }
                else if (ApplicType == "招投标授权" && cbFileType == "Tender_AuthorizationBSC")
                {
                    filepath = "~/Upload/TenderAuthorizationListDownLoad/招标授权书 -BSC招标模板.docx";
                }
                else if (ApplicType == "招投标授权" && cbFileType == "Tender_AuthorizationLP")
                {
                    filepath = "~/Upload/TenderAuthorizationListDownLoad/授权书LP-招标模板（耗材招标）.docx";
                }
                var sourcePath = HttpContext.Current.Server.MapPath(filepath);
                var desPath = Path.GetFullPath(Path.Combine(Newpath, newfileName));
                File.Delete(desPath);
                File.Copy(sourcePath, desPath);
                //根据书签,替换内容
                List<Bookmark> listMark = ListBookMark(cbFileType, ExpHospital, this.DTM_NO.Value.ToString());
                BookMark(model, desPath, listMark);
                string path = Request.PhysicalApplicationPath;
                string str = desPath.Replace(path, "~\\");
                string pdf0path = desPath.Replace("docx", "pdf");
                using (WordApp wordapp = new WordApp(desPath))
                {
                    wordapp.SavePdf(pdf0path);
                }
                pdfname = Path.GetFileName(pdf0path);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return pdfname;
        }

        public string BuildPath()
        {
            string path = "~/Upload/";
            if (!Path.IsPathRooted(path))
            {
                path = HttpContext.Current.Server.MapPath(path);
            }
            string s = Path.GetFullPath(path);
            return s;
        }
        public TenderAuthorizationListVO BookMark(TenderAuthorizationListVO model, string desPath, List<Bookmark> list)
        {
            try
            {
                using (WordProcessing word = new WordProcessing(desPath))
                {
                    word.ReplaceBookmarks(list);
                    word.Save();
                }
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }
        //替换书签
        public List<Bookmark> ListBookMark(string cbFileType, string ExpHospital, string TempFile)
        {
            List<Bookmark> list = new List<Bookmark>();
            DataTable dt = Bll.SelectTenderWork(TempFile).Tables[0];
            string Id = dt.Rows[0]["DTM_ID"].ToString();
            string qrcodeUrl = NewQrCode(TempFile);
            var Begindata = Convert.ToDateTime(dt.Rows[0]["DTM_BeginDate"].ToString());
            string beginYear = Begindata.Year.ToString();
            string beginMonth = Begindata.Month.ToString();
            string beginDay = Begindata.Day.ToString();
            var Enddata = Convert.ToDateTime(dt.Rows[0]["DTM_EndDate"].ToString());
            string endYear = Enddata.Year.ToString();
            string endMonth = Enddata.Month.ToString();
            string endDay = Enddata.Day.ToString();
            var Createdata = Convert.ToDateTime(dt.Rows[0]["DTM_CreateDate"].ToString());
            string creatYear = Createdata.Year.ToString();
            string creatMonth = Createdata.Month.ToString();
            string creatDay = Createdata.Day.ToString();
            Hashtable DtmId = new Hashtable();
            DtmId.Add("DTM_ID", dt.Rows[0]["DTM_ID"].ToString());
            DataTable table = Bll.ExportHospitalProductWork(DtmId).Tables[0];
            list.Add(new Bookmark { BookmarkName = "DTM_NO", BookmarkType = BookmarkType.Text, BookmarkValue = dt.Rows[0]["DTM_NO"].ToString() });
            list.Add(new Bookmark { BookmarkName = "beginYear", BookmarkType = BookmarkType.Text, BookmarkValue = beginYear });
            list.Add(new Bookmark { BookmarkName = "beginMonth", BookmarkType = BookmarkType.Text, BookmarkValue = beginMonth });
            list.Add(new Bookmark { BookmarkName = "beginDay", BookmarkType = BookmarkType.Text, BookmarkValue = beginDay });
            list.Add(new Bookmark { BookmarkName = "endYear", BookmarkType = BookmarkType.Text, BookmarkValue = endYear });
            list.Add(new Bookmark { BookmarkName = "endMonth", BookmarkType = BookmarkType.Text, BookmarkValue = endMonth });
            list.Add(new Bookmark { BookmarkName = "endDay", BookmarkType = BookmarkType.Text, BookmarkValue = endDay });
            list.Add(new Bookmark { BookmarkName = "createYear", BookmarkType = BookmarkType.Text, BookmarkValue = creatYear });
            list.Add(new Bookmark { BookmarkName = "createMonth", BookmarkType = BookmarkType.Text, BookmarkValue = creatMonth });
            list.Add(new Bookmark { BookmarkName = "createDay", BookmarkType = BookmarkType.Text, BookmarkValue = creatDay });
            list.Add(new Bookmark { BookmarkName = "Hospital", BookmarkType = BookmarkType.Html, BookmarkValue = ExportDatatableToHtml(table) });
            list.Add(new Bookmark { BookmarkName = "DTM_DealerName", BookmarkType = BookmarkType.Text, BookmarkValue = dt.Rows[0]["DTM_DealerName"].ToString() });
            list.Add(new Bookmark { BookmarkName = "DTM_DealerName2", BookmarkType = BookmarkType.Text, BookmarkValue = dt.Rows[0]["DTM_DealerName"].ToString() });
            list.Add(new Bookmark { BookmarkName = "DTM_SupDealer", BookmarkType = BookmarkType.Text, BookmarkValue = dt.Rows[0]["DTM_SupDealer"].ToString() });
            list.Add(new Bookmark { BookmarkName = "QRCode", BookmarkType = BookmarkType.Image, BookmarkValue = qrcodeUrl });
            return list;
        }
      
        protected string ExportDatatableToHtml(DataTable table)
        {
            StringBuilder strHTMLBuilder = new StringBuilder();
            strHTMLBuilder.Append("< !DOCTYPE html><html><head></head><body style='font-size:18px'>");
            if (table.Rows.Count > 0)
            {
                for (int i = 0; i < table.Rows.Count; i++)
                {
                    strHTMLBuilder.Append(table.Rows[i]["HOS_HospitalName"].ToString());
                    strHTMLBuilder.Append("(");
                    strHTMLBuilder.Append(table.Rows[i]["ProductString"].ToString());
                    strHTMLBuilder.Append(")");
                    strHTMLBuilder.Append("<br/>");
                }
            }
            strHTMLBuilder.Append("</body></html>");
            string Htmltext = strHTMLBuilder.ToString();
            return Htmltext;
        }

        //生成二维码
        public string NewQrCode(string ContractNo)
        {
            QRCodeEncoder qrCodeEncoder = new QRCodeEncoder();
            qrCodeEncoder.QRCodeEncodeMode = QRCodeEncoder.ENCODE_MODE.BYTE;
            qrCodeEncoder.QRCodeScale = 3;
            qrCodeEncoder.QRCodeVersion = 0;
            qrCodeEncoder.QRCodeErrorCorrect = QRCodeEncoder.ERROR_CORRECTION.L;
            System.Drawing.Image image = qrCodeEncoder.Encode(ContractNo);
            //string filepath = System.Web.HttpContext.Current.Server.MapPath("QrCode\\" + Guid.NewGuid().ToString() + ".png");
            string filepath = AppDomain.CurrentDomain.BaseDirectory.ToString() + "QrCode\\" + Guid.NewGuid().ToString() + ".png";
            System.IO.FileStream fs = new System.IO.FileStream(filepath, System.IO.FileMode.OpenOrCreate, System.IO.FileAccess.Write);
            image.Save(fs, System.Drawing.Imaging.ImageFormat.Jpeg);
            string filepath1 = AppDomain.CurrentDomain.BaseDirectory.ToString() + "QrCode\\" + Guid.NewGuid().ToString() + ".png";
            fs.Close();
            image.Dispose();
            return filepath;
        }
    }
}