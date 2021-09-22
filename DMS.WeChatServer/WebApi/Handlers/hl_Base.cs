using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Linq.Expressions;
using DMS.Business;
using DMS.Model.WeChat;

namespace DMS.WeChatServer.WebApi.Handlers
{
    public abstract class hl_Base
    {
        public static List<string> ActionNames = new List<string>();
        public abstract List<string> GetActionName();
        public abstract HandleResult ProcessMessage(WeChatParams mobileParams);

        private static WeChatBaseBLL _bllWeChat;

        protected static WeChatBaseBLL bllWeChat
        {
            get { return _bllWeChat ?? (_bllWeChat = new WeChatBaseBLL()); }
        }
    }
}