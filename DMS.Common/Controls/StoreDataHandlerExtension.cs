using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
    
namespace DMS.Common
{
    using Coolite.Ext.Web;
    using Newtonsoft.Json;

    public static class StoreDataHandlerExtension
    {
        public static ChangeRecords<T> CustomObjectData<T>(this StoreDataHandler storeDataHandler)
        {
            JsonSerializer serializer = new JsonSerializer();
            serializer.MissingMemberHandling = MissingMemberHandling.Ignore;
            
            serializer.NullValueHandling = NullValueHandling.Ignore;

            StringReader sr = new StringReader(storeDataHandler.JsonData);
            ChangeRecords<T> data = (ChangeRecords<T>)serializer.Deserialize(sr, typeof(ChangeRecords<T>));
            return data;
        }
    }
}
