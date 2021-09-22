using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections;
using System.Web.UI.WebControls;

namespace DMS.Common.Extention
{
    public static class LongExtends
    {
        public static long ToSafeLong(this long? value)
        {
            return value.HasValue ? value.Value : 0;
        }

        public static String ToSafeLong(this long value)
        {
            return value.ToString("0");
        }
    }
}
