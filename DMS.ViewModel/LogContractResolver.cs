using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.ViewModel
{
    public class LogContractResolver : DefaultContractResolver
    {
        /// <summary>
        /// 构造函数
        /// </summary>
        public LogContractResolver()
        {
        }

        protected override IList<JsonProperty> CreateProperties(Type type, MemberSerialization memberSerialization)
        {
            IList<JsonProperty> list =
            base.CreateProperties(type, memberSerialization);
            //只保留清单有列出的属性
            return list.Where(p =>
            {
                return p.AttributeProvider.GetAttributes(typeof(LogAttribute), true).Count > 0;
            }).ToList();
        }
    }
}
