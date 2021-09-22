using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Common.Extention
{
    public static class DateTimeExtends
    {
        public static DateTime ToSafeDateTime(this DateTime? value)
        {
            return value.HasValue ? value.Value : DateTime.MinValue;
        }

        public static String To_yyyy_MM(this DateTime value)
        {
            if (value == DateTime.MinValue)
            {
                return String.Empty;
            }

            return value.ToString("yyyy-MM");
        }

        public static String To_yyyyMM(this DateTime value)
        {
            if (value == DateTime.MinValue)
            {
                return String.Empty;
            }

            return value.ToString("yyyyMM");
        }

        public static String To_yyyy_MM_dd(this DateTime value)
        {
            if (value == DateTime.MinValue)
            {
                return String.Empty;
            }

            return value.ToString("yyyy-MM-dd");
        }

        public static String To_yyyy_MM_dd_HH_mm_ss(this DateTime value)
        {
            if (value == DateTime.MinValue)
            {
                return String.Empty;
            }

            return value.ToString("yyyy-MM-dd HH:mm:ss");
        }
    }
}
