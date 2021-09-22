using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using DMS.DataService.Core;
using DMS.Business.MasterData;
using System.Web.Services.Protocols;
using DMS.Model;
using DMS.Business;
using System.Data;

namespace DMS.DataService
{
    /// <summary>
    /// zzcsc 的摘要说明
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // 若要允许使用 ASP.NET AJAX 从脚本中调用此 Web 服务，请取消对下行的注释。
    // [System.Web.Script.Services.ScriptService]
    public class zzcsc : System.Web.Services.WebService
    {

        public AuthHeader authHeader;
        private const string SAP_CLIENT_ID = "EAI";

        private void Authenticate()
        {
            IClientBLL business = new ClientBLL();
            Client client = business.GetClientById(authHeader.User);
            if (client == null)
                throw new SoapException("ClientID不存在", SoapException.ClientFaultCode);

            if (!client.ActiveFlag)
                throw new SoapException("ClientID已失效", SoapException.ClientFaultCode);

            if (client.DeletedFlag)
                throw new SoapException("ClientID已失效", SoapException.ClientFaultCode);

            if (!client.Password.Equals(authHeader.Password))
                throw new SoapException("密码错误", SoapException.ClientFaultCode);
        }

        /// <summary>
        /// 医院接口信息
        /// </summary>
        /// <param name="Uid"></param>
        /// <param name="Pwd"></param>
        /// <returns></returns>
        [WebMethod]
        public DataSet GetAllHospitals(string Uid, string Pwd)
        {
            authHeader = new AuthHeader();
            authHeader.User = Uid;
            authHeader.Password = Pwd;

            Authenticate();

            Hospitals bll = new Hospitals();

            return bll.GetAllHospitals();
        }


        /// <summary>
        /// 经销商接口信息
        /// </summary>
        /// <param name="Uid"></param>
        /// <param name="Pwd"></param>
        /// <returns></returns>
        [WebMethod]
        //[SoapHeader("authHeader")]
        public DataSet P_GetCRMDealer(string Uid, string Pwd)
        {
            authHeader = new AuthHeader();
            authHeader.User = Uid;
            authHeader.Password = Pwd;

            Authenticate();
            DealerMasters bll = new DealerMasters();

            return bll.P_GetCRMDealer();
        }


        /// <summary>
        /// 经销商对应产品价格
        /// </summary>
        /// <param name="Uid"></param>
        /// <param name="Pwd"></param>
        /// <returns></returns>
        [WebMethod]
        //[SoapHeader("authHeader")]
        public DataSet P_GetDealerProductionPrice(string Uid, string Pwd, string CustomerID)
        {
            authHeader = new AuthHeader();
            authHeader.User = Uid;
            authHeader.Password = Pwd;

            Authenticate();
            DealerMasters bll = new DealerMasters();

            return bll.P_GetDealerProductionPrice(CustomerID);
        }

        /// <summary>
        /// 经销商与医院对应信息接口
        /// </summary>
        /// <param name="Uid"></param>
        /// <param name="Pwd"></param>
        /// <returns></returns>
        [WebMethod]
        //[SoapHeader("authHeader")]
        public DataSet P_GetCRMDealerHospital(string Uid, string Pwd)
        {
            authHeader = new AuthHeader();
            authHeader.User = Uid;
            authHeader.Password = Pwd;

            Authenticate();
            DealerMasters bll = new DealerMasters();

            return bll.P_GetCRMDealerHospital();
        }

        /// <summary>
        /// 产品信息接口
        /// </summary>
        /// <param name="Uid"></param>
        /// <param name="Pwd"></param>
        /// <returns></returns>
        [WebMethod]
        //[SoapHeader("authHeader")]
        public DataSet P_GetAllCRMProduction(string Uid, string Pwd)
        {
            authHeader = new AuthHeader();
            authHeader.User = Uid;
            authHeader.Password = Pwd;

            Authenticate();
            Cfns bll = new Cfns();

            return bll.P_GetAllCRMProduction();
        }


        /// <summary>
        /// 产品使用量信息接口
        /// </summary>
        /// <param name="Uid"></param>
        /// <param name="Pwd"></param>
        /// <param name="Year"></param>
        /// <param name="Month"></param>
        /// <param name="DivisionID"></param>
        /// <returns></returns>
        [WebMethod]
        //[SoapHeader("authHeader")]
        public DataSet GetInHospitalSales(string Uid, string Pwd, int Year, int Month, int DivisionID)
        {
            authHeader = new AuthHeader();
            authHeader.User = Uid;
            authHeader.Password = Pwd;

            Authenticate();
            Hospitals bll = new Hospitals();

            return bll.GetInHospitalSales(Year, Month, DivisionID);
        }

        /// <summary>
        /// 医院销量接口
        /// </summary>
        /// <param name="Uid"></param>
        /// <param name="Pwd"></param>
        /// <param name="Year"></param>
        /// <param name="Month"></param>
        /// <param name="DivisionID"></param>
        /// <returns></returns>
        [WebMethod]
        //[SoapHeader("authHeader")]
        public string UploadHospitalSales(string Uid, string Pwd, string Upn, string Lot, string HosId, string SubUser, string Rv1, string Rv2, string Rv3)
        {
            string rtnVal = null;
            string rtnMsg = null;

            authHeader = new AuthHeader();
            authHeader.User = Uid;
            authHeader.Password = Pwd;

            Authenticate();
            Hospitals bll = new Hospitals();

            bll.UploadHospitalSales(Upn, Lot, HosId, SubUser, Rv1, Rv2, Rv3, out rtnVal, out rtnMsg);
            return rtnVal;
        }

        /// <summary>
        /// 同步CFN接口
        /// </summary>
        /// <param name="Uid"></param>
        /// <param name="Pwd"></param>
        /// <returns></returns>
        [WebMethod]
        //[SoapHeader("authHeader")]
        public DataSet GetCFNList(string Uid, string Pwd)
        {
            authHeader = new AuthHeader();
            authHeader.User = Uid;
            authHeader.Password = Pwd;

            Authenticate();
            Cfns bll = new Cfns();

            return bll.P_GetAllCFN();

        }

        /// <summary>
        /// 同步产品接口
        /// </summary>
        /// <param name="Uid"></param>
        /// <param name="Pwd"></param>
        /// <returns></returns>
        [WebMethod]
        //[SoapHeader("authHeader")]
        public DataSet GetProductList(string Uid, string Pwd)
        {
            authHeader = new AuthHeader();
            authHeader.User = Uid;
            authHeader.Password = Pwd;

            Authenticate();
            Cfns bll = new Cfns();

            return bll.P_GetAllProductList();

        }

        /// <summary>
        /// 同步LotMaster接口
        /// </summary>
        /// <param name="Uid"></param>
        /// <param name="Pwd"></param>
        /// <returns></returns>
        [WebMethod]
        //[SoapHeader("authHeader")]
        public DataSet GetLotMaster(string Uid, string Pwd)
        {
            authHeader = new AuthHeader();
            authHeader.User = Uid;
            authHeader.Password = Pwd;

            Authenticate();
            LotMasters bll = new LotMasters();

            string currentdate = DateTime.Now.Year.ToString() + DateTime.Now.Month.ToString() + DateTime.Now.Day.ToString("00");
            return bll.P_GetLotMaster(currentdate);

        }

        #region DRM Wechart
        /// <summary>
        /// 同步经销商达成率接口
        /// </summary>
        /// <param name="Uid"></param>
        /// <param name="Pwd"></param>
        /// <param name="DealerName"></param>
        /// <returns></returns>
        [WebMethod]
        //[SoapHeader("authHeader")]
        public DataSet GetDealerAchievingRate(string Uid, string Pwd, string DealerId)
        {
            authHeader = new AuthHeader();
            authHeader.User = Uid;
            authHeader.Password = Pwd;

            Authenticate();
            WeChatBaseBLL bll = new WeChatBaseBLL();

            return bll.GetDealerAchievingRate(DealerId);

        }

        /// <summary>
        /// 同步经销商医院达成率接口
        /// </summary>
        /// <param name="Uid"></param>
        /// <param name="Pwd"></param>
        /// <param name="DealerId"></param>
        /// <param name="YearMonth"></param>
        /// <returns></returns>
        [WebMethod]
        //[SoapHeader("authHeader")]
        public DataSet GetDealerHospitalAchievingRate(string Uid, string Pwd, string DealerId,string YearMonth)
        {
            authHeader = new AuthHeader();
            authHeader.User = Uid;
            authHeader.Password = Pwd;

            Authenticate();
            WeChatBaseBLL bll = new WeChatBaseBLL();

            return bll.GetDealerHospitalAchievingRate(DealerId, YearMonth);

        }


        /// <summary>
        /// 获取经销商数据上传及时性
        /// </summary>
        /// <param name="Uid"></param>
        /// <param name="Pwd"></param>
        /// <param name="DealerId"></param>
        /// <returns></returns>
        [WebMethod]
        //[SoapHeader("authHeader")]
        public DataSet GetUploadTimely(string Uid, string Pwd, string DealerId)
        {
            authHeader = new AuthHeader();
            authHeader.User = Uid;
            authHeader.Password = Pwd;

            Authenticate();
            WeChatBaseBLL bll = new WeChatBaseBLL();

            return bll.GetUploadTimely(DealerId);
        }

        /// <summary>
        /// 获取指定UPN产品
        /// </summary>
        /// <param name="Uid"></param>
        /// <param name="Pwd"></param>
        /// <param name="UPN"></param>
        /// <returns></returns>
        [WebMethod]
        //[SoapHeader("authHeader")]
        public DataSet GetProductInfor(string Uid, string Pwd, string UPN)
        {
            authHeader = new AuthHeader();
            authHeader.User = Uid;
            authHeader.Password = Pwd;

            Authenticate();
            WeChatBaseBLL bll = new WeChatBaseBLL();

            return bll.GetProductInfor(UPN);
        }


        /// <summary>
        /// 缺货查询
        /// </summary>
        /// <param name="Uid"></param>
        /// <param name="Pwd"></param>
        /// <param name="DealerId"></param>
        ///   /// <param name="UPN"></param>
        /// <returns></returns>
        [WebMethod]
        //[SoapHeader("authHeader")]
        public DataSet GetLPInventory(string Uid, string Pwd, string DealerId, string UPN)
        {
            authHeader = new AuthHeader();
            authHeader.User = Uid;
            authHeader.Password = Pwd;

            Authenticate();
            WeChatBaseBLL bll = new WeChatBaseBLL();

            return bll.GetLPInventory(DealerId, UPN);
        }


        /// <summary>
        /// 用户信息
        /// </summary>
        /// <param name="Uid"></param>
        /// <param name="Pwd"></param>
        /// <returns></returns>
        [WebMethod]
        //[SoapHeader("authHeader")]
        public DataSet GetUserInformation(string Uid, string Pwd)
        {
            authHeader = new AuthHeader();
            authHeader.User = Uid;
            authHeader.Password = Pwd;

            Authenticate();
            WeChatBaseBLL bll = new WeChatBaseBLL();

            return bll.GetUserInformation();
        }

        /// <summary>
        /// 更新微信用户OpenId
        /// </summary>
        /// <param name="Uid"></param>
        /// <param name="Pwd"></param>
        /// <returns></returns>
        [WebMethod]
        //[SoapHeader("authHeader")]
        public int UpdateWechatUserOpenId(string Uid, string Pwd, string UserId, string OpenId, string BindDate, string NickName)
        {
            authHeader = new AuthHeader();
            authHeader.User = Uid;
            authHeader.Password = Pwd;

            Authenticate();
            WeChatBaseBLL bll = new WeChatBaseBLL();

            return bll.UpdateWechatUserOpenId(UserId, OpenId, BindDate, NickName);
        }

        /// <summary>
        /// 用户所属产品线
        /// </summary>
        /// <param name="Uid"></param>
        /// <param name="Pwd"></param>
        /// <returns></returns>
        [WebMethod]
        //[SoapHeader("authHeader")]
        public DataSet GetUserProduct(string Uid, string Pwd)
        {
            authHeader = new AuthHeader();
            authHeader.User = Uid;
            authHeader.Password = Pwd;

            Authenticate();
            WeChatBaseBLL bll = new WeChatBaseBLL();

            return bll.GetUserProduct();
        }

        /// <summary>
        /// 用户权限
        /// </summary>
        /// <param name="Uid"></param>
        /// <param name="Pwd"></param>
        /// <returns></returns>
        [WebMethod]
        //[SoapHeader("authHeader")]
        public DataSet GetUserPermissions(string Uid, string Pwd)
        {
            authHeader = new AuthHeader();
            authHeader.User = Uid;
            authHeader.Password = Pwd;

            Authenticate();
            WeChatBaseBLL bll = new WeChatBaseBLL();

            return bll.GetUserPermissions();
        }

        /// <summary>
        /// 常见问题
        /// </summary>
        /// <param name="Uid"></param>
        /// <param name="Pwd"></param>
        /// <returns></returns>
        [WebMethod]
        //[SoapHeader("authHeader")]
        public DataSet GetFQAList(string Uid, string Pwd)
        {
            authHeader = new AuthHeader();
            authHeader.User = Uid;
            authHeader.Password = Pwd;

            Authenticate();
            WeChatBaseBLL bll = new WeChatBaseBLL();

            return bll.GetFQAList();
        }

        /// <summary>
        /// 常见问题附件
        /// </summary>
        /// <param name="Uid"></param>
        /// <param name="Pwd"></param>
        /// <returns></returns>
        [WebMethod]
        //[SoapHeader("authHeader")]
        public DataSet GetFQAAnnexList(string Uid, string Pwd)
        {
            authHeader = new AuthHeader();
            authHeader.User = Uid;
            authHeader.Password = Pwd;

            Authenticate();
            WeChatBaseBLL bll = new WeChatBaseBLL();

            return bll.GetFQAAnnexList();
        }

        /// <summary>
        /// 投诉建议回复
        /// </summary>
        /// <param name="Uid"></param>
        /// <param name="Pwd"></param>
        /// <returns></returns>
        [WebMethod]
        //[SoapHeader("authHeader")]
        public DataSet GetQuestionList(string Uid, string Pwd)
        {
            authHeader = new AuthHeader();
            authHeader.User = Uid;
            authHeader.Password = Pwd;

            Authenticate();
            WeChatBaseBLL bll = new WeChatBaseBLL();

            return bll.GetQuestionList();
        }

        /// <summary>
        /// 获取礼品兑换信息
        /// </summary>
        /// <param name="Uid"></param>
        /// <param name="Pwd"></param>
        /// <returns></returns>
        [WebMethod]
        //[SoapHeader("authHeader")]
        public DataSet GetAllIntegralExchange(string Uid, string Pwd)
        {
            authHeader = new AuthHeader();
            authHeader.User = Uid;
            authHeader.Password = Pwd;

            Authenticate();
            WeChatBaseBLL bll = new WeChatBaseBLL();

            return bll.GetAllIntegralExchange();
        }

        /// <summary>
        /// 获取已审批的礼品兑换信息
        /// </summary>
        /// <param name="Uid"></param>
        /// <param name="Pwd"></param>
        /// <returns></returns>
        [WebMethod]
        //[SoapHeader("authHeader")]
        public DataSet GetAllApprovedIntegralExchange(string Uid, string Pwd)
        {
            authHeader = new AuthHeader();
            authHeader.User = Uid;
            authHeader.Password = Pwd;

            Authenticate();
            WeChatBaseBLL bll = new WeChatBaseBLL();

            return bll.GetAllApprovedIntegralExchange();
        }

        /// <summary>
        /// 插入新的礼品兑换信息
        /// </summary>
        /// <param name="Uid"></param>
        /// <param name="Pwd"></param>
        /// <param name="txtId"></param>
        /// <param name="txtUserId"></param>
        /// <param name="txtStatus"></param>
        /// <param name="txtGiftId"></param>
        /// <param name="txtExchangenumber"></param>
        /// <param name="txtDocumentnumber"></param>
        /// <param name="txtDeliverNumber"></param>
        /// <param name="txtReturnIntegral"></param>
        /// <param name="txtTypes"></param>
        /// <param name="txtData"></param>
        /// <param name="txtGiftName"></param>
        /// <returns></returns>
        [WebMethod]
        //[SoapHeader("authHeader")]
        public void InsertIntegralExchangeToDms(string Uid, string Pwd, string txtId, string txtUserId, string txtStatus,
            string txtGiftId, string txtExchangenumber, string txtDocumentnumber, string txtDeliverNumber,
            string txtReturnIntegral, string txtTypes, string txtData, string txtGiftName)
        {
            //string rtnVal = null;
            //string rtnMsg = null;

            authHeader = new AuthHeader();
            authHeader.User = Uid;
            authHeader.Password = Pwd;

            Authenticate();
            WeChatBaseBLL bll = new WeChatBaseBLL();

            bll.InsertIntegralExchangeToDms(txtId, txtUserId, txtStatus, txtGiftId,
                        txtExchangenumber, txtDocumentnumber, txtDeliverNumber, txtReturnIntegral, txtTypes, txtData, txtGiftName);


        }
        /// <summary>
        /// 更改投诉建议同步状态
        /// </summary>
        /// <param name="Uid"></param>
        /// <param name="Pwd"></param>
        [WebMethod]
        //[SoapHeader("authHeader")]
        public void UpdateQuestionDmsToWc(string Uid, string Pwd)
        {
            authHeader = new AuthHeader();
            authHeader.User = Uid;
            authHeader.Password = Pwd;

            Authenticate();
            WeChatBaseBLL bll = new WeChatBaseBLL();

            bll.UpdateQuestionDmsToWc();

        }

        /// <summary>
        /// 同步经销商投诉信息
        /// </summary>
        /// <param name="Uid"></param>
        /// <param name="Pwd"></param>
        /// <param name="Id"></param>
        /// <param name="WdtId"></param>
        /// <param name="WupId"></param>
        /// <param name="Title"></param>
        /// <param name="Body"></param>
        /// <param name="CreateDate"></param>
        /// <param name="UserID"></param>
        /// <param name="Status"></param>
        /// <returns></returns>
        [WebMethod]
        //[SoapHeader("authHeader")]
        public string InsertQuestionWcToDms(string Uid, string Pwd, string Id, string WdtId, string WupId, string Title, string Body, string CreateDate, string UserID, string Status)
        {
            string rtnVal = null;
            string rtnMsg = null;

            authHeader = new AuthHeader();
            authHeader.User = Uid;
            authHeader.Password = Pwd;

            Authenticate();
            WeChatBaseBLL bll = new WeChatBaseBLL();

            bll.InsertQuestionWcToDms(Id, WdtId, WupId, Title, Body, CreateDate, UserID, Status, out rtnVal, out rtnMsg);

            return rtnVal;

        }

        /// <summary>
        /// 删除微消息
        /// </summary>
        /// <param name="Uid"></param>
        /// <param name="Pwd"></param>
        [WebMethod]
        //[SoapHeader("authHeader")]
        public void DeleteDealerNews(string Uid, string Pwd)
        {
            authHeader = new AuthHeader();
            authHeader.User = Uid;
            authHeader.Password = Pwd;

            Authenticate();
            WeChatBaseBLL bll = new WeChatBaseBLL();

            bll.DeleteDealerNews();

        }

        /// <summary>
        /// 删除微消息附件
        /// </summary>
        /// <param name="Uid"></param>
        /// <param name="Pwd"></param>
        [WebMethod]
        //[SoapHeader("authHeader")]
        public void DeleteDealerNewsAnnex(string Uid, string Pwd)
        {
            authHeader = new AuthHeader();
            authHeader.User = Uid;
            authHeader.Password = Pwd;

            Authenticate();
            WeChatBaseBLL bll = new WeChatBaseBLL();

            bll.DeleteDealerNewsAnnex();

        }

        /// <summary>
        /// 维护微消息
        /// </summary>
        /// <param name="Uid"></param>
        /// <param name="Pwd"></param>
        /// <param name="Id"></param>
        /// <param name="ProductLineID"></param>
        /// <param name="Tital"></param>
        /// <param name="Body"></param>
        /// <param name="UserId"></param>
        /// <param name="CreateDate"></param>
        [WebMethod]
        //[SoapHeader("authHeader")]
        public void InsertDealerNews(string Uid, string Pwd, string Id, string ProductLineID, string Tital, string Body, string UserId, string CreateDate)
        {
            authHeader = new AuthHeader();
            authHeader.User = Uid;
            authHeader.Password = Pwd;

            Authenticate();
            WeChatBaseBLL bll = new WeChatBaseBLL();

            bll.InsertDealerNews(Id, ProductLineID, Tital, Body, UserId, CreateDate);

        }

        /// <summary>
        /// 维护微消息附件
        /// </summary>
        /// <param name="Uid"></param>
        /// <param name="Pwd"></param>
        /// <param name="Id"></param>
        /// <param name="MainId"></param>
        /// <param name="Name"></param>
        /// <param name="Url"></param>
        /// <param name="Type"></param>
        /// <param name="UploadUser"></param>
        /// <param name="UploadDate"></param>
        [WebMethod]
        //[SoapHeader("authHeader")]
        public void InsertDealerNewsAnnex(string Uid, string Pwd, string Id, string MainId, string Name, string Url, string Type, string UploadUser, string UploadDate)
        {
            authHeader = new AuthHeader();
            authHeader.User = Uid;
            authHeader.Password = Pwd;

            Authenticate();
            WeChatBaseBLL bll = new WeChatBaseBLL();

            bll.InsertDealerNewsAnnex(Id, MainId, Name, Url, Type, UploadUser, UploadDate);

        }

        /// <summary>
        /// 维护新功能建议
        /// </summary>
        /// <param name="Uid"></param>
        /// <param name="Pwd"></param>
        /// <param name="Id"></param>
        /// <param name="Body"></param>
        /// <param name="CreateUserId"></param>
        /// <param name="CreateDate"></param>
        /// <param name="Sny_Status"></param>
        [WebMethod]
        //[SoapHeader("authHeader")]
        public void InsertFunctionSuggest(string Uid, string Pwd, string Id, string Body, string CreateUserId, string CreateDate, string Sny_Status)
        {
            authHeader = new AuthHeader();
            authHeader.User = Uid;
            authHeader.Password = Pwd;

            Authenticate();
            WeChatBaseBLL bll = new WeChatBaseBLL();

            bll.InsertFunctionSuggest(Id, Body, CreateUserId, CreateDate, Sny_Status);

        }

        /// <summary>
        /// 删除DMS中的微信操作日志
        /// </summary>
        /// <param name="Uid"></param>
        /// <param name="Pwd"></param>
        [WebMethod]
        public void DeleteAllWechatOperatLog(string Uid, string Pwd)
        {
            authHeader = new AuthHeader();
            authHeader.User = Uid;
            authHeader.Password = Pwd;

            Authenticate();
            WeChatBaseBLL bll = new WeChatBaseBLL();

            bll.DeleteAllWechatOperatLog();


        }

        /// <summary>
        /// 同步微信日志信息到DMS
        /// </summary>
        /// <param name="Uid"></param>
        /// <param name="Pwd"></param>
        /// <param name="Id"></param>
        /// <param name="?"></param>
        [WebMethod]
        public void InsertWechatLog(string Uid, string Pwd, string Id, string BwuId, string OperatTime, string OperatMenu, string Rv1)
        {
            authHeader = new AuthHeader();
            authHeader.User = Uid;
            authHeader.Password = Pwd;

            Authenticate();
            WeChatBaseBLL bll = new WeChatBaseBLL();

            bll.InsertWechatLog(Id, BwuId, OperatTime, OperatMenu, Rv1);


        }


      /// <summary>
      /// 发邮件
      /// </summary>
      /// <param name="Uid"></param>
      /// <param name="Pwd"></param>
      /// <param name="To">邮箱地址</param>
      /// <param name="Subject">主题</param>
      /// <param name="Body">正文</param>
      /// <param name="Status">状态</param>
        [WebMethod]
        public void SendMailMassage(string Uid, string Pwd, string To, string Subject, string Body)
        {
            authHeader = new AuthHeader();
            authHeader.User = Uid;
            authHeader.Password = Pwd;

            Authenticate();
            IMessageBLL bll = new MessageBLL();

            MailMessageQueue mail = new MailMessageQueue();
            mail.Id = Guid.NewGuid();
            mail.QueueNo = "email";
            mail.From = "";
            mail.To = To;
            mail.Subject = Subject;
            mail.Body = Body;
            mail.Status = "Waiting";
            mail.CreateDate = DateTime.Now;
            bll.AddToMailMessageQueue(mail);
        }
    }
           #endregion
}
