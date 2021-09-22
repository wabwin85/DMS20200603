using System;
using DMS.Common.Common;
using DMS.Common;
using System.Data;
using Newtonsoft.Json;
using DMS.BusinessService.Util.DealerFilter;
using DMS.BusinessService.Util.DealerFilter.Impl;
using System.Collections;
using DMS.Business;
using System.Linq;
using Lafite.RoleModel.Security;
using System.Collections.Specialized;
using DMS.Common.Extention;
using DMS.Business.Excel;
using DMS.ViewModel.Contract;
using DMS.Business.Contract;
using DMS.Business.EKPWorkflow;
using System.IO;
using System.Web;
using DMS.Common.Office;
using System.Collections.Generic;
using ThoughtWorks.QRCode.Codec;
using System.Text;

namespace DMS.BusinessService.Contract
{
    public class TenderAuthorizationService : ABaseQueryService, IQueryExport
    {
        #region Ajax Method
        public TenderAuthorizationVO Init(TenderAuthorizationVO model)
        {
            try
            {
                model.ListAuthorizationType = new ArrayList(DictionaryHelper.GetDictionary(SR.Provisional_Authorization).ToList());
                model.ListApproveStatus = new ArrayList(DictionaryHelper.GetDictionary(SR.CONST_TenderType).ToList());
                
                model.IsSuccess = true;
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }
        public TenderAuthorizationVO GetEkpHistoryPageUrl(TenderAuthorizationVO model)
        {
            try
            {
                EkpWorkflowBLL ekpBll = new EkpWorkflowBLL();
                string url = ekpBll.GetEkpCommonPageUrlByInstanceId(model.DTMID, RoleModelContext.Current.User.LoginId);
                model.ApprovalUrl = new System.Web.UI.Control().ResolveUrl(url);
                model.IsSuccess = true;
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }
        public TenderAuthorizationVO GetExpAuthorization(TenderAuthorizationVO model)
        {
            try
            {
                TenderAuthorizationListBLL ta = new TenderAuthorizationListBLL();
                DataTable dt = ta.ExpApplicType(model.DTMID).Tables[0];
                if (dt.Rows.Count > 0)
                {
                    model.ApplicType = dt.Rows[0]["DTM_ApplicType"].ToString();
                    model.DTMNO = dt.Rows[0]["DTM_NO"].ToString();
                    model.DealerType = dt.Rows[0]["DTM_DealerType"].ToString();
                    if (model.DealerType == "T2")
                    {
                        if (IsDealer)
                        {   //有二级并且为平台只有lp
                            model.ListAuthorizationTypeExt = new ArrayList(DictionaryHelper.GetDictionary(SR.Tender_AuthorizationLP).ToList());
                        }
                        else
                        {    //有二级都lp/bsc可以选
                            model.ListAuthorizationTypeExt = new ArrayList(DictionaryHelper.GetDictionary(SR.Tender_Authorization).ToList());
                        }
                    }
                    else
                    {   //无二级只有bsc
                        model.ListAuthorizationTypeExt = new ArrayList(DictionaryHelper.GetDictionary(SR.Tender_AuthorizationBSC).ToList());
                    }
                }
                model.IsSuccess = true;
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public TenderAuthorizationVO GetDownloadPDFPath(TenderAuthorizationVO model)
        {
            try
            {
                TenderAuthorizationListBLL ta = new TenderAuthorizationListBLL();
                DataTable dt = ta.ExpApplicType(model.DTMID).Tables[0];
                if (dt.Rows.Count > 0)
                {
                    model.ApplicType = dt.Rows[0]["DTM_ApplicType"].ToString();
                    model.DTMNO = dt.Rows[0]["DTM_NO"].ToString();
                    model.DealerType = dt.Rows[0]["DTM_DealerType"].ToString();
                }
                string ApplicType = model.ApplicType;
                string cbFileType = model.IptAuthorizationTypeExt.Key;
                string ExpHospital = "";
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
                List<Bookmark> listMark = ListBookMark(cbFileType, ExpHospital, model.DTMNO);
                BookMark(model, desPath, listMark);
                string path = Request.PhysicalApplicationPath;
                string str = desPath.Replace(path, "~\\");
                string pdf0path = desPath.Replace("docx", "pdf");
                using (WordApp wordapp = new WordApp(desPath))
                {
                    wordapp.SavePdf(pdf0path);
                }
                model.PdfName = Path.GetFileName(pdf0path);
                model.IsSuccess = true;
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }
        public string Query(TenderAuthorizationVO model)
        {
            try
            {
                ITenderAuthorizationList business = new TenderAuthorizationListBLL();
                Hashtable param = GetQueryConditions(model);

                param.Add("SubCompanyId", BaseService.CurrentSubCompany?.Key);
                param.Add("BrandId", BaseService.CurrentBrand?.Key);
                int outCont = 0;
                int start = (model.Page - 1) * model.PageSize;
                DataSet ds = business.GetTenderAuthorizationList(param, start, model.PageSize, out outCont);
                model.RstResultList = JsonHelper.DataTableToArrayList(ds.Tables[0]);

                model.DataCount = outCont;
                model.IsSuccess = true;

            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            var data = new { data = model.RstResultList, total = model.DataCount };
            var result = new { success = model.IsSuccess, data = data };
            return JsonConvert.SerializeObject(result);
        }

        public void Export(NameValueCollection Parameters, string DownloadCookie)
        {
            ITenderAuthorizationList business = new TenderAuthorizationListBLL();
            Hashtable param = new Hashtable();

            if (!string.IsNullOrEmpty(Parameters["AuthorizationNo"].ToSafeString()))
            {
                param.Add("AuthorizationNo", Parameters["AuthorizationNo"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["StartBeginsDate"].ToSafeString()))
            {
                param.Add("StartBeginsDate", Parameters["StartBeginsDate"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["StopBeginsDate"].ToSafeString()))
            {
                param.Add("StopBeginsDate", Parameters["StopBeginsDate"].ToSafeString());
            }

            if (!string.IsNullOrEmpty(Parameters["StartEndDate"].ToSafeString()))
            {
                param.Add("StartEndDate", Parameters["StartEndDate"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["StopEndDate"].ToSafeString()))
            {
                param.Add("StopEndDate", Parameters["StopEndDate"].ToSafeString());
            }

            if (!string.IsNullOrEmpty(Parameters["BeginApprovedDate"].ToSafeString()))
            {
                param.Add("BeginApprovedDate", Parameters["BeginApprovedDate"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["EndApprovedDate"].ToSafeString()))
            {
                param.Add("EndApprovedDate", Parameters["EndApprovedDate"].ToSafeString());
            }


            if (!string.IsNullOrEmpty(Parameters["Dealer"].ToSafeString()))
            {
                param.Add("Dealer", Parameters["Dealer"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["cbStatesType"].ToSafeString()))
            {
                param.Add("cbStatesType", Parameters["cbStatesType"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["Authorization"].ToSafeString()))
            {
                param.Add("Authorization", Parameters["Authorization"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["Hospital"].ToSafeString()))
            {
                param.Add("Hospital", Parameters["Hospital"].ToSafeString());
            }
            if (IsDealer)
            {
                param.Add("PmaDealerId", RoleModelContext.Current.User.CorpId);
            }

            param.Add("OwnerIdentityType", RoleModelContext.Current.User.IdentityType);
            if (RoleModelContext.Current.User.Roles.Contains(SR.Const_UserRole_TenderAdmin.ToString()) || RoleModelContext.Current.User.Roles.Contains(SR.Const_UserRole_Admin.ToString()))
            {
                param.Add("UserType", "TenderAdmin");
                param.Add("OwnerId", new Guid(RoleModelContext.Current.User.Id));
            }
            else
            {
                param.Add("UserType", "TenderUser");
                param.Add("OwnerId", new Guid(RoleModelContext.Current.User.Id));
            }
            param.Add("SubCompanyId", BaseService.CurrentSubCompany?.Key);
            param.Add("BrandId", BaseService.CurrentBrand?.Key);
            DataSet ds= business.ExcelTenderAuthorization(param);
            
            if (ds != null)
            {
                DataTable dt = ds.Tables[0];
                DataSet[] result = new DataSet[1];
                result[0] = new DataSet();
                result[0].Tables.Add(dt.Copy());

                Hashtable ht = new Hashtable();
                XlsExport xlsExport = new XlsExport("TenderAuthorization");
                xlsExport.Export(ht, result, DownloadCookie);
            }

        }
        private Hashtable GetQueryConditions(TenderAuthorizationVO model)
        {
            Hashtable param = new Hashtable();
            if (!string.IsNullOrEmpty(model.QryAuthorizationNo))
            {
                param.Add("AuthorizationNo", model.QryAuthorizationNo);
            }
            if (model.QryAuthorizationStart!=null)
            {
                if (!string.IsNullOrEmpty(model.QryAuthorizationStart.StartDate))
                {
                    param.Add("StartBeginsDate", model.QryAuthorizationStart.StartDate);
                }
                if (!string.IsNullOrEmpty(model.QryAuthorizationStart.EndDate))
                {
                    param.Add("StopBeginsDate", model.QryAuthorizationStart.EndDate);
                }
            }
            
            if (model.QryAuthorizationEnd!=null)
            {
                if (!string.IsNullOrEmpty(model.QryAuthorizationEnd.StartDate))
                {
                    param.Add("StartEndDate", model.QryAuthorizationEnd.StartDate);
                }
                if (!string.IsNullOrEmpty(model.QryAuthorizationEnd.EndDate))
                {
                    param.Add("StopEndDate", model.QryAuthorizationEnd.EndDate);
                }
            }
            if (model.QryApproveDate != null)
            {
                if (!string.IsNullOrEmpty(model.QryApproveDate.StartDate))
                {
                    param.Add("BeginApprovedDate", model.QryApproveDate.StartDate);
                }
                if (!string.IsNullOrEmpty(model.QryApproveDate.EndDate))
                {
                    param.Add("EndApprovedDate", model.QryApproveDate.EndDate);
                }
            }
            

            if (!string.IsNullOrEmpty(model.QryDealer))
            {
                param.Add("dealer", model.QryDealer);
            }
            if (model.QryApproveStatus!=null&& !string.IsNullOrEmpty(model.QryApproveStatus.Key))
            {
                param.Add("cbStatesType", model.QryApproveStatus.Key);
            }
            if (model.QryAuthorizationType!=null && !string.IsNullOrEmpty(model.QryAuthorizationType.Key))
            {
                param.Add("Authorization", model.QryAuthorizationType.Key);
            }
            if (!string.IsNullOrEmpty(model.QryHospital))
            {
                param.Add("Hospital", model.QryHospital);
            }
            if (IsDealer)
            {
                param.Add("PmaDealerId", RoleModelContext.Current.User.CorpId);
            }

            param.Add("OwnerIdentityType", RoleModelContext.Current.User.IdentityType);
            if (RoleModelContext.Current.User.Roles.Contains(SR.Const_UserRole_TenderAdmin.ToString()) || RoleModelContext.Current.User.Roles.Contains(SR.Const_UserRole_Admin.ToString()))
            {
                param.Add("UserType", "TenderAdmin");
                param.Add("OwnerId", new Guid(RoleModelContext.Current.User.Id));
            }
            else
            {
                param.Add("UserType", "TenderUser");
                param.Add("OwnerId", new Guid(RoleModelContext.Current.User.Id));
            }
            return param;
        }
        private string BuildPath()
        {
            string path = "~/Upload/";
            if (!Path.IsPathRooted(path))
            {
                path = HttpContext.Current.Server.MapPath(path);
            }
            string s = Path.GetFullPath(path);
            return s;
        }
        private List<Bookmark> ListBookMark(string cbFileType, string ExpHospital, string TempFile)
        {
            TenderAuthorizationListBLL Bll = new TenderAuthorizationListBLL();
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
        private string ExportDatatableToHtml(DataTable table)
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
        private string NewQrCode(string ContractNo)
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
        private TenderAuthorizationVO BookMark(TenderAuthorizationVO model, string desPath, List<Bookmark> list)
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
        #endregion
    }


}
