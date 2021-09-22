using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Common.Extention
{
    public static class DecimalExtends
    {
        public static decimal ToSafeDecimal(this decimal? value)
        {
            return value.HasValue ? value.Value : 0.0m;
        }

        public static String ToDecimalString(this decimal value)
        {
            return value.ToString("0.00");
        }

        public static String ToDecimalString(this decimal value, int digit)
        {
            return value.ToString("N" + digit.ToSafeString());
        }
    }
}
