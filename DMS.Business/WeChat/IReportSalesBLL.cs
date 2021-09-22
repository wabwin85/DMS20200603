using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Collections;
using DMS.Model;

namespace DMS.Business
{
    public interface IReportSalesBLL
    {
        /// <summary>
        /// 手机号绑定微信号
        /// </summary>
        /// <param name="mobile"></param>
        /// <param name="weChat"></param>
        /// <returns></returns>
        string BindingWeChatByMobile(string mobile, string weChat);
        
        /// <summary>
        /// 判断是否已经被绑定
        /// </summary>
        /// <param name="weChat"></param>
        /// <returns></returns>
        bool HashBindingWeChat(string weChat);

        /// <summary>
        /// 返回用户信息
        /// </summary>
        /// <param name="weChat">微信号</param>
        /// <returns></returns>
        HospitalReportUser GetReportUserInfoByWeChat(string weChat);

        /// <summary>
        /// 根据产品线得到产品第一层分类
        /// </summary>
        /// <param name="productLineId"></param>
        /// <returns></returns>
        DataSet GetCfnLevel1ByProductLine(Guid productLineId);

        /// <summary>
        /// 根据产品线得到产品第二层分类
        /// </summary>
        /// <param name="productLineId"></param>
        /// <returns></returns>
        DataSet GetCfnLevel2ByProductLine(Guid productLineId);

        /// <summary>
        /// 根据产品线和产品第一层大类获得第二层大类
        /// </summary>
        /// <param name="table"></param>
        /// <returns></returns>
        DataSet GetCfnLevel2ByFilter(Hashtable table);

        /// <summary>
        /// 校验产品信息
        /// </summary>
        /// <param name="upn"></param>
        /// <param name="lotNumber"></param>
        /// <param name="weChatNumber"></param>
        /// <returns></returns>
        int CheckCfn(string upn, string lotNumber, string weChatNumber);

        /// <summary>
        /// 校验产品信息
        /// </summary>
        /// <param name="level2Code"></param>
        /// <param name="spec"></param>
        /// <param name="expiredDate"></param>
        /// <param name="weChatNumber"></param>
        /// <param name="reportType"></param>
        /// <returns></returns>
        int CheckCfnWeChatBySpec(string level2Code, string spec, string expiredDate, string weChatNumber, string reportType);

        /// <summary>
        /// 获得记录数量
        /// </summary>
        /// <param name="weChatNumber"></param>
        /// <returns></returns>
        DataSet GetCountByFilter(string weChatNumber);

        /// <summary>
        /// 根据医院 ID 获得上报人员列表
        /// </summary>
        /// <param name="hospId"></param>
        /// <returns></returns>
        DataSet QueryHospitalReportUserByFilter(string hospId);

        /// <summary>
        /// 校验手机号是否唯一
        /// </summary>
        /// <param name="id"></param>
        /// <param name="phone"></param>
        /// <returns></returns>
        bool CheckUserPhoneExist(string id, string phone);

        /// <summary>
        /// 更新用户信息
        /// </summary>
        /// <param name="user"></param>
        void UpdateHospitalReportUserByFilter(HospitalReportUser user);

        /// <summary>
        /// 根据ID得到用户信息
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        HospitalReportUser getHospitalReportUserById(Guid id);

        /// <summary>
        /// 新增用户
        /// </summary>
        /// <param name="user"></param>
        void SaveUser(HospitalReportUser user);

        /// <summary>
        /// 删除用户
        /// </summary>
        /// <param name="id"></param>
        void DeleteUser(Guid id);
    }
}