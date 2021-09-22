using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Web;
using System.Collections.Specialized;

namespace DMS.Common.Common
{
    public static class CommonFunction
    {
        public static DataSet ToDataSet<T>(this IList<T> list)
        {
            Type elementType = typeof(T);
            var ds = new DataSet();
            var t = new DataTable();
            ds.Tables.Add(t);
            elementType.GetProperties()
                .ToList()
                .ForEach(
                    propInfo =>
                        t.Columns.Add(propInfo.Name,
                            Nullable.GetUnderlyingType(propInfo.PropertyType) ?? propInfo.PropertyType));
            foreach (T item in list)
            {
                var row = t.NewRow();
                elementType.GetProperties()
                    .ToList()
                    .ForEach(propInfo => row[propInfo.Name] = propInfo.GetValue(item, null) ?? DBNull.Value);
                t.Rows.Add(row);
            }
            return ds;
        }

        /// <summary>
        /// 将DataTable中的列重命名
        /// </summary>
        /// <param name="dt"></param>
        /// <param name="strOldColumnName"></param>
        /// <param name="strNewColumnName"></param>
        public static void ChangeColumnName(this DataTable dt, string strOldColumnName, string strNewColumnName)
        {
            if (dt.Columns.Contains(strOldColumnName))
            {
                dt.Columns[strOldColumnName].ColumnName = strNewColumnName;
            }
        }

        /// <summary>
        /// 移除DataTable中的列
        /// </summary>
        /// <param name="dt"></param>
        /// <param name="listColumnNames"></param>
        public static void RemoveColumn(DataTable dt, List<string> listColumnNames)
        {
            foreach (string strColumnName in listColumnNames)
            {
                if (dt.Columns.Contains(strColumnName))
                {
                    dt.Columns.Remove(strColumnName);
                }
            }
        }

        /// <summary>
        /// 调整DataTable中列的顺序，并且移除不在排序列表中的列以供导出用
        /// </summary>
        /// <param name="dt"></param>
        /// <param name="listColumnNames">需要保留的列</param>
        public static void SetColumnIndexAndRemoveColumn(DataTable dt, Dictionary<string, string> listColumnNames)
        {
            List<string> listRemoveColumns = new List<string>();
            for (int i = 0; i < dt.Columns.Count; i++)
            {
                string strRemoveColumnName = dt.Columns[i].ColumnName;
                if (!listColumnNames.ContainsKey(strRemoveColumnName))
                {
                    listRemoveColumns.Add(strRemoveColumnName);
                }
            }
            RemoveColumn(dt, listRemoveColumns);

            int j = 0;
            foreach (var listColumnName in listColumnNames)
            {
                string strColumnName = listColumnName.Key;
                if (dt.Columns.Contains(strColumnName))
                {
                    dt.Columns[strColumnName].SetOrdinal(j);
                    dt.Columns[strColumnName].ColumnName = listColumnName.Value;
                    j++;
                }
            }
        }

        /// <summary>
        /// 调整DataTable中列的顺序
        /// </summary>
        /// <param name="dt"></param>
        /// <param name="listColumnNames"></param>
        public static void SetColumnIndex(DataTable dt, List<string> listColumnNames)
        {
            string strColumnName;
            for (int i = 0; i < listColumnNames.Count(); i++)
            {
                strColumnName = listColumnNames[i];
                if (dt.Columns.Contains(strColumnName))
                {
                    dt.Columns[strColumnName].SetOrdinal(i);
                }
            }
        }

        public static string ConertToXml(DataTable dt)
        {
            dt.TableName = "Table";
            if (null != dt.DataSet)
            {
                dt.DataSet.DataSetName = "DocumentElement";
            }
            System.IO.MemoryStream ms = new System.IO.MemoryStream();
            dt.WriteXml(ms);
            string xmlContent = System.Text.Encoding.UTF8.GetString(ms.ToArray());
            return string.Format("<?xml   version=\"1.0\"   encoding=\"unicode\"   ?> {0}", xmlContent);
        }

        public static T GetEnumAttribute<T>(Enum source) where T : Attribute
        {
            Type type = source.GetType();
            var sourceName = Enum.GetName(type, source);
            FieldInfo field = type.GetField(sourceName);
            object[] attributes = field.GetCustomAttributes(typeof(T), false);
            foreach (var o in attributes)
            {
                if (o is T)
                    return (T)o;
            }
            return null;
        }

        public static string GetDescription(Enum source)
        {
            var str = GetEnumAttribute<DescriptionAttribute>(source);
            if (str == null)
                return null;
            return str.Description;
        }

        public static Nullable<T> ConvertStringToEnum<T>(string input) where T : struct
        {
            if (!typeof(T).IsEnum)
            {
                throw new ArgumentException("Generic Type 'T' must be an Enum");
            }
            if (!string.IsNullOrEmpty(input))
            {
                if (Enum.GetNames(typeof(T)).Any(
                      e => e.Trim().ToUpperInvariant() == input.Trim().ToUpperInvariant()))
                {
                    return (T)Enum.Parse(typeof(T), input, true);
                }
            }
            return null;
        }

        public static string CheckColumnName(DataTable dt, List<string> listColumnName)
        {

            StringBuilder strNotExistsColumnName = new StringBuilder();
            foreach (string strColumnName in listColumnName)
            {
                if (!dt.Columns.Contains(strColumnName))
                {
                    strNotExistsColumnName.Append(";" + strColumnName);
                }
            }
            return strNotExistsColumnName.ToString();
        }

        public static string ReplaceString(string strOrg)
        {
            return strOrg.Replace("\"", "\\'");
        }

        /// <summary>
        /// 将enum和其说明转为键值对
        /// </summary>
        /// <returns></returns>
        public static NameValueCollection ConvertEnumDescriptionValue<T>()
        {
            NameValueCollection nvc = new NameValueCollection();
            Type type = typeof(DescriptionAttribute);

            foreach (FieldInfo fi in typeof(T).GetFields())
            {
                object[] arr = fi.GetCustomAttributes(type, true);
                if (arr.Length > 0)
                {
                    nvc.Add(fi.Name, ((DescriptionAttribute)arr[0]).Description);
                }
            }
            return nvc;
        }

        public static string ConvertNumberToSN(int Number)
        {
            string strResult;
            int intStep = Number - 1;
            var charSN = (char)(char.Parse("A") + intStep);
            strResult = new string(new[] { charSN });
            return strResult;
        }

    }
}
