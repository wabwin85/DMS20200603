using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Web;

namespace DMS.WeChatServer.Common
{
    public class EncryptHelper
    {
        public static string DESEncode(string data, string key, string value)
        {
            var cryptoProvider = new DESCryptoServiceProvider();
            var msData = new MemoryStream();
            var cstData = new CryptoStream(msData, cryptoProvider.CreateEncryptor(Encoding.UTF8.GetBytes(key), Encoding.UTF8.GetBytes(value)), CryptoStreamMode.Write);

            var swData = new StreamWriter(cstData);
            swData.Write(data);
            swData.Flush();
            cstData.FlushFinalBlock();
            swData.Flush();
            return Convert.ToBase64String(msData.GetBuffer(), 0, (int)msData.Length);
        }

        public static string DESDecode(string data, string key, string value)
        {
            try
            {
                byte[] byData = Convert.FromBase64String(data);
                var cryptoProvider = new DESCryptoServiceProvider();
                var msData = new MemoryStream(byData);
                var cstData = new CryptoStream(msData, cryptoProvider.CreateDecryptor(Encoding.UTF8.GetBytes(key), Encoding.UTF8.GetBytes(value)), CryptoStreamMode.Read);
                var srData = new StreamReader(cstData);
                return srData.ReadToEnd();
            }
            catch (Exception ex)
            {
                CommonHelper.WriteLog(string.Format("解码失败:{0}", ex.ToString()));
                return null;
            }
        }

        public static string Base64Encode(string data)
        {
            return Convert.ToBase64String(Encoding.UTF8.GetBytes(data));
        }

        public static string Base64Decode(string data)
        {
            return Encoding.UTF8.GetString(Convert.FromBase64String(data));
        }

        public static string SHA1EnCode(string data)
        {

            char[] hexDigits = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f' };
            byte[] bytes = Encoding.UTF8.GetBytes(data);
            SHA1 sha1 = SHA1.Create();
            byte[] hashBytes = sha1.ComputeHash(bytes);
            int j = hashBytes.Length;
            char[] crResult = new char[j * 2];
            int k = 0;
            for (int i = 0; i < j; i++)
            {
                byte byte0 = hashBytes[i];
                crResult[k++] = hexDigits[byte0 >> 4 & 0xf];
                crResult[k++] = hexDigits[byte0 & 0xf];
            }
            return new string(crResult);
        }

        public static string getAESEncrypt(string key, string iv, string Data)
        {
            //先采用AES 加密，再采用BASE 64加密
            byte[] byteKey = Encoding.UTF8.GetBytes(key);
            byte[] byteIV = Encoding.UTF8.GetBytes(iv);
            byte[] byteData = Encoding.UTF8.GetBytes(Data);
            string encryptResult = null;
            Rijndael aes = Rijndael.Create();
            using (MemoryStream mStream = new MemoryStream())
            {
                using (CryptoStream cStream = new CryptoStream(mStream, aes.CreateEncryptor(byteKey, byteIV), CryptoStreamMode.Write))
                {
                    cStream.Write(byteData, 0, byteData.Length);
                    cStream.FlushFinalBlock();
                    encryptResult = Convert.ToBase64String(mStream.ToArray());
                }
            }
            aes.Clear();

            return encryptResult;
        }

        public static string getAESDecrypt(string key, string iv, string Data)
        {
            byte[] bKey = Encoding.UTF8.GetBytes(key);
            byte[] bIV = Encoding.UTF8.GetBytes(iv);
            byte[] byteArray = Convert.FromBase64String(Data);
            string decrypt = null;
            Rijndael aes = Rijndael.Create();
            using (MemoryStream mStream = new MemoryStream())
            {
                using (CryptoStream cStream = new CryptoStream(mStream, aes.CreateDecryptor(bKey, bIV), CryptoStreamMode.Write))
                {
                    cStream.Write(byteArray, 0, byteArray.Length);
                    cStream.FlushFinalBlock();
                    decrypt = Encoding.UTF8.GetString(mStream.ToArray());
                }
            }
            return decrypt;
        }

        public static string GetMD5(string encypStr, string charset = "utf-8")
        {
            MD5CryptoServiceProvider provider = new MD5CryptoServiceProvider();
            Encoding encoding = Encoding.Default;

            if (!string.IsNullOrEmpty(charset))
                encoding = Encoding.GetEncoding(charset);
            byte[] bytes = encoding.GetBytes(encypStr);
            return BitConverter.ToString(provider.ComputeHash(bytes)).Replace("-", "");
        }
    }
}