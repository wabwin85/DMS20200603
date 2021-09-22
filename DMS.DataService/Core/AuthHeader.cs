using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services.Protocols;

namespace DMS.DataService.Core
{
    public class AuthHeader : SoapHeader
    {
        /// <summary>
        /// 用户名
        /// </summary>
        public string User;
        /// <summary>
        /// 密码
        /// </summary>
        public string Password;
    }
}
