using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System.Net;
using System.Web;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace DMS.WeChatServer.Common
{
    public static class CommonHelper
    {
        public static string Serialize(object data)
        {
            JsonSerializerSettings settings = new JsonSerializerSettings
            {
                ReferenceLoopHandling = ReferenceLoopHandling.Ignore
            };
            IsoDateTimeConverter timeConverter = new IsoDateTimeConverter { DateTimeFormat = "yyyy'-'MM'-'dd HH':'mm':'ss" };
            settings.Converters.Add(timeConverter);
            return JsonConvert.SerializeObject(data, Formatting.None, settings);
        }

        public static T Deserialize<T>(string jsongstring)
        {
            return JsonConvert.DeserializeObject<T>(jsongstring);
        }

        public static string GetDecryptParameters(string key)
        {
            string strResult = key;
            strResult = EncryptHelper.getAESDecrypt(Config.Key, Config.Iv, strResult);
            return strResult;
        }

        public static string WriteLog(String message, bool isForWinForm = false)
        {
            try
            {
                string filePath = string.Empty;
                if (isForWinForm)
                {
                    filePath = System.Environment.CurrentDirectory;
                }
                else
                {
                    try
                    {
                        filePath = System.Web.HttpContext.Current.Request.PhysicalApplicationPath;
                    }
                    catch (Exception e)
                    {
                        filePath = System.Environment.CurrentDirectory;
                    }
                }
                filePath += "/Logs";
                string fileName = string.Format("{0:yyyy-MM-dd}", DateTime.Now) + ".txt";
                FileInfo fi = new FileInfo(filePath + "\\" + fileName);
                StreamWriter sw = null;
                if (!fi.Exists)
                {
                    if (!Directory.Exists(filePath))
                    {
                        Directory.CreateDirectory(filePath);
                    }
                    sw = fi.CreateText();
                }
                else
                {
                    sw = fi.AppendText();
                }
                sw.WriteLine(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") +
                             "Begin----------------------------------------------");
                sw.WriteLine(message);
                sw.WriteLine("End----------------------------------------------");
                sw.Close();

                Console.WriteLine(message);

                return string.Empty;
            }
            catch (Exception exception)
            {
                return exception.Message;
            }
        }

        public static byte[] Compress(byte[] bytes)
        {
            using (MemoryStream memoryStream = new MemoryStream())
            {
                GZipStream gZipStreamCompress = new GZipStream(memoryStream, CompressionMode.Compress);
                gZipStreamCompress.Write(bytes, 0, bytes.Length);
                gZipStreamCompress.Close();
                return memoryStream.ToArray();
            }
        }

        public static bool IsRemoteFileExists(string strFileUrl)
        {
            bool result = false;
            HttpWebResponse response = null;
            try
            {
                HttpWebRequest request = (HttpWebRequest)WebRequest.Create(strFileUrl);
                request.KeepAlive = false;
                request.Method = "GET";
                request.UserAgent = "Mozilla/5.0 (Windows NT 5.1; rv:19.0) Gecko/20100101 Firefox/19.0";
                request.ServicePoint.Expect100Continue = false;
                request.Timeout = 3000;
                ServicePointManager.DefaultConnectionLimit = 2;

                using (response = (HttpWebResponse)request.GetResponse())
                {
                    if (response.StatusCode != HttpStatusCode.RequestTimeout)
                    {
                        result = true;
                    }
                }
            }
            catch (Exception ex)
            {
                result = false;
            }
            finally
            {
                if (response != null)
                {
                    response.Close();
                }
            }
            return result;
        }
    }
}