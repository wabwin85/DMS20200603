using DMS.Business;
using DMS.Business.Contract;
using DMS.Common;
using DMS.Website.Common;
using iTextSharp.text;
using iTextSharp.text.pdf;
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

namespace DMS.Website.Revolution.Pages.Contract
{
    public partial class ContractThirdPartyV2 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        #region Create IAF_ThirdParty File
        [WebMethod]
        public static string CreatePdf(string dealerID, string dealerName)
        {
            bool flag = true;
            string msg = "";
            IDealerMasters dealerMasters = new DealerMasters();
            IThirdPartyDisclosureService thirdPartyDisclosure = new ThirdPartyDisclosureService();
            Hashtable objsign = new Hashtable();
            objsign.Add("DealerId", dealerID);
            DataTable sign = dealerMasters.GetThirdPartSignature(objsign).Tables[0];

            string fileName = DateTime.Now.ToFileTime().ToString() + ".pdf";
            string targetPath = System.Web.HttpContext.Current.Server.MapPath(PdfHelper.FILE_PATH + fileName);

            Document doc = new Document(iTextSharp.text.PageSize.A4, 36, 36, 12, 12);
            try
            {
                //注册中文字库
                PdfHelper.RegisterChineseFont();
                PdfHelper pdfFont = new PdfHelper();

                //DataSet ds = _trainingSignIn.GetTrainingSignInByContId(new Guid(this.hdCmId.Value.ToString()));

                PdfWriter writer = PdfWriter.GetInstance(doc, new FileStream(targetPath, FileMode.Create));
                //设置脚注，页码
                PdfPageEvent pdfPage = new PdfPageEvent("Third party disclosure");
                writer.PageEvent = pdfPage;

                doc.Open();

                #region Pdf Title

                //设置Title Tabel 
                PdfPTable titleTable = new PdfPTable(3);
                titleTable.SetWidths(new float[] { 25f, 50f, 25f });
                PdfHelper.InitPdfTableProperty(titleTable);

                titleTable.AddCell(PdfHelper.GetIAFBscLogoImageCell());

                //Pdf标题
                PdfPCell titleCell = new PdfPCell(new Paragraph("经销商第三方公司披露表", pdfFont.normalBoldChineseFont14));
                titleCell.HorizontalAlignment = Rectangle.ALIGN_CENTER;
                titleCell.VerticalAlignment = Rectangle.ALIGN_BOTTOM;
                titleCell.PaddingBottom = 9f;
                titleCell.FixedHeight = 65.5f;
                titleCell.Border = 0;
                titleTable.AddCell(titleCell);

                PdfHelper.AddEmptyPdfCell(titleTable);

                //添加至pdf中
                PdfHelper.AddPdfTable(doc, titleTable);

                #endregion

                //#region 副标题
                //PdfPTable labelTable = new PdfPTable(1);
                //PdfHelper.InitPdfTableProperty(labelTable);

                //PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Transacting Business with Integrity Training", PdfHelper.iafTitleFont)) { FixedHeight = 50f, BackgroundColor = PdfHelper.remarkBgColor, PaddingTop = 10f }, labelTable, null, null);

                //PdfHelper.AddPdfTable(doc, labelTable);

                //#endregion

                #region 第三方信息
                PdfPTable thirdParyTable = new PdfPTable(2);
                thirdParyTable.SetWidths(new float[] { 30f, 70f });
                PdfHelper.InitPdfTableProperty(thirdParyTable);
                AddHeadTable(doc, 1, "公司信息", "");
                //PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("1.	     贵公司信息", pdfFont.normalChineseFont)) { FixedHeight = PdfHelper.YOUNG_FIXED_HEIGHT, Colspan = 2, BackgroundColor = PdfHelper.remarkBgColor }
                //       , thirdParyTable, Rectangle.ALIGN_LEFT, null, true, true, true, true);
                //Third Party Name
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("公司名称（本表简称“公司”）: ", pdfFont.normalChineseFont)) { FixedHeight = 20f, Colspan = 2 }
                      , thirdParyTable, Rectangle.ALIGN_LEFT, null, true, true, false, true);

                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(dealerName, pdfFont.normalChineseFont)) { Colspan = 2 }
                      , thirdParyTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);


                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph(" ")) { Colspan = 4, FixedHeight = 10f }, thirdParyTable, null, null);


                PdfHelper.AddPdfTable(doc, thirdParyTable);
                #endregion

                #region Third Party User
                Hashtable obj = new Hashtable();
                obj.Add("DmaId", dealerID);
                DataSet ds = thirdPartyDisclosure.ThirdPartylist(obj);

                PdfPTable bodyTable = new PdfPTable(3);
                bodyTable.SetWidths(new float[] { 40f, 30f, 30f });
                PdfHelper.InitPdfTableProperty(bodyTable);

                AddHeadTable(doc, 2, "第三方公司披露", "若贵公司通过其它第三方公司向医院进行开票和销售，请列出第三方公司的名称、涉及医院及关系描述。若贵公司直接向医院进行开票和销售，请在此填“无”");

                //Head
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Phrase("医院", pdfFont.normalChineseFont)) { BackgroundColor = PdfHelper.grayColor, BorderColor = PdfHelper.blueColor, BorderColorRight = BaseColor.BLACK, BorderWidthLeft = 1f, BorderWidthTop = 1f, BorderWidthRight = 0f, BorderWidthBottom = 0f }
                    , bodyTable, null, null);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Phrase("第三方公司", pdfFont.normalChineseFont)) { BackgroundColor = PdfHelper.grayColor, BorderColor = PdfHelper.blueColor, BorderColorLeft = BaseColor.BLACK, BorderWidthLeft = 0.6f, BorderWidthTop = 1f, BorderWidthRight = 0f, BorderWidthBottom = 0f }
                    , bodyTable, null, null);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Phrase("与贵司或医院关系", pdfFont.normalChineseFont)) { BackgroundColor = PdfHelper.grayColor, BorderColor = PdfHelper.blueColor, BorderColorLeft = BaseColor.BLACK, BorderWidthTop = 1f, BorderWidthRight = 1f, BorderWidthLeft = 0.6f, BorderWidthBottom = 0f }
                    , bodyTable, null, null);
                //PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Phrase("第三方公司2", pdfFont.normalChineseFont)) { BackgroundColor = PdfHelper.grayColor, BorderColor = PdfHelper.blueColor, BorderColorLeft = BaseColor.BLACK, BorderWidthLeft = 0f, BorderWidthTop = 1f, BorderWidthRight = 0f, BorderWidthBottom = 0f }
                //  , bodyTable, null, null);
                //PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Phrase("与贵司或医院关系2", pdfFont.normalChineseFont)) { BackgroundColor = PdfHelper.grayColor, BorderColor = PdfHelper.blueColor, BorderColorLeft = BaseColor.BLACK, BorderWidthTop = 1f, BorderWidthRight = 1f, BorderWidthLeft = 0.6f, BorderWidthBottom = 0f }
                //    , bodyTable, null, null);

                PdfHelper.AddPdfCellHasBorderTopLeft(new PdfPCell(new Phrase("  1.  " + GetStringByDataRow(ds, 1, "HospitalName"), pdfFont.normalChineseFont)) { FixedHeight = 20f }, bodyTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false);
                PdfHelper.AddPdfCellHasBorderTop(new PdfPCell(new Phrase(GetStringByDataRow(ds, 1, "CompanyName").Equals("") ? "N/A" : GetStringByDataRow(ds, 1, "CompanyName"), pdfFont.normalChineseFont)) { BorderColor = BaseColor.BLACK, BorderColorTop = PdfHelper.blueColor, BorderWidth = 0.3f, BorderWidthTop = 1.5f }, bodyTable, Rectangle.ALIGN_LEFT, null, false);
                PdfHelper.AddPdfCellHasBorderTopRight(new PdfPCell(new Phrase(GetStringByDataRow(ds, 1, "Rsm").Equals("") ? "N/A" : GetStringByDataRow(ds, 1, "Rsm"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                //PdfHelper.AddPdfCellHasBorderTop(new PdfPCell(new Phrase(this.GetStringByDataRow(ds, 1, "CompanyName2").Equals("") ? "N/A" : this.GetStringByDataRow(ds, 1, "CompanyName2"), pdfFont.normalChineseFont)) { BorderColor = BaseColor.BLACK, BorderColorTop = PdfHelper.blueColor, BorderWidth = 0.3f, BorderWidthTop = 1.5f }, bodyTable, Rectangle.ALIGN_LEFT, null, false);
                //PdfHelper.AddPdfCellHasBorderTopRight(new PdfPCell(new Phrase(this.GetStringByDataRow(ds, 1, "Rsm2").Equals("") ? "N/A" : this.GetStringByDataRow(ds, 1, "Rsm2"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                if (ds.Tables[0] != null && ds.Tables[0].Rows.Count > 20)
                {
                    for (int i = 2; i <= ds.Tables[0].Rows.Count - 1; i++)
                    {
                        PdfHelper.AddPdfCellHasBorderLeft(new PdfPCell(new Phrase("  " + i + ".  " + GetStringByDataRow(ds, i, "HospitalName"), pdfFont.normalChineseFont)) { FixedHeight = 20f }, bodyTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false);
                        if (GetStringByDataRow(ds, i, "HospitalName").Equals(""))
                        {
                            PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Phrase(GetStringByDataRow(ds, i, "CompanyName"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                            PdfHelper.AddPdfCellHasBorderRight(new PdfPCell(new Phrase(GetStringByDataRow(ds, i, "Rsm"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                            //PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Phrase(this.GetStringByDataRow(ds, i, "CompanyName2"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                            //PdfHelper.AddPdfCellHasBorderRight(new PdfPCell(new Phrase(this.GetStringByDataRow(ds, i, "Rsm2"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                        }
                        else
                        {
                            PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Phrase(GetStringByDataRow(ds, i, "CompanyName").Equals("") ? "N/A" : GetStringByDataRow(ds, i, "CompanyName"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                            PdfHelper.AddPdfCellHasBorderRight(new PdfPCell(new Phrase(GetStringByDataRow(ds, i, "Rsm").Equals("") ? "N/A" : GetStringByDataRow(ds, i, "Rsm"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                            //PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Phrase(this.GetStringByDataRow(ds, i, "CompanyName2").Equals("") ? "N/A" : this.GetStringByDataRow(ds, i, "CompanyName2"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                            //PdfHelper.AddPdfCellHasBorderRight(new PdfPCell(new Phrase(this.GetStringByDataRow(ds, i, "Rsm2").Equals("") ? "N/A" : this.GetStringByDataRow(ds, i, "Rsm2"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                        }
                    }
                    PdfHelper.AddPdfCellHasBorderBottomLeft(new PdfPCell(new Phrase(" " + ds.Tables[0].Rows.Count.ToString() + ".  " + GetStringByDataRow(ds, ds.Tables[0].Rows.Count, "HospitalName"), pdfFont.normalChineseFont)) { FixedHeight = 20f }, bodyTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false);
                    PdfHelper.AddPdfCellHasBorderBottom(new PdfPCell(new Phrase(GetStringByDataRow(ds, ds.Tables[0].Rows.Count, "CompanyName").Equals("") ? "N/A" : GetStringByDataRow(ds, ds.Tables[0].Rows.Count, "CompanyName"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                    PdfHelper.AddPdfCellHasBorderBottomRight(new PdfPCell(new Phrase(GetStringByDataRow(ds, ds.Tables[0].Rows.Count, "Rsm").Equals("") ? "N/A" : GetStringByDataRow(ds, ds.Tables[0].Rows.Count, "Rsm"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                    //PdfHelper.AddPdfCellHasBorderBottom(new PdfPCell(new Phrase(this.GetStringByDataRow(ds, ds.Tables[0].Rows.Count, "CompanyName2").Equals("") ? "N/A" : this.GetStringByDataRow(ds, ds.Tables[0].Rows.Count, "CompanyName"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                    //PdfHelper.AddPdfCellHasBorderBottomRight(new PdfPCell(new Phrase(this.GetStringByDataRow(ds, ds.Tables[0].Rows.Count, "Rsm2").Equals("") ? "N/A" : this.GetStringByDataRow(ds, ds.Tables[0].Rows.Count, "Rsm"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                }
                else
                {
                    for (int i = 2; i < 20; i++)
                    {
                        PdfHelper.AddPdfCellHasBorderLeft(new PdfPCell(new Phrase("  " + i + ".  " + GetStringByDataRow(ds, i, "HospitalName"), pdfFont.normalChineseFont)) { FixedHeight = 20f }, bodyTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false);
                        if (GetStringByDataRow(ds, i, "HospitalName").Equals(""))
                        {
                            PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Phrase(GetStringByDataRow(ds, i, "CompanyName"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                            PdfHelper.AddPdfCellHasBorderRight(new PdfPCell(new Phrase(GetStringByDataRow(ds, i, "Rsm"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                            //PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Phrase(this.GetStringByDataRow(ds, i, "CompanyName2"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                            //PdfHelper.AddPdfCellHasBorderRight(new PdfPCell(new Phrase(this.GetStringByDataRow(ds, i, "Rsm2"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                        }
                        else
                        {
                            PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Phrase(GetStringByDataRow(ds, i, "CompanyName").Equals("") ? "N/A" : GetStringByDataRow(ds, i, "CompanyName"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                            PdfHelper.AddPdfCellHasBorderRight(new PdfPCell(new Phrase(GetStringByDataRow(ds, i, "Rsm").Equals("") ? "N/A" : GetStringByDataRow(ds, i, "Rsm"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                            //PdfHelper.AddPdfCellHasBorderCenter(new PdfPCell(new Phrase(this.GetStringByDataRow(ds, i, "CompanyName2").Equals("") ? "N/A" : this.GetStringByDataRow(ds, i, "CompanyName2"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                            //PdfHelper.AddPdfCellHasBorderRight(new PdfPCell(new Phrase(this.GetStringByDataRow(ds, i, "Rsm2").Equals("") ? "N/A" : this.GetStringByDataRow(ds, i, "Rsm2"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                        }
                    }
                    PdfHelper.AddPdfCellHasBorderBottomLeft(new PdfPCell(new Phrase("  20.  " + GetStringByDataRow(ds, 20, "HospitalName"), pdfFont.normalChineseFont)) { FixedHeight = 20f }, bodyTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP, false);
                    if (GetStringByDataRow(ds, 20, "HospitalName").Equals(""))
                    {
                        PdfHelper.AddPdfCellHasBorderBottom(new PdfPCell(new Phrase(GetStringByDataRow(ds, 20, "CompanyName"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                        PdfHelper.AddPdfCellHasBorderBottomRight(new PdfPCell(new Phrase(GetStringByDataRow(ds, 20, "Rsm"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                        //PdfHelper.AddPdfCellHasBorderBottom(new PdfPCell(new Phrase(this.GetStringByDataRow(ds, 20, "CompanyName2"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                        //PdfHelper.AddPdfCellHasBorderBottomRight(new PdfPCell(new Phrase(this.GetStringByDataRow(ds, 20, "Rsm2"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                    }
                    else
                    {
                        PdfHelper.AddPdfCellHasBorderBottom(new PdfPCell(new Phrase(GetStringByDataRow(ds, 20, "CompanyName").Equals("") ? "N/A" : GetStringByDataRow(ds, 20, "CompanyName"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                        PdfHelper.AddPdfCellHasBorderBottomRight(new PdfPCell(new Phrase(GetStringByDataRow(ds, 20, "Rsm").Equals("") ? "N/A" : GetStringByDataRow(ds, 20, "Rsm"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                        PdfHelper.AddPdfCellHasBorderBottom(new PdfPCell(new Phrase(GetStringByDataRow(ds, 20, "CompanyName2").Equals("") ? "N/A" : GetStringByDataRow(ds, 20, "CompanyName"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                        PdfHelper.AddPdfCellHasBorderBottomRight(new PdfPCell(new Phrase(GetStringByDataRow(ds, 20, "Rsm2").Equals("") ? "N/A" : GetStringByDataRow(ds, 20, "Rsm"), pdfFont.normalChineseFont)), bodyTable, Rectangle.ALIGN_LEFT, null, false);
                    }
                }
                bodyTable.AddCell(new PdfPCell(new Paragraph("")) { FixedHeight = 10f, Border = 0, Colspan = 5 });
                PdfHelper.AddPdfTable(doc, bodyTable);
                #endregion

                #region Remark
                PdfPTable cbTable = new PdfPTable(4);
                cbTable.SetWidths(new float[] { 5f, 30f, 35f, 10f });
                PdfHelper.InitPdfTableProperty(cbTable);
                Chunk descChunk = new Chunk("兹通知，在贵司披露第三方公司时，蓝威或其代理公司可能会购买尽职调查验证报告及/或调查性的尽职调查报告，以获取有关各种事项的信息，包括但不限于公司结构、所有权、商务实践、银行记录、资信状况、破产程序、犯罪记录、民事记录、一般声誉及个人品质（包括前述任何项目，以及个人的教育程度、从业历史等），并有权根据报告结果拒绝与该第三方公司合作。若贵司未主动披露第三方公司，蓝威或其代理公司发现后，蓝威或其代理公司保留扣减贵司返利，直至解除合同取消授权等措施的权利。", pdfFont.normalChineseFont);

                Phrase notePhrase = new Phrase();
                notePhrase.Add(descChunk);

                Paragraph noteParagraph = new Paragraph();
                noteParagraph.Add(notePhrase);

                PdfHelper.AddPdfCell(new PdfPCell(noteParagraph) { Colspan = 4, BackgroundColor = PdfHelper.grayColor }, cbTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP);

                PdfHelper.AddPdfCell(new PdfPCell() { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 4 }, cbTable, null, null);

                PdfHelper.AddPdfTable(doc, cbTable);
                #endregion



                //return fileName;
            }
            catch (Exception ex)
            {
                flag = false;
                msg = "发生错误！" + ex.Message;
            }
            finally
            {
                doc.Close();
            }
            var result = new
            {
                IsSuccess = flag,
                downName = "ThirdPartyDisclosure.pdf",
                fileName = fileName,
                ExecuteMessage = msg
            };
            return JsonHelper.Serialize(result);

        }

        private static void AddHeadTable(Document doc, int number, string headText, string subHeadText)
        {
            PdfHelper pdfFont = new PdfHelper();
            PdfPTable headTable = new PdfPTable(2);
            headTable.SetWidths(new float[] { 5f, 95f });
            PdfHelper.InitPdfTableProperty(headTable);

            Chunk numberChunk = new Chunk(number.ToString() + ".     ", PdfHelper.italicFont);
            Chunk headChunk = new Chunk(headText, pdfFont.normalChineseFontB);

            Phrase headPhrase = new Phrase();
            headPhrase.Add(headChunk);

            if (!string.IsNullOrEmpty(subHeadText))
            {
                Chunk subHeadChunk = new Chunk("\r\n" + subHeadText, pdfFont.normalChineseFont);
                headPhrase.Add(subHeadChunk);
            }

            Phrase nbrPhrase = new Phrase();
            nbrPhrase.Add(numberChunk);

            Paragraph headParagraph = new Paragraph();
            headParagraph.Add(headPhrase);

            Paragraph nbrParagraph = new Paragraph();
            nbrParagraph.Add(nbrPhrase);

            PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(nbrParagraph) { BackgroundColor = PdfHelper.remarkBgColor }
                        , headTable, Rectangle.ALIGN_LEFT, null, true, false, false, true);
            PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(headParagraph) { BackgroundColor = PdfHelper.remarkBgColor }
                        , headTable, Rectangle.ALIGN_LEFT, null, true, true, false, false);

            doc.Add(headTable);
        }

        private static string GetStringByDataRow(DataSet ds, int rowNumber, string column)
        {
            string resultStr = string.Empty;
            if (ds.Tables != null && ds.Tables.Count > 0)
            {
                if (rowNumber <= ds.Tables[0].Rows.Count)
                {
                    if (ds.Tables[0].Rows[rowNumber - 1][column] != null)
                    {
                        resultStr = ds.Tables[0].Rows[rowNumber - 1][column].ToString();
                    }
                }
            }

            return resultStr;
        }
        
        #endregion
    }
}