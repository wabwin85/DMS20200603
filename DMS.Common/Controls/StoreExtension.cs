using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.ComponentModel;
using System.Drawing;

namespace DMS.Common.WebControls
{
    using System.Globalization;
    using Newtonsoft.Json;
    using Coolite.Ext.Web;


    [InstanceOf(ClassName = "Coolite.Ext.Store")]
    //[Designer(typeof(EmptyDesigner))]
    [ToolboxBitmap(typeof(Coolite.Ext.Web.Store), "Build.Resources.ToolboxIcons.Store.bmp")]
    [ClientScript(FilePath = "/coolite/coolite-data.js", PathDebug = "/coolite/coolite-data-debug.js", WebResource = "Coolite.Ext.Web.Build.Resources.Coolite.coolite.coolite-data.js", WebResourceDebug = "Coolite.Ext.Web.Build.Resources.Coolite.coolite.coolite-data-debug.js")]
    [Description("The Store class encapsulates a client side cache of Record objects which provide input data for Components such as the GridPanel, the ComboBox, or the DataView.")]
    public class JsonStore : Store
    {
       public void DataBind(string jsonData)
       {
           this.Data = null;
           this.JsonData = jsonData;

           base.DataBind();
       }
    }

}
