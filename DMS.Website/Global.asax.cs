using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.SessionState;
using System.Web.UI;
using DMS.Model;

namespace DMS.Website
{
    using DMS.Common;
    using log4net.Config;
    using Microsoft.Practices.Unity;
    using System.IO;

    public class Global : System.Web.HttpApplication
    {
        private const string AppContainerKey = "dms-application-container";

        private IUnityContainer applicationContainer
        {
            get
            {
                return (IUnityContainer)this.Application[AppContainerKey];
            }
            set
            {
                this.Application[AppContainerKey] = value;
            }
        }

        public static IUnityContainer ApplicationContainer
        {
            get
            {
                System.Web.HttpApplicationState applicationstate = HttpContext.Current.Application;
                return (IUnityContainer)applicationstate[AppContainerKey];
            }
        }

        public Global()
        {
            //
        }

        protected void Application_Start(object sender, EventArgs e)
        {
            IUnityContainer applicationContainer = new UnityContainer();
            WebContainerHelper.ConfigureContainer(applicationContainer, "application");

            this.applicationContainer = applicationContainer;

            XmlConfigurator.Configure(new FileInfo(AppDomain.CurrentDomain.BaseDirectory + "config/log4net.config"));

            #region 电子签章
            //TODO:初始化电子签章

            DMS.Signature.SignatureHelper helper = new DMS.Signature.SignatureHelper();
            helper.EsignInit();

            #endregion

            //加载一个model
            Hospital hos = new Hospital();
        }

        protected void Application_End(object sender, EventArgs e)
        {
            IUnityContainer applicationContainer = this.applicationContainer;

            if (applicationContainer != null)
            {
                applicationContainer.Dispose();

                this.applicationContainer = null;
            }
        }

        protected void Application_BeginRequest(object sender, EventArgs e)
        { 
         
        }

        protected void Application_PostAcquireRequestState(object sender, EventArgs e)
        {
            // 
            HttpApplication application = (sender as HttpApplication);
            if (application == null) return;

            HttpContext context = application.Context;
            if (!context.Request.Path.Contains("Login.aspx")
                && !context.Request.Path.Contains("ChangePassword.aspx")
                && context.Session != null)
            {
                object needchangepass = context.Session["needchangepassword"];
                object needchangewechatuser = context.Session["needchangewechatuser"];
                if (needchangepass != null)
                {
                    int needchange = Convert.ToUInt16(needchangepass);
                    if (needchange > 0)
                    {
                        string url = context.Request.RawUrl;
                        //context.RewritePath(string.Format("~/Pages/ChangePassword.aspx?pt={0}&ReturnUrl={1}", needchange, url), false);
                        context.Response.Redirect(string.Format("~/Pages/ChangePassword.aspx?pt={0}&ReturnUrl={1}", needchange, url));                      
                    }
                }
                
            }             
        }

        protected void Application_PreRequestHandlerExecute(object sender, EventArgs e)
        {
            Page handler = HttpContext.Current.Handler as Page;

            if (handler != null)
            {
                if (this.applicationContainer != null)
                {
                    this.applicationContainer.BuildUp(handler.GetType(), handler);
                }
            }          
        }

        protected void Application_Error(object sender, EventArgs e)
        {
            Exception ex = this.Context.Server.GetLastError();
            if (null != ex)
            {
             
            }
        }

        protected void Session_Start(object sender, EventArgs e)
        {
           
        }

        protected void Session_End(object sender, EventArgs e)
        {

        }
    }
}