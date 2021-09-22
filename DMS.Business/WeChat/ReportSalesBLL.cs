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
    public class ReportSalesBLL : IReportSalesBLL
    {
        public static string WeChatMaxBindingCount = System.Configuration.ConfigurationManager.AppSettings["WeChatMaxBindingCount"];

        public string BindingWeChatByMobile(string mobile, string weChat)
        {
            using (HospitalReportUserDao dao = new HospitalReportUserDao())
            {
                string resultString = string.Empty;
                StringBuilder weChatList = new StringBuilder();
                Hashtable table = new Hashtable();
                table.Add("Phone", mobile);
                //table.Add("IsActive", "1");
                table.Add("IsDeleted", "0");
                IList<HospitalReportUser> list = dao.QueryByFilter(table);

                if (list.Count() == 0)
                {
                    return resultString = "您输入的手机号不存在，请重新输入！";
                }
                else if (list.Count() == 1)
                {
                    HospitalReportUser oldUser = list.First<HospitalReportUser>();

                    if (!string.IsNullOrEmpty(oldUser.WeChat) && oldUser.WeChat.Contains(weChat))
                    {
                        return resultString = "微信号已经与手机号绑定！";
                    }

                    //如果配置为0，则不控制绑定同一个手机微信号的数量限定
                    //目前只支持一个手机只能绑定一个微信号
                    //已经绑定了微信号
                    if (WeChatMaxBindingCount != "0" && !string.IsNullOrEmpty(oldUser.WeChat))
                    {
                        return resultString = "该手机号已经与其他的微信号绑定！";
                    }

                    //手机号没有绑定微信
                    if (string.IsNullOrEmpty(oldUser.WeChat))
                    {
                        //直接赋值
                        weChatList.Append(weChat);
                    }

                    HospitalReportUser user = new HospitalReportUser();
                    user.Phone = mobile;
                    //已经绑定微信号，则在原有的基础上附加微信号，用“;”分割
                    if (weChatList.Length == 0)
                    {
                        weChatList.Append(oldUser.WeChat);
                        weChatList.Append(";");
                        weChatList.Append(weChat);
                    }
                    user.WeChat = weChatList.ToString();

                    int i = dao.BindingWeChatByMobile(user);
                    if (i > 0)
                    {
                        return resultString = "绑定成功！";
                    }
                }
                return resultString = "存在多个这一手机号！";
            }
        }

        public bool HashBindingWeChat(string weChat)
        {
            using (HospitalReportUserDao dao = new HospitalReportUserDao())
            {
                bool result = false;
                Hashtable table = new Hashtable();
                table.Add("WeChat", weChat);
                //table.Add("IsActive", "1");
                table.Add("IsDeleted", "0");
                IList<HospitalReportUser> list = dao.QueryByFilter(table);

                if (list.Count() > 0)
                {
                    HospitalReportUser user = list.First<HospitalReportUser>();
                    result = true;
                }
                return result;
            }
        }

        public HospitalReportUser GetReportUserInfoByWeChat(string weChat)
        {
            using (HospitalReportUserDao dao = new HospitalReportUserDao())
            {
                Hashtable table = new Hashtable();
                table.Add("WeChat", weChat);
                //table.Add("IsActive", "1");
                table.Add("IsDeleted", "0");
                IList<HospitalReportUser> list = dao.QueryByFilter(table);

                if (list.Count() > 0)
                {
                    HospitalReportUser user = list.First<HospitalReportUser>();
                    return user;
                }
                return null;
            }
        }

        public DataSet GetCfnLevel1ByProductLine(Guid productLineId)
        {
            using (CfnWeChatDao dao = new CfnWeChatDao())
            {
                return dao.GetCfnLevel1ByProductLine(productLineId);
            }
        }

        public DataSet GetCfnLevel2ByProductLine(Guid productLineId)
        {
            using (CfnWeChatDao dao = new CfnWeChatDao())
            {
                return dao.GetCfnLevel2ByProductLine(productLineId);
            }
        }

        public DataSet GetCfnLevel2ByFilter(Hashtable table)
        {
            using (CfnWeChatDao dao = new CfnWeChatDao())
            {
                return dao.GetCfnLevel2ByFilter(table);
            }
        }

        public int CheckCfn(string upn,string lotNumber,string weChatNumber)
        {
            int resultStr = 0;

            using (HospitalReportUserDao dao = new HospitalReportUserDao())
            {
                Hashtable table = new Hashtable();
                table.Add("CfnUPN", upn);
                table.Add("LotNumber", lotNumber);
                table.Add("WeChatNumber", weChatNumber);
                resultStr = dao.CheckProductInfo(table);

                return resultStr;
            }
        }

        public int CheckCfnWeChatBySpec(string level2Code, string spec, string expiredDate, string weChatNumber,string reportType)
        {
            int resultStr = 0;

            using (HospitalReportUserDao dao = new HospitalReportUserDao())
            {
                Hashtable table = new Hashtable();
                table.Add("Level2Code", level2Code);
                table.Add("Spec", spec);
                table.Add("ExpiredDate", expiredDate);
                table.Add("ReportType", reportType);
                table.Add("WeChatNumber", weChatNumber);
                resultStr = dao.CheckCfnWeChatBySpec(table);

                return resultStr;
            }
        }

        public DataSet GetCountByFilter(string weChatNumber)
        {
            using (ReportSalesDao dao = new ReportSalesDao())
            {
                return dao.GetCountByFilter(weChatNumber);
            }
        }

        public DataSet QueryHospitalReportUserByFilter(string hospId)
        {
            Hashtable table = new Hashtable();

            table.Add("HospitalId", hospId);

            using (HospitalReportUserDao dao = new HospitalReportUserDao())
            {
                return dao.QueryHospitalReportUserByFilter(table);
            }

        }

        public bool CheckUserPhoneExist(string id, string phone)
        {
            Hashtable table = new Hashtable();
            table.Add("Id", id);
            table.Add("Phone", phone);

            using (HospitalReportUserDao dao = new HospitalReportUserDao())
            {
                IList<HospitalReportUser> list = dao.CheckUserPhoneExist(table);
                if (list.Count() > 0)
                    return true;

                return false;
            }
        }

        public void UpdateHospitalReportUserByFilter(HospitalReportUser user)
        {
            using (HospitalReportUserDao dao = new HospitalReportUserDao())
            {
                dao.UpdateHospitalReportUserByFilter(user);
            }
        }

        public HospitalReportUser getHospitalReportUserById(Guid id)
        { 
            using (HospitalReportUserDao dao = new HospitalReportUserDao())
            {
                return dao.GetObject(id);
            }
        }

        public void SaveUser(HospitalReportUser user)
        {
            using (HospitalReportUserDao dao = new HospitalReportUserDao())
            {
                dao.Insert(user);
            }
        }

        public void DeleteUser(Guid id)
        {
            using (HospitalReportUserDao dao = new HospitalReportUserDao())
            {
                dao.Delete(id);
            }
        }
    }   
}
