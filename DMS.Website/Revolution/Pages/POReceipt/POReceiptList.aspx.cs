using DMS.Business;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DMS.Website.Revolution.Pages.POReceipt
{
    public partial class POReceiptList : System.Web.UI.Page
    {
        public IPOReceipt business = new DMS.Business.POReceipt();
        protected void Page_Load(object sender, EventArgs e)
        {

        }


    }
}