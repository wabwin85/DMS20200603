using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;

namespace DMS.Common.Common
{
    public class HtmlHelper
    {
        #region 通过StringBuilder替换
        private const string tdStyle = "<td style=\"border-style: solid; border-width: 0 0 1px 1px; border-color: #c5c5c5;padding: 2px 7px;line-height: 20px;overflow: hidden;vertical-align: middle;text-overflow: ellipsis;white-space: nowrap;\">";
        private const string CONST_DMS_HTML_KEY_WORD = "[#DMS.HTML.{0}#]";

        /// <summary>
        /// 获取模板HTML信息
        /// </summary>
        /// <param name="tempName"></param>
        /// <param name="tempType"></param>
        /// <returns></returns>
        public StringBuilder GetDmsTemplateHtml(string tempName, DmsTemplateHtmlType tempType)
        {
            if (tempType == DmsTemplateHtmlType.Email)
                tempName = tempName + "_Email";

            string filePath = new Page().Server.MapPath("~") + "\\HTML\\module\\" + tempName + ".html";
            string fileContent;
            using (var reader = new StreamReader(filePath))
            {
                fileContent = reader.ReadToEnd();
            }

            return new StringBuilder(fileContent);
        }

        /// <summary>
        /// 根据字符串生成HTML
        /// </summary>
        /// <param name="htmlFileName"></param>
        /// <param name="htmlContent"></param>
        /// <returns></returns>
        public String CreateHtml(String htmlFileName, StringBuilder htmlContent)
        {
            try
            {
                string htmlName = htmlFileName + "_" + DateTime.Now.ToFileTime() + ".html";
                string strFile = new Page().Server.MapPath("~") + "\\HTML\\temp\\" + htmlName;
                if (File.Exists(strFile))
                    File.Delete(strFile);

                UTF8Encoding utf8 = new UTF8Encoding(false);

                StreamWriter sw = new StreamWriter(strFile, false, utf8);
                sw.WriteLine(htmlContent);
                sw.Close();
                sw.Dispose();

                Random sr = new Random();

                return htmlName + "?V=" + sr.Next().ToString();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// 根据字典表中Key+Value替换HTML模板中的信息
        /// </summary>
        /// <param name="htmlContent"></param>
        /// <param name="dict"></param>
        /// <returns></returns>
        public StringBuilder SetHtmlContentByKeyValue(StringBuilder htmlContent, Dictionary<string, string> dict)
        {
            foreach (var d in dict)
            {
                htmlContent.Replace(string.Format(CONST_DMS_HTML_KEY_WORD, d.Key), d.Value);
            }

            return htmlContent;
        }

        /// <summary>
        /// 根据DataTable中第一行的信息ColumnName+Value替换HTML模板中的信息
        /// </summary>
        /// <param name="htmlContent"></param>
        /// <param name="dt"></param>
        /// <returns></returns>
        public StringBuilder SetHtmlContentByKeyValue(StringBuilder htmlContent, DataTable dt)
        {
            foreach (DataRow dr in dt.Rows)
            {
                for (int i = 0; i < dt.Columns.Count; i++)
                {
                    htmlContent.Replace(string.Format(CONST_DMS_HTML_KEY_WORD, dt.Columns[i].ColumnName)
                        , dt.Rows[0][dt.Columns[i].ColumnName] == null 
                            ? string.Empty 
                            : dt.Rows[0][dt.Columns[i].ColumnName].ToString());
                }
            }

            return htmlContent;
        }
        
        /// <summary>
        /// 根据DataTable中信息拼接成TR+TD替换HTML模板中的信息
        /// </summary>
        /// <param name="htmlContent"></param>
        /// <param name="dt"></param>
        /// <returns></returns>
        public StringBuilder SetHtmlContentByDataTable(StringBuilder htmlContent, DataTable dt)
        {
            StringBuilder dtContent = new StringBuilder();

            foreach (DataRow dr in dt.Rows)
            {
                dtContent.Append("<tr>");

                for (int i = 0; i < dt.Columns.Count; i++)
                {
                    dtContent.Append("<td style=\"border-style: solid; border-width: 0 0 1px 1px; border-color: #c5c5c5;padding: 2px 7px;line-height: 20px;overflow: hidden;vertical-align: middle;text-overflow: ellipsis;white-space: nowrap;\">");
                    dtContent.Append(dr[i] == null ? string.Empty : dr[i].ToString());
                    dtContent.Append("</td>");
                }

                dtContent.Append("</tr>");
            }

            htmlContent.Replace(string.Format(CONST_DMS_HTML_KEY_WORD, dt.TableName), dtContent.ToString());

            return htmlContent;
        }

        /// <summary>
        /// 附件公用方法
        /// </summary>
        /// <param name="htmlContent"></param>
        /// <param name="dt"></param>
        /// <param name="downType"></param>
        /// <returns></returns>
        public StringBuilder SetHtmlForAttachmentByDataTable(StringBuilder htmlContent, DataTable dt, string downType)
        {
            StringBuilder dtContent = new StringBuilder();
            string scheme = HttpContext.Current.Request.Url.Scheme;
            string authority = HttpContext.Current.Request.Url.Authority;

            foreach (DataRow dr in dt.Rows)
            {
                dtContent.Append("<tr>");
                dtContent.Append(tdStyle);
                dtContent.Append(dr["row_number"] == null ? string.Empty : dr["row_number"].ToString());
                dtContent.Append("</td>");
                dtContent.Append(tdStyle);
                dtContent.AppendFormat("<a href=\"{0}://{1}/Pages/Download.aspx?downloadname={2}&filename={3}&downtype={4}\" target=\"_blank\" >"
                        , scheme
                        , authority
                        , HttpUtility.UrlDecode(dr["Name"].ToString())
                        , HttpUtility.UrlDecode(dr["Url"].ToString())
                        , downType);
                dtContent.Append(dr["Name"] == null ? string.Empty : dr["Name"].ToString());
                dtContent.Append("</a>");
                dtContent.Append("</td>");
                dtContent.Append(tdStyle);
                dtContent.Append(dr["TypeName"] == null ? string.Empty : dr["TypeName"].ToString());
                dtContent.Append("</td>");
                dtContent.Append(tdStyle);
                dtContent.Append(dr["Identity_Name"] == null ? string.Empty : dr["Identity_Name"].ToString());
                dtContent.Append("</td>");
                dtContent.Append(tdStyle);
                dtContent.Append(dr["UploadDate"] == null ? string.Empty : dr["UploadDate"].ToString());
                dtContent.Append("</td>");
                dtContent.Append("</tr>");
            }

            htmlContent.Replace(string.Format(CONST_DMS_HTML_KEY_WORD, dt.TableName), dtContent.ToString());

            return htmlContent;
        }

        public void SetColumnIndexAndRemoveColumn(DataTable dt, Dictionary<string, string> listColumnNames)
        {
            List<string> listRemoveColumns = new List<string>();
            for (int i = 0; i < dt.Columns.Count; i++)
            {
                string strRemoveColumnName = dt.Columns[i].ColumnName;
                if (!listColumnNames.ContainsKey(strRemoveColumnName))
                {
                    listRemoveColumns.Add(strRemoveColumnName);
                }
            }
            RemoveColumn(dt, listRemoveColumns);

            int j = 0;
            foreach (var listColumnName in listColumnNames)
            {
                string strColumnName = listColumnName.Key;
                if (dt.Columns.Contains(strColumnName))
                {
                    dt.Columns[strColumnName].SetOrdinal(j);
                    dt.Columns[strColumnName].ColumnName = listColumnName.Value;
                    j++;
                }
            }
        }

        public void SetColumnIndexAndRemoveColumn(DataTable dt, string[] listColumnNames)
        {
            List<string> listRemoveColumns = new List<string>();
            for (int i = 0; i < dt.Columns.Count; i++)
            {
                string strRemoveColumnName = dt.Columns[i].ColumnName;
                if (!listColumnNames.Contains(strRemoveColumnName))
                {
                    listRemoveColumns.Add(strRemoveColumnName);
                }
            }
            RemoveColumn(dt, listRemoveColumns);

            int j = 0;
            foreach (var listColumnName in listColumnNames)
            {
                string strColumnName = listColumnName;
                if (dt.Columns.Contains(strColumnName))
                {
                    dt.Columns[strColumnName].SetOrdinal(j);
                    j++;
                }
            }
        }

        public void RemoveColumn(DataTable dt, List<string> listColumnNames)
        {
            foreach (string strColumnName in listColumnNames)
            {
                if (dt.Columns.Contains(strColumnName))
                {
                    dt.Columns.Remove(strColumnName);
                }
            }
        }

        #endregion

        #region 通过正则替换
        private const string REGEX_FOREACH = @"#\{foreach\((.*?)\)}(.*?)#\{end}";
        private const string REGEX_VAR = @"#\{(.*?)}";
        
        private static MatchCollection Matches(string input, string regex, RegexOptions options)
        {
            Regex r = new Regex(regex, options);
            return r.Matches(input);
        }

        private static string Load(string path)
        {
            using (StreamReader reader = new StreamReader(path, System.Text.Encoding.UTF8))
            {
                return reader.ReadToEnd();
            }
        }

        private static string HandleVariable(string input, DataSet ds)
        {
            MatchCollection mc = Matches(input, REGEX_VAR, RegexOptions.None);

            foreach (Match m in mc)
            {
                System.Diagnostics.Debug.WriteLine(m.Groups[1].ToString());
                string[] arr = m.Groups[1].ToString().Split(new char[] { '.' }, StringSplitOptions.RemoveEmptyEntries);

                try
                {

                    input = input.Replace(m.ToString(), ds.Tables[arr[0]].Rows[0][arr[1]] == DBNull.Value ? string.Empty : ds.Tables[arr[0]].Rows[0][arr[1]].ToString());
                }
                catch (Exception ex)
                {
                    throw new Exception(arr[1] + " not found");
                }
            }

            return input;
        }

        private static string HandleForeach(string input, DataSet ds)
        {
            MatchCollection mc = Matches(input, REGEX_FOREACH, RegexOptions.Singleline);

            foreach (Match m in mc)
            {
                string tablename = m.Groups[1].ToString();
                string template = m.Groups[2].ToString();

                MatchCollection tmc = Matches(template, REGEX_VAR, RegexOptions.None);

                StringBuilder html = new StringBuilder();
                foreach (DataRow row in ds.Tables[tablename].Rows)
                {
                    string result = template;
                    foreach (Match tm in tmc)
                    {
                        if (ds.Tables[tablename].Columns.Contains(tm.Groups[1].ToString()))
                        {
                            result = result.Replace(tm.ToString(), row[tm.Groups[1].ToString()] == DBNull.Value ? string.Empty : row[tm.Groups[1].ToString()].ToString());
                        }
                    }
                    html.Append(result);
                }


                input = input.Replace(m.ToString(), html.ToString());
            }

            return input;
        }

        public static string Create(string templatePath, DataSet ds)
        {

            string input = Load(templatePath);

            input = HandleForeach(input, ds);
            input = HandleVariable(input, ds);

            return input;
        }

        #endregion

        public static bool IsMobile()
        {
            Regex b = new Regex(@"android.+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|symbian|treo|up\.(browser|link)|vodafone|wap|windows (ce|phone)|xda|xiino", RegexOptions.IgnoreCase | RegexOptions.Multiline);
            Regex v = new Regex(@"1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(di|rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-", RegexOptions.IgnoreCase | RegexOptions.Multiline);
            //string os = "mozilla|m3gate|winwap|openwave|Windows NT|Windows 3.1|95|Blackcomb|98|ME|X Window|Longhorn|ubuntu|AIX|Linux|AmigaOS|BEOS|HP-UX|OpenBSD|FreeBSD|NetBSD|OS/2|OSF1|SUN";
            string userAgent = HttpContext.Current.Request.ServerVariables["HTTP_USER_AGENT"];

            if (!(b.IsMatch(userAgent) || v.IsMatch(userAgent.Substring(0, 4))))
            {
                return false;
            }
            else
            {
                return true;
            }
            //return !reg.IsMatch(userAgent);
        }

        public static bool IsWeChat()
        {
            return HttpContext.Current.Request.UserAgent.ToLower().Contains("micromessenger");
        }
    }

    public enum DmsTemplateHtmlType
    {
        /// <summary>
        /// 用于常规的HTML（模板）
        /// </summary>
        Normal,
        /// <summary>
        /// 用于EMAIL的HTML（模板）
        /// </summary>
        Email
    }
}
