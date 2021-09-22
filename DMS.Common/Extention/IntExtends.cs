using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Common.Extention
{
    public static class IntExtends
    {
        public static int ToSafeInt(this int? value)
        {
            return value.HasValue ? value.Value : 0;
        }

        public static String ToIntString(this int value)
        {
            return value.ToString("0");
        }
    }
}
