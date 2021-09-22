
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : BusinessWechatUser
 * Created Time: 2014/5/30 17:26:03
 *
 ****** Copyright (C) 2009/2010 - GrapeCity*****
 *
***********************************************/

using System;
using System.Collections;
using System.Collections.Generic;
using IBatisNet.DataMapper;
using DMS.Model;
using System.Data;
using System.Linq;

namespace DMS.DataAccess
{
    /// <summary>
    /// BusinessWechatUser的Dao
    /// </summary>
    public class BusinessWechatUserDao : BaseSqlMapDao
    {

        /// <summary>
        /// 默认构造函数
        /// </summary>
        public BusinessWechatUserDao()
            : base()
        {
        }

        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public BusinessWechatUser GetObject(Guid objKey)
        {
            BusinessWechatUser obj = this.ExecuteQueryForObject<BusinessWechatUser>("SelectBusinessWechatUser", objKey);
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<BusinessWechatUser> GetAll()
        {
            IList<BusinessWechatUser> list = this.ExecuteQueryForList<BusinessWechatUser>("SelectBusinessWechatUser", null);
            return list;
        }


        /// <summary>
        /// 查询BusinessWechatUser
        /// </summary>
        /// <returns>返回BusinessWechatUser集合</returns>
        public IList<BusinessWechatUser> SelectByFilter(BusinessWechatUser obj)
        {
            IList<BusinessWechatUser> list = this.ExecuteQueryForList<BusinessWechatUser>("SelectByFilterBusinessWechatUser", obj);
            return list;
        }

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(BusinessWechatUser obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateBusinessWechatUser", obj);
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteBusinessWechatUser", objKey);
            return cnt;
        }

        public int UpdateWechatUserStatus(BusinessWechatUser obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateWechatUserStatus", obj);
            return cnt;
        }


        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(BusinessWechatUser obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteBusinessWechatUser", obj);
            return cnt;
        }

        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(BusinessWechatUser obj)
        {
            this.ExecuteInsert("InsertBusinessWechatUser", obj);
        }

        public void InsertUserProductLine(Hashtable obj)
        {
            this.ExecuteInsert("InsertUserProductLine", obj);
        }

        public DataSet GetUser(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectByBusinessWechatUser", obj, start, limit, out totalCount);
            return ds;
        }

        public DataSet GetUser(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectByBusinessWechatUser", obj);
            return ds;
        }

        public BusinessWechatUser GetUserByUserId(Guid id)
        {
            BusinessWechatUser obj = this.ExecuteQueryForObject<BusinessWechatUser>("SelectBusinessWechatUser", id);
            return obj;
        }

        public DataSet SelectWechatUserByOpenId(string openId)
        {
            Hashtable ht = new Hashtable { { "OpenId", openId } };
            return this.ExecuteQueryForDataSet("SelectWechatUserByWeChat", ht);
        }

        public DataSet GetUserPosition(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectUserPosition", obj);
            return ds;
        }

        public int DeleteUserProductLineId(Guid UserId)
        {
            int cnt = (int)this.ExecuteUpdate("DeleteUserProductLineId", UserId);
            return cnt;
        }

        #region 维护职位
        public DataSet GetPosition(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectPosition", obj, start, limit, out totalCount);
            return ds;
        }

        public DataSet GetPosition(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectPosition", obj);
            return ds;
        }

        public DataSet GetPositionByPositionKey(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectUserPosition", obj);
            return ds;
        }

        public void InsertPosition(Hashtable Posit)
        {
            this.ExecuteInsert("InsertPosition", Posit);
        }

        public int UpdatePosition(Hashtable Posit)
        {
            int cnt = (int)this.ExecuteUpdate("UpdatePosition", Posit);
            return cnt;
        }

        public int DeletePosition(string objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeletePosition", objKey);
            return cnt;
        }

        #endregion

        #region 维护职位权限
        public DataSet GetPositionPermits(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectPositionPermits", obj);
            return ds;
        }

        public int DeletePositionPermits(string PositKey)
        {
            int cnt = (int)this.ExecuteDelete("DeletePositionAccess", PositKey);
            return cnt;
        }

        public void InsertPositionPermits(Hashtable Perm)
        {
            this.ExecuteInsert("InsertPositionPermits", Perm);
        }
        #endregion

        #region 微信端查询功能
        public DataSet GetDealerAchievingRate(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectDealerAchievingRate", obj);
            return ds;
        }

        public DataSet GetDealerHospitalAchievingRate(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectDealerHospitalAchievingRate", obj);
            return ds;
        }

        public DataSet GetUploadTimely(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectUploadTimely", obj);
            return ds;
        }

        public DataSet GetProductInfor(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectProductInfor", obj);
            return ds;
        }

        public DataSet GetLPInventory(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectLPInventory", obj);
            return ds;
        }

        public DataSet GetT1Inventory(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectT1Inventory", obj);
            return ds;
        }

        public DataSet GetDealerType(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectDealerType", obj);
            return ds;
        }
        #endregion

        #region 投诉建议维护
        public DataSet GetComplaintType(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectComplaintType", obj);
            return ds;
        }

        public DataSet GetComplaintQuery(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectComplaintQuery", obj, start, limit, out totalCount);
            return ds;
        }

        public DataSet GetComplaintQuery(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectComplaintQuery", obj);
            return ds;
        }
        public int UpdateComplaint(Hashtable obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateComplaint", obj);
            return cnt;
        }

        #endregion

        #region 30字新闻
        public DataSet GetDealerNews(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectDealerNews", obj, start, limit, out totalCount);
            return ds;
        }

        public DataSet GetDealerNews(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectDealerNews", obj);
            return ds;
        }
        #endregion

        #region 微信端同步数据功能
        public DataSet GetUserInformation()
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectUserInformation", null);
            return ds;
        }

        public int UpdateWechatUserOpenId(string UserId, string OpenId, string BindDate, string NickName)
        {
            Hashtable obj = new Hashtable();
            obj.Add("BwuId", UserId);
            obj.Add("BwuWeChat", OpenId);
            obj.Add("BwuBindDate", BindDate);
            obj.Add("BWUNickName", NickName);
            int cnt = (int)this.ExecuteUpdate("UpdateWechatUserOpenId", obj);
            return cnt;
        }

        public DataSet GetUserProduct()
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectUserProduct", null);
            return ds;
        }

        public DataSet GetUserPermissions()
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectUserPermissions", null);
            return ds;
        }

        public DataSet GetQuestionList()
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectQuestionList", null);
            return ds;
        }


        public void UpdateQuestionDmsToWc()
        {
            try
            {
                this.ExecuteUpdate("UpdateQuestionDmsToWc", null);
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }


        public void InsertQuestionWcToDms(string Id, string WdtId, string WupId, string Title, string Body, string CreateDate, string UserID, string Status, out string rtnVal, out string rtnMsg)
        {
            rtnVal = string.Empty;
            rtnMsg = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("Id", Id);
            ht.Add("WdtId", WdtId);
            ht.Add("WupId", WupId);
            ht.Add("Title", Title);
            ht.Add("Body", Body);
            ht.Add("CreateDate", CreateDate);
            ht.Add("UserID", UserID);
            ht.Add("Status", Status);
            ht.Add("RtnVal", rtnVal);
            ht.Add("RtnMsg", rtnMsg);
            try
            {
                this.ExecuteInsert("GC_InsertWeChatComplaintWcToDms", ht);

                rtnVal = ht["RtnVal"].ToString();
                rtnMsg = ht["RtnMsg"].ToString();
            }
            catch (Exception ex)
            {
                throw ex;
            }


        }

        public void InsertDealerNews(string Id, string ProductLineID, string Tital, string Body, string UserId, string CreateDate)
        {
            Hashtable ht = new Hashtable();
            ht.Add("Id", Id);
            ht.Add("ProductLineID", ProductLineID);
            ht.Add("Tital", Tital);
            ht.Add("Body", Body);
            ht.Add("UserId", UserId);
            ht.Add("CreateDate", CreateDate);
            try
            {
                this.ExecuteInsert("InsertDealerNews", ht);

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void InsertDealerNewsAnnex(string Id, string MainId, string Name, string Url, string Type, string UploadUser, string UploadDate)
        {
            Hashtable ht = new Hashtable();
            ht.Add("Id", Id);
            ht.Add("MainId", MainId);
            ht.Add("Name", Name);
            ht.Add("Url", Url);
            ht.Add("Type", Type);
            ht.Add("UploadUser", UploadUser);
            ht.Add("UploadDate", UploadDate);
            try
            {
                this.ExecuteInsert("InsertDealerNewsAnnex", ht);

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void InsertFunctionSuggest(string Id, string Body, string CreateUserId, string CreateDate, string Sny_Status)
        {
            Hashtable ht = new Hashtable();
            ht.Add("Id", Id);
            ht.Add("Body", Body);
            ht.Add("CreateUserId", CreateUserId);
            ht.Add("CreateDate", CreateDate);
            ht.Add("Sny_Status", Sny_Status);
            try
            {
                this.ExecuteInsert("InsertFunctionSuggest", ht);

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public int DeleteDealerNews()
        {
            int cnt = (int)this.ExecuteDelete("DeleteDealerNews", null);
            return cnt;
        }

        public int DeleteDealerNewsAnnex()
        {
            int cnt = (int)this.ExecuteDelete("DeleteDealerNewsAnnex", null);
            return cnt;
        }
        #endregion


        #region 微信二维码上传

        public string GetWechatQRCodeHeaderNo(string DealerId, string UserId)
        {
            string strNo = string.Empty;
            Hashtable ht = new Hashtable();
            ht.Add("DealerId", DealerId);
            ht.Add("UserId", UserId);
            ht.Add("HeaderNo", strNo);
            base.ExecuteInsert("USP_GetWechatQRCodeHeaderNo", ht);
            strNo = ht["HeaderNo"].ToString();
            return strNo;
        }

        public DataSet SelectWechatQRCodeHeader(string DealerId, string HeaderNo, string KeyWord)
        {
            Hashtable ht = new Hashtable();
            ht.Add("DealerId", DealerId);
            if (!string.IsNullOrEmpty(HeaderNo))
            {
                ht.Add("HeaderNo", HeaderNo);
            }
            if (!string.IsNullOrEmpty(KeyWord))
            {
                ht.Add("KeyWord", KeyWord);
            }
            int totalCount;
            return base.ExecuteQueryForDataSet("SelectWechatQRCodeHeader", ht, 0, int.MaxValue, out totalCount);
        }

        public DataSet SelectWechatQRCodeDetail(string HeaderId, string DetailId)
        {
            Hashtable ht = new Hashtable();
            ht.Add("HeaderId", HeaderId);
            if (!string.IsNullOrEmpty(DetailId))
            {
                ht.Add("DetailId", DetailId);
            }
            int totalCount;
            return base.ExecuteQueryForDataSet("SelectWechatQRCodeDetail", ht, 0, int.MaxValue, out totalCount);
        }

        public void InsertWechatQRCodeDetail(string QRCode, string HeaderId, string UserId, out Guid DetailId, out bool IsSuccess, out string Message)
        {

            Hashtable ht = new Hashtable();
            ht.Add("QRCode", QRCode);
            ht.Add("HeaderId", HeaderId);
            ht.Add("UserId", UserId);
            ht.Add("DetailId", Guid.Empty);
            ht.Add("IsSuccess", false);
            ht.Add("Message", string.Empty);

            base.ExecuteInsert("USP_InsertWechatQRCodeDetail", ht);
            DetailId = null != ht["DetailId"] ? new Guid(ht["DetailId"].ToString()) : Guid.Empty;
            IsSuccess = bool.Parse(ht["IsSuccess"].ToString());
            Message = ht["Message"]?.ToString();
        }

        public bool DeleteWechatQRCodeDetail(string DetailId)
        {
            Hashtable ht = new Hashtable();
            ht.Add("DetailId", DetailId);
            int cnt = (int)this.ExecuteDelete("DeleteWechatQRCodeDetail", ht);
            return cnt > 0;
        }

        public bool FakeDeleteWechatQRCodeDetail(string DetailId,string UserId)
        {
            Hashtable ht = new Hashtable();
            ht.Add("DetailId", DetailId);
            ht.Add("UserId", UserId);
            int cnt = (int)this.ExecuteUpdate("FakeDeleteWechatQRCodeDetail", ht);
            return cnt > 0;
        }
        

        public bool UpdateWechatQRCodeInfo(string HeaderId, string DMSResult, bool DMSStatus,string Remark)
        {
            Hashtable ht = new Hashtable();
            ht.Add("HeaderId", HeaderId);
            ht.Add("DMSResult", DMSResult);
            ht.Add("DMSStatus", DMSStatus);
            ht.Add("Remark", Remark);
            int cnt = (int)this.ExecuteUpdate("UpdateWechatQRCodeInfo", ht);
            return cnt > 0;
        }
        public DataSet ExportWechatQRCodeInfo(string DealerId, string HeaderId)
        {
            Hashtable ht = new Hashtable();
            ht.Add("DealerId", DealerId);
            ht.Add("HeaderId", HeaderId);
            return base.ExecuteQueryForDataSet("ExportWechatQRCodeInfo", ht);
        }

        public bool FakeDeleteWechatQRCodeHeader(string HeaderId, string UserId)
        {
            Hashtable ht = new Hashtable();
            ht.Add("HeaderId", HeaderId);
            ht.Add("UserId", UserId);
            int cnt = (int)this.ExecuteUpdate("FakeDeleteWechatQRCodeHeader", ht);
            return cnt > 0;
        }

        public bool BindWechatUser(string UserName, string OpenId)
        {
            Hashtable ht = new Hashtable();
            ht.Add("UserName", UserName);
            ht.Add("OpenId", OpenId);
            int cnt = (int)this.ExecuteUpdate("BindWechatUser", ht);
            return cnt > 0;
        }

        public bool UnbindWechatUser(string OpenId)
        {
            Hashtable ht = new Hashtable();
            ht.Add("OpenId", OpenId);
            int cnt = (int)this.ExecuteUpdate("UnbindWechatUser", ht);
            return cnt > 0;
        }

        #endregion 微信二维码上传
    }
}