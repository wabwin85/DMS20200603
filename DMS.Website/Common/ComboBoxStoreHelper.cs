using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI.HtmlControls;

namespace DMS.Website.Common
{
    using System.Web.UI; 
    using Coolite.Ext.Web;

    public static class ComboBoxStoreHelper
    {
        /// <summary>
        /// Creates the store.
        /// </summary>
        /// <param name="container">The container.</param>
        /// <param name="storeName">Name of the store.</param>
        /// <param name="jsreader">The jsreader.</param>
        /// <param name="sortField">The sort field.</param>
        /// <returns></returns>
        public static Store CreateStore(Control container, string storeName, JsonReader jsreader, string sortField)
        {
            Store myStore = new Store();
            myStore.ID = storeName;
            myStore.AutoLoad = true;
            myStore.Reader.Add(jsreader);
            if (!string.IsNullOrEmpty(sortField))
            {
                myStore.SortInfo = new SortInfo(sortField, SortDirection.ASC);
            }

            if (container != null)
                container.Controls.AddAt(0, myStore);

            return myStore;
        
        }

        /// <summary> 创建地区Store
        /// <remarks>
        /// <example>
        /// <![CDATA[
        ///     <Reader> 
        ///        <ext:JsonReader ReaderID="TerId">
        ///            <Fields>
        ///                <ext:RecordField Name="TerId" />
        ///                <ext:RecordField Name="Description" />
        ///            </Fields>
        ///        </ext:JsonReader>
        ///    </Reader>
        ///    <SortInfo Field="TerId" Direction="ASC"  />
        /// ]]>
        /// </example>
        /// </remarks>
        /// </summary>
        /// <param name="container"></param>
        /// <param name="storeName"></param>
        /// <returns>Store</returns>
        public static Store CreateTerritoryStore(Control container, string storeName)
        {
            JsonReader jsreader = new JsonReader();
            RecordField rfKey = new RecordField("TerId", RecordFieldType.String);
            RecordField rfValue = new RecordField("Description", RecordFieldType.String);
            jsreader.Fields.Add(rfKey);
            jsreader.Fields.Add(rfValue);
            jsreader.ReaderID = "TerId";

            Store myStore = CreateStore(container, storeName, jsreader, "TerId");

            return myStore;
        }


        /// <summary>
        /// 创建字典表Store
        /// </summary>
        /// <remarks>
        /// <example>
        /// <![CDATA[
        /// <ext:Store ID="Store2" runat="server" UseIdConfirmation="true" OnRefreshData="Store_HospitalGrade">
        ///    <Reader>
        ///        <ext:JsonReader ReaderID="Key">
        ///            <Fields>
        ///                <ext:RecordField Name="Key" />
        ///                <ext:RecordField Name="Value" />
        ///            </Fields>
        ///        </ext:JsonReader>
        ///    </Reader>
        ///    <SortInfo Field="Key" Direction="ASC" />
        ///    <Listeners>
        ///    </Listeners>
        ///</ext:Store>
        ///]]>
        /// </example>
        /// </remarks>
        /// <param name="container"></param>
        /// <param name="storeName"></param>
        /// <returns>Store</returns>
        public static Store CreateDictionaryStore(Control container, string storeName)
        {
            JsonReader jsreader = new JsonReader();
            RecordField rfKey = new RecordField("Key", RecordFieldType.String);
            RecordField rfValue = new RecordField("Value", RecordFieldType.String);
            jsreader.Fields.Add(rfKey);
            jsreader.Fields.Add(rfValue);
            jsreader.ReaderID = "Key";

            Store myStore = CreateStore(container, storeName, jsreader, "Key");


            return myStore;
        }



        /// <summary>创建组织结构Store
        /// <remarks>
        /// <example>
        /// <![CDATA[
        /// <Reader>
        ///     <ext:JsonReader ReaderID="Id">           
        ///          <Fields>
        ///              <ext:RecordField Name="Id" />
        ///              <ext:RecordField Name="AttributeName" />
        ///          </Fields>
        ///      </ext:JsonReader>
        ///  </Reader>
        ///  <SortInfo Field="Id" Direction="ASC" />
        /// ]]>
        /// </example>
        /// </remarks>
        /// </summary>
        /// <param name="container"></param>
        /// <param name="storeName"></param>
        /// <returns></returns>
        public static Store CreateAttributeStore(Control container, string storeName)
        {

            JsonReader jsreader = new JsonReader();
            RecordField rfKey = new RecordField("Id", RecordFieldType.String);
            RecordField rfValue = new RecordField("AttributeName", RecordFieldType.String);
            jsreader.Fields.Add(rfKey);
            jsreader.Fields.Add(rfValue);
            jsreader.ReaderID = "Id";

            Store myStore = CreateStore(container, storeName, jsreader, "Id");


            return myStore;
        }

    }
}
