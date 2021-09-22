using DMS.Business;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DMS.Website.Revolution.Pages.Shipment
{
    public partial class ShipmentList : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string UploadShipmentAttachment(int index, string fileName, string fileUrl)
        {
            string rtnVal;
            string fileNewName;
            fileNewName = fileUrl.Substring(fileUrl.LastIndexOf("/") + 1, fileUrl.Length - fileUrl.LastIndexOf("/") - 1);

            IShipmentBLL _business = new ShipmentBLL();
            int cn = _business.InsertAttachmentForShipmentUploadFile(fileName, fileNewName);

            rtnVal = string.Format("{0},{1}", index, cn);

            return rtnVal;
        }
    }
}