using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
namespace DMS.Website.Controls
{
    using Coolite.Ext.Web;
    using DMS.Model;
    using DMS.Website.Common;
    public partial class CFNEditor : BaseUserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        public void CreateCFN()
        {
            this.Id1.Text = this.NewGuid();
        }

    }
}