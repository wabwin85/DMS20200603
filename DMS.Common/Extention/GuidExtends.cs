using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Common.Extention
{
    public static class GuidExtends
    {
        public static Guid ToSafeGuid(this Guid? value)
        {
            return value.HasValue ? value.Value : Guid.Empty;
        }
    }
}
