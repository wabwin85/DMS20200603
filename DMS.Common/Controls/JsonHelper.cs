using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Newtonsoft.Json.Converters;

namespace DMS.Common
{
    using System.Globalization;
    using Newtonsoft.Json;
    using Coolite.Ext.Web;
    using System.Data;
    using System.Collections;
    using System.IO;
    using System.IO.Compression;
    using System.Text.RegularExpressions;

    public class JsonDateTimeConverter : JSONDateTimeJsonConverter
    {
        private const string DateTime_Format = "HH:mm:ss MM/dd/yyyy";

        public virtual string DateTimeFormat
        {
            get { return DateTime_Format; }
        }

        /// <summary>
        /// Writes the JSON representation of the object.
        /// </summary>
        /// <param name="writer">The <see cref="JsonWriter"/> to write to.</param>
        /// <param name="value">The value.</param>
        public override void WriteJson(Newtonsoft.Json.JsonWriter writer, object value)
        {
            if (value is DateTime)
            {
                DateTime date = (DateTime)value;
                if (date != DateTime.MinValue)
                {
                    writer.WriteValue(date.ToString(DateTimeFormat, CultureInfo.InvariantCulture));
                }
                else
                {
                    writer.WriteRawValue("null");
                }
                return;
            }

            writer.WriteRawValue("null");
        }

    }

    public sealed class JsonHelper
    {
        public static object Deserialize(string value)
        {
            return JsonConvert.DeserializeObject(value);
        }

        public static object Deserialize(string value, Type type)
        {
            return JsonConvert.DeserializeObject(value, type);
        }

        public static T Deserialize<T>(string value)
        {
            return JsonConvert.DeserializeObject<T>(value);
        }

        public static byte[] Compress(byte[] bytes)
        {
            using (MemoryStream memoryStream = new MemoryStream())
            {
                GZipStream gZipStreamCompress = new GZipStream(memoryStream, CompressionMode.Compress);
                gZipStreamCompress.Write(bytes, 0, bytes.Length);
                gZipStreamCompress.Close();
                return memoryStream.ToArray();
            }
        }

        public static string Serialize(object data)
        {
            JsonSerializerSettings settings = new JsonSerializerSettings
            {
                ReferenceLoopHandling = ReferenceLoopHandling.Ignore
            };
            IsoDateTimeConverter timeConverter = new IsoDateTimeConverter { DateTimeFormat = "yyyy'-'MM'-'dd HH':'mm':'ss" };
            settings.Converters.Add(timeConverter);
            return JsonConvert.SerializeObject(data, Formatting.None, settings);
        }

        public static string DataTableToJson(DataTable dt)
        {
            ArrayList arrayList = new ArrayList();
            foreach (DataRow dataRow in dt.Rows)
            {
                Dictionary<string, object> dictionary = new Dictionary<string, object>();  //实例化一个参数集合
                foreach (DataColumn dataColumn in dt.Columns)
                {
                    dictionary.Add(dataColumn.ColumnName, dataRow[dataColumn.ColumnName]);
                }
                arrayList.Add(dictionary); //ArrayList集合中添加键值
            }

            return Serialize(arrayList);
        }

        public static ArrayList DataTableToArrayList(DataTable dt)
        {
            ArrayList arrayList = new ArrayList();
            foreach (DataRow dataRow in dt.Rows)
            {
                Dictionary<string, object> dictionary = new Dictionary<string, object>();  //实例化一个参数集合
                foreach (DataColumn dataColumn in dt.Columns)
                {
                    dictionary.Add(dataColumn.ColumnName, dataRow[dataColumn.ColumnName]);
                }
                arrayList.Add(dictionary); //ArrayList集合中添加键值
            }
            return arrayList;
        }

        /// <summary>
        /// json转为DataTable
        /// </summary>
        /// <param name="strJson"></param>
        /// <returns></returns>
        public static DataTable JsonToDataTable(string strJson)
        {
            ////取出表名  
            //Regex rg = new Regex(@"(?<={)[^:]+(?=:/[)", RegexOptions.IgnoreCase);
            //string strName = rg.Match(strJson).Value;
            DataTable tb = null;
            ////去除表名  
            //strJson = strJson.Substring(strJson.IndexOf("[") + 1);
            //strJson = strJson.Substring(0, strJson.IndexOf("]"));

            //获取数据  
            Regex rg = new Regex(@"(?<={)[^}]+(?=})");
            MatchCollection mc = rg.Matches(strJson);
            for (int i = 0; i < mc.Count; i++)
            {
                string strRow = mc[i].Value;
                string[] strRows = strRow.Split(',');

                //创建表  
                if (tb == null)
                {
                    tb = new DataTable();
                    tb.TableName = "";
                    foreach (string str in strRows)
                    {
                        DataColumn dc = new DataColumn();
                        string[] strCell = str.Split(':');

                        dc.ColumnName = strCell[0].ToString().Replace("\"", "").Trim();
                        tb.Columns.Add(dc);
                    }
                    tb.AcceptChanges();
                }

                //增加内容  
                DataRow dr = tb.NewRow();
                for (int r = 0; r < strRows.Length; r++)
                {
                    dr[r] = strRows[r].Split(':')[1].Trim().Replace("，", ",").Replace("：", ":").Replace("/", "").Replace("\"", "").Trim();
                }
                tb.Rows.Add(dr);
                tb.AcceptChanges();
            }

            return tb;
        }

    }
}
