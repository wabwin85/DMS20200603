using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;

namespace DMS.WeChatClient.Common
{
    public class EncryptHelper
    {
        public static string EncodeBase64(Encoding encode, string source)
        {
            byte[] bytes = encode.GetBytes(source);
            string strResult = string.Empty;
            try
            {
                strResult = Convert.ToBase64String(bytes);
            }
            catch
            {
                strResult = source;
            }
            return strResult;
        }

        public static string EncodeBase64(string source)
        {
            return EncodeBase64(Encoding.UTF8, source);
        }

        public static string DecodeBase64(Encoding encode, string result)
        {
            string decode = "";
            byte[] bytes = Convert.FromBase64String(result);
            try
            {
                decode = encode.GetString(bytes);
            }
            catch
            {
                decode = result;
            }
            return decode;
        }

        public static string DecodeBase64(string result)
        {
            return DecodeBase64(Encoding.UTF8, result);
        }
    }
}