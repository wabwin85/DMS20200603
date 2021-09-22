using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DMS.Website.Pages.Contract
{
    using DMS.Website.Common;
    using DMS.Business;
    using Microsoft.Practices.Unity;
    using DMS.Model.Data;
    using DMS.Model;
    using Coolite.Ext.Web;
    using Lafite.RoleModel.Security;
    using System.IO;
    using System.Collections.Generic;
    using DMS.Common;
    using System.Data;
    using System.Text;
    using System.Collections;
    using DMS.Business.Contract;

    public partial class MergeAttachment : BasePage
    {
        IRoleModelContext _context = RoleModelContext.Current;
        private IAttachmentBLL _attachmentBLL = null;
        private const string ATTACHMENT_FILE_PATH = "\\Upload\\UploadFile\\DCMS\\";
        [Dependency]
        public IAttachmentBLL attachmentBLL
        {
            get { return _attachmentBLL; }
            set { _attachmentBLL = value; }
        }
        private IContractMasterBLL _contractBll = new ContractMasterBLL();
        private IContractAppointmentService _appointment = new ContractAppointmentService();
        private IContractAmendmentService _amendment = new ContractAmendmentService();
        private IContractRenewalService _renewal = new ContractRenewalService();
        private IContractTerminationService termination = new ContractTerminationService();
        private IMessageBLL _messageBLL = new MessageBLL();
        private IDealerMasters _dealerMaster = new DealerMasters();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                if (Request.QueryString["Cmid"] != null && Request.QueryString["ParmetType"] != null && Request.QueryString["ContId"] != null
                    && Request.QueryString["DealerId"] != null && Request.QueryString["DealerType"] != null)
                {
                    this.hdDealerType.Value = Request.QueryString["DealerType"].ToString();
                    this.hdContractType.Value = Request.QueryString["ParmetType"];
                    this.hdContractId.Value = Request.QueryString["ContId"];

                    if (this.hdDealerType.Value.Equals(DealerType.T2.ToString()))
                    {
                        //维护二级经销商信息，附件关联经销商ID
                        //this.hdCmId.Value = Request.QueryString["DealerId"];

                        //设定附件参数类型
                        this.hdParmetType.Value = SR.Const_ContractAnnex_Type_T2;
                        this.hdSystemCreateAttachment.Value = "T2_SystemCreate";
                    }
                    else
                    {
                        //维护一级经销商或者设备经销商，附件关联合同主表ID
                        //this.hdCmId.Value = Request.QueryString["Cmid"];
                        if (this.hdDealerType.Value.Equals(DealerType.T1.ToString()))
                        {
                            //设定附件参数类型
                            this.hdParmetType.Value = SR.Const_ContractAnnex_Type_T1;
                            this.hdSystemCreateAttachment.Value = "T1_SystemCreate";
                        }
                        else
                        {
                            //设定附件参数类型
                            this.hdParmetType.Value = SR.Const_ContractAnnex_Type_LP;
                            this.hdSystemCreateAttachment.Value = "LP_SystemCreate";
                        }
                    }


                    if (this.hdContractType.Value.Equals("Appointment"))
                    {
                        ContractAppointment ConApm = _appointment.GetContractAppointmentByID(new Guid(this.hdContractId.Value.ToString()));
                        this.hdContractStatus.Value = ConApm.CapStatus;
                    }
                    else if (this.hdContractType.Value.Equals("Amendment"))
                    {
                        ContractAmendment amendment = _amendment.GetContractAmendmentByID(new Guid(this.hdContractId.Value.ToString()));
                        this.hdContractStatus.Value = amendment.CamStatus;
                    }
                    else if (this.hdContractType.Value.Equals("Renewal"))
                    {
                        ContractRenewal renewal = _renewal.GetContractRenewalByID(new Guid(this.hdContractId.Value.ToString()));
                        this.hdContractStatus.Value = renewal.CreStatus;
                    }
                    else if (this.hdContractType.Value.Equals("Termination"))
                    {
                        ContractTermination term = termination.GetContractTerminationByID(new Guid(this.hdContractId.Value.ToString()));
                        this.hdContractStatus.Value = term.CteStatus;
                    }
                    PagePermissions();
                }
            }
            this.hdContextUserId.Value = _context.User.Id;
        }

        #region Store
        //附件类型
        protected void FileTypeStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            IDictionary<string, string> dicts = DictionaryHelper.GetDictionary(this.hdParmetType.Value.ToString());

            dicts.Remove("T1_SystemCreate");
            dicts.Remove("T2_SystemCreate");
            dicts.Remove("T3_SystemCreate");
            FileTypeStore.DataSource = dicts;
            FileTypeStore.DataBind();
        }

        //附件
        protected void Store_RefreshAttachment(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            Guid ContractId = new Guid(this.hdContractId.Value.ToString());
            Hashtable tb = new Hashtable();
            tb.Add("MainId", ContractId);
            tb.Add("ParType", this.hdParmetType.Value.ToString());

            DataTable dt = attachmentBLL.GetAttachment(tb, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount).Tables[0];
            (this.AttachmentStore.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
            AttachmentStore.DataSource = dt;
            AttachmentStore.DataBind();
        }
        #endregion

        #region Page Event
        //附件上传
        protected void UploadClick(object sender, AjaxEventArgs e)
        {
            if (this.FileUploadField1.HasFile)
            {

                bool error = false;

                string fileName = FileUploadField1.PostedFile.FileName;
                string fileExtention = string.Empty;
                string fileExt = string.Empty;
                if (fileName.LastIndexOf(".") < 0)
                {
                    error = true;
                }
                else
                {
                    fileExtention = fileName.Substring(fileName.LastIndexOf("\\") + 1);
                    fileExt = fileName.Substring(fileName.LastIndexOf(".") + 1).ToLower();
                }

                if (error)
                {
                    Ext.Msg.Show(new MessageBox.Config
                    {
                        Buttons = MessageBox.Button.OK,
                        Icon = MessageBox.Icon.INFO,
                        Title = "文件错误",
                        Message = "请上传正确的文件！"
                    });

                    return;
                }

                //构造文件名称

                string newFileName = DateTime.Now.ToFileTime().ToString() + "." + fileExt;

                //上传文件在Upload文件夹

                string file = Server.MapPath("\\Upload\\UploadFile\\DCMS\\" + newFileName);


                //文件上传
                FileUploadField1.PostedFile.SaveAs(file);

                this.hiddenWinFileName.Text = newFileName;

                Attachment attach = new Attachment();
                attach.Id = Guid.NewGuid();
                attach.MainId = new Guid(this.hdContractId.Value.ToString());
                attach.Name = fileExtention;
                attach.Url = newFileName;
                attach.Type = this.cbFileType.SelectedItem.Value;
                attach.UploadDate = DateTime.Now;
                attach.UploadUser = new Guid(_context.User.Id);
                //维护附件信息
                bool ckUpload= attachmentBLL.AddAttachment(attach);
                
                //发送通知邮件
                if (ckUpload && (this.cbFileType.SelectedItem.Value.Equals("LP_Agreement") || this.cbFileType.SelectedItem.Value.Equals("T1_Agreement"))) 
                {
                    _contractBll.SendMailByDCMSAnnexNotice(this.hdContractId.Value.ToString(), "Agreement");
                }
                if (ckUpload && (this.cbFileType.SelectedItem.Value.Equals("T1_Supplementary") || this.cbFileType.SelectedItem.Value.Equals("LP_Supplementary")))
                {
                    _contractBll.SendMailByDCMSAnnexNotice(this.hdContractId.Value.ToString(), "Supplementary");
                }
                if (ckUpload && this.cbFileType.SelectedItem.Value.Equals("T2_Appointment")) 
                {
                    _contractBll.SendMailByDCMSAnnexNotice(this.hdContractId.Value.ToString(), "AppointmentT2");
                }
                if (ckUpload && this.cbFileType.SelectedItem.Value.Equals("T2_ELearning")) 
                {
                    _contractBll.SendMailByDCMSAnnexNotice(this.hdContractId.Value.ToString(), "ELearningT2");
                }


                Ext.Msg.Show(new MessageBox.Config
                {
                    Buttons = MessageBox.Button.OK,
                    Icon = MessageBox.Icon.INFO,
                    Title = "上传成功",
                    Message = "已成功上传文件！"
                });
            }
            else
            {
                Ext.Msg.Show(new MessageBox.Config
                {
                    Buttons = MessageBox.Button.OK,
                    Icon = MessageBox.Icon.ERROR,
                    Title = "上传失败",
                    Message = "文件未被成功上传！"
                });
            }
        }
        #endregion

        #region 附件
        [AjaxMethod]
        public void DeleteAttachment(string id, string fileName)
        {
            try
            {
                //逻辑删除
                attachmentBLL.DelAttachment(new Guid(id));
                //物理删除
                string uploadFile = Server.MapPath("..\\..\\Upload\\UploadFile\\DCMS");
                File.Delete(uploadFile + "\\" + fileName);
            }
            catch (Exception ex)
            {
                Ext.Msg.Alert("Error", "删除失败").Show();
            }
        }

        [AjaxMethod]
        public void ShowAttachInfo()
        {
            this.tfWinAttachName.Clear();
            this.cbWinAttachType.SelectedItem.Value = string.Empty;
            this.dfWinUploadDate.Clear();
            this.cbWinAttachType.Disabled = false;

            if (!string.IsNullOrEmpty(this.tfWinAttachId.Text))
            {
                Attachment attach = attachmentBLL.GetAttachmentById(new Guid(this.tfWinAttachId.Text));
                if (attach != null)
                {
                    //赋值
                    this.tfWinAttachName.Text = attach.Name.Substring(0, attach.Name.LastIndexOf("."));
                    this.tfWinAttachFileType.Text = attach.Name.Substring(attach.Name.LastIndexOf(".") + 1);
                    this.dfWinUploadDate.SelectedDate = attach.UploadDate;
                    this.cbWinAttachType.SelectedItem.Value = attach.Type;
                    this.tfWinAttachType.Text = attach.Type;

                    if (attach.Type == this.hdParmetType.Value.ToString())
                    {
                        //添加
                        this.cbWinAttachType.SelectedItem.Value = "系统生成";
                        //设置状态
                        this.cbWinAttachType.Disabled = true;
                    }
                }
            }
        }

        [AjaxMethod]
        public void UpdateAttachmentName()
        {
            string atId = this.tfWinAttachId.Text.Trim();
            string atName = this.tfWinAttachName.Text.Trim();
            string fileType = this.tfWinAttachFileType.Text.Trim();
            string atType = this.cbWinAttachType.SelectedItem.Value.Trim();
            string oldAtType = this.tfWinAttachType.Text;
            if (!string.IsNullOrEmpty(atId) && !string.IsNullOrEmpty(atName) && !string.IsNullOrEmpty(atType))
            {
                attachmentBLL.UpdateAttachmentName(new Guid(atId), atName + "." + fileType, atType);
                Ext.Msg.Alert("Message", "更新成功！").Show();
            }
            else if (!string.IsNullOrEmpty(atId) && !string.IsNullOrEmpty(atName) && oldAtType == this.hdParmetType.Value.ToString())
            {
                attachmentBLL.UpdateAttachmentName(new Guid(atId), atName + "." + fileType, oldAtType);
                Ext.Msg.Alert("Message", "更新成功！").Show();
            }
            else
            {
                Ext.Msg.Alert("Error", "请填写完整！").Show();
            }
        }

        [AjaxMethod]
        public void ConvertPdf()
        {

            RowSelectionModel sm = this.gpAttachment.SelectionModel.Primary as RowSelectionModel;

            if (sm.SelectedRows.Count() > 1)
            {
                Ext.Msg.Alert("Error", "不支持多个文件同时进行转换！").Show();
            }
            else if (sm.SelectedRows.Count() == 1)
            {
                SelectedRow row = sm.SelectedRows.First<SelectedRow>();

                Attachment attachment = attachmentBLL.GetAttachmentById(new Guid(row.RecordID));
                string newFileName = DateTime.Now.ToFileTime().ToString();
                string sourcePath = Server.MapPath(ATTACHMENT_FILE_PATH + attachment.Url);
                string targetPath = Server.MapPath(ATTACHMENT_FILE_PATH + newFileName + ".pdf");

                if (!PdfHelper.ValidateImage(sourcePath))
                {
                    Ext.Msg.Alert("Error", "您选择文件不是图片格式！").Show();
                    Console.WriteLine("您选择文件不是图片格式");
                }
                else
                {
                    if (PdfHelper.ConvertPdf(sourcePath, targetPath))
                    {
                        string oldFileType = attachment.Name.Substring(attachment.Name.LastIndexOf(".") + 1);
                        string oldFileName = attachment.Name.Substring(0, attachment.Name.LastIndexOf("."));

                        Attachment newAttachment = new Attachment();
                        newAttachment.Id = Guid.NewGuid();
                        newAttachment.MainId = new Guid(this.hdContractId.Value.ToString());
                        newAttachment.Name = oldFileName + ".pdf";
                        newAttachment.Url = newFileName + ".pdf";
                        newAttachment.Type = this.hdSystemCreateAttachment.Value.ToString();

                        newAttachment.UploadDate = DateTime.Now;
                        newAttachment.UploadUser = new Guid(_context.User.Id);

                        attachmentBLL.AddAttachment(newAttachment);

                        Ext.Msg.Alert("Message", "转换成功！").Show();
                    }
                    else
                    {
                        Ext.Msg.Alert("Error", "发生错误！").Show();
                    }
                }
            }
            else
            {
                Ext.Msg.Alert("Error", "请选择！").Show();
            }
        }

        [AjaxMethod]
        public void MergePdf(string ids)
        {
            string[] idList = ids.Split(';');

            if (idList.Count() > 0)
            {
                string newFileName = DateTime.Now.ToFileTime().ToString();
                string targetPath = Server.MapPath(ATTACHMENT_FILE_PATH + newFileName + ".pdf");
                string[] fileList = new string[idList.Count()];
                string oldFileName = string.Empty;
                Attachment attachment;
                int i = 0;
                foreach (string id in idList)
                {
                    attachment = attachmentBLL.GetAttachmentById(new Guid(id));
                    if (string.IsNullOrEmpty(oldFileName))
                    {
                        oldFileName = attachment.Name;
                    }
                    fileList[i] = Server.MapPath(ATTACHMENT_FILE_PATH + attachment.Url);
                    i++;
                }
                if (PdfHelper.MergePdf(fileList, targetPath))
                {
                    oldFileName = oldFileName.Substring(0, oldFileName.LastIndexOf("."));

                    Attachment newAttachment = new Attachment();
                    newAttachment.Id = Guid.NewGuid();
                    newAttachment.MainId = new Guid(this.hdContractId.Value.ToString());
                    newAttachment.Name = oldFileName + "_new.pdf";
                    newAttachment.Url = newFileName + ".pdf";
                    newAttachment.Type = this.hdSystemCreateAttachment.Value.ToString();
                    newAttachment.UploadDate = DateTime.Now;
                    newAttachment.UploadUser = new Guid(_context.User.Id);

                    attachmentBLL.AddAttachment(newAttachment);

                    Ext.Msg.Alert("Message", "合并成功！").Show();
                }
                else
                {
                    Ext.Msg.Alert("Error", "发生错误！").Show();
                }
            }
            else
            {
                Ext.Msg.Alert("Error", "请选择！").Show();
            }
        }
      

        private string ConvterDateToEnglish(DateTime strDate)
        {
            string retValue = "";
            int month = strDate.Month;
            switch (month)
            {
                case 1:
                    retValue = "January";
                    break;
                case 2:
                    retValue = "February";
                    break;
                case 3:
                    retValue = "March";
                    break;
                case 4:
                    retValue = "April";
                    break;
                case 5:
                    retValue = "May";
                    break;
                case 6:
                    retValue = "June";
                    break;
                case 7:
                    retValue = "July";
                    break;
                case 8:
                    retValue = "August";
                    break;
                case 9:
                    retValue = "September";
                    break;
                case 10:
                    retValue = "October";
                    break;
                case 11:
                    retValue = "November";
                    break;
                case 12:
                    retValue = "December";
                    break;

                default:
                    retValue = "0";
                    break;
            }

            retValue = (retValue + " " + strDate.Day + ", " + strDate.Year);
            return retValue;
        }
        #endregion

        //private bool ConvertPdf(string sourcePath, string targetPath)
        //{
        //    Document doc = new Document();

        //    try
        //    {
        //        PdfWriter.GetInstance(doc, new FileStream(targetPath, FileMode.Create));
        //        doc.Open();
        //        string fileExt = sourcePath.Substring(sourcePath.LastIndexOf(".") + 1).ToUpper();

        //        //doc.Add(new Paragraph(fileExt));
        //        iTextSharp.text.Image image = iTextSharp.text.Image.GetInstance(sourcePath);

        //        //根据A4纸张的大小调整图片的大小。
        //        if (image.Height > iTextSharp.text.PageSize.A4.Height - 25)
        //            image.ScaleToFit(iTextSharp.text.PageSize.A4.Width - 25, iTextSharp.text.PageSize.A4.Height - 25);
        //        else if (image.Width > iTextSharp.text.PageSize.A4.Width - 25)
        //            image.ScaleToFit(iTextSharp.text.PageSize.A4.Width - 25, iTextSharp.text.PageSize.A4.Height - 25);
        //        //调整图片位置，使之居中
        //        image.Alignment = iTextSharp.text.Image.ALIGN_MIDDLE;
        //        doc.NewPage();
        //        doc.Add(image);

        //        return true;
        //    }
        //    catch (Exception ex)
        //    {
        //        Response.Write(ex.Message);
        //        return false;
        //    }
        //    finally
        //    {
        //        doc.Close();
        //    }
        //}

        //private bool Convert(string sourcePath, string targetPath)
        //{
        //    System.Drawing.Image img = System.Drawing.Image.FromFile(sourcePath);

        //    string resFile = sourcePath;
        //    XpsDocument xpsDoc = new XpsDocument(targetPath, FileAccess.ReadWrite);
        //    IXpsFixedDocumentSequenceWriter fds = xpsDoc.AddFixedDocumentSequence();
        //    IXpsFixedDocumentWriter fd = fds.AddFixedDocument();
        //    IXpsFixedPageWriter fp = fd.AddFixedPage();
        //    XpsResource res = null;
        //    XpsResource thumb = null;

        //    res = fp.AddImage(XpsImageType.JpegImageType);
        //    thumb = xpsDoc.AddThumbnail(XpsImageType.JpegImageType);

        //    WriteStream(res.GetStream(), resFile);
        //    WritePageContent(fp.XmlWriter, res, img.Width, img.Height);
        //    res.Commit();

        //    WriteStream(thumb.GetStream(), resFile);
        //    thumb.Commit();

        //    fp.Commit();
        //    fd.Commit();
        //    fds.Commit();
        //    xpsDoc.Close();
        //    return true;
        //}

        //private static void WritePageContent(System.Xml.XmlWriter xmlWriter, XpsResource res, int width, int height)
        //{
        //    xmlWriter.WriteStartElement("FixedPage");
        //    xmlWriter.WriteAttributeString("xmlns", @"http://schemas.microsoft.com/xps/2005/06");
        //    xmlWriter.WriteAttributeString("Width", width.ToString());
        //    xmlWriter.WriteAttributeString("Height", height.ToString());
        //    xmlWriter.WriteAttributeString("xml:lang", "en-US");
        //    xmlWriter.WriteStartElement("Canvas");

        //    if (res is XpsImage)
        //    {
        //        xmlWriter.WriteStartElement("Path");
        //        xmlWriter.WriteAttributeString("Data", "M 20,20 L 770,20 770,770 20,770 z");
        //        xmlWriter.WriteStartElement("Path.Fill");
        //        xmlWriter.WriteStartElement("ImageBrush");
        //        xmlWriter.WriteAttributeString("ImageSource", res.Uri.ToString());
        //        xmlWriter.WriteAttributeString("Viewbox", "0,0,750,750");
        //        xmlWriter.WriteAttributeString("ViewboxUnits", "Absolute");
        //        xmlWriter.WriteAttributeString("Viewport", "20,20,750,750");
        //        xmlWriter.WriteAttributeString("ViewportUnits", "Absolute");
        //        xmlWriter.WriteEndElement();
        //        xmlWriter.WriteEndElement();
        //        xmlWriter.WriteEndElement();
        //    }
        //    xmlWriter.WriteEndElement();
        //    xmlWriter.WriteEndElement();
        //}

        //private static void WriteStream(Stream stream, string resFile)
        //{
        //    using (FileStream sourceStream = new FileStream(resFile, FileMode.Open, FileAccess.Read))
        //    {
        //        byte[] buf = new byte[1024];
        //        int read = 0;
        //        while ((read = sourceStream.Read(buf, 0, buf.Length)) > 0)
        //        {
        //            stream.Write(buf, 0, read);
        //        }
        //    }
        //}

        #region 页面权限设定
        private void PagePermissions()
        {
            if (RoleModelContext.Current.User.Roles.Contains(SR.Const_UserRole_ChannelOperation))
            {
                this.hdLoginRole.Value = SR.Const_UserRole_ChannelOperation;
            }

            if (this.hdDealerType.Value.Equals(DealerType.T2.ToString()))
            {
                if (IsDealer && !RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()) && !RoleModelContext.Current.User.CorpType.Equals(DealerType.LS.ToString()))
                {
                    this.hdOperationStates.Value = "readonly";
                    this.btnAddAttachment.Enabled = false;
                    this.btnConvertPdf.Enabled = false;
                    this.btnMergePdf.Enabled = false;
                }
            }

            if (RoleModelContext.Current.User.Roles.Contains(SR.Const_UserRole_ContractQuery))
            {
                this.btnAddAttachment.Enabled = false;
                this.btnConvertPdf.Enabled = false;
                this.btnMergePdf.Enabled = false;
            }
        }

        #endregion
    }
}
