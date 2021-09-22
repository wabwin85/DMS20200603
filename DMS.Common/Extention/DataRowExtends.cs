using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;

namespace DMS.Common.Extention
{
    public static class DataRowExtends
    {
        #region Normal

        public static String GetStringValue(this DataRow value, String key)
        {
            if (value != null && value[key] != null && value[key] != DBNull.Value)
            {
                return value[key].ToString();
            }
            else
            {
                return null;
            }
        }

        public static String GetStringValue(this DataRow value, int index)
        {
            if (value != null && !value.IsNull(index))
            {
                return value[index].ToString();
            }
            else
            {
                return null;
            }
        }

        public static int? GetIntValue(this DataRow value, String key)
        {
            if (value != null && value[key] != null && value[key] != DBNull.Value)
            {
                return Convert.ToInt32(value[key]);
            }
            else
            {
                return null;
            }
        }

        public static int? GetIntValue(this DataRow value, int index)
        {
            if (value != null && !value.IsNull(index))
            {
                return Convert.ToInt32(value[index]);
            }
            else
            {
                return null;
            }
        }

        public static long? GetLongValue(this DataRow value, String key)
        {
            if (value != null && value[key] != null && value[key] != DBNull.Value)
            {
                return Convert.ToInt64(value[key]);
            }
            else
            {
                return null;
            }
        }

        public static long? GetLongValue(this DataRow value, int index)
        {
            if (value != null && !value.IsNull(index))
            {
                return Convert.ToInt64(value[index]);
            }
            else
            {
                return null;
            }
        }

        public static decimal? GetDecimalValue(this DataRow value, String key)
        {
            if (value != null && value[key] != null && value[key] != DBNull.Value)
            {
                return Convert.ToDecimal(value[key]);
            }
            else
            {
                return null;
            }
        }

        public static decimal? GetDecimalValue(this DataRow value, int index)
        {
            if (value != null && !value.IsNull(index))
            {
                return Convert.ToDecimal(value[index]);
            }
            else
            {
                return null;
            }
        }

        public static DateTime? GetDatetimeValue(this DataRow value, String key)
        {
            if (value != null && value[key] != null && value[key] != DBNull.Value)
            {
                return Convert.ToDateTime(value[key]);
            }
            else
            {
                return null;
            }
        }

        public static DateTime? GetDatetimeValue(this DataRow value, int index)
        {
            if (value != null && !value.IsNull(index))
            {
                return Convert.ToDateTime(value[index]);
            }
            else
            {
                return null;
            }
        }

        public static bool? GetBoolValue(this DataRow value, String key)
        {
            if (value != null && value[key] != null && value[key] != DBNull.Value)
            {
                return Convert.ToBoolean(value[key]);
            }
            else
            {
                return null;
            }
        }

        public static bool? GetBoolValue(this DataRow value, int index)
        {
            if (value != null && !value.IsNull(index))
            {
                return Convert.ToBoolean(value[index]);
            }
            else
            {
                return null;
            }
        }

        #endregion

        #region Safe

        public static String GetSafeStringValue(this DataRow value, String key)
        {
            return value.GetStringValue(key).ToSafeString();
        }

        public static String GetSafeStringValue(this DataRow value, int index)
        {
            return value.GetStringValue(index).ToSafeString();
        }

        public static int GetSafeIntValue(this DataRow value, String key)
        {
            return value.GetIntValue(key).ToSafeInt();
        }

        public static int GetSafeIntValue(this DataRow value, int index)
        {
            return value.GetIntValue(index).ToSafeInt();
        }

        public static long GetSafeLongValue(this DataRow value, String key)
        {
            return value.GetLongValue(key).ToSafeLong();
        }

        public static long GetSafeLongValue(this DataRow value, int index)
        {
            return value.GetLongValue(index).ToSafeLong();
        }

        public static decimal GetSafeDecimalValue(this DataRow value, String key)
        {
            return value.GetDecimalValue(key).ToSafeDecimal();
        }

        public static decimal GetSafeDecimalValue(this DataRow value, int index)
        {
            return value.GetDecimalValue(index).ToSafeDecimal();
        }

        public static DateTime GetSafeDatetimeValue(this DataRow value, String key)
        {
            return value.GetDatetimeValue(key).ToSafeDateTime();
        }

        public static DateTime GetSafeDatetimeValue(this DataRow value, int index)
        {
            return value.GetDatetimeValue(index).ToSafeDateTime();
        }

        public static bool GetSafeBoolValue(this DataRow value, String key)
        {
            return value.GetBoolValue(key).ToSafeBool();
        }

        public static bool GetSafeBoolValue(this DataRow value, int index)
        {
            return value.GetBoolValue(index).ToSafeBool();
        }

        #endregion
    }
}
