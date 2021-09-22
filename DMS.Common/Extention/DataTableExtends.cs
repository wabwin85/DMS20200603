using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Collections;

namespace DMS.Common.Extention
{
    public static class DataTableExtends
    {
        public static DataRow GetRow(this DataTable value, int index)
        {
            if (value != null && index >= 0 && value.Rows.Count > index && value.Rows[index] != null)
            {
                return value.Rows[index];
            }
            else
            {
                return null;
            }
        }

        public static List<Hashtable> ToList(this DataTable value)
        {
            List<Hashtable> list = new List<Hashtable>();

            foreach (DataRow r in value.Rows)
            {
                Hashtable h = new Hashtable();
                foreach (DataColumn dc in value.Columns)
                {
                    h.Add(dc.ColumnName, r[dc]);
                }

                list.Add(h);
            }

            return list;
        }

        public static List<KeyValuePair<String, String>> ToKeyValuePair(this DataTable value, String keyCol, String valueCol)
        {
            List<KeyValuePair<String, String>> list = new List<KeyValuePair<String, String>>();

            foreach (DataRow r in value.Rows)
            {
                KeyValuePair<String, String> h = new KeyValuePair<String, String>(r.GetStringValue(keyCol), r.GetStringValue(valueCol));

                list.Add(h);
            }

            return list;
        }
    }
}
