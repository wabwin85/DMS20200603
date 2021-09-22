using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.IO;

namespace DMS.Website.Common
{
    /// <summary>
    /// UploadFileHandler 的摘要说明
    /// </summary>
    public class UploadFileHandler : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            try
            {
                if (context.Request.QueryString["UploadType"] != null)
                {
                    string UploadType = context.Request.QueryString["UploadType"];
                    string UploadFileUrl = string.Empty;
                    switch (UploadType)
                    {
                        case "ShipmentInvoice":
                            UploadShipmentInvoiceFile(context);
                            break;
                        default:
                            context.Response.Write("Not Set UploadType Function!");
                            break;
                    }
                }
                else
                {
                    context.Response.Write("Not Set UploadType Value!");
                }
            }
            catch (Exception ex)
            {
                context.Response.StatusCode = 500;
                context.Response.Write(ex.Message);
                context.Response.End();
            }
            finally
            {
                context.Response.End();
            }
        }

        #region 销售出库单发票批量上传
        private void UploadShipmentInvoiceFile(HttpContext context)
        {
            HttpPostedFile file;
            for (int i = 0; i < context.Request.Files.Count; ++i)
            {
                file = context.Request.Files[i];
                if (file == null || file.ContentLength == 0 || string.IsNullOrEmpty(file.FileName)) continue;
                string filename = DateTime.Now.ToString("yyyyMMddHHmmss") + "_" + RndNumStr(9) + Path.GetExtension(file.FileName);

                /********************文件夹**************************/

                file.SaveAs(HttpContext.Current.Server.MapPath("/Upload/UploadFile/ShipmentAttachment/" + filename));
                context.Response.Write("/Upload/UploadFile/ShipmentAttachment/" + filename);
            }
        }
        #endregion

        #region 该方法用于生成指定位数的随机字符串
        /// <summary>
        /// 该方法用于生成指定位数的随机字符串
        /// </summary>
        /// <param name="VcodeNum">参数是随机数的位数</param>
        /// <returns>返回一个随机数字符串</returns>
        public static string RndNumStr(int VcodeNum)
        {
            string[] source = { "0", "1", "1", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z" };

            string checkCode = String.Empty;
            Random random = new Random();
            for (int i = 0; i < VcodeNum; i++)
            {
                checkCode += source[random.Next(0, source.Length)];

            }
            return checkCode;
        }
        #endregion

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}