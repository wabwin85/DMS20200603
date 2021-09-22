using DMS.Common.Common;
using DMS.DataAccess.ContractElectronic;
using DMS.Model.ViewModel.ContractElectronic;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using ThoughtWorks.QRCode.Codec;
using DocumentFormat.OpenXml.Wordprocessing;
using DMS.Common.Office;
using Newtonsoft.Json;
using DMS.Common;
using System.Reflection;

using iTextSharp.text;
using iTextSharp.text.pdf;
using System.Web;
using System.Text.RegularExpressions;
using Grapecity.DataAccess.Transaction;
using System.Globalization;
using Lafite.RoleModel.Security;
using DMS.DataAccess;
using DMS.Model;
using DMS.Model.Data;
using DMS.Signature.Model;
using DMS.Signature.BLL;
using iTextSharp.awt.geom;

namespace DMS.Business.ContractElectronic
{
    public class ContractService : BaseService
    {
        public IRoleModelContext _context = RoleModelContext.Current;
        private IDealerMasters dealerMasters = new DealerMasters();
        public ContractDetailView InsertExportCache(ContractDetailView model)
        {
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    using (LPandT1Dao dao = new LPandT1Dao())
                    {
                        var delExportId = dao.SelectDeleteContract(model).Tables[0];
                        if (delExportId.Rows.Count != 0 && !string.IsNullOrEmpty(delExportId.Rows[0]["ExportId"].ToString()))
                        {
                            string ExportId = delExportId.Rows[0]["ExportId"].ToString();
                            //1.0先去删除同一个合同的草稿
                            dao.deleteContract(model);
                            //1.0.1 删除合同模板的草稿
                            dao.DeleteDraftSelectExportTemp(ExportId);

                            //删除版本
                            dao.DeleteExportVersionByExporId(ExportId);
                        }

                        var exportId = Guid.NewGuid();
                        model.ExportId = exportId;

                        model.Status = "draft";
                        model.CreateUser = UserInfo.Id;
                        model.CreateDate = DateTime.Now;

                        //2.0插入草稿数据
                        dao.InsertContract(model);

                        //3.插入版本
                        Hashtable ht = new Hashtable();
                        //版本号
                        ht.Add("VersionNo", "");
                        ht.Add("ContractId", model.ContractId);
                        ht.Add("ExportId", exportId);
                        ht.Add("CreateUser", UserInfo.Id);
                        ht.Add("CreateDate", DateTime.Now);
                        ht.Add("VersionStatus", DMS.Common.ContractESignStatus.Draft.ToString());
                        dao.InsertVersion(ht);
                        List<SelectedTemplate> tmplist = new List<SelectedTemplate>();
                        //3.0批量插入选择过的模板数据
                        if (model.ContractTemplateList.Count != 0)
                        {

                            foreach (var i in model.ContractTemplateList)
                            {
                                if (i.FileType == "OtherAttachment")
                                {
                                    i.FilePath = null;
                                    //遍历用户上传的附件，匹配TemplateId替换路径
                                    foreach (var item in model.ContractTemplatePdfList)
                                    {
                                        if (item.FileType == i.FileType)
                                        {
                                            i.FilePath = item.FilePath;
                                            i.TmpName = item.TmpName;

                                        }
                                    }


                                }
                                if (i.FilePath != null)
                                {
                                    tmplist.Add(i);
                                }
                            }

                            dao.BatchInsertSelectedTmp(tmplist, exportId);
                        }

                        model.IsSuccess = true;
                        trans.Complete();
                    }
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
        public ContractDetailView InsertExportSubmit(ContractDetailView model)
        {
            Guid exportId = Guid.NewGuid();
            try
            {
                if (model.DealerType == "T2" && model.ContractType == "Amendment")
                {
                    using (QueryDao dao = new QueryDao())
                    {
                        DataTable tb = dao.GetContract(model.DealerId, CurrentSubCompany?.Key, CurrentBrand?.Key);

                        if (tb.Rows.Count == 0)
                        {
                            model.IsSuccess = false;
                            model.ExecuteMessage.Add("主合同未生成");
                            return model;
                        }
                    }


                }
                using (TransactionScope trans = new TransactionScope())
                {
                    using (LPandT1Dao dao = new LPandT1Dao())
                    {
                        var delExportId = dao.SelectDeleteContract(model).Tables[0];
                        if (delExportId.Rows.Count != 0 && !string.IsNullOrEmpty(delExportId.Rows[0]["ExportId"].ToString()))
                        {
                            string ExportId = delExportId.Rows[0]["ExportId"].ToString();
                            //1.0先去删除同一个合同的草稿
                            dao.deleteContract(model);
                            //1.0.1 删除合同模板的草稿
                            dao.DeleteDraftSelectExportTemp(ExportId);

                            //删除版本
                            dao.DeleteExportVersionByExporId(ExportId);
                        }

                        model.ExportId = exportId;

                        model.Status = "submit";
                        model.CreateUser = UserInfo.Id;
                        model.CreateDate = DateTime.Now;

                        //1.插入主表数据
                        dao.InsertContract(model);
                        List<SelectedTemplate> tmplist = new List<SelectedTemplate>();
                        //2.批量插入选择过的模板数据
                        if (model.ContractTemplateList.Count != 0)
                        {
                            foreach (var i in model.ContractTemplateList)
                            {
                                //法人委托书
                                if (i.FileType == "OtherAttachment")
                                {
                                    i.FilePath = null;
                                    //遍历用户上传的附件，匹配TemplateId替换路径
                                    foreach (var item in model.ContractTemplatePdfList)
                                    {
                                        if (item.FileType == i.FileType)
                                        {
                                            i.FilePath = item.FilePath;
                                            i.TmpName = item.TmpName;

                                        }
                                    }
                                }
                                if (i.FilePath != null)
                                {
                                    tmplist.Add(i);
                                }
                            }
                            dao.BatchInsertSelectedTmp(tmplist, exportId);
                        }
                        //3.插入版本
                        Hashtable ht = new Hashtable();
                        //版本号
                        ht.Add("VersionNo", "V-" + DateTime.Now.ToString("yyyyMMdd-HHmmss"));
                        ht.Add("ContractId", model.ContractId);
                        ht.Add("ExportId", exportId);
                        ht.Add("CreateUser", UserInfo.Id);
                        ht.Add("CreateDate", DateTime.Now);
                        //2019-7-30 T2终止合同提交后直接平台签章。
                        if (model.DealerType == "T2" && model.ContractType == "Termination")
                        {
                            ht.Add("VersionStatus", DMS.Common.ContractESignStatus.WaitLPSign.ToString());
                        }
                        else
                        {
                            ht.Add("VersionStatus", DMS.Common.ContractESignStatus.WaitDealerSign.ToString());
                        }

                        dao.InsertVersion(ht);

                        model.IsSuccess = true;
                        trans.Complete();


                    }

                }
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            //生成电子合同
            model.IsPreview = "PDFExport";
            model.SelectExportId = exportId.ToString();
            this.BuildPath(model);
            model = this.ExportPDFLP(model);
            return model;
        }
        public ContractDetailView BuildPath(ContractDetailView model)
        {
            string path = "~/Upload/ContractElectronicAttachmentTemplate/";

            if (!Path.IsPathRooted(path))
            {
                path = HttpContext.Current.Server.MapPath(path);
            }
            string s = Path.GetFullPath(path);

            model.FullPath = s;

            return model;
        }
        public ContractDetailView GiveUpCache(ContractDetailView model)
        {
            try
            {
                using (LPandT1Dao dao = new LPandT1Dao())
                {
                    var delExportId = dao.SelectDeleteContract(model).Tables[0];
                    if (delExportId.Rows.Count != 0 && !string.IsNullOrEmpty(delExportId.Rows[0][0].ToString()))
                    {
                        //1.0先去删除同一个合同的草稿
                        dao.deleteContract(model);
                        //1.0.1 删除合同模板的草稿
                        dao.DeleteDraftSelectExportTemp(delExportId.Rows[0][0].ToString());
                    }
                    model.IsSuccess = true;
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

        public ContractDetailView ExportPDFLP(ContractDetailView model)
        {

            try
            {
                //if (model.)
                //{

                //}
                if (model.DealerType == "T2" && model.ContractType == "Amendment")
                {
                    using (QueryDao dao = new QueryDao())
                    {
                        DataTable tb = dao.GetContract(model.DealerId, CurrentSubCompany?.Key, CurrentBrand?.Key);

                        if (tb.Rows.Count == 0)
                        {
                            model.IsSuccess = false;
                            model.ExecuteMessage.Add("主合同未生成");
                            return model;
                        }
                    }


                }


                if (model.IsPreview == "Preview")
                {

                    if (model.ContractTemplatePdfList.Count > 0)
                    {
                        foreach (UserPdfTemplate item in model.ContractTemplatePdfList)
                        {

                            if (model.ContractTemplateList.Find(p => p.FileType == item.FileType).FileType == item.FileType)
                            {

                                model.ContractTemplateList.Find(p => p.FileType == item.FileType).TmpName = item.TmpName;
                                model.ContractTemplateList.Find(p => p.FileType == item.FileType).TmpID = item.TmpID;
                                model.ContractTemplateList.Find(p => p.FileType == item.FileType).FilePath = item.FilePath;
                            }
                            else
                            {
                                SelectedTemplate Template = new SelectedTemplate();
                                Template.FilePath = item.FilePath;
                                Template.TmpName = item.TmpName;
                                Template.TmpID = item.TmpID;
                                model.ContractTemplateList.Add(Template);
                            }

                        }

                    }
                    model = CopySelectFile(model);
                }
                else if (model.IsPreview == "PDFExport")
                {
                    Hashtable ht = new Hashtable();
                    ht.Add("ExportId", model.SelectExportId);
                    List<ContractDetailView> arrlist = new List<ContractDetailView>();
                    DataTable ds = new DataTable();
                    ContractDetailView view = new ContractDetailView();
                    using (QueryDao dao = new QueryDao())
                    {
                        if (model.DealerType == "T2")
                        {
                            view = dao.SelectContractT2MainByExportId(ht).ToList()[0];
                        }
                        else
                        {
                            view = dao.SelectContractMainByExportId(ht).ToList()[0];
                        }
                        view.IsPreview = "PDFExport";
                        Hashtable obj = new Hashtable();
                        obj.Add("ContractType", view.ContractType);
                        obj.Add("DealerType", view.DealerType);
                        obj.Add("ExportId", view.ExportId);
                        obj.Add("ProductlineId", view.DeptId);
                        obj.Add("ContractId", view.ContractId);
                        LPandT1Dao LPdao = new LPandT1Dao();
                        DataSet Fileds = LPdao.SelectExportSelectedTemplateByFileType(model.ExportId.ToString(), "Finaldraft");
                        view.ContractTemplateList = dao.SelectExportTemplateToList(obj).ToList();
                        // SelectedTemplate Template = view.ContractTemplateList.Find(p => p.FileType == "Finaldraft");
                        //如果已经有导出的合同
                        if (Fileds.Tables[0].Rows.Count > 0)
                        {
                            model.FilePath = Fileds.Tables[0].Rows[0]["UploadFilePath"].ToString();
                            model.IsSuccess = true;
                        }
                        else
                        {
                            view.FullPath = model.FullPath;
                            view.ContractTemplateList.RemoveAll(c => c.FilePath == null);
                            model = CopySelectFile(view);
                            if (File.Exists(HttpContext.Current.Server.MapPath(model.FilePath)))
                            {
                                List<SelectedTemplate> ListNewFile = new List<SelectedTemplate>();
                                SelectedTemplate NewTemplate = new SelectedTemplate();
                                NewTemplate.FilePath = model.FilePath;
                                NewTemplate.FileType = "Finaldraft";
                                NewTemplate.TmpName = model.ContractNo + ".pdf";
                                NewTemplate.TmpID = Guid.NewGuid().ToString();
                                ListNewFile.Add(NewTemplate);
                                LPdao.BatchInsertSelectedTmp(ListNewFile, model.ExportId);
                            }
                            else
                            {
                                model.IsSuccess = false;
                                model.ExecuteMessage.Add("文件生成失败");
                            }



                            //保存最终稿信息

                        }

                    }




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
        private static string BuildPath(string path)
        {
            if (!Path.IsPathRooted(path))
            {
                path = HttpContext.Current.Server.MapPath(path);
            }

            if (!Directory.Exists(path))
            {
                Directory.CreateDirectory(path);
            }
            return Path.GetFullPath(path);
        }
        private ContractDetailView CopySelectFile(ContractDetailView model)
        {
            string NewFilePath = string.Empty;
            string Newpath = string.Empty;
            string TempFile = ContractTemplate.ExpPDfPath + model.IsPreview + "/" + Guid.NewGuid().ToString();
            List<SelectedTemplate> UserFileList = new List<SelectedTemplate>();
            try
            {
                string fullpath = model.FullPath;

                Newpath = Path.Combine(fullpath, TempFile);
                if (!Directory.Exists(Newpath))
                {
                    Directory.CreateDirectory(Newpath);
                }
                List<SelectedTemplate> list = new List<SelectedTemplate>();
                //list = model.ContractTemplateList;
                //检查是否有用户上传的附件

                for (int i = 0; i < model.ContractTemplateList.Count; i++)
                {
                    if (model.ContractTemplateList[i].FileType == "OtherAttachment")
                    {
                        string WatermarkPath = string.Empty;
                        string OutFileName = Guid.NewGuid().ToString() + ".pdf";
                        string OutputPdfPath = Newpath + "/" + OutFileName;
                        if (model.IsPreview == "PDFExport")
                        {
                            WatermarkPath = NewQrCode(model.ContractNo);
                            this.PDFAddQrCode(HttpContext.Current.Server.MapPath(model.ContractTemplateList[i].FilePath), OutputPdfPath, WatermarkPath, 0, 0);
                        }
                        else
                        {
                            WatermarkPath = HttpContext.Current.Server.MapPath(ContractTemplate.ExpPDfPreview);
                            this.PDFAddPreview(HttpContext.Current.Server.MapPath(model.ContractTemplateList[i].FilePath), OutputPdfPath, WatermarkPath, 0, 0);
                        }


                        SelectedTemplate UserFileTemplate = new SelectedTemplate();
                        UserFileTemplate.FilePath = GetRelativePath(TempFile + "/" + OutFileName);
                        UserFileTemplate.TmpName = model.ContractTemplateList[i].TmpName;
                        UserFileTemplate.TmpID = model.ContractTemplateList[i].TmpID;
                        UserFileList.Add(UserFileTemplate);
                        model.ContractTemplateList.Remove(model.ContractTemplateList[i]);
                        i--;
                    }

                }
                foreach (var i in model.ContractTemplateList)
                {

                    if (i.FilePath != null)
                    {
                        list.Add(i);
                    }

                }
                foreach (var i in list)
                {
                    var filepath = i.FilePath;
                    //  var sourcePath = Path.GetFullPath(Path.Combine(fullpath, filepath));

                    var sourcePath = HttpContext.Current.Server.MapPath(filepath);
                    var f = filepath.Split(new char[] { '/' });
                    var desPath = Path.GetFullPath(Path.Combine(Newpath, f.Last()));
                    File.Copy(sourcePath, desPath);
                }
                List<Bookmark> listMark = ListBookMark(model);
                foreach (var i in list)
                {
                    //if (i.TmpID.ToLower() != "3efa8a35-82f4-4b6d-9b4d-39ffa666cffa" && i.TmpID.ToLower() != "2fb78cd6-366e-4558-a761-04937e0870f0")
                    // {
                    var filepath = i.FilePath;
                    var f = filepath.Split(new char[] { '/' });
                    List<Bookmark> HeadMark = new List<Bookmark>();
                    var desPath = Path.GetFullPath(Path.Combine(Newpath, f.Last()));
                    if (model.IsPreview == "Preview")
                    {
                        string value = "<!DOCTYPE html><html><head><meta charset='UTF-8'/></head><body><h1 style='color:red;'>此版本仅供预览使用</h1></body></html>";

                        HeadMark = HeadBookMark("head", BookmarkType.Html, value);
                    }
                    else
                    {
                        string value = NewQrCode(model.ContractNo);
                        HeadMark = HeadBookMark("head", BookmarkType.Image, value);
                    }
                    BookMark(model, desPath, listMark, HeadMark);
                    // }
                }


                string[] files = new string[list.Count - 1];

                var index0 = list[0];
                var filepath0 = index0.FilePath.Split(new char[] { '/' }).Last();
                var desPath0 = Path.GetFullPath(Path.Combine(Newpath, filepath0));


                using (WordProcessing word = new WordProcessing(desPath0))
                {
                    for (int i = 0; i < list.Count; i++)
                    {
                        if (i > 0)
                        {
                            var tmp1 = list[i];
                            var tmpPath = tmp1.FilePath.Split(new char[] { '/' }).Last();
                            var desPath = Path.GetFullPath(Path.Combine(Newpath, tmpPath));
                            var tmpid = tmp1.TmpID.ToLower();

                            files[i - 1] = desPath;
                        }

                    }
                    word.AppendDocuments(files);
                    word.Save();
                }

                string FileName = "";
                if (UserFileList.Count > 0)
                {
                    FileName = Guid.NewGuid().ToString();
                }
                else
                {
                    FileName = GetFileName(model.ContractNo);
                }
                string pdf0path = Path.GetFullPath(Path.Combine(Newpath, FileName + ".pdf"));
                NewFilePath = GetRelativePath(TempFile + "/" + FileName + ".pdf");

                using (WordApp wordapp = new WordApp(desPath0))
                {
                    wordapp.Save();
                    wordapp.SavePdf(pdf0path);

                }

                if (UserFileList.Count > 0)
                {
                    string[] Files = new string[UserFileList.Count + 1];
                    Files[0] = NewFilePath;
                    for (int i = 0; i < UserFileList.Count; i++)
                    {
                        Files[i + 1] = UserFileList[i].FilePath;
                    }
                    FileName = GetFileName(model.ContractNo);
                    NewFilePath = mergePDFFiles(Files, NewFilePath, TempFile, FileName);
                }
                model.IsSuccess = true;
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }




            model.FilePath = NewFilePath;
            return model;
        }
        private string GetFileName(string ContractNo)
        {
            string FileName = DateTime.Now.ToString("yyyyMMddHH") + ContractNo;
            return FileName;

        }
        private static float getScale(float width, float height)
        {
            float scaleX = iTextSharp.text.PageSize.A4.Width / width;
            float scaleY = iTextSharp.text.PageSize.A4.Height / height;
            return Math.Min(scaleX, scaleY);
        }

        private string mergePDFFiles(string[] fileList, string outMergeFile, string FileNnames, string Name)
        {

            PdfReader reader;
            iTextSharp.text.Document document = new iTextSharp.text.Document();
            Rectangle pageSize = iTextSharp.text.PageSize.A4;
            string FileName = GetRelativePath(FileNnames) + "/" + Name + ".pdf";
            PdfWriter writer = PdfWriter.GetInstance(document,
                new FileStream(HttpContext.Current.Server.MapPath(FileName), FileMode.Create));
            document.Open();
            PdfContentByte cb = writer.DirectContent;
            PdfImportedPage newPage;
            for (int i = 0; i < fileList.Length; i++)
            {
                // reader = new PdfReader(Server.MapPath(fileList[i]));
                reader = new PdfReader(HttpContext.Current.Server.MapPath(fileList[i]));
                int iPageNum = reader.NumberOfPages;
                for (int j = 1; j <= iPageNum; j++)
                {
                    document.NewPage();
                    document.SetPageSize(pageSize);

                    newPage = writer.GetImportedPage(reader, j);

                    Rectangle pagesize = reader.GetPageSizeWithRotation(j);
                    float oWidth = pagesize.Width;
                    float oHeight = pagesize.Height;
                    float scale = getScale(oWidth, oHeight);
                    float scaledWidth = oWidth * scale;
                    float scaledHeight = oHeight * scale;
                    int rotation = reader.GetPageRotation(j);
                    AffineTransform transform = new AffineTransform(scale, 0, 0,
                        scale, 0, 0);
                    switch (rotation)
                    {
                        case 90:
                            {
                                AffineTransform rotate90 = new AffineTransform(0, -1f, 1f, 0, 0, scaledHeight);
                                rotate90.Concatenate(transform);
                                cb.AddTemplate(newPage, rotate90);
                                break;
                            }
                        case 180:
                            {
                                AffineTransform rotate180 = new AffineTransform(-1f, 0, 0, -1f, scaledWidth, scaledHeight);
                                rotate180.Concatenate(transform);
                                cb.AddTemplate(newPage, rotate180);
                                break;
                            }
                        case 270:
                            {
                                AffineTransform rotate270 = new AffineTransform(0, 1f, -1f, 0, scaledWidth, 0);
                                rotate270.Concatenate(transform);
                                cb.AddTemplate(newPage, rotate270);
                                break;
                            }
                        default:
                            {
                                cb.AddTemplate(newPage, transform);
                                break;
                            }
                    }
                }
            }
            document.Close();
            return FileName;
        }

        public string GetRelativePath(string FileName)
        {

            string path = "~//Upload/ContractElectronicAttachmentTemplate/";
            if (!string.IsNullOrEmpty(FileName))
            {
                path = Path.Combine(path, FileName);
            }
            Regex r = new Regex("\\|/", RegexOptions.None);
            path = r.Replace(path, Path.DirectorySeparatorChar.ToString());
            return path;
        }
        public List<Bookmark> HeadBookMark(string bookName, BookmarkType type, string value)
        {
            List<Bookmark> list = new List<Bookmark>();
            list.Add(new Bookmark { BookmarkName = bookName, BookmarkType = type, BookmarkValue = value });
            return list;
        }
        public List<Bookmark> HeadBookImage(string bookName, BookmarkType type, string value)
        {
            List<Bookmark> list = new List<Bookmark>();
            list.Add(new Bookmark { BookmarkName = bookName, BookmarkType = type, BookmarkValue = value });
            return list;
        }
        public List<Bookmark> ListBookMark(ContractDetailView model)
        {
            List<Bookmark> list = new List<Bookmark>();
            list.Add(new Bookmark { BookmarkName = "ContractNo", BookmarkType = BookmarkType.Text, BookmarkValue = model.ContractNo });
            list.Add(new Bookmark { BookmarkName = "AgreementEndDate", BookmarkType = BookmarkType.Text, BookmarkValue = Convert.ToDateTime(model.AgreementEndDate).ToString("yyyy年MM月dd日") });
            list.Add(new Bookmark { BookmarkName = "AgreementStartDate", BookmarkType = BookmarkType.Text, BookmarkValue = Convert.ToDateTime(model.AgreementStartDate).ToString("yyyy年MM月dd日") });
            list.Add(new Bookmark { BookmarkName = "AgreementEndDateEn", BookmarkType = BookmarkType.Text, BookmarkValue = Convert.ToDateTime(model.AgreementEndDate).ToString("dd MMMM yyyy", CultureInfo.CreateSpecificCulture("en-us")) });

            //list.Add(new Bookmark { BookmarkName = "AgreementStartDateEn", BookmarkType = BookmarkType.Text, BookmarkValue = Convert.ToDateTime(model.AgreementStartDate).GetDateTimeFormats('r')[0].ToString() });
            list.Add(new Bookmark { BookmarkName = "AgreementStartDateEn", BookmarkType = BookmarkType.Text, BookmarkValue = Convert.ToDateTime(model.AgreementStartDate).ToString("dd MMMM yyyy", CultureInfo.CreateSpecificCulture("en-us")) });
            list.Add(new Bookmark { BookmarkName = "DealerAddress", BookmarkType = BookmarkType.Text, BookmarkValue = model.DealerAddress });
            list.Add(new Bookmark { BookmarkName = "DealerAddressEn", BookmarkType = BookmarkType.Text, BookmarkValue = model.DealerAddressEn });
            list.Add(new Bookmark { BookmarkName = "DealerFax", BookmarkType = BookmarkType.Text, BookmarkValue = model.DealerFax });
            list.Add(new Bookmark { BookmarkName = "DealerMail", BookmarkType = BookmarkType.Text, BookmarkValue = model.DealerMail });
            list.Add(new Bookmark { BookmarkName = "DealerManager", BookmarkType = BookmarkType.Text, BookmarkValue = model.DealerManager });
            list.Add(new Bookmark { BookmarkName = "DealerManagerEn", BookmarkType = BookmarkType.Text, BookmarkValue = model.DealerManagerEn });
            list.Add(new Bookmark { BookmarkName = "DealerName", BookmarkType = BookmarkType.Text, BookmarkValue = model.DealerName });
            list.Add(new Bookmark { BookmarkName = "LogisticsCompany", BookmarkType = BookmarkType.Text, BookmarkValue = model.LogisticsCompany });
            list.Add(new Bookmark { BookmarkName = "StartDate", BookmarkType = BookmarkType.Text, BookmarkValue = model.StartDate == string.Empty ? "" : Convert.ToDateTime(model.StartDate).ToString("yyyy年MM月dd日") });
            list.Add(new Bookmark { BookmarkName = "EndDate", BookmarkType = BookmarkType.Text, BookmarkValue = model.EndDate == string.Empty ? "" : Convert.ToDateTime(model.EndDate).ToString("yyyy年MM月dd日") });
            //list.Add(new Bookmark { BookmarkName = "Date", BookmarkType = BookmarkType.Text, BookmarkValue = Convert.ToDateTime(DateTime.Now).ToString("yyyy年MM月dd日") });
            list.Add(new Bookmark { BookmarkName = "DealerName1", BookmarkType = BookmarkType.Text, BookmarkValue = model.DealerName });
            list.Add(new Bookmark { BookmarkName = "DealerNameEn", BookmarkType = BookmarkType.Text, BookmarkValue = model.DealerNameEn });
            list.Add(new Bookmark { BookmarkName = "DealerNameEn1", BookmarkType = BookmarkType.Text, BookmarkValue = model.DealerNameEn });
            list.Add(new Bookmark { BookmarkName = "DealerName5", BookmarkType = BookmarkType.Text, BookmarkValue = model.DealerName });

            list.Add(new Bookmark { BookmarkName = "DealerNameEn5", BookmarkType = BookmarkType.Text, BookmarkValue = model.DealerNameEn });
            list.Add(new Bookmark { BookmarkName = "DealerPhone", BookmarkType = BookmarkType.Text, BookmarkValue = model.DealerPhone });
            list.Add(new Bookmark { BookmarkName = "RepresentName", BookmarkType = BookmarkType.Text, BookmarkValue = model.DealerContact });
            list.Add(new Bookmark { BookmarkName = "RepresentName2", BookmarkType = BookmarkType.Text, BookmarkValue = model.DealerContact });
            #region  法人取值
            ESignBLL bll = new ESignBLL();
            string strT2LegalName = "";
            string strLPLegalName = "";
            {
                EnterpriseRegisterVO vo = new EnterpriseRegisterVO();
                vo.DealerId = model.DealerId;
                DataTable dtLegal = bll.QueryEnterpriseRegister(vo);
                if (dtLegal != null && dtLegal.Rows.Count > 0)
                {
                    strT2LegalName = Convert.ToString(dtLegal.Rows[0]["LegalName"]);
                }
            }
            {
                var dealer = dealerMasters.GetDealerMaster(new Guid(model.DealerId));
                EnterpriseRegisterVO vo = new EnterpriseRegisterVO();
                vo.DealerId = dealer.ParentDmaId.Value.ToString();
                DataTable dtLegal = bll.QueryEnterpriseRegister(vo);
                if (dtLegal != null && dtLegal.Rows.Count > 0)
                {
                    strLPLegalName = Convert.ToString(dtLegal.Rows[0]["LegalName"]);
                }
            }

            #endregion  法人取值
            list.Add(new Bookmark { BookmarkName = "T2LegalName", BookmarkType = BookmarkType.Text, BookmarkValue = strT2LegalName });
            list.Add(new Bookmark { BookmarkName = "T2LegalName1", BookmarkType = BookmarkType.Text, BookmarkValue = strT2LegalName });
            list.Add(new Bookmark { BookmarkName = "LPLegalName", BookmarkType = BookmarkType.Text, BookmarkValue = strLPLegalName });
            //if (model.DealerType == "T1" && model.DeptId == "18")
            //{

            //}
            //else
            //{
            //    list.Add(new Bookmark { BookmarkName = "DeptName", BookmarkType = BookmarkType.Text, BookmarkValue = model.DeptName });
            //    list.Add(new Bookmark { BookmarkName = "DeptNameEn", BookmarkType = BookmarkType.Text, BookmarkValue = model.DeptNameEn });
            //}

            string BrandName = "";
            ContractMasterDao cmd = new ContractMasterDao();
            DataSet dsBrand = cmd.SelectSubCompnayAndBrandInfoByBU(model.DeptId);
            if (dsBrand.Tables[0].Rows.Count > 0)
            {
                BrandName = Convert.ToString(dsBrand.Tables[0].Rows[0]["BrandName"]);
            }
            list.Add(new Bookmark { BookmarkName = "BrandName", BookmarkType = BookmarkType.Text, BookmarkValue = BrandName });
            using (QueryDao dao = new QueryDao())
            {
                DataSet ProductDs = dao.SelectAuthorizationProductByContractId(model.ContractId);
                string ProductCn = "";
                string ProductEn = "";
                if (ProductDs.Tables[0].Rows.Count > 0)
                {
                    ProductCn = ProductDs.Tables[0].Rows[0]["ProductName"].ToString().Replace("<!DOCTYPE html><html><head><meta charset='UTF-8'></head><body><table style='border: 0; width: 100%;'>", "<!DOCTYPE html><html><head></head><body><table style='border: 0; width: 100%;'><tr><td style='font-family:新宋体; font-size:15px;'>" + model.DeptName + "<br/>&nbsp;</td></tr>");
                    ProductEn = ProductDs.Tables[0].Rows[0]["ProductEnglishName"].ToString().Replace("<!DOCTYPE html><html><head><meta charset='UTF-8'></head><body><table style='border: 0; width: 100%;'>", "<!DOCTYPE html><html><head></head><body><table style='border: 0; width: 100%;'><tr><td style='font-family:新宋体; font-size:15px;'>" + model.DeptNameEn + "<br/>&nbsp;</td></tr>");
                }
                else
                {
                    ProductCn = "<!DOCTYPE html><html><head></head><body>" + model.DeptName + "</body></html>";
                    ProductEn = "<!DOCTYPE html><html><head></head><body>" + model.DeptNameEn + "</body></html>";
                }
                list.Add(new Bookmark { BookmarkName = "DeptName", BookmarkType = BookmarkType.Html, BookmarkValue = ProductCn });
                list.Add(new Bookmark { BookmarkName = "DeptNameEn", BookmarkType = BookmarkType.Html, BookmarkValue = ProductEn });
            }

            if (model.DealerType == "T2" && model.ContractType == "Amendment")
            {
                #region T2 Amendment
                string PEIndex = "";
                string PEPPIndex = "";
                string PurchasingIndex = "";
                string HospitalIndex = "";
                string AuthorizedHospital = "";
                string AddOrUpdateSubu1 = "";
                string AddOrUpdateSubu2 = "";
                string AddOrUpdateSubu3 = "";
                string UpdataSubBuName = "";
                DataTable tb = new DataTable();
                DataSet dsHospital = new DataSet();
                using (QueryDao dao = new QueryDao())
                {
                    int Number = 2;
                    PurchasingIndex = dao.T2DealerAopDataHtmlTable(model.ContractId);
                    //Rovus设备、Endo设备、EP设备 不生成医院植入指标
                    if (model.SubDepId != "C1703" && model.DeptNameEn != "C1802" && model.DeptNameEn != "C3202")
                    {
                        HospitalIndex = "<b>" + Number + "、医院植入指标（金额、不含税）</b>" + dao.T2DealerImportAopDataHtmlTable(model.ContractId);
                        Number += 1;
                    }

                    PEIndex = dao.T2DealerPEHtmlTable(model.ContractId);
                    PEPPIndex = dao.T2DealerPEPPHtmlTable(model.ContractId);
                    if (PEPPIndex != "")
                    {
                        PEPPIndex = "<b>" + Number + "、DES支架类产品采购指标（PE, PE,PE+,PP, Synergy）</b>" + PEPPIndex;
                        Number += 1;
                    }


                    if (PEIndex != "")
                    {
                        PEIndex = "<b>" + Number + "、PE+经销商植入金额指标</b>" + PEIndex;
                    }

                    dsHospital = dao.SelectFunAuthorizationData(model.ContractId);
                    if (dsHospital != null && dsHospital.Tables.Count != 0)
                    {
                        for (int i = 0; i < dsHospital.Tables[0].Rows.Count; i++)
                        {
                            AuthorizedHospital += dsHospital.Tables[0].Rows[i]["TerritoryName"].ToString() == "" ? dsHospital.Tables[0].Rows[i]["TerritoryName"].ToString() : dsHospital.Tables[0].Rows[i]["TerritoryName"].ToString() + ",";

                        }

                        list.Add(new Bookmark { BookmarkName = "AuthorizedHospital", BookmarkType = BookmarkType.Text, BookmarkValue = AuthorizedHospital });

                    }

                    DataSet d = dao.GetSubBuContract(model.DealerId, model.DeptId, model.SubDepId, model.ContractNo);
                    DataTable S = dao.GetClassificationContract(model.SubDepId);
                    string IsSubu = d.Tables[0].Rows[0]["Column1"].ToString();
                    string strSubBuName = S.Rows[0][0].ToString();
                    if (IsSubu == "F")
                    {
                        AddOrUpdateSubu1 = "一、增加产品线:" + strSubBuName;//" + model.SubBuName+"
                        AddOrUpdateSubu2 = "二、增加" + model.SubBuName + "产品线授权区域为：" + AuthorizedHospital;
                        AddOrUpdateSubu3 = "三、增加" + model.SubBuName + "产品线指标为:";
                    }
                    else if (IsSubu == "T")
                    {
                        UpdataSubBuName = strSubBuName + "产线";
                        AddOrUpdateSubu1 = "一、该"+ UpdataSubBuName + "合同附件1的授权区域变更为：" + AuthorizedHospital;
                        AddOrUpdateSubu2 = "二、该" + UpdataSubBuName + "合同的指标变更为:";
                    }

                    tb = dao.GetContract(model.DealerId, CurrentSubCompany?.Key, CurrentBrand?.Key);
                }
                list.Add(new Bookmark { BookmarkName = "T2DealerName", BookmarkType = BookmarkType.Text, BookmarkValue = model.DealerName });
                list.Add(new Bookmark { BookmarkName = "LPSignDate", BookmarkType = BookmarkType.Text, BookmarkValue = Convert.ToDateTime(tb.Rows[0]["CreateDate"]).ToString("yyyy年MM月dd日") });
                list.Add(new Bookmark { BookmarkName = "ProtocolNumber", BookmarkType = BookmarkType.Text, BookmarkValue = model.ContractNo });
                list.Add(new Bookmark { BookmarkName = "ProtocolDate", BookmarkType = BookmarkType.Text, BookmarkValue = Convert.ToDateTime(model.AgreementStartDate).ToString("yyyy年MM月dd日") });
                list.Add(new Bookmark { BookmarkName = "TakeDate", BookmarkType = BookmarkType.Text, BookmarkValue = Convert.ToDateTime(tb.Rows[0]["AgreementStartDate"]).ToString("yyyy年MM月dd日") });
                list.Add(new Bookmark { BookmarkName = "EffectiveDate", BookmarkType = BookmarkType.Text, BookmarkValue = Convert.ToDateTime(tb.Rows[0]["AgreementEndDate"]).ToString("yyyy年MM月dd日") });
                list.Add(new Bookmark { BookmarkName = "Subu", BookmarkType = BookmarkType.Text, BookmarkValue = model.SubBuName });
                list.Add(new Bookmark { BookmarkName = "AuthorizedHospital", BookmarkType = BookmarkType.Text, BookmarkValue = model.DeptName });
                list.Add(new Bookmark { BookmarkName = "Subu1", BookmarkType = BookmarkType.Text, BookmarkValue = model.SubBuName });
                list.Add(new Bookmark { BookmarkName = "PurchasingIndex", BookmarkType = BookmarkType.Html, BookmarkValue = PurchasingIndex });
                list.Add(new Bookmark { BookmarkName = "HospitalIndex", BookmarkType = BookmarkType.Html, BookmarkValue = HospitalIndex });
                list.Add(new Bookmark { BookmarkName = "LPName", BookmarkType = BookmarkType.Text, BookmarkValue = model.PlatformName });
                list.Add(new Bookmark { BookmarkName = "LPName1", BookmarkType = BookmarkType.Text, BookmarkValue = model.PlatformName });
                list.Add(new Bookmark { BookmarkName = "BusinessGroup", BookmarkType = BookmarkType.Text, BookmarkValue = model.PlatformBusinessContact });
                list.Add(new Bookmark { BookmarkName = "BusinessGroupPhone", BookmarkType = BookmarkType.Text, BookmarkValue = model.PlatformBusinessPhone });
                list.Add(new Bookmark { BookmarkName = "LPName2", BookmarkType = BookmarkType.Text, BookmarkValue = model.PlatformName });
                list.Add(new Bookmark { BookmarkName = "LPName3", BookmarkType = BookmarkType.Text, BookmarkValue = model.PlatformName });
                list.Add(new Bookmark { BookmarkName = "T2DealerName1", BookmarkType = BookmarkType.Text, BookmarkValue = model.DealerName });
                list.Add(new Bookmark { BookmarkName = "Subu2", BookmarkType = BookmarkType.Text, BookmarkValue = model.SubBuName });
                list.Add(new Bookmark { BookmarkName = "T2DealerName2", BookmarkType = BookmarkType.Text, BookmarkValue = model.DealerName });
                list.Add(new Bookmark { BookmarkName = "UpdataSubBuName", BookmarkType = BookmarkType.Text, BookmarkValue = UpdataSubBuName });
                list.Add(new Bookmark { BookmarkName = "AddOrUpdateSubu1", BookmarkType = BookmarkType.Text, BookmarkValue = AddOrUpdateSubu1 });
                list.Add(new Bookmark { BookmarkName = "AddOrUpdateSubu2", BookmarkType = BookmarkType.Text, BookmarkValue = AddOrUpdateSubu2 });
                list.Add(new Bookmark { BookmarkName = "AddOrUpdateSubu3", BookmarkType = BookmarkType.Text, BookmarkValue = AddOrUpdateSubu3 });
                list.Add(new Bookmark { BookmarkName = "PEIndex", BookmarkType = BookmarkType.Html, BookmarkValue = PEIndex });
                list.Add(new Bookmark { BookmarkName = "PEPPIndex", BookmarkType = BookmarkType.Html, BookmarkValue = PEPPIndex });
                
                #endregion T2 Amendment
            }
            if (model.DealerType == "T2" && (model.ContractType == "Appointment" || model.ContractType == "Renewal"))
            {
                #region T2 Appointment&Renewal
                string PurchasingIndex = "";
                string HospitalIndex = "";
                string PEIndex = "";
                string PEPPIndex = "";
                string ProductCn = "";
                string ProductEn = "";
                string AuthorizedHospital = "";
                string Taxamount = "";
                DataSet dsHospital = new DataSet();
                using (QueryDao dao = new QueryDao())
                {

                    if (model.SubDepId != "C1703" && model.DeptNameEn != "C1802" && model.DeptNameEn != "C3202")
                    {
                        HospitalIndex = "<b>2、医院植入指标（如适用）</b>" + dao.T2DealerImportAopDataHtmlTable(model.ContractId);
                    }

                    PurchasingIndex = dao.T2DealerAopDataHtmlTable(model.ContractId);
                    PEIndex = dao.T2DealerPEHtmlTable(model.ContractId);
                    PEPPIndex = dao.T2DealerPEPPHtmlTable(model.ContractId);
                    if (PEPPIndex != "")
                    {
                        PEPPIndex = "<b>3、DES支架类产品采购指标（PE, PE,PE+,PP, Synergy）</b>" + PEPPIndex;

                    }


                    if (PEIndex != "")
                    {
                        PEIndex = "<b>4、PE+经销商植入金额指标</b>" + PEIndex;
                    }

                    //HospitalIndex = dao.T2DealerImportAopDataHtmlTable(model.ContractId);
                    Taxamount = dao.GetT2Taxamount(model.ContractId).Rows.Count > 0 ? dao.GetT2Taxamount(model.ContractId).Rows[0]["Taxamount"].ToString() : "";
                    DataSet ProductDs = dao.SelectAuthorizationProductByContractId(model.ContractId);

                    //if (ProductDs.Tables[0].Rows.Count > 0)
                    //{
                    //    ProductCn = ProductDs.Tables[0].Rows[0]["ProductName"].ToString().Replace("<!DOCTYPE html><html><head><meta charset='UTF-8'></head><body><table style='border: 0; width: 100%;'>", "<!DOCTYPE html><html><head><meta charset='UTF-8'></head><body><table style='border: 0; width: 100%;'><tr><td style='font-family:新宋体; font-size:15px;'>" + BrandName + model.DeptName + "<br/>&nbsp;</td></tr>");
                    //    ProductEn = ProductDs.Tables[0].Rows[0]["ProductEnglishName"].ToString().Replace("<!DOCTYPE html><html><head><meta charset='UTF-8'></head><body><table style='border: 0; width: 100%;'>", "<!DOCTYPE html><html><head><meta charset='UTF-8'></head><body><table style='border: 0; width: 100%;'><tr><td style='font-family:新宋体; font-size:15px;'>" + model.DeptNameEn + "<br/>&nbsp;</td></tr>");
                    //}
                    //else
                    //{
                    //    ProductCn = "<!DOCTYPE html><html><head><meta charset=''UTF-8''></head><body>" + BrandName + model.DeptName + "</body></html>";
                    //    ProductEn = "<!DOCTYPE html><html><head><meta charset=''UTF-8''></head><body>" + model.DeptNameEn + "</body></html>";
                    //}
                    ProductCn = BrandName + model.DeptName;
                    ProductEn = model.DeptNameEn;
                    dsHospital = dao.SelectFunAuthorizationData(model.ContractId);
                    if (dsHospital != null && dsHospital.Tables.Count != 0)
                    {
                        for (int i = 0; i < dsHospital.Tables[0].Rows.Count; i++)
                        {
                            AuthorizedHospital += dsHospital.Tables[0].Rows[i]["TerritoryName"].ToString() == "" ? dsHospital.Tables[0].Rows[i]["TerritoryName"].ToString() : dsHospital.Tables[0].Rows[i]["TerritoryName"].ToString() + ",";

                        }

                        list.Add(new Bookmark { BookmarkName = "AuthorizedHospital", BookmarkType = BookmarkType.Text, BookmarkValue = AuthorizedHospital });

                    }
                }
                //邮寄地址取
                DataTable tb = new DataTable();
                using (QueryDao dao = new QueryDao())
                {
                    tb = dao.GetContractMainInfo(model.ContractId);
                }
                string EmailAddress = model.DealerAddress;
                if (tb != null && tb.Rows.Count > 0)
                {
                    EmailAddress = Convert.ToString(tb.Rows[0]["EmailAddress"]);
                }
                string AgreementDate = "";
                /*if (model.PlatformName.Contains("聚赢"))
                {
                    AgreementDate = "2017-07-01";
                }
                else if (model.PlatformName.Contains("国科"))
                {
                    AgreementDate = "2017-01-08";
                }
                else if (model.PlatformName.Contains("方承"))
                {
                    AgreementDate = "2017-02-09";
                }
                */
                AgreementDate = DateTime.Now.ToString("yyyy-01-01");
                list.Add(new Bookmark { BookmarkName = "T2DealerName", BookmarkType = BookmarkType.Text, BookmarkValue = model.DealerName });
                list.Add(new Bookmark { BookmarkName = "LPName", BookmarkType = BookmarkType.Text, BookmarkValue = model.PlatformName });
                list.Add(new Bookmark { BookmarkName = "LPAddress", BookmarkType = BookmarkType.Text, BookmarkValue = model.PlatformAddress });
                list.Add(new Bookmark { BookmarkName = "LPOpeningBank", BookmarkType = BookmarkType.Text, BookmarkValue = model.PlatformBank });
                list.Add(new Bookmark { BookmarkName = "T2Address", BookmarkType = BookmarkType.Text, BookmarkValue = model.DealerAddress });
                list.Add(new Bookmark { BookmarkName = "T2OpeningBank", BookmarkType = BookmarkType.Text, BookmarkValue = model.DealerBank });
                list.Add(new Bookmark { BookmarkName = "AgreementDate", BookmarkType = BookmarkType.Text, BookmarkValue = Convert.ToDateTime(AgreementDate).ToString("yyyy年MM月dd日") });
                list.Add(new Bookmark { BookmarkName = "EnsureAmount", BookmarkType = BookmarkType.Text, BookmarkValue = !string.IsNullOrEmpty(model.Guarantee)? model.Guarantee:"0"});
                list.Add(new Bookmark { BookmarkName = "ContractTerminationDateStart", BookmarkType = BookmarkType.Text, BookmarkValue = Convert.ToDateTime(model.AgreementStartDate).ToString("yyyy年MM月dd日") });
                list.Add(new Bookmark { BookmarkName = "ContractTerminationDateEnd", BookmarkType = BookmarkType.Text, BookmarkValue = Convert.ToDateTime(model.AgreementEndDate).ToString("yyyy年MM月dd日") });
                list.Add(new Bookmark { BookmarkName = "LPName1", BookmarkType = BookmarkType.Text, BookmarkValue = model.PlatformName });
                list.Add(new Bookmark { BookmarkName = "LPFax", BookmarkType = BookmarkType.Text, BookmarkValue = model.PlatformFax });
                list.Add(new Bookmark { BookmarkName = "LPZipAddress", BookmarkType = BookmarkType.Text, BookmarkValue = model.PlatformAddress });
                list.Add(new Bookmark { BookmarkName = "T2DealerName1", BookmarkType = BookmarkType.Text, BookmarkValue = model.DealerName });
                list.Add(new Bookmark { BookmarkName = "T2Fax", BookmarkType = BookmarkType.Text, BookmarkValue = model.DealerFax });
                list.Add(new Bookmark { BookmarkName = "T2ZipAddress", BookmarkType = BookmarkType.Text, BookmarkValue = EmailAddress });
                list.Add(new Bookmark { BookmarkName = "LPName2", BookmarkType = BookmarkType.Text, BookmarkValue = model.PlatformName });
                list.Add(new Bookmark { BookmarkName = "T2DealerName2", BookmarkType = BookmarkType.Text, BookmarkValue = model.DealerName });
                list.Add(new Bookmark { BookmarkName = "T2Contact", BookmarkType = BookmarkType.Text, BookmarkValue = model.DealerContact });
                list.Add(new Bookmark { BookmarkName = "T2Contact1", BookmarkType = BookmarkType.Text, BookmarkValue = model.DealerContact });
                list.Add(new Bookmark { BookmarkName = "TakeDate", BookmarkType = BookmarkType.Text, BookmarkValue = Convert.ToDateTime(model.AgreementEndDate).ToString("yyyy年MM月dd日") });
                list.Add(new Bookmark { BookmarkName = "Subu", BookmarkType = BookmarkType.Text, BookmarkValue = ProductCn });
                list.Add(new Bookmark { BookmarkName = "PurchasingIndex", BookmarkType = BookmarkType.Html, BookmarkValue = PurchasingIndex });
                list.Add(new Bookmark { BookmarkName = "HospitalIndex", BookmarkType = BookmarkType.Html, BookmarkValue = HospitalIndex });
                list.Add(new Bookmark { BookmarkName = "ContractTerminationDateStart1", BookmarkType = BookmarkType.Text, BookmarkValue = Convert.ToDateTime(model.AgreementStartDate).ToString("yyyy年MM月dd日") });
                list.Add(new Bookmark { BookmarkName = "ContractTerminationDateEnd1", BookmarkType = BookmarkType.Text, BookmarkValue = Convert.ToDateTime(model.AgreementEndDate).ToString("yyyy年MM月dd日") });
                list.Add(new Bookmark { BookmarkName = "T2phone", BookmarkType = BookmarkType.Text, BookmarkValue = model.Phone });
                list.Add(new Bookmark { BookmarkName = "Taxamount", BookmarkType = BookmarkType.Text, BookmarkValue = Taxamount });
                list.Add(new Bookmark { BookmarkName = "LPName3", BookmarkType = BookmarkType.Text, BookmarkValue = model.PlatformName });
                list.Add(new Bookmark { BookmarkName = "PEIndex", BookmarkType = BookmarkType.Html, BookmarkValue = PEIndex });
                list.Add(new Bookmark { BookmarkName = "PEPPIndex", BookmarkType = BookmarkType.Html, BookmarkValue = PEPPIndex });
                
                #endregion T2 Appointment&Renewal
            }
            if (model.DealerType == "T2" && model.ContractType == "Termination")
            {
                #region T2 Termination
                DataTable tb = new DataTable();
                using (QueryDao dao = new QueryDao())
                {
                    tb = dao.GetContract(model.DealerId, CurrentSubCompany?.Key, CurrentBrand?.Key);
                }

                if (tb.Rows.Count > 0)
                {
                    list.Add(new Bookmark { BookmarkName = "ContractDate", BookmarkType = BookmarkType.Text, BookmarkValue = Convert.ToDateTime(tb.Rows[0]["CreateDate"]).ToString("yyyy年MM月dd日") });
                    list.Add(new Bookmark { BookmarkName = "TakeDate", BookmarkType = BookmarkType.Text, BookmarkValue = Convert.ToDateTime(tb.Rows[0]["AgreementStartDate"]).ToString("yyyy年MM月dd日") });

                    list.Add(new Bookmark { BookmarkName = "EffectiveDate", BookmarkType = BookmarkType.Text, BookmarkValue = Convert.ToDateTime(tb.Rows[0]["AgreementEndDate"]).ToString("yyyy年MM月dd日") });
                }
                else
                {
                    list.Add(new Bookmark { BookmarkName = "ContractDate", BookmarkType = BookmarkType.Text, BookmarkValue = "" });
                }
                list.Add(new Bookmark { BookmarkName = "TakeDate2", BookmarkType = BookmarkType.Text, BookmarkValue = DateTime.Now.ToString("yyyy年MM月dd日") });
                list.Add(new Bookmark { BookmarkName = "ProtocolNumber", BookmarkType = BookmarkType.Text, BookmarkValue = model.ContractNo });
                list.Add(new Bookmark { BookmarkName = "ProtocolDate", BookmarkType = BookmarkType.Text, BookmarkValue = Convert.ToDateTime(model.AgreementStartDate).ToString("yyyy年MM月dd日") });

                list.Add(new Bookmark { BookmarkName = "Subu", BookmarkType = BookmarkType.Text, BookmarkValue = model.DeptName });
                list.Add(new Bookmark { BookmarkName = "TerminationDate", BookmarkType = BookmarkType.Text, BookmarkValue = Convert.ToDateTime(model.AgreementEndDate).ToString("yyyy年MM月dd日") });
                list.Add(new Bookmark { BookmarkName = "T2DealerName", BookmarkType = BookmarkType.Text, BookmarkValue = model.DealerName });
                list.Add(new Bookmark { BookmarkName = "T2DealerName2", BookmarkType = BookmarkType.Text, BookmarkValue = model.DealerName });
                list.Add(new Bookmark { BookmarkName = "T2DealerName3", BookmarkType = BookmarkType.Text, BookmarkValue = model.DealerName });
                list.Add(new Bookmark { BookmarkName = "T2DealerName4", BookmarkType = BookmarkType.Text, BookmarkValue = model.DealerName });
                list.Add(new Bookmark { BookmarkName = "T2Address", BookmarkType = BookmarkType.Text, BookmarkValue = model.DealerAddress });
                list.Add(new Bookmark { BookmarkName = "T2Contact", BookmarkType = BookmarkType.Text, BookmarkValue = model.DealerManager });
                list.Add(new Bookmark { BookmarkName = "LPName", BookmarkType = BookmarkType.Text, BookmarkValue = model.PlatformName });
                list.Add(new Bookmark { BookmarkName = "LPName1", BookmarkType = BookmarkType.Text, BookmarkValue = model.PlatformName });
                list.Add(new Bookmark { BookmarkName = "LPName2", BookmarkType = BookmarkType.Text, BookmarkValue = model.PlatformName });
                list.Add(new Bookmark { BookmarkName = "LPName3", BookmarkType = BookmarkType.Text, BookmarkValue = model.PlatformName });

                list.Add(new Bookmark { BookmarkName = "PaymentDate", BookmarkType = BookmarkType.Text, BookmarkValue = Convert.ToDateTime(model.AgreementStartDate).ToString("yyyy年MM月dd日") });
                
                #endregion T2 Termination
            }
            list.Add(new Bookmark { BookmarkName = "ExclusiveTypeEn", BookmarkType = BookmarkType.Text, BookmarkValue = model.ExclusiveType == "non-exclusive" ? "non - exclusive" : "exclusive" });
            list.Add(new Bookmark { BookmarkName = "ExclusiveTypeCn", BookmarkType = BookmarkType.Text, BookmarkValue = model.ExclusiveType == "non-exclusive" ? "非独家" : "独家" });

            list.Add(new Bookmark { BookmarkName = "CurYear", BookmarkType = BookmarkType.Text, BookmarkValue = Convert.ToDateTime(model.AgreementStartDate).Year.ToString() });
            list.Add(new Bookmark { BookmarkName = "AgreementStartDateEn1", BookmarkType = BookmarkType.Text, BookmarkValue = Convert.ToDateTime(model.AgreementStartDate).ToString("dd MMMM yyyy", CultureInfo.CreateSpecificCulture("en-us")) });
            list.Add(new Bookmark { BookmarkName = "AgreementStartDate1", BookmarkType = BookmarkType.Text, BookmarkValue = Convert.ToDateTime(model.AgreementStartDate).ToString("yyyy年MM月dd日") });
            list.Add(new Bookmark { BookmarkName = "AgreementEndDateEn1", BookmarkType = BookmarkType.Text, BookmarkValue = Convert.ToDateTime(model.AgreementEndDate).ToString("dd MMMM yyyy", CultureInfo.CreateSpecificCulture("en-us")) });
            list.Add(new Bookmark { BookmarkName = "AgreementEndDateEn2", BookmarkType = BookmarkType.Text, BookmarkValue = Convert.ToDateTime(model.AgreementEndDate).ToString("dd MMMM yyyy", CultureInfo.CreateSpecificCulture("en-us")) });
            list.Add(new Bookmark { BookmarkName = "OriginalStartDate", BookmarkType = BookmarkType.Text, BookmarkValue = Convert.ToDateTime(model.OriginalStartDate).ToString("yyyy年MM月dd日") });
            list.Add(new Bookmark { BookmarkName = "OriginalStartDateEn", BookmarkType = BookmarkType.Text, BookmarkValue = Convert.ToDateTime(model.OriginalStartDate).ToString("dd MMMM yyyy", CultureInfo.CreateSpecificCulture("en-us")) });
            list.Add(new Bookmark { BookmarkName = "ContractNo1", BookmarkType = BookmarkType.Text, BookmarkValue = model.ContractNo.ToString() });
            list.Add(new Bookmark { BookmarkName = "OriginalStartDate1", BookmarkType = BookmarkType.Text, BookmarkValue = Convert.ToDateTime(model.OriginalStartDate).ToString("yyyy年MM月dd日") });
            list.Add(new Bookmark { BookmarkName = "OriginalStartDateEn1", BookmarkType = BookmarkType.Text, BookmarkValue = Convert.ToDateTime(model.OriginalStartDate).ToString("dd MMMM yyyy", CultureInfo.CreateSpecificCulture("en-us")) });
            list.Add(new Bookmark { BookmarkName = "OriginalEndDate", BookmarkType = BookmarkType.Text, BookmarkValue = Convert.ToDateTime(model.OriginalEndDate).ToString("yyyy年MM月dd日") });
            list.Add(new Bookmark { BookmarkName = "OriginalEndDateEn", BookmarkType = BookmarkType.Text, BookmarkValue = Convert.ToDateTime(model.OriginalEndDate).ToString("dd MMMM yyyy", CultureInfo.CreateSpecificCulture("en-us")) });
            //list.Add(new Bookmark { BookmarkName = "OriginalStartDateEn", BookmarkType = BookmarkType.Text, BookmarkValue = Convert.ToDateTime(model.OriginalStartDate).GetDateTimeFormats('r')[0].ToString() });
            var tableAopTarget = "";
            var tableImportTarget = "";
            var Author = "";
            using (QueryDao dao = new QueryDao())
            {
                tableAopTarget = dao.DealerAopDataHtmlTable(model.ContractId);
                tableImportTarget = dao.DealerImportAopDataHtmlTable(model.ContractId);

                //如果授权分类中包含“设备”，则判断此合同中经销商属性为“设备经销商”
                //对于“设备经销商”和“平台经销商”不需要显示植入指标
                //if (model.DealerType != "LP" && model.SubProductName.Contains("设备") == false)
                //{
                tableAopTarget = string.Format("{0}{1}{2}", tableAopTarget, "<br/><br/><br/>", tableImportTarget);
                //}

            }

            list.Add(new Bookmark { BookmarkName = "tableTarget", BookmarkType = BookmarkType.Html, BookmarkValue = tableAopTarget });
            // list.Add(new Bookmark { BookmarkName = "Author", BookmarkType = BookmarkType.Text, BookmarkValue = Author });
            if (model.IsPreview == "Preview")
            {
                list.Add(new Bookmark { BookmarkName = "head", BookmarkType = BookmarkType.Html, BookmarkValue = "<!DOCTYPE html><html><head></head><body><h1 style='color:red;'>此版本仅供预览使用</h1></body></html>" });
            }
            else
            {
                list.Add(new Bookmark { BookmarkName = "head", BookmarkType = BookmarkType.Image, BookmarkValue = model.QrCde });
            }
            if (!string.IsNullOrEmpty(model.Rebate))
            {
                var obj = JsonConvert.DeserializeObject<Rebate>(model.Rebate);
                list.Add(new Bookmark { BookmarkName = "RebateRation", BookmarkType = BookmarkType.Text, BookmarkValue = obj.RebateRation });
                list.Add(new Bookmark { BookmarkName = "RebateRation1", BookmarkType = BookmarkType.Text, BookmarkValue = obj.RebateRation });
                list.Add(new Bookmark { BookmarkName = "RebateDiscount", BookmarkType = BookmarkType.Text, BookmarkValue = obj.RebateDiscount });
                list.Add(new Bookmark { BookmarkName = "RebateDiscount1", BookmarkType = BookmarkType.Text, BookmarkValue = obj.RebateDiscount });
                list.Add(new Bookmark { BookmarkName = "QuarterRatio", BookmarkType = BookmarkType.Text, BookmarkValue = obj.QuarterRatio });
                list.Add(new Bookmark { BookmarkName = "QuarterRatio1", BookmarkType = BookmarkType.Text, BookmarkValue = obj.QuarterRatio });
                if (obj.DiscountList.Count != 0)
                {
                    var discountList = obj.DiscountList.ToList();
                    var table = "";
                    var table2 = "";
                    table += "<thead><tr><th>经销商季度业绩考评得分</th><th>在第一部分返利基础上的额外折扣</th></tr></thead><tbody>";
                    table2 = "<thead><tr><th>Scores of the Quarterly Dealer Performance Review</th><th>Additional Discount on Top of Part I Rebate</th></tr></thead><tbody>";
                    foreach (var i in discountList)
                    {
                        table += "<tr><td>" + i.Grade + "</td><td>" + i.Discount + "</td></tr>";
                        table2 += "<tr><td>" + i.Grade + "</td><td>" + i.Discount + "</td></tr>";
                    }
                    table += "</tbody>";
                    table2 += "</tbody>";
                    var html1 = "<!DOCTYPE html><html><head></head><body><table style='border-style:solid;border-collapse:collapse;text-align: center;' border='1'>" + table + "</table></body></html>";
                    var html2 = "<!DOCTYPE html><html><head></head><body><table style='border-style:solid;border-collapse:collapse;text-align: center;' border='1'>" + table2 + "</table></body></html>";
                    list.Add(new Bookmark { BookmarkName = "DiscountListCn", BookmarkType = BookmarkType.Html, BookmarkValue = html1 });
                    list.Add(new Bookmark { BookmarkName = "DiscountListEn", BookmarkType = BookmarkType.Html, BookmarkValue = html2 });
                }
            }
            DataSet ds = new DataSet();
            var authDataCn = "";
            var authDataEn = "";
            using (QueryDao dao = new QueryDao())
            {
                if ((model.ContractType == "Appointment" || model.ContractType == "Renewal") && model.DealerType == "LP")
                {
                    ds = dao.SelectFunAuthorizationData(model.ContractId);
                    if (ds != null && ds.Tables.Count != 0)
                    {
                        for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                        {
                            authDataCn += ds.Tables[0].Rows[i]["TerritoryName"].ToString() == "" ? ds.Tables[0].Rows[i]["TerritoryName"].ToString() : ds.Tables[0].Rows[i]["TerritoryName"].ToString() + ",";
                            authDataEn += ds.Tables[0].Rows[i]["TerritoryEName"].ToString() == "" ? ds.Tables[0].Rows[i]["TerritoryEName"].ToString() : ds.Tables[0].Rows[i]["TerritoryEName"].ToString() + ",";
                        }

                        list.Add(new Bookmark { BookmarkName = "AuthCityCn", BookmarkType = BookmarkType.Text, BookmarkValue = authDataCn });
                        list.Add(new Bookmark { BookmarkName = "AuthCityEn", BookmarkType = BookmarkType.Text, BookmarkValue = authDataEn });
                    }
                }
                else
                {
                    ds = dao.SelectAuthorizationByContractId(model.ContractId);
                    if (ds != null && ds.Tables.Count != 0)
                    {

                        authDataCn = ds.Tables[0].Rows[0]["StrHtml"].ToString() == "" ? ds.Tables[0].Rows[0]["StrHtml"].ToString() : ds.Tables[0].Rows[0]["StrHtml"].ToString();
                        list.Add(new Bookmark { BookmarkName = "AuthCityCn", BookmarkType = BookmarkType.Html, BookmarkValue = string.Format(ContractTemplate.HtmlTempale, authDataCn) });
                    }

                }
            }

            string PaymentCn = string.Empty;
            string PaymentEn = string.Empty;
            if (model.PaymentType == "Credit" && Convert.ToInt32(model.CreditTerm == "" ? "0" : model.CreditTerm) <= 90)
            {
                decimal CompanyGuarantee = model.CompanyGuarantee == "" ? 0 : Convert.ToDecimal(model.CompanyGuarantee);
                if (CompanyGuarantee <= 0)
                {
                    PaymentCn = DMS.Common.Common.ContractTemplate.CreditPaymentCnv2;
                    PaymentEn = DMS.Common.Common.ContractTemplate.CreditPaymentEnv2;
                }
                else
                {
                    PaymentCn = DMS.Common.Common.ContractTemplate.CreditPaymentCnv1;
                    PaymentEn = DMS.Common.Common.ContractTemplate.CreditPaymentEnv1;
                }

                PaymentCn = PaymentCn.Replace("{#PaymentDays}", model.PaymentDays);
                PaymentCn = PaymentCn.Replace("{#Rmb1#}", model.CreditLimit);
                PaymentCn = PaymentCn.Replace("{#Rmb2#}", model.BankGuarantee);
                PaymentCn = PaymentCn.Replace("{#Rmb3#}", model.CompanyGuarantee);

                PaymentEn = PaymentEn.Replace("{#PaymentDays}", model.PaymentDays);
                PaymentEn = PaymentEn.Replace("{#Rmb1#}", model.CreditLimit);
                PaymentEn = PaymentEn.Replace("{#Rmb2#}", model.BankGuarantee);
                PaymentEn = PaymentEn.Replace("{#Rmb3#}", model.CompanyGuarantee);
            }
            else if (model.PaymentType == "Credit" && Convert.ToInt32(model.CreditTerm == "" ? "0" : model.CreditTerm) > 90)
            {
                PaymentCn = DMS.Common.Common.ContractTemplate.CreditPaymentCn2;
                PaymentCn = PaymentCn.Replace("{#PaymentDays}", model.PaymentDays);
                PaymentCn = PaymentCn.Replace("{#Rmb1#}", model.CreditLimit);
                PaymentCn = PaymentCn.Replace("{#Rmb2#}", model.BankGuarantee);
                PaymentCn = PaymentCn.Replace("{#Rmb3#}", model.CompanyGuarantee);
                PaymentEn = DMS.Common.Common.ContractTemplate.CreditPaymentEn2;
                PaymentEn = PaymentEn.Replace("{#PaymentDays}", model.PaymentDays);
                PaymentEn = PaymentEn.Replace("{#Rmb1#}", model.CreditLimit);
                PaymentEn = PaymentEn.Replace("{#Rmb2#}", model.BankGuarantee);
                PaymentEn = PaymentEn.Replace("{#Rmb3#}", model.CompanyGuarantee);
            }
            else if (model.PaymentType == "COD")
            {
                PaymentCn = DMS.Common.Common.ContractTemplate.CodPaymentCn;
                PaymentEn = DMS.Common.Common.ContractTemplate.CodPaymentEn;
            }
            else
            {
                PaymentCn = "<!DOCTYPE html><html><head></head><body><div style=\"font-family:SimSun;font-size:15px; text-align:left;\">" + model.PaymentType + "</div></html>";
                PaymentEn = "<!DOCTYPE html><html><head></head><body><div style=\"font-family:SimSun;font-size:15px; text-align:left;\">" + model.PaymentType + "</div></html>";
            }
            list.Add(new Bookmark { BookmarkName = "PaymentCn", BookmarkType = BookmarkType.Text, BookmarkValue = PaymentCn });
            list.Add(new Bookmark { BookmarkName = "PaymentEn", BookmarkType = BookmarkType.Text, BookmarkValue = PaymentEn });
            list.Add(new Bookmark { BookmarkName = "DeptName1", BookmarkType = BookmarkType.Text, BookmarkValue = model.DeptName });
            list.Add(new Bookmark { BookmarkName = "DeptNameEn1", BookmarkType = BookmarkType.Text, BookmarkValue = model.DeptNameEn });
            list.Add(new Bookmark { BookmarkName = "DeptName2", BookmarkType = BookmarkType.Text, BookmarkValue = model.DeptName });
            list.Add(new Bookmark { BookmarkName = "DeptNameEn2", BookmarkType = BookmarkType.Text, BookmarkValue = model.DeptNameEn });
            list.Add(new Bookmark { BookmarkName = "DeptName3", BookmarkType = BookmarkType.Text, BookmarkValue = model.DeptName });
            list.Add(new Bookmark { BookmarkName = "DeptNameEn3", BookmarkType = BookmarkType.Text, BookmarkValue = model.DeptNameEn });
            list.Add(new Bookmark { BookmarkName = "DeptName4", BookmarkType = BookmarkType.Text, BookmarkValue = model.DeptName });
            list.Add(new Bookmark { BookmarkName = "DeptNameEn4", BookmarkType = BookmarkType.Text, BookmarkValue = model.DeptNameEn });
            list.Add(new Bookmark { BookmarkName = "DeptNameEn4", BookmarkType = BookmarkType.Text, BookmarkValue = model.DeptNameEn });
            list.Add(new Bookmark { BookmarkName = "AgreementStartDateYMD1", BookmarkType = BookmarkType.Text, BookmarkValue = Convert.ToDateTime(model.AgreementStartDate).ToString("yyyy年MM月dd日") });
            list.Add(new Bookmark { BookmarkName = "AgreementStartDateYMDEn1", BookmarkType = BookmarkType.Text, BookmarkValue = Convert.ToDateTime(model.AgreementStartDate).ToString("dd MMMM yyyy", CultureInfo.CreateSpecificCulture("en-us")) });
            list.Add(new Bookmark { BookmarkName = "AgreementStartDateYMD2", BookmarkType = BookmarkType.Text, BookmarkValue = Convert.ToDateTime(model.AgreementStartDate).ToString("yyyy年MM月dd日") });
            list.Add(new Bookmark { BookmarkName = "AgreementStartDateYMDEn2", BookmarkType = BookmarkType.Text, BookmarkValue = Convert.ToDateTime(model.AgreementStartDate).ToString("dd MMMM yyyy", CultureInfo.CreateSpecificCulture("en-us")) });
            list.Add(new Bookmark { BookmarkName = "AgreementStartDateYMD3", BookmarkType = BookmarkType.Text, BookmarkValue = Convert.ToDateTime(model.AgreementStartDate).ToString("yyyy年MM月dd日") });
            list.Add(new Bookmark { BookmarkName = "AgreementStartDateYMDEn3", BookmarkType = BookmarkType.Text, BookmarkValue = Convert.ToDateTime(model.AgreementStartDate).ToString("dd MMMM yyyy", CultureInfo.CreateSpecificCulture("en-us")) });
            list.Add(new Bookmark { BookmarkName = "AgreementStartDateYMD4", BookmarkType = BookmarkType.Text, BookmarkValue = Convert.ToDateTime(model.AgreementStartDate).ToString("yyyy年MM月dd日") });
            list.Add(new Bookmark { BookmarkName = "AgreementStartDateYMDEn4", BookmarkType = BookmarkType.Text, BookmarkValue = Convert.ToDateTime(model.AgreementStartDate).ToString("dd MMMM yyyy", CultureInfo.CreateSpecificCulture("en-us")) });
            list.Add(new Bookmark { BookmarkName = "COName", BookmarkType = BookmarkType.Text, BookmarkValue = model.COName });
            list.Add(new Bookmark { BookmarkName = "COContactInfo", BookmarkType = BookmarkType.Text, BookmarkValue = model.COContactInfo });
            list.Add(new Bookmark { BookmarkName = "CONameEn", BookmarkType = BookmarkType.Text, BookmarkValue = model.CONameEn });
            list.Add(new Bookmark { BookmarkName = "COContactInfo1", BookmarkType = BookmarkType.Text, BookmarkValue = model.COContactInfo });
            list.Add(new Bookmark { BookmarkName = "DealerName2", BookmarkType = BookmarkType.Text, BookmarkValue = model.DealerName });
            list.Add(new Bookmark { BookmarkName = "DealerNameEn2", BookmarkType = BookmarkType.Text, BookmarkValue = model.DealerNameEn });
            list.Add(new Bookmark { BookmarkName = "DealerName3", BookmarkType = BookmarkType.Text, BookmarkValue = model.DealerName });
            list.Add(new Bookmark { BookmarkName = "DealerNameEn3", BookmarkType = BookmarkType.Text, BookmarkValue = model.DealerNameEn });
            list.Add(new Bookmark { BookmarkName = "DealerName4", BookmarkType = BookmarkType.Text, BookmarkValue = model.DealerName });
            list.Add(new Bookmark { BookmarkName = "DealerNameEn4", BookmarkType = BookmarkType.Text, BookmarkValue = model.DealerNameEn });
            list.Add(new Bookmark { BookmarkName = "AgreementEndDateYMD1", BookmarkType = BookmarkType.Text, BookmarkValue = Convert.ToDateTime(model.AgreementEndDate).ToString("yyyy年MM月dd日") });
            list.Add(new Bookmark { BookmarkName = "AgreementEndDateYMD2", BookmarkType = BookmarkType.Text, BookmarkValue = Convert.ToDateTime(model.AgreementEndDate).ToString("yyyy年MM月dd日") });
            list.Add(new Bookmark { BookmarkName = "AgreementEndDateYMD3", BookmarkType = BookmarkType.Text, BookmarkValue = Convert.ToDateTime(model.AgreementEndDate).ToString("yyyy年MM月dd日") });
            list.Add(new Bookmark { BookmarkName = "AgreementEndDateYMDEn1", BookmarkType = BookmarkType.Text, BookmarkValue = Convert.ToDateTime(model.AgreementEndDate).ToString("dd MMMM yyyy", CultureInfo.CreateSpecificCulture("en-us")) });
            list.Add(new Bookmark { BookmarkName = "TerminationEn", BookmarkType = BookmarkType.Text, BookmarkValue = model.TerminationType == "Termination" ? "Termination" : "no Termination" });
            list.Add(new Bookmark { BookmarkName = "TerminationCn", BookmarkType = BookmarkType.Text, BookmarkValue = model.TerminationType == "Termination" ? "Termination" : "no Termination" });
            list.Add(new Bookmark { BookmarkName = "TerminationCn", BookmarkType = BookmarkType.Text, BookmarkValue = model.TerminationType == "Termination" ? "Termination" : "no Termination" });
            list.Add(new Bookmark { BookmarkName = "ApplicantName", BookmarkType = BookmarkType.Text, BookmarkValue = model.ApplicantName });
            list.Add(new Bookmark { BookmarkName = "ApplicantNameEn", BookmarkType = BookmarkType.Text, BookmarkValue = model.ApplicantNameEn });
            if (model.DealerType == "T1" && model.ContractType == "Termination")
            {
                int Balance = 0;
                if ((int.TryParse(model.Balance, out Balance)))
                {
                    if (Balance > 0)
                    {
                        string StrEn = DMS.Common.Common.ContractTemplate.TerminationTextEn;
                        string StrCn = DMS.Common.Common.ContractTemplate.TerminationTextCn;
                        StrEn = StrEn.Replace("{#AgreementEndDateEn}", Convert.ToDateTime(model.AgreementEndDate).ToString("dd MMMM yyyy", CultureInfo.CreateSpecificCulture("en-us")));
                        StrCn = StrCn.Replace("{#AgreementEndDateCn}", Convert.ToDateTime(model.AgreementEndDate).ToString("yyyy年MM月dd日"));
                        list.Add(new Bookmark { BookmarkName = "TerminationTextEn", BookmarkType = BookmarkType.Text, BookmarkValue = StrEn });
                        list.Add(new Bookmark { BookmarkName = "TerminationTextCn", BookmarkType = BookmarkType.Text, BookmarkValue = StrCn });
                    }
                }
            }
            list.Add(new Bookmark { BookmarkName = "SubProductEName1", BookmarkType = BookmarkType.Text, BookmarkValue = model.SubProductEName });
            list.Add(new Bookmark { BookmarkName = "SubProductEName2", BookmarkType = BookmarkType.Text, BookmarkValue = model.SubProductEName });
            list.Add(new Bookmark { BookmarkName = "SubProductEName3", BookmarkType = BookmarkType.Text, BookmarkValue = model.SubProductEName });
            list.Add(new Bookmark { BookmarkName = "SubProductEName4", BookmarkType = BookmarkType.Text, BookmarkValue = model.SubProductEName });
            list.Add(new Bookmark { BookmarkName = "SubProductEName5", BookmarkType = BookmarkType.Text, BookmarkValue = model.SubProductEName });
            list.Add(new Bookmark { BookmarkName = "SubProductEName6", BookmarkType = BookmarkType.Text, BookmarkValue = model.SubProductEName });
            list.Add(new Bookmark { BookmarkName = "SubProductEName7", BookmarkType = BookmarkType.Text, BookmarkValue = model.SubProductEName });
            list.Add(new Bookmark { BookmarkName = "SubProductEName8", BookmarkType = BookmarkType.Text, BookmarkValue = model.SubProductEName });
            list.Add(new Bookmark { BookmarkName = "SubProductName1", BookmarkType = BookmarkType.Text, BookmarkValue = model.SubProductName });
            list.Add(new Bookmark { BookmarkName = "SubProductName2", BookmarkType = BookmarkType.Text, BookmarkValue = model.SubProductName });
            list.Add(new Bookmark { BookmarkName = "SubProductName3", BookmarkType = BookmarkType.Text, BookmarkValue = model.SubProductName });
            list.Add(new Bookmark { BookmarkName = "SubProductName4", BookmarkType = BookmarkType.Text, BookmarkValue = model.SubProductName });
            list.Add(new Bookmark { BookmarkName = "SubProductName5", BookmarkType = BookmarkType.Text, BookmarkValue = model.SubProductName });
            if (model.ContractType == "Amendment")
            {
                StringBuilder strHtml = new StringBuilder(string.Empty);
                StringBuilder strHtmlCn = new StringBuilder(string.Empty);
                int Linbr = 0;
                if (model.IsProduct == 1)
                {
                    Linbr = Linbr + 1;

                    using (QueryDao dao = new QueryDao())
                    {
                        DataSet ProductDs = dao.SelectAuthorizationProductByContractId(model.ContractId);
                        string ProductCn = "";
                        string ProductEn = "";
                        if (ProductDs.Tables[0].Rows.Count > 0)
                        {
                            ProductCn = ProductDs.Tables[0].Rows[0]["ProductName"].ToString().Replace("<!DOCTYPE html><html><head><meta charset='UTF-8'></head><body><table style='border: 0; width: 100%;'>", "<!DOCTYPE html><html><head></head><body><table style='border: 0; width: 100%;'><tr><td style='font-family:新宋体; font-size:15px;'>" + model.DeptName + "<br/>&nbsp;</td></tr>");
                            ProductEn = ProductDs.Tables[0].Rows[0]["ProductEnglishName"].ToString().Replace("<!DOCTYPE html><html><head><meta charset='UTF-8'></head><body><table style='border: 0; width: 100%;'>", "<!DOCTYPE html><html><head></head><body><table style='border: 0; width: 100%;'><tr><td style='font-family:新宋体; font-size:15px;'>" + model.DeptNameEn + "<br/>&nbsp;</td></tr>");
                        }
                        else
                        {
                            ProductCn = "<!DOCTYPE html><html><head></head><body>" + model.DeptName + "</body></html>";
                            ProductEn = "<!DOCTYPE html><html><head></head><body>" + model.DeptNameEn + "</body></html>";
                        }
                        list.Add(new Bookmark { BookmarkName = "DeptName", BookmarkType = BookmarkType.Html, BookmarkValue = ProductCn });
                        list.Add(new Bookmark { BookmarkName = "DeptNameEn", BookmarkType = BookmarkType.Html, BookmarkValue = ProductEn });

                        string AmendmentHtml1 = ContractTemplate.AmendmentHtml1;
                        AmendmentHtml1 = AmendmentHtml1.Replace("{#AgreementStartDateEn1#}", Convert.ToDateTime(model.AgreementStartDate).ToString("dd MMMM yyyy", CultureInfo.CreateSpecificCulture("en-us")));
                        AmendmentHtml1 = AmendmentHtml1.Replace("{#DeptNameEn#}", ProductEn);
                        AmendmentHtml1 = AmendmentHtml1.Replace("{#AgreementStartDate1#}", Convert.ToDateTime(model.AgreementStartDate).ToString("yyyy年MM月dd日"));
                        AmendmentHtml1 = AmendmentHtml1.Replace("{#DeptName#}", ProductCn);
                        AmendmentHtml1 = AmendmentHtml1.Replace("{#Linbr#}", Linbr.ToString());

                        strHtml.Append(AmendmentHtml1);
                    }

                }
                if (model.IsPrices == 1)
                {
                    Linbr = Linbr + 1;

                    string AmendmentHtml2 = ContractTemplate.AmendmentHtml2;
                    AmendmentHtml2 = AmendmentHtml2.Replace("{#AgreementStartDateYMDEn1#}", Convert.ToDateTime(model.AgreementStartDate).ToString("dd MMMM yyyy", CultureInfo.CreateSpecificCulture("en-us")));
                    AmendmentHtml2 = AmendmentHtml2.Replace("{#DeptNameEn1#}", model.DeptNameEn);
                    AmendmentHtml2 = AmendmentHtml2.Replace("{#DeptName1#}", model.DeptName);
                    AmendmentHtml2 = AmendmentHtml2.Replace("{#AgreementStartDateYMD1#}", Convert.ToDateTime(model.AgreementStartDate).ToString("yyyy年MM月dd日"));
                    AmendmentHtml2 = AmendmentHtml2.Replace("{#Linbr#}", Linbr.ToString());
                    strHtml.Append(AmendmentHtml2);

                }
                if (model.IsTerritory == 1)
                {
                    Linbr = Linbr + 1;


                    string AmendmentHtml3 = ContractTemplate.AmendmentHtml3;
                    AmendmentHtml3 = AmendmentHtml3.Replace("{#AgreementStartDateYMDEn2#}", Convert.ToDateTime(model.AgreementStartDate).ToString("dd MMMM yyyy", CultureInfo.CreateSpecificCulture("en-us")));
                    AmendmentHtml3 = AmendmentHtml3.Replace("{#DeptNameEn2#}", model.DeptNameEn);
                    AmendmentHtml3 = AmendmentHtml3.Replace("{#DeptName2#}", model.DeptName);
                    AmendmentHtml3 = AmendmentHtml3.Replace("{#AgreementStartDateYMD2#}", Convert.ToDateTime(model.AgreementStartDate).ToString("yyyy年MM月dd日"));
                    AmendmentHtml3 = AmendmentHtml3.Replace("{#Linbr#}", Linbr.ToString());
                    strHtml.Append(AmendmentHtml3);
                }
                if (model.IsPurchase == 1)
                {
                    Linbr = Linbr + 1;


                    string AmendmentHtml4 = ContractTemplate.AmendmentHtml4;
                    AmendmentHtml4 = AmendmentHtml4.Replace("{#AgreementStartDateYMDEn3#}", Convert.ToDateTime(model.AgreementStartDate).ToString("dd MMMM yyyy", CultureInfo.CreateSpecificCulture("en-us")));
                    AmendmentHtml4 = AmendmentHtml4.Replace("{#DeptNameEn3#}", model.DeptNameEn);
                    AmendmentHtml4 = AmendmentHtml4.Replace("{#AgreementStartDateYMD3#}", model.DeptName);
                    AmendmentHtml4 = AmendmentHtml4.Replace("{#DeptName3#}", Convert.ToDateTime(model.AgreementStartDate).ToString("yyyy年MM月dd日"));
                    AmendmentHtml4 = AmendmentHtml4.Replace("{#Linbr#}", Linbr.ToString());
                    strHtml.Append(AmendmentHtml4);
                }
                if (model.IsPayment == 1)
                {
                    Linbr = Linbr + 1;

                    string AmendmentHtml5 = ContractTemplate.AmendmentHtml5;
                    AmendmentHtml5 = AmendmentHtml5.Replace("{#AgreementStartDateYMDEn4#}", Convert.ToDateTime(model.AgreementStartDate).ToString("dd MMMM yyyy", CultureInfo.CreateSpecificCulture("en-us")));
                    AmendmentHtml5 = AmendmentHtml5.Replace("{#DeptNameEn4#}", model.DeptNameEn);
                    AmendmentHtml5 = AmendmentHtml5.Replace("{#PaymentEn#}", PaymentEn);
                    AmendmentHtml5 = AmendmentHtml5.Replace("{#DeptName4#}", model.DeptName);
                    AmendmentHtml5 = AmendmentHtml5.Replace("{#AgreementStartDateYMD4#}", Convert.ToDateTime(model.AgreementStartDate).ToString("yyyy年MM月dd日"));
                    AmendmentHtml5 = AmendmentHtml5.Replace("{#PaymentCn#}", PaymentCn);
                    AmendmentHtml5 = AmendmentHtml5.Replace("{#Linbr#}", Linbr.ToString());
                    strHtml.Append(AmendmentHtml5);
                }
                if (model.IsProduct == 1 || model.IsPrices == 1 || model.IsTerritory == 1 || model.IsPurchase == 1 || model.IsPayment == 1)
                {
                    string TextEn1 = string.Format(ContractTemplate.HtmlTempale, strHtml.ToString());
                    //  string TextCn1 = string.Format(ContractTemplate.HtmlTempale, strHtmlCn.ToString());
                    list.Add(new Bookmark { BookmarkName = "strHtml", BookmarkType = BookmarkType.Html, BookmarkValue = TextEn1 });
                    //  list.Add(new Bookmark { BookmarkName = "TextCn1", BookmarkType = BookmarkType.Html, BookmarkValue = TextCn1 });
                }

            }
            return list;
        }
        public ContractDetailView BookMark(ContractDetailView model, string desPath, List<Bookmark> list, List<Bookmark> HeadList)
        {
            try
            {
                //if (model.DealerType == "LP" && model.ContractType == "Renewal")
                //{
                using (WordProcessing word = new WordProcessing(desPath))
                {

                    word.ReplaceBookmarks(list);
                    word.ReplaceHeaderBookmarks(HeadList);
                    word.Save();
                }
                //}
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
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
        public void ContractSign(string ExportId, string UploadFilePath, string FileName, string DealerID)
        {
            try
            {
                using (LPandT1Dao dao = new LPandT1Dao())
                {
                    using (TransactionScope trans = new TransactionScope())
                    {
                        DataSet ds = dao.SelectExportVersionExporId(ExportId);
                        DataSet DealerType = dao.SelectDealerTypeExporId(DealerID);
                        if (ds.Tables[0].Rows.Count > 0)
                        {
                            string VersionStatus = ds.Tables[0].Rows[0]["VersionStatus"].ToString();
                            string Stauts = "";
                            if (VersionStatus == DMS.Common.ContractESignStatus.Cancelled.ToString()
                                || VersionStatus == DMS.Common.ContractESignStatus.Complete.ToString())
                            {
                                throw new Exception("电子合同状态已改变，请刷新页面");
                            }
                            else
                            {
                                if (VersionStatus == DMS.Common.ContractESignStatus.WaitDealerSign.ToString() && _context.User.IdentityType == "Dealer")
                                {
                                    if (DealerType.Tables[0].Rows[0]["DMA_DealerType"].ToString() == "T2")
                                    {
                                        Stauts = DMS.Common.ContractESignStatus.WaitLPSign.ToString();
                                    }
                                    if (DealerType.Tables[0].Rows[0]["DMA_DealerType"].ToString() == "T1" || DealerType.Tables[0].Rows[0]["DMA_DealerType"].ToString() == "LP")
                                    {
                                        Stauts = DMS.Common.ContractESignStatus.WaitBscSign.ToString();
                                    }

                                }
                                else if (VersionStatus == DMS.Common.ContractESignStatus.WaitBscSign.ToString() && _context.User.IdentityType == "User")
                                {
                                    Stauts = DMS.Common.ContractESignStatus.Complete.ToString();
                                }
                                else if (VersionStatus == DMS.Common.ContractESignStatus.WaitLPSign.ToString() && _context.User.IdentityType == "Dealer")
                                {
                                    Stauts = DMS.Common.ContractESignStatus.Complete.ToString();
                                }
                                else
                                {
                                    throw new Exception("");
                                }
                                //更新电子合同版本状态
                                dao.UpdateExportVersionStatusByExportId(ExportId, Stauts);
                                //更新附件路径
                                dao.UpdateExportSelectedTemplateExportId(ExportId, UploadFilePath + FileName, FileName);
                            }
                        }
                        else
                        {
                            throw new Exception("电子合同状态已改变，请刷新页面");
                        }
                        trans.Complete();
                    }

                }
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);

            }
        }
        public void ContractRevokeByExportId(ContractDetailView model)
        {

            try
            {
                using (LPandT1Dao dao = new LPandT1Dao())
                {
                    using (TransactionScope trans = new TransactionScope())
                    {
                        DataSet ds = dao.SelectExportVersionExporId(model.ExportId.ToString());
                        if (ds.Tables[0].Rows.Count > 0)
                        {
                            string VersionStatus = ds.Tables[0].Rows[0]["VersionStatus"].ToString();
                            if (VersionStatus == DMS.Common.ContractESignStatus.Cancelled.ToString()
                                || VersionStatus == DMS.Common.ContractESignStatus.Complete.ToString())
                            {
                                throw new Exception("电子合同状态已改变，请刷新页面");
                            }
                            else
                            {
                                //string Stauts = VersionStatus == DMS.Common.ContractESignStatus.Submitted.ToString() ? DMS.Common.ContractESignStatus.InApprova.ToString() : VersionStatus == DMS.Common.ContractESignStatus.InApprova.ToString() ? DMS.Common.ContractESignStatus.Complete.ToString() : VersionStatus;
                                //更新电子合同版本状态
                                dao.UpdateExportVersionStatusByExportId(model.ExportId.ToString(), "Cancelled");

                            }
                            model.IsSuccess = true;
                        }
                        else
                        {
                            throw new Exception("电子合同状态已改变，请刷新页面");
                        }
                        trans.Complete();
                    }

                }
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
                model.IsSuccess = false;

                model.ExecuteMessage.Add(ex.Message);

            }
        }
        public void ContractAbandonment(string ExportId, string UploadFilePath, string FileName)
        {
            try
            {
                using (LPandT1Dao dao = new LPandT1Dao())
                {
                    using (TransactionScope trans = new TransactionScope())
                    {
                        DataSet ds = dao.SelectExportVersionExporId(ExportId);
                        if (ds.Tables[0].Rows.Count > 0)
                        {
                            string VersionStatus = ds.Tables[0].Rows[0]["VersionStatus"].ToString();
                            string Stauts = "";
                            if (VersionStatus == DMS.Common.ContractESignStatus.Abandonment.ToString())
                            {
                                throw new Exception("合同状态已改变，请刷新页面");
                            }
                            else
                            {
                                if (VersionStatus == DMS.Common.ContractESignStatus.Complete.ToString() && _context.User.IdentityType == "User")
                                {
                                    Stauts = DMS.Common.ContractESignStatus.WaitDealerAbandonment.ToString();
                                }
                                else if (VersionStatus == DMS.Common.ContractESignStatus.WaitDealerAbandonment.ToString() && _context.User.IdentityType == "Dealer")
                                {
                                    Stauts = DMS.Common.ContractESignStatus.Abandonment.ToString();
                                }

                                //更新电子合同版本状态
                                dao.UpdateExportVersionStatusByExportId(ExportId, Stauts);
                                //更新附件路径
                                dao.UpdateExportSelectedTemplateExportId(ExportId, UploadFilePath + FileName, FileName);
                            }
                        }
                        else
                        {
                            throw new Exception("电子合同状态已改变，请刷新页面");
                        }
                        trans.Complete();
                    }

                }
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);

            }
        }
        //获取合同模板的路径
        public DataSet GetExportSelectedTemplateByExportId(string ExportId)
        {
            using (LPandT1Dao dao = new LPandT1Dao())
            {
                return dao.GetExportSelectedTemplateByExportId(ExportId);
            }
        }
        public DataSet SelectDealerMaster(string DealerName)
        {

            using (LPandT1Dao dao = new LPandT1Dao())
            {
                return dao.SelectDealerMaster(DealerName);
            }
        }

        public DataTable SelectDealerType(string ID)
        {

            using (LPandT1Dao dao = new LPandT1Dao())
            {
                return dao.SelectDealerType(ID).Tables[0];
            }
        }
        public bool PDFAddQrCode(string inputfilepath, string outputfilepath, string ModelPicName, float top, float left)
        {
            //throw new NotImplementedException();
            PdfReader pdfReader = null;
            PdfStamper pdfStamper = null;
            try
            {
                pdfReader = new PdfReader(inputfilepath);

                int numberOfPages = pdfReader.NumberOfPages;

                iTextSharp.text.Rectangle psize = pdfReader.GetPageSize(1);

                float width = psize.Width;

                float height = psize.Height;

                pdfStamper = new PdfStamper(pdfReader, new FileStream(outputfilepath, FileMode.Create));

                PdfContentByte waterMarkContent;

                iTextSharp.text.Image image = iTextSharp.text.Image.GetInstance(ModelPicName);

                image.GrayFill = 0;//透明度，灰色填充
                                   //image.Rotation//旋转
                                   //image.RotationDegrees//旋转角度
                                   //水印的位置 
                                   //if (left < 0)
                                   //{
                                   //    left = width / 2 - image.Width + left;
                                   //}

                //image.SetAbsolutePosition(left, (height - image.Height) - top);
                image.SetAbsolutePosition(width - image.Width - 10, height - image.Height - 10);
                image.ScalePercent(50f);

                //每一页加水印,也可以设置某一页加水印 
                for (int i = 1; i <= numberOfPages; i++)
                {
                    //waterMarkContent = pdfStamper.GetUnderContent(i);//内容下层加水印
                    waterMarkContent = pdfStamper.GetUnderContent(i);//内容上层加水印

                    waterMarkContent.AddImage(image);
                }
                //strMsg = "success";
                return true;
            }
            catch (Exception ex)
            {
                throw ex;

            }
            finally
            {

                if (pdfStamper != null)
                    pdfStamper.Close();

                if (pdfReader != null)
                    pdfReader.Close();
            }
        }
        public bool PDFAddPreview(string inputfilepath, string outputfilepath, string ModelPicName, float top, float left)
        {
            //throw new NotImplementedException();
            PdfReader pdfReader = null;
            PdfStamper pdfStamper = null;
            try
            {
                pdfReader = new PdfReader(inputfilepath);

                int numberOfPages = pdfReader.NumberOfPages;

                iTextSharp.text.Rectangle psize = pdfReader.GetPageSize(1);

                float width = psize.Width;

                float height = psize.Height;

                pdfStamper = new PdfStamper(pdfReader, new FileStream(outputfilepath, FileMode.Create));

                PdfContentByte waterMarkContent;

                iTextSharp.text.Image image = iTextSharp.text.Image.GetInstance(ModelPicName);

                image.GrayFill = 0;//透明度，灰色填充
                                   //image.Rotation//旋转
                                   //image.RotationDegrees//旋转角度
                                   //水印的位置 
                                   //if (left < 0)
                                   //{
                                   //    left = width / 2 - image.Width + left;
                                   //}

                //image.SetAbsolutePosition(left, (height - image.Height) - top);
                image.SetAbsolutePosition(width - image.Width - 300, height - image.Height - 100);
                image.ScalePercent(80f);

                //每一页加水印,也可以设置某一页加水印 
                for (int i = 1; i <= numberOfPages; i++)
                {
                    //waterMarkContent = pdfStamper.GetUnderContent(i);//内容下层加水印
                    waterMarkContent = pdfStamper.GetUnderContent(i);//内容上层加水印

                    waterMarkContent.AddImage(image);
                }
                //strMsg = "success";
                return true;
            }
            catch (Exception ex)
            {
                throw ex;

            }
            finally
            {

                if (pdfStamper != null)
                    pdfStamper.Close();

                if (pdfReader != null)
                    pdfReader.Close();
            }
        }
        public DataSet GetSingStatusList(string DictType)
        {
            using (LPandT1Dao dao = new LPandT1Dao())
            {
                return dao.GetSingStatusList(DictType);
            }
        }
        public DataSet GetProductLineRelation(Hashtable ht)
        {
            using (LPandT1Dao dao = new LPandT1Dao())
            {
                return dao.GetProductLineRelation(ht);
            }
        }

        public ContractDetailView GetReadTemplate(ContractDetailView model)
        {
            try
            {
                using (LPandT1Dao dao = new LPandT1Dao())
                {

                    Hashtable ht = new Hashtable();
                    ht.Add("ContractId", model.ContractId);
                    ht.Add("DealerType", model.DealerType);
                    ht.Add("ContractType", model.ContractType);
                    ht.Add("DivisionCode", model.DeptId);
                    model.QryList = JsonHelper.DataTableToArrayList(dao.GetReadTemplate(ht).Tables[0]);
                    model.IsSuccess = true;
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

        public ContractDetailView InsertDetail(ContractDetailView model)
        {
            try
            {
                using (LPandT1Dao dao = new LPandT1Dao())
                {

                    Hashtable ht = new Hashtable();
                    ht.Add("ID", Guid.NewGuid());
                    ht.Add("ContractID", model.ContractId);
                    ht.Add("ReadID", model.ReadID);
                    ht.Add("ReadUserId", UserInfo.Id);
                    ht.Add("ReadUserName", UserInfo.UserName);
                    ht.Add("ReadDate", DateTime.Now);
                    dao.InsertDetail(ht);

                    Hashtable ht2 = new Hashtable();
                    ht2.Add("ContractId", model.ContractId);
                    ht2.Add("DealerType", model.DealerType);
                    ht2.Add("ContractType", model.ContractType);
                    ht2.Add("DivisionCode", model.DeptId);
                    model.QryList = JsonHelper.DataTableToArrayList(dao.GetReadTemplate(ht2).Tables[0]);
                    model.IsSuccess = true;
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

        public ContractDetailView IsReadFile(ContractDetailView model)
        {
            try
            {
                using (LPandT1Dao dao = new LPandT1Dao())
                {
                    model.IsRead = true;
                    if (UserInfo.IdentityType == IdentityType.User.ToString())
                    {
                        model.IsRead = true;
                    }
                    else
                    {
                        //仅在“等待经销商签章”时，切操作人为经销商时会校验“阅读文件”的功能
                        if (model.VisionStatus == DMS.Common.ContractESignStatus.WaitDealerSign.ToString())
                        {
                            if ((model.DealerType == "T1" || model.DealerType == "T2") && (model.ContractType == "Amendment" || model.ContractType == "Termination"))
                            {
                                model.IsRead = true;
                            }
                            else if (model.DealerType == "LP" && model.ContractType == "Amendment")
                            {
                                model.IsRead = true;
                            }
                            else if (model.DealerType == "LS")
                            {
                                model.IsRead = true;
                            }
                            else
                            {
                                if (model.DealerType != "T2")
                                {
                                    Hashtable ht = new Hashtable();
                                    ht.Add("ContractId", model.ContractId);
                                    ht.Add("DealerType", model.DealerType);
                                    ht.Add("ContractType", model.ContractType);
                                    ht.Add("DivisionCode", model.DeptId);
                                    DataTable Read = new DataTable();

                                    Read = dao.IsReadFile(ht);
                                    if (Read.Rows.Count > 0)
                                    {
                                        model.IsRead = false;
                                    }
                                    else
                                    {
                                        model.IsRead = true;
                                    }
                                }
                                if (model.DealerType == "T2")
                                {
                                    Hashtable ht = new Hashtable();
                                    ht.Add("ContractId", model.ContractId);
                                    ht.Add("DealerType", model.DealerType);
                                    ht.Add("ContractType", model.ContractType);
                                    ht.Add("DivisionCode", model.DeptId);
                                    DataTable Read = new DataTable();

                                    Read = dao.IsReadFile(ht);
                                    if (Read.Rows.Count > 0)
                                    {
                                        model.IsRead = false;
                                    }
                                    else
                                    {
                                        model.IsRead = true;
                                    }
                                }

                            }
                        }
                    }

                    //bool trainingOneStatus = false;
                    //bool trainingTwoStatus = false;

                    //this.QueryDealerTrainingByDealerId(model, out trainingOneStatus, out trainingTwoStatus);

                    model.DealerName = _context.User.CorpName;
                    model.TraningOneStatus = true;//trainingOneStatus;
                    model.TraningTwoStatus = true;//trainingTwoStatus;

                    model.IsSuccess = true;
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

        public ContractDetailView InitUploadFile(ContractDetailView model)
        {
            try
            {
                using (ExportUploadDetailDao dao = new ExportUploadDetailDao())
                {
                    Hashtable table = new Hashtable();

                    if (!UserInfo.CorpId.HasValue)
                    {
                        throw new Exception("请用经销商账号登陆");
                    }

                    table.Add("DealerId", UserInfo.CorpId.Value);
                    model.FileData = dao.QueryUploadFileByDealerId(table);

                    table.Add("TemplateType", "OtherAttachment");
                    table.Add("ContractType", "Appointment");
                    model.UploadTemplateFileData = JsonHelper.DataTableToArrayList(dao.QueryUploadFileTemplateByDealerId(table));

                    model.IsSuccess = true;
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

        public ContractDetailView UploadFile(ContractDetailView model)
        {

            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    using (ExportUploadDetailDao dao = new ExportUploadDetailDao())
                    {
                        ExportUploadDetail exportUploadDetail = new ExportUploadDetail();

                        exportUploadDetail.Id = Guid.NewGuid();
                        exportUploadDetail.DmaId = UserInfo.CorpId.Value;
                        exportUploadDetail.UploadFilePath = model.FilePath;
                        exportUploadDetail.UploadFileName = model.FileName;
                        exportUploadDetail.FileType = "OtherAttachment";
                        exportUploadDetail.IsActived = 1;
                        exportUploadDetail.Status = "1";
                        exportUploadDetail.CreateDate = DateTime.Now;
                        exportUploadDetail.CreateUserId = new Guid(UserInfo.Id);
                        exportUploadDetail.CreateUserName = UserInfo.FullName;
                        exportUploadDetail.CreateDate = exportUploadDetail.CreateDate;
                        exportUploadDetail.CreateUserId = exportUploadDetail.CreateUserId;
                        exportUploadDetail.CreateUserName = exportUploadDetail.CreateUserName;

                        dao.Insert(exportUploadDetail);

                        model.IsSuccess = true;
                    }

                    trans.Complete();
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

        public void QueryDealerTrainingByDealerId(ContractDetailView model, out bool traningOneStatus, out bool traningTwoStatus)
        {
            using (LPandT1Dao dao = new LPandT1Dao())
            {
                Hashtable table = new Hashtable();

                table.Add("DealerId", model.DealerId);

                DataTable dt = dao.QueryDealerTrainingByDealerId(table);

                traningOneStatus = false;
                traningTwoStatus = false;

                //培训记录校验值针对新签以及续约合同
                if (UserInfo.IdentityType == IdentityType.Dealer.ToString())
                {
                    traningOneStatus = true;
                    traningTwoStatus = true;
                }
                else
                {
                    if (model.VisionStatus == DMS.Common.ContractESignStatus.WaitBscSign.ToString()
                        && (model.ContractType == "Appointment" || model.ContractType == "Renewal"))
                    {
                        if (model.DealerType == "T2")
                        {
                            traningTwoStatus = true;
                        }

                        if (dt.Rows.Count > 0)
                        {
                            foreach (DataRow dr in dt.Rows)
                            {
                                if (dr["TestName"].ToString() == "第三方合规知识培训-测试试题"
                                    && dr["IsActived"].ToString() == "1")
                                {
                                    traningOneStatus = true;
                                }
                                else if ((dr["TestName"].ToString() == "代理商质量培训考试"
                                    && dr["IsActived"].ToString() == "1")
                                    || model.DealerType == "T2")
                                {
                                    traningTwoStatus = true;
                                }
                            }
                        }
                    }
                    else
                    {
                        traningOneStatus = true;
                        traningTwoStatus = true;
                    }
                }
            }
        }

        public ContractDetailView QueryDealerTrainingByDealerId(ContractDetailView model)
        {
            try
            {
                using (LPandT1Dao dao = new LPandT1Dao())
                {
                    Hashtable table = new Hashtable();

                    table.Add("DealerId", model.DealerId);

                    DataTable dt = dao.QueryDealerTrainingByDealerId(table);

                    string rtnMsg = string.Empty;

                    foreach (DataRow dr in dt.Rows)
                    {
                        if (dr["TestName"].ToString() == "第三方合规知识培训-测试试题")
                        {
                            rtnMsg = string.Format("{0}&nbsp;&nbsp;&nbsp;{1}&nbsp;&nbsp;&nbsp;{2}&nbsp;&nbsp;&nbsp;{3}<br/><br/>", dr["IsActived"].ToString() == "1" ? "在90天内" : "超过90天", dr["TestStatus"].ToString(), Convert.ToDateTime(dr["TestDate"].ToString()).ToString("yyyy-MM-dd HH:mm:ss"), dr["TestName"].ToString());
                        }
                        else if (dr["TestName"].ToString() == "代理商质量培训考试"
                            && model.DealerType != "T2")
                        {
                            rtnMsg += string.Format("{0}&nbsp;&nbsp;&nbsp;{1}&nbsp;&nbsp;&nbsp;{2}&nbsp;&nbsp;&nbsp;{3}<br/><br/>", dr["IsActived"].ToString() == "1" ? "在90天内" : "超过90天", dr["TestStatus"].ToString(), Convert.ToDateTime(dr["TestDate"].ToString()).ToString("yyyy-MM-dd HH:mm:ss"), dr["TestName"].ToString());
                        }
                    }

                    model.TraningResult = rtnMsg;
                    model.IsSuccess = true;
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

        public ContractDetailView GetLpAndT1ContractEsignTypeByContractId(ContractDetailView model)
        {
            try
            {
                using (QueryDao dao = new QueryDao())
                {
                    model.ESignContractType = model.ContractType;

                    //Amendment和Termination这两种类型的合同直接返回即可
                    if (model.ContractType != "Amendment" && model.ContractType != "Termination")
                    {
                        DataTable dt = dao.GetContractEsignTypeByContractId(model.ContractId);
                        //返回结果没有结果集，延用合同的本身的类型
                        if (dt.Rows.Count > 0)
                        {
                            string contractNo = dt.Rows[0]["ContractNo"].ToString();

                            //如果合同编号等同那么延用合同的本身的类型
                            //其他情况下统一使用“Amendment”类型的电子合同末班
                            if (contractNo == model.ContractNo)
                            {
                                model.ESignContractType = dt.Rows[0]["ContractType"].ToString();
                            }
                            else
                            {
                                model.ESignContractType = "Amendment";
                            }
                        }
                    }

                    model.IsSuccess = true;
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

        /// <summary>
        /// 波科签章结束后邮件提醒CO用户
        /// </summary>
        /// <param name="model"></param>
        public void SendEmail(EnterpriseSignVO model)
        {

            using (QueryDao dao = new QueryDao())
            {
                using (MailDeliveryAddressDao mailAddressDao = new MailDeliveryAddressDao())
                {
                    Hashtable ht = new Hashtable();
                    ht.Add("ExportId", model.FileId);

                    //根据ID获取合同信息
                    ContractDetailView view = dao.SelectContractMainByExportId(ht).First<ContractDetailView>();

                    MailDeliveryAddress mda = new MailDeliveryAddress();
                    mda.MailType = "LP&T1_BSCESIGN";
                    mda.MailTo = "CO";
                    mda.ActiveFlag = true;
                    mda.ProductLineid = Guid.Empty;
                    IList<MailDeliveryAddress> mailList = mailAddressDao.SelectMailDeliveryAddressByCondition(mda);

                    MessageBLL msgBll = new MessageBLL();
                    MailMessageTemplate template = msgBll.GetMailMessageTemplate(MailMessageTemplateCode.EMAIL_ESIGN_BSCSIGN_ALERT.ToString());

                    Dictionary<string, string> subjectDict = new Dictionary<string, string>();
                    subjectDict.Add("ContractNo", view.ContractNo);

                    Dictionary<string, string> bodyDict = new Dictionary<string, string>();
                    bodyDict.Add("DealerName", view.DealerName);
                    bodyDict.Add("BU", view.DeptName);
                    bodyDict.Add("ContractClassification", view.SubProductName);
                    bodyDict.Add("ContractType", view.ContractType);
                    bodyDict.Add("UserName", string.Format("{0}({1})", UserInfo.FullName, UserInfo.LoginId));

                    foreach (MailDeliveryAddress mailAddress in mailList)
                    {
                        msgBll.AddToMailMessageQueue(MailMessageTemplateCode.EMAIL_ESIGN_BSCSIGN_ALERT, subjectDict, bodyDict, mailAddress.MailAddress);
                    }
                }
            }
        }

        public void CheckContractStatus(string ExportId, DMS.Common.ContractESignStatus VersionStatus)
        {
            using (LPandT1Dao dao = new LPandT1Dao())
            {
                DataSet ds = dao.SelectExportVersionExporId(ExportId);

                if (VersionStatus.ToString() != ds.Tables[0].Rows[0]["VersionStatus"].ToString())
                {
                    throw new Exception("电子合同状态已改变，请刷新页面");
                }
            }
        }
    }
}
