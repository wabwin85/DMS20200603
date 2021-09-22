using DMS.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;

namespace DMS.Business.EKPWorkflow
{
    public class Encryption
    {
        private static long encodeNum = 43200L;
        private static int encodeLen = 20;
        private static byte[] HEADER = { 0, 1, 2, 3 };
        private static string password = EkpSetting.CONST_EKP_SSO_KEY;

        public static string Encoder(string str)
        {
            long createTime = Decimal.ToInt64(Decimal.Divide(DateTime.UtcNow.Ticks - 621355968000000000, 10000 * 1000));
            long expireTime = createTime + 43200L;

            byte[] create = System.Text.Encoding.Default.GetBytes(Convert.ToString(createTime, 16).ToUpper());
            byte[] expire = System.Text.Encoding.Default.GetBytes(Convert.ToString(expireTime, 16).ToUpper());
            byte[] user = System.Text.Encoding.Default.GetBytes(str);
            byte[] bytes = new byte[20 + str.Length];
            Array.Copy(HEADER, 0, bytes, 0, 4);
            Array.Copy(create, 0, bytes, 4, 8);
            Array.Copy(expire, 0, bytes, 12, 8);
            Array.Copy(user, 0, bytes, 20, str.Length);

            byte[] digest = System.Text.Encoding.Default.GetBytes(GetSHA1(password));
            byte[] token = new byte[bytes.Length + digest.Length];
            Array.Copy(bytes, 0, token, 0, bytes.Length);
            Array.Copy(digest, 0, token, bytes.Length, digest.Length);

            return Convert.ToBase64String(token);
        }

        public static string Decoder(string str)
        {
            byte[] token = Convert.FromBase64String(str);
            byte[] digest = System.Text.Encoding.Default.GetBytes(GetSHA1(password));
            byte[] user = new byte[token.Length - encodeLen - digest.Length];
            Array.Copy(token, encodeLen, user, 0, token.Length - encodeLen - digest.Length);

            return System.Text.Encoding.Default.GetString(user);
        }

        private static string GetSHA1(string str)
        {
            byte[] hash = SHA1.Create().ComputeHash(Encoding.ASCII.GetBytes(password));
            char[] hexDigits = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f' };
            int j = 8;
            char[] buffer = new char[j * 2];
            int k = 0;
            for (int i = 0; i < j; i++)
            {
                byte byte0 = hash[i];
                buffer[k++] = hexDigits[RightMove(byte0, 4) & 0xf];
                buffer[k++] = hexDigits[byte0 & 0xf];
            }

            return new string(buffer);
        }

        private static int RightMove(int value, int pos)
        {

            if (pos != 0)
            {
                int mask = 0x7fffffff;
                value >>= 1;
                value &= mask;
                value >>= pos - 1;
            }
            return value;
        }
    }
}
