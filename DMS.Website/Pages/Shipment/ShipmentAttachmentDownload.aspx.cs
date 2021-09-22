using DMS.Business;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DMS.Website.Pages.Shipment
{
    public partial class ShipmentAttachmentDownload : System.Web.UI.Page
    {
        private IShipmentBLL business = new ShipmentBLL();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string id = Request.QueryString["ID"].ToString();
                DataTable dt = business.ShipmentAttachmentDownload(id).Tables[0];
                if (dt.Rows.Count > 0)
                {
                    string filename = dt.Rows[0]["AT_Url"].ToString();
                    string download = dt.Rows[0]["AT_Name"].ToString();
                    string savename = download;
                    try
                    {
                        filename = AppDomain.CurrentDomain.BaseDirectory.ToString() + "Upload\\UploadFile\\ShipmentAttachment\\" + filename;
                        if (File.Exists(filename))
                        {
                            Response.Clear();
                            Response.Buffer = true;          
                            //以字符流的形式下载文件 
                            System.IO.FileStream fs = new System.IO.FileStream(filename, System.IO.FileMode.Open);
                            byte[] bytes = new byte[(int)fs.Length];
                            fs.Read(bytes, 0, bytes.Length);
                            fs.Close();
                            Response.ContentType = "application/octet-stream";
                            //通知浏览器下载文件而不是打开 
                            Response.AddHeader("Content-Disposition", "attachment; filename=" + HttpUtility.UrlEncode(savename, System.Text.Encoding.UTF8));
                            Response.BinaryWrite(bytes);
                            Response.Flush();
                            Response.Write("<script language=javascript>windows.close();</script>");
                            Response.End();                     
                        }
                        else
                        {
                            Response.Write("<script language=javascript>alert('附件不存在！');</script>");
                        }
                    }
                    catch (Exception ex)
                    {
                        ex.ToString();
                    }
                }
               
            }
        }
    }
}