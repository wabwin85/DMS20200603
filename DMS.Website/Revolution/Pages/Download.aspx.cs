using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;

namespace DMS.Website.Revolution.Pages
{
    public partial class Download : System.Web.UI.Page
    {

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(Request.QueryString["downloadname"]) && !string.IsNullOrEmpty(Request.QueryString["filename"]))
            {
                if (Request.QueryString["downtype"] == null)
                {
                    string downname = Request.QueryString["downloadname"];
                    string filename = Request.QueryString["filename"];
                    DownloadFileForDealer(filename, downname);
                }
                //DCMS 下载专用
                else if (Request.QueryString["downtype"].ToString() == "dcms")
                {
                    string downname = Request.QueryString["downloadname"];
                    string filename = Request.QueryString["filename"];
                    DownloadFileForDCMS(filename, downname, "DCMS");
                }
                else if (Request.QueryString["downtype"].ToString() == "cfn")
                {
                    string downname = Request.QueryString["downloadname"];
                    string filename = Request.QueryString["filename"];
                    DownloadFileForCFN(filename, downname, "CFN");
                }
                else if (Request.QueryString["downtype"].ToString() == "help")
                {
                    string downname = Request.QueryString["downloadname"];
                    string filename = Request.QueryString["filename"];
                    DownloadFileForHelp(filename, downname, "Help");
                }
                else if (Request.QueryString["downtype"].ToString() == "ELearning")
                {
                    string downname = Request.QueryString["downloadname"];
                    string filename = Request.QueryString["filename"];
                    DownloadFileForELearning(filename, downname, "ELearning");
                }
                else if (Request.QueryString["downtype"].ToString() == "ShipmentToHospital")
                {
                    string downname = Request.QueryString["downloadname"];
                    string filename = Request.QueryString["filename"];
                    DownloadFileForELearning(filename, downname, "ShipmentAttachment");
                }
                else if (Request.QueryString["downtype"].ToString() == "DealerLicense")
                {
                    string downname = Request.QueryString["downloadname"];
                    string filename = Request.QueryString["filename"];
                    DownloadFileForELearning(filename, downname, "LicenseCatagory");
                }
                else if (Request.QueryString["downtype"].ToString() == "DPComp")
                {
                    string downname = Request.QueryString["downloadname"];
                    string filename = Request.QueryString["filename"];
                    DownloadFileForELearning(filename, downname, "DPComp");
                }
                else if (Request.QueryString["downtype"].ToString() == "DPScoreCard")
                {
                    string downname = Request.QueryString["downloadname"];
                    string filename = Request.QueryString["filename"];
                    DownloadFileForELearning(filename, downname, "DPScoreCard");
                }
                else if (Request.QueryString["downtype"].ToString() == "Promotion")
                {
                    string downname = Request.QueryString["downloadname"];
                    string filename = Request.QueryString["filename"];
                    DownloadFileForELearning(filename, downname, "Promotion");
                }
                else if (Request.QueryString["downtype"].ToString() == "COA")
                {
                    string downname = Request.QueryString["downloadname"];
                    string filename = Request.QueryString["filename"];
                    DownloadCOAFile(filename, downname);
                }
                else if (Request.QueryString["downtype"].ToString() == "TenderFile")
                {
                    string downname = Request.QueryString["downloadname"];
                    string filename = Request.QueryString["filename"];
                    DownloadFileForTender(filename, downname);
                }
                else if (Request.QueryString["downtype"].ToString() == "ContractFileAdmin")
                {
                    string downname = Request.QueryString["downloadname"];
                    string filename = Request.QueryString["filename"];
                    DownloadFile(filename, downname);
                }
                else
                {
                    string downname = Request.QueryString["downloadname"];
                    string filename = Request.QueryString["filename"];
                    DownloadFileForELearning(filename, downname, Request.QueryString["downtype"].ToString());
                }
            }

        }

        //protected string DownloadFile(string filename)
        //{
        //    string fullFileName = AppDomain.CurrentDomain.BaseDirectory.ToString() + DMS.Business.OrderExcel.outputPath + filename;
        //    string strError = string.Empty;
        //    //文件创建成功
        //    if (string.IsNullOrEmpty(strError) && System.IO.File.Exists(fullFileName))
        //    {
        //        string saveFileName = "PurchaseOrder.xls";
        //        try
        //        {
        //            System.IO.FileInfo fi = new System.IO.FileInfo(fullFileName);

        //            Response.Clear();
        //            Response.Charset = "utf-8";
        //            Response.Buffer = true;
        //            this.EnableViewState = false;
        //            Response.ContentEncoding = System.Text.Encoding.UTF8;

        //            Response.AppendHeader("Content-Disposition", "attachment;filename=" + HttpUtility.UrlEncode(saveFileName, System.Text.Encoding.UTF8));

        //            Response.ContentType = "application/vnd.ms-excel";

        //            Response.WriteFile(fullFileName);
        //            Response.Flush();
        //            Response.Close();

        //            Response.End();
        //            fi.Delete();

        //        }
        //        catch (Exception ex)
        //        {
        //            strError = ex.Message;
        //        }
        //    }
        //    return strError;
        //}

        protected void DownloadFileForDealer(string filename, string downname)
        {
            string savename = downname;

            try
            {
                filename = AppDomain.CurrentDomain.BaseDirectory.ToString() + "Upload\\UploadFile\\" + filename;

                Response.Clear();
                Response.Buffer = true;

                //Response.ContentType = "application/octet-stream";
                //Response.AddHeader("Content-Disposition ", "attachment;FileName= " + HttpUtility.UrlEncode(savename, System.Text.Encoding.UTF8));

                //System.IO.FileStream filestream = System.IO.File.OpenRead(filename);
                //byte[] bytes = new byte[filestream.Length];
                //filestream.Read(bytes, 0, bytes.Length);
                //filestream.Close();
                //Response.BinaryWrite(bytes);
                //Response.Flush();
                //Response.End();



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
                Response.End();
            }
            catch (Exception ex)
            {

            }

        }

        protected void DownloadFileForDCMS(string filename, string downname, string documentName)
        {
            string savename = downname;

            try
            {
                filename = AppDomain.CurrentDomain.BaseDirectory.ToString() + "Upload\\UploadFile\\" + documentName + "\\" + filename;

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
                Response.End();
            }
            catch (Exception ex)
            {

            }

        }

        protected void DownloadFileForCFN(string filename, string downname, string documentName)
        {
            string savename = downname;

            try
            {
                filename = AppDomain.CurrentDomain.BaseDirectory.ToString() + "Upload\\UPN\\Licence\\" + filename;
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
                    Response.End();
                }
                else
                {
                    //Ext.Msg.Alert("Error", "文件不存在！").Show();
                    Response.Write("您所下载的产品注册证不存在!");
                }
            }
            catch (Exception ex)
            {

            }

        }

        protected void DownloadFileForELearning(string filename, string downname, string documentName)
        {
            string savename = downname;

            try
            {
                filename = AppDomain.CurrentDomain.BaseDirectory.ToString() + "Upload\\UploadFile\\" + documentName + "\\" + filename;

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
                Response.End();
            }
            catch (Exception ex)
            {

            }

        }

        protected void DownloadFileForHelp(string filename, string downname, string documentName)
        {
            string savename = downname;

            try
            {
                filename = AppDomain.CurrentDomain.BaseDirectory.ToString() + "Upload\\DownLoad\\" + filename;

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
                Response.End();
            }
            catch (Exception ex)
            {

            }

        }
        protected void DownloadCOAFile(string filename, string downname)
        {
            string savename = filename;

            try
            {
                filename = AppDomain.CurrentDomain.BaseDirectory.ToString() + "Upload\\COA\\" + downname;
                if (File.Exists(filename))
                {

                    Response.Clear();
                    Response.Buffer = true;
                    filename = AppDomain.CurrentDomain.BaseDirectory.ToString() + "Upload\\COA\\" + downname;
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
                    Response.End();
                }
                else
                {
                    //Ext.Msg.Alert("Error", "文件不存在！").Show();
                    Response.Write("您所下载的COA文件不存在!");
                }
            }
            catch (Exception ex)
            {

            }

        }
        protected void DownloadFile(string filename, string downname)
        {
            string savename = downname;

            try
            {
                filename = AppDomain.CurrentDomain.BaseDirectory.ToString() + "/" + filename;

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
                Response.End();
            }
            catch (Exception ex)
            {

            }
        }
        //授权导出pdf
        protected void DownloadFileForTender(string filename, string downname)
        {
            downname = downname + ".pdf";
            try
            {
                filename = AppDomain.CurrentDomain.BaseDirectory.ToString() + "Upload\\TenderAuthorization\\" + filename;
                Response.Clear();
                Response.Buffer = true;
                //以字符流的形式下载文件 
                System.IO.FileStream fs = new System.IO.FileStream(filename, System.IO.FileMode.Open);
                byte[] bytes = new byte[(int)fs.Length];
                fs.Read(bytes, 0, bytes.Length);
                fs.Close();
                Response.ContentType = "application/octet-stream";
                //通知浏览器下载文件而不是打开 
                Response.AddHeader("Content-Disposition", "attachment; filename=" + HttpUtility.UrlEncode(downname, System.Text.Encoding.UTF8));
                Response.BinaryWrite(bytes);
                Response.Flush();
                Response.End();
            }
            catch (Exception ex)
            { }
        }
    }
}
