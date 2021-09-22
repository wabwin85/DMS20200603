using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.SessionState;
using System.Reflection;
using DMS.Common;
using Spring.Context;
using Spring.Context.Support;
using DMS.Common.Extention;
using DMS.ViewModel;
using DMS.Common.Common;

namespace DMS.Website.Revolution.Pages.Handler
{
    /// <summary>
    /// ActionHandler 的摘要说明
    /// </summary>
    public class ActionHandler : IHttpHandler, IRequiresSessionState
    {
        public void ProcessRequest(HttpContext context)
       {
            String Business = context.Request.QueryString["Business"].ToSafeString();

            //String ViewModel = context.Request.QueryString["ViewModel"].ToSafeString();
            //String BusinessService = context.Request.QueryString["BusinessService"].ToSafeString();
            String Method = context.Request.QueryString["Method"].ToSafeString();
            String ContentType = context.Request.QueryString["ContentType"].ToSafeString();

            if (Business.IsNullOrEmpty() || Method.IsNullOrEmpty())
            {
                BaseVO model = new BaseVO();

                model.IsSuccess = false;
                model.ExecuteMessage.Add("Empty of Business/Method");

                context.Response.Write(JsonHelper.Serialize(model));
            }
            else
            {
                IApplicationContext iac = ContextRegistry.GetContext();
                object serviceObject = iac.GetObject(Business + "_Service");

                //Assembly modelAssembly = Assembly.Load("Model");
                //Type modelType = modelAssembly.GetType(ViewModel);//获得类型
                //object modelObject = Activator.CreateInstance(modelType);//创建实例

                //Assembly serviceAssembly = Assembly.Load("Business");
                //Type serviceType = serviceAssembly.GetType(BusinessService);//获得类型
                //object serviceObject = Activator.CreateInstance(serviceType);//创建实例

                if (ContentType.IsNullOrEmpty() || ContentType == "json")
                {
                    object modelObject = iac.GetObject(Business + "_VO");
                    try
                    {
                        context.Response.ClearContent();
                        context.Response.ContentType = "text/plain";
                        context.Response.Cache.SetCacheability(HttpCacheability.NoCache); //无缓存

                        byte[] byts = new byte[context.Request.InputStream.Length];
                        context.Request.InputStream.Read(byts, 0, byts.Length);
                        string data = Encoding.GetEncoding("utf-8").GetString(byts);

                        modelObject = JsonConvert.DeserializeObject(data, modelObject.GetType());

                        //获取方法的信息
                        MethodInfo serviceMethod = serviceObject.GetType().GetMethod(Method);
                        //调用方法的一些标志位，这里的含义是Public并且是实例方法，这也是默认的值
                        BindingFlags flag = BindingFlags.Public | BindingFlags.Instance;
                        //GetValue方法的参数
                        object[] serviceParameters = new object[] { modelObject };
                        //调用方法，用一个object接收返回值
                        modelObject = serviceMethod.Invoke(serviceObject, flag, Type.DefaultBinder, serviceParameters, null);
                    }
                    catch (Exception ex)
                    {
                        LogHelper.Error(ex);

                        BaseVO model = modelObject as BaseVO;
                        model.IsSuccess = false;
                        model.AddExecuteMessage(ex.Message);

                        modelObject = model;

                        //    //设置错误标志
                        //    PropertyInfo IsSuccess = modelObject.GetType().GetProperty("IsSuccess"); //获取指定名称的属性
                        //    IsSuccess.SetValue(modelObject, false, null); //给对应属性赋值

                        //    //设置错误信息
                        //    //获取方法的信息
                        //    MethodInfo AddExecuteMessage = modelObject.GetType().GetMethod("AddExecuteMessage");
                        //    //调用方法的一些标志位，这里的含义是Public并且是实例方法，这也是默认的值
                        //    BindingFlags flag = BindingFlags.Public | BindingFlags.Instance;
                        //    //GetValue方法的参数
                        //    object[] parameters = new object[] { ex.Message };
                        //    //调用方法，用一个object接收返回值
                        //    AddExecuteMessage.Invoke(modelObject, flag, Type.DefaultBinder, parameters, null);
                    }

                    context.Response.Write(JsonHelper.Serialize(modelObject));
                }
                else
                {
                    object modelObject = new object();
                    try
                    {
                        //获取方法的信息
                        MethodInfo serviceMethod = serviceObject.GetType().GetMethod(Method);
                        //调用方法的一些标志位，这里的含义是Public并且是实例方法，这也是默认的值
                        BindingFlags flag = BindingFlags.Public | BindingFlags.Instance;
                        //GetValue方法的参数
                        object[] serviceParameters = new object[] { context.Request.QueryString };
                        //调用方法，用一个object接收返回值
                        modelObject = serviceMethod.Invoke(serviceObject, flag, Type.DefaultBinder, serviceParameters, null);
                    }
                    catch (Exception ex)
                    {
                        LogHelper.Error(ex);
                    }
                    context.Response.Write(JsonHelper.Serialize(modelObject));
                }
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