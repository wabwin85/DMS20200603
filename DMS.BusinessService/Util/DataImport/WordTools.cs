using iTextSharp.text.pdf;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;

namespace DMS.BusinessService.Util.DataImport
{
    public class WordTools
    {
        public static void AddWaterMark(string imgName, string srcFileName)
        {
            PdfReader pdfReader = null;
            PdfStamper pdfStamper = null;
            FileStream outputStream = null;
            try
            {
                pdfReader = new PdfReader(srcFileName);
                int numberOfPages = pdfReader.NumberOfPages;
                outputStream = new FileStream(srcFileName.Replace(".pdf", "_output.pdf"), FileMode.Create);
                pdfStamper = new PdfStamper(pdfReader, outputStream);
                PdfContentByte waterMarkContent;

                iTextSharp.text.Image image = null;
                image = iTextSharp.text.Image.GetInstance(imgName);
                image.SetAbsolutePosition(0, 0);
                image.ScalePercent(70);
                for (int i = 1; i <= numberOfPages; i++)
                {
                    waterMarkContent = pdfStamper.GetUnderContent(i);
                    waterMarkContent.AddImage(image);
                }
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
                if (outputStream != null)
                    outputStream.Close();
            }
        }
    }
}
