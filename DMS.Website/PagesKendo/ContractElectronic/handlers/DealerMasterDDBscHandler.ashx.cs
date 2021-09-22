using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Newtonsoft.Json;
using System.Text;
using DMS.Common.Common;
using DMS.Model;
using DMS.Business;
using System.Web.SessionState;
using Lafite.RoleModel.Security;

namespace DMS.Website.PagesKendo.ContractElectronic.handlers
{
    /// <summary>
    /// QueryHandler 的摘要说明
    /// </summary>
    public class DealerMasterDDBscHandler : IHttpHandler, IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            DealerMasterDDBscView model = new DealerMasterDDBscView();
            try
            {
                context.Response.ClearContent();
                context.Response.ContentType = "text/plain";
                context.Response.Cache.SetCacheability(HttpCacheability.NoCache); //无缓存

                byte[] byts = new byte[context.Request.InputStream.Length];
                context.Request.InputStream.Read(byts, 0, byts.Length);
                string data = Encoding.GetEncoding("utf-8").GetString(byts);

                model = JsonConvert.DeserializeObject<DealerMasterDDBscView>(data);
                DealerMasterDDBscService service = new DealerMasterDDBscService();

                if (model.Method == "InitPage")
                {
                    //model.IsSuccess = ekpBll.ValidateUserCanEditEkpProcess(model.ContractID, RoleModelContext.Current.User.LoginId);
                    model = service.GetInitInfo(model);
                }
                else if (model.Method == "DoSave")
                {
                    model = service.SaveInfo(model);
                }
                else if (model.Method == "AttachmentStore_Refresh")
                {
                    model = service.AttachmentStore_Refresh(model);
                }
                else if (model.Method == "DeleteAttachment")
                {
                    model = service.DeleteAttachment(model);
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