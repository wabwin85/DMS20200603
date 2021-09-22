/**********************************************
 *
 * NameSpace   : DMS.Common 
 * ClassName   : DictionaryHelper
 * Created Time: 2009-7 
 * Author      : Donson
 ****** Copyright (C) 2009/2010 - GrapeCity*****
 *
***********************************************/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Common
{
    using Lafite.RoleModel.Domain;
    using Lafite.RoleModel.Service;

    public static class DictionaryHelper
    {
        public static IDictionary<string, string> GetDictionary(string type)
        {
            IGeneralDictionary dictbiz = new GeneralDictionary();
            return dictbiz.GetDictionaryByType(type);
        }

        public static Hashtable GetHashtable(string type)
        {
            IGeneralDictionary dictbiz = new GeneralDictionary();
            return dictbiz.GetHashTableByType(type);
        }


        public static IList<DictionaryDomain> GetDomainListByFilter(DictionaryDomain DictDomain)
        {
            IGeneralDictionary dictbiz = new GeneralDictionary();
            return dictbiz.GetDomainListByFilter(DictDomain);
        }

        public static string GetDictionaryNameById(string type, string id)
        {
            string str = string.Empty;
            IDictionary<string, string> dictionary = GetDictionary(type);
            if ((dictionary != null) && dictionary.ContainsKey(id))
            {
                str = dictionary[id];
            }
            return str;
        }

        public static string GetDictionaryNamesById(string type, string id)
        {
            string str = "";
            IDictionary<string, string> dictionary = GetDictionary(type);
            string[] strArray = id.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
            if (dictionary != null)
            {
                foreach (KeyValuePair<string, string> pair in dictionary)
                {
                    foreach (string str2 in strArray)
                    {
                        if (pair.Key == str2)
                        {
                            str = str + pair.Value + ",";
                        }
                    }
                }
            }
            if (!string.IsNullOrEmpty(str))
            {
                str = str.Substring(0, str.Length - 1);
            }
            return str;
        }

        public static IList<KeyValuePair<string, string>> GetKeyValueList(string type)
        {
            IList<KeyValuePair<string, string>> result = new List<KeyValuePair<string, string>>();

            IGeneralDictionary dictionary = new GeneralDictionary();
            IList<DictionaryDomain> l = dictionary.GetListByType(type);
            foreach (DictionaryDomain dd in l)
            {
                KeyValuePair<string, string> kvp = new KeyValuePair<string, string>(dd.DictKey, dd.Value1);
                result.Add(kvp);
            }
            return result;
        }
        public static IList<DictionaryDomain> GetAllKeyValueList(string type)
        {
            IList<KeyValuePair<string, string>> result = new List<KeyValuePair<string, string>>();

            IGeneralDictionary dictionary = new GeneralDictionary();
            IList<DictionaryDomain> l = dictionary.GetListByType(type);
            return l;
        }
        public static IList<KeyValuePair<string, string>> GetKeyValueListByParams(IList<DictionaryDomain> l)
        {
            IList<KeyValuePair<string, string>> result = new List<KeyValuePair<string, string>>();
            foreach (DictionaryDomain dd in l)
            {
                KeyValuePair<string, string> kvp = new KeyValuePair<string, string>(dd.DictKey, dd.Value1);
                result.Add(kvp);
            }
            return result;
        }
        public static string GetPairValue(IList<KeyValuePair<string, string>> list, string id)
        {
            foreach (KeyValuePair<string, string> k in list)
            {
                if (k.Key == id)
                {
                    return k.Value;
                }
            }
            return "";
        }
    }
}
