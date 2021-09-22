using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections;
using System.Web.UI.WebControls;

namespace DMS.Common.Extention
{
    public static class HashtableExtends
    {
        #region Normal

        public static String GetStringValue(this Hashtable value, String key)
        {
            if (value != null && value.Contains(key) && value[key] != null)
            {
                return value[key].ToString();
            }
            else
            {
                return null;
            }
        }

        public static int? GetIntValue(this Hashtable value, String key)
        {
            if (value != null && value.Contains(key) && value[key] != null)
            {
                return Convert.ToInt32(value[key]);
            }
            else
            {
                return null;
            }
        }

        public static decimal? GetDecimalValue(this Hashtable value, String key)
        {
            if (value != null && value.Contains(key) && value[key] != null)
            {
                return Convert.ToDecimal(value[key]);
            }
            else
            {
                return null;
            }
        }

        public static DateTime? GetDatetimeValue(this Hashtable value, String key)
        {
            if (value != null && value.Contains(key) && value[key] != null)
            {
                return Convert.ToDateTime(value[key]);
            }
            else
            {
                return null;
            }
        }

        public static bool? GetBooleanValue(this Hashtable value, String key)
        {
            if (value != null && value.Contains(key) && value[key] != null)
            {
                return Convert.ToBoolean(value[key]);
            }
            else
            {
                return null;
            }
        }

        public static Guid? GetGuidValue(this Hashtable value, String key)
        {
            if (value != null && value.Contains(key) && value[key] != null)
            {
                return new Guid(value[key].ToSafeString());
            }
            else
            {
                return null;
            }
        }

        #endregion

        #region Safe

        public static String GetSafeStringValue(this Hashtable value, String key)
        {
            return value.GetStringValue(key).ToSafeString();
        }

        public static int GetSafeIntValue(this Hashtable value, String key)
        {
            return value.GetIntValue(key).ToSafeInt();
        }

        public static decimal GetSafeDecimalValue(this Hashtable value, String key)
        {
            return value.GetDecimalValue(key).ToSafeDecimal();
        }

        public static DateTime GetSafeDatetimeValue(this Hashtable value, String key)
        {
            return value.GetDatetimeValue(key).ToSafeDateTime();
        }

        public static bool GetSafeBooleanValue(this Hashtable value, String key)
        {
            return value.GetBooleanValue(key).ToSafeBool();
        }

        public static Guid GetSafeGuidValue(this Hashtable value, String key)
        {
            return value.GetGuidValue(key).ToSafeGuid();
        }

        #endregion

        #region Condition

        public static void AddCondition(this Hashtable condition, String key, int value)
        {
            condition.Add(key, value);
        }

        public static void AddCondition(this Hashtable condition, String key, int value, int ignoreValue)
        {
            if (value == ignoreValue)
            {
                condition.AddNullCondition(key);
            }
            else
            {
                condition.Add(key, value);
            }
        }

        public static void AddCondition(this Hashtable condition, String key, String value)
        {
            condition.Add(key, value);
        }

        public static void AddNullableCondition(this Hashtable condition, String key, String value)
        {
            if (String.IsNullOrEmpty(value))
            {
                condition.AddNullCondition(key);
            }
            else
            {
                condition.Add(key, value);
            }
        }

        public static void AddCondition(this Hashtable condition, String key, String value, String ignoreValue)
        {
            if (value == ignoreValue)
            {
                condition.AddNullCondition(key);
            }
            else
            {
                condition.Add(key, value);
            }
        }

        public static void AddCondition(this Hashtable condition, String key, Guid value)
        {
            condition.Add(key, value);
        }

        public static void AddCondition(this Hashtable condition, String key, Guid value, Guid ignoreValue)
        {
            if (value == ignoreValue)
            {
                condition.AddNullCondition(key);
            }
            else
            {
                condition.Add(key, value);
            }
        }

        public static void AddCondition(this Hashtable condition, String key, bool value)
        {
            condition.Add(key, value);
        }

        public static void AddCondition(this Hashtable condition, String key, bool value, bool ignoreValue)
        {
            if (value == ignoreValue)
            {
                condition.AddNullCondition(key);
            }
            else
            {
                condition.Add(key, value);
            }
        }

        public static void AddNullCondition(this Hashtable condition, String key)
        {
            condition.Add(key, null);
        }

        public static void AddIntCondition(this Hashtable condition, String key, String value)
        {
            if (String.IsNullOrEmpty(value))
            {
                condition.AddNullCondition(key);
            }
            else
            {
                condition.Add(key, Convert.ToInt32(value));
            }
        }

        public static void AddDecimalCondition(this Hashtable condition, String key, String value)
        {
            if (String.IsNullOrEmpty(value))
            {
                condition.AddNullCondition(key);
            }
            else
            {
                condition.Add(key, Convert.ToDecimal(value));
            }
        }

        public static void AddBoolCondition(this Hashtable condition, String key, String value)
        {
            if (String.IsNullOrEmpty(value))
            {
                condition.AddNullCondition(key);
            }
            else
            {
                condition.Add(key, Convert.ToBoolean(value));
            }
        }

        public static void AddDateTimeCondition(this Hashtable condition, String key, String value)
        {
            if (String.IsNullOrEmpty(value))
            {
                condition.AddNullCondition(key);
            }
            else
            {
                condition.Add(key, Convert.ToDateTime(value));
            }
        }

        #endregion
    }
}
