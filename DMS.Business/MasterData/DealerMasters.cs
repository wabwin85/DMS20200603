using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Business
{
    using Coolite.Ext.Web;
    using Grapecity.DataAccess.Transaction;
    using Lafite.RoleModel.Security;
    using DMS.DataAccess;
    using DMS.Model;
    using DMS.Common;
    using DMS.Model.Data;
    using Lafite.RoleModel.Security.Authorization;
    using Grapecity.Logging.CallHandlers;

    using System.Data;
    using System.Collections;
    using DataAccess.DataInterface;
    using EKPWorkflow;
    using Model.EKPWorkflow;

    /// <summary>
    /// DealerMaster 经销商信息维护

    /// </summary>
    public class DealerMasters : IDealerMasters
    {
        public const string Action_DealerMasters = "DealerInfo";

        private IRoleModelContext _context = RoleModelContext.Current;
        private IAttachmentBLL _attachBll = new AttachmentBLL();
        private IMessageBLL _messageBLL = new MessageBLL();
        private MailDeliveryAddressDao mailAddressDao = new MailDeliveryAddressDao();
        private kmReviewWebserviceBLL ekpBll = new kmReviewWebserviceBLL();
        public DealerMasters()
        {

        }

        public DealerMaster GetDealerMaster(Guid dmaId)
        {
            using (DealerMasterDao dao = new DealerMasterDao())
            {
                return dao.GetObject(dmaId);
            }
        }

        /// <summary>
        /// Gets all dealers , by donson
        /// </summary>
        /// <returns></returns>
        public IList<DealerMaster> GetAll()
        {
            using (DealerMasterDao dao = new DealerMasterDao())
            {
                return dao.GetAll();
            }
        }

        [AuthenticateHandler(ActionName = Action_DealerMasters, Description = "经销商维护", Permissoin = PermissionType.Read)]
        public IList<DealerMaster> QueryForDealerMaster(DealerMaster dealermaster, int start, int limit, out int totalRowCount)
        {
            using (DealerMasterDao dao = new DealerMasterDao())
            {
                return dao.SelectByFilter(dealermaster, start, limit, out totalRowCount);
            }
        }

        public IList<DealerMaster> QueryForDealerMaster(DealerMaster dealermaster)
        {
            using (DealerMasterDao dao = new DealerMasterDao())
            {
                return dao.SelectByFilter(dealermaster);
            }
        }

        public IList<DealerMaster> QueryForDealerMasterByAllUser(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            using (DealerMasterDao dao = new DealerMasterDao())
            {
                return dao.QueryForDealerMasterByAllUser(obj, start, limit, out totalRowCount);
            }
        }

        public DataSet QueryForDealerMaster(Hashtable param, int start, int limit, out int totalRowCount)
        {
            using (DealerMasterDao dao = new DealerMasterDao())
            {
                return dao.QueryForDealerMaster(param, start, limit, out totalRowCount);
            }
        }

        public DataTable QueryForDealerProfileMaster(Hashtable param, int start, int limit, out int totalRowCount)
        {
            param.Add("PageStart", start);
            param.Add("PageLimit", limit);

            param.Add("OwnerIdentityType", this._context.User.IdentityType);
            param.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            param.Add("OwnerId", new Guid(this._context.User.Id));
            using (DealerMasterDao dao = new DealerMasterDao())
            {
                DataSet ds = dao.QueryForDealerProfileMaster(param);

                totalRowCount = Convert.ToInt32(ds.Tables[0].Rows[0]["CNT"].ToString());
                return ds.Tables[1];
            }
        }



        #region CUID functions
        /// <summary>
        /// 新增
        /// </summary>
        /// <param name="hospital"></param>
        /// <returns></returns>
        [AuthenticateHandler(ActionName = Action_DealerMasters, Description = "经销商维护", Permissoin = PermissionType.Write)]
        public bool Insert(DealerMaster dealermaster)
        {
            bool result = false;
            using (DealerMasterDao dao = new DealerMasterDao())
            {
                dealermaster.LastUpdateDate = DateTime.Now;
                dealermaster.LastUpdateUser = new Guid(_context.User.Id);

                dealermaster.CreateDate = dealermaster.LastUpdateDate;
                dealermaster.CreateUser = dealermaster.LastUpdateUser;

                dao.InsertNew(dealermaster);
                result = true;
            }
            return result;
        }

        /// <summary>
        /// 修改
        /// </summary>
        /// <param name="hospital"></param>
        /// <returns></returns>
        [AuthenticateHandler(ActionName = Action_DealerMasters, Description = "经销商维护", Permissoin = PermissionType.Write)]
        public bool Update(DealerMaster dealermaster)
        {
            bool result = false;
            using (DealerMasterDao dao = new DealerMasterDao())
            {
                dealermaster.LastUpdateDate = DateTime.Now;
                dealermaster.LastUpdateUser = new Guid(_context.User.Id);

                int afterRow = dao.UpdateNew(dealermaster);
                result = true;
            }
            return result;
        }

        /// <summary>
        /// 逻辑删除
        /// </summary>
        /// <param name="hospitalId"></param>
        /// <returns></returns>
        [AuthenticateHandler(ActionName = Action_DealerMasters, Description = "经销商维护", Permissoin = PermissionType.Delete)]
        public bool FakeDelete(DealerMaster dealermaster)
        {
            bool result = false;
            using (DealerMasterDao dao = new DealerMasterDao())
            {
                //DealerMaster dealermaster = new DealerMaster();
                //dealermaster.Id = dealermasterId;
                dealermaster.DeletedFlag = true;

                dealermaster.LastUpdateDate = DateTime.Now;
                dealermaster.LastUpdateUser = new Guid(_context.User.Id);


                int afterRow = dao.FakeDelete(dealermaster);
                result = true;
            }
            return result;
        }

        /// <summary>
        /// 删除
        /// </summary>
        /// <param name="hospitalId"></param>
        /// <returns></returns>
        [AuthenticateHandler(ActionName = Action_DealerMasters, Description = "经销商维护", Permissoin = PermissionType.Delete)]
        public bool Delete(DealerMaster dealermaster)
        {
            bool result = false;

            using (DealerMasterDao dao = new DealerMasterDao())
            {
                int afterRow = dao.Delete(dealermaster);
            }
            return result;
        }
        /// <summary>
        /// SaveChanges, 把所有改变保存到数据库中 Todo
        /// </summary>
        /// <param name="data"></param>
        /// <returns></returns>
        [AuthenticateHandler(ActionName = Action_DealerMasters, Description = "经销商维护", Permissoin = PermissionType.Write)]
        [LogInfoHandler(Order = 1, EventId = ActionsDefine.EventId_Dealer, Title = "经销商信息维护", Message = "经销商信息维护新增、修改、删除", Categories = new string[] { Data.DMSLogging.MasterDataCategory })]
        public bool SaveChanges(ChangeRecords<DealerMaster> data)
        {
            bool result = false;

            int num = 0;


            using (TransactionScope trans = new TransactionScope())
            {
                foreach (DealerMaster dealermaster in data.Deleted)
                {
                    this.FakeDelete(dealermaster);
                }

                foreach (DealerMaster dealermaster in data.Updated)
                {
                    //if (dealermaster.SapCode == this.GetDealerMaster(dealermaster.Id.Value).SapCode)
                    //{
                    this.Update(dealermaster);
                    //}
                    //else
                    //{
                    //    num = this.GetSapCodeById(dealermaster.SapCode).Count;
                    //    if (num > 0)
                    //        throw new Exception("SAP账号重复");
                    //    else
                    //        this.Update(dealermaster);
                    //}
                }

                foreach (DealerMaster dealermaster in data.Created)
                {
                    //num = this.GetSapCodeById(dealermaster.SapCode).Count;
                    //if(num>0) 
                    //    throw new Exception("SAP账号重复");
                    //else
                    this.Insert(dealermaster);
                }

                trans.Complete();

                result = true;
            }

            return result;
        }
        #endregion

        /// <summary>
        /// Gets the dealers by sales.
        /// </summary>
        /// <param name="userId">The user id.</param>
        /// <param name="productLines">The product lines.</param>
        /// <returns></returns>
        public IList<Guid> GetDealersBySales(string userId, Guid[] productLines)
        {
            using (DealerMasterDao dao = new DealerMasterDao())
            {
                return dao.GetDealersBySales(userId, productLines);
            }
        }


        public IList<DealerMaster> QueryDealerMasterForTransferByDealerFromId(Guid DealerFromId)
        {
            using (DealerMasterDao dao = new DealerMasterDao())
            {
                return dao.SelectDealerMasterForTransferByDealerFromId(DealerFromId);
            }
        }

        public DataSet GetProductLineByDealer(Guid DealerId)
        {
            using (DealerMasterDao dao = new DealerMasterDao())
            {
                return dao.SelectProductLineByDealerId(DealerId);
            }
        }

        public DataSet GetHospitalForDealerByFilter(Hashtable param)
        {
            using (DealerMasterDao dao = new DealerMasterDao())
            {
                return dao.SelectHospitalForDealerByFilter(param);
            }
        }

        public DataSet GetProductLineById(Guid ProductId)
        {
            using (DealerMasterDao dao = new DealerMasterDao())
            {
                return dao.SelectProductLineById(ProductId);
            }
        }

        public DataSet GetHospitalById(Guid Hospital)
        {
            using (DealerMasterDao dao = new DealerMasterDao())
            {
                return dao.SelectHospitalById(Hospital);
            }
        }

        public IList<DealerMaster> GetSapCodeById(string sapCode)
        {
            using (DealerMasterDao dao = new DealerMasterDao())
            {
                return dao.SelectSapCodeById(sapCode);
            }
        }

        public IList<DealerMaster> SelectByFilter(DealerMaster obj)
        {
            using (DealerMasterDao dao = new DealerMasterDao())
            {
                return dao.SelectByFilter(obj);
            }
        }

        public IList<DealerMaster> SelectSameLevelDealer(Guid DealerId)
        {
            using (DealerMasterDao dao = new DealerMasterDao())
            {
                return dao.SelectSameLevelDealer(DealerId);
            }
        }

        public IList<LpDistributorData> QueryLPDistributorInfo(string batchNbr)
        {
            using (DealerMasterDao dao = new DealerMasterDao())
            {
                return dao.QueryLPDistributorInfo(batchNbr);
            }
        }

        public DataSet P_GetCRMDealer()
        {
            using (DealerMasterDao dao = new DealerMasterDao())
            {
                return dao.P_GetCRMDealer();
            }
        }

        public DataSet P_GetDealerProductionPrice(string CustomerID)
        {

            Hashtable ht = new Hashtable();
            BaseService.AddCommonFilterCondition(ht);
            using (DealerMasterDao dao = new DealerMasterDao())
            {
                return dao.P_GetDealerProductionPrice(CustomerID, Convert.ToString(ht["SubCompanyId"]), Convert.ToString(ht["BrandId"]));
            }
        }

        public DataSet P_GetCRMDealerHospital()
        {
            using (DealerMasterDao dao = new DealerMasterDao())
            {
                return dao.P_GetCRMDealerHospital();
            }
        }

        public IList<DealerMaster> SelectHospitalForDealerByFilterNew(Hashtable param, int start, int limit, out int totalCount)
        {
            using (DealerMasterDao dao = new DealerMasterDao())
            {
                return dao.SelectHospitalForDealerByFilterNew(param, start, limit, out totalCount);
            }
        }

        /// <summary>
        /// 查询所有医院，销售医院Store
        /// </summary>
        /// <param name="param"></param>
        /// <returns></returns>
        public DataSet GetHospitalForDealer()
        {
            using (DealerMasterDao dao = new DealerMasterDao())
            {
                return dao.SelectHospitalForDealer();
            }
        }

        public DataSet GetParentDealer(Guid dealerId)
        {
            using (DealerMasterDao dao = new DealerMasterDao())
            {
                return dao.SelectParentDealer(dealerId);
            }
        }

        public DataSet ExportDealerMaster(Guid dealerId)
        {
            using (DealerMasterDao dao = new DealerMasterDao())
            {
                return dao.ExportDealerMaster(dealerId);
            }
        }

        public DataSet GetDealerProductLine(Guid dealerId)
        {
            using (DealerAuthorizationDao dao = new DealerAuthorizationDao())
            {
                return dao.GetDealerProductLine(dealerId);
            }
        }

        public DataSet ExportDealerAuthorization(Hashtable obj)
        {
            using (DealerAuthorizationDao dao = new DealerAuthorizationDao())
            {
                return dao.ExportDealerAuthorization(obj);
            }
        }

        public DataSet SelectHospitalForDealerByShipmentDate(Hashtable param)
        {
            using (DealerMasterDao dao = new DealerMasterDao())
            {
                return dao.SelectHospitalForDealerByShipmentDate(param);
            }
        }

        public DataSet GetDealerContract(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            using (DealerMasterDao dao = new DealerMasterDao())
            {
                return dao.GetDealerContract(obj, start, limit, out totalRowCount);
            }
        }

        public DataSet GetDealerContract(Hashtable obj)
        {
            using (DealerMasterDao dao = new DealerMasterDao())
            {
                return dao.GetDealerContract(obj);
            }
        }

        public int UpdateDealerContractThirdParty(Hashtable obj)
        {
            using (DealerMasterDao dao = new DealerMasterDao())
            {
                return dao.UpdateDealerContractThirdParty(obj);
            }
        }

        public int UpdateDealerBaseContact(DealerMaster obj)
        {
            using (DealerMasterDao dao = new DealerMasterDao())
            {
                return dao.UpdateDealerBaseContact(obj);
            }
        }

        public DataSet GetThirdPartSignature(Hashtable obj)
        {
            using (DealerMasterDao dao = new DealerMasterDao())
            {
                return dao.GetThirdPartSignature(obj);
            }
        }

        public int UpdateThirdPartSignature(Hashtable obj)
        {
            using (DealerMasterDao dao = new DealerMasterDao())
            {
                return dao.UpdateThirdPartSignature(obj);
            }
        }

        public DataSet GetDealerMassageByAccount(string userName)
        {
            Hashtable obj = new Hashtable();
            obj.Add("UserName", userName);
            using (DealerMasterDao dao = new DealerMasterDao())
            {
                return dao.GetDealerMassageByAccount(obj);
            }
        }

        public bool GetHomePageMessage(Hashtable obj)
        {
            using (DealerMasterDao dao = new DealerMasterDao())
            {
                DataTable dtCheck = dao.GetHomePageMessage(obj).Tables[0];
                if (dtCheck.Rows.Count > 0)
                {
                    return false;
                }
                else
                {
                    dao.InsertHomePageMessage(obj);
                    return true;
                }
            }
        }

        public DataSet GetExcelDealerMasterByAllUser(Hashtable obj)
        {
            using (DealerMasterDao dao = new DealerMasterDao())
            {
                return dao.GetExcelDealerMasterByAllUser(obj);

            }
        }

        //Add By SongWeiming on 2015-09-15 For GSP Project
        public DealerMasterLicense QueryDealerMasterLicenseByDealerId(Guid dealerId)
        {
            using (DealerMasterLicenseDao dao = new DealerMasterLicenseDao())
            {
                return dao.GetObject(dealerId);
            }
        }
        public DataSet GetDealerMasterLicenseToTable(string dealerId)
        {
            using (DealerMasterLicenseDao dao = new DealerMasterLicenseDao())
            {
                return dao.GetDealerMasterLicenseToTable(dealerId);
            }
        }

        public DataSet GetDealerLicenseCatagoryByCatId(string strCatId, string catType,string versionNumber)
        {
            Hashtable obj = new Hashtable();
            obj.Add("strCatId", strCatId);
            obj.Add("catType", catType);
            obj.Add("versionNumber", versionNumber);
            using (DealerMasterDao dao = new DealerMasterDao())
            {
                return dao.GetDealerLicenseCatagoryByCatId(obj);
            }
        }

        //根据经销商分类代码类别，获取产品分类信息
        public DataSet GetLicenseCatagoryByCatType(Hashtable obj)
        {
            using (DealerMasterDao dao = new DealerMasterDao())
            {
                return dao.GetLicenseCatagoryByCatType(obj);
            }
        }


        public bool SubmitLicenseApplication(DealerMasterLicense dml, string applyType)
        {
            //applyType 有两种类型：新增、更新

            bool result = false;

            using (TransactionScope trans = new TransactionScope())
            {
                DealerMasterLicenseDao dmlDao = new DealerMasterLicenseDao();
                PurchaseOrderBLL poBLL = new PurchaseOrderBLL();

                if (applyType.Equals("Insert"))
                {
                    dmlDao.Insert(dml);
                }
                else
                {
                    //需要更新NewApplyId
                    Guid newApplyId = Guid.NewGuid();
                    //更新附件
                    _attachBll.UpdateAttachmentMainID(dml.NewApplyid.Value, newApplyId, AttachmentType.DealerLicense.ToString());
                    dml.NewApplyid = newApplyId;
                    dmlDao.Update(dml);

                }

                #region 邮件通知QA人员

                //获取经销商名称
                DealerMaster dMaster = this.GetDealerMaster(dml.DmaId);

                //获取邮件模板
                MailMessageTemplate mailMessage = _messageBLL.GetMailMessageTemplate(MailMessageTemplateCode.EMAIL_DEALER_CFDALICENSE_MODIFICATION.ToString());

                //获取QA人员邮件地址
                MailDeliveryAddress mda = new MailDeliveryAddress();
                mda.MailType = "CFDALicenseMoidfy";
                mda.MailTo = "EAI";
                mda.ActiveFlag = true;
                mda.ProductLineid = Guid.Empty;
                IList<MailDeliveryAddress> mailList = mailAddressDao.SelectMailDeliveryAddressByCondition(mda);

                if (mailList != null && mailList.Count > 0 && dMaster != null)
                {

                    foreach (MailDeliveryAddress mailAddress in mailList)
                    {
                        MailMessageQueue mail = new MailMessageQueue();
                        mail.Id = Guid.NewGuid();
                        mail.QueueNo = "email";
                        mail.From = "";
                        mail.To = mailAddress.MailAddress;
                        mail.Subject = mailMessage.Subject.Replace("{#DealerName}", dMaster.ChineseName);
                        mail.Body = mailMessage.Body.Replace("{#DealerName}", dMaster.ChineseName).Replace("{#SubmitDate}", DateTime.Now.ToString("yyyy-M-d H:m:s"));
                        mail.Status = "Waiting";
                        mail.CreateDate = DateTime.Now;
                        _messageBLL.AddToMailMessageQueue(mail);
                    }
                }
                #endregion

                poBLL.InsertPurchaseOrderLog(dml.DmaId, new Guid(this._context.User.Id), PurchaseOrderOperationType.Submit, "提交经销商CFDA证照信息修改申请");
                result = true;

                trans.Complete();
            }
            return result;
        }

        public bool ApproveLicenseApplication(Guid dealerId, string remark)
        {
            //将新的证照信息更新为正式的证照信息
            //将新添加的附件作为正式的附件
            //更新单据状态为“审批通过”
            //记录日志
            bool result = false;

            using (TransactionScope trans = new TransactionScope())
            {
                DealerMasterLicenseDao dmlDao = new DealerMasterLicenseDao();
                PurchaseOrderBLL poBLL = new PurchaseOrderBLL();
 				string IsValid = string.Empty;
                Hashtable ht = new Hashtable();
                ht.Add("DealerID", dealerId);
                //将新的证照信息更新为正式的证照信息
                int updCnt = dmlDao.approveLicenseApplication(dealerId, new Guid(this._context.User.Id), DealerLicenseUpdateStatus.审批通过.ToString(), remark);

                //将新添加的附件作为正式的附件
                int updCntAttach = _attachBll.UpdateAttachmentTempMainIDToDealerID(dealerId, AttachmentType.DealerLicense.ToString());

                poBLL.InsertPurchaseOrderLog(dealerId, new Guid(this._context.User.Id), PurchaseOrderOperationType.Approve, "审批通过经销商提交的CFDA证照信息修改申请，审批意见：" + remark);

                if (updCnt > 0 && IsValid == "Success")
                {
                    result = true;
                }

                trans.Complete();
            }
            return result;
        }

        public bool RejectLicenseApplication(Guid dealerId, string remark)
        {
            //更新单据状态为“审批拒绝”
            //记录日志

            bool result = false;

            using (TransactionScope trans = new TransactionScope())
            {
                DealerMasterLicenseDao dmlDao = new DealerMasterLicenseDao();
                PurchaseOrderBLL poBLL = new PurchaseOrderBLL();

                //将新的证照信息更新为正式的证照信息
                int updCnt = dmlDao.rejectLicenseApplication(dealerId, new Guid(this._context.User.Id), DealerLicenseUpdateStatus.审批拒绝.ToString(), remark);

                poBLL.InsertPurchaseOrderLog(dealerId, new Guid(this._context.User.Id), PurchaseOrderOperationType.Reject, "审批拒绝经销商提交的CFDA证照信息修改申请，审批意见：" + remark);

                if (updCnt > 0)
                {
                    result = true;
                }

                trans.Complete();
            }
            return result;
        }


        // 导出查询结果     
        public DataSet QueryDealerLicenseForExport(Hashtable table)
        {
            //获取当前登录身份类型以及所属组织

            table.Add("OwnerIdentityType", this._context.User.IdentityType);
            table.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            table.Add("OwnerId", new Guid(this._context.User.Id));

            using (DealerMasterLicenseDao dao = new DealerMasterLicenseDao())
            {
                return dao.SelectDealerLicenseForExport(table);
            }
        }
        //End Add By SongWeiming on 2015-09-15 For GSP Project
        //lijie add 2016-04-13
        public DataSet QueryDealerLicenseCfnForExport(Hashtable param)
        {
            using (DealerMasterLicenseDao dao = new DealerMasterLicenseDao())
            {
                return dao.SelectDealerLicenseCfnForExport(param);
            }
        }
        public DealerMaster SelectDealerMasterParentTypebyId(Guid Id)
        {
            using (DealerMasterDao dao = new DealerMasterDao())
            {
                return dao.SelectDealerMasterParentTypebyId(Id);
            }
        }

        //added by huyong on 2016-10-23 根据上报销量是否上传文件过滤产品线
        public DataSet GetNoLimitProductLineByDealer(Guid DealerId)
        {
            using (DealerMasterDao dao = new DealerMasterDao())
            {
                Hashtable ht = new Hashtable();
                ht.Add("DealerId", DealerId);
                BaseService.AddCommonFilterCondition(ht);
                return dao.GetNoLimitProductLineByDealer(ht);
            }
        }
        public DataSet GetNoLimitProductLineByDealerAll(Guid DealerId)
        {
            using (DealerMasterDao dao = new DealerMasterDao())
            {
                Hashtable ht = new Hashtable();
                return dao.GetNoLimitProductLineByDealerAll(ht);
            }
        }
        public DataSet GetDealerForLocalSeal(Hashtable ht)
        {
            using (DealerMasterDao dao = new DealerMasterDao())
            {
                return dao.GetDealerForLocalSeal(ht);
            }
        }

        public DataSet GetDealerMaster(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            using (DealerMasterDao dao = new DealerMasterDao())
            {
                return dao.GetDealerMaster(obj, start, limit, out totalRowCount);
            }
        }

        public bool UpdateDealerName(Hashtable obj,out string IsValid)
        {
            bool result = false;
            //调用存储过程验证数据
            using (DealerMasterDao dao = new DealerMasterDao())
            {
                IsValid = dao.UpdateDealerName(obj);
                result = true;
            }
            return result;
        }

        //added by huyong on 2017-10-23 根据经销商ID获取联系人信息
        public IList<Interfacet2ContactInfo> SelectT2ContactInfoByID(Guid Id, int start, int limit, out int totalCount)
        {
            using (Interfacet2ContactInfoDao dao = new Interfacet2ContactInfoDao())
            {
                return dao.SelectT2ContactInfoByID(Id, start, limit, out totalCount);
            }
        }

        public DataSet GetShiptoAddress(Guid NewApplyId)
        {
            using (DealerMasterLicenseDao dao = new DealerMasterLicenseDao())
            {
                return dao.GetShiptoAddress(NewApplyId);
            }
        }

        public void addaddress(Hashtable hs)
        {
            using (DealerMasterLicenseDao dao = new DealerMasterLicenseDao())
            {
                 dao.addaddress(hs);
            }
        }

        public DataSet GetAddress(Guid NewApplyId, int start, int limit, out int totalRowCount)
        {
            using (DealerMasterLicenseDao dao = new DealerMasterLicenseDao())
            {
                return dao.GetAddress(NewApplyId, start , limit, out totalRowCount);
            }
        }

        public void updateaddress(string id)
        {
            using (DealerMasterLicenseDao dao = new DealerMasterLicenseDao())
            {
                dao.updateaddress(id);
            }
        }

        public void updateshiptoaddress(Guid DealerId)
        {
            using (DealerMasterLicenseDao dao = new DealerMasterLicenseDao())
            {
                dao.updateshiptoaddress(DealerId);
            }
        }

        public void insertDealerMasterLicenseModify(Hashtable hs)
        {
            using (DealerMasterLicenseDao dao = new DealerMasterLicenseDao())
            {
                dao.insertDealerMasterLicenseModify(hs);
            }
        }

        public DataSet GetCFDAHead(Hashtable hs,int start, int limit, out int totalRowCount)
        {
            using (DealerMasterLicenseDao dao = new DealerMasterLicenseDao())
            {
                return dao.GetCFDAHead(hs,start, limit,out totalRowCount);
            }
        }

        public DataSet GetCFDAHeadAll(string DealerId, string ApplyStatus)
        {
            using (DealerMasterLicenseDao dao = new DealerMasterLicenseDao())
            {
                return dao.GetCFDAHeadAll(DealerId, ApplyStatus);
            }
        }
        public DataSet GetCFDAProcess(string MID)
        {
            using (DealerMasterLicenseDao dao = new DealerMasterLicenseDao())
            {
                return dao.GetCFDAProcess(MID);
            }
        }

        public void UpdateDealerMasterLicenseModify(Hashtable hs)
        {
            using (DealerMasterLicenseDao dao = new DealerMasterLicenseDao())
            {
                 dao.UpdateDealerMasterLicenseModify(hs);
            }
        }

        public string GetNextCFDANo(string clientid, string strSettings)
        {
            using (DealerMasterLicenseDao dao = new DealerMasterLicenseDao())
            {
                return dao.GetNextCFDANo( clientid,  strSettings);
            }
        }

        public void DeleteShipToAddress(Guid DML_MID)
        {
            using (DealerMasterLicenseDao dao = new DealerMasterLicenseDao())
            {
                dao.DeleteShipToAddress(DML_MID);
            }
        }

        public void DeleteAttachment(Guid DML_MID)
        {
            using (DealerMasterLicenseDao dao = new DealerMasterLicenseDao())
            {
                dao.DeleteAttachment(DML_MID);
            }
        }

        public void DeleteDealerMasterLicenseModify(Guid DML_MID)
        {
            using (DealerMasterLicenseDao dao = new DealerMasterLicenseDao())
            {
                dao.DeleteDealerMasterLicenseModify(DML_MID);
            }
        }

        public void insertShipToAddress(Guid DML_MID, Guid DealerId)
        {
            using (DealerMasterLicenseDao dao = new DealerMasterLicenseDao())
            {
                dao.insertShipToAddress(DML_MID, DealerId);
            }
        }

        public DataSet SelectSAPWarehouseAddress(Guid DealerId)
        {
            using (DealerMasterLicenseDao dao = new DealerMasterLicenseDao())
            {
               return  dao.SelectSAPWarehouseAddress(DealerId);
            }
        }

        public void updateshiptoaddressbtn(string ID, string IsSendAddress)
        {
            using (DealerMasterLicenseDao dao = new DealerMasterLicenseDao())
            {
                dao.updateshiptoaddressbtn(ID, IsSendAddress);
            }
        }

        public void DeleteSAPWarehouseAddress_temp(string id)
        {
            using (DealerMasterLicenseDao dao = new DealerMasterLicenseDao())
            {
                dao.DeleteSAPWarehouseAddress_temp(id);
            }
        }

        public DataSet SelectSAPWarehouseAddress_temp(Guid DML_MID)
        {
            using (DealerMasterLicenseDao dao = new DealerMasterLicenseDao())
            {
                return dao.SelectSAPWarehouseAddress_temp(DML_MID);
            }
        }

        public void SubmintCfdaMflow(string mdlId, string SubmintNo,string SalesRep)
        {
            string templateId = DictionaryHelper.GetDictionaryNameById("CONST_TemplateId", "DealerLicense");
            if (string.IsNullOrEmpty(templateId))
            {
                throw new Exception("OA流程ID未配置！");
            }
            //发起流程
            ekpBll.DoSubmit(SalesRep, mdlId, SubmintNo, "DealerLicense", string.Format("{0} 经销商CFDA证照维护", SubmintNo)
                , EkpModelId.DealerLicense.ToString(), EkpTemplateFormId.DealerLicenseTemplate.ToString(), templateId);
        }
        public DataSet GetSalesRepByParam(Hashtable Param)
        {
            using (DealerMasterLicenseDao dao = new DealerMasterLicenseDao())
            {
                return dao.GetSalesRepByParam(Param);
            }
        }
    }
}
