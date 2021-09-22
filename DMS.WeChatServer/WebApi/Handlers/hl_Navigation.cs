using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Linq.Expressions;
using System.Dynamic;
using DMS.Model.WeChat;

namespace DMS.WeChatServer.WebApi.Handlers
{
    public class hl_Navigation : hl_Base
    {
        public override List<string> GetActionName()
        {
            return new List<string> { "Navigation" };
        }

        public override HandleResult ProcessMessage(WeChatParams mobileParams)
        {
            HandleResult result = new HandleResult();
            try
            {
                var operateType = mobileParams.MethodName;
                if (operateType == "Init")
                {
                    result = Init(mobileParams);
                }
            }
            catch (Exception ex)
            {
                result.success = false;
                result.msg = ex.ToString();
            }
            return result;
        }

        #region 
        public static HandleResult Init(WeChatParams message)
        {
            string strOpenId = message.Parameters["openId"].ToString();
            HandleResult handleResult = new HandleResult { success = false, msg = string.Empty };
            DataSet dsWeChatUser=bllWeChat.SelectWechatUserByOpenId(strOpenId);
            if (null != dsWeChatUser && dsWeChatUser.Tables.Count > 0&& dsWeChatUser.Tables[0].Rows.Count>0)
            {
                DataTable dtWeChatUser = dsWeChatUser.Tables[0];
                handleResult.data = dtWeChatUser;
                handleResult.success = true;
            }
            else
            {
                handleResult.msg = "用户信息不存在。";
            }
            return handleResult;
        }
        #endregion
    }
}