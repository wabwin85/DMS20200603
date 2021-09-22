using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DMS.DataAccess;
using System.Collections;
using DMS.Model;
using System.Data;

namespace DMS.Business
{
    public class WeChatBaseBLL : IWeChatBaseBLL
    {
        #region 新功能建议
        public DataSet GetFunctionSuggest(Hashtable obj, int start, int limit, out int totalCount)
        {
            using (WechatfqaDao dao = new WechatfqaDao())
            {
                return dao.GetFunctionSuggest(obj, start, limit, out totalCount);
            }
        }

        public DataSet GetFunctionSuggest(Hashtable obj)
        {
            using (WechatfqaDao dao = new WechatfqaDao())
            {
                return dao.GetFunctionSuggest(obj);
            }
        }
        #endregion

        #region 常见问题维护
        public DataSet GetFQA(Hashtable obj, int start, int limit, out int totalCount)
        {
            using (WechatfqaDao dao = new WechatfqaDao())
            {
                return dao.GetFQA(obj, start, limit, out totalCount);
            }
        }

        public Wechatfqa GetFQAByFqaId(Guid fqaId)
        {
            using (WechatfqaDao dao = new WechatfqaDao())
            {
                return dao.GetFQAByFqaId(fqaId);
            }
        }

        public void InsertFQA(Wechatfqa faq)
        {
            using (WechatfqaDao dao = new WechatfqaDao())
            {
                dao.Insert(faq);
            }
        }

        public int UpdateFQA(Wechatfqa faq)
        {
            using (WechatfqaDao dao = new WechatfqaDao())
            {
                return dao.Update(faq);
            }
        }

        #endregion

        #region 微信登录维护
        public DataSet GetUser(Hashtable obj, int start, int limit, out int totalCount)
        {
            using (BusinessWechatUserDao dao = new BusinessWechatUserDao())
            {
                return dao.GetUser(obj, start, limit, out totalCount);
            }
        }

        public DataSet GetUser(Hashtable obj)
        {
            using (BusinessWechatUserDao dao = new BusinessWechatUserDao())
            {
                return dao.GetUser(obj);
            }
        }

        public BusinessWechatUser GetUserByUserId(Guid userId)
        {
            using (BusinessWechatUserDao dao = new BusinessWechatUserDao())
            {
                return dao.GetUserByUserId(userId);
            }
        }

        public DataSet SelectWechatUserByOpenId(string openId)
        {
            using (BusinessWechatUserDao dao = new BusinessWechatUserDao())
            {
                return dao.SelectWechatUserByOpenId(openId);
            }
        }
        public void InsertUser(BusinessWechatUser user)
        {
            using (BusinessWechatUserDao dao = new BusinessWechatUserDao())
            {
                dao.Insert(user);
            }
        }

        public void InsertUserProductLine(Hashtable obj)
        {
            using (BusinessWechatUserDao dao = new BusinessWechatUserDao())
            {
                dao.InsertUserProductLine(obj);
            }
        }


        public int UpdateUser(BusinessWechatUser user)
        {
            using (BusinessWechatUserDao dao = new BusinessWechatUserDao())
            {
                return dao.Update(user);
            }
        }

        public DataSet GetUserPosition(Hashtable obj)
        {
            using (BusinessWechatUserDao dao = new BusinessWechatUserDao())
            {
                return dao.GetUserPosition(obj);
            }
        }

        public int DeleteUser(string userId)
        {
            using (BusinessWechatUserDao dao = new BusinessWechatUserDao())
            {
                dao.Delete(new Guid(userId));

                return dao.DeleteUserProductLineId(new Guid(userId));
            }
        }

        public void UpdateUserStatus(BusinessWechatUser user)
        {
            using (BusinessWechatUserDao dao = new BusinessWechatUserDao())
            {
                dao.UpdateWechatUserStatus(user);

                dao.DeleteUserProductLineId(user.Id);
            }
        }
        #endregion

        #region 职位信息维护
        public DataSet GetPosition(Hashtable obj, int start, int limit, out int totalCount)
        {
            using (BusinessWechatUserDao dao = new BusinessWechatUserDao())
            {
                return dao.GetPosition(obj, start, limit, out totalCount);
            }
        }

        public DataSet GetPosition(Hashtable obj)
        {
            using (BusinessWechatUserDao dao = new BusinessWechatUserDao())
            {
                return dao.GetPosition(obj);
            }
        }

        public DataSet GetPositionByPositionKey(string key)
        {
            using (BusinessWechatUserDao dao = new BusinessWechatUserDao())
            {
                Hashtable obj = new Hashtable();
                obj.Add("PositKey", key);
                return dao.GetPositionByPositionKey(obj);
            }
        }

        public void InsertPosition(Hashtable Posit)
        {
            using (BusinessWechatUserDao dao = new BusinessWechatUserDao())
            {
                dao.InsertPosition(Posit);
            }
        }

        public int UpdatePosition(Hashtable Posit)
        {
            using (BusinessWechatUserDao dao = new BusinessWechatUserDao())
            {
                return dao.UpdatePosition(Posit);
            }
        }

        public int DeletePosition(string Key)
        {
            using (BusinessWechatUserDao dao = new BusinessWechatUserDao())
            {
                return dao.DeletePosition(Key);
            }
        }
        #endregion

        #region 职位权限维护
        public DataSet GetPositionPermits(Hashtable obj)
        {
            using (BusinessWechatUserDao dao = new BusinessWechatUserDao())
            {
                return dao.GetPositionPermits(obj);
            }
        }

        public int DeletePositionPermits(string PositKey)
        {
            using (BusinessWechatUserDao dao = new BusinessWechatUserDao())
            {
                return dao.DeletePositionPermits(PositKey);
            }
        }

        public void InsertPositionPermits(Hashtable Perm)
        {
            using (BusinessWechatUserDao dao = new BusinessWechatUserDao())
            {
                dao.InsertPositionPermits(Perm);
            }
        }
        #endregion

        #region 投诉建议维护
        public DataSet GetComplaintType(int type, string delFlag)
        {
            using (BusinessWechatUserDao dao = new BusinessWechatUserDao())
            {
                Hashtable obj = new Hashtable();
                obj.Add("Type", type);
                if (!delFlag.Equals(""))
                {
                    obj.Add("DeleteFlag", delFlag);
                }
                return dao.GetComplaintType(obj);
            }
        }

        public DataSet GetComplaintQuery(Hashtable obj)
        {
            using (BusinessWechatUserDao dao = new BusinessWechatUserDao())
            {
                return dao.GetComplaintQuery(obj);
            }
        }

        public DataSet GetComplaintQuery(Hashtable obj, int start, int limit, out int totalCount)
        {
            using (BusinessWechatUserDao dao = new BusinessWechatUserDao())
            {
                return dao.GetComplaintQuery(obj, start, limit, out totalCount);
            }
        }

        public int UpdateComplaint(Hashtable obj)
        {
            using (BusinessWechatUserDao dao = new BusinessWechatUserDao())
            {
                return dao.UpdateComplaint(obj);
            }
        }
        #endregion

        #region 30字新闻
        public DataSet GetDealerNews(Hashtable obj, int start, int limit, out int totalCount)
        {
            using (BusinessWechatUserDao dao = new BusinessWechatUserDao())
            {
                return dao.GetDealerNews(obj, start, limit, out totalCount);
            }
        }

        public DataSet GetDealerNews(Hashtable obj)
        {
            using (BusinessWechatUserDao dao = new BusinessWechatUserDao())
            {
                return dao.GetDealerNews(obj);
            }
        }
        #endregion

        #region DRM_Wechat接口

        #region 查询功能
        /// <summary>
        /// 获取经销商指标完成率
        /// </summary>
        /// <param name="DealerName"></param>
        /// <returns></returns>
        public DataSet GetDealerAchievingRate(string DealerId)
        {
            Hashtable obj = new Hashtable();
            obj.Add("DealerId", DealerId);

            using (BusinessWechatUserDao dao = new BusinessWechatUserDao())
            {
                return dao.GetDealerAchievingRate(obj);
            }
        }

        public DataSet GetDealerHospitalAchievingRate(string DealerId, string YearMonth)
        {
            Hashtable obj = new Hashtable();
            obj.Add("DealerId", DealerId);
            obj.Add("YearMonth", YearMonth);

            using (BusinessWechatUserDao dao = new BusinessWechatUserDao())
            {
                return dao.GetDealerHospitalAchievingRate(obj);
            }
        }

        /// <summary>
        /// 获取经销商数据上传及时性
        /// </summary>
        /// <param name="dealerId"></param>
        /// <param name="date"></param>
        /// <returns></returns>
        public DataSet GetUploadTimely(string dealerId)
        {
            Hashtable obj = new Hashtable();
            obj.Add("DealerId", dealerId);
            obj.Add("LastTime", dealerId);
            using (BusinessWechatUserDao dao = new BusinessWechatUserDao())
            {
                return dao.GetUploadTimely(obj);
            }
        }

        public DataSet GetProductInfor(string upn)
        {
            Hashtable obj = new Hashtable();
            obj.Add("UPN", upn);

            using (BusinessWechatUserDao dao = new BusinessWechatUserDao())
            {
                return dao.GetProductInfor(obj);
            }
        }

        /// <summary>
        /// 获取库存信息
        /// </summary>
        /// <param name="dealerId"></param>
        /// <param name="date"></param>
        /// <returns></returns>
        public DataSet GetLPInventory(string dealerId, string upn)
        {
            Hashtable obj = new Hashtable();
            obj.Add("DealerId", dealerId);
            obj.Add("UPN", upn);

            DataSet reDs = new DataSet();
            using (BusinessWechatUserDao dao = new BusinessWechatUserDao())
            {
                DataTable dtDealer = dao.GetDealerType(obj).Tables[0];
                if (dtDealer.Rows.Count > 0)
                {
                    if (dtDealer.Rows[0]["DMA_DealerType"].ToString().Equals("T2"))
                    {
                        reDs = dao.GetLPInventory(obj);
                    }
                    else
                    {
                        reDs = dao.GetT1Inventory(obj);
                    }
                }
                return reDs;
            }
        }
        #endregion

        #region 同步数据
        /// <summary>
        /// 微信用户信息
        /// </summary>
        /// <returns></returns>
        public DataSet GetUserInformation()
        {
            using (BusinessWechatUserDao dao = new BusinessWechatUserDao())
            {
                return dao.GetUserInformation();
            }
        }

        /// <summary>
        /// 更新微信用户OpenId
        /// </summary>
        /// <returns></returns>
        public int UpdateWechatUserOpenId(string UserId, string OpenId, string BindDate, string NickName)
        {
            using (BusinessWechatUserDao dao = new BusinessWechatUserDao())
            {
                return dao.UpdateWechatUserOpenId(UserId, OpenId, BindDate, NickName);
            }
        }

        /// <summary>
        /// 获取用户所属产品线
        /// </summary>
        /// <returns></returns>
        public DataSet GetUserProduct()
        {
            using (BusinessWechatUserDao dao = new BusinessWechatUserDao())
            {
                return dao.GetUserProduct();
            }
        }


        /// <summary>
        /// 微信用户权限
        /// </summary>
        /// <returns></returns>
        public DataSet GetUserPermissions()
        {
            using (BusinessWechatUserDao dao = new BusinessWechatUserDao())
            {
                return dao.GetUserPermissions();
            }
        }

        /// <summary>
        /// 常见问题同步
        /// </summary>
        /// <returns></returns>
        public DataSet GetFQAList()
        {
            using (WechatfqaDao dao = new WechatfqaDao())
            {
                return dao.GetFQAList();
            }
        }

        /// <summary>
        /// 常见问题附件同步
        /// </summary>
        /// <returns></returns>
        public DataSet GetFQAAnnexList()
        {
            using (WechatfqaDao dao = new WechatfqaDao())
            {
                return dao.GetFQAAnnexList();
            }
        }

        /// <summary>
        /// 投诉建议回复
        /// </summary>
        /// <returns></returns>
        public DataSet GetQuestionList()
        {
            using (BusinessWechatUserDao dao = new BusinessWechatUserDao())
            {
                return dao.GetQuestionList();
            }
        }

        public void UpdateQuestionDmsToWc()
        {
            using (BusinessWechatUserDao dao = new BusinessWechatUserDao())
            {
                dao.UpdateQuestionDmsToWc();
            }
        }


        public void InsertQuestionWcToDms(string Id, string WdtId, string WupId, string Title, string Body, string CreateDate, string UserID, string Status, out string rtnVal, out string rtnMsg)
        {
            using (BusinessWechatUserDao dao = new BusinessWechatUserDao())
            {
                dao.InsertQuestionWcToDms(Id, WdtId, WupId, Title, Body, CreateDate, UserID, Status, out rtnVal, out rtnMsg);
            }
        }

        public void InsertDealerNews(string Id, string ProductLineID, string Tital, string Body, string UserId, string CreateDate)
        {
            using (BusinessWechatUserDao dao = new BusinessWechatUserDao())
            {
                dao.InsertDealerNews(Id, ProductLineID, Tital, Body, UserId, CreateDate);
            }
        }

        public void InsertDealerNewsAnnex(string Id, string MainId, string Name, string Url, string Type, string UploadUser, string UploadDate)
        {
            using (BusinessWechatUserDao dao = new BusinessWechatUserDao())
            {
                dao.InsertDealerNewsAnnex(Id, MainId, Name, Url, Type, UploadUser, UploadDate);
            }
        }

        public void InsertFunctionSuggest(string Id, string Body, string CreateUserId, string CreateDate, string Sny_Status)
        {
            using (BusinessWechatUserDao dao = new BusinessWechatUserDao())
            {
                dao.InsertFunctionSuggest(Id, Body, CreateUserId, CreateDate, Sny_Status);
            }
        }

        public void DeleteDealerNews()
        {
            using (BusinessWechatUserDao dao = new BusinessWechatUserDao())
            {
                dao.DeleteDealerNews();
            }
        }

        public void DeleteDealerNewsAnnex()
        {
            using (BusinessWechatUserDao dao = new BusinessWechatUserDao())
            {
                dao.DeleteDealerNewsAnnex();
            }
        }
        #endregion

        #endregion

        #region
        public DataSet QuerySelectGiftsByFilter(Hashtable table, int start, int limit, out int totalRowCount)
        {
            using (IntegralExchangeDao dao = new IntegralExchangeDao())
            {
                return dao.QuerySelectGiftsByFilter(table, start, limit, out totalRowCount);
            }
        }

        public DataSet GetGiftByMainId(string number, int start, int limit, out int totalCount)
        {
            using (IntegralExchangeDao dao = new IntegralExchangeDao())
            {
                return dao.GetGiftByMainId(number, start, limit, out totalCount);
            }
        }

        public void UpdateRedeemGiftStatus(string[] Documentnumber)
        {
            Hashtable param = new Hashtable();
            param.Add("Documentnumber", Documentnumber);
            using (IntegralExchangeDao dao = new IntegralExchangeDao())
            {
                dao.UpdateRedeemGiftStatus(param);
            }
        }
        public void UpdateRejectStatus(string[] Documentnumber)
        {
            Hashtable param = new Hashtable();
            param.Add("Documentnumber", Documentnumber);
            using (IntegralExchangeDao dao = new IntegralExchangeDao())
            {
                dao.UpdateRejectStatus(param);
            }
        }

        /// <summary>
        /// 礼品兑换信息
        /// </summary>
        public DataSet GetAllIntegralExchange()
        {
            using (IntegralExchangeDao dao = new IntegralExchangeDao())
            {
                return dao.GetAllIntegralExchange();
            }
        }

        /// <summary>
        /// 已审批的礼品兑换信息
        /// </summary>
        public DataSet GetAllApprovedIntegralExchange()
        {
            using (IntegralExchangeDao dao = new IntegralExchangeDao())
            {
                return dao.GetAllApprovedIntegralExchange();
            }
        }

        public void InsertIntegralExchangeToDms(string txtId, string txtUserId, string txtStatus,
            string txtGiftId, string txtExchangenumber, string txtDocumentnumber, string txtDeliverNumber,
            string txtReturnIntegral, string txtTypes, string txtData, string txtGiftName)
        {
            using (IntegralExchangeDao dao = new IntegralExchangeDao())
            {
                dao.InsertIntegralExchangeToDms(txtId, txtUserId, txtStatus, txtGiftId,
                        txtExchangenumber, txtDocumentnumber, txtDeliverNumber, txtReturnIntegral, txtTypes, txtData, txtGiftName);
            }
        }

        public DataSet ExportUsageInfo(Hashtable table)
        {
            using (WechatOperatLogDao dao = new WechatOperatLogDao())
            {
                return dao.ExportUsageInfo(table);

            }
        }

        public DataSet ExportRegisterInfo()
        {
            using (WechatOperatLogDao dao = new WechatOperatLogDao())
            {
                return dao.ExportRegisterInfo();

            }
        }


        public void DeleteAllWechatOperatLog()
        {
            using (WechatOperatLogDao dao = new WechatOperatLogDao())
            {
                dao.DeleteAllWechatOperatLog();
            }
        }

        /// <summary>
        /// 同步微信日志记录到DMS
        /// </summary>
        /// <param name="Id"></param>
        /// <param name="BwuId"></param>
        /// <param name="OperatTime"></param>
        /// <param name="OperatMenu"></param>
        /// <param name="Rv1"></param>
        public void InsertWechatLog(string Id, string BwuId, string OperatTime, string OperatMenu, string Rv1)
        {
            using (WechatOperatLogDao dao = new WechatOperatLogDao())
            {
                dao.InsertWechatLog(Id, BwuId, OperatTime, OperatMenu, Rv1);
            }
        }
        #endregion

        #region 微信二维码上传

        public string GetWechatQRCodeHeaderNo(string DealerId, string UserId)
        {
            using (BusinessWechatUserDao businessWechatUserDao = new BusinessWechatUserDao())
            {
                return businessWechatUserDao.GetWechatQRCodeHeaderNo(DealerId, UserId);
            }
        }

        public DataSet SelectWechatQRCodeHeader(string DealerId, string HeaderNo, string KeyWord = "")
        {
            using (BusinessWechatUserDao businessWechatUserDao = new BusinessWechatUserDao())
            {
                return businessWechatUserDao.SelectWechatQRCodeHeader(DealerId, HeaderNo, KeyWord);
            }
        }
        public DataSet SelectWechatQRCodeDetail(string HeaderId, string DetailId = "")
        {
            using (BusinessWechatUserDao businessWechatUserDao = new BusinessWechatUserDao())
            {
                return businessWechatUserDao.SelectWechatQRCodeDetail(HeaderId, DetailId);
            }
        }

        public void InsertWechatQRCodeDetail(string QRCode, string HeaderId, string UserId, out Guid DetailId, out bool IsSuccess, out string Message)
        {
            using (BusinessWechatUserDao businessWechatUserDao = new BusinessWechatUserDao())
            {
                businessWechatUserDao.InsertWechatQRCodeDetail(QRCode, HeaderId, UserId, out DetailId,
                    out IsSuccess, out Message);
            }
        }

        public bool DeleteWechatQRCodeDetail(string DetailId)
        {
            using (BusinessWechatUserDao businessWechatUserDao = new BusinessWechatUserDao())
            {
                return businessWechatUserDao.DeleteWechatQRCodeDetail(DetailId);
            }
        }
        public bool FakeDeleteWechatQRCodeDetail(string DetailId, string UserId)
        {
            using (BusinessWechatUserDao businessWechatUserDao = new BusinessWechatUserDao())
            {
                return businessWechatUserDao.FakeDeleteWechatQRCodeDetail(DetailId, UserId);
            }
        }

        public bool UpdateWechatQRCodeInfo(string HeaderId, string DMSResult, bool DMSStatus, string Remark)
        {
            using (BusinessWechatUserDao businessWechatUserDao = new BusinessWechatUserDao())
            {
                return businessWechatUserDao.UpdateWechatQRCodeInfo(HeaderId, DMSResult, DMSStatus, Remark);
            }
        }

        public DataSet ExportWechatQRCodeInfo(string DealerId, string HeaderId)
        {
            using (BusinessWechatUserDao businessWechatUserDao = new BusinessWechatUserDao())
            {
                return businessWechatUserDao.ExportWechatQRCodeInfo(DealerId, HeaderId);
            }
        }

        public bool FakeDeleteWechatQRCodeHeader(string HeaderId, string UserId)
        {
            using (BusinessWechatUserDao businessWechatUserDao = new BusinessWechatUserDao())
            {
                return businessWechatUserDao.FakeDeleteWechatQRCodeHeader(HeaderId, UserId);
            }
        }
        
        public bool BindWechatUser(string UserName, string OpenId)
        {
            using (BusinessWechatUserDao businessWechatUserDao = new BusinessWechatUserDao())
            {
                return businessWechatUserDao.BindWechatUser(UserName, OpenId);
            }
        }

        public bool UnbindWechatUser(string OpenId)
        {
            using (BusinessWechatUserDao businessWechatUserDao = new BusinessWechatUserDao())
            {
                return businessWechatUserDao.UnbindWechatUser(OpenId);
            }
        }

        #endregion 微信二维码上传
    }
}
