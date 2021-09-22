using DMS.Business.Contract;
using DMS.Website.Common;
using iTextSharp.text;
using iTextSharp.text.pdf;
using NPOI.HSSF.UserModel;
using NPOI.SS.UserModel;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ThoughtWorks.QRCode.Codec;

namespace DMS.Website.Pages.Contract
{
    public partial class Equipment : BasePage
    {
        //private static HSSFWorkbook hssfworkbook;
        private ITenderAuthorizationList _businessReport = new TenderAuthorizationListBLL();
        protected void Page_Load(object sender, EventArgs e)
        {
            CreatePdfUpdate();
        }

        //private void PrintDealerAuthorization()
        //{
        //    string id = Request.QueryString["ID"].ToString();

        //    if (dt.Rows.Count > 0)
        //    {
        //        string AuthorizationNo = dt.Rows[0]["DTM_NO"].ToString();
        //        string DealerName = dt.Rows[0]["DTM_DealerName"].ToString();
        //        DateTime BeginDate = Convert.ToDateTime(dt.Rows[0]["DTM_BeginDate"].ToString());
        //        DateTime EndDate = Convert.ToDateTime(dt.Rows[0]["DTM_EndDate"].ToString());
        //        string ProductLineName = dt.Rows[0]["ProductLineName"].ToString();

        //        GetDealerAuthorizationProduct(AuthorizationNo, DealerName, BeginDate, EndDate, ProductLineName);
        //    }

        //    Response.ContentType = "application/vnd.ms-excel";
        //    Response.AddHeader("Content-Disposition", string.Format("attachment;filename={0}", "DealerAuthorization.xls"));
        //    Response.Clear();
        //    GetExcelStream().WriteTo(Response.OutputStream);
        //    Response.Flush();
        //    Response.End();
        //}
        //private void GetDealerAuthorizationProduct(string AuthorizationNo, string DealerName, DateTime BeginDate, DateTime EndDate, string ProductLineName)
        //{
        //    string templateName = "";
        //    string id = Request.QueryString["ID"].ToString();
        //    templateName = Server.MapPath("\\Upload\\ExcelTemplate\\Template_DeviceAuthorization.xls");
        //    FileStream file = new FileStream(templateName, FileMode.Open, FileAccess.Read);
        //    hssfworkbook = new HSSFWorkbook(file);
        //    string endtime = "";
        //    endtime = "本授权书授权期限为 " + BeginDate.Year.ToString() + " 年 " + BeginDate.Month.ToString() + " 月 " + BeginDate.Day.ToString() + " 日 ";
        //    endtime += "至 " + EndDate.Year.ToString() + " 年 " + EndDate.Month.ToString() + " 月 " + EndDate.Day.ToString() + " 日。";
        //    ISheet dataSheet = hssfworkbook.GetSheetAt(0);
        //    dataSheet.GetRow(2).GetCell(1).SetCellValue("【编号：" + AuthorizationNo.ToString() + "】");
        //    dataSheet.GetRow(18).GetCell(1).SetCellValue(DateTime.Now.Year.ToString() + "年 " + DateTime.Now.Month.ToString() + "月 " + DateTime.Now.Day + "日 ");
        //    dataSheet.GetRow(8).GetCell(1).SetCellValue("    本公司 蓝威医疗科技(上海)有限公司 为提高产品配送效率，向医疗机构提供更为优质高效的服务, 特授权 " + DealerName.ToString() + "为本公司在 （授权区域详见下述清单） 的配送企业，负责承担在授权时限内对我司" + ProductLineName.ToString() + " （授权产品如下清单） 的配送和结算工作。 " + DealerName.ToString() + " 将保证及时供货并提供全面、完善的服务。");
        //    dataSheet.GetRow(17).GetCell(1).SetCellValue("蓝威医疗科技(上海)有限公司");
        //    dataSheet.GetRow(15).GetCell(1).SetCellValue(endtime.ToString());
        //    DataTable list = _businessReport.GetAuthorization(new Guid(id)).Tables[0];
        //    if (list.Rows.Count > 1)
        //    {
        //        InsertExcelHospitalRows(dataSheet, list.Rows.Count - 1);
        //    }
        //    int rowNub = 9;
        //    for (int i = 0; i < list.Rows.Count; i++)
        //    {
        //        int a = i + 1;
        //        rowNub = rowNub + 1;
        //        string stringHospital = a.ToString() + ". " + list.Rows[i]["HOS_HospitalName"].ToString();

        //        if (!list.Rows[i]["DTH_HospitalDept"].ToString().Equals(""))
        //        {
        //            stringHospital += (" (" + list.Rows[i]["DTH_HospitalDept"].ToString() + ")");
        //        }
        //        stringHospital += (":" + list.Rows[i]["ProductName"].ToString());

        //        dataSheet.GetRow(rowNub).GetCell(1).SetCellValue(stringHospital.ToString());
        //    }
        //    QRCodeEncoder qrCodeEncoder = new QRCodeEncoder();
        //    qrCodeEncoder.QRCodeEncodeMode = QRCodeEncoder.ENCODE_MODE.BYTE;
        //    qrCodeEncoder.QRCodeScale = 3;
        //    qrCodeEncoder.QRCodeVersion = 0;
        //    qrCodeEncoder.QRCodeErrorCorrect = QRCodeEncoder.ERROR_CORRECTION.L;
        //    System.Drawing.Image image = qrCodeEncoder.Encode(new Guid(id).ToString());
        //    string filepath = Page.Server.MapPath(@"..\..\") + @"Upload\QR\" + Guid.NewGuid().ToString() + ".png";
        //    System.IO.FileStream fs = new System.IO.FileStream(filepath, System.IO.FileMode.OpenOrCreate, System.IO.FileAccess.Write);
        //    image.Save(fs, System.Drawing.Imaging.ImageFormat.Jpeg);
        //    fs.Close();
        //    image.Dispose();
        //    FileStream fs2 = new FileStream(filepath, FileMode.Open, FileAccess.Read);
        //    byte[] Content = new byte[Convert.ToInt32(fs2.Length)];
        //    fs2.Read(Content, 0, Convert.ToInt32(fs2.Length));
        //    int pictureIdx = hssfworkbook.AddPicture(Content, NPOI.SS.UserModel.PictureType.JPEG);
        //    HSSFPatriarch patriarch = (HSSFPatriarch)dataSheet.CreateDrawingPatriarch();
        //    HSSFClientAnchor anchor = new HSSFClientAnchor(0, 0, 0, 0, 14, 1, 17, 5);
        //    HSSFPicture pict = (HSSFPicture)patriarch.CreatePicture(anchor, pictureIdx);
        //    fs2.Close();
        //}


        //private MemoryStream GetExcelStream()
        //{
        //    MemoryStream file = new MemoryStream();
        //    hssfworkbook.Write(file);
        //    return file;
        //}


        //private void InsertExcelHospitalRows(ISheet dataSheet, int rowCount)
        //{
        //    // '将fromRowIndex行以后的所有行向下移动rowCount行，保留行高和格式
        //    dataSheet.ShiftRows(11, dataSheet.LastRowNum, rowCount, true, false);

        //    // '取得源格式行
        //    IRow rowSource = dataSheet.GetRow(10);
        //    ICellStyle rowstyle = rowSource.RowStyle;

        //    for (int rowIndex = 11; rowIndex < 11 + rowCount; rowIndex++)
        //    {
        //        // '新建插入行
        //        IRow rowInsert = dataSheet.CreateRow(rowIndex);
        //        //rowInsert.RowStyle = rowstyle;
        //        rowInsert.Height = rowSource.Height;
        //        for (int colIndex = 0; colIndex < rowSource.LastCellNum; colIndex++)
        //        {
        //            //'新建插入行的所有单元格，并复制源格式行相应单元格的格式
        //            ICell cellSource = rowSource.GetCell(colIndex);
        //            ICell cellInsert = rowInsert.CreateCell(colIndex);
        //            //cellInsert.CellStyle = cellSource.CellStyle;
        //        }
        //    }
        //}






        protected void CreatePdf()
        {

            string id = Request.QueryString["DtmId"].ToString();
            string mainid = Request.QueryString["MainId"].ToString();
            DataTable dt = _businessReport.GetAuthorizationList(new Guid(id)).Tables[0];


            //生成二维码图片
            if (dt.Rows.Count > 0)
            {
                string DTM_NO = dt.Rows[0]["DTM_NO"].ToString();
                string dealername = dt.Rows[0]["DTM_DealerName"].ToString();
                string begindate = dt.Rows[0]["DTM_BeginDate"].ToString();
                string enddate = dt.Rows[0]["DTM_EndDate"].ToString();
                string hospitalname = dt.Rows[0]["HOS_HospitalName"].ToString();




                QRCodeEncoder qrCodeEncoder = new QRCodeEncoder();
                System.Drawing.Image image = qrCodeEncoder.Encode(new Guid(id).ToString());
                string filepath = Page.Server.MapPath(@"..\..\") + @"Upload\QR\" + Guid.NewGuid().ToString() + ".png";
                System.IO.FileStream fs = new System.IO.FileStream(filepath, System.IO.FileMode.OpenOrCreate, System.IO.FileAccess.Write);
                image.Save(fs, System.Drawing.Imaging.ImageFormat.Jpeg);
                fs.Close();
                image.Dispose();
                iTextSharp.text.Image op = iTextSharp.text.Image.GetInstance(filepath);
                op.ScaleAbsolute(100.8f, 100.8f);//图片缩放
                PdfPCell cellImage = new PdfPCell(op);
                cellImage.Border = 0;
                cellImage.PaddingBottom = 5f;
                cellImage.PaddingRight = 5f;
                cellImage.HorizontalAlignment = Rectangle.ALIGN_RIGHT;
                cellImage.VerticalAlignment = Rectangle.ALIGN_BOTTOM;


                string fileName = DateTime.Now.ToFileTime().ToString() + ".pdf";
                string targetPath = Server.MapPath(PdfHelper.FILE_PATH + fileName);
                Document doc = new Document(iTextSharp.text.PageSize.A4, 36, 36, 12, 50);

                PdfHelper.RegisterChineseFont();
                PdfHelper pdfFont = new PdfHelper();
                //DataTable list = _businessReport.GetAuthorization(new Guid(id)).Tables[0];

                PdfWriter writer = PdfWriter.GetInstance(doc, new FileStream(targetPath, FileMode.Create));
                doc.Open();

                PdfPTable titleTable = new PdfPTable(3);
                titleTable.SetWidths(new float[] { 8f, 8f, 8f });
                PdfHelper.InitPdfTableProperty(titleTable);
                //标题
                PdfHelper.AddEmptyPdfCell(titleTable);
                PdfPCell titleCell = new PdfPCell(new Paragraph("制造厂家的授权书", pdfFont.bigtitlechinesefont2));
                titleCell.HorizontalAlignment = Rectangle.ALIGN_MIDDLE;
                titleCell.VerticalAlignment = Rectangle.ALIGN_BOTTOM;
                titleCell.PaddingBottom = 10f;
                titleCell.FixedHeight = 65.5f;
                titleCell.Border = 0;
                titleTable.AddCell(titleCell);
                titleTable.AddCell(cellImage);
                PdfHelper.AddPdfTable(doc, titleTable);

                if (hospitalname.Length <= 12)
                {
                    PdfPTable recTable = new PdfPTable(3);
                    recTable.SetWidths(new float[] { 1.3f, 5f, 8f });
                    PdfHelper.InitPdfTableProperty(recTable);
                    //致言

                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("致:", pdfFont.bigchinesefont)) { FixedHeight = 25f }, recTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                    //PdfHelper.AddPdfCellWithUnderLine(list.Rows[0]["HOS_HospitalName"].ToString(), pdfFont.answerChineseFont, recTable, null);

                    PdfHelper.AddPdfCellWithUnderLine(new PdfPCell(new Paragraph(hospitalname, pdfFont.bigchinesefontLine)), recTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE);

                    PdfHelper.AddEmptyPdfCell(recTable);
                    PdfHelper.AddPdfTable(doc, recTable);
                }
                else if (hospitalname.Length > 12)
                {
                    PdfPTable recTable = new PdfPTable(3);
                    recTable.SetWidths(new float[] { 1.3f, 13f, 5f });
                    PdfHelper.InitPdfTableProperty(recTable);
                    //致言
                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("致:", pdfFont.bigchinesefont)) { FixedHeight = 25f }, recTable, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddPdfCellWithUnderLine(new PdfPCell(new Paragraph(hospitalname, pdfFont.bigchinesefontLine)), recTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE);
                    PdfHelper.AddEmptyPdfCell(recTable);
                    PdfHelper.AddPdfTable(doc, recTable);
                }


                //正文 法律成立
                PdfPTable rows1 = new PdfPTable(6);
                rows1.SetWidths(new float[] { 1f, 3f, 12f, 2f, 3f, 3f });
                PdfHelper.InitPdfTableProperty(rows1);
                PdfHelper.AddEmptyPdfCell(rows1);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("我们", pdfFont.bigchinesefont)) { FixedHeight = 25f }, rows1, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellWithUnderLine(new PdfPCell(new Paragraph("（Boston Scientific Corperation）", pdfFont.bigchinesefontLine)), rows1, Rectangle.ALIGN_CENTER, Rectangle.ALIGN_MIDDLE);
                PdfHelper.AddPdfCell("是按", pdfFont.bigchinesefont, rows1, Rectangle.ALIGN_LEFT);
                PdfHelper.AddPdfCellWithUnderLine(new PdfPCell(new Paragraph("（美国）", pdfFont.bigchinesefontLine)), rows1, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCell("法律成立", pdfFont.bigchinesefont, rows1, Rectangle.ALIGN_LEFT);

                PdfHelper.AddPdfTable(doc, rows1);


                PdfPTable rows2 = new PdfPTable(3);
                rows2.SetWidths(new float[] { 1f, 11f, 14f });
                PdfHelper.InitPdfTableProperty(rows2);
                PdfHelper.AddEmptyPdfCell(rows2);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("的一家制造商，主要营业地点设在", pdfFont.bigchinesefont)) { FixedHeight = 25f }, rows2, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellWithUnderLine(new PdfPCell(new Paragraph("（One Boston Scientific Place,Natick,", pdfFont.bigchinesefontLine)), rows2, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfTable(doc, rows2);


                PdfPTable rows3 = new PdfPTable(6);
                rows3.SetWidths(new float[] { 1f, 6.5f, 4f, 3f, 6f, 4f });
                PdfHelper.InitPdfTableProperty(rows3);
                PdfHelper.AddEmptyPdfCell(rows3);
                PdfHelper.AddPdfCellWithUnderLine(new PdfPCell(new Paragraph("MA01760, USA）", pdfFont.bigchinesefontLine)) { FixedHeight = 25f }, rows3, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCell("。兹指派按", pdfFont.bigchinesefont, rows3, Rectangle.ALIGN_LEFT);
                PdfHelper.AddPdfCellWithUnderLine("（中国）", pdfFont.bigchinesefontLine, rows3, Rectangle.ALIGN_LEFT);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("的法律正式成立的,", pdfFont.bigchinesefont)), rows3, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellWithUnderLine(dealername.Length>5 ?dealername.Substring(0, 5): dealername, pdfFont.bigchinesefontLine, rows3, Rectangle.ALIGN_LEFT);
                PdfHelper.AddPdfTable(doc, rows3);
                //PdfPTable rows3 = new PdfPTable(5);
                //rows3.SetWidths(new float[] { 1f, 6f, 4f, 3f, 10f });
                //PdfHelper.InitPdfTableProperty(rows3);
                //PdfHelper.AddEmptyPdfCell(rows3);
                //PdfHelper.AddPdfCellWithUnderLine(new PdfPCell(new Paragraph("MA01760, USA）", pdfFont.bigchinesefontLine)) { FixedHeight = 25f }, rows3, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                //PdfHelper.AddPdfCell("。兹指派按", pdfFont.bigchinesefont, rows3, Rectangle.ALIGN_LEFT);

                //PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("的法律正式成立的", pdfFont.bigchinesefont)), rows3, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                //PdfHelper.AddPdfCellWithUnderLine(new PdfPCell(new Paragraph(dealername.Substring(0, 4), pdfFont.bigchinesefontLine)) { FixedHeight = 25f }, rows3, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                //PdfHelper.AddPdfTable(doc, rows3);


                PdfPTable row4 = new PdfPTable(3);
                row4.SetWidths(new float[] { 0.7f, 8f, 9f });
                PdfHelper.InitPdfTableProperty(row4);
                PdfHelper.AddEmptyPdfCell(row4);
                if (dealername.Length > 5)
                {
                    PdfHelper.AddPdfCellWithUnderLine(new PdfPCell(new Paragraph(dealername.Remove(0, 5), pdfFont.bigchinesefontLine)), row4, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE);
                }
                else {
                    PdfHelper.AddPdfCellWithUnderLine(new PdfPCell(new Paragraph("", pdfFont.bigchinesefontLine)), row4, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE);
                }
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("作为我方真正合法的代理人进行下列有效的", pdfFont.bigchinesefont)) { FixedHeight = 25f }, row4, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfTable(doc, row4);


                PdfPTable row5 = new PdfPTable(2);
                row5.SetWidths(new float[] { 0.7f, 15f });
                PdfHelper.InitPdfTableProperty(row5);
                PdfHelper.AddEmptyPdfCell(row5);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("活动：", pdfFont.bigchinesefont)) { FixedHeight = 25f }, row5, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfTable(doc, row5);




                #region 授权明细
                DataTable dt2 = _businessReport.ExportTenderAuthorizationProduct(id).Tables[0];
                if (dt2.Rows.Count > 0)
                {

                    string product = dt2.Rows[0]["ProductName"].ToString();

                    PdfPTable row6 = new PdfPTable(4);
                    row6.SetWidths(new float[] { 2f, 2f, 13f, 2f });
                    PdfHelper.InitPdfTableProperty(row6);
                    PdfHelper.AddEmptyPdfCell(row6);
                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("(1)", pdfFont.bigchinesefont)) { FixedHeight = 25f }, row6, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddPdfCell("代表我方办理贵方采购投标邀请要求提供的由我方制造的", pdfFont.bigchinesefont, row6, Rectangle.ALIGN_LEFT);
                    PdfHelper.AddPdfCellWithUnderLine(new PdfPCell(new Paragraph("", pdfFont.bigchinesefontLine)), row6, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddPdfTable(doc, row6);


                    PdfPTable row320 = new PdfPTable(2);
                    row320.SetWidths(new float[] { 2.5f, 16.5f });
                    PdfHelper.AddEmptyPdfCell(row320);
                    //PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("代表我方办理贵方采购投标邀请要求提供的由我方制造的", pdfFont.bigchinesefont)) { Width=15f }, row320, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                    PdfHelper.AddPdfCellWithUnderLine(new PdfPCell(new Paragraph(product, pdfFont.bigchinesefontLine)) { Colspan=1, PaddingTop=15f}, row320, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_CENTER);
                    
                    PdfHelper.AddPdfTable(doc, row320);
                }
                PdfPTable rownew = new PdfPTable(2);
                rownew.SetWidths(new float[] { 4f, 15f });
                PdfHelper.InitPdfTableProperty(rownew);
                PdfHelper.AddEmptyPdfCell(rownew);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("货物的有关事宜，并对我并具有约束力。", pdfFont.bigchinesefont)) { FixedHeight = 20f }, rownew, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfTable(doc, rownew);

                #endregion

                PdfPTable row8 = new PdfPTable(3);
                row8.SetWidths(new float[] { 2f, 2f, 15f });
                PdfHelper.InitPdfTableProperty(row8);
                PdfHelper.AddEmptyPdfCell(row8);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("(2)", pdfFont.bigchinesefont)) { FixedHeight = 25f }, row8, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCell("作为制造商，我方保证以投标合作者来约束自己，并对该投标共同", pdfFont.bigchinesefont, row8, Rectangle.ALIGN_LEFT);
                PdfHelper.AddPdfTable(doc, row8);

                PdfPTable row9 = new PdfPTable(2);
                row9.SetWidths(new float[] { 4f, 15f });
                PdfHelper.InitPdfTableProperty(row9);
                PdfHelper.AddEmptyPdfCell(row9);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("和分别承担招标文件中所规定的义务。", pdfFont.bigchinesefont)) { FixedHeight = 25f }, row9, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfTable(doc, row9);

                PdfPTable row10 = new PdfPTable(5);
                row10.SetWidths(new float[] { 2.1f, 2.2f, 3f, 12f, 1.5f });
                PdfHelper.InitPdfTableProperty(row10);
                PdfHelper.AddEmptyPdfCell(row10);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("(3)", pdfFont.bigchinesefont)) { FixedHeight = 25f }, row10, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCell("我方兹授予", pdfFont.bigchinesefont, row10, Rectangle.ALIGN_LEFT);
                PdfHelper.AddPdfCellWithUnderLine(new PdfPCell(new Paragraph(dealername, pdfFont.bigchinesefontLine)), row10, Rectangle.ALIGN_CENTER, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCell("全权", pdfFont.bigchinesefont, row10, Rectangle.ALIGN_LEFT);
                PdfHelper.AddPdfTable(doc, row10);

                PdfPTable row11 = new PdfPTable(2);
                row11.SetWidths(new float[] { 4f, 15.5f });
                PdfHelper.InitPdfTableProperty(row11);
                PdfHelper.AddEmptyPdfCell(row11);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("办理和履行上述完成上述各点所必须的事宜，具有替换或撤销的全", pdfFont.bigchinesefont)) { FixedHeight = 25f }, row11, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);

                PdfHelper.AddPdfTable(doc, row11);

                PdfPTable row12 = new PdfPTable(4);
                row12.SetWidths(new float[] { 5f, 4f, 14f, 1.5f });
                PdfHelper.InitPdfTableProperty(row12);
                PdfHelper.AddEmptyPdfCell(row12);
                PdfHelper.AddPdfCell("权。兹确认", pdfFont.bigchinesefont, row12, Rectangle.ALIGN_LEFT);
                PdfHelper.AddPdfCellWithUnderLine(new PdfPCell(new Paragraph(dealername, pdfFont.bigchinesefontLine)) { FixedHeight = 25f }, row12, Rectangle.ALIGN_CENTER, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCell("或其", pdfFont.bigchinesefont, row12, Rectangle.ALIGN_LEFT);
                PdfHelper.AddPdfTable(doc, row12);


                PdfPTable row13 = new PdfPTable(2);
                row13.SetWidths(new float[] { 4f, 15f });
                PdfHelper.InitPdfTableProperty(row13);
                PdfHelper.AddEmptyPdfCell(row13);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("正式授权代表依此合法地办理一切事宜。", pdfFont.bigchinesefont)) { FixedHeight = 25f }, row13, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfTable(doc, row13);




                PdfPTable row14 = new PdfPTable(10);
                row14.SetWidths(new float[] { 1.65f, 1.65f, 1.5f, 1.5f, 1f, 1f, 1f, 1f, 4f, 1.5f });
                PdfHelper.InitPdfTableProperty(row14);
                PdfHelper.AddEmptyPdfCell(row14);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("(4)", pdfFont.bigchinesefont)) { FixedHeight = 25f }, row14, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCell("我方于", pdfFont.bigchinesefont, row14, Rectangle.ALIGN_LEFT);
                PdfHelper.AddPdfCellWithUnderLine(new PdfPCell(new Paragraph(begindate.Substring(0, 4), pdfFont.bigchinesefontLine)), row14, Rectangle.ALIGN_CENTER, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCell("年", pdfFont.bigchinesefont, row14, Rectangle.ALIGN_LEFT);
                PdfHelper.AddPdfCellWithUnderLine(new PdfPCell(new Paragraph(begindate.Substring(5, 2), pdfFont.bigchinesefontLine)), row14, Rectangle.ALIGN_CENTER, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCell("月", pdfFont.bigchinesefont, row14, Rectangle.ALIGN_LEFT);
                PdfHelper.AddPdfCellWithUnderLine(new PdfPCell(new Paragraph(begindate.Remove(0, 8), pdfFont.bigchinesefontLine)), row14, Rectangle.ALIGN_CENTER, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCell("日签署本文件，于", pdfFont.bigchinesefont, row14, Rectangle.ALIGN_LEFT);
                PdfHelper.AddPdfCellWithUnderLine(new PdfPCell(new Paragraph(enddate.Substring(0, 4), pdfFont.bigchinesefontLine)), row14, Rectangle.ALIGN_CENTER, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfTable(doc, row14);


                PdfPTable row15 = new PdfPTable(7);
                row15.SetWidths(new float[] { 3f, 1f, 1.5f, 1f, 1.5f, 1f, 5f });
                PdfHelper.InitPdfTableProperty(row15);
                PdfHelper.AddEmptyPdfCell(row15);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("年", pdfFont.bigchinesefont)) { FixedHeight = 25f }, row15, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellWithUnderLine(new PdfPCell(new Paragraph(enddate.Substring(5, 2), pdfFont.bigchinesefontLine)), row15, Rectangle.ALIGN_CENTER, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCell("月", pdfFont.bigchinesefont, row15, Rectangle.ALIGN_LEFT);
                PdfHelper.AddPdfCellWithUnderLine(new PdfPCell(new Paragraph(enddate.Remove(0, 8), pdfFont.bigchinesefontLine)), row15, Rectangle.ALIGN_CENTER, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCell("日", pdfFont.bigchinesefont, row15, Rectangle.ALIGN_LEFT);
                PdfHelper.AddPdfCell("接受此证件，以此为凭。", pdfFont.bigchinesefont, row15, Rectangle.ALIGN_LEFT);
                PdfHelper.AddPdfTable(doc, row15);







                PdfPTable row21 = new PdfPTable(2);
                row21.SetWidths(new float[] { 2f, 10f });
                PdfHelper.AddEmptyPdfCell(row21);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("", pdfFont.bigchinesefontLine)) { FixedHeight = 25f }, row21, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfTable(doc, row21);

                PdfPTable row16 = new PdfPTable(3);
                row16.SetWidths(new float[] { 3.3f, 4.5f, 8f });
                PdfHelper.InitPdfTableProperty(row16);
                PdfHelper.AddEmptyPdfCell(row16);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("制造商名称（盖章）：", pdfFont.bigchinesefont)) { FixedHeight = 25f }, row16, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellWithUnderLine(new PdfPCell(new Paragraph("蓝威医疗科技(上海)有限公司 ", pdfFont.bigchinesefontLine)), row16, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfTable(doc, row16);

                PdfPTable row17 = new PdfPTable(5);
                row17.SetWidths(new float[] { 3.2f, 4f, 3f, 3f, 2f });
                PdfHelper.InitPdfTableProperty(row17);
                PdfHelper.AddEmptyPdfCell(row17);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("签字人职务和部门：", pdfFont.bigchinesefont)) { FixedHeight = 25f }, row17, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellWithUnderLine("", pdfFont.bigchinesefontLine, row17, Rectangle.ALIGN_LEFT);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("", pdfFont.bigchinesefont)) { FixedHeight = 25f }, row17, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("", pdfFont.bigchinesefont)) { FixedHeight = 25f }, row17, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfTable(doc, row17);



                PdfPTable row18 = new PdfPTable(4);
                row18.SetWidths(new float[] { 3.5f, 3f, 4f, 6f, });
                PdfHelper.InitPdfTableProperty(row18);
                PdfHelper.AddEmptyPdfCell(row18);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("签字人姓名：", pdfFont.bigchinesefont)) { FixedHeight = 25f }, row18, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellWithUnderLine("", pdfFont.bigchinesefontLine, row18, Rectangle.ALIGN_LEFT);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("", pdfFont.bigchinesefont)) { FixedHeight = 25f }, row18, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("", pdfFont.bigchinesefont)) { FixedHeight = 25f }, row18, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfTable(doc, row18);



                PdfPTable row19 = new PdfPTable(5);
                row19.SetWidths(new float[] { 3.5f, 3f, 4f, 3f, 3f });
                PdfHelper.InitPdfTableProperty(row19);
                PdfHelper.AddEmptyPdfCell(row19);

                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("签字人签名：", pdfFont.bigchinesefont)) { FixedHeight = 25f }, row19, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);


                PdfHelper.AddPdfCellWithUnderLine("", pdfFont.bigchinesefontLine, row19, Rectangle.ALIGN_RIGHT);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("", pdfFont.bigchinesefont)) { FixedHeight = 25f }, row19, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("", pdfFont.bigchinesefont)) { FixedHeight = 25f }, row19, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfTable(doc, row19);

                PdfPTable row20 = new PdfPTable(3);
                row20.SetWidths(new float[] { 3.3f, 11f, 4f });
                PdfHelper.InitPdfTableProperty(row20);
                PdfHelper.AddEmptyPdfCell(row20);

                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("注：授权有效期自签署之日起90天内有效", pdfFont.bigtitlechinesefont)) { FixedHeight = 70f }, row20, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddEmptyPdfCell(row20);
                PdfHelper.AddPdfTable(doc, row20);





                //#region 生成表格显示产品

                ////Agreement Renewal Proposals Grid:
                //PdfPTable standardTermGridTable = new PdfPTable(5);
                //standardTermGridTable.SetWidths(new float[] { 4f, 25f, 25f, 25f, 25f });
                //PdfHelper.InitPdfTableProperty(standardTermGridTable);





                //#endregion

                doc.Close();
                DownloadFileForDCMS(fileName, "Bidauthorization.pdf", "DCMS");

            }



        }


        protected void CreatePdfUpdate()
        {

            string id = Request.QueryString["DtmId"].ToString();
            string mainid = Request.QueryString["MainId"].ToString();
            DataTable dt = _businessReport.GetAuthorizationList(new Guid(id)).Tables[0];


            //生成二维码图片
            if (dt.Rows.Count > 0)
            {
                string DTM_NO = dt.Rows[0]["DTM_NO"].ToString();
                string dealername = dt.Rows[0]["DTM_DealerName"].ToString();
                DateTime begindate = Convert.ToDateTime(dt.Rows[0]["DTM_BeginDate"]);
                DateTime enddate = Convert.ToDateTime(dt.Rows[0]["DTM_EndDate"]);
                string hospitalname = dt.Rows[0]["HOS_HospitalName"].ToString();




                QRCodeEncoder qrCodeEncoder = new QRCodeEncoder();
                System.Drawing.Image image = qrCodeEncoder.Encode(new Guid(id).ToString());
                string filepath = Page.Server.MapPath(@"..\..\") + @"Upload\QR\" + Guid.NewGuid().ToString() + ".png";
                System.IO.FileStream fs = new System.IO.FileStream(filepath, System.IO.FileMode.OpenOrCreate, System.IO.FileAccess.Write);
                image.Save(fs, System.Drawing.Imaging.ImageFormat.Jpeg);
                fs.Close();
                image.Dispose();
                iTextSharp.text.Image op = iTextSharp.text.Image.GetInstance(filepath);
                op.ScaleAbsolute(100.8f, 100.8f);//图片缩放
                PdfPCell cellImage = new PdfPCell(op);
                cellImage.Border = 0;
                cellImage.PaddingBottom = 5f;
                cellImage.PaddingRight = 5f;
                cellImage.HorizontalAlignment = Rectangle.ALIGN_RIGHT;
                cellImage.VerticalAlignment = Rectangle.ALIGN_BOTTOM;


                string fileName = DateTime.Now.ToFileTime().ToString() + ".pdf";
                string targetPath = Server.MapPath(PdfHelper.FILE_PATH + fileName);
                Document doc = new Document(iTextSharp.text.PageSize.A4, 36, 36, 12, 50);

                PdfHelper.RegisterChineseFont();
                PdfHelper pdfFont = new PdfHelper();
                //DataTable list = _businessReport.GetAuthorization(new Guid(id)).Tables[0];

                PdfWriter writer = PdfWriter.GetInstance(doc, new FileStream(targetPath, FileMode.Create));
                doc.Open();

                PdfPTable titleTable = new PdfPTable(3);
                titleTable.SetWidths(new float[] { 8f, 8f, 8f });
                PdfHelper.InitPdfTableProperty(titleTable);
                //标题
                PdfHelper.AddEmptyPdfCell(titleTable);
                PdfPCell titleCell = new PdfPCell(new Paragraph("制造厂家的授权书", pdfFont.bigtitlechinesefont2));
                titleCell.HorizontalAlignment = Rectangle.ALIGN_MIDDLE;
                titleCell.VerticalAlignment = Rectangle.ALIGN_BOTTOM;
                titleCell.PaddingBottom = 10f;
                titleCell.FixedHeight = 65.5f;
                titleCell.Border = 0;
                titleTable.AddCell(titleCell);
                titleTable.AddCell(cellImage);
                PdfHelper.AddPdfTable(doc, titleTable);


                #region Content

                Font georgia = pdfFont.bigchinesefont;
                Font georgiaB = pdfFont.bigtitlechinesefont;
                Font georgiaC = pdfFont.bigchinesefontLine;
                Paragraph EmptyParagragh = new Paragraph("  ", georgia);

                Chunk chunk1 = new Chunk("致: ", georgia);
                Chunk chunk2 = new Chunk("  " + hospitalname + "  ", georgiaC).SetUnderline(1f, -2f);
                Chunk chunk2_1 = new Chunk("   ", georgia).SetUnderline(1f, -2f);
                Phrase phrase1 = new Phrase();
                phrase1.Add(chunk1);
                phrase1.Add(chunk2);
                phrase1.Add(chunk2_1);
                Paragraph paragraph1 = new Paragraph();
               
                paragraph1.KeepTogether = true;
                paragraph1.Alignment = Element.ALIGN_JUSTIFIED;

                paragraph1.Add(phrase1);
                doc.Add(EmptyParagragh);
                doc.Add(paragraph1);

                Chunk chunk3 = new Chunk("我们", georgia);
                Chunk chunk4 = new Chunk("  （Boston Scientific Corperation）  ", georgiaC).SetUnderline(1f, -2f);
                Chunk chunk5 = new Chunk("是按", georgia);
                Chunk chunk6 = new Chunk("  （美国）  ", georgiaC).SetUnderline(1f, -2f);
                Chunk chunk7 = new Chunk("法律成立的一家制造商，主要营业地点设在", georgia);
                Chunk chunk8 = new Chunk("  （One Boston Scientific Place,Natick, MA01760, USA） ", georgiaC).SetUnderline(1f, -2f);
                Chunk chunk9 = new Chunk("。兹指派按", georgia);
                Chunk chunk10 = new Chunk("  （中国）  ", georgiaC).SetUnderline(1f, -2f);
                Chunk chunk11 = new Chunk("的法律正式成立的, ", georgia);
                Chunk chunk12 = new Chunk("  "+ dealername + "  ", georgiaC).SetUnderline(1f, -2f);
                Chunk chunk13 = new Chunk("作为我方真正合法的代理人进行下列有效活动： ", georgia);
                Phrase phrase1_2 = new Phrase();
                phrase1_2.Add(chunk3);
                phrase1_2.Add(chunk4);
                phrase1_2.Add(chunk5);
                phrase1_2.Add(chunk6);
                phrase1_2.Add(chunk7);
                phrase1_2.Add(chunk8);
                phrase1_2.Add(chunk9);
                phrase1_2.Add(chunk10);
                phrase1_2.Add(chunk11);
                phrase1_2.Add(chunk12);
                phrase1_2.Add(chunk13);
                Paragraph paragraph1_2 = new Paragraph();
                paragraph1_2.FirstLineIndent = 30f;
                paragraph1_2.KeepTogether = true;
                paragraph1_2.Alignment = Element.ALIGN_JUSTIFIED;
                paragraph1_2.Leading = 28f;

                paragraph1_2.Add(phrase1_2);

                doc.Add(EmptyParagragh);
                doc.Add(paragraph1_2);

                string product = "";
                DataTable dt2 = _businessReport.ExportTenderAuthorizationProduct(id).Tables[0];
                if (dt2.Rows.Count > 0)
                {
                    product = dt2.Rows[0]["ProductName"].ToString();
                }
                Chunk chunk3_1 = new Chunk("(1)  代表我方办理贵方采购投标邀请要求提供的由我方制造的", georgia);
                Chunk chunk3_2 = new Chunk("  "+ product.Replace("&amp;", "") + "  ", georgiaC).SetUnderline(1f, -2f);
                Chunk chunk3_3 = new Chunk("货物的有关事宜，并对我并具有约束力。 ", georgia);
                Phrase phrase3_1 = new Phrase();
                phrase3_1.Add(chunk3_1);
                phrase3_1.Add(chunk3_2);
                phrase3_1.Add(chunk3_3);
                Paragraph paragraph3 = new Paragraph();
                paragraph3.IndentationLeft = 45f;
                paragraph3.KeepTogether = true;
                paragraph3.Alignment = Element.ALIGN_JUSTIFIED;
                paragraph3.Leading = 28f;

                paragraph3.Add(phrase3_1);

                //doc.Add(EmptyParagragh);
                doc.Add(paragraph3);

                Chunk chunk4_1 = new Chunk("(2)  作为制造商，我方保证以投标合作者来约束自己，并对该投标共同和分别承担招标文件中所规定的义务。 ", georgia);
                Phrase phrase4_1 = new Phrase();
                phrase4_1.Add(chunk4_1);
                Paragraph paragraph4 = new Paragraph();
                paragraph4.IndentationLeft = 45f;
                paragraph4.KeepTogether = true;
                paragraph4.Alignment = Element.ALIGN_JUSTIFIED;
                paragraph4.Leading = 25f;
                paragraph4.Add(phrase4_1);

                //doc.Add(EmptyParagragh);
                doc.Add(paragraph4);

                Chunk chunk5_1 = new Chunk("(3)  我方兹授予 ", georgia);
                Chunk chunk5_2 = new Chunk("  " + dealername + "  ", georgiaC).SetUnderline(1f, -2f);
                Chunk chunk5_3 = new Chunk(" 全权办理和履行上述完成上述各点所必须的事宜，具有替换或撤销的全权。兹确认 ", georgia);
                Chunk chunk5_4 = new Chunk("  " + dealername + "  ", georgiaC).SetUnderline(1f, -2f);
                Chunk chunk5_5 = new Chunk("  或其正式授权代表依此合法地办理一切事宜。  ", georgia);
                Phrase phrase5_1 = new Phrase();
                phrase5_1.Add(chunk5_1);
                phrase5_1.Add(chunk5_2);
                phrase5_1.Add(chunk5_3);
                phrase5_1.Add(chunk5_4);
                phrase5_1.Add(chunk5_5);
                Paragraph paragraph5 = new Paragraph();
                paragraph5.IndentationLeft = 45f;
                paragraph5.KeepTogether = true;
                paragraph5.Alignment = Element.ALIGN_JUSTIFIED;
                paragraph5.Leading = 28f;
                paragraph5.Add(phrase5_1);

                //doc.Add(EmptyParagragh);
                doc.Add(paragraph5);

                Chunk chunk6_1 = new Chunk("(4)   我方于 ", georgia);
                Chunk chunk6_2 = new Chunk("  " + begindate.Year.ToString() + "  ", georgiaC).SetUnderline(1f, -2f);
                Chunk chunk6_3 = new Chunk(" 年 ", georgia);
                Chunk chunk6_4 = new Chunk("  " + (begindate.Month.ToString().Length==1? ("0"+ begindate.Month.ToString()): begindate.Month.ToString()) + "  ", georgiaC).SetUnderline(1f, -2f);
                Chunk chunk6_5 = new Chunk("  月  ", georgia);
                Chunk chunk6_6 = new Chunk("  " + (begindate.Day.ToString().Length == 1 ? ("0" + begindate.Day.ToString()) : begindate.Day.ToString()) + "  ", georgiaC).SetUnderline(1f, -2f);
                Chunk chunk6_7 = new Chunk("  日签署本文件，  ", georgia);
                Chunk chunk6_14 = new Chunk(" "+dealername+" ", georgiaC).SetUnderline(1f, -2f);
                Chunk chunk6_15 = new Chunk(" 于 ", georgia);
                Chunk chunk6_8 = new Chunk("  " + begindate.Year.ToString() + "  ", georgiaC).SetUnderline(1f, -2f);
                Chunk chunk6_9 = new Chunk(" 年 ", georgia);
                Chunk chunk6_10 = new Chunk("  " + (begindate.Month.ToString().Length == 1 ? ("0" + begindate.Month.ToString()) : begindate.Month.ToString()) + "  ", georgiaC).SetUnderline(1f, -2f);
                Chunk chunk6_11 = new Chunk("  月  ", georgia);
                Chunk chunk6_12 = new Chunk("  " + (begindate.Day.ToString().Length == 1 ? ("0" + begindate.Day.ToString()) : begindate.Day.ToString()) + "  ", georgiaC).SetUnderline(1f, -2f);
                Chunk chunk6_13 = new Chunk("  日接受此件，以此为证。  ", georgia);
                Phrase phrase6_1 = new Phrase();
                phrase6_1.Add(chunk6_1);
                phrase6_1.Add(chunk6_2);
                phrase6_1.Add(chunk6_3);
                phrase6_1.Add(chunk6_4);
                phrase6_1.Add(chunk6_5);
                phrase6_1.Add(chunk6_6);
                phrase6_1.Add(chunk6_7);
                phrase6_1.Add(chunk6_14);
                phrase6_1.Add(chunk6_15);
                phrase6_1.Add(chunk6_8);
                phrase6_1.Add(chunk6_9);
                phrase6_1.Add(chunk6_10);
                phrase6_1.Add(chunk6_11);
                phrase6_1.Add(chunk6_12);
                phrase6_1.Add(chunk6_13);
                
                Paragraph paragraph6 = new Paragraph();
                paragraph6.IndentationLeft = 45f;
                paragraph6.KeepTogether = true;
                paragraph6.Alignment = Element.ALIGN_JUSTIFIED;
                paragraph6.Leading = 28f;
                paragraph6.Add(phrase6_1);

                //doc.Add(EmptyParagragh);
                doc.Add(paragraph6);

                /*
               Chunk chunk7_1 = new Chunk("制造商名称（盖章）：  ", georgia);
               Chunk chunk7_2 = new Chunk("  蓝威医疗科技(上海)有限公司  ", georgiaC).SetUnderline(1f, -2f);

               Phrase phrase7_1 = new Phrase();
               phrase7_1.Add(chunk7_1);
               phrase7_1.Add(chunk7_2);
               Paragraph paragraph7 = new Paragraph();
               paragraph7.IndentationLeft = 55f;
               paragraph7.KeepTogether = true;
               paragraph7.Alignment = Element.ALIGN_JUSTIFIED;
               paragraph7.Leading = 25f;
               paragraph7.Add(phrase7_1);
               doc.Add(EmptyParagragh);
               doc.Add(EmptyParagragh);
               doc.Add(paragraph7);


               Chunk chunk8_1 = new Chunk("签字人职务和部门：  ", georgia);
               Chunk chunk8_2 = new Chunk("                                                ", georgiaC).SetUnderline(1f, -2f);

               Phrase phrase8_1 = new Phrase();
               phrase8_1.Add(chunk8_1);
               phrase8_1.Add(chunk8_2);
               Paragraph paragraph8 = new Paragraph();
               paragraph8.IndentationLeft = 55f;
               paragraph8.KeepTogether = true;
               paragraph8.Alignment = Element.ALIGN_JUSTIFIED;
               paragraph8.Leading = 28f;
               paragraph8.Add(phrase8_1);

               doc.Add(paragraph8);

               Chunk chunk9_1 = new Chunk("签字人姓名：  ", georgia);
               Chunk chunk9_2 = new Chunk("                                                ", georgiaC).SetUnderline(1f, -2f);

               Phrase phrase9_1 = new Phrase();
               phrase9_1.Add(chunk9_1);
               phrase9_1.Add(chunk9_2);
               Paragraph paragraph9 = new Paragraph();
               paragraph9.IndentationLeft = 55f;
               paragraph9.KeepTogether = true;
               paragraph9.Alignment = Element.ALIGN_JUSTIFIED;
               paragraph9.Leading = 28f;
               paragraph9.Add(phrase9_1);

               doc.Add(paragraph9);

               Chunk chunk10_1 = new Chunk("签字人签名：  ", georgia);
               Chunk chunk10_2 = new Chunk("                                                ", georgiaC).SetUnderline(1f, -2f);

               Phrase phrase10_1 = new Phrase();
               phrase10_1.Add(chunk10_1);
               phrase10_1.Add(chunk10_2);
               Paragraph paragraph10 = new Paragraph();
               paragraph10.IndentationLeft = 55f;
               paragraph10.KeepTogether = true;
               paragraph10.Alignment = Element.ALIGN_JUSTIFIED;
               paragraph10.Leading = 28f;
               paragraph10.Add(phrase10_1);

               doc.Add(paragraph10);*/
                PdfPTable row21 = new PdfPTable(2);
                row21.SetWidths(new float[] { 2f, 10f });
                PdfHelper.AddEmptyPdfCell(row21);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("", pdfFont.bigchinesefontLine)) { FixedHeight = 25f }, row21, Rectangle.ALIGN_RIGHT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfTable(doc, row21);

                PdfPTable row16 = new PdfPTable(3);
                row16.SetWidths(new float[] { 3.3f, 4.5f, 8f });
                PdfHelper.InitPdfTableProperty(row16);
                PdfHelper.AddEmptyPdfCell(row16);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("制造商名称（盖章）：", pdfFont.bigchinesefont)) { FixedHeight = 25f }, row16, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellWithUnderLine(new PdfPCell(new Paragraph("蓝威医疗科技(上海)有限公司 ", pdfFont.bigchinesefontLine)), row16, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
             
                PdfHelper.AddPdfTable(doc, row16);

                PdfPTable row17 = new PdfPTable(5);
                row17.SetWidths(new float[] { 3.2f, 4f, 3f, 3f, 2f });
                PdfHelper.InitPdfTableProperty(row17);
                PdfHelper.AddEmptyPdfCell(row17);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("签字人职务和部门：", pdfFont.bigchinesefont)) { FixedHeight = 25f }, row17, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellWithUnderLine("", pdfFont.bigchinesefontLine, row17, Rectangle.ALIGN_LEFT);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("", pdfFont.bigchinesefont)) { FixedHeight = 25f }, row17, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("", pdfFont.bigchinesefont)) { FixedHeight = 25f }, row17, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfTable(doc, row17);



                PdfPTable row18 = new PdfPTable(4);
                row18.SetWidths(new float[] { 3.5f, 3f, 4f, 6f, });
                PdfHelper.InitPdfTableProperty(row18);
                PdfHelper.AddEmptyPdfCell(row18);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("签字人姓名：", pdfFont.bigchinesefont)) { FixedHeight = 25f }, row18, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCellWithUnderLine("", pdfFont.bigchinesefontLine, row18, Rectangle.ALIGN_LEFT);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("", pdfFont.bigchinesefont)) { FixedHeight = 25f }, row18, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("", pdfFont.bigchinesefont)) { FixedHeight = 25f }, row18, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfTable(doc, row18);



                PdfPTable row19 = new PdfPTable(5);
                row19.SetWidths(new float[] { 3.5f, 3f, 4f, 3f, 3f });
                PdfHelper.InitPdfTableProperty(row19);
                PdfHelper.AddEmptyPdfCell(row19);

                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("签字人签名：", pdfFont.bigchinesefont)) { FixedHeight = 25f }, row19, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);


                PdfHelper.AddPdfCellWithUnderLine("", pdfFont.bigchinesefontLine, row19, Rectangle.ALIGN_RIGHT);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("", pdfFont.bigchinesefont)) { FixedHeight = 25f }, row19, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("", pdfFont.bigchinesefont)) { FixedHeight = 25f }, row19, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_BOTTOM);
                PdfHelper.AddPdfTable(doc, row19);

                Chunk chunk11_1 = new Chunk("注：授权有效期自签署之日起90天内有效  ", georgiaB);
                Phrase phrase11_1 = new Phrase();
                phrase11_1.Add(chunk11_1);
                Paragraph paragraph11 = new Paragraph();
                paragraph11.IndentationLeft = 80f;
                paragraph11.KeepTogether = true;
                paragraph11.Alignment = Element.ALIGN_JUSTIFIED;
                paragraph11.Leading = 28f;
                paragraph11.Add(phrase11_1);

                doc.Add(EmptyParagragh);
                doc.Add(EmptyParagragh);
                doc.Add(paragraph11);
                #endregion


                doc.Close();
                DownloadFileForDCMS(fileName, "TenderAuthorization.pdf", "DCMS");

            }

        }



        protected void DownloadFileForDCMS(string filename, string downname, string documentName)
        {
            string savename = downname;

            try
            {
                filename = AppDomain.CurrentDomain.BaseDirectory.ToString() + "Upload\\UploadFile\\" + documentName + "\\" + filename;

                Response.Clear();
                Response.Buffer = true;

                //以字符流的形式下载文件 
                System.IO.FileStream fs = new System.IO.FileStream(filename, System.IO.FileMode.Open);
                byte[] bytes = new byte[(int)fs.Length];
                fs.Read(bytes, 0, bytes.Length);
                fs.Close();
                Response.ContentType = "application/octet-stream";
                //通知浏览器下载文件而不是打开 
                Response.AddHeader("Content-Disposition", "attachment; filename=" + HttpUtility.UrlEncode(savename, System.Text.Encoding.UTF8));
                Response.BinaryWrite(bytes);
                Response.Flush();
                Response.End();
            }
            catch (Exception ex)
            {

            }

        }


    }
}