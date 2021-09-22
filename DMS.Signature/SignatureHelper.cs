using Common.Logging;
using DMS.Signature.Common;
using DMS.Signature.Daos;
using DMS.Signature.Model;
//using EsignUtils.bean.constant;
//using EsignUtils.bean.result;
using EsignUtils.service;
using EsignUtils.service.factory;
using EsignUtils.utils.bean;
using EsignUtils.utils.bean.config;
using EsignUtils.utils.bean.constant;
using EsignUtils.utils.bean.result;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Linq;
using System.Collections.ObjectModel;
using System.Net;
using System.Reflection;
using System.Runtime.InteropServices;
using System.Security.Cryptography;
using System.Text;
using System.Web.UI;
using System.Windows.Forms;
using static DMS.Signature.Model.EviFileDigestRequest;
using EsignUtils.bean.result;
using EsignUtils.bean.constant;

namespace DMS.Signature
{
    public class SignatureHelper
    {
        private static String RequestMessage;
        private static String ResponseMessage;
        private static DateTime BeginTime;
        private static String OperationName;
        private static bool OperationResult;
        private static ILog _log = LogManager.GetLogger(typeof(SignatureHelper));

        public static String ESign_ProjectId = System.Configuration.ConfigurationManager.AppSettings["ESign_ProjectId"];
        public static String ESign_ProjectSecret = System.Configuration.ConfigurationManager.AppSettings["ESign_ProjectSecret"];
        public static String ESign_ApisUrl = System.Configuration.ConfigurationManager.AppSettings["ESign_ApisUrl"];
        public static String ESign_Algorithm = System.Configuration.ConfigurationManager.AppSettings["ESign_Algorithm"];
        public static String ESign_EnterpriseAuth_ROOTURL = System.Configuration.ConfigurationManager.AppSettings["ESign_EnterpriseAuth_ROOTURL"];
        public static String ESign_FileDigestAPI = System.Configuration.ConfigurationManager.AppSettings["ESign_FileDigestAPI"];
        public static String ESign_RelateAPI = System.Configuration.ConfigurationManager.AppSettings["ESign_RelateAPI"];
        public static String ESign_CertificateInfoUrl = System.Configuration.ConfigurationManager.AppSettings["ESign_CertificateInfoUrl"];

        public static String ESign_PayResultUrl = System.Configuration.ConfigurationManager.AppSettings["ESign_PayResultUrl"];
        public static String ESign_Zoom = System.Configuration.ConfigurationManager.AppSettings["ESign_Zoom"];

        public static String ESign_EnterpriseWidth = System.Configuration.ConfigurationManager.AppSettings["ESign_EnterpriseWidth"];
        public static String ESign_LegalWidth = System.Configuration.ConfigurationManager.AppSettings["ESign_LegalWidth"];

        public static String ESing_NeedShortMessage = System.Configuration.ConfigurationManager.AppSettings["ESing_NeedShortMessage"];

        public static String ESing_BscSignRole = System.Configuration.ConfigurationManager.AppSettings["ESing_BscSignRole"];

        EsignTechService service = EsignTechServiceFactory.Instance();//sdk初始化

        #region 电子签章
        /// <summary>
        /// 初始化e签宝平台信息
        /// </summary>
        public void EsignInit()
        {
            try
            {
                ProjectConfig projectConfig = new ProjectConfig();
                projectConfig.ProjectId = ESign_ProjectId;
                projectConfig.ProjectSecret = ESign_ProjectSecret;
                projectConfig.ApisUrl = ESign_ApisUrl;

                //HttpConnectConfig httpConfig = new HttpConnectConfig();
                //httpConfig.HttpType = httpType.ToUpper() == HttpTypes.HTTPS.ToString() ? HttpTypes.HTTPS : HttpTypes.HTTP;
                //httpConfig.ProxyIp = proxyIp;
                //httpConfig.ProxyPort = proxyPort;
                //httpConfig.Retry = retry;

                Result initResult = service.Init(projectConfig, new HttpConnectConfig(), new SignatureConfig());
                _log.Info(string.Format("ESign Init Message:{0}={1}", initResult.ErrCode, initResult.Msg));

            }
            catch (Exception e)
            {
                _log.Error(e.ToString());
                throw e;
            }
        }

        /// <summary>
        /// 添加企业账号
        /// </summary>
        public String AddOrganize(EnterpriseMaster enterprise)
        {
            OperationResult = false;
            OperationName = "添加企业账号";
            BeginTime = DateTime.Now;
            RequestMessage = JsonConvert.SerializeObject(enterprise);
            try
            {
                if (String.IsNullOrEmpty(enterprise.AccountUid))
                {
                    OrganizeBean organize = new OrganizeBean();

                    organize.Email = enterprise.Email;
                    organize.Mobile = enterprise.Phone;
                    organize.Name = enterprise.Name;
                    organize.OrganType = enterprise.OrganType.Value;
                    organize.UserType = enterprise.UserType.Value;
                    organize.OrganCode = enterprise.OrganCode;
                    organize.LegalName = enterprise.LegalName;
                    organize.LegalIdNo = enterprise.LegalIdNo;
                    organize.LegalArea = enterprise.LegalArea.Value;
                    organize.AgentName = enterprise.AgentName;
                    organize.AgentIdNo = enterprise.AgentIdNo;
                    organize.Address = enterprise.Address;
                    organize.Scope = enterprise.Scope;
                    organize.RegType = String.IsNullOrEmpty(enterprise.RegType) ? OrganRegType.NORMAL : (OrganRegType)Enum.Parse(typeof(OrganRegType), enterprise.RegType);

                    AddAccountResult addAccountResult = service.AddAccount(organize);

                    if (addAccountResult.ErrCode == 0)
                    {
                        ResponseMessage = "添加企业账号结果：" + "\n\n" + "添加成功，企业账号为：" + addAccountResult.AccountId + "！";
                        OperationResult = true;
                    }
                    else
                    {
                        ResponseMessage = "添加企业账号结果：" + "\n\n" + "信息校验失败！" + "\n\n" + "errCode=" + addAccountResult.ErrCode.ToString() + "\n" + "msg=" + addAccountResult.Msg.ToString();
                        throw new Exception(ResponseMessage);
                    }

                    enterprise.AccountUid = addAccountResult.AccountId;
                }
                else
                {
                    OperationName = "更新企业账号";
                    UpdateOrganizeBean organize = new UpdateOrganizeBean();

                    organize.Email = enterprise.Email;
                    organize.Mobile = enterprise.Phone;
                    organize.Name = enterprise.Name;
                    organize.OrganType = (OrganType)Enum.Parse(typeof(OrganType), enterprise.OrganType.Value.ToString());
                    organize.UserType = (UserType)Enum.Parse(typeof(UserType), enterprise.UserType.Value.ToString());
                    organize.LegalName = enterprise.LegalName;
                    organize.LegalIdNo = enterprise.LegalIdNo;
                    organize.LegalArea = (LegalAreaType)Enum.Parse(typeof(LegalAreaType), enterprise.LegalArea.Value.ToString());
                    organize.AgentName = enterprise.AgentName;
                    organize.AgentIdNo = enterprise.AgentIdNo;
                    organize.Address = enterprise.Address;
                    organize.Scope = enterprise.Scope;

                    List<EmptyInfo> emtpyList = new List<EmptyInfo>();
                    emtpyList.Add(EmptyInfo.SCOPE);
                    emtpyList.Add(EmptyInfo.ADDRESS);

                    Result updateAccountResult = service.UpdateAccount(enterprise.AccountUid, organize, emtpyList);

                    if (updateAccountResult.ErrCode == 0)
                    {
                        ResponseMessage = "更新企业账号结果：" + "\n\n" + "更新成功!";
                        OperationResult = true;
                    }
                    else
                    {
                        ResponseMessage = "更新企业账号结果：" + "\n\n" + "信息校验失败！" + "\n\n" + "errCode=" + updateAccountResult.ErrCode.ToString() + "\n" + "msg=" + updateAccountResult.Msg.ToString();
                        throw new Exception(ResponseMessage);
                    }
                }

                _log.Info(ResponseMessage);

                //添加企业信息
                //InsertEnterpriseMaster(enterprise);

                InsertLog(enterprise.DmaId.ToString(), OperationName, BeginTime, RequestMessage, ResponseMessage, OperationResult, enterprise.DmaId.Value, enterprise.CreateUser.Value, enterprise.CreateUserName, enterprise.AccountUid);

                return enterprise.AccountUid;
            }
            catch (Exception ex)
            {
                InsertLog(enterprise.DmaId.ToString(), OperationName, BeginTime, RequestMessage, ex.ToString(), false, enterprise.DmaId.Value, enterprise.CreateUser.Value, enterprise.CreateUserName, "");
                throw ex;
            }
        }

        /// <summary>
        /// 创建模版印章
        /// </summary>
        /// <param name="seal"></param>
        /// <returns></returns>
        public String AddTemplateSeal(EnterpriseSeal seal)
        {
            OperationResult = false;
            OperationName = "创建企业模版印章";
            BeginTime = DateTime.Now;
            RequestMessage = JsonConvert.SerializeObject(seal);
            try
            {
                String accountId = seal.AccountUid;
                String templateType = seal.TemplateType;
                String color = seal.Color;
                String hText = seal.Htext;
                String qText = seal.Qtext;

                AddSealResult addSealResult = service.AddTemplateSeal(accountId,
                        (OrganizeTemplateType)Enum.Parse(typeof(OrganizeTemplateType), templateType.ToUpper()),
                        (SealColor)Enum.Parse(typeof(SealColor), color),
                        hText, qText);

                if (addSealResult.ErrCode == 0)
                {
                    ResponseMessage = "创建企业模版印章结果：" + "\n\n" + "创建企业模版印章成功，印章为：" + addSealResult.SealData + "！";
                    OperationResult = true;
                }
                else
                {
                    ResponseMessage = "创建企业模版印章结果：" + "\n\n" + "创建企业模版印章失败！" + "\n\n" + "errCode=" + addSealResult.ErrCode.ToString() + "\n" + "msg=" + addSealResult.Msg.ToString();
                    throw new Exception(ResponseMessage);
                }

                _log.Info(ResponseMessage);

                InsertLog(seal.DmaId.ToString(), OperationName, BeginTime, RequestMessage, ResponseMessage, OperationResult, seal.DmaId, seal.CreateUser.Value, seal.CreateUserName, seal.AccountUid);

                return addSealResult.SealData;
            }
            catch (Exception ex)
            {
                InsertLog(seal.DmaId.ToString(), OperationName, BeginTime, RequestMessage, ex.ToString(), false, seal.DmaId, seal.CreateUser.Value, seal.CreateUserName, seal.AccountUid);
                throw ex;
            }
        }

        /// <summary>
        /// 添加法人账号
        /// </summary>
        public String AddPerson(EnterpriseLegalMaster legal)
        {
            OperationResult = false;
            OperationName = "添加个人账号";
            BeginTime = DateTime.Now;
            RequestMessage = JsonConvert.SerializeObject(legal);
            try
            {
                if (String.IsNullOrEmpty(legal.AccountUid))
                {
                    PersonBean person = new PersonBean();

                    person.Email = legal.Email;
                    person.Mobile = legal.Mobile;
                    person.Name = legal.Name;
                    person.IdNo = legal.IdNo;
                    person.PersonArea = legal.PersonArea.Value;
                    person.Organ = legal.Organ;
                    person.Title = legal.Title;
                    person.Address = legal.Address;

                    AddAccountResult addAccountResult = service.AddAccount(person);

                    if (addAccountResult.ErrCode == 0)
                    {
                        ResponseMessage = "添加个人账号结果：" + "\n\n" + "添加成功，个人账号为：" + addAccountResult.AccountId + "！";
                        OperationResult = true;
                    }
                    else
                    {
                        ResponseMessage = "添加个人账号结果：" + "\n\n" + "信息校验失败！" + "\n\n" + "errCode=" + addAccountResult.ErrCode.ToString() + "\n" + "msg=" + addAccountResult.Msg.ToString();
                        throw new Exception(ResponseMessage);
                    }

                    legal.AccountUid = addAccountResult.AccountId;
                }
                else
                {
                    OperationName = "更新个人账号";
                    UpdatePersonBean person = new UpdatePersonBean();

                    person.Email = legal.Email;
                    person.Mobile = legal.Mobile;
                    person.Organ = legal.Organ;
                    person.Title = legal.Title;
                    person.Address = legal.Address;

                    List<EmptyInfo> emtpyList = new List<EmptyInfo>();
                    //emtpyList.Add(EmptyInfo.TITLE);
                    //emtpyList.Add(EmptyInfo.ADDRESS);

                    Result updateAccountResult = service.UpdateAccount(legal.AccountUid, person, emtpyList);

                    if (updateAccountResult.ErrCode == 0)
                    {
                        ResponseMessage = "更新个人账号结果：" + "\n\n" + "更新成功!";
                        OperationResult = true;
                    }
                    else
                    {
                        ResponseMessage = "更新个人账号结果：" + "\n\n" + "信息校验失败！" + "\n\n" + "errCode=" + updateAccountResult.ErrCode.ToString() + "\n" + "msg=" + updateAccountResult.Msg.ToString();
                        throw new Exception(ResponseMessage);
                    }
                }

                _log.Info(ResponseMessage);

                //添加企业信息
                //InsertEnterpriseMaster(enterprise);

                InsertLog(legal.DmaId.ToString(), OperationName, BeginTime, RequestMessage, ResponseMessage, OperationResult, legal.DmaId.Value, legal.CreateUser.Value, legal.CreateUserName, legal.AccountUid);

                return legal.AccountUid;
            }
            catch (Exception ex)
            {
                InsertLog(legal.DmaId.ToString(), OperationName, BeginTime, RequestMessage, ex.ToString(), false, legal.DmaId.Value, legal.CreateUser.Value, legal.CreateUserName, "");
                throw ex;
            }
        }

        /// <summary>
        /// 创建模版印章
        /// </summary>
        /// <param name="seal"></param>
        /// <returns></returns>
        public String AddPersonTemplateSeal(EnterpriseLegalSeal legal)
        {
            OperationResult = false;
            OperationName = "创建个人模版印章";
            BeginTime = DateTime.Now;
            RequestMessage = JsonConvert.SerializeObject(legal);
            try
            {
                String accountId = legal.AccountUid;
                String templateType = legal.TemplateType;
                String color = legal.Color;

                AddSealResult addSealResult = service.AddTemplateSeal(accountId,
                        (PersonTemplateType)Enum.Parse(typeof(PersonTemplateType), templateType.ToUpper()),
                        (SealColor)Enum.Parse(typeof(SealColor), color));

                if (addSealResult.ErrCode == 0)
                {
                    ResponseMessage = "创建个人模版印章结果：" + "\n\n" + "创建个人模版印章成功，印章为：" + addSealResult.SealData + "！";
                    OperationResult = true;
                }
                else
                {
                    ResponseMessage = "创建个人模版印章结果：" + "\n\n" + "创建个人模版印章失败！" + "\n\n" + "errCode=" + addSealResult.ErrCode.ToString() + "\n" + "msg=" + addSealResult.Msg.ToString();
                    throw new Exception(ResponseMessage);
                }

                _log.Info(ResponseMessage);

                InsertLog(legal.DmaId.ToString(), OperationName, BeginTime, RequestMessage, ResponseMessage, OperationResult, legal.DmaId, legal.CreateUser.Value, legal.CreateUserName, legal.AccountUid);

                return addSealResult.SealData;
            }
            catch (Exception ex)
            {
                InsertLog(legal.DmaId.ToString(), OperationName, BeginTime, RequestMessage, ex.ToString(), false, legal.DmaId, legal.CreateUser.Value, legal.CreateUserName, legal.AccountUid);
                throw ex;
            }
        }

        /// <summary>
        /// 推送短信验证码
        /// </summary>
        /// <param name="model"></param>
        public void SendSignMobileCode(ESignBaseModel model)
        {
            OperationResult = false;
            OperationName = "推送短信验证码";
            BeginTime = DateTime.Now;
            RequestMessage = JsonConvert.SerializeObject(model);
            try
            {
                Result result = service.SendSignMobileCode(model.AccountUid);

                if (result.ErrCode == 0)
                {
                    ResponseMessage = "推送短信验证码结果：" + "\n\n" + "成功！";
                    OperationResult = true;
                }
                else
                {
                    ResponseMessage = "推送短信验证码结果：" + "\n\n" + "失败！" + "\n\n" + "errCode=" + result.ErrCode.ToString() + "\n" + "msg=" + result.Msg.ToString();
                    throw new Exception(ResponseMessage);
                }

                _log.Info(ResponseMessage);

                InsertLog(model.DealerId.ToString(), OperationName, BeginTime, RequestMessage, ResponseMessage, OperationResult, model.DealerId, model.CreateUser, model.CreateUserName, model.AccountUid);
            }
            catch (Exception ex)
            {
                InsertLog(model.DealerId.ToString(), OperationName, BeginTime, RequestMessage, ex.ToString(), false, model.DealerId, model.CreateUser, model.CreateUserName, model.AccountUid);
                throw ex;
            }
        }

        /// <summary>
        /// 平台用户PDF摘要签署
        /// </summary>
        public String LocalSignPDF(SignPdfModel model, string eSignFolder = "")
        {
            if (String.IsNullOrEmpty(eSignFolder))
            {
                eSignFolder = new Page().Server.MapPath("~/");
            }

            OperationResult = false;
            OperationName = "平台用户PDF摘要签署";
            BeginTime = DateTime.Now;
            RequestMessage = JsonConvert.SerializeObject(model);
            int i = 1;
            try
            {
                foreach (var sealPostModel in model.sealList.OrderBy(p => p.sealType).ToList())
                {
                    model.dstName = Guid.NewGuid().ToString() + "." + model.srcName.Substring(model.srcName.LastIndexOf(".") + 1);

                    PosBean pos = new PosBean();
                    //pos.AddSignTime = true;
                    pos.PosX = sealPostModel.xPadding;
                    pos.PosY = sealPostModel.yPadding;
                    pos.PosType = 1;
                    if (sealPostModel.sealType == "1")
                    {
                        pos.Width = float.Parse(ESign_LegalWidth);
                    }
                    else
                    {
                        pos.Width = float.Parse(ESign_EnterpriseWidth);
                    }
                    //pos.Width = 157;
                    pos.Key = sealPostModel.keyWord;

                    SignPDFFileBean fileBean = new SignPDFFileBean();
                    fileBean.DstPdfFile = Path.Combine(eSignFolder,
                                               model.dstFile.TrimStart('/').Replace('/', '\\') + model.dstName);
                    fileBean.SrcPdfFile = Path.Combine(eSignFolder,
                                               model.srcFile.TrimStart('/').Replace('/', '\\') + model.srcName);
                    if (i > 1)
                    {
                        fileBean.SrcPdfFile = Path.Combine(eSignFolder, model.srcName.TrimStart('/').Replace('/', '\\'));
                    }

                    fileBean.FileName = model.fileName;

                    String accountUid;

                    if (sealPostModel.sealType == "0")
                    {
                        accountUid = model.AccountUid;
                    }
                    else if (sealPostModel.sealType == "1")
                    {
                        accountUid = model.LegalAccountUid;
                    }
                    else
                    {
                        throw new Exception("印章类型【" + sealPostModel.sealType + "】不存在");
                    }

                    FileDigestSignResult result;
                    ///第一次需要验证码校验，后续的不用
                    if (i == 1)
                    {
                        if (SignatureHelper.ESing_NeedShortMessage == "1")
                        {
                            if (model.code == "LP")
                            {
                                result = service.LocalSignPDF(accountUid, sealPostModel.sealData, fileBean, pos, SignType.Key);
                            }
                            else
                            {
                                result = service.LocalSignPDF(accountUid, sealPostModel.sealData, fileBean, pos, SignType.Key, model.code);
                            }

                        }
                        else
                        {
                            result = service.LocalSignPDF(accountUid, sealPostModel.sealData, fileBean, pos, SignType.Key);
                            //result = service.LocalSignPDF(accountUid, sealPostModel.sealData, fileBean, pos, SignType.Edges);
                        }
                    }
                    else
                    {
                        result = service.LocalSignPDF(accountUid, sealPostModel.sealData, fileBean, pos, SignType.Key);
                        //result = service.LocalSignPDF(accountUid, sealPostModel.sealData, fileBean, pos, SignType.Edges);
                    }

                    String msg = JsonConvert.SerializeObject(result);
                    
                    if (result.ErrCode == 0)
                    {
                        if (sealPostModel.sealType == "0")
                        //加盖骑缝章
                        {
                            Acrobat.CAcroPDDoc pdfDoc = null;
                            //生成操作Pdf文件的Com对象
                            pdfDoc = (Acrobat.CAcroPDDoc)Activator.CreateInstance(System.Type.GetTypeFromProgID("AcroExch.PDDoc"));
                            pdfDoc.Open(fileBean.DstPdfFile);
                            int endNum = pdfDoc.GetNumPages();
                            pdfDoc.Close();
                            if (endNum > 1)
                            {
                                model.srcName = model.dstName;
                                model.srcFile = model.dstFile;
                                model.dstName = model.dstFile.TrimStart('/').Replace('/', '\\') + Guid.NewGuid() + "." + model.srcName.Substring(model.srcName.LastIndexOf(".") + 1);


                                Marshal.ReleaseComObject(pdfDoc);
                                pos.PosY = sealPostModel.edgesYPosition;
                                pos.PosX = 0;
                                pos.PosPage = "1-" + endNum;
                                fileBean.SrcPdfFile = fileBean.DstPdfFile;
                                fileBean.DstPdfFile = Path.Combine(eSignFolder, model.dstName);
                                //合同大于1页才加盖骑缝章                            
                                result = service.LocalSignPDF(accountUid, sealPostModel.sealData, fileBean, pos, SignType.Edges);
                            }
                            else
                            {
                                model.dstName = model.dstFile.TrimStart('/').Replace('/', '\\') + model.dstName;
                            }
                        }
                        if (result.ErrCode == 0)
                        {
                            ResponseMessage = "平台用户PDF摘要签署结果：" + "\n\n" + "签署成功！FileDigestSignResult:" + msg;
                            OperationResult = true;
                        }
                        else
                        {
                            ResponseMessage = "平台用户PDF摘要(骑缝章)签署结果：" + "\n\n" + "签署失败！" + "\n\n" + "errCode=" + result.ErrCode.ToString() + "\n" + "msg=" + result.Msg.ToString();
                            throw new Exception(ResponseMessage);
                        }
                    }
                    else
                    {
                        ResponseMessage = "平台用户PDF摘要签署结果：" + "\n\n" + "签署失败！" + "\n\n" + "errCode=" + result.ErrCode.ToString() + "\n" + "msg=" + result.Msg.ToString();
                        throw new Exception(ResponseMessage);
                    }


                    _log.Info(ResponseMessage);

                    InsertLog(model.ApplyId, OperationName, BeginTime, RequestMessage, ResponseMessage, OperationResult, model.DealerId, model.CreateUser, model.CreateUserName, model.AccountUid);

                    InsertFileVersion(model, result, i);
                    ///目标文件变为源文件
                    model.srcName = model.dstName;
                    model.srcFile = model.dstFile;
                    i++;
                }

                return model.dstName;
            }
            catch (Exception ex)
            {
                InsertLog(model.ApplyId, OperationName, BeginTime, RequestMessage, ex.ToString(), false, model.DealerId, model.CreateUser, model.CreateUserName, model.AccountUid);
                throw ex;
            }
        }

        /// <summary>
        /// 平台自身PDF摘要签署
        /// </summary>
        public String LocalSelfSignPDF(SignPdfModel model, string eSignFolder = "")
        {
            if (String.IsNullOrEmpty(eSignFolder))
            {
                eSignFolder = new Page().Server.MapPath("~/");
            }

            OperationResult = false;
            OperationName = "平台自身PDF摘要签署";
            BeginTime = DateTime.Now;
            RequestMessage = JsonConvert.SerializeObject(model);
            int i = 1;
            try
            {
                foreach (var SealPostModel in model.sealList)
                {
                    model.dstName = Guid.NewGuid().ToString() + "." + model.srcName.Substring(model.srcName.LastIndexOf(".") + 1);

                    PosBean pos = new PosBean();
                    //pos.AddSignTime = true;
                    pos.PosX = SealPostModel.xPadding;
                    pos.PosY = SealPostModel.yPadding;
                    pos.PosType = 1;
                    pos.Width = 157;
                    pos.Key = SealPostModel.keyWord;

                    SignPDFFileBean fileBean = new SignPDFFileBean();
                    fileBean.DstPdfFile = Path.Combine(eSignFolder,
                                               model.dstFile.TrimStart('/').Replace('/', '\\') + model.dstName);
                    fileBean.SrcPdfFile = Path.Combine(eSignFolder,
                                               model.srcFile.TrimStart('/').Replace('/', '\\') + model.srcName);

                    fileBean.FileName = model.fileName;

                    FileDigestSignResult result = service.LocalSignPDF(model.AccountUid, SealPostModel.sealData, fileBean, pos, SignType.Key);
                    String msg = JsonConvert.SerializeObject(result);

                    if (result.ErrCode == 0)
                    {
                        ResponseMessage = "平台自身PDF摘要签署结果：" + "\n\n" + "签署成功！FileDigestSignResult:" + msg;
                        OperationResult = true;
                    }
                    else
                    {
                        ResponseMessage = "平台自身PDF摘要签署结果：" + "\n\n" + "签署失败！" + "\n\n" + "errCode=" + result.ErrCode.ToString() + "\n" + "msg=" + result.Msg.ToString();
                        throw new Exception(ResponseMessage);
                    }

                    _log.Info(ResponseMessage);

                    InsertLog(model.ApplyId, OperationName, BeginTime, RequestMessage, ResponseMessage, OperationResult, model.DealerId, model.CreateUser, model.CreateUserName, model.AccountUid);

                    InsertFileVersion(model, result, i);
                    ///目标文件变为源文件
                    model.srcName = model.dstName;
                    model.srcFile = model.dstFile;
                    i++;
                }

                return model.dstName;
            }
            catch (Exception ex)
            {
                InsertLog(model.ApplyId, OperationName, BeginTime, RequestMessage, ex.ToString(), false, model.DealerId, model.CreateUser, model.CreateUserName, model.AccountUid);
                throw ex;
            }
        }

        /// <summary>
        /// 平台用户PDF作废
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public String LocalCancelPDF(SignPdfModel model, string eSignFolder = "")
        {
            if (String.IsNullOrEmpty(eSignFolder))
            {
                eSignFolder = new Page().Server.MapPath("~/");
            }

            OperationResult = false;
            OperationName = "平台用户PDF作废";
            BeginTime = DateTime.Now;
            RequestMessage = JsonConvert.SerializeObject(model);
            int i = 1;
            try
            {
                foreach (var SealPostModel in model.sealList)
                {
                    model.dstName = Guid.NewGuid().ToString() + "." + model.srcName.Substring(model.srcName.LastIndexOf(".") + 1);

                    PosBean pos = new PosBean();
                    //pos.AddSignTime = true;
                    pos.PosX = SealPostModel.xPadding;
                    pos.PosY = SealPostModel.yPadding;
                    pos.PosType = 1;
                    pos.Width = 157;
                    pos.Key = SealPostModel.keyWord;
                    pos.CacellingSign = true;

                    SignPDFFileBean fileBean = new SignPDFFileBean();
                    fileBean.DstPdfFile = Path.Combine(eSignFolder,
                                               model.dstFile.TrimStart('/').Replace('/', '\\') + model.dstName);
                    fileBean.SrcPdfFile = Path.Combine(eSignFolder,
                                               model.srcFile.TrimStart('/').Replace('/', '\\') + model.srcName);

                    fileBean.FileName = model.fileName;

                    FileDigestSignResult result;
                    ///第一次需要验证码校验，后续的不用
                    if (i == 1)
                    {
                        if (SignatureHelper.ESing_NeedShortMessage == "1")
                        {
                            result = service.LocalSignPDF(model.AccountUid, SealPostModel.sealData, fileBean, pos, SignType.Key, model.code);
                        }
                        else
                        {
                            result = service.LocalSignPDF(model.AccountUid, SealPostModel.sealData, fileBean, pos, SignType.Key);
                        }
                    }
                    else
                    {
                        result = service.LocalSignPDF(model.AccountUid, SealPostModel.sealData, fileBean, pos, SignType.Key);
                    }

                    String msg = JsonConvert.SerializeObject(result);

                    if (result.ErrCode == 0)
                    {
                        ResponseMessage = "平台用户PDF作废结果：" + "\n\n" + "签署成功！FileDigestSignResult:" + msg;
                        OperationResult = true;
                    }
                    else
                    {
                        ResponseMessage = "平台用户PDF作废结果：" + "\n\n" + "签署失败！" + "\n\n" + "errCode=" + result.ErrCode.ToString() + "\n" + "msg=" + result.Msg.ToString();
                        throw new Exception(ResponseMessage);
                    }

                    _log.Info(ResponseMessage);

                    InsertLog(model.ApplyId, OperationName, BeginTime, RequestMessage, ResponseMessage, OperationResult, model.DealerId, model.CreateUser, model.CreateUserName, model.AccountUid);

                    InsertFileVersion(model, result, i);
                    ///目标文件变为源文件
                    model.srcName = model.dstName;
                    model.srcFile = model.dstFile;
                    i++;
                }

                return model.dstName;
            }
            catch (Exception ex)
            {
                InsertLog(model.ApplyId, OperationName, BeginTime, RequestMessage, ex.ToString(), false, model.DealerId, model.CreateUser, model.CreateUserName, model.AccountUid);
                throw ex;
            }
        }

        /// <summary>
        /// 平台自身PDF作废
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public String LocalSelfCanelPDF(SignPdfModel model, string eSignFolder = "")
        {
            if (String.IsNullOrEmpty(eSignFolder))
            {
                eSignFolder = new Page().Server.MapPath("~/");
            }

            OperationResult = false;
            OperationName = "平台自身PDF作废";
            BeginTime = DateTime.Now;
            RequestMessage = JsonConvert.SerializeObject(model);
            int i = 1;
            try
            {
                foreach (var sealPostModel in model.sealList)
                {
                    model.dstName = Guid.NewGuid().ToString() + "." + model.srcName.Substring(model.srcName.LastIndexOf(".") + 1);

                    PosBean pos = new PosBean();
                    //pos.AddSignTime = true;
                    pos.PosX = sealPostModel.xPadding;
                    pos.PosY = sealPostModel.yPadding;
                    pos.PosType = 1;
                    pos.Width = 157;
                    pos.Key = sealPostModel.keyWord;
                    pos.CacellingSign = true;

                    SignPDFFileBean fileBean = new SignPDFFileBean();
                    fileBean.DstPdfFile = Path.Combine(eSignFolder,
                                               model.dstFile.TrimStart('/').Replace('/', '\\') + model.dstName);
                    fileBean.SrcPdfFile = Path.Combine(eSignFolder,
                                               model.srcFile.TrimStart('/').Replace('/', '\\') + model.srcName);

                    fileBean.FileName = model.fileName;

                    String accountUid;

                    if (sealPostModel.sealType == "0")
                    {
                        accountUid = model.AccountUid;
                    }
                    else if (sealPostModel.sealType == "1")
                    {
                        accountUid = model.LegalAccountUid;
                    }
                    else
                    {
                        throw new Exception("印章类型【" + sealPostModel.sealType + "】不存在");
                    }

                    FileDigestSignResult result;
                    ///第一次需要验证码校验，后续的不用
                    if (i == 1)
                    {
                        result = service.LocalSignPDF(accountUid, sealPostModel.sealData, fileBean, pos, SignType.Key, model.code);
                    }
                    else
                    {
                        result = service.LocalSignPDF(accountUid, sealPostModel.sealData, fileBean, pos, SignType.Key);
                    }

                    String msg = JsonConvert.SerializeObject(result);

                    if (result.ErrCode == 0)
                    {
                        ResponseMessage = "平台自身PDF作废结果：" + "\n\n" + "作废成功！FileDigestSignResult:" + msg;
                        OperationResult = true;
                    }
                    else
                    {
                        ResponseMessage = "平台自身PDF作废结果：" + "\n\n" + "作废失败！" + "\n\n" + "errCode=" + result.ErrCode.ToString() + "\n" + "msg=" + result.Msg.ToString();
                        throw new Exception(ResponseMessage);
                    }

                    _log.Info(ResponseMessage);

                    InsertLog(model.ApplyId, OperationName, BeginTime, RequestMessage, ResponseMessage, OperationResult, model.DealerId, model.CreateUser, model.CreateUserName, model.AccountUid);

                    InsertFileVersion(model, result, i);
                    ///目标文件变为源文件
                    model.srcName = model.dstName;
                    model.srcFile = model.dstFile;
                    i++;
                }

                return model.dstName;
            }
            catch (Exception ex)
            {
                InsertLog(model.ApplyId, OperationName, BeginTime, RequestMessage, ex.ToString(), false, model.DealerId, model.CreateUser, model.CreateUserName, model.AccountUid);
                throw ex;
            }
        }

        #endregion

        #region 企业实名制认证
        /// <summary>
        /// 企业实名制认证
        /// </summary>
        public String EnterpriseNameAuthentication(EnterpriseAuthentication model)
        {
            OperationResult = false;
            OperationName = "企业实名制认证";
            BeginTime = DateTime.Now;
            RequestMessage = JsonConvert.SerializeObject(model);
            try
            {
                EnterpriseAuth_RealName enterpriseInfoAuth = new EnterpriseAuth_RealName();

                enterpriseInfoAuth.name = model.Name;
                enterpriseInfoAuth.codeUSC = model.UscCode;
                enterpriseInfoAuth.codeORG = model.OrgCode;
                enterpriseInfoAuth.codeREG = model.RegCode;

                enterpriseInfoAuth.legalName = model.LegalName.Replace(" ", String.Empty); //model.LegalName.Replace(' ', ',');

                //仅当法人所在地为“大陆”需要验证身份证（e签宝无法验证除此之外的身份信息）
                if (model.LegalArea.HasValue && model.LegalArea.Value == 0)
                    enterpriseInfoAuth.legalIdno = model.LegalIdNo;

                String result = HttpPostData(string.Format("{0}{1}", ESign_EnterpriseAuth_ROOTURL, "/realname/rest/external/organ/infoAuth"), JsonConvert.SerializeObject(enterpriseInfoAuth));

                EnterpriseInfoAuthResult authResult = DeserializeJsonToObject<EnterpriseInfoAuthResult>(result);

                if ("0".Equals(authResult.errCode.ToString()))
                {
                    ResponseMessage = "企业实名制认证校验结果：" + "\n\n" + "信息校验通过！EnterpriseInfoAuthResult:" + SerializeObject(authResult);
                    OperationResult = true;
                }
                else
                {
                    ResponseMessage = "企业实名制认证校验结果：" + "\n\n" + "信息校验失败！" + "\n\n" + "errCode=" + authResult.errCode.ToString() + "\n" + "msg=" + authResult.msg.ToString();
                    throw new Exception(ResponseMessage);
                }

                _log.Info(RequestMessage);

                InsertLog(model.Id.ToString(), OperationName, BeginTime, RequestMessage, ResponseMessage, OperationResult, model.DmaId.Value, model.CreateUser.Value, model.CreateUserName, model.AccountUid);


                return authResult.serviceId;
            }
            catch (Exception ex)
            {
                InsertLog(model.Id.ToString(), OperationName, BeginTime, RequestMessage, ex.ToString(), false, model.DmaId.Value, model.CreateUser.Value, model.CreateUserName, model.AccountUid);
                throw ex;
            }
        }

        /// <summary>
        /// 企业对公打款
        /// </summary>
        public String EnterpriseToPay(EnterprisePayAuth model)
        {
            OperationResult = false;
            OperationName = "企业对公打款";
            BeginTime = DateTime.Now;
            RequestMessage = JsonConvert.SerializeObject(model);
            try
            {
                EnterpriseAuth_ToPay enterpriseToPay = new EnterpriseAuth_ToPay();

                enterpriseToPay.name = model.Name;
                enterpriseToPay.cardno = model.CardNo.Replace(" ", String.Empty);
                enterpriseToPay.subbranch = model.SubBranch;
                enterpriseToPay.bank = model.Bank;
                enterpriseToPay.provice = model.Provice;
                enterpriseToPay.city = model.City;
                enterpriseToPay.notify = ESign_PayResultUrl;
                enterpriseToPay.serviceId = model.AuthServiceId;
                enterpriseToPay.prcptcd = model.Prcptcd;
                enterpriseToPay.pizId = model.PizId;

                String result = HttpPostData(string.Format("{0}{1}", ESign_EnterpriseAuth_ROOTURL, "/realname/rest/external/organ/toPay"), JsonConvert.SerializeObject(enterpriseToPay));

                EnterpriseToPayReslt toPayResult = DeserializeJsonToObject<EnterpriseToPayReslt>(result);

                if ("0".Equals(toPayResult.errCode.ToString()))
                {
                    ResponseMessage = "企业对公打款校验结果：" + "\n\n" + "信息校验通过！EnterpriseToPayReslt:" + SerializeObject(toPayResult);
                    OperationResult = true;
                }
                else
                {
                    ResponseMessage = "企业对公打款校验结果：" + "\n\n" + "信息校验失败！" + "\n\n" + "errCode=" + toPayResult.errCode.ToString() + "\n" + "msg=" + toPayResult.msg.ToString();
                    throw new Exception(ResponseMessage);
                }

                _log.Info(RequestMessage);

                InsertLog(model.Id.ToString(), OperationName, BeginTime, RequestMessage, ResponseMessage, OperationResult, model.DmaId.Value, model.CreateUser.Value, model.CreateUserName, model.AccountUid);

                return toPayResult.serviceId;
            }
            catch (Exception ex)
            {
                InsertLog(model.Id.ToString(), OperationName, BeginTime, RequestMessage, ex.ToString(), false, model.DmaId.Value, model.CreateUser.Value, model.CreateUserName, model.AccountUid);
                throw ex;
            }
        }

        /// <summary>
        /// 企业对公打款验证
        /// </summary>
        public bool EnterprisePayAuth(EnterprisePayAuth model)
        {
            OperationResult = false;
            OperationName = "企业对公打款金额验证";
            BeginTime = DateTime.Now;
            RequestMessage = JsonConvert.SerializeObject(model);
            try
            {
                EnterpriseAuth_PayVerification enterprisePayAuth = new EnterpriseAuth_PayVerification();

                enterprisePayAuth.serviceId = model.ServiceId;
                enterprisePayAuth.cash = model.PayMoney.Value;

                String result = HttpPostData(string.Format("{0}{1}", ESign_EnterpriseAuth_ROOTURL, "/realname/rest/external/organ/payAuth"), JsonConvert.SerializeObject(enterprisePayAuth));

                EnterpriseBaseResult baseResult = DeserializeJsonToObject<EnterpriseBaseResult>(result);

                if ("0".Equals(baseResult.errCode.ToString()))
                {
                    ResponseMessage = "企业对公打款金额验证校验结果：" + "\n\n" + "信息校验通过！EnterpriseBaseResult:" + SerializeObject(baseResult);
                    OperationResult = true;
                }
                else
                {
                    ResponseMessage = "企业对公打款金额证校验结果：" + "\n\n" + "信息校验失败！" + "\n\n" + "errCode=" + baseResult.errCode.ToString() + "\n" + "msg=" + baseResult.msg.ToString();
                    throw new Exception(ResponseMessage);
                }

                _log.Info(RequestMessage);

                InsertLog(model.Id.ToString(), OperationName, BeginTime, RequestMessage, ResponseMessage, OperationResult, model.DmaId.Value, model.CreateUser.Value, model.CreateUserName, model.AccountUid);


                return OperationResult;
            }
            catch (Exception ex)
            {
                InsertLog(model.Id.ToString(), OperationName, BeginTime, RequestMessage, ex.ToString(), false, model.DmaId.Value, model.CreateUser.Value, model.CreateUserName, model.AccountUid);
                throw ex;
            }
        }

        public String EnterprisePayComplate(String jsonStr)
        {
            _log.Info(jsonStr);
            EnterprisePayComplateReslt result = DeserializeJsonToObject<EnterprisePayComplateReslt>(jsonStr);

            if (String.IsNullOrEmpty(result.serviceId))
            {

            }

            if ("SUCCESS".Equals(result.result))
            {
                return "打款成功";
            }
            else
            {
                return result.msg;
            }
        }

        #endregion

        #region 文档保全
        public String FileDigestEvi(EviFileModel model)
        {
            OperationResult = false;
            OperationName = "文档保全";
            BeginTime = DateTime.Now;
            RequestMessage = JsonConvert.SerializeObject(model);
            try
            {
                ////Formal//a65b7e7c-ee61-4369-83e1-981843b94d76.pdf
                // 存证名称
                string eviName = model.eviName;
                //文件名
                string fileName = Path.GetFileName(model.filePath);
                //文件大小
                FileInfo fileInfo = new FileInfo(model.filePath);
                long contentLength = fileInfo.Length;

                // 原文SHA256摘要
                string fileSHA256 = FileHelper.SHA256File(model.filePath);
                _log.Info("原文SHA256摘要 = " + fileSHA256);

                /*- - - - - - - - - - eSignIds列表(可同时设置多个)  - - - - - - - - - -*/
                //model.eviFileDigestInfo.eSignIds = new List<ESignIds>();
                //eSignIdsList.Add(new ESignIds { type = 0, value = "953168998248288265" });//电子签名签署成功时返回的SignServiceId（签署记录ID）
                //eSignIdsList.Add(new ESignIds { type = 0, value = "953169021199486984" });
                /*- - - - - - - - - -   - - - - - - - - - -*/

                EviFileDigestInfo eviFileDigestInfo = new EviFileDigestInfo();
                eviFileDigestInfo.eviName = model.eviName;
                eviFileDigestInfo.contentDescription = fileName;
                eviFileDigestInfo.contentLength = contentLength;
                eviFileDigestInfo.contentDigest = fileSHA256;
                eviFileDigestInfo.eSignIds = model.eSignIds;
                eviFileDigestInfo.bizIds = model.bizIds; //null-代表未使用实名认证

                String data = JsonConvert.SerializeObject(eviFileDigestInfo);

                //模拟请求  获取获取摘要保全存证编号
                String result = HttpPostData(ESign_FileDigestAPI, data);

                EviFileDigestResult fileResult = DeserializeJsonToObject<EviFileDigestResult>(result);

                if ("0".Equals(fileResult.errCode.ToString()))
                {
                    ResponseMessage = "文档保全结果：" + "\n\n" + "信息校验通过！fileResult=" + result;
                    OperationResult = true;
                }
                else
                {
                    ResponseMessage = "文档保全结果：" + "\n\n" + "信息校验失败！" + "\n\n" + "errCode=" + fileResult.errCode.ToString() + "\n" + "msg=" + fileResult.msg.ToString();
                    throw new Exception(ResponseMessage);
                }

                _log.Info(RequestMessage);

                InsertLog(model.applyId.ToString(), OperationName, BeginTime, RequestMessage, ResponseMessage, OperationResult, model.dealerId, model.CreateUser, model.CreateUserName, "");

                return fileResult.eid;
            }
            catch (Exception ex)
            {
                InsertLog(model.applyId.ToString(), OperationName, BeginTime, RequestMessage, ex.ToString(), false, model.dealerId, model.CreateUser, model.CreateUserName, "");
                throw ex;
            }
        }

        public void RelateEvIdWithUser(RelateFileModel model)
        {
            OperationResult = false;
            OperationName = "存证编号关联到指定用户";
            BeginTime = DateTime.Now;
            RequestMessage = JsonConvert.SerializeObject(model);
            try
            {
                CertificateInfo certificateInfo = new CertificateInfo();
                certificateInfo.evid = model.evid;
                certificateInfo.certificates = model.certificates;

                String data = JsonConvert.SerializeObject(certificateInfo);

                //模拟请求  获取获取摘要保全存证编号
                String result = HttpPostData(ESign_RelateAPI, data);

                EviFileDigestResult fileResult = DeserializeJsonToObject<EviFileDigestResult>(result);

                if ("0".Equals(fileResult.errCode.ToString()))
                {
                    ResponseMessage = "存证编号关联到指定用户结果：" + "\n\n" + "信息校验通过！fileResult=" + result;
                    OperationResult = true;
                }
                else
                {
                    ResponseMessage = "存证编号关联到指定用户结果：" + "\n\n" + "信息校验失败！" + "\n\n" + "errCode=" + fileResult.errCode.ToString() + "\n" + "msg=" + fileResult.msg.ToString();
                    throw new Exception(ResponseMessage);
                }

                _log.Info(RequestMessage);

                InsertLog(model.applyId.ToString(), OperationName, BeginTime, RequestMessage, ResponseMessage, OperationResult, model.dealerId, model.CreateUser, model.CreateUserName, "");
            }
            catch (Exception ex)
            {
                InsertLog(model.applyId.ToString(), OperationName, BeginTime, RequestMessage, ex.ToString(), false, model.dealerId, model.CreateUser, model.CreateUserName, "");
                throw ex;
            }
        }

        public String GetFileDigestEviUrl(FileDigestEviUrlModel model)
        {
            // 存证证明页面查看地址Url的有效期：
            String reverse = "true";
            String timestampString = null;
            if ("false".Equals(reverse))
            {
                // false表示timestamp字段为链接的生效时间，在生效30分钟后该链接失效
                long timestamp = GetTimestamp();
                timestampString = timestamp.ToString();// 当前系统的时间戳
            }
            else
            {
                // true表示timestamp字段为链接的失效时间
                timestampString = GetTimestamp(DateTime.Now.AddDays(1).ToString("yyyy-MM-dd HH:mm:ss")).ToString();
                Console.WriteLine(timestampString);
            }

            //// 证件类型
            //String type = "ID_CARD";
            //// 证件号码，指定这个用户查看这个存证证明时，页面中的证明持有人一栏显示的是该用户名称
            //String number = "220301198711200018";
            String data = "id=" + model.evid + "&projectId=" + ESign_ProjectId + "&timestamp=" + timestampString + "&reverse=" + reverse
                + "&type=" + model.certificateType.ToString() + "&number=" + model.certificateNumber;

            //计算请求签名值
            string signature = GetXtimevaleSignature(ESign_ProjectSecret, data);
            string urlStr = data + "&signature=" + signature;
            //查看存证证明跳转测试环境地址
            return ESign_CertificateInfoUrl + "?" + urlStr;
        }

        #endregion

        #region E签宝接口对接私有方法
        /// <summary>
        /// 模拟POST请求
        /// </summary>
        /// <param name="url"></param>
        /// <param name="param"></param>
        /// <returns></returns>
        private String HttpPostData(String url, String param)
        {
            //计算请求签名值
            string signature = GetXtimevaleSignature(ESign_ProjectSecret, param);
            var result = string.Empty;
            //注意提交的编码 这边是需要改变的 这边默认的是Default：系统当前编码
            byte[] postData = Encoding.UTF8.GetBytes(param);

            // 设置提交的相关参数 
            HttpWebRequest request = WebRequest.Create(url) as HttpWebRequest;
            Encoding myEncoding = Encoding.UTF8;
            request.Method = "POST";
            request.KeepAlive = false;
            request.AllowAutoRedirect = false;
            request.Headers.Add("X-timevale-project-id", ESign_ProjectId);
            request.Headers.Add("X-timevale-signature", signature);
            request.Headers.Add("X-timevale-signature-algorithm", "HmacSHA256");
            request.Headers.Add("Charset", "UTF-8");
            request.ContentType = "application/json";

            // 提交请求数据 
            System.IO.Stream outputStream = request.GetRequestStream();
            outputStream.Write(postData, 0, postData.Length);
            outputStream.Close();

            HttpWebResponse response;
            Stream responseStream;
            StreamReader reader;
            string srcString;
            response = request.GetResponse() as HttpWebResponse;
            responseStream = response.GetResponseStream();
            reader = new System.IO.StreamReader(responseStream, Encoding.GetEncoding("UTF-8"));
            srcString = reader.ReadToEnd();
            result = srcString;   //返回值赋值
            reader.Close();
            return result;
        }

        /// <summary>
        ///  HmacSHA256 加密
        /// </summary>
        /// <param name="secret">projectSecret</param>
        /// <param name="data">请求的JSON参数</param>
        /// <returns></returns>
        private String GetXtimevaleSignature(String secret, String data)
        {
            byte[] keyByte = Encoding.UTF8.GetBytes(secret);
            byte[] messageBytes = Encoding.UTF8.GetBytes(data);
            using (var hmacsha256 = new HMACSHA256(keyByte))
            {
                byte[] hashmessage = hmacsha256.ComputeHash(messageBytes);
                StringBuilder sb = new StringBuilder();
                foreach (byte test in hashmessage)
                {
                    sb.Append(test.ToString("x2"));
                }
                return sb.ToString();
            }
        }

        private String GetStringByByte(byte[] b)
        {
            StringBuilder sb = new StringBuilder();
            foreach (byte test in b)
            {
                sb.Append(test.ToString("x2"));
            }
            return sb.ToString();
        }

        /// <summary>    
        /// 获取当前时间戳（毫秒级）    
        /// </summary>        
        /// <returns>long</returns>    
        public static long GetTimestamp()
        {
            System.DateTime startTime = TimeZone.CurrentTimeZone.ToLocalTime(new System.DateTime(1970, 1, 1, 0, 0, 0, 0));
            long t = (DateTime.Now.Ticks - startTime.Ticks) / 10000;   //除10000调整为13位        
            return t;
        }

        public static long GetTimestamp(String time)
        {
            System.DateTime startTime = TimeZone.CurrentTimeZone.ToLocalTime(new System.DateTime(1970, 1, 1, 0, 0, 0, 0));
            long t = (Convert.ToDateTime(time).Ticks - startTime.Ticks) / 10000;   //除10000调整为13位        
            return t;
        }

        /// <summary>
        /// 将对象序列化为JSON格式
        /// </summary>
        /// <param name="o">对象</param>
        /// <returns>json字符串</returns>
        private static String SerializeObject(object o)
        {
            string json = JsonConvert.SerializeObject(o);
            return json;
        }

        /// <summary>
        /// 解析JSON字符串生成对象实体
        /// </summary>
        /// <typeparam name="T">对象类型</typeparam>
        /// <param name="json">json字符串</param>
        /// <returns>对象实体</returns>
        private static T DeserializeJsonToObject<T>(String json) where T : class
        {
            JsonSerializer serializer = new JsonSerializer();
            StringReader sr = new StringReader(json);
            object o = serializer.Deserialize(new JsonTextReader(sr), typeof(T));
            T t = o as T;
            return t;
        }

        /// <summary>
        /// 解析JSON数组生成对象实体集合
        /// </summary>
        /// <typeparam name="T">对象类型</typeparam>
        /// <param name="json">json字符串</param>
        /// <returns>对象实体集合</returns>
        private static List<T> DeserializeJsonToList<T>(String json) where T : class
        {
            JsonSerializer serializer = new JsonSerializer();
            StringReader sr = new StringReader(json);
            object o = serializer.Deserialize(new JsonTextReader(sr), typeof(List<T>));
            List<T> list = o as List<T>;
            return list;
        }

        /// <summary>
        /// 反序列化JSON到给定的匿名对象.
        /// </summary>
        /// <typeparam name="T">匿名对象类型</typeparam>
        /// <param name="json">json字符串</param>
        /// <param name="anonymousTypeObject">匿名对象</param>
        /// <returns>匿名对象</returns>
        private static T DeserializeAnonymousType<T>(String json, T anonymousTypeObject)
        {
            T t = JsonConvert.DeserializeAnonymousType(json, anonymousTypeObject);
            return t;
        }
        #endregion

        #region DMS业务数据（操作日志、合同版本、企业信息、签章等）
        /// <summary>
        /// 添加企业信息
        /// </summary>
        /// <param name="enterprise"></param>
        private void InsertEnterpriseMaster(EnterpriseMaster enterprise)
        {
            using (EnterpriseMasterDao dao = new EnterpriseMasterDao())
            {
                dao.Insert(enterprise);
            }
        }

        /// <summary>
        /// 添加企业印章信息
        /// </summary>
        /// <param name="seal"></param>
        private void InsertEnterpriseSeal(EnterpriseSeal seal)
        {
            using (EnterpriseSealDao dao = new EnterpriseSealDao())
            {
                dao.Insert(seal);
            }
        }

        private void InsertFileVersion(SignPdfModel model, FileDigestSignResult fileResut, int i)
        {
            using (FileVersionDao dao = new FileVersionDao())
            {
                FileVersion file = new FileVersion();

                file.Id = Guid.NewGuid();
                file.ApplyId = new Guid(model.ApplyId);
                file.FileId = new Guid(model.FileId);
                file.FileUrl = model.dstFile + model.dstName;
                file.FileName = model.fileName;
                file.Version = i.ToString();
                file.IsCurrent = 1;
                file.SignServiceId = fileResut.SignServiceId;
                file.FilePath = fileResut.FilePath;
                file.Stream = GetStringByByte(fileResut.Stream);
                file.CreateDate = model.CreateDate;
                file.CreateUser = model.CreateUser;
                file.CreateUserName = model.CreateUserName;

                dao.Insert(file);
            }
        }

        /// <summary>
        /// 记录电子签章操作日志
        /// </summary>
        private static void InsertLog(String applyId, String name, DateTime startTime, String reqMsg, String resMsg
          , bool status, Guid dealerId, Guid userId, String userName, String accountUid)
        {
            using (OperationLogDao dao = new OperationLogDao())
            {
                OperationLog operLog = new OperationLog();
                operLog.ApplyId = applyId;
                operLog.Id = Guid.NewGuid();
                operLog.DealerId = dealerId;
                operLog.AccountUid = accountUid;
                operLog.Name = name;
                operLog.StartTime = startTime;
                operLog.EndTime = DateTime.Now;
                operLog.RequestMsg = reqMsg;
                operLog.ResponseMsg = resMsg;
                operLog.OperationUser = userId;
                operLog.OperationUserName = userName;
                operLog.Status = status ? "SUCCESS" : "FAILURE";

                dao.Insert(operLog);
            }
        }
        #endregion

        #region PDF转图片
        public void ConvertPDF2Image(string pdfFilePath, string imageDirectoryPath,
            int beginPageNum, int endPageNum, ImageFormat format, double zoom = 1)
        {
            try
            {
                Acrobat.CAcroPDDoc pdfDoc = null;
                Acrobat.CAcroPDPage pdfPage = null;
                Acrobat.CAcroRect pdfRect = null;
                Acrobat.CAcroPoint pdfPoint = null;

                //1)
                //生成操作Pdf文件的Com对象
                pdfDoc = (Acrobat.CAcroPDDoc)Activator.CreateInstance(System.Type.GetTypeFromProgID("AcroExch.PDDoc"));

                //检查输入参数
                if (!pdfDoc.Open(pdfFilePath))
                {
                    throw new FileNotFoundException(string.Format("源文件{0}不存在！", pdfFilePath));
                }

                if (!Directory.Exists(imageDirectoryPath))
                {
                    Directory.CreateDirectory(imageDirectoryPath);
                }

                if (beginPageNum <= 0)
                {
                    beginPageNum = 1;
                }

                if (endPageNum > pdfDoc.GetNumPages() || endPageNum <= 0)
                {
                    endPageNum = pdfDoc.GetNumPages();
                }

                if (beginPageNum > endPageNum)
                {
                    throw new ArgumentException("参数\"beginPageNum\"必须小于\"endPageNum\"！");
                }

                if (format == null)
                {
                    format = ImageFormat.Png;
                }

                if (!String.IsNullOrEmpty(ESign_Zoom))
                {
                    int tempZomm = 1;
                    if (int.TryParse(ESign_Zoom, out tempZomm))
                    {
                        zoom = tempZomm;
                    }
                }

                if (zoom <= 0)
                {
                    zoom = 1;
                }

                //转换
                for (int i = beginPageNum; i <= endPageNum; i++)
                {
                    //2)
                    //取出当前页
                    pdfPage = (Acrobat.CAcroPDPage)pdfDoc.AcquirePage(i - 1);

                    //3)
                    //得到当前页的大小
                    pdfPoint = (Acrobat.CAcroPoint)pdfPage.GetSize();
                    //生成一个页的裁剪区矩形对象
                    pdfRect = (Acrobat.CAcroRect)Activator.CreateInstance(System.Type.GetTypeFromProgID("AcroExch.Rect"));


                    //计算当前页经缩放后的实际宽度和高度,zoom==1时，保持原比例大小
                    int imgWidth = (int)((double)pdfPoint.x * zoom);
                    int imgHeight = (int)((double)pdfPoint.y * zoom);

                    //设置裁剪矩形的大小为当前页的大小
                    pdfRect.Left = 0;
                    pdfRect.right = (short)imgWidth;
                    pdfRect.Top = 0;
                    pdfRect.bottom = (short)imgHeight;

                    //4)
                    //将当前页的裁剪区的内容编成图片后复制到剪贴板中
                    pdfPage.CopyToClipboard(pdfRect, 0, 0, (short)(100 * zoom));

                    //5)
                    IDataObject clipboardData = Clipboard.GetDataObject();

                    //检查剪贴板中的对象是否是图片，如果是图片则将其保存为指定格式的图片文件
                    if (clipboardData.GetDataPresent(DataFormats.Bitmap))
                    {
                        Bitmap pdfBitmap = (Bitmap)clipboardData.GetData(DataFormats.Bitmap);

                        pdfBitmap.Save(
                            Path.Combine(imageDirectoryPath, i.ToString("0000") + "." + format.ToString()), format);

                        pdfBitmap.Dispose();
                    }
                }

                //关闭和释放相关COM对象
                pdfDoc.Close();
                Marshal.ReleaseComObject(pdfRect);
                Marshal.ReleaseComObject(pdfPoint);
                Marshal.ReleaseComObject(pdfPage);
                Marshal.ReleaseComObject(pdfDoc);
            }
            catch (Exception ex)
            {
                _log.Error(ex.ToString());
            }
        }
        #endregion
    }
}
