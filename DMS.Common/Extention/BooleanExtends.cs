using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Common.Extention
{
    public static class BooleanExtends
    {
        public static bool ToSafeBool(this bool? value)
        {
            return value.HasValue ? value.Value : false;
        }
    }
}
