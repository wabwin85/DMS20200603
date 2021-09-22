using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;

namespace DMS.Logging
{
    public static class IdentityHelper
    {
        public static string GetIdentityId()
        {
            HttpContext current = HttpContext.Current;
            string text = string.Empty;
            if (current != null && current.User.Identity.IsAuthenticated)
            {
                text = current.User.Identity.Name;
                if (!string.IsNullOrEmpty(text))
                {
                    int num = text.IndexOf("\\");
                    if (num > 0)
                    {
                        text = text.Substring(num + 1);
                    }
                }
            }
            return text;
        }
    }
}
