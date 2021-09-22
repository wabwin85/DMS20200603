using DMS.BusinessService.Attachment;
using DMS.Common.Extention;
using System;

namespace DMS.Website.Revolution.Pages.Util
{
    public partial class AttachmentDownload : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                String AttachmentId = Request.QueryString["AttachmentId"];
                String AttachmentType = Request.QueryString["AttachmentType"];
                String DownloadCookie = Request.QueryString["DownloadCookie"].IsNullOrEmpty() ? "DefaultCookie" : Request.QueryString["DownloadCookie"];

                if (AttachmentId.IsNullOrEmpty())
                {
                    throw new Exception("Empty of FileId");
                }
                else
                {
                    DownloadAttachmentService service = new DownloadAttachmentService();

                    service.Download(AttachmentId.ToSafeGuid(), AttachmentType, DownloadCookie);
                }
            }
        }
    }
}