using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace DMS.Website.Common
{
    using iTextSharp.text;
    using iTextSharp.text.pdf;
    using System.IO;
    using System.Reflection;
    using System.Web.UI;

    public class PdfHelper
    {
        
        public static string FILE_PATH = "\\Upload\\UploadFile\\DCMS\\";
        public static string COA_FILE_PATH = "\\Upload\\COA\\";
        public static float NORMAL_FIXED_HEIGHT = 22f;
        public static float APPROVAL_FIXED_HEIGHT = 50f;
        public static float APPROVAL_PADDING_RIGHT = 10f;
        public static float PDF_NEW_LINE = 10f;
        public static float YOUNG_FIXED_HEIGHT = 15f;
        public static float MIN_HEIGHT = 16f;

        public static BaseColor blueColor = new BaseColor(2, 33, 160);
        public static BaseColor remarkBgColor = new BaseColor(190, 239, 250);
        public static BaseColor grayColor = new BaseColor(239, 239, 239);
        public static BaseColor headColor = new BaseColor(128, 128, 128);

        public static BaseFont baseFont = BaseFont.CreateFont("C:\\WINDOWS\\FONTS\\FZLTZHUNHJW_0.TTF", BaseFont.IDENTITY_H, BaseFont.NOT_EMBEDDED);
        //public static BaseFont baseFont = BaseFont.CreateFont("C:\\WINDOWS\\FONTS\\方正兰亭准黑简体.TTF", BaseFont.IDENTITY_H, BaseFont.NOT_EMBEDDED);

        public static Font boldFont = FontFactory.GetFont(FontFactory.HELVETICA_BOLD, 12);
        public static Font italicFont = FontFactory.GetFont(FontFactory.HELVETICA_BOLD, 10, Font.ITALIC);
    
        public static Font italicFontBasc = new Font(baseFont, 10, Font.ITALIC);
        public static Font youngFontBasc = new Font(baseFont, 8, Font.NORMAL);
        public static Font youngDescFontBasc = new Font(baseFont, 8, Font.ITALIC);
        public static Font youngBoldFontBasc = new Font(baseFont, 8, Font.BOLD);
        public static Font iafAnswerFontBasc = new Font(baseFont, 9, Font.NORMAL);

        public static Font normalFont = FontFactory.GetFont("Arial", 9);
        public static Font normalFontmin = FontFactory.GetFont("Arial", 9);
        //public static Font answerFont = FontFactory.GetFont(FontFactory.HELVETICA, 9, new BaseColor(1, 30, 139));

        //public static Font normalFont = new Font(baseFont, 9, Font.NORMAL);
        //public static Font normalFontmin = new Font(baseFont, 9, Font.NORMAL);
        public static Font answerFont = new Font(baseFont, 9, Font.NORMAL, new BaseColor(1, 30, 139));
       

        public static Font normalBoldFont = FontFactory.GetFont("Arial", 9, Font.BOLD);
        public static Font underLineFont = FontFactory.GetFont("Arial", 9, Font.UNDERLINE);
        public static Font youngBoldFont = FontFactory.GetFont("Arial", 7, Font.BOLD);
        public static Font youngItalicFont = FontFactory.GetFont("Arial", 7, Font.ITALIC);
        public static Font youngFont = FontFactory.GetFont("Arial", 8);
        public static Font youngChineseFont = new Font(baseFont, 8, Font.NORMAL);
        public static Font youngDescFont = FontFactory.GetFont("Arial", 8, Font.BOLDITALIC);
        public static Font smallFont = FontFactory.GetFont(FontFactory.HELVETICA, 8.5f);
        public static Font descFont = new Font(Font.FontFamily.UNDEFINED, 8, Font.ITALIC);
        public static Font iafAnswerFont = FontFactory.GetFont(FontFactory.HELVETICA, 9);
        public static Font timesFont = FontFactory.GetFont(FontFactory.TIMES_ROMAN, 10);
        public static Font iafTitleFont = new Font(Font.FontFamily.TIMES_ROMAN, 16, Font.BOLDITALIC);
        public static Font iafTitleGrayFont = new Font(Font.FontFamily.TIMES_ROMAN, 16, Font.BOLDITALIC, PdfHelper.headColor);
        public static Font noteFont = new Font(Font.FontFamily.TIMES_ROMAN, 12, Font.BOLDITALIC);

        //public Font answerChineseFont = FontFactory.GetFont("PMingLiU", BaseFont.IDENTITY_H, true, 9, Font.NORMAL, new BaseColor(1, 30, 139));
        //public Font normalChineseFont = FontFactory.GetFont("PMingLiU", BaseFont.IDENTITY_H, 9);
        public Font answerChineseFont = new Font(baseFont, 9, Font.NORMAL, new BaseColor(1, 30, 139));
        public Font normalChineseFont = new Font(baseFont, 9, Font.NORMAL);
        public Font normalChineseFontB = new Font(baseFont, 9, Font.BOLD);

        
        public Font bigchinesefontLine = new Font(baseFont, 14, Font.NORMAL, new BaseColor(1, 30, 139));
        public Font bigchinesefont = new Font(baseFont, 14, Font.NORMAL);
        public Font bigtitlechinesefont = new Font(baseFont, 16, Font.BOLD);
        public Font bigtitlechinesefont2 = new Font(baseFont, 20, Font.NORMAL);




        public Font normalBoldChineseFont = FontFactory.GetFont("PMingLiU", BaseFont.IDENTITY_H, 9, Font.BOLD);

        public Font normalBoldChineseFont14 = FontFactory.GetFont("PMingLiU", BaseFont.IDENTITY_H, 14, Font.BOLD);

        /// <summary>
        /// 图片转换为PDF
        /// </summary>
        /// <param name="sourcePath"></param>
        /// <param name="targetPath"></param>
        /// <returns></returns>
        public static bool ConvertPdf(string sourcePath, string targetPath)
        {
            Document doc = new Document();

            try
            {
                PdfWriter.GetInstance(doc, new FileStream(targetPath, FileMode.Create));
                doc.Open();
                string fileExt = sourcePath.Substring(sourcePath.LastIndexOf(".") + 1).ToUpper();

                //doc.Add(new Paragraph(fileExt));
                iTextSharp.text.Image image = iTextSharp.text.Image.GetInstance(sourcePath);

                //根据A4纸张的大小调整图片的大小。
                if (image.Height > iTextSharp.text.PageSize.A4.Height - 25)
                    image.ScaleToFit(iTextSharp.text.PageSize.A4.Width - 25, iTextSharp.text.PageSize.A4.Height - 25);
                else if (image.Width > iTextSharp.text.PageSize.A4.Width - 25)
                    image.ScaleToFit(iTextSharp.text.PageSize.A4.Width - 25, iTextSharp.text.PageSize.A4.Height - 25);
                //调整图片位置，使之居中
                image.Alignment = iTextSharp.text.Image.ALIGN_MIDDLE;
                doc.Add(image);

                return true;
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                return false;
            }
            finally
            {
                doc.Close();
            }
        }

        /// <summary>
        /// 判断文件是否为图片格式
        /// </summary>
        /// <param name="filePath"></param>
        /// <returns></returns>
        public static bool ValidateImage(string filePath)
        {
            System.Drawing.Image sourceImage;

            try
            {
                sourceImage = System.Drawing.Image.FromFile(filePath);
                sourceImage.Dispose();
                return true;
            }
            catch
            {
                // This is not a valid image. Do nothing.
                return false;
            }
        }

        /// <summary>
        /// 合并PDF
        /// </summary>
        /// <param name="sourcPaths"></param>
        /// <param name="targetPath"></param>
        /// <returns></returns>
        public static bool MergePdf(string[] sourcPaths, string targetPath)
        {
            Document document = new Document();
            try
            {
                PdfReader reader;
                PdfWriter writer = PdfWriter.GetInstance(document, new FileStream(targetPath, FileMode.Create));
                document.Open();
                PdfContentByte cb = writer.DirectContent;
                PdfImportedPage newPage;
                for (int i = 0; i < sourcPaths.Length; i++)
                {
                    reader = new PdfReader(sourcPaths[i]);
                    int iPageNum = reader.NumberOfPages;
                    for (int j = 1; j <= iPageNum; j++)
                    {
                        document.NewPage();
                        newPage = writer.GetImportedPage(reader, j);
                        cb.AddTemplate(newPage, 0, 0);
                    }
                }

                return true;
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                return false;
            }
            finally
            {
                document.Close();
            }
        }

        #region Draw Pdf Methods

        /// <summary>
        /// Add PdfTable into Document(Pdf File)
        /// </summary>
        /// <param name="doc">Document</param>
        /// <param name="table">PdfPTable</param>
        public static void AddPdfTable(Document doc, PdfPTable table)
        {
            doc.Add(table);
        }

        /// <summary>
        /// Add PdfPCell into PdfPTable
        /// Default Vertical Alignment is Bottom
        /// PaddingBottom fixed value is 3f
        /// </summary>
        /// <param name="fileLable">Lable</param>
        /// <param name="font">Font</param>
        /// <param name="pdfTable">PdfPTable</param>
        /// <param name="hAlign">Horizontal Alignment</param>
        public static void AddPdfCell(string fileLable, Font font, PdfPTable pdfTable, int? hAlign)
        {
            AddPdfCell(fileLable, font, pdfTable, hAlign, Rectangle.ALIGN_BOTTOM, 3f);
        }

        private static void AddPdfCell(string fileLable, Font font, PdfPTable pdfTable, int? hAlign, int? vAlign, float? paddingBottom)
        {
            PdfPCell pdfCell = new PdfPCell(new Paragraph(fileLable, font));

            pdfCell.Border = 0;
            pdfCell.HorizontalAlignment = hAlign.HasValue ? hAlign.Value : Rectangle.ALIGN_CENTER;
            pdfCell.VerticalAlignment = vAlign.HasValue ? vAlign.Value : Rectangle.ALIGN_MIDDLE;
            if (pdfCell.FixedHeight == 0f)
            {
                pdfCell.MinimumHeight = MIN_HEIGHT;
            }
            if (paddingBottom.HasValue)
            {
                pdfCell.PaddingBottom = paddingBottom.Value;
            }

            pdfTable.AddCell(pdfCell);
        }

        /// <summary>
        /// Add PdfPCell into PdfPTable
        /// Can custom PdfPCell property
        /// </summary>
        /// <param name="pdfCell">PdfPCell</param>
        /// <param name="pdfTable">PdfPTable</param>
        /// <param name="hAlign">Horizontal Alignment</param>
        /// <param name="vAlign">Vertical Alignment</param>
        public static void AddPdfCell(PdfPCell pdfCell, PdfPTable pdfTable, int? hAlign, int? vAlign)
        {
            if (pdfCell.FixedHeight == 0f)
            {
                pdfCell.MinimumHeight = MIN_HEIGHT;
            }
            
            pdfCell.Border = 0;
            pdfCell.HorizontalAlignment = hAlign.HasValue ? hAlign.Value : Rectangle.ALIGN_CENTER;
            pdfCell.VerticalAlignment = vAlign.HasValue ? vAlign.Value : Rectangle.ALIGN_MIDDLE;
            if (pdfCell.VerticalAlignment == Rectangle.ALIGN_BOTTOM)
            {
                pdfCell.PaddingBottom = 3f;
            }
            pdfTable.AddCell(pdfCell);
        }

        /// <summary>
        /// Add PdfPCell into PdfPTable, has UnderLine
        /// </summary>
        /// <param name="fileLable">Lable</param>
        /// <param name="font">Font</param>
        /// <param name="pdfTable">PdfPTable</param>
        /// <param name="hAlign">Horizontal Alignment</param>
        public static void AddPdfCellWithUnderLine(string fileLable, Font font, PdfPTable pdfTable, int? hAlign)
        {
            AddPdfCellWithUnderLine(fileLable, font, pdfTable, hAlign, null);
        }

        /// <summary>
        /// Add PdfPCell into PdfPTable, has UnderLine
        /// </summary>
        /// <param name="fileLable">Lable</param>
        /// <param name="font">Font</param>
        /// <param name="pdfTable">PdfPTable</param>
        /// <param name="hAlign">Horizontal Alignment</param>
        /// <param name="vAlign">Vertical Alignment</param>
        public static void AddPdfCellWithUnderLine(string fileLable, Font font, PdfPTable pdfTable, int? hAlign, int? vAlign)
        {
            PdfPCell pdfCell = new PdfPCell(new Paragraph(fileLable, font));
            pdfCell.Border = 0;
            pdfCell.BorderWidthRight = 0;
            pdfCell.BorderWidthLeft = 0;
            pdfCell.BorderWidthBottom = 1.0f;
            pdfCell.BorderWidthTop = 0;
            pdfCell.HorizontalAlignment = hAlign.HasValue ? hAlign.Value : Rectangle.ALIGN_CENTER;
            pdfCell.VerticalAlignment = vAlign.HasValue ? vAlign.Value : Rectangle.ALIGN_MIDDLE;
            if (pdfCell.FixedHeight == 0f)
            {
                pdfCell.MinimumHeight = MIN_HEIGHT;//行的最小高度
            } 
            if (pdfCell.VerticalAlignment == Rectangle.ALIGN_CENTER)
            {
                pdfCell.PaddingTop = 6f;
            }
            else if (pdfCell.VerticalAlignment == Rectangle.ALIGN_BOTTOM)
            {
                pdfCell.PaddingBottom = 3f;
            }
            pdfTable.AddCell(pdfCell);
        }

        /// <summary>
        /// Add PdfPCell into PdfPTable, has UnderLine
        /// Can custom PdfPCell property
        /// </summary>
        /// <param name="fileLable">Lable</param>
        /// <param name="font">Font</param>
        /// <param name="pdfTable">PdfPTable</param>
        /// <param name="hAlign">Horizontal Alignment</param>
        /// <param name="vAlign">Vertical Alignment</param>
        public static void AddPdfCellWithUnderLine(PdfPCell pdfCell, PdfPTable pdfTable, int? hAlign, int? vAlign)
        {
            pdfCell.Border = 0;
            pdfCell.BorderWidthRight = 0;
            pdfCell.BorderWidthLeft = 0;
            pdfCell.BorderWidthBottom = 1.0f;
            pdfCell.BorderWidthTop = 0;
            pdfCell.HorizontalAlignment = hAlign.HasValue ? hAlign.Value : Rectangle.ALIGN_CENTER;
            pdfCell.VerticalAlignment = hAlign.HasValue ? hAlign.Value : Rectangle.ALIGN_MIDDLE;
            pdfCell.PaddingTop = 6f;
            if (pdfCell.FixedHeight == 0f)
            {
                pdfCell.MinimumHeight = MIN_HEIGHT;//行的最小高度
            } 
            pdfTable.AddCell(pdfCell);
        }

        /// <summary>
        /// Add Empty PdfPCell into PdfPTable
        /// </summary>
        /// <param name="pdfTable">PdfPTable</param>
        public static void AddEmptyPdfCell(PdfPTable pdfTable)
        {
            PdfPCell pdfCell = new PdfPCell(new Paragraph(""));
            pdfCell.Border = 0;
            pdfTable.AddCell(pdfCell);
        }

        /// <summary>
        /// Describe PdfPCell
        /// </summary>
        /// <param name="fileLable">lable</param>
        /// <param name="font">Font</param>
        /// <param name="pdfTable">PdfPTable</param>
        /// <param name="colspan">colspan</param>
        public static void AddRemarkPdfCell(string fileLable, Font font, PdfPTable pdfTable, int colspan)
        {
            PdfPCell cell = new PdfPCell(new Paragraph(fileLable, font));
            cell.Border = 0;
            cell.PaddingLeft = 11f;
            cell.HorizontalAlignment = Rectangle.ALIGN_LEFT;
            cell.Colspan = colspan;
            if (cell.FixedHeight == 0f)
            {
                cell.MinimumHeight = MIN_HEIGHT;//行的最小高度
            } 
            pdfTable.AddCell(cell);
        }

        /// <summary>
        /// Init PdfPTable(Width is 100%, Horizontal Alignment is Center)
        /// </summary>
        /// <param name="pdfTable">PdfPTable</param>
        public static void InitPdfTableProperty(PdfPTable pdfTable)
        {
            pdfTable.WidthPercentage = 100;
            pdfTable.HorizontalAlignment = Rectangle.ALIGN_CENTER;
        }

        /// <summary>
        /// Add ImageCell into PdfPTable
        /// </summary>
        /// <param name="cell">PdfPCell</param>
        /// <param name="pdfTable">PdfPTable</param>
        public static void AddImageCell(PdfPCell cell, PdfPTable pdfTable)
        {
            pdfTable.AddCell(cell);
        }

        /// <summary>
        /// Get Checked Image Cell
        /// </summary>
        /// <returns></returns>
        public static PdfPCell GetYesSelectImageCell()
        {
            string noSelectSrc = new Page().Server.MapPath("\\resources\\images\\pdf\\Select.png");
            iTextSharp.text.Image imageNoSelect = iTextSharp.text.Image.GetInstance(noSelectSrc);
            imageNoSelect.ScaleAbsolute(15f, 15f);//图片缩放

            PdfPCell noSelectCell = new PdfPCell(imageNoSelect);
            noSelectCell.Border = 0;
            noSelectCell.HorizontalAlignment = Rectangle.ALIGN_RIGHT;
            noSelectCell.VerticalAlignment = Rectangle.ALIGN_BOTTOM;
            noSelectCell.PaddingTop = 3f;

            return noSelectCell;
        }

        /// <summary>
        /// Get Uncheck Image Cell
        /// </summary>
        /// <returns></returns>
        public static PdfPCell GetNoSelectImageCell()
        {
            string noSelectSrc = new Page().Server.MapPath("\\resources\\images\\pdf\\noSelect.png");
            iTextSharp.text.Image imageNoSelect = iTextSharp.text.Image.GetInstance(noSelectSrc);
            imageNoSelect.ScaleAbsolute(15f, 15f);//图片缩放

            PdfPCell noSelectCell = new PdfPCell(imageNoSelect);
            noSelectCell.Border = 0;
            noSelectCell.HorizontalAlignment = Rectangle.ALIGN_RIGHT;
            noSelectCell.VerticalAlignment = Rectangle.ALIGN_BOTTOM;
            noSelectCell.PaddingTop = 3f;

            return noSelectCell;
        }

        /// <summary>
        /// Get BscLogo Image Cell
        /// </summary>
        /// <returns></returns>
        public static PdfPCell GetBscLogoImageCell()
        {
            string imageSrc = new Page().Server.MapPath("\\resources\\images\\pdf\\bsc_logo.png");
            iTextSharp.text.Image image = iTextSharp.text.Image.GetInstance(imageSrc);
            image.ScaleAbsolute(100.8f, 36.4f);//图片缩放

            PdfPCell cellImage = new PdfPCell(image);
            cellImage.Border = 0;
            cellImage.PaddingBottom = 5f;
            cellImage.PaddingRight = 5f;
            cellImage.HorizontalAlignment = Rectangle.ALIGN_RIGHT;
            cellImage.VerticalAlignment = Rectangle.ALIGN_BOTTOM;

            return cellImage;
        }

        /// <summary>
        /// Get Bsc IAF Logo Image Cell
        /// </summary>
        /// <returns></returns>
        public static PdfPCell GetIAFBscLogoImageCell()
        {
            string imageSrc = new Page().Server.MapPath("\\resources\\images\\pdf\\bsc_logo.png");
            iTextSharp.text.Image image = iTextSharp.text.Image.GetInstance(imageSrc);
            image.ScaleAbsolute(100.8f, 36.4f);//图片缩放

            PdfPCell cellImage = new PdfPCell(image);
            cellImage.Border = 0;
            cellImage.PaddingBottom = 5f;
            cellImage.PaddingLeft = 5f;
            cellImage.HorizontalAlignment = Rectangle.ALIGN_LEFT;
            cellImage.VerticalAlignment = Rectangle.ALIGN_BOTTOM;

            return cellImage;
        }

        #region Table Form
        public static void AddPdfCellHasBorder(PdfPCell pdfCell, PdfPTable pdfTable, float? borderWidth, int? hAlign, int? vAlign)
        {
            pdfCell.BorderColor = BaseColor.BLACK;
            pdfCell.BorderWidth = borderWidth.HasValue ? borderWidth.Value : 0.3f;
            pdfCell.HorizontalAlignment = hAlign.HasValue ? hAlign.Value : Rectangle.ALIGN_CENTER;
            pdfCell.VerticalAlignment = vAlign.HasValue ? vAlign.Value : Rectangle.ALIGN_MIDDLE;
            if (pdfCell.FixedHeight == 0f)
            {
                pdfCell.MinimumHeight = MIN_HEIGHT;//行的最小高度
            } 
            if (pdfCell.VerticalAlignment == Rectangle.ALIGN_BOTTOM)
            {
                pdfCell.PaddingBottom = 3f;
            }
            pdfTable.AddCell(pdfCell);
        }

        public static void AddPdfCellHasBorder(PdfPCell pdfCell, PdfPTable pdfTable, int? hAlign, int? vAlign)
        {
            pdfCell.HorizontalAlignment = hAlign.HasValue ? hAlign.Value : Rectangle.ALIGN_CENTER;
            pdfCell.VerticalAlignment = vAlign.HasValue ? vAlign.Value : Rectangle.ALIGN_MIDDLE;
            if (pdfCell.FixedHeight == 0f)
            {
                pdfCell.MinimumHeight = MIN_HEIGHT;//行的最小高度
            } 
            if (pdfCell.VerticalAlignment == Rectangle.ALIGN_BOTTOM)
            {
                pdfCell.PaddingBottom = 3f;
            }
            pdfTable.AddCell(pdfCell);
        }

        public static void AddPdfCellHasBorderTopLeft(PdfPCell pdfCell, PdfPTable pdfTable, int? hAlign, int? vAlign, bool onlyShowBorder)
        {
            pdfCell.BorderWidthLeft = 1f;
            pdfCell.BorderWidthTop = 1f;
            pdfCell.BorderWidthRight = 0f;
            pdfCell.BorderWidthBottom = onlyShowBorder ? 0f : 0.6f;

            pdfCell.BorderColorLeft = PdfHelper.blueColor;
            pdfCell.BorderColorTop = PdfHelper.blueColor;
            pdfCell.BorderColorRight = BaseColor.BLACK;
            pdfCell.BorderColorBottom = BaseColor.BLACK;

            pdfCell.HorizontalAlignment = hAlign.HasValue ? hAlign.Value : Rectangle.ALIGN_CENTER;
            pdfCell.VerticalAlignment = vAlign.HasValue ? vAlign.Value : Rectangle.ALIGN_MIDDLE;
            if (pdfCell.FixedHeight == 0f)
            {
                pdfCell.MinimumHeight = MIN_HEIGHT;//行的最小高度
            } 
            if (pdfCell.VerticalAlignment == Rectangle.ALIGN_BOTTOM)
            {
                pdfCell.PaddingBottom = 3f;
            }
            pdfTable.AddCell(pdfCell);
        }

        public static void AddPdfCellHasBorderTopRight(PdfPCell pdfCell, PdfPTable pdfTable, int? hAlign, int? vAlign, bool onlyShowBorder)
        {
            pdfCell.BorderWidthLeft = onlyShowBorder ? 0f : 0.6f;
            pdfCell.BorderWidthTop = 1f;
            pdfCell.BorderWidthRight = 1f;
            pdfCell.BorderWidthBottom = onlyShowBorder ? 0f : 0.6f;

            pdfCell.BorderColorLeft = BaseColor.BLACK;
            pdfCell.BorderColorTop = PdfHelper.blueColor;
            pdfCell.BorderColorRight = PdfHelper.blueColor;
            pdfCell.BorderColorBottom = BaseColor.BLACK;

            pdfCell.HorizontalAlignment = hAlign.HasValue ? hAlign.Value : Rectangle.ALIGN_CENTER;
            pdfCell.VerticalAlignment = vAlign.HasValue ? vAlign.Value : Rectangle.ALIGN_MIDDLE;
            if (pdfCell.FixedHeight == 0f)
            {
                pdfCell.MinimumHeight = MIN_HEIGHT;//行的最小高度
            } 
            if (pdfCell.VerticalAlignment == Rectangle.ALIGN_BOTTOM)
            {
                pdfCell.PaddingBottom = 3f;
            }
            pdfTable.AddCell(pdfCell);
        }

        public static void AddPdfCellHasBorderBottomLeft(PdfPCell pdfCell, PdfPTable pdfTable, int? hAlign, int? vAlign, bool onlyShowBorder)
        {
            pdfCell.BorderWidthLeft = 1f;
            pdfCell.BorderWidthTop = 0f;
            pdfCell.BorderWidthRight = 0f;
            pdfCell.BorderWidthBottom = 1f;

            pdfCell.BorderColorLeft = PdfHelper.blueColor;
            pdfCell.BorderColorTop = BaseColor.BLACK;
            pdfCell.BorderColorRight = BaseColor.BLACK;
            pdfCell.BorderColorBottom = PdfHelper.blueColor;

            pdfCell.HorizontalAlignment = hAlign.HasValue ? hAlign.Value : Rectangle.ALIGN_CENTER;
            pdfCell.VerticalAlignment = vAlign.HasValue ? vAlign.Value : Rectangle.ALIGN_MIDDLE;
            if (pdfCell.FixedHeight == 0f)
            {
                pdfCell.MinimumHeight = MIN_HEIGHT;//行的最小高度
            } 
            if (pdfCell.VerticalAlignment == Rectangle.ALIGN_BOTTOM)
            {
                pdfCell.PaddingBottom = 3f;
            }
            pdfTable.AddCell(pdfCell);
        }

        public static void AddPdfCellHasBorderBottomRight(PdfPCell pdfCell, PdfPTable pdfTable, int? hAlign, int? vAlign, bool onlyShowBorder)
        {
            pdfCell.BorderWidthLeft = onlyShowBorder ? 0f : 0.6f;
            pdfCell.BorderWidthTop = 0;
            pdfCell.BorderWidthRight = 1f;
            pdfCell.BorderWidthBottom = 1f;

            pdfCell.BorderColorLeft = BaseColor.BLACK;
            pdfCell.BorderColorTop = BaseColor.BLACK;
            pdfCell.BorderColorRight = PdfHelper.blueColor;
            pdfCell.BorderColorBottom = PdfHelper.blueColor;

            pdfCell.HorizontalAlignment = hAlign.HasValue ? hAlign.Value : Rectangle.ALIGN_CENTER;
            pdfCell.VerticalAlignment = vAlign.HasValue ? vAlign.Value : Rectangle.ALIGN_MIDDLE;
            if (pdfCell.FixedHeight == 0f)
            {
                pdfCell.MinimumHeight = MIN_HEIGHT;//行的最小高度
            } 
            if (pdfCell.VerticalAlignment == Rectangle.ALIGN_BOTTOM)
            {
                pdfCell.PaddingBottom = 3f;
            }
            pdfTable.AddCell(pdfCell);
        }

        public static void AddPdfCellHasBorderLeft(PdfPCell pdfCell, PdfPTable pdfTable, int? hAlign, int? vAlign, bool onlyShowBorder)
        {
            pdfCell.BorderWidthLeft = 1f;
            pdfCell.BorderWidthTop = 0f;
            pdfCell.BorderWidthRight = 0f;
            pdfCell.BorderWidthBottom = onlyShowBorder ? 0f : 0.6f;

            pdfCell.BorderColorLeft = PdfHelper.blueColor;
            pdfCell.BorderColorTop = BaseColor.BLACK;
            pdfCell.BorderColorRight = BaseColor.BLACK;
            pdfCell.BorderColorBottom = BaseColor.BLACK;

            pdfCell.HorizontalAlignment = hAlign.HasValue ? hAlign.Value : Rectangle.ALIGN_CENTER;
            pdfCell.VerticalAlignment = vAlign.HasValue ? vAlign.Value : Rectangle.ALIGN_MIDDLE;
            if (pdfCell.FixedHeight == 0f)
            {
                pdfCell.MinimumHeight = MIN_HEIGHT;//行的最小高度
            } 
            if (pdfCell.VerticalAlignment == Rectangle.ALIGN_BOTTOM)
            {
                pdfCell.PaddingBottom = 3f;
            }
            pdfTable.AddCell(pdfCell);
        }

        public static void AddPdfCellHasBorderTop(PdfPCell pdfCell, PdfPTable pdfTable, int? hAlign, int? vAlign, bool onlyShowBorder)
        {
            pdfCell.BorderWidthLeft = onlyShowBorder ? 0f : 0.6f;
            pdfCell.BorderWidthTop = 1f;
            pdfCell.BorderWidthRight = 0f;
            pdfCell.BorderWidthBottom = onlyShowBorder ? 0f : 0.6f;

            pdfCell.BorderColorLeft = BaseColor.BLACK;
            pdfCell.BorderColorTop = PdfHelper.blueColor;
            pdfCell.BorderColorRight = BaseColor.BLACK;
            pdfCell.BorderColorBottom = BaseColor.BLACK;

            pdfCell.HorizontalAlignment = hAlign.HasValue ? hAlign.Value : Rectangle.ALIGN_CENTER;
            pdfCell.VerticalAlignment = vAlign.HasValue ? vAlign.Value : Rectangle.ALIGN_MIDDLE;
            if (pdfCell.FixedHeight == 0f)
            {
                pdfCell.MinimumHeight = MIN_HEIGHT;//行的最小高度
            } 
            if (pdfCell.VerticalAlignment == Rectangle.ALIGN_BOTTOM)
            {
                pdfCell.PaddingBottom = 3f;
            }
            pdfTable.AddCell(pdfCell);
        }

        public static void AddPdfCellHasBorderRight(PdfPCell pdfCell, PdfPTable pdfTable, int? hAlign, int? vAlign, bool onlyShowBorder)
        {
            pdfCell.BorderWidthLeft = onlyShowBorder ? 0f : 0.6f;
            pdfCell.BorderWidthTop = 0f;
            pdfCell.BorderWidthRight = 1f;
            pdfCell.BorderWidthBottom = onlyShowBorder ? 0f : 0.6f;

            pdfCell.BorderColorLeft = BaseColor.BLACK;
            pdfCell.BorderColorTop = BaseColor.BLACK;
            pdfCell.BorderColorRight = PdfHelper.blueColor;
            pdfCell.BorderColorBottom = BaseColor.BLACK;

            pdfCell.HorizontalAlignment = hAlign.HasValue ? hAlign.Value : Rectangle.ALIGN_CENTER;
            pdfCell.VerticalAlignment = vAlign.HasValue ? vAlign.Value : Rectangle.ALIGN_MIDDLE;
            if (pdfCell.FixedHeight == 0f)
            {
                pdfCell.MinimumHeight = MIN_HEIGHT;//行的最小高度
            } 
            if (pdfCell.VerticalAlignment == Rectangle.ALIGN_BOTTOM)
            {
                pdfCell.PaddingBottom = 3f;
            }
            pdfTable.AddCell(pdfCell);
        }

        public static void AddPdfCellHasBorderBottom(PdfPCell pdfCell, PdfPTable pdfTable, int? hAlign, int? vAlign, bool onlyShowBorder)
        {
            pdfCell.BorderWidthLeft = onlyShowBorder ? 0f : 0.6f;
            pdfCell.BorderWidthTop = 0f;
            pdfCell.BorderWidthRight = 0f;
            pdfCell.BorderWidthBottom = 1f;

            pdfCell.BorderColorLeft = BaseColor.BLACK;
            pdfCell.BorderColorTop = BaseColor.BLACK;
            pdfCell.BorderColorRight = BaseColor.BLACK;
            pdfCell.BorderColorBottom = PdfHelper.blueColor;

            pdfCell.HorizontalAlignment = hAlign.HasValue ? hAlign.Value : Rectangle.ALIGN_CENTER;
            pdfCell.VerticalAlignment = vAlign.HasValue ? vAlign.Value : Rectangle.ALIGN_MIDDLE;
            if (pdfCell.FixedHeight == 0f)
            {
                pdfCell.MinimumHeight = MIN_HEIGHT;//行的最小高度
            } 
            if (pdfCell.VerticalAlignment == Rectangle.ALIGN_BOTTOM)
            {
                pdfCell.PaddingBottom = 3f;
            }
            pdfTable.AddCell(pdfCell);
        }

        public static void AddPdfCellHasBorderCenter(PdfPCell pdfCell, PdfPTable pdfTable, int? hAlign, int? vAlign, bool onlyShowBorder)
        {
            pdfCell.BorderWidthLeft = onlyShowBorder ? 0f : 0.6f;
            pdfCell.BorderWidthTop = 0;
            pdfCell.BorderWidthRight = 0f;
            pdfCell.BorderWidthBottom = onlyShowBorder ? 0f : 0.6f;

            pdfCell.BorderColorLeft = BaseColor.BLACK;
            pdfCell.BorderColorTop = BaseColor.BLACK;
            pdfCell.BorderColorRight = BaseColor.BLACK;
            pdfCell.BorderColorBottom = BaseColor.BLACK;

            pdfCell.HorizontalAlignment = hAlign.HasValue ? hAlign.Value : Rectangle.ALIGN_CENTER;
            pdfCell.VerticalAlignment = vAlign.HasValue ? vAlign.Value : Rectangle.ALIGN_MIDDLE;
            if (pdfCell.FixedHeight == 0f)
            {
                pdfCell.MinimumHeight = MIN_HEIGHT;//行的最小高度
            } 
            if (pdfCell.VerticalAlignment == Rectangle.ALIGN_BOTTOM)
            {
                pdfCell.PaddingBottom = 3f;
            }
            pdfTable.AddCell(pdfCell);
        }

        public static void AddPdfCellHasBorderNormal(PdfPCell pdfCell, PdfPTable pdfTable, int? hAlign, int? vAlign, bool showTop, bool showRight, bool showBottom, bool showLeft)
        {
            pdfCell.BorderWidthLeft = showLeft ? 0.6f : 0f;
            pdfCell.BorderWidthTop = showTop ? 0.6f : 0f;
            pdfCell.BorderWidthRight = showRight ? 0.6f : 0f;
            pdfCell.BorderWidthBottom = showBottom ? 0.6f : 0f;

            pdfCell.BorderColorLeft = BaseColor.BLACK;
            pdfCell.BorderColorTop = BaseColor.BLACK;
            pdfCell.BorderColorRight = BaseColor.BLACK;
            pdfCell.BorderColorBottom = BaseColor.BLACK;

            pdfCell.HorizontalAlignment = hAlign.HasValue ? hAlign.Value : Rectangle.ALIGN_CENTER;
            pdfCell.VerticalAlignment = vAlign.HasValue ? vAlign.Value : Rectangle.ALIGN_MIDDLE;

            if (pdfCell.FixedHeight == 0f)
            {
                pdfCell.MinimumHeight = MIN_HEIGHT;
            }

            if (pdfCell.VerticalAlignment == Rectangle.ALIGN_BOTTOM)
            {
                pdfCell.PaddingBottom = 3f;
            }
            pdfTable.AddCell(pdfCell);
        }
        #endregion
        #endregion

        /// <summary>
        /// 注册中文字库
        /// </summary>
        public static void RegisterChineseFont()
        {
            string fontPath = System.Web.HttpContext.Current.Server.MapPath(@".\");

            FontFactory.Register(fontPath + @"\..\..\resources\Font\ARLRDBD.TTF");
            FontFactory.Register(fontPath + @"\..\..\resources\Font\ARIALUNI.TTF");
            FontFactory.Register(fontPath + @"\..\..\resources\Font\simhei.ttf");
            FontFactory.Register(fontPath + @"\..\..\resources\Font\simsun.ttc");
            FontFactory.Register(fontPath + @"\..\..\resources\Font\mingliu.ttc");

        }

      
    }
}
