using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

using System.Xml;
using System.Xml.Xsl;

namespace DMS.Website.Common
{
    public static class BaseFunction
    {



        public static bool DiffDate(DateTime StartDate, DateTime EndDate, string DiffType, int div)
        {
            bool isOK = false;

            if (DateTime.Compare(EndDate, StartDate) >= 0)
            {

                if (DiffType.Equals("Month"))
                {
                    StartDate = StartDate.AddMonths(div);
                }

                if (DateTime.Compare(EndDate, StartDate) <= 0)
                {
                    isOK = true;
                }
            }

            return isOK ;
        }

        public static void Export(HttpResponse Response, HttpServerUtility Server, XmlNode xml, string format, string filename)
        {
            Response.Clear();

            if (string.IsNullOrEmpty(filename))
            {
                filename = "submittedData";
            }

            switch (format)
            {
                case "xml":
                    string strXml = xml.OuterXml;
                    Response.AddHeader("Content-Disposition", "attachment; filename=" + filename + ".xml");
                    Response.AddHeader("Content-Length", strXml.Length.ToString());
                    Response.ContentType = "application/xml";
                    Response.Write(strXml);
                    break;

                case "xls":
                    Response.ContentType = "application/vnd.ms-excel";
                    Response.AddHeader("Content-Disposition", "attachment; filename=" + filename + ".xls");
                    XslCompiledTransform xtExcel = new XslCompiledTransform();
                    xtExcel.Load(Server.MapPath("/resources/Excel.xsl"));
                    xtExcel.Transform(xml, null, Response.OutputStream);

                    break;

                case "csv":
                    Response.ContentType = "application/octet-stream";
                    Response.AddHeader("Content-Disposition", "attachment; filename=" + filename + ".csv");
                    XslCompiledTransform xtCsv = new XslCompiledTransform();
                    xtCsv.Load(Server.MapPath("/resources/Csv.xsl"));
                    xtCsv.Transform(xml, null, Response.OutputStream);

                    break;
            }

            Response.End();
        }
    }
}
