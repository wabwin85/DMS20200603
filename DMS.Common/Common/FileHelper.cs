using ICSharpCode.SharpZipLib.Zip;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;

namespace DMS.Common.Common
{
    public class FileHelper
    {
        public static String UploadFile(HttpPostedFile postedFile, String preFix)
        {
            String rtnFileName = "";

            if (postedFile.ContentLength > 20000000) //  < 200M
            {
                throw new Exception("文件太大不能上传");
            }

            String fileExtension;
            String ftpYear = DateTime.Now.Year.ToString();

            String fileName = Path.GetFileName(postedFile.FileName);

            if (!String.IsNullOrEmpty(fileName))
            {
                fileExtension = Path.GetExtension(fileName);
                if (postedFile == null)
                {
                    throw new Exception("文件不存在");
                }
                else
                {
                    DateTime date = DateTime.Now;

                    //生成随机文件名
                    String saveName = date.Year.ToString() + date.Month.ToString() + date.Day.ToString() + date.Hour.ToString() + date.Minute.ToString() + date.Second.ToString() + date.Millisecond.ToString() + "-" + Guid.NewGuid().ToString();
                    saveName = preFix + "_" + saveName + fileExtension;

                    String filePath = AppDomain.CurrentDomain.BaseDirectory + "Upload\\temp\\";

                    filePath = FileHelper.BuildPath(filePath);
                    String fullName = Path.Combine(filePath, saveName);

                    //
                    //保存文件
                    //
                    postedFile.SaveAs(fullName);

                    rtnFileName = fullName;
                }
            }

            return rtnFileName;
        }

        /// <summary>
        /// 查看路径是否存在，
        /// 不存在，则创建
        /// </summary>
        /// <param name="path"></param>
        public static string BuildPath(string path)
        {
            if (!Directory.Exists(path))
            {
                Directory.CreateDirectory(path);
            }
            return Path.GetFullPath(path);
        }

        public static void Delete(string fileName)
        {
            if (File.Exists(fileName))
            {
                File.Delete(fileName);
            }
        }
    }
}
