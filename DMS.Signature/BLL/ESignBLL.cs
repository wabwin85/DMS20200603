using Common.Logging;
using DMS.Signature.Daos;
using DMS.Signature.Model;
using Grapecity.DataAccess.Transaction;
using Newtonsoft.Json;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading;
using System.Web.UI;
using static DMS.Signature.Model.EviFileDigestRequest;

namespace DMS.Signature.BLL
{
    public class ESignBLL
    {
        private static ILog _log = LogManager.GetLogger(typeof(ESignBLL));
        private static readonly object SequenceLock = new object();
        SignatureHelper signHelper = new SignatureHelper();

        #region 关联经销商
        public String QueryEnterpriseMapping(String dealerId)
        {
            using (EnterpriseMappingDao dao = new EnterpriseMappingDao())
            {
                Hashtable table = new Hashtable();
                table.Add("DealerId", dealerId);


                EnterpriseMapping mapping = dao.QueryEnterpriseMappingByFilter(table);

                if (mapping != null && mapping.ParentId.HasValue)
                {
                    return mapping.ParentId.Value.ToString();
                }

                return dealerId;
            }
        }
        #endregion

        #region 企业用户信息管理
        /// <summary>
        /// 企业用户注册
        /// </summary>
        /// <param name="vo"></param>
        public void CreateEnterpriseUser(EnterpriseUserVO vo)
        {
            using (EnterpriseMasterDao dao = new EnterpriseMasterDao())
            {
                EnterpriseMaster em = new EnterpriseMaster();

                em.Id = Guid.NewGuid();
                em.DmaId = new Guid(vo.DealerId);
                em.ParentDmaId = new Guid(vo.SubDealerId);
                em.DealerName = vo.DealerName;
                em.AccountUid = vo.AccountUid;
                em.Phone = vo.Phone;
                em.Email = vo.Email;
                em.Name = vo.Name;
                em.OrganType = vo.OrganType;
                em.RegType = vo.RegType;
                em.OrganCode = vo.OrganCode;
                em.UserType = vo.UserType;
                em.LegalName = vo.LegalName;
                em.LegalIdNo = vo.LegalIdNo;
                em.LegalArea = vo.LegalArea;
                em.AgentName = vo.AgentName;
                em.AgentIdNo = vo.AgentIdNo;
                em.Address = vo.Address;
                em.Scope = vo.Scope;
                em.Status = EnterpriseMasterStatus.NORMAL.ToString();
                em.CreateDate = vo.CreateDate;
                em.CreateUser = vo.CreateUser;
                em.CreateUserName = vo.CreateUserName;
                em.UpdateDate = vo.UpdateDate;
                em.UpdateUser = vo.UpdateUser;
                em.UpdateUserName = vo.UpdateUserName;

                try
                {
                    em.AccountUid = signHelper.AddOrganize(em);
                }
                catch (Exception ex)
                {
                    em.Status = EnterpriseMasterStatus.ERROR.ToString();
                    throw ex;
                }
                finally
                {
                    dao.Insert(em);
                }
            }
        }

        public DataTable QueryEnterpriseUser(String dealerId)
        {
            using (EnterpriseMasterDao dao = new EnterpriseMasterDao())
            {
                Hashtable table = new Hashtable();

                ///关联经销商ID
                table.Add("DealerId", this.QueryEnterpriseMapping(dealerId));
                ///原始经销商ID
                table.Add("ParentDealerId", dealerId);

                return dao.QueryEnterpriseMasterByDealerId(table);
            }
        }
        #endregion

        #region 企业用户制章管理

        /// <summary>
        /// 企业用户制章
        /// </summary>
        /// <param name="vo"></param>
        public void CreateEnterpriseSeal(EnterpriseSealVO vo)
        {
            using (EnterpriseSealDao dao = new EnterpriseSealDao())
            {
                using (EnterpriseMasterDao userDao = new EnterpriseMasterDao())
                {
                    Hashtable table = new Hashtable();

                    table.Add("AccountUid", vo.AccountUid);
                    DataTable dt = userDao.QueryEnterpriseMasterByAccountUid(table);

                    if (dt.Rows.Count == 0)
                    {
                        throw new Exception("当前用户失效，请重新注册电子签章企业用户信息");
                    }
                }

                EnterpriseSeal es = new EnterpriseSeal();

                es.Id = Guid.NewGuid();
                es.EmId = new Guid(vo.DealerId);
                es.DmaId = new Guid(vo.DealerId);
                es.ParentDmaId = new Guid(vo.SubDealerId);
                es.DealerName = vo.DealerName;
                es.OrganName = vo.OrganName;
                es.AccountUid = vo.AccountUid;
                es.TemplateType = vo.TemplateType;
                es.Color = vo.Color;
                es.Htext = vo.HText;
                es.Qtext = vo.QText;

                es.ImageUrl = vo.ImageUrl;
                es.IsActive = 1;

                es.CreateDate = vo.CreateDate;
                es.CreateUser = vo.CreateUser;
                es.CreateUserName = vo.CreateUserName;
                es.UpdateDate = vo.UpdateDate;
                es.UpdateUser = vo.UpdateUser;
                es.UpdateUserName = vo.UpdateUserName;

                try
                {
                    es.Seal = signHelper.AddTemplateSeal(es);
                }
                catch (Exception ex)
                {
                    es.IsActive = 2;//2代表Error
                    throw ex;
                }
                finally
                {
                    dao.Insert(es);
                }
            }
        }

        public DataSet QueryEnterpriseSeal(String dealerId)
        {
            using (EnterpriseSealDao dao = new EnterpriseSealDao())
            {
                Hashtable table = new Hashtable();

                ///关联经销商ID
                table.Add("DealerId", this.QueryEnterpriseMapping(dealerId));
                ///原始经销商ID
                table.Add("ParentDealerId", dealerId);

                return dao.QueryEnterpriseSealByDealerId(table);
            }
        }
        #endregion

        #region 企业用户签章
        /// <summary>
        /// 发送短信验证码
        /// </summary>
        /// <param name="vo"></param>
        public String SendMobileCode(EnterpriseSignVO vo)
        {
            using (EnterpriseMasterDao dao = new EnterpriseMasterDao())
            {
                //根据DealerId，获取经销商
                String accountUid = String.Empty;
                String legalAccountUid = String.Empty;
                String phone = String.Empty;
                this.getAccountUidAndPhone(vo.DealerId, out accountUid, out legalAccountUid,out phone);
                
                ESignBaseModel spm = new ESignBaseModel();

                spm.ApplyId = Guid.NewGuid().ToString();
                spm.DealerId = new Guid(vo.DealerId);
                spm.AccountUid = accountUid;
                spm.CreateUser = vo.CreateUser;
                spm.CreateUserName = vo.CreateUserName;
                spm.CreateDate = vo.CreateDate;

                signHelper.SendSignMobileCode(spm);
                return phone;
            }
        }

        /// <summary>
        /// PDF预览
        /// </summary>
        /// <param name="vo"></param>
        /// <returns></returns>
        public List<Object> PereviewPdf(String filePath)
        {
            String tempFile = Guid.NewGuid().ToString();
            String pdfFilePath = new Page().Server.MapPath(filePath);
            String imageDirectoryPath = new Page().Server.MapPath("/Upload/temp/" + tempFile);

            List<Object> list = new List<Object>();

            lock (SequenceLock)
            {
                ConvertPdtToImage convertPdtToImage = new ConvertPdtToImage(pdfFilePath, imageDirectoryPath);
                //_log.Info("Start :" + DateTime.Now.ToString("yyyy-MM-dd mm:HH:ss fff"));

                Thread thread = new Thread(new ThreadStart(convertPdtToImage.ToConvert));
                thread.SetApartmentState(ApartmentState.STA);

                thread.Start();

                thread.Join();
                //_log.Info("End :" + DateTime.Now.ToString("yyyy-MM-dd mm:HH:ss fff"));

                if (Directory.Exists(imageDirectoryPath))
                {
                    DirectoryInfo folder = new DirectoryInfo(imageDirectoryPath);

                    foreach (FileInfo file in folder.GetFiles("*.Png"))
                    {
                        list.Add(new { name = file.Name, imgSrc = String.Format("/Upload/temp/{0}/{1}", tempFile, file.Name) });
                    }
                }
            }

            return list;
        }

        /// <summary>
        /// 企业用户摘要签章（需要短信验证码）
        /// </summary>
        /// <param name="vo"></param>
        public void EnterpriseUserSign(EnterpriseSignVO vo)
        {
            using (EnterpriseSealDao dao = new EnterpriseSealDao())
            {
                using (EnterpriseLegalSealDao legalDao = new EnterpriseLegalSealDao())
                {
                    if (SignatureHelper.ESing_NeedShortMessage == "1" && String.IsNullOrEmpty(vo.Code))
                    {
                        throw new Exception("请输入验证码！");
                    }

                    //根据DealerId，获取经销商
                    String accountUid = String.Empty;
                    String legalAccountUid = String.Empty;
                    String seal = String.Empty;
                    String legalSeal = String.Empty;
                    //测试签章
                    //vo.DealerId = "85754CAF-23D2-4910-86CE-67DECF86262C";

                    this.getAccountUidAndSeal(vo.DealerId, out accountUid, out legalAccountUid, out seal, out legalSeal);

                    SignPdfModel spm = new SignPdfModel();

                    spm.ApplyId = vo.ApplyId;
                    spm.FileId = vo.FileId;
                    spm.fileName = vo.FileName;
                    spm.code = vo.Code;

                    spm.srcName = vo.FileSrcName;
                    spm.srcFile = vo.FileSrcPath;
                    spm.dstFile = vo.FileDstPath;

                    spm.DealerId = new Guid(vo.DealerId);
                    spm.AccountUid = accountUid;
                    spm.LegalAccountUid = legalAccountUid; 
                    spm.CreateUser = vo.CreateUser;
                    spm.CreateUserName = vo.CreateUserName;
                    spm.CreateDate = vo.CreateDate;

                    if (vo.FileId=="00000000-0000-0000-0000-000000000000")
                    {
                        spm.sealList = GetSealPostModel(EnterpriseUserType.OBORDealer.ToString(), null, seal, legalSeal);
                    }
                    else
                    {
                        spm.sealList = GetSealPostModel(EnterpriseUserType.Dealer.ToString(), null, seal, legalSeal);
                    }
                    

                    signHelper.LocalSignPDF(spm);

                    vo.FileSrcPath = spm.srcFile;
                    vo.FileSrcName = spm.srcName;
                }
            }
        }


        
        public void EnterpriseLPSign(EnterpriseSignVO vo)
        {
            using (EnterpriseSealDao dao = new EnterpriseSealDao())
            {
                using (EnterpriseLegalSealDao legalDao = new EnterpriseLegalSealDao())
                {
                    //if (SignatureHelper.ESing_NeedShortMessage == "1" && String.IsNullOrEmpty(vo.Code))
                    //{
                    //    throw new Exception("请输入验证码！");
                    //}

                    //根据DealerId，获取经销商
                    String accountUid = String.Empty;
                    String legalAccountUid = String.Empty;
                    String seal = String.Empty;
                    String legalSeal = String.Empty;

                    //vo.DealerId = "85754CAF-23D2-4910-86CE-67DECF86262C";

                    this.getAccountUidAndSeal(vo.DealerId, out accountUid, out legalAccountUid, out seal, out legalSeal);

                    SignPdfModel spm = new SignPdfModel();

                    spm.ApplyId = vo.ApplyId;
                    spm.FileId = vo.FileId;
                    spm.fileName = vo.FileName;
                    spm.code = vo.Code;

                    spm.srcName = vo.FileSrcName;
                    spm.srcFile = vo.FileSrcPath;
                    spm.dstFile = vo.FileDstPath;

                    spm.DealerId = new Guid(vo.DealerId);
                    spm.AccountUid = accountUid;
                    spm.LegalAccountUid = legalAccountUid;
                    spm.CreateUser = vo.CreateUser;
                    spm.CreateUserName = vo.CreateUserName;
                    spm.CreateDate = vo.CreateDate;

                    if (vo.FileId == "00000000-0000-0000-0000-000000000000")
                    {
                        spm.sealList = GetSealPostModel(EnterpriseUserType.OBORLP.ToString(), null, seal, legalSeal);
                    }
                    else
                    {
                        spm.sealList = GetSealPostModel(EnterpriseUserType.LP.ToString(), null, seal, legalSeal);
                    }
                       

                    signHelper.LocalSignPDF(spm);

                    vo.FileSrcPath = spm.srcFile;
                    vo.FileSrcName = spm.srcName;
                }
            }
        }

        private void getAccountUidAndPhone(String dealerId, out String accountUid, out String legalAccountUid, out String phone)
        {
            String seal = String.Empty;
            String legalSeal = String.Empty;

            this.getAccountUid(dealerId, out accountUid, out legalAccountUid, out seal, out legalSeal, out phone);
        }

        private void getAccountUid(String dealerId, out String accountUid, out String legalAccountUid)
        {
            String seal = String.Empty;
            String legalSeal = String.Empty;
            String phone = String.Empty;

            this.getAccountUid(dealerId, out accountUid, out legalAccountUid, out seal, out legalSeal, out phone);
        }

        private void getAccountUidAndSeal(String dealerId, out String accountUid, out String legalAccountUid,out String seal,out String legalSeal)
        {
            String phone = String.Empty;
            this.getAccountUid(dealerId, out accountUid, out legalAccountUid, out seal, out legalSeal, out phone);
        }

        private void getAccountUid(String dealerId, out String accountUid, out String legalAccountUid,out String seal,out String legalSeal, out String phone)
        {
            //根据DealerId，获取经销商
            DataTable dt = this.QueryEnterpriseUser(dealerId);

            if (dt == null || dt.Rows.Count == 0 || dt.Rows[0]["AccountUid"] == null || dt.Rows[0]["AccountUid"] == DBNull.Value
                || dt.Rows[0]["LegalAccountUid"] == null || dt.Rows[0]["LegalAccountUid"] == DBNull.Value
                || string.IsNullOrEmpty(dt.Rows[0]["AccountUid"].ToString())
                || string.IsNullOrEmpty(dt.Rows[0]["LegalAccountUid"].ToString()))
            {
                throw new Exception("请注册电子签章企业用户信息");
            }
            else if (dt.Rows[0]["Seal"] == null || dt.Rows[0]["Seal"] == DBNull.Value
                || string.IsNullOrEmpty(dt.Rows[0]["Seal"].ToString())
                || dt.Rows[0]["LegalSeal"] == null || dt.Rows[0]["LegalSeal"] == DBNull.Value
                || string.IsNullOrEmpty(dt.Rows[0]["LegalSeal"].ToString())
                )
            {
                throw new Exception("请先创建企业电子印章");
            }

            accountUid = dt.Rows[0]["AccountUid"].ToString();
            legalAccountUid = dt.Rows[0]["LegalAccountUid"].ToString();
            seal = dt.Rows[0]["Seal"].ToString();
            legalSeal = dt.Rows[0]["LegalSeal"].ToString();
            phone = dt.Rows[0]["Phone"].ToString();
        }

        private void PereviewPdf_ThreadException(object sender, ThreadExceptionEventArgs e)
        {
            _log.Error(e.Exception.ToString());
        }
        #endregion

        #region 平台自身摘要签署
        /// <summary>
        /// 平台自身摘要签署
        /// </summary>
        /// <param name="vo"></param>
        public void EnterpriseSelfSign(EnterpriseSignVO vo)
        {
            if (!vo.UserRoles.Contains(SignatureHelper.ESing_BscSignRole))
            {
                throw new Exception("没有权限执行此操作！");
            }

            //根据DealerId，获取经销商
            String accountUid = String.Empty;
            String legalAccountUid = String.Empty;
            String seal = String.Empty;
            String legalSeal = String.Empty;

            //vo.DealerId = "85754CAF-23D2-4910-86CE-67DECF86262C";

            this.getAccountUidAndSeal(vo.DealerId, out accountUid, out legalAccountUid, out seal, out legalSeal);

            SignPdfModel spm = new SignPdfModel();

            spm.ApplyId = vo.ApplyId;
            spm.FileId = vo.FileId;
            spm.fileName = vo.FileName;
            spm.code = vo.Code;

            spm.srcName = vo.FileSrcName;
            spm.srcFile = vo.FileSrcPath;
            spm.dstFile = vo.FileDstPath;

            spm.DealerId = new Guid(vo.DealerId);
            spm.AccountUid = accountUid;
            spm.LegalAccountUid = legalAccountUid;
            spm.CreateUser = vo.CreateUser;
            spm.CreateUserName = vo.CreateUserName;
            spm.CreateDate = vo.CreateDate;

            spm.sealList = GetSealPostModel(EnterpriseUserType.Local.ToString(), null, seal, legalSeal);

            signHelper.LocalSelfSignPDF(spm);
            
            vo.FileSrcPath = spm.srcFile;
            vo.FileSrcName = spm.srcName;
        }

        #endregion

        #region 平台自身作废签署
        /// <summary>
        /// 平台自身作废签署
        /// </summary>
        /// <param name="vo"></param>
        public void EnterpriseSelfCanelSign(EnterpriseSignVO vo)
        {
            if (!vo.UserRoles.Contains(SignatureHelper.ESing_BscSignRole))
            {
                throw new Exception("没有权限执行此操作！");
            }

            SignPdfModel spm = new SignPdfModel();

            spm.ApplyId = vo.ApplyId;
            spm.FileId = vo.FileId;
            spm.fileName = vo.FileName;
            spm.code = vo.Code;

            spm.srcName = vo.FileSrcName;
            spm.srcFile = vo.FileSrcPath;
            spm.dstFile = vo.FileDstPath;

            spm.DealerId = new Guid(vo.DealerId);
            spm.AccountUid = vo.AccountUid;
            spm.CreateUser = vo.CreateUser;
            spm.CreateUserName = vo.CreateUserName;
            spm.CreateDate = vo.CreateDate;

            spm.sealList = GetSealPostModel(EnterpriseUserType.LocalCancel.ToString(), null, "", "");

            signHelper.LocalSelfCanelPDF(spm);

            vo.FileSrcPath = spm.srcFile;
            vo.FileSrcName = spm.srcName;
        }
        #endregion

        #region 企业用户作废签署
        /// <summary>
        /// 企业用户作废签署
        /// </summary>
        /// <param name="vo"></param>
        public void EnterpriseUserCanelSign(EnterpriseSignVO vo)
        {
            using (EnterpriseSealDao dao = new EnterpriseSealDao())
            {
                if (SignatureHelper.ESing_NeedShortMessage == "1" && String.IsNullOrEmpty(vo.Code))
                {
                    throw new Exception("请输入验证码！");
                }

                //根据DealerId，获取经销商
                String accountUid = String.Empty;
                String legalAccountUid = String.Empty;
                String seal = String.Empty;
                String legalSeal = String.Empty;
                this.getAccountUidAndSeal(vo.DealerId, out accountUid, out legalAccountUid, out seal, out legalSeal);

                SignPdfModel spm = new SignPdfModel();
                spm.ApplyId = vo.ApplyId;
                spm.FileId = vo.FileId;
                spm.fileName = vo.FileName;
                spm.code = vo.Code;

                spm.srcName = vo.FileSrcName;
                spm.srcFile = vo.FileSrcPath;
                spm.dstFile = vo.FileDstPath;

                spm.DealerId = new Guid(vo.DealerId);
                spm.AccountUid = accountUid;
                spm.LegalAccountUid = legalAccountUid;

                spm.CreateUser = vo.CreateUser;
                spm.CreateUserName = vo.CreateUserName;
                spm.CreateDate = vo.CreateDate;

                spm.sealList = GetSealPostModel(EnterpriseUserType.DealerCancel.ToString(), null, seal, legalSeal);

                signHelper.LocalCancelPDF(spm);

                vo.FileSrcPath = spm.srcFile;
                vo.FileSrcName = spm.srcName;
            }
        }
        #endregion

        #region 企业实名认证（实名认证\打款认证\打款金额确认）
        public DataTable QuerySubBranchByKeyWord(Hashtable table, int start, int limit, out int totalRowCount)
        {
            using (EnterpriseAuthenticationDao dao = new EnterpriseAuthenticationDao())
            {
                return dao.QuerySubBranchByKeyWord(table, start, limit, out totalRowCount);
            }
        }

        public DataTable QueryEnterpriseAuth(EnterpriseAuthVO vo)
        {
            using (EnterpriseAuthenticationDao dao = new EnterpriseAuthenticationDao())
            {
                Hashtable table = new Hashtable();

                ///关联经销商ID
                table.Add("DealerId", this.QueryEnterpriseMapping(vo.DealerId));
                ///原始经销商ID
                table.Add("ParentDealerId", vo.DealerId);

                return dao.QueryEnterpriseAuthenticationByFilter(table);
            }
        }

        /// <summary>
        /// 实名认证
        /// </summary>
        /// <param name="vo"></param>
        public void EnterpriseRealNameAuth(EnterpriseAuthVO vo)
        {
            using (EnterpriseAuthenticationDao authDao = new EnterpriseAuthenticationDao())
            {
                using (EnterprisePayAuthDao payDao = new EnterprisePayAuthDao())
                {
                    Hashtable table = new Hashtable();

                    table.Add("DealerId", vo.DealerId);

                    EnterpriseAuthentication authModel = new EnterpriseAuthentication();//dao.QueryEnterpriseAuthenticationByDealerId(table);
                    EnterprisePayAuth payModel = new EnterprisePayAuth();

                    authModel.Id = Guid.NewGuid();
                    authModel.DmaId = new Guid(vo.DealerId);
                    authModel.ParentDmaId = new Guid(vo.SubDealerId);
                    authModel.AccountUid = vo.AccountUid;
                    authModel.DealerName = vo.DealerName.Trim();
                    authModel.Name = vo.OrganName.Trim();
                    authModel.UscCode = vo.ResisterType == "0" ? vo.OrganCode.Trim() : null;
                    authModel.OrgCode = vo.ResisterType == "1" ? vo.OrganCode.Trim() : null;
                    authModel.RegCode = vo.ResisterType == "2" ? vo.OrganCode.Trim() : null;
                    authModel.LegalName = vo.LegalName.Trim();
                    authModel.LegalIdNo = vo.LegalIdNo.Trim();

                    authModel.Status = EnterpriseAuthStatus.RealNameError.ToString();
                    authModel.IsActive = 1;
                    authModel.Remark1 = null;
                    authModel.Remark2 = null;
                    authModel.Remark3 = null;

                    authModel.CreateDate = vo.CreateDate;
                    authModel.CreateUser = vo.CreateUser;
                    authModel.CreateUserName = vo.CreateUserName;
                    authModel.UpdateDate = authModel.UpdateDate;
                    authModel.UpdateUser = authModel.UpdateUser;
                    authModel.UpdateUserName = authModel.UpdateUserName;

                    payModel.Id = Guid.NewGuid();
                    payModel.EaId = authModel.Id;
                    payModel.DmaId = authModel.DmaId;
                    payModel.ParentDmaId = authModel.ParentDmaId;
                    payModel.AccountUid = authModel.AccountUid;
                    payModel.Name = vo.AccountName.Trim();
                    payModel.CardNo = vo.CardNo.Trim();
                    payModel.Bank = vo.Bank.Trim();
                    payModel.SubBranch = vo.SubBranch.Trim();
                    payModel.Provice = vo.Provice.Trim();
                    payModel.City = vo.City.Trim();
                    payModel.ServiceId = "";
                    payModel.Prcptcd = vo.Prcptcd.Trim();

                    payModel.Status = EnterpriseToPayStatus.Error.ToString();
                    payModel.IsActive = 1;
                    payModel.Remark1 = null;
                    payModel.Remark2 = null;
                    payModel.Remark3 = null;

                    payModel.CreateDate = authModel.CreateDate;
                    payModel.CreateUser = authModel.CreateUser;
                    payModel.CreateUserName = authModel.CreateUserName;
                    payModel.UpdateDate = authModel.UpdateDate;
                    payModel.UpdateUser = authModel.UpdateUser;
                    payModel.UpdateUserName = authModel.UpdateUserName;

                    try
                    {
                        ///获取企业实名认证ServiceId
                        authModel.ServiceId = signHelper.EnterpriseNameAuthentication(authModel);
                        authModel.ToPayCount = 0;
                        ///重置认证状态为"实名认证成功"
                        authModel.Status = EnterpriseAuthStatus.RealNameSuccess.ToString();

                        ///将认证的ServiceId放入打款请求中
                        payModel.AuthServiceId = authModel.ServiceId;
                        ///获取企业打款认证ServiceId
                        payModel.ServiceId = "1";//signHelper.EnterpriseToPay(payModel);
                        ///重置打款认证状态为"等待金额认证"
                        payModel.Status = EnterpriseToPayStatus.WaitPayAuth.ToString();

                        ///重置认证状态为"打款成功"
                        authModel.Status = EnterpriseAuthStatus.PayAuthSuccss.ToString();
                    }
                    catch (Exception ex)
                    {
                        if (authModel.Status == EnterpriseAuthStatus.RealNameError.ToString())
                        {
                            authModel.Remark1 = ex.Message;
                            authModel.ServiceId = null;
                        }

                        if (authModel.Status == EnterpriseAuthStatus.RealNameSuccess.ToString()
                            && payModel.Status == EnterpriseToPayStatus.Error.ToString())
                        {
                            payModel.Remark1 = ex.Message;
                            payModel.ServiceId = null;
                        }

                        throw ex;
                    }
                    finally
                    {
                        using (TransactionScope trans = new TransactionScope())
                        {
                            authDao.Insert(authModel);
                            payDao.Insert(payModel);

                            trans.Complete();
                        }
                    }
                }
            }
        }

        /// <summary>
        /// 打款认证
        /// </summary>
        /// <param name="vo"></param>
        public void EnterpriseToPay(EnterpriseAuthVO vo)
        {
            using (EnterprisePayAuthDao dao = new EnterprisePayAuthDao())
            {
                using (EnterpriseAuthenticationDao authDao = new EnterpriseAuthenticationDao())
                {
                    Hashtable table = new Hashtable();

                    table.Add("DealerId", vo.DealerId);

                    EnterprisePayAuth model = dao.QueryEnterprisePayAuthByDealerId(table);
                    EnterpriseAuthentication auth = authDao.QueryEnterpriseAuthenticationByDealerId(table);

                    if (model == null || auth == null)
                    {
                        throw new Exception("企业认证信息不存在");
                    }
                    else if (String.IsNullOrEmpty(auth.ServiceId))
                    {
                        throw new Exception("请先认证企业实名制信息");
                    }
                    else if (auth.ToPayCount.HasValue && auth.ToPayCount.Value >= 5)
                    {
                        throw new Exception("打款金额验证超过5次请重新提交企业打款请求");
                    }

                    model.Status = EnterpriseToPayStatus.WaitPayAuth.ToString();
                    model.IsActive = 1;
                    model.Remark1 = null;
                    model.Remark2 = null;
                    model.Remark3 = null;

                    model.CreateDate = vo.CreateDate;
                    model.CreateUser = vo.CreateUser;
                    model.CreateUserName = vo.CreateUserName;
                    model.UpdateDate = model.UpdateDate;
                    model.UpdateUser = model.UpdateUser;
                    model.UpdateUserName = model.UpdateUserName;

                    try
                    {
                        //获取企业实名认证的ServiceId
                        model.ServiceId = signHelper.EnterpriseToPay(model);
                    }
                    catch (Exception ex)
                    {
                        model.Status = EnterpriseToPayStatus.Error.ToString();
                        model.Remark1 = ex.Message;
                        model.Remark2 = model.ServiceId;
                        model.ServiceId = null;
                        throw ex;
                    }
                    finally
                    {
                        dao.Update(model);
                    }
                }
            }
        }

        /// <summary>
        /// 打款金额校验
        /// </summary>
        public void EnterprisePayAuth(EnterpriseAuthVO vo)
        {
            using (EnterprisePayAuthDao payDao = new EnterprisePayAuthDao())
            {
                using (EnterpriseAuthenticationDao authDao = new EnterpriseAuthenticationDao())
                {
                    Hashtable table = new Hashtable();

                    table.Add("DealerId", vo.DealerId);

                    EnterpriseAuthentication authModel = authDao.QueryEnterpriseAuthenticationByDealerId(table);
                    EnterprisePayAuth payModel = payDao.QueryEnterprisePayAuthByDealerId(table);

                    if (authModel == null || payModel == null)
                    {
                        throw new Exception("企业认证信息不存在");
                    }
                    else if (String.IsNullOrEmpty(authModel.ServiceId))
                    {
                        throw new Exception("请先认证企业实名制信息");
                    }
                    else if (String.IsNullOrEmpty(payModel.ServiceId))
                    {
                        throw new Exception("请先执行企业打款");
                    }
                    else if (payModel.PayAuthCount.HasValue && payModel.PayAuthCount.Value >= 3)
                    {
                        throw new Exception("打款金额验证超过3次请重新提交企业打款请求");
                    }

                    authModel.Status = EnterpriseAuthStatus.PayAuthError.ToString();

                    authModel.Id = Guid.NewGuid();
                    authModel.CreateDate = vo.CreateDate;
                    authModel.CreateUser = vo.CreateUser;
                    authModel.CreateUserName = vo.CreateUserName;
                    authModel.UpdateDate = authModel.UpdateDate;
                    authModel.UpdateUser = authModel.UpdateUser;
                    authModel.UpdateUserName = authModel.UpdateUserName;

                    payModel.Id = Guid.NewGuid();
                    payModel.EaId = authModel.Id;
                    payModel.Status = EnterpriseToPayStatus.Error.ToString();

                    payModel.PayAuthCount = payModel.PayAuthCount.HasValue ? payModel.PayAuthCount + 1 : 1;
                    payModel.CreateDate = authModel.CreateDate;
                    payModel.CreateUser = authModel.CreateUser;
                    payModel.CreateUserName = authModel.CreateUserName;
                    payModel.UpdateDate = authModel.UpdateDate;
                    payModel.UpdateUser = authModel.UpdateUser;
                    payModel.UpdateUserName = authModel.UpdateUserName;

                    try
                    {
                        payModel.PayResult = signHelper.EnterprisePayAuth(payModel) ? "SUCCESS" : "ERROR";

                        authModel.Status = EnterpriseAuthStatus.Normal.ToString();
                        payModel.Status = EnterpriseToPayStatus.Normal.ToString();
                    }
                    catch (Exception ex)
                    {
                        if (authModel.Status == EnterpriseAuthStatus.PayAuthError.ToString())
                        {
                            authModel.Remark1 = ex.Message;
                        }
                        if (payModel.Status == EnterpriseToPayStatus.Error.ToString())
                        {
                            payModel.Remark1 = ex.Message;
                        }
                        if (payModel.PayAuthCount.Value < 3)
                        {
                            throw new Exception("当前打款验证错误[" + payModel.PayAuthCount.ToString() + "]次");
                        }
                        else
                        {
                            authModel.Status = EnterpriseAuthStatus.RealNameError.ToString();
                            throw new Exception("打款验证次数超过3次，请重新提交企业实名认证");
                        }
                    }
                    finally
                    {
                        using (TransactionScope trans = new TransactionScope())
                        {
                            authDao.Insert(authModel);
                            payDao.Insert(payModel);

                            trans.Complete();
                        }
                    }
                }
            }
        }
        #endregion

        #region 文档保全
        public void FileDigestUpload(EviFileModel fileModel, RelateFileModel relateModel)
        {
            try
            {
                string eviNo = signHelper.FileDigestEvi(fileModel);
                _log.Info("存档编号：" + eviNo);

                relateModel.evid = eviNo;
                signHelper.RelateEvIdWithUser(relateModel);

                FileDigestEviUrlModel model = new FileDigestEviUrlModel();

                model.evid = eviNo;
                model.certificateNumber = "91310115607246787D";
                model.certificateType = CertificateType.CODE_USC;

                string fileEviUrl = signHelper.GetFileDigestEviUrl(model);
                _log.Info("文档保全查看路径：" + fileEviUrl);
            }
            catch (Exception ex)
            {
                _log.Error(ex.ToString());
            }
        }
        #endregion

        #region 签章日志
        public IList<FileVersion> QueryFileVersion(String applyId, String fileId = null)
        {
            using (FileVersionDao dao = new FileVersionDao())
            {
                Hashtable table = new Hashtable();
                table.Add("ApplyId", applyId);
                table.Add("FileId", fileId);

                return dao.QueryFileVersionByFilter(table);
            }
        }
        #endregion

        #region 企业实名认证（实名认证+企业注册+法人注册+企业制章+法人制章）
        public DataTable QueryEnterpriseRegister(EnterpriseRegisterVO vo)
        {
            using (EnterpriseAuthenticationDao dao = new EnterpriseAuthenticationDao())
            {
                Hashtable table = new Hashtable();

                ///关联经销商ID
                table.Add("DealerId", this.QueryEnterpriseMapping(vo.DealerId));
                ///原始经销商ID
                table.Add("ParentDealerId", vo.DealerId);

                return dao.QueryEnterpriseRegisterByFilter(table);
            }
        }

        public void EnterpriseRealNameRegister(EnterpriseRegisterVO vo)
        {
            #region 企业实名认证实体类

            EnterpriseAuthentication authModel = new EnterpriseAuthentication();

            authModel.Id = Guid.NewGuid();
            authModel.DmaId = new Guid(vo.DealerId);
            authModel.ParentDmaId = new Guid(vo.SubDealerId);
            authModel.AccountUid = vo.AccountUid;
            authModel.DealerName = vo.DealerName.Trim();
            authModel.Name = vo.OrganName.Trim();
            authModel.OrgCode = vo.EnterpriseResisterType == "0" ? vo.OrganCode.Trim() : null;
            authModel.UscCode = vo.EnterpriseResisterType == "1" ? vo.OrganCode.Trim() : null;
            authModel.RegCode = vo.EnterpriseResisterType == "2" ? vo.OrganCode.Trim() : null;
            authModel.LegalName = vo.LegalName.Trim();
            authModel.LegalIdNo = vo.LegalIdNo.Trim();
            authModel.LegalArea = vo.LegalArea;

            authModel.CardNo = vo.CardNo.Trim();
            authModel.Bank = vo.Bank.Trim();

            authModel.Status = EnterpriseAuthStatus.RealNameError.ToString();
            authModel.IsActive = 1;
            authModel.Remark1 = null;
            authModel.Remark2 = null;
            authModel.Remark3 = null;

            authModel.CreateDate = vo.CreateDate;
            authModel.CreateUser = vo.CreateUser;
            authModel.CreateUserName = vo.CreateUserName;
            authModel.UpdateDate = authModel.UpdateDate;
            authModel.UpdateUser = authModel.UpdateUser;
            authModel.UpdateUserName = authModel.UpdateUserName;

            #endregion

            #region 企业注册
            EnterpriseMaster em = new EnterpriseMaster();

            em.Id = Guid.NewGuid();
            em.DmaId = new Guid(vo.DealerId);
            em.ParentDmaId = new Guid(vo.SubDealerId);
            em.DealerName = vo.DealerName;
            em.AccountUid = vo.AccountUid;
            em.Phone = vo.Moblie;
            em.Email = vo.Email;
            em.Name = vo.OrganName;

            em.OrganType = vo.OrganType;
            em.RegType = vo.EnterpriseResisterType;
            em.OrganCode = vo.OrganCode;
            em.UserType = vo.UserType;

            em.LegalName = vo.LegalName;
            em.LegalIdNo = vo.LegalIdNo;
            em.LegalArea = vo.LegalArea;
            em.AgentName = vo.AgentName;
            em.AgentIdNo = vo.AgentIdNo;
            em.Address = null;
            em.Scope = null;
            em.Status = EnterpriseMasterStatus.NORMAL.ToString();
            em.CreateDate = vo.CreateDate;
            em.CreateUser = vo.CreateUser;
            em.CreateUserName = vo.CreateUserName;
            em.UpdateDate = em.CreateDate;
            em.UpdateUser = em.CreateUser;
            em.UpdateUserName = em.CreateUserName;
            #endregion

            #region 企业制章
            EnterpriseSeal es = new EnterpriseSeal();

            es.Id = Guid.NewGuid();
            es.EmId = new Guid(vo.DealerId);
            es.DmaId = new Guid(vo.DealerId);
            es.ParentDmaId = new Guid(vo.SubDealerId);
            es.DealerName = vo.DealerName;
            es.OrganName = vo.OrganName;
            es.AccountUid = vo.AccountUid;
            es.TemplateType = "STAR";
            es.Color = "RED";
            es.Htext = "电子专用章";
            es.Qtext = "";

            es.ImageUrl = "";
            es.IsActive = 1;

            es.CreateDate = vo.CreateDate;
            es.CreateUser = vo.CreateUser;
            es.CreateUserName = vo.CreateUserName;
            es.UpdateDate = es.CreateDate;
            es.UpdateUser = es.CreateUser;
            es.UpdateUserName = es.CreateUserName;
            #endregion

            #region 法人注册

            EnterpriseLegalMaster elm = new EnterpriseLegalMaster();

            elm.Id = Guid.NewGuid();
            elm.DmaId = new Guid(vo.DealerId);
            elm.ParentDmaId = new Guid(vo.SubDealerId);
            elm.DealerName = vo.DealerName;
            elm.AccountUid = vo.LegalAccountUid;
            elm.Name = vo.LegalName;
            elm.IdNo = vo.LegalIdNo;
            elm.PersonArea = vo.LegalArea;
            elm.Email = "";
            elm.Mobile = "";
            elm.Title = "";
            elm.Address = "";
            elm.Organ = vo.OrganName;
            elm.Status = EnterpriseMasterStatus.NORMAL.ToString();
            elm.CreateDate = vo.CreateDate;
            elm.CreateUser = vo.CreateUser;
            elm.CreateUserName = vo.CreateUserName;
            elm.UpdateDate = elm.CreateDate;
            elm.UpdateUser = elm.CreateUser;
            elm.UpdateUserName = elm.CreateUserName;

            #endregion

            #region 法人制章

            EnterpriseLegalSeal els = new EnterpriseLegalSeal();

            els.Id = Guid.NewGuid();
            els.ElmId = new Guid(vo.DealerId);
            els.DmaId = new Guid(vo.DealerId);
            els.ParentDmaId = new Guid(vo.SubDealerId);
            els.DealerName = vo.DealerName;
            els.LegalName = vo.LegalName;
            els.AccountUid = vo.LegalAccountUid;
            els.TemplateType = "RECTANGLE";
            els.Color = "RED";
            els.ImageUrl = "";
            els.IsActive = 1;
            els.CreateDate = vo.CreateDate;
            els.CreateUser = vo.CreateUser;
            els.CreateUserName = vo.CreateUserName;
            els.UpdateDate = els.CreateDate;
            els.UpdateUser = els.CreateUser;
            els.UpdateUserName = els.CreateUserName;

            #endregion

            try
            {
                #region 实名认证

                ///获取企业实名认证ServiceId
                authModel.ServiceId = signHelper.EnterpriseNameAuthentication(authModel);
                authModel.ToPayCount = 0;
                ///重置认证状态为"实名认证成功"
                authModel.Status = EnterpriseAuthStatus.RealNameSuccess.ToString();
                #endregion

                #region 企业注册

                try
                {
                    em.AccountUid = signHelper.AddOrganize(em);
                }
                catch (Exception ex0)
                {
                    ///企业注册失败
                    authModel.Status = EnterpriseAuthStatus.EnterpriseRegError.ToString();
                    em.Status = EnterpriseMasterStatus.ERROR.ToString();
                    throw ex0;
                }
                #endregion

                #region 企业制章

                try
                {
                    es.AccountUid = em.AccountUid;
                    es.Seal = signHelper.AddTemplateSeal(es);
                }
                catch (Exception ex1)
                {
                    ///企业制章失败
                    authModel.Status = EnterpriseAuthStatus.EnterpriseSealError.ToString();
                    es.IsActive = 2;//2代表Error
                    throw ex1;
                }
                #endregion

                #region 法人注册
                try
                {
                    elm.AccountUid = signHelper.AddPerson(elm);
                }
                catch (Exception ex2)
                {
                    ///企业注册失败
                    authModel.Status = EnterpriseAuthStatus.LegalRegError.ToString();
                    elm.Status = EnterpriseMasterStatus.ERROR.ToString();
                    throw ex2;
                }

                #endregion

                #region 法人制章
                try
                {
                    els.AccountUid = elm.AccountUid;
                    els.Seal = signHelper.AddPersonTemplateSeal(els);
                }
                catch (Exception ex3)
                {
                    ///企业制章失败
                    authModel.Status = EnterpriseAuthStatus.LegalSealError.ToString();
                    els.IsActive = 2;//2代表Error
                    throw ex3;
                }

                #endregion

                ///重置认证状态为"所有注册都已完成"
                authModel.Status = EnterpriseAuthStatus.Normal.ToString();
            }
            catch (Exception ex)
            {
                if (authModel.Status != EnterpriseAuthStatus.Normal.ToString())
                {
                    authModel.Remark1 = ex.Message;
                    authModel.ServiceId = null;
                }
                throw ex;
            }
            finally
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    EnterpriseAuthenticationDao authDao = new EnterpriseAuthenticationDao();
                    EnterpriseMasterDao eMasterDao = new EnterpriseMasterDao();
                    EnterpriseSealDao eSealDao = new EnterpriseSealDao();

                    EnterpriseLegalMasterDao lMasterDao = new EnterpriseLegalMasterDao();
                    EnterpriseLegalSealDao lSealDao = new EnterpriseLegalSealDao();

                    authDao.Insert(authModel);
                    eMasterDao.Insert(em);
                    eSealDao.Insert(es);
                    lMasterDao.Insert(elm);
                    lSealDao.Insert(els);

                    trans.Complete();
                }
            }

        }
        #endregion

        #region 私有方法
        public List<SealPostModel> GetSealPostModel(String userType, String fileType, String enterpriseSealData, String legalSealDate)
        {
            using (FileKeyWordDao dao = new FileKeyWordDao())
            {
                List<SealPostModel> sealList = new List<SealPostModel>();

                Hashtable table = new Hashtable();
                table.Add("UserType", userType);
                table.Add("FileType", fileType);

                IList<FileKeyWord> keyWorList = dao.QueryFileKeyWordByFilter(table);

                foreach (FileKeyWord key in keyWorList)
                {
                    ///SealType 1代表法人签章
                    ///SealType 0代表企业签章
                    if (key.SealType == "1")
                    {
                        sealList.Add(new SealPostModel()
                        {
                            sealType = key.SealType,
                            keyWord = key.KeyWord,
                            xPadding = float.Parse(key.Xpadding.ToString()),
                            yPadding = float.Parse(key.Ypadding.ToString()),
                            edgesYPosition = float.Parse(key.EdgesYPosition.ToString() == "" ? "0" : key.EdgesYPosition.ToString()),
                            sealData = legalSealDate
                        });
                    }
                    else if (key.SealType == "0")
                    {
                        sealList.Add(new SealPostModel()
                        {
                            sealType = key.SealType,
                            keyWord = key.KeyWord,
                            xPadding = float.Parse(key.Xpadding.ToString()),
                            yPadding = float.Parse(key.Ypadding.ToString()),
                            edgesYPosition = float.Parse(key.EdgesYPosition.ToString() == "" ? "0" : key.EdgesYPosition.ToString()),
                            sealData = enterpriseSealData
                        });
                    }

                }

                if (sealList.Count == 0)
                {
                    throw new Exception("电子签章关键字获取异常！");
                }

                return sealList;
            }
        }

        #endregion
    }
    public class ConvertPdtToImage
    {

        private String pdfFilePath;
        private String imageDirectoryPath;
        private SignatureHelper signHelper = new SignatureHelper();
        public ConvertPdtToImage(String srcPath, String dstPath)
        {
            pdfFilePath = srcPath;
            imageDirectoryPath = dstPath;
        }

        private static ILog _log = LogManager.GetLogger(typeof(ESignBLL));
        public void ToConvert()
        {
            signHelper.ConvertPDF2Image(pdfFilePath, imageDirectoryPath, 0, 0, null);
        }
    }
}
