using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Model.WeChat
{
    public class HandleResult
    {
        public bool success
        {
            get;
            set;
        }

        public string msg
        {
            get;
            set;
        }

        public object data
        {
            get;
            set;
        }
    }

    [Serializable]
    public class WeChatParams
    {
        public string UserToken { get; set; }
        public string ActionName { get; set; }
        public string MethodName { get; set; }
        public Dictionary<string, Object> Parameters = new Dictionary<string, object>();
        public object Result;
    }
}
