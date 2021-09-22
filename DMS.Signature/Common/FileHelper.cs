using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Text;

namespace DMS.Signature.Common
{
    public static class FileHelper
    {
        /// <summary>
        /// 计算文件MD5值获得128比特位数字，对该数字进行base64编码为一个的Content-MD5值
        /// </summary>
        /// <param name="filePath"></param>
        /// <returns></returns>
        public static string GetContentMD5FromFile(string filePath)
        {
            string ContentMD5 = null;
            try
            {
                FileStream file = new FileStream(filePath, FileMode.Open, FileAccess.Read);
                System.Security.Cryptography.MD5 md5 = new System.Security.Cryptography.MD5CryptoServiceProvider();
                byte[] retVal = md5.ComputeHash(file);
                file.Close();
                ContentMD5 = Convert.ToBase64String(retVal).ToString();
                return ContentMD5;
            }
            catch (Exception ex)
            {
                Console.WriteLine("发生异常：" + ex.Message);
                return ContentMD5;
            }
        }

        /// <summary>
        /// 将文件转换为byte数组
        /// </summary>
        /// <param name="path">文件地址</param>
        /// <returns>转换后的byte数组</returns>
        public static byte[] File2Bytes(string path)
        {
            if (!System.IO.File.Exists(path))
            {
                return new byte[0];
            }

            FileInfo fi = new FileInfo(path);
            byte[] buff = new byte[fi.Length];

            FileStream fs = fi.OpenRead();
            fs.Read(buff, 0, Convert.ToInt32(fs.Length));
            fs.Close();

            return buff;
        }

        /// 计算文件的 SHA256 值 
        /// </summary> 
        /// <param name="fileName">要计算 SHA256 值的文件名和路径</param> 
        /// <returns>SHA256值16进制字符串</returns> 
        public static string SHA256File(string fileName)
        {
            return HashFile(fileName, "sha256");
        }

        /// <summary> 
        /// 计算文件的哈希值 
        /// </summary> 
        /// <param name="fileName">要计算哈希值的文件名和路径</param> 
        /// <param name="algName">算法:sha1,md5</param> 
        /// <returns>哈希值16进制字符串</returns> 
        public static string HashFile(string fileName, string algName)
        {
            if (!System.IO.File.Exists(fileName))
                return string.Empty;

            FileStream fs = new FileStream(fileName, FileMode.Open, FileAccess.Read);
            byte[] hashBytes = HashData(fs, algName);
            fs.Close();
            return ByteArrayToHexString(hashBytes);
        }

        /// <summary> 
        /// 字节数组转换为16进制表示的字符串 
        /// </summary> 
        public static string ByteArrayToHexString(byte[] buf)
        {
            string returnStr = "";
            if (buf != null)
            {
                for (int i = 0; i < buf.Length; i++)
                {
                    returnStr += buf[i].ToString("X2");
                }
            }
            return returnStr;
        }

        /// <summary> 
        /// 计算哈希值 
        /// </summary> 
        /// <param name="stream">要计算哈希值的 Stream</param> 
        /// <param name="algName">算法:sha1,md5</param> 
        /// <returns>哈希值字节数组</returns> 
        public static byte[] HashData(Stream stream, string algName)
        {
            HashAlgorithm algorithm;
            if (algName == null)
            {
                throw new ArgumentNullException("algName 不能为 null");
            }
            if (string.Compare(algName, "sha256", true) == 0)
            {
                algorithm = SHA256.Create();
            }
            else
            {
                if (string.Compare(algName, "md5", true) != 0)
                {
                    throw new Exception("algName 只能使用 sha256 或 md5");
                }
                algorithm = MD5.Create();
            }
            return algorithm.ComputeHash(stream);
        }
    }
}
