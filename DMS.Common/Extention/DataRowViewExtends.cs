using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;

namespace DMS.Common.Extention
{
    public static class DataRowViewExtends
    {
        #region Normal

        public static String GetStringValue(this DataRowView value, String key)
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

        public static int? GetIntValue(this DataRowView value, String key)
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

        public static decimal? GetDecimalValue(this DataRowView value, String key)
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

        public static DateTime? GetDatetimeValue(this DataRowView value, String key)
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

        #endregion

        #region Safe

        public static String GetSafeStringValue(this DataRowView value, String key)
        {
            return value.GetStringValue(key).ToSafeString();
        }

        public static int GetSafeIntValue(this DataRowView value, String key)
        {
            return value.GetIntValue(key).ToSafeInt();
        }

        public static decimal GetSafeDecimalValue(this DataRowView value, String key)
        {
            return value.GetDecimalValue(key).ToSafeDecimal();
        }

        public static DateTime GetSafeDatetimeValue(this DataRowView value, String key)
        {
            return value.GetDatetimeValue(key).ToSafeDateTime();
        }

        #endregion
    }
}
