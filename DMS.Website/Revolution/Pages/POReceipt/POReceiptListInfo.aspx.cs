using DMS.Business;
using DMS.Website.Common;
using iTextSharp.text;
using iTextSharp.text.pdf;
using Newtonsoft.Json;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DMS.Website.Revolution.Pages.POReceipt
{
    public partial class POReceiptListInfo : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        #region 下载表单文件
        [WebMethod]
        public static ResultAjax DownloadPdf(string Lot, string Property1, string Upn)
        {
            ResultAjax res = new ResultAjax();
            res.success = true;

            ICfns _cfns = Global.ApplicationContainer.Resolve<ICfns>();
            Hashtable param = new Hashtable();
            param.Add("CustomerFaceNbr", Upn);
            DataSet ds = _cfns.SelectCFNRegistrationByUpn(param);
            if (ds.Tables[0].Rows.Count > 0)
            {
                String[] strPath = new String[2];
                strPath[0] = HttpContext.Current.Server.MapPath("\\Upload\\UPN\\Licence\\" + ds.Tables[0].Rows[0]["AttachName"].ToString());
                string CoaFile = AppDomain.CurrentDomain.BaseDirectory.ToString() + "Upload\\UPN\\Licence\\" + ds.Tables[0].Rows[0]["AttachName"].ToString();
                if (File.Exists(CoaFile))
                {
                    String fileName = string.Empty;
                    String NewWaterPdf = string.Empty;
                    AddPdfs(Lot, Property1, out fileName);
                    AddTextWatermark(fileName, out NewWaterPdf);

                    strPath[1] = NewWaterPdf;
                    String fileName1 = Guid.NewGuid().ToString().Replace("-", "").ToUpper() + ".pdf";
                    String OutputPdfPath = HttpContext.Current.Server.MapPath(PdfHelper.COA_FILE_PATH + fileName1);
                    PdfHelper.MergePdf(strPath, OutputPdfPath);
                    //HiddFileName.Text = ds.Tables[0].Rows[0]["AttachName"].ToString();
                    //HiddDowleName.Text = fileName1;
                    res.data = "{\"FileName\":" + ds.Tables[0].Rows[0]["AttachName"].ToString() + ",\"DownPath\":" + fileName1 + "}";
                }
                else
                {
                    res.success = false;
                    res.msg = "该产品型号COA附件不存在";
                }
                //HiddenCoafileUrl.Text = "../Download.aspx?downloadname=" + fileName1 + "&filename=" + ds.Tables[0].Rows[0]["AttachName"].ToString() + "&downtype=COA";
            }
            else
            {
                res.success = false;
                res.msg = "该产型品号没有上传COA附件";
            }
            //return JsonConvert.DeserializeObject(res.ToString());
            return res;
        }
        public static void AddPdfs(string Lot, string Upn, out String fileName)
        {
            //下载COA证件

            fileName = DateTime.Now.ToFileTime().ToString() + ".pdf";
            string targetPath = HttpContext.Current.Server.MapPath(PdfHelper.COA_FILE_PATH + fileName);
            fileName = targetPath;
            Document doc = new Document(iTextSharp.text.PageSize.A4, 36, 36, 12, 12);
            try
            {
                PdfWriter writer = PdfWriter.GetInstance(doc, new FileStream(targetPath, FileMode.Create));
                doc.Open();
                doc.NewPage();

                //设置Title Tabel 
                PdfPTable titleTable = new PdfPTable(1);
                //titleTable.SetWidths(new float[] { 90f});
                PdfHelper.InitPdfTableProperty(titleTable);

                //Pdf标题
                PdfPCell titleCell = new PdfPCell(new Paragraph("ATTACHMENT of CERTIFICATE OF ANALYSIS ", PdfHelper.boldFont));
                //设置标题居中
                titleCell.HorizontalAlignment = Rectangle.ALIGN_CENTER;
                titleCell.VerticalAlignment = Rectangle.ALIGN_BOTTOM;
                titleCell.PaddingBottom = 9f;
                titleCell.FixedHeight = 65.5f;
                titleCell.Border = 0;
                titleTable.AddCell(titleCell);

                //title下划线
                PdfContentByte cb = writer.DirectContent;
                cb.SetLineWidth(0.2f);
                cb.MoveTo(165f, 772.5f);
                cb.LineTo(430f, 772.5f);
                cb.ClosePath();
                cb.Stroke();

                //添加至pdf中
                PdfHelper.AddPdfTable(doc, titleTable);

                //副标题
                #region
                Phrase phrase2 = new Phrase();
                phrase2.Add(new Chunk("The products listed below have been manufactured to the good manufacturing rules of this company, and that they have been successfully released by the Quality Control Department.", PdfHelper.boldFont));
                phrase2.Add(Chunk.NEWLINE);
                Paragraph paragraph2 = new Paragraph();
                phrase2.Add(Chunk.NEWLINE);
                paragraph2.Add(phrase2);
                paragraph2.Alignment = Rectangle.ALIGN_JUSTIFIED;
                paragraph2.IndentationLeft = 5;
                paragraph2.KeepTogether = true;
                paragraph2.Leading = 15f;
                doc.Add(paragraph2);
                #endregion

                //生成表格
                PdfPTable supportDocTable = new PdfPTable(1);
                PdfHelper.AddPdfCell("", PdfHelper.normalFont, supportDocTable, Rectangle.ALIGN_LEFT);
                PdfHelper.AddPdfTable(doc, supportDocTable);
                PdfHelper.InitPdfTableProperty(supportDocTable);
                PdfPTable standardTermGridTable = new PdfPTable(4);
                standardTermGridTable.SetWidths(new float[] { 1f, 16f, 9f, 25f });
                PdfHelper.InitPdfTableProperty(standardTermGridTable);

                //表头
                PdfHelper.AddEmptyPdfCell(standardTermGridTable);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("UPN/Model Number", PdfHelper.boldFont)) { FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT, Colspan = 2, BackgroundColor = BaseColor.GRAY }, standardTermGridTable, Rectangle.ALIGN_CENTER, Rectangle.ALIGN_CENTER, true, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Lot/Batch Number", PdfHelper.boldFont)) { FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT, Colspan = 1, BackgroundColor = BaseColor.GRAY }, standardTermGridTable, Rectangle.ALIGN_CENTER, Rectangle.ALIGN_CENTER, true, true, true, true);
                PdfHelper.AddEmptyPdfCell(standardTermGridTable);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(Upn, PdfHelper.normalFont)) { FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT, Colspan = 2 }, standardTermGridTable, Rectangle.ALIGN_CENTER, Rectangle.ALIGN_CENTER, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(Lot, PdfHelper.normalFont)) { FixedHeight = PdfHelper.NORMAL_FIXED_HEIGHT, Colspan = 1 }, standardTermGridTable, Rectangle.ALIGN_CENTER, Rectangle.ALIGN_CENTER, false, true, true, true);
                PdfHelper.AddPdfTable(doc, standardTermGridTable);

            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
            finally
            {
                doc.Close();

            }
        }
        public static void AddTextWatermark(string Filename, out string OutputPdfPath)
        {
            String newfileName = Guid.NewGuid().ToString().Replace("-", "").ToUpper() + ".pdf";
            OutputPdfPath = HttpContext.Current.Server.MapPath(PdfHelper.COA_FILE_PATH + newfileName);
            PDFTextWatermark(Filename, OutputPdfPath, "仅供代理商或使用单位验收备案/招标，解释权归蓝威所有", 0, 0);
        }
        public static bool PDFTextWatermark(string inputfilepath, string outputfilepath, string waterMarkText, float top, float left)
        {
            //注册中文字库
            PdfHelper.RegisterChineseFont();

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

                //微软雅黑  
                BaseFont bfChinese = PdfHelper.baseFont;
                PdfGState gs = new PdfGState();
                gs.FillOpacity = 0.2f;//透明度

                int j = waterMarkText.Length;
                char c;
                int rise = 0;
                for (int i = 1; i <= numberOfPages; i++)
                {
                    waterMarkContent = pdfStamper.GetOverContent(i);//在内容上方加水印
                    //content = pdfStamper.GetUnderContent(i);//在内容下方加水印
                    //透明度
                    gs.FillOpacity = 0.3f;
                    waterMarkContent.SetGState(gs);

                    //开始写入文本
                    waterMarkContent.BeginText();
                    waterMarkContent.SetColorFill(BaseColor.LIGHT_GRAY);
                    waterMarkContent.SetFontAndSize(bfChinese, 25);
                    waterMarkContent.SetTextMatrix(0, 0);
                    waterMarkContent.ShowTextAligned(Element.ALIGN_CENTER, waterMarkText, width / 2 - 50, height / 2 - 50, 55);

                    waterMarkContent.EndText();
                }

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
        #endregion 

    }
    public class ResultAjax
    {
        public bool success { get; set; }
        public string data { get; set; }
        public string msg { get; set; }
    }
}