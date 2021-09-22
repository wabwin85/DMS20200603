using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using iTextSharp.text;
using iTextSharp.text.pdf;
using iTextSharp.text.html.simpleparser;
using System.Collections;
using System.Net;
using System.Reflection;

namespace DMS.Website.Common
{
    public class PdfPageEvent : iTextSharp.text.pdf.PdfPageEventHelper
    {
        protected Font footer
        {
            get
            {
                BaseColor grey = new BaseColor(128, 128, 128);
                Font font = FontFactory.GetFont(BaseFont.COURIER, 9, Font.NORMAL, grey);
                return font;
            }
        }

        protected BaseFont font
        {
            get
            {
                BaseFont bfCour = BaseFont.CreateFont(BaseFont.COURIER, BaseFont.CP1252, false);
                return bfCour;
            }
        }

        string headRemark = string.Empty;
        string footRemark = string.Empty;
        bool hasShowHead = false;
        bool isIAFHead = false;

        public PdfPageEvent(string pageFooter)
        {
            footRemark = pageFooter;
            hasShowHead = false;
        }

        public PdfPageEvent(string pageHeader, string pageFooter, bool iafHead)
        {
            headRemark = pageHeader;
            footRemark = pageFooter;
            isIAFHead = iafHead;
            if (!string.IsNullOrEmpty(pageHeader.Trim()))
            {
                hasShowHead = true;
            }
        }

        protected PdfTemplate total;

        public override void OnOpenDocument(PdfWriter writer, Document document)
        {
            total = writer.DirectContent.CreateTemplate(50, 50);
            total.BoundingBox = new Rectangle(-20, -20, 100, 100);
        }

        public override void OnStartPage(PdfWriter writer, Document document)
        {
            if (hasShowHead)
            {
                if (isIAFHead)
                {
                    //设置Title Tabel 
                    PdfPTable titleTable = new PdfPTable(3);
                    titleTable.SetWidths(new float[] { 20f, 60f, 20f });
                    titleTable.TotalWidth = document.PageSize.Width;

                    titleTable.AddCell(PdfHelper.GetIAFBscLogoImageCell());

                    //Pdf标题
                    PdfPCell titleCell = new PdfPCell(new Paragraph(headRemark, PdfHelper.iafTitleGrayFont));
                    titleCell.HorizontalAlignment = Rectangle.ALIGN_CENTER;
                    titleCell.VerticalAlignment = Rectangle.ALIGN_BOTTOM;
                    titleCell.PaddingBottom = 9f;
                    titleCell.FixedHeight = 50f;
                    titleCell.Border = 0;
                    titleTable.AddCell(titleCell);

                    PdfHelper.AddEmptyPdfCell(titleTable);

                    titleTable.WriteSelectedRows(0, -1, document.LeftMargin, document.PageSize.Height, writer.DirectContent);
                }
                else
                {
                    PdfContentByte cb = writer.DirectContent;
                    cb.SaveState();
                    cb.BeginText();
                    cb.SetFontAndSize(font, 9);
                    cb.SetRGBColorFill(128, 128, 128);
                    cb.ShowTextAligned(Element.ALIGN_LEFT, headRemark, 20, document.PageSize.Height - 20, 0);
                    cb.EndText();
                    cb.RestoreState();
                }
            }
        }

        public override void OnEndPage(PdfWriter writer, Document document)
        {
            PdfPTable footerTbl = new PdfPTable(1);
            footerTbl.TotalWidth = document.PageSize.Width;
            footerTbl.HorizontalAlignment = Element.ALIGN_CENTER;
            Paragraph para = new Paragraph(footRemark, footer);
            PdfPCell cell = new PdfPCell(para);
            cell.Border = 0;
            cell.PaddingLeft = 10f;
            footerTbl.AddCell(cell);
            footerTbl.WriteSelectedRows(0, -1, 0, 30, writer.DirectContent);

            PdfContentByte cb = writer.DirectContent;
            cb.SaveState();
            string text = "Page: " + writer.PageNumber;
            float len = font.GetWidthPoint(text, 9);
            cb.BeginText();
            cb.SetFontAndSize(font, 9);
            cb.SetRGBColorFill(128, 128, 128);
            cb.SetTextMatrix(500, 20);
            cb.ShowText(text);
            cb.EndText();
            cb.AddTemplate(total, 500 + len, 20);
            cb.RestoreState();
        }

        public override void OnCloseDocument(PdfWriter writer, Document document)
        {
            total.BeginText();
            total.SetFontAndSize(font, 9);
            total.SetRGBColorFill(128, 128, 128);
            int pageNumber = writer.PageNumber - 1;
            total.ShowText(" of " + Convert.ToString(pageNumber));
            total.EndText();
        }

    }
}
