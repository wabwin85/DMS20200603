using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using System.Web.Security;

using Coolite.Ext.Web;
using Lafite.SiteMap.Provider;
namespace DMS.Website
{
    public partial class Site : System.Web.UI.MasterPage
    {
   

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Ext.IsAjaxRequest)
            {
                if (!IsPostBack)
                {

                }
            }

        }

      
    }

   
}
