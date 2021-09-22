using DMS.Business.EKPWorkflow;
using DMS.Common.Common;
using DMS.Model.ViewModel.InventoryReturn;
using Lafite.RoleModel.Security;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;

namespace DMS.Website.PagesKendo.InventoryReturn.Handler
{
    /// <summary>
    /// DealerComplainBscHandler 的摘要说明
    /// </summary>
    public class DealerComplainBscHandler : IHttpHandler
    {
        private EkpWorkflowBLL ekpBll = new EkpWorkflowBLL();
        public void ProcessRequest(HttpContext context)
        {
            DealerComplainBscVO model = new DealerComplainBscVO();
            try
            {
                context.Response.ClearContent();
                context.Response.ContentType = "text/plain";
                context.Response.Cache.SetCacheability(HttpCacheability.NoCache); //无缓存

                byte[] byts = new byte[context.Request.InputStream.Length];
                context.Request.InputStream.Read(byts, 0, byts.Length);
                string data = Encoding.GetEncoding("utf-8").GetString(byts);

                model = JsonConvert.DeserializeObject<DealerComplainBscVO>(data);
                DMS.Business.DealerComplainBLL service = new DMS.Business.DealerComplainBLL();

                if (model.Method == "InitPage")
                {
                    model.IsSuccess = ekpBll.ValidateUserCanEditEkpProcess(model.ComplainId, RoleModelContext.Current.User.LoginId);

                    if (model.IsSuccess)
                    {
                        model = service.InitPage(model, true);
                    }
                    else
                    {
                        model.ExecuteMessage.Add("没有编辑申请单的权限！");
                    }
                }
                else if (model.Method == "DoSave")
                {
                    model = service.DoSave(model);
                }
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }

            context.Response.Write(JsonConvert.SerializeObject(model));
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