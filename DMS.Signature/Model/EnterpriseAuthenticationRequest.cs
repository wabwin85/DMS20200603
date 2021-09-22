using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Signature.Model
{
    public class EnterpriseAuth_RealName
    {
        /// <summary>
        /// 企业名称
        /// </summary>
        public string name;
        /// <summary>
        /// 组织机构代码，codeORG、codeUSC 选填其中之一
        /// </summary>
        public string codeORG;
        /// <summary>
        /// 社会统一信用代码，codeORG、codeUSC 选填其中之一
        /// </summary>
        public string codeUSC;
        /// <summary>
        /// 工商注册号
        /// </summary>
        public string codeREG;
        /// <summary>
        /// 法人姓名
        /// </summary>
        public string legalName;
        /// <summary>
        /// 法人身份证号码
        /// </summary>
        public string legalIdno;
    }

    public class EnterpriseAuth_ToPay
    {
        /// <summary>
        /// 对公账户户名（一般来说即企业名称） 
        /// </summary>
        public string name;
        /// <summary>
        /// 企业对公银行账号 
        /// </summary>
        public string cardno;
        /// <summary>
        /// 企业银行账号开户行支行全称
        /// </summary>
        public string subbranch;
        /// <summary>
        /// 企业银行账号开户行名称，支持银行列表见《e 签宝企业实名 认证服务支持打款银行列表》，精确匹配 
        /// </summary>
        public string bank;
        /// <summary>
        /// 企业银行账号开户行所在省份，支持省份见《e 签宝企业实名 认证服务银行省市列表》，精确匹配 
        /// </summary>
        public string provice;
        /// <summary>
        /// 企业银行账号开户行所在城市，支持县市见《e 签宝企业实名 认证服务银行省市列表》，精确匹配 
        /// </summary>
        public string city;
        /// <summary>
        /// 打款完成通知的接收地址 
        /// </summary>
        public string notify;
        /// <summary>
        /// 企业信息校验成功后返回的 serviceId 
        /// </summary>
        public string serviceId;
        /// <summary>
        /// 企业用户对公账户所在的开户行的大额行号；请参考 3 支持银 行列表。列表内银行不必传入大额行号，其他银行需要传入大 额行号 
        /// </summary>
        public string prcptcd;
        /// <summary>
        /// 调用者业务 ID 
        /// </summary>
        public string pizId;
    }

    public class EnterpriseAuth_PayVerification
    {
        public string serviceId;
        public decimal cash;
    }
}
