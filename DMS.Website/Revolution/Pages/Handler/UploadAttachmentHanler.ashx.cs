using DMS.Business;
using DMS.Business.Contract;
using DMS.Common;
using DMS.Common.Common;
using DMS.DataAccess;
using DMS.DataAccess.Platform;
using DMS.Model;
using DMS.Model.Data;
using Lafite.RoleModel.Security;
using Newtonsoft.Json;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.SessionState;

namespace DMS.Website.Revolution.Pages.Handler
{
    /// <summary>
    /// UploadAttachmentHanler 的摘要说明
    /// </summary>
    public class UploadAttachmentHanler : IHttpHandler, IRequiresSessionState
    {
        IRoleModelContext _context = RoleModelContext.Current;
        public IAttachmentBLL attachBll = new AttachmentBLL();
        public void ProcessRequest(HttpContext context)
        {
            try
            {
                bool uploadStatus = true;
                string type = HttpContext.Current.Request.QueryString["Type"].ToString();
                HttpPostedFile postedFile = HttpContext.Current.Request.Files["files"];
                string fileType = HttpContext.Current.Request.QueryString["FileType"];
                if (postedFile == null)
                {
                    postedFile = HttpContext.Current.Request.Files["files2"];
                }
                string fileSavePath = "";
                switch (type)
                {
                    case "InventoryRenturn"://退换货申请附件上传
                    case "OrderApply"://二级经销商订单申请
                        uploadStatus = InventoryReturnUpload(postedFile);
                        break;
                    case "DealerLicense":
                        DealerLicenseAttach(postedFile);
                        break;
                    case "dcms":
                        DealerDetailAttach(postedFile);
                        break;
                    case "ShipmentToHospital":
                        ShipmentListAttach(postedFile);
                        break;
                    case "DealerMasterDD":  //合同审批DD信息维护
                        fileSavePath = "\\Upload\\UploadFile\\DealerMasterDDAttachment\\";
                        CommonAttach(postedFile, AttachmentType.DealerMasterDD.ToString(), fileSavePath);
                        break;
                    case "DCMSDisclosure":
                        DealerDisclosureAttach(postedFile);
                        break;
                    case "ShipmentQr":
                        ShipmentQrAttach(postedFile);               
                        break;
                    case "TenderAuthorization":
                        fileSavePath = "\\Upload\\UploadFile\\TenderAuthorization\\";
                        if (string.IsNullOrEmpty(fileType))
                        {
                            var lsrtn = new { result = "Error", msg = "请选择文件类型" };
                            HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lsrtn));
                        }
                        else
                        {
                            CommonAttach(postedFile, fileType, fileSavePath);
                        }
                        break;
                    case "ddReport":
                        DDReportAttach(postedFile);
                        break;
                    case "ManualUpload":
                        ManualAttach(postedFile);
                        break;
                    case "DealerAuthorization":
                        CommonAttach(postedFile, type, "\\Upload\\UploadFile\\DealerAuthorization\\");
                        break;
                    default:
                        CommonAttach(postedFile, fileType);
                        break;
                }
                //if (!uploadStatus)
                //{
                //    var lsrtn = new { result = "Error", msg =  };
                //    HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lsrtn));
                //}
            }
            catch (Exception e)
            {
                var lsrtn = new { result = "Error", msg = e.Message };
                HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lsrtn));
            }

        }

        public bool InventoryReturnUpload(HttpPostedFile File)
        {
            string HeadId = HttpContext.Current.Request.QueryString["InstanceId"].ToString();
            string fileName = File.FileName;
            string fileExtention = string.Empty;
            string fileExt = string.Empty;
            //string msg = ValidateExtensions(fileName, ".xls,.xlsx");
            //if (!string.IsNullOrEmpty(msg))
            //{
            //    var lsrtn = new { result = "Error", msg = msg };
            //    HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lsrtn));
            //    return false;
            //}
            fileExtention = fileName.Substring(fileName.LastIndexOf("\\") + 1);
            fileExt = fileName.Substring(fileName.LastIndexOf(".") + 1).ToLower();
            //构造文件名称
            string newFileName = DateTime.Now.ToFileTime().ToString() + "." + fileExt;
            //上传文件在Upload文件夹

            string savepath = HttpContext.Current.Server.MapPath("\\Upload\\UploadFile\\AdjustAttachment\\");
            if (!Directory.Exists(savepath))
                Directory.CreateDirectory(savepath);
            //文件上传
            string saveFilepath = HttpContext.Current.Server.MapPath("\\Upload\\UploadFile\\AdjustAttachment\\" + newFileName);
            File.SaveAs(saveFilepath);

            Attachment attach = new Attachment();
            attach.Id = Guid.NewGuid();
            attach.MainId = new Guid(HeadId);
            attach.Name = fileExtention;
            attach.Url = newFileName;
            attach.Type = AttachmentType.ReturnAdjust.ToString();
            attach.UploadDate = DateTime.Now;
            attach.UploadUser = new Guid(_context.User.Id);
            attachBll.AddAttachment(attach);

            return true;
        }

        public void DealerLicenseAttach(HttpPostedFile File)
        {
            string HeadId = HttpContext.Current.Request.Params["InstanceId"].ToString();
            string fileName = File.FileName;
            string fileExtention = string.Empty;
            string fileExt = string.Empty;

            fileExtention = fileName.Substring(fileName.LastIndexOf("\\") + 1);
            fileExt = fileName.Substring(fileName.LastIndexOf(".") + 1).ToLower();
            //构造文件名称
            string newFileName = DateTime.Now.ToFileTime().ToString() + "." + fileExt;
            //上传文件在Upload文件夹

            string savepath = HttpContext.Current.Server.MapPath("\\Upload\\UploadFile\\LicenseCatagory\\");
            if (!Directory.Exists(savepath))
                Directory.CreateDirectory(savepath);
            //文件上传
            string saveFilepath = HttpContext.Current.Server.MapPath("\\Upload\\UploadFile\\LicenseCatagory\\" + newFileName);
            File.SaveAs(saveFilepath);

            Attachment attach = new Attachment();
            attach.Id = Guid.NewGuid();
            attach.MainId = new Guid(HeadId);
            attach.Name = fileExtention;
            attach.Url = newFileName;
            attach.Type = AttachmentType.DealerLicense.ToString();
            attach.UploadDate = DateTime.Now;
            attach.UploadUser = new Guid(_context.User.Id);
            attachBll.AddAttachment(attach);
            
        }
        public void DealerDetailAttach(HttpPostedFile File)
        {
            string HeadId = HttpContext.Current.Request.QueryString["InstanceId"].ToString();
            string selectType = HttpContext.Current.Request.Params["selectType"];
            string fileName = File.FileName;
            string fileExtention = string.Empty;
            string fileExt = string.Empty;

            if (!string.IsNullOrEmpty(selectType))
            {
                fileExtention = fileName.Substring(fileName.LastIndexOf("\\") + 1);
                fileExt = fileName.Substring(fileName.LastIndexOf(".") + 1).ToLower();
                //构造文件名称
                string newFileName = DateTime.Now.ToFileTime().ToString() + "." + fileExt;
                //上传文件在Upload文件夹

                string savepath = HttpContext.Current.Server.MapPath("\\Upload\\UploadFile\\DCMS\\");
                if (!Directory.Exists(savepath))
                    Directory.CreateDirectory(savepath);
                //文件上传
                string saveFilepath = HttpContext.Current.Server.MapPath("\\Upload\\UploadFile\\DCMS\\" + newFileName);
                File.SaveAs(saveFilepath);

                Attachment attach = new Attachment();
                attach.Id = Guid.NewGuid();
                attach.MainId = new Guid(HeadId);
                attach.Name = fileExtention;
                attach.Url = newFileName;
                attach.Type = selectType;
                attach.UploadDate = DateTime.Now;
                attach.UploadUser = new Guid(_context.User.Id);
                attachBll.AddAttachment(attach);
                var lstresult = new { result = "Success", msg = "" };
                HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));

            }
            else
            {
                var lstresult = new { result = "Error", msg = "请选择文件类型！" };
                HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));
            }

        }

        public void DealerDisclosureAttach(HttpPostedFile File)
        {
            string dealerId = HttpContext.Current.Request.QueryString["DealerId"].ToString();
            string dealerType = HttpContext.Current.Request.QueryString["DealerType"].ToString();
            string dealerName = HttpContext.Current.Request.QueryString["DealerName"].ToString();
            string disclosureId = HttpContext.Current.Request.Params["DisclosureId"].ToString();
            string hdType = HttpContext.Current.Request.Params["HdType"].ToString();
            string companyName = HttpContext.Current.Request.Params["CompanyName"].ToString();
            string hospitalName = HttpContext.Current.Request.Params["HospitalName"].ToString();
            string productLine = HttpContext.Current.Request.Params["ProductLine"].ToString();
            string fileName = File.FileName;
            string fileExtention = string.Empty;
            string fileExt = string.Empty;

            fileExtention = fileName.Substring(fileName.LastIndexOf("\\") + 1);
            fileExt = fileName.Substring(fileName.LastIndexOf(".") + 1).ToLower();
            //构造文件名称
            string newFileName = DateTime.Now.ToFileTime().ToString() + "." + fileExt;
            //上传文件在Upload文件夹

            string savepath = HttpContext.Current.Server.MapPath("\\Upload\\UploadFile\\DCMS\\");
            if (!Directory.Exists(savepath))
                Directory.CreateDirectory(savepath);
            //文件上传
            string saveFilepath = HttpContext.Current.Server.MapPath("\\Upload\\UploadFile\\DCMS\\" + newFileName);
            File.SaveAs(saveFilepath);

            Attachment attach = new Attachment();
            attach.Id = Guid.NewGuid();
            attach.MainId = new Guid(disclosureId);
            attach.Name = fileExtention;
            attach.Url = newFileName;
            attach.Type = "HospitalThirdPart";
            attach.UploadDate = DateTime.Now;
            attach.UploadUser = new Guid(_context.User.Id);
            attachBll.AddAttachment(attach);

            //发送邮件
            if (hdType == "old" && dealerId == _context.User.CorpId.ToString() && hdType != "new")
            {
                ChangeAttachment("EMAIL_ThirdParty_ChangeAttachment_LPCO", dealerId, disclosureId, dealerType);

            }
            if (RoleModelContext.Current.User.CorpType != null && RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString())
                 && dealerType == "T2" && hdType != "new" || dealerType != "T2" && !(RoleModelContext.Current.User.IdentityType == SR.Consts_System_Dealer_User) && RoleModelContext.Current.User.Roles.Contains(SR.Const_UserRole_ChannelOperation) && hdType != "new")
            {
                SandMailApproval("ChangeAttachment", "EMAIL_ThirdParty_ChangeAttachment_LPT2", dealerId, dealerName, companyName, hospitalName, productLine);

            }

        }

        public void ShipmentListAttach(HttpPostedFile File)
        {
            string HeadId = HttpContext.Current.Request.Params["InstanceId"].ToString();
            string fileName = File.FileName;
            string fileExtention = string.Empty;
            string fileExt = string.Empty;

            fileExtention = fileName.Substring(fileName.LastIndexOf("\\") + 1);
            fileExt = fileName.Substring(fileName.LastIndexOf(".") + 1).ToLower();
            //构造文件名称
            string newFileName = DateTime.Now.ToFileTime().ToString() + "." + fileExt;
            //上传文件在Upload文件夹

            string savepath = HttpContext.Current.Server.MapPath("\\Upload\\UploadFile\\ShipmentAttachment\\");
            if (!Directory.Exists(savepath))
                Directory.CreateDirectory(savepath);
            //文件上传
            string saveFilepath = HttpContext.Current.Server.MapPath("\\Upload\\UploadFile\\ShipmentAttachment\\" + newFileName);
            File.SaveAs(saveFilepath);

            Attachment attach = new Attachment();
            attach.Id = Guid.NewGuid();
            attach.MainId = new Guid(HeadId);
            attach.Name = fileExtention;
            attach.Url = newFileName;
            attach.Type = AttachmentType.ShipmentToHospital.ToString();
            attach.UploadDate = DateTime.Now;
            attach.UploadUser = new Guid(_context.User.Id);
            attachBll.AddAttachment(attach);

        }

        public void ShipmentQrAttach(HttpPostedFile File)
        {
            string HeadId = HttpContext.Current.Request.Params["InstanceId"].ToString();
            string fileName = File.FileName;
            string fileExtention = string.Empty;
            string fileExt = string.Empty;

            fileExtention = fileName.Substring(fileName.LastIndexOf("\\") + 1);
            fileExt = fileName.Substring(fileName.LastIndexOf(".") + 1).ToLower();
            //构造文件名称
            string newFileName = DateTime.Now.ToFileTime().ToString() + "." + fileExt;
            //上传文件在Upload文件夹

            string savepath = HttpContext.Current.Server.MapPath("\\Upload\\UploadFile\\ShipmentAttachment\\");
            if (!Directory.Exists(savepath))
                Directory.CreateDirectory(savepath);
            //文件上传
            string saveFilepath = HttpContext.Current.Server.MapPath("\\Upload\\UploadFile\\ShipmentAttachment\\" + newFileName);
            File.SaveAs(saveFilepath);

            Attachment attach = new Attachment();
            attach.Id = Guid.NewGuid();
            attach.MainId = new Guid(HeadId);
            attach.Name = fileExtention;
            attach.Url = newFileName;
            attach.Type = AttachmentType.Dealer_Shipment_Qr.ToString();
            attach.UploadDate = DateTime.Now;
            attach.UploadUser = new Guid(_context.User.Id);
            attachBll.AddAttachment(attach);

        }

        public void ManualAttach(HttpPostedFile File)
        {
            string fileName = File.FileName;
            string fileExtention = string.Empty;
            string fileExt = string.Empty;
            string saveName = string.Empty;

            fileExtention = fileName.Substring(fileName.LastIndexOf("\\") + 1);
            saveName = fileName.Substring(0, fileExtention.LastIndexOf("."));
            fileExt = fileName.Substring(fileName.LastIndexOf(".") + 1).ToLower();
            //构造文件名称
            string newFileName = DateTime.Now.ToFileTime().ToString() + "." + fileExt;
            //上传文件在Upload文件夹

            string savepath = HttpContext.Current.Server.MapPath("\\Upload\\SystemManual\\");
            if (!Directory.Exists(savepath))
                Directory.CreateDirectory(savepath);
            //文件上传
            string saveFilepath = HttpContext.Current.Server.MapPath("\\Upload\\SystemManual\\" + newFileName);
            File.SaveAs(saveFilepath);

            Hashtable ht = new Hashtable();
            ht.Add("ManualName", saveName);
            ht.Add("ManualUrl", "/Upload/SystemManual/" + newFileName);
            SystemManualDao smd = new SystemManualDao();
            smd.InsertSystemManual(ht);
        }

        public void CommonAttach(HttpPostedFile File,string FileType="",string FilePath= "\\Upload\\UploadFile\\")
        {
            string HeadId = HttpContext.Current.Request.Params["InstanceId"].ToString();
            string fileName = File.FileName;
            string fileExtention = string.Empty;
            string fileExt = string.Empty;

            fileExtention = fileName.Substring(fileName.LastIndexOf("\\") + 1);
            fileExt = fileName.Substring(fileName.LastIndexOf(".") + 1).ToLower();
            //构造文件名称
            string newFileName = DateTime.Now.ToFileTime().ToString() + "." + fileExt;
            //上传文件在Upload文件夹

            string savepath = HttpContext.Current.Server.MapPath(FilePath);
            if (!Directory.Exists(savepath))
                Directory.CreateDirectory(savepath);
            //文件上传
            string saveFilepath = HttpContext.Current.Server.MapPath(FilePath + newFileName);
            File.SaveAs(saveFilepath);

            Attachment attach = new Attachment();
            attach.Id = Guid.NewGuid();
            attach.MainId = new Guid(HeadId);
            attach.Name = fileExtention;
            attach.Url = newFileName;
            attach.Type = FileType;
            attach.UploadDate = DateTime.Now;
            attach.UploadUser = new Guid(_context.User.Id);
            attachBll.AddAttachment(attach);

        }
        public void DDReportAttach(HttpPostedFile File)
        {
            string HeadId = HttpContext.Current.Request.QueryString["InstanceId"].ToString();
            string ddReportName = HttpContext.Current.Request.Params["DDReportName"].ToString();
            string ddStarDate = HttpContext.Current.Request.Params["DDStartDate"].ToString();
            string ddEndDate = HttpContext.Current.Request.Params["DDEndDate"].ToString();
            string DealerType = HttpContext.Current.Request.QueryString["DealerType"].ToString();
            string ddIsHaveRedFlag = HttpContext.Current.Request.Params["DDIsHaveRedFlag"].ToString();
            string fileName = File.FileName;
            string fileExtention = string.Empty;
            string fileExt = string.Empty;

            fileExtention = fileName.Substring(fileName.LastIndexOf("\\") + 1);
            fileExt = fileName.Substring(fileName.LastIndexOf(".") + 1).ToLower();
            //构造文件名称
            string newFileName = DateTime.Now.ToFileTime().ToString() + "." + fileExt;
            //上传文件在Upload文件夹
            string Type = DealerType + "_BackgroundCheck";
            string savepath = HttpContext.Current.Server.MapPath("\\Upload\\UploadFile\\"+ Type + "\\");
            if (!Directory.Exists(savepath))
                Directory.CreateDirectory(savepath);
            //文件上传
            string saveFilepath = HttpContext.Current.Server.MapPath("\\Upload\\UploadFile\\"+ Type + "\\" + newFileName);
            File.SaveAs(saveFilepath);
            Guid ddID = Guid.NewGuid();
            Attachment attach = new Attachment();
            attach.Id = ddID;
            attach.MainId = new Guid(HeadId);
            attach.Name = fileExtention;
            attach.Url = newFileName;
            attach.Type = Type;
            attach.UploadDate = DateTime.Now;
            attach.UploadUser = new Guid(_context.User.Id);
            attachBll.AddAttachment(attach);
            //插入合同显示背调报告
            Hashtable ht = new Hashtable();
            ht.Add("FileName", fileName);
            ht.Add("FileUrl", saveFilepath);
            ht.Add("UserId", new Guid(_context.User.Id));
            string attId = attachBll.AddContractAttachment(ht);
            //DD报告信息插入
            using (DealerMasterDDBscDao dao = new DealerMasterDDBscDao())
            {
                DealerMasterDD dmdd = new DealerMasterDD();
                dmdd.DMDD_ID = ddID;
                dmdd.DMDD_ContractID = null;
                dmdd.DMDD_DealerID = new Guid(HeadId);
                dmdd.DMDD_ReportName = ddReportName;
                dmdd.DMDD_IsHaveRedFlag = ddIsHaveRedFlag == "true" ? true : false;
                if (!string.IsNullOrEmpty(ddStarDate)&& ddStarDate!="null")
                {
                    dmdd.DMDD_StartDate = Convert.ToDateTime(ddStarDate);
                }
                if (!string.IsNullOrEmpty(ddEndDate) && ddEndDate != "null")
                {
                    dmdd.DMDD_EndDate = Convert.ToDateTime(ddEndDate);
                }
                dmdd.DMDD_DD = attId;
                dmdd.DMDD_CreateDate = DateTime.Now;
                dmdd.DMDD_CreateUser = _context.UserName;
                dmdd.DMDD_UpdateDate = DateTime.Now;
                dmdd.DMDD_UpdateUser = _context.UserName;
                dao.Insert(dmdd);
            }
        }
        /// <summary>
        /// 检查文件类型
        /// </summary>
        /// <param name="filename">文件名</param>
        /// <param name="allowedExtensions">允许的文件类型，多个文件类型用逗号隔开，不传入参数则用配置文件中的不允许文件类型检测</param>
        /// <returns>方法返回空表示正确，错误则返回对应MSG</returns>
        public string ValidateExtensions(string filename, string allowedExtensions = null)
        {
            try
            {
                string ext = System.IO.Path.GetExtension(filename).ToLower();
                if (string.IsNullOrEmpty(allowedExtensions))
                {

                    return string.Empty;

                }
                else
                {
                    if (allowedExtensions.Split(',').Contains(ext))
                    {
                        return string.Empty;
                    }
                    else
                    {
                        return "上传文件格式不在支持范围内";
                    }
                }
            }
            catch (Exception ex)
            {

                return ex.ToString();
            }
        }

        #region 邮件
        IThirdPartyDisclosureService thirdPartyDisclosure = new ThirdPartyDisclosureService();
        IContractMasterBLL masterBll = new ContractMasterBLL();
        IDealerMasters dealerMasters = new DealerMasters();
        IMessageBLL messageBll = new MessageBLL();
        public void ChangeAttachment(string MessageTemplatelpco, string dealerId, string disclosureId, string dealerType)
        {

            Hashtable obj = new Hashtable();
            obj.Add("DmaId", dealerId);
            obj.Add("MainId", disclosureId);
            DataTable dsb = thirdPartyDisclosure.SelectThirdPartyDisclosureListHospitBU(obj).Tables[0];
            string hospital = dsb.Rows[0]["HospitalName"].ToString();
            string bu = dsb.Rows[0]["ProductNameString"].ToString();
            string CompanyName = dsb.Rows[0]["CompanyName"].ToString();
            string DMA_ChineseName = dsb.Rows[0]["DMA_ChineseName"].ToString();

            DealerMaster dMaster = dealerMasters.GetDealerMaster(new Guid(dealerId));
            MailMessageTemplate mailMessage = null;
            IList<MailDeliveryAddress> Addresslist = null;
            if (dealerType.Equals(DealerType.T2.ToString()))
            {
                mailMessage = messageBll.GetMailMessageTemplate(MessageTemplatelpco);

                Hashtable tbaddress = new Hashtable();
                tbaddress.Add("MailType", "DCMS");
                tbaddress.Add("DealerId", dealerId);
                Addresslist = masterBll.GetLPMailDeliveryAddressByDealerId(tbaddress);
            }
            else
            {
                mailMessage = messageBll.GetMailMessageTemplate(MessageTemplatelpco);
                Hashtable tbaddress = new Hashtable();
                tbaddress.Add("MailType", "DCMS");
                tbaddress.Add("MailTo", "CO");
                Addresslist = masterBll.GetMailDeliveryAddress(tbaddress);
            }

            //发邮件给平台和CO
            Hashtable hasButype = new Hashtable();
            hasButype.Add("DmaId", dealerId);
            DataTable dtButype = thirdPartyDisclosure.GetThirdPartyDisclosureListBuType(hasButype).Tables[0];
            DataRow drButype = null;
            if (dtButype.Rows.Count > 0)
            {
                drButype = dtButype.Rows[0];
            }
            string titalSubject = mailMessage.Subject;
            if (drButype != null && drButype[0] != null && drButype[0].ToString() != "")
            {
                titalSubject += ("(" + drButype[0].ToString() + ")");
            }
            
            if (Addresslist != null && Addresslist.Count > 0)
            {
                //发邮件通知CO确认IAF信息
                foreach (MailDeliveryAddress mailAddress in Addresslist)
                {
                    MailMessageQueue mail = new MailMessageQueue();
                    mail.Id = Guid.NewGuid();
                    mail.QueueNo = "email";
                    mail.From = "";
                    mail.To = mailAddress.MailAddress;
                    mail.Subject = titalSubject.Replace("{#Delertype}", dealerType);
                    mail.Body = mailMessage.Body.Replace("{#DealerName}", DMA_ChineseName).Replace("{#hospital}", hospital).Replace("{#CompanyName}", CompanyName).Replace("{#ProductNameString}", bu);
                    mail.CreateDate = DateTime.Now;
                    mail.Status = "Waiting";
                    messageBll.AddToMailMessageQueue(mail);
                }
            }

        }

        public void SandMailApproval(string Type, string MessageTemplate, string dealerId, string dealerName, string companyName, string hospitalName, string productLine)
        {
            MailMessageTemplate mailMessage = null;
            if (Type == "Reject")
            {
                mailMessage = messageBll.GetMailMessageTemplate(MessageTemplate);
            }
            else if (Type == "Approval")
            {
                mailMessage = messageBll.GetMailMessageTemplate(MessageTemplate);
            }
            else if (Type == "ChangeAttachment")
            {
                mailMessage = messageBll.GetMailMessageTemplate(MessageTemplate);
            }
            else if (Type == "new")
            {

                mailMessage = messageBll.GetMailMessageTemplate(MessageTemplate);

            }
            string role = "";
            DealerMaster dealermaster = dealerMasters.GetDealerMaster(new Guid(dealerId));

            if (!(RoleModelContext.Current.User.IdentityType == SR.Consts_System_Dealer_User))
            {
                role = "波科渠道管理员";
            }
            else
            {
                role = dealerName;
            }
            if (!dealermaster.Email.ToString().Equals(""))
            {
                MailMessageQueue mail = new MailMessageQueue();
                mail.Id = Guid.NewGuid();
                mail.QueueNo = "email";
                mail.From = "";
                mail.To = dealermaster.Email.ToString();
                mail.Subject = mailMessage.Subject.Replace("{#role}", role);
                mail.Body = mailMessage.Body.Replace("{#DealerName}", dealerName).Replace("{#Hospital}", hospitalName).Replace("{#ProductNameString}", productLine).Replace("{#CompanyName}", companyName).Replace("{#role}", role);
                mail.Status = "Waiting";
                mail.CreateDate = DateTime.Now;
                messageBll.AddToMailMessageQueue(mail);
            }
        }
        #endregion

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}