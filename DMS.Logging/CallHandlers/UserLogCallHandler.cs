using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.Practices.Unity.InterceptionExtension;
using DMS.Logging.Providers;
using System.Reflection;

namespace DMS.Logging.CallHandlers
{
    public class UserLogCallHandler : ICallHandler
    {
        public int Order { get; set; }
        public string Category { get; set; }
        public string EventId { get; set; }
        public string EventMessage { get; set; }

        public IMethodReturn Invoke(IMethodInvocation input, GetNextHandlerDelegate getNext)
        {
            //获取参数
            object[] parms = null;
            Type[] types = null;
            if (input.Arguments.Count > 0)
            {
                parms = new object[input.Arguments.Count];
                types = new Type[input.Arguments.Count];
                for (int i = 0; i < input.Arguments.Count; i++)
                {
                    ParameterInfo pi = input.Arguments.GetParameterInfo(i);
                    parms[i] = input.Arguments[pi.Name];
                    types[i] = pi.ParameterType;
                    //types[i] = Type.GetType(pi.ParameterType.FullName + "," + pi.ParameterType.Assembly.FullName);
                }
            }

            if (parms == null)
                parms = new object[] { };
            if (types == null)
                types = new Type[] { };

            //拦截事件保存消息
            string message = string.Empty;

            //创建Extension对象
            Type extType = Type.GetType(GetExtensionTypeName(input.MethodBase.ReflectedType) + "," + input.MethodBase.ReflectedType.Assembly.FullName);
            object ext = Activator.CreateInstance(extType);

            //调用Before事件方法
            MethodInfo before = extType.GetMethod("Before" + input.MethodBase.Name, types);
            if (before != null)
            {
                try
                {
                    message += before.Invoke(ext, parms);
                }
                catch
                {
                    message += "调用Before事件方法出错";
                }
            }

            IMethodReturn result = getNext()(input, getNext);

            bool success = false;

            if (result.Exception != null)
            {
                message += result.Exception.Message;
            }
            else if (result.ReturnValue != null && result.ReturnValue.GetType() == typeof(bool))
            {
                success = Convert.ToBoolean(result.ReturnValue);
                message += success ? "" : "操作失败";
            }
            else
            {
                success = true;
            }


            if (success)
            {
                //获取参数
                object[] parms1 = null;
                if (input.Arguments.Count > 0)
                {
                    parms1 = new object[input.Arguments.Count];
                    for (int i = 0; i < input.Arguments.Count; i++)
                    {
                        ParameterInfo pi = input.Arguments.GetParameterInfo(i);
                        parms1[i] = input.Arguments[pi.Name];
                    }
                }

                if (parms1 == null)
                    parms1 = new object[] { };

                //调用After事件方法
                MethodInfo after = extType.GetMethod("After" + input.MethodBase.Name, types);
                if (after != null)
                {
                    try
                    {
                        message += after.Invoke(ext, parms1);
                    }
                    catch
                    {
                        message += "调用After事件方法出错";
                    }
                }
            }
            try
            {
                if (!string.IsNullOrEmpty(message))
                {
                    //记录日志
                    ILogger logger = new SqlLogger();
                    logger.WriteLog(new LogEntry { Category = this.Category, EventId = this.EventId, EventMessage = message });
                }
            }
            catch
            {

            }

            return result;
        }

        private string GetExtensionTypeName(Type type)
        {
            string ns = type.Namespace;
            string name = type.Name;
            if (type.IsInterface && type.Name.StartsWith("I"))
            {
                return ns + "." + type.Name.Substring(1) + "Extension";
            }

            return ns + "." + type.Name + "Extension";
        }
    }
}
