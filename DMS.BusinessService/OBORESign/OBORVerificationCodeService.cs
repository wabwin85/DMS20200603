using DMS.Common.Common;
using DMS.ViewModel.OBORESign;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Web.UI;
using DMS.Signature.BLL;
using Newtonsoft.Json;
using DMS.DataAccess.OBORESign;
using System.Data;
using DMS.Signature.Model;
using Lafite.RoleModel.Security;
using System.Text.RegularExpressions;
using System.Collections;
using DMS.Model;
using DMS.Business;

namespace DMS.BusinessService.OBORESign
{
    public class OBORVerificationCodeService : ABaseQueryService
    {
        private IContractMasterBLL masterBll = new ContractMasterBLL();
        private IMessageBLL _messageBLL = new MessageBLL();
        public OBORVerificationCodeVO Init(OBORVerificationCodeVO model)
        {
            try
            {


            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }


        public OBORVerificationCodeVO Send(OBORVerificationCodeVO model)
        {
            try
            {
                EnterpriseSignVO vo = new EnterpriseSignVO();
                ESignBLL bll = new ESignBLL();

                vo.DealerId = RoleModelContext.Current.User.CorpId.ToString();
                //vo.DealerId = "85754CAF-23D2-4910-86CE-67DECF86262C";
                vo.CreateUser = new Guid(RoleModelContext.Current.User.CorpId.ToString());
                vo.CreateUserName = RoleModelContext.Current.User.CorpName;
                vo.CreateDate = DateTime.Now;

                String phone = bll.SendMobileCode(vo);

                if (phone.Length >= 7)
                {
                    phone = Regex.Replace(phone, "(\\d{3})\\d{4}(\\d{4})", "$1****$2");
                }

                model.Phone = phone;
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }


        public OBORVerificationCodeVO Confirm(OBORVerificationCodeVO model)
        {
            try
            {
                if (model.SignType == "DealerSign")
                {


                    OBORESignDao dao = new OBORESignDao();
                    ESignBLL bll = new ESignBLL();

                    DataTable tb = new DataTable();
                    tb = dao.SelectOBORESignUrl(model.ES_ID);

                    if ((tb.Rows[0]["ES_Status"].ToString() == "WaitDealerSign"))
                    {

                        string str = tb.Rows[0]["ES_UploadFilePath"].ToString();
                        string[] sArray = str.Split(new string[] { "temp/" }, StringSplitOptions.RemoveEmptyEntries);

                        EnterpriseSignVO vo = new EnterpriseSignVO();
                        vo.Code = model.IptVerificationCode;
                        vo.DealerId = RoleModelContext.Current.User.CorpId.ToString();
                        vo.CreateUser = new Guid(RoleModelContext.Current.User.CorpId.ToString());
                        vo.CreateUserName = RoleModelContext.Current.User.CorpName;
                        vo.CreateDate = DateTime.Now;
                        vo.ApplyId = model.ES_ID;
                        vo.FileSrcPath = "/Upload/temp/";
                        vo.FileDstPath = @"//Upload/temp/";
                        vo.FileSrcName = sArray[1];
                        vo.FileName = sArray[1];
                        vo.FileId = "00000000-0000-0000-0000-000000000000";
                        bll.EnterpriseUserSign(vo);

                        string FileSrcName = vo.FileSrcName;

                        //更新合同状态
                        dao.UpdateDealerSign(model.ES_ID, FileSrcName, RoleModelContext.Current.User.Id.ToString());


                        //邮件通知平台
                        Hashtable tbaddress = new Hashtable();
                        string ClientID = dao.SelectClientID(model.ES_ID);

                        tbaddress.Add("MailType", "OBOR");
                        tbaddress.Add("MailTo", ClientID);
                        IList<MailDeliveryAddress> Addresslist = masterBll.GetMailDeliveryAddress(tbaddress);


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
                                mail.Subject = "邮件通知";
                                mail.Body = "";
                                mail.Status = "Waiting";
                                mail.CreateDate = DateTime.Now;
                                _messageBLL.AddToMailMessageQueue(mail);
                            }
                        }

                        //短信通知

                        string phone = dao.SelectLPPhone(model.ES_ID);
                        if (model.ES_ID != "" && phone != "")
                        {
                            SendMassage(tb.Rows[0]["ES_AgreementNo"].ToString(), phone);
                        }
                        else
                        {
                            model.IsSuccess = false;
                            model.ExecuteMessage.Add("请注册企业用户信息");
                        }
                    }
                    else
                    {
                        model.IsSuccess = false;
                        model.ExecuteMessage.Add("合同状态已更改，请重试！");
                    }
                }
                else
                {
                    OBORESignDao dao = new OBORESignDao();
                    ESignBLL bll = new ESignBLL();

                    DataTable tb = new DataTable();
                    tb = dao.SelectOBORESignUrl(model.ES_ID);

                    if ((tb.Rows[0]["ES_Status"].ToString() == "WaitLPSign"))
                    {
                        string str = tb.Rows[0]["ES_UploadFilePath"].ToString();
                        string[] sArray = str.Split(new string[] { "temp/" }, StringSplitOptions.RemoveEmptyEntries);

                        EnterpriseSignVO vo = new EnterpriseSignVO();
                        vo.Code = model.IptVerificationCode;
                        vo.DealerId = RoleModelContext.Current.User.CorpId.ToString();
                        vo.CreateUser = new Guid(RoleModelContext.Current.User.CorpId.ToString());
                        vo.CreateUserName = RoleModelContext.Current.User.CorpName;
                        vo.CreateDate = DateTime.Now;
                        vo.ApplyId = model.ES_ID;
                        vo.FileSrcPath = "/Upload/temp/";
                        vo.FileDstPath = @"//Upload/temp/";
                        vo.FileSrcName = sArray[1];
                        vo.FileName = sArray[1];
                        vo.FileId = "00000000-0000-0000-0000-000000000000";
                        bll.EnterpriseLPSign(vo);

                        string FileSrcName = vo.FileSrcName;

                        //更新合同状态
                        dao.UpdateLPSign(model.ES_ID, FileSrcName, RoleModelContext.Current.User.Id.ToString());

                    }
                    else
                    {
                        model.IsSuccess = false;
                        model.ExecuteMessage.Add("合同状态已更改，请重试！");
                    }

                }

            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        private void SendMassage(string AgreementNo, string massageTo)
        {
            ShortMessageTemplate temp = _messageBLL.GetShortMessageTemplate("SMS_OBOR_SUBMIT");

            MessageTaskSend massage = new MessageTaskSend();
            massage.SendMode = "2";
            massage.EmailWechatContent = temp.Template.Replace("#AgreementNo#", AgreementNo);
            massage.MsgPhone = massageTo;
            massage.HtmlTranslationFLG = "1";
            massage.InsertQueFLG = "0";
            massage.SendAdminFLG = "0";
            massage.InsertTime = DateTime.Now;
            massage.InsertOrigin = "songw2";
            massage.GUID = "DMS-" + Guid.NewGuid().ToString();

            _messageBLL.AddToShortMessagTask(massage);
        }



    }
}
