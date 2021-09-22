using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Common.Extention
{
    public static class ObjectExtends
    {
        public static String ToSafeString(this Object value)
        {
            if (value == null)
            {
                return String.Empty;
            }

            return value.ToString().Trim();
        }
    }
}
