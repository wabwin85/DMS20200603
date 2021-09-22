using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using DMS.DataAccess;
using System.Collections;
using DMS.Model;

namespace DMS.Business.DealerTrain
{
    public class CommandoUserBLL
    {
        #region 销售维护

        public DataSet GetDealerSalesList(String dealerName, String salesName, int start, int limit, out int totalCount)
        {
            using (DealerSalesDao dao = new DealerSalesDao())
            {
                Hashtable condition = new Hashtable();
                if (!string.IsNullOrEmpty(dealerName))
                {
                    condition.Add("DealerName", dealerName);
                }
                if (!string.IsNullOrEmpty(salesName))
                {
                    condition.Add("SalesName", salesName);
                }
                return dao.SelectDealerSalesList(condition, start, limit, out totalCount);
            }
        }

        public DataSet GetRemainWechatUserList(String dealerName, String salesName, int start, int limit, out int totalCount)
        {
            using (DealerSalesDao dao = new DealerSalesDao())
            {
                Hashtable condition = new Hashtable();
                if (!string.IsNullOrEmpty(dealerName))
                {
                    condition.Add("DealerName", dealerName);
                }
                if (!string.IsNullOrEmpty(salesName))
                {
                    condition.Add("SalesName", salesName);
                }
                return dao.SelectRemainWechatUserList(condition, start, limit, out totalCount);
            }
        }

        public void AddDealerSalesInfo(DealerSales dealerSales)
        {
            using (DealerSalesDao dao = new DealerSalesDao())
            {
                dao.Insert(dealerSales);
            }
        }

        public void RemoveDealerSalesInfo(Guid dealerSalesId)
        {
            using (DealerSalesDao dao = new DealerSalesDao())
            {
                dao.Delete(dealerSalesId);
            }
        }

        #endregion

        #region 波科用户维护

        public DataSet GetBscUserList(String userName, String userType, int start, int limit, out int totalCount)
        {
            using (BscUserDao dao = new BscUserDao())
            {
                Hashtable condition = new Hashtable();
                if (!string.IsNullOrEmpty(userName))
                {
                    condition.Add("UserName", userName);
                }
                if (!string.IsNullOrEmpty(userType))
                {
                    condition.Add("UserType", userType);
                }
                return dao.SelectBscUserList(condition, start, limit, out totalCount);
            }
        }

        public DataSet GetBscUserAllList(String userName, String userType)
        {
            using (BscUserDao dao = new BscUserDao())
            {
                Hashtable condition = new Hashtable();
                if (!string.IsNullOrEmpty(userName))
                {
                    condition.Add("UserName", userName);
                }
                if (!string.IsNullOrEmpty(userType))
                {
                    condition.Add("UserType", userType);
                }
                return dao.SelectBscUserAllList(condition);
            }
        }

        public Hashtable GetBscUserInfo(String bscUserId)
        {
            using (BscUserDao dao = new BscUserDao())
            {
                return dao.SelectBscUserInfo(bscUserId);
            }
        }

        public void AddBscUserInfo(BscUser bscUser)
        {
            using (BscUserDao dao = new BscUserDao())
            {
                dao.Insert(bscUser);
            }
        }

        public void ModifyBscUserInfo(BscUser bscUser)
        {
            using (BscUserDao dao = new BscUserDao())
            {
                dao.Update(bscUser);
            }
        }

        public void RemoveBscUserInfo(Guid bscUserId)
        {
            using (BscUserDao dao = new BscUserDao())
            {
                dao.Delete(bscUserId);
            }
        }

        public DataSet GetTeacherDealerList(String bscUserId, int start, int limit, out int totalCount)
        {
            using (TeacherDealerRelationDao dao = new TeacherDealerRelationDao())
            {
                return dao.SelectTeacherDealerList(bscUserId, start, limit, out totalCount);
            }
        }

        public DataSet GetRemainTeacherDealerList(String bscUserId, String dealerName, int start, int limit, out int totalCount)
        {
            using (TeacherDealerRelationDao dao = new TeacherDealerRelationDao())
            {
                Hashtable condition = new Hashtable();
                condition.Add("BscUserId", bscUserId);
                if (!string.IsNullOrEmpty(dealerName))
                {
                    condition.Add("DealerName", dealerName);
                }
                return dao.SelectRemainTeacherDealerList(condition, start, limit, out totalCount);
            }
        }

        public void AddTeacherDealer(String bscUserId, String[] dealerList)
        {
            TeacherDealerRelationDao teacherDealerRelationDao = new TeacherDealerRelationDao();

            foreach (String dealerId in dealerList)
            {
                TeacherDealerRelation sr = new TeacherDealerRelation();
                sr.BscUserId = new Guid(bscUserId);
                sr.DealerId = new Guid(dealerId);

                teacherDealerRelationDao.Insert(sr);
            }
        }

        public void RemoveTeacherDealer(String bscUserId, String dealerId)
        {
            TeacherDealerRelationDao teacherDealerRelationDao = new TeacherDealerRelationDao();

            TeacherDealerRelation sr = new TeacherDealerRelation();
            sr.BscUserId = new Guid(bscUserId);
            sr.DealerId = new Guid(dealerId);

            teacherDealerRelationDao.Delete(sr);
        }

        public void RemoveAllTeacherDealer(String bscUserId)
        {
            TeacherDealerRelationDao teacherDealerRelationDao = new TeacherDealerRelationDao();

            teacherDealerRelationDao.DeleteTeacherDealerRelationByBscUserId(bscUserId);
        }

        #endregion

        #region 发送验证码

        public void SendMail(string Verifi, string MailAddress)
        {
            IMessageBLL _messageBLL = new MessageBLL();

            MailMessageTemplate mailMessage = _messageBLL.GetMailMessageTemplate("EMAL_DRM_WECHART_VERIFI");

            MailMessageQueue mail = new MailMessageQueue();
            mail.Id = Guid.NewGuid();
            mail.QueueNo = "email";
            mail.From = "";
            mail.To = MailAddress;
            mail.Subject = mailMessage.Subject;
            mail.Body = mailMessage.Body.Replace("{#VERIFI}", Verifi);
            mail.Status = "Waiting";
            mail.CreateDate = DateTime.Now;
            _messageBLL.AddToMailMessageQueue(mail);
        }

        public void SendMassage(string Verifi, string massageTo)
        {
            IMessageBLL _messageBLL = new MessageBLL();

            ShortMessageQueue massage = new ShortMessageQueue();
            massage.Id = Guid.NewGuid();
            massage.QueueNo = "sms";
            massage.To = massageTo;
            massage.Message = "您的BSC微信验证码为：" + Verifi + "   请在微信中输入：“手机号”+“空格”+“验证码” ，进行账号绑定【无需输入“+”号  例如：13800000000 2161】";
            massage.Status = "Waiting";
            massage.CreateDate = DateTime.Now;
            _messageBLL.AddToShortMessageQueue(massage);
        }

        #endregion
    }
}
