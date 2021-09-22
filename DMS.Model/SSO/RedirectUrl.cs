using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Model.SSO
{
    public class RedirectUrl
    {
        public string LoginUrl { get; set; }
        public string DefaultUrl { get; set; }
        public string ReturnUrl { get; set; }
    }
}
