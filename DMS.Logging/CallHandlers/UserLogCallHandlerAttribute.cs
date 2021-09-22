using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.Practices.Unity.InterceptionExtension;
using Microsoft.Practices.Unity;

namespace DMS.Logging.CallHandlers
{
    [AttributeUsage(AttributeTargets.Class | AttributeTargets.Method | AttributeTargets.Property)]
    public class UserLogCallHandlerAttribute : HandlerAttribute
    {
        public string Category { get; set; }
        public string EventId { get; set; }
        public string EventMessage { get; set; }

        public override ICallHandler CreateHandler(IUnityContainer container)
        {
            return new UserLogCallHandler() { Category = this.Category, EventId = this.EventId, EventMessage = this.EventMessage };
        }
    }

}
