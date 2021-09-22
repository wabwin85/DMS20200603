using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Common.Extention
{
    public static class ExceptionExtends
    {
        public static String GetExceptionMessage(this Exception ex)
        {
            if (ex.InnerException != null)
            {
                return ex.InnerException.GetExceptionMessage();
            }
            else
            {
                return ex.Message;
            }
        }
    }
}
