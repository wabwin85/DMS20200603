using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Collections;
using DMS.Model;

namespace DMS.Business
{
    public interface IWeChatBaseBLL
    {
        #region 新功能建议
        DataSet GetFunctionSuggest(Hashtable obj, int start, int limit, out int totalCount);
        DataSet GetFunctionSuggest(Hashtable obj);
        #endregion

        #region 常见问题维护

        DataSet GetFQA(Hashtable obj, int start, int limit, out int totalCount);

        Wechatfqa GetFQAByFqaId(Guid fqaId);

        void InsertFQA(Wechatfqa faq);

        int UpdateFQA(Wechatfqa faq);

        #endregion

        #region 微信登录维护
        DataSet GetUser(Hashtable obj, int start, int limit, out int totalCount);

        DataSet GetUser(Hashtable obj);

        BusinessWechatUser GetUserByUserId(Guid userId);

        void InsertUser(BusinessWechatUser user);

        void InsertUserProductLine(Hashtable obj);

        int UpdateUser(BusinessWechatUser user);

        DataSet GetUserPosition(Hashtable obj);

        int DeleteUser(string userId);

        void UpdateUserStatus(BusinessWechatUser user);
        #endregion

        #region 投诉建议
        DataSet GetComplaintType(int type,string delFlag);
        DataSet GetComplaintQuery(Hashtable obj);
        DataSet GetComplaintQuery(Hashtable obj, int start, int limit, out int totalCount);
        int UpdateComplaint(Hashtable obj);
        #endregion
        
        #region 30字新闻
        DataSet GetDealerNews(Hashtable obj, int start, int limit, out int totalCount);
        DataSet GetDealerNews(Hashtable obj);
        #endregion

        #region 职位信息维护
        DataSet GetPosition(Hashtable obj, int start, int limit, out int totalCount);

        DataSet GetPosition(Hashtable obj);

        DataSet GetPositionByPositionKey(string key);

        void InsertPosition(Hashtable Posit);

        int UpdatePosition(Hashtable Posit);

        int DeletePosition(string Key);
        #endregion

        #region 职位权限维护

        DataSet GetPositionPermits(Hashtable obj);

        int DeletePositionPermits(string PositKey);

        void InsertPositionPermits(Hashtable Perm);
        #endregion

        #region DRM_Wechat接口
        DataSet GetDealerAchievingRate(string DealerName);

        DataSet GetUploadTimely(string dealerId);

        DataSet GetLPInventory(string dealerId, string upn);

        #region 同步数据
        DataSet GetUserInformation();

        DataSet GetUserProduct();

        DataSet GetUserPermissions();

        DataSet GetFQAList();

        DataSet GetFQAAnnexList();

        DataSet GetQuestionList();

        void UpdateQuestionDmsToWc();

        void InsertQuestionWcToDms(string Id, string WdtId, string WupId, string Title, string Body, string CreateDate, string UserID, string Status, out string rtnVal, out string rtnMsg);

        void InsertDealerNews(string Id, string ProductLineID, string Tital, string Body, string UserId, string CreateDate);

        void InsertDealerNewsAnnex(string Id, string MainId, string Name, string Url, string Type, string UploadUser, string UploadDate);

        void InsertFunctionSuggest(string Id, string Body, string CreateUserId, string CreateDate, string Sny_Status);

        void DeleteDealerNews();

        void DeleteDealerNewsAnnex();

        #endregion
        #endregion

        DataSet QuerySelectGiftsByFilter(Hashtable table, int start, int limit, out int totalRowCount);
        DataSet GetGiftByMainId(string number, int start,int limit, out int totalCount);
        void UpdateRedeemGiftStatus(string[] items);

        void UpdateRejectStatus(string[] p);
    }
}
