using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using DMS.Model.WeChat;
using DMS.WeChatServer.Common;
using DMS.WeChatServer.WebApi.Handlers;

namespace DMS.WeChatServer.WebApi
{
    public class ActionHandler : IHttpHandler
    {

        private static List<hl_Base> lstHandlers = null;

        public static void InitServiceHandlerList()
        {
            if (null == lstHandlers)
            {
                lstHandlers = new List<hl_Base>
                {
                    new hl_Account(),
                    new hl_Navigation(),
                    new hl_ScanQRCode()
                };
                foreach (var item in lstHandlers)
                {
                    hl_Base.ActionNames.AddRange(item.GetActionName());
                }
            }
        }

        public void ProcessRequest(HttpContext context)
        {

            WeChatParams wechatParams = new WeChatParams();
            InitServiceHandlerList();
            var jsonString = context.Request["WeChatParams"];
            if (!string.IsNullOrEmpty(jsonString))
            {
                jsonString = CommonHelper.GetDecryptParameters(jsonString);
                wechatParams = CommonHelper.Deserialize<WeChatParams>(jsonString);
            }

            if (wechatParams == null || !lstHandlers.Any(item => item.GetActionName().Contains(wechatParams.ActionName)))
            {
                // 测试目的
                context.Response.Write(string.Format("Welcome. {0}", DateTime.Now));
                context.Response.Flush();
                return;
            }
            else
            {
                var handler = lstHandlers.FirstOrDefault(item => item.GetActionName().Contains(wechatParams.ActionName));
                HandleResult result = new HandleResult() {success = false};
                try
                {
                    if (null != handler)
                    {
                        result = handler.ProcessMessage(wechatParams);
                    }
                }
                catch (Exception ex)
                {
                    CommonHelper.WriteLog(string.Format("API执行失败:{0}", ex.StackTrace));
                    result.success = false;
                    result.msg = ex.ToString();
                }
                string strResult = CommonHelper.Serialize(result);

                byte[] bytes = Encoding.UTF8.GetBytes(strResult);
                bytes = CommonHelper.Compress(bytes);
                var response = context.Response;
                response.Clear();
                response.AddHeader("Content-Type", "application/json;charset=utf-8");
                response.AddHeader("Content-Encoding", "gzip");
                response.AddHeader("Content-Length", bytes.Length.ToString());
                response.BinaryWrite(bytes);
                response.Flush();
                response.Close();
            }
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}