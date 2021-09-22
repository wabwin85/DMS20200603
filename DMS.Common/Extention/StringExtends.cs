using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Common.Extention
{
    public static class StringExtends
    {
        public static String ToSafeString(this String value)
        {
            if (string.IsNullOrEmpty(value))
            {
                return String.Empty;
            }

            return value.Trim();
        }

        public static int? ToInt(this String value)
        {
            int? rtn = null;

            if (String.IsNullOrEmpty(value))
            {
                return null;
            }

            try
            {
                rtn = Convert.ToInt32(value);
            }
            catch
            {
                rtn = null;
            }

            return rtn;
        }

        public static int ToSafeInt(this String value)
        {
            return value.ToInt().HasValue ? value.ToInt().Value : 0;
        }

        public static decimal? ToDecimal(this String value)
        {
            decimal? rtn = null;

            if (String.IsNullOrEmpty(value))
            {
                return null;
            }

            try
            {
                rtn = Convert.ToDecimal(value);
            }
            catch
            {
                rtn = null;
            }

            return rtn;
        }

        public static decimal ToSafeDecimal(this String value)
        {
            return value.ToDecimal().HasValue ? value.ToDecimal().Value : 0;
        }

        public static DateTime? ToDateTime(this String value)
        {
            DateTime? rtn = null;

            if (String.IsNullOrEmpty(value))
            {
                return null;
            }

            try
            {
                rtn = Convert.ToDateTime(value);
            }
            catch
            {
                rtn = null;
            }

            return rtn;
        }

        public static DateTime ToSafeDateTime(this String value)
        {
            return value.ToDateTime().HasValue ? value.ToDateTime().Value : DateTime.MinValue;
        }

        public static bool? ToBool(this String value)
        {
            bool? rtn = null;

            if (String.IsNullOrEmpty(value))
            {
                return null;
            }

            try
            {
                rtn = Convert.ToBoolean(value);
            }
            catch
            {
                rtn = null;
            }

            return rtn;
        }

        public static bool ToSafeBool(this String value)
        {
            return value.ToBool().HasValue ? value.ToBool().Value : false;
        }

        public static Guid? ToGuid(this String value)
        {
            Guid? rtn = null;

            if (String.IsNullOrEmpty(value))
            {
                return null;
            }

            try
            {
                rtn = new Guid(value);
            }
            catch
            {
                rtn = null;
            }

            return rtn;
        }

        public static Guid ToSafeGuid(this String value)
        {
            return value.ToGuid().HasValue ? value.ToGuid().Value : Guid.Empty;
        }

        public static String SafeTrim(this String value)
        {
            if (String.IsNullOrEmpty(value))
            {
                return null;
            }
            else
            {
                return value.Trim();
            }
        }

        public static bool IsNullOrEmpty(this String value)
        {
            return String.IsNullOrEmpty(value);
        }

        public static bool IsDateime(this String value)
        {
            try
            {
                DateTime.Parse(value);
                return true;
            }
            catch
            {
                return false;
            }
        }

        public static bool IsDecimal(this String value)
        {
            try
            {
                Decimal.Parse(value);
                return true;
            }
            catch
            {
                return false;
            }
        }

        public static String EscapeJsChar(this String value)
        {
            return value.Replace("\r", "\\r").Replace("\n", "\\n").Replace("'", "\\'");
        }

        public static bool ContainsString(this String value, String str, String split)
        {
            String[] ss = value.Split(new String[] { split }, StringSplitOptions.RemoveEmptyEntries);
            foreach (String s in ss)
            {
                if (s == str)
                {
                    return true;
                }
            }
            return false;
        }
    }
}
