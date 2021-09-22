using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Business
{
    using Grapecity.Logging.Common;
    using Grapecity.Logging.Providers;

    using Microsoft.Practices.Unity;

    /// <summary>
    /// BaseBusiness类
    /// </summary>
    /// <remarks>
    /// 1. 定义ILogger属性 , 可以通过自动装配使用Logger
    /// 2. 继承ContextBoundObject， 可以使用[Authenticate] [Action]属性
    /// 3. 使用[AuthenticateHandler]属性则需要Policy Injection支持
    /// 4. 详见enterpriselibrary.config
    /// </remarks>
    public class BaseBusiness : ContextBoundObject
    {
        private ILogger _logger = new NullLogger();

        [Dependency]
        public virtual ILogger Logger
        {
            get { return _logger; }
            set { _logger = value; }
        }

        /// <summary>
        /// Guid
        /// </summary>
        /// <returns></returns>
        public virtual Guid GetGuid()
        {
            return DMS.Common.DMSUtility.GetGuid();
        }

        /// <summary>
        /// Guid
        /// </summary>
        /// <returns></returns>
        public virtual string NewGuid()
        {
            return DMS.Common.DMSUtility.NewGuid();
        }
    }
}
