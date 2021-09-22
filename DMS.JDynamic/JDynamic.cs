using Newtonsoft.Json.Linq;
using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Dynamic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DMS.JsonDynamic
{
    public class JDynamic : DynamicObject
    {
        private readonly ConcurrentDictionary<string, object> cacheMember = new ConcurrentDictionary<string, object>();
        public object Value { get; private set; }

        public JDynamic(string json)
        {
            if (json.StartsWith("{"))
                Value = JObject.Parse(json);
            else if (json.StartsWith("["))
                Value = JArray.Parse(json);
            else
                Value = json;
        }

        public override bool TryGetMember(GetMemberBinder binder, out object result)
        {
            return TryGetField(binder.Name, out result);
        }

        public override bool TryGetIndex(GetIndexBinder binder, object[] indexes, out object result)
        {
            result = null;
            var key = indexes[0];
            if (key is int && Value is JArray)
            {
                string keyName = "List[" + key.ToString() + "]";
                if (!cacheMember.TryGetValue(keyName, out result))
                {
                    result = new JDynamic((((JArray)Value)[key]).ToString());
                    cacheMember.TryAdd(keyName, result);
                }
                return true;
            }
            else if (key is string)
            {
                return TryGetField(key.ToString(), out result);
            }
            return false;
        }

        private bool TryGetField(string name, out object result)
        {
            if (cacheMember.TryGetValue(name, out result))
                return true;
            if (Value is JObject)
            {
                JToken token = ((JObject)Value)[name];
                if (token.Type == JsonTokenType.String)
                    result = token.Value<string>();
                else if (token.Type == JsonTokenType.Object || token.Type == JsonTokenType.Array)
                    result = new JDynamic(token.ToString());
                else
                    result = token.ToString();

                cacheMember.TryAdd(name, result);
                return true;
            }
            else if (Value is JArray && (name == "Count" || name == "Length"))
            {
                result = ((JArray)Value).Count;
                cacheMember.TryAdd(name, result);
                return true;
            }
            return false;
        }

        public override string ToString()
        {
            return Value.ToString();
        }
    }
}

