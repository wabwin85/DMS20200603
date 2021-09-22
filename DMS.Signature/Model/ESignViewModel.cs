using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.Text;

namespace DMS.Signature.Model
{
    #region ViewModel
    public class ESignViewModel
    {
        public String ReqData { get; set; }

        public String ResData { get; set; }

        public String Function { get; set; }

        public String Method { get; set; }

        public bool IsSuccess { get; set; }

        public bool IsCanEdit { get; set; }

        public bool IsCanView { get; set; }

        public String LastUpdateDate { get; set; }

        private StringCollection _executeMessage;
        public StringCollection ExecuteMessage
        {
            get
            {
                if (_executeMessage == null)
                {
                    _executeMessage = new StringCollection();
                }
                return _executeMessage;
            }
            set
            {
                this._executeMessage = value;
            }
        }
    }

    /// <summary>
    /// 企业用户注册
    /// </summary>
    public class EnterpriseUserVO
    {
        public String DealerId { get; set; }
        public String SubDealerId { get; set; }
        public String DealerName { get; set; }
        public String AccountUid { get; set; }
        public String Phone { get; set; }
        public String Email { get; set; }
        public String Name { get; set; }
        public int OrganType { get; set; }
        public String RegType { get; set; }
        public String OrganCode { get; set; }
        public int UserType { get; set; }
        public String LegalName { get; set; }
        public String LegalIdNo { get; set; }
        public int LegalArea { get; set; }
        public String AgentName { get; set; }
        public String AgentIdNo { get; set; }
        public String Address { get; set; }
        public String Scope { get; set; }
        public String Status { get; set; }
        public Guid CreateUser { get; set; }
        public String CreateUserName { get; set; }
        public DateTime CreateDate { get; set; }
        public Guid UpdateUser { get; set; }
        public String UpdateUserName { get; set; }
        public DateTime UpdateDate { get; set; }
    }

    /// <summary>
    /// 企业制章
    /// </summary>
    public class EnterpriseSealVO
    {
        public String EmId { get; set; }
        public String DealerId { get; set; }
        public String SubDealerId { get; set; }
        public String OrganName { get; set; }
        public String DealerName { get; set; }
        public String AccountUid { get; set; }
        public String TemplateType { get; set; }
        public String Color { get; set; }
        public String HText { get; set; }
        public String QText { get; set; }
        public String Seal { get; set; }
        public String ImageUrl { get; set; }
        public String IsActive { get; set; }
        public Guid CreateUser { get; set; }
        public String CreateUserName { get; set; }
        public DateTime CreateDate { get; set; }
        public Guid UpdateUser { get; set; }
        public String UpdateUserName { get; set; }
        public DateTime UpdateDate { get; set; }
    }

    /// <summary>
    /// 电子签章
    /// </summary>
    public class EnterpriseSignVO
    {
        /// <summary>
        /// 业务单据ID
        /// </summary>
        public String ApplyId { get; set; }
        /// <summary>
        /// 附件ID
        /// </summary>
        public String FileId { get; set; }
        /// <summary>
        /// 源文件名字
        /// </summary>
        public String FileSrcName { get; set; }
        /// <summary>
        /// 源文件路径
        /// </summary>
        public String FileSrcPath { get; set; }
        /// <summary>
        /// 目标文件名字
        /// </summary>
        public String FileDstName { get; set; }
        /// <summary>
        /// 目标文件路径
        /// </summary>
        public String FileDstPath { get; set; }
        /// <summary>
        /// 文件名（下载后的）
        /// </summary>
        public String FileName { get; set; }
        /// <summary>
        /// 经销商ID
        /// </summary>
        public String DealerId { get; set; }
        public String SubDealerId { get; set; }
        public String DealerName { get; set; }
        public String AccountUid { get; set; }
        public String LegalAccountUid { get; set; }
        /// <summary>
        /// 短信验证码
        /// </summary>
        public String Code { get; set; }
        public Guid CreateUser { get; set; }
        public String CreateUserName { get; set; }
        public DateTime CreateDate { get; set; }
        public String[] UserRoles { get; set; }
    }

    /// <summary>
    /// 企业实名制
    /// </summary>
    public class EnterpriseAuthVO
    {
        public String DealerId { get; set; }
        public String SubDealerId { get; set; }
        public String DealerName { get; set; }
        public String AccountUid { get; set; }

        public String OrganName { get; set; }
        public String ResisterType { get; set; }
        public String OrganCode { get; set; }
        public String LegalName { get; set; }
        public String LegalIdNo { get; set; }
        public String AccountName { get; set; }
        public String CardNo { get; set; }
        public String Bank { get; set; }
        public String SubBranch { get; set; }
        public String Provice { get; set; }
        public String City { get; set; }
        public String Prcptcd { get; set; }

        public String PayMoney { get; set; }
        public Guid CreateUser { get; set; }
        public String CreateUserName { get; set; }
        public DateTime CreateDate { get; set; }
    }

    public class EnterpriseToolVO
    {
        public int page { get; set; }
        public int pageSize { get; set; }
        public int take { get; set; }
        public int skip { get; set; }
        public String bankName { get; set; }
        public String subBranch { get; set; }
    }

    public class EnterpriseRegisterVO
    {
        public String DealerId { get; set; }
        public String SubDealerId { get; set; }
        public String DealerName { get; set; }
        public String AccountUid { get; set; }
        public String LegalAccountUid { get; set; }
        public String OrganName { get; set; }
        public int OrganType { get; set; }
        public String EnterpriseResisterType { get; set; }
        public String OrganCode { get; set; }
        public String LegalName { get; set; }
        public String LegalIdNo { get; set; }
        public String AgentName { get; set; }
        public String AgentIdNo { get; set; }
        public String Moblie { get; set; }
        public String Email { get; set; }
        public String CardNo { get; set; }
        public String Bank { get; set; }
        public int LegalArea { get; set; }
        public int UserType { get; set; }
        public Guid CreateUser { get; set; }
        public String CreateUserName { get; set; }
        public DateTime CreateDate { get; set; }
    }
    #endregion

    #region 电子签章model
    public class ESignBaseModel
    {
        /// <summary>
        /// 业务单据ID
        /// </summary>
        public String ApplyId { get; set; }
        /// <summary>
        /// 附件ID
        /// </summary>
        public String FileId { get; set; }
        /// <summary>
        /// 经销商ID
        /// </summary>
        public Guid DealerId { get; set; }
        public String SubDealerId { get; set; }
        /// <summary>
        /// 用户唯一标识
        /// </summary>
        public String AccountUid { get; set; }
        /// <summary>
        /// 法人唯一标识
        /// </summary>
        public String LegalAccountUid { get; set; }
        public Guid CreateUser { get; set; }
        public String CreateUserName { get; set; }
        public DateTime CreateDate { get; set; }
    }

    /// <summary>
    /// 签章
    /// </summary>
    public class SignPdfModel : ESignBaseModel
    {
        /// <summary>
        /// 源文件名
        /// </summary>
        public String srcName { get; set; }
        /// <summary>
        /// 源文件路径
        /// </summary>
        public String srcFile { get; set; }
        /// <summary>
        /// 目标文件名
        /// </summary>
        public String dstName { get; set; }
        /// <summary>
        /// 目标文件路径
        /// </summary>
        public String dstFile { get; set; }
        /// <summary>
        /// 文件名
        /// </summary>
        public String fileName { get; set; }
        /// <summary>
        /// 短信验证码
        /// </summary>
        public String code { get; set; }
        /// <summary>
        /// 坐标
        /// </summary>
        public List<SealPostModel> sealList { get; set; }
    }

    /// <summary>
    /// 签章关键字
    /// </summary>
    public class SealPostModel
    {
        /// <summary>
        /// 签字类型 “1”：法人章；“0”：企业章
        /// </summary>
        public String sealType { get; set; }
        /// <summary>
        /// 关键字
        /// </summary>
        public String keyWord { get; set; }
        /// <summary>
        /// X偏移
        /// </summary>
        public float xPadding { get; set; }
        /// <summary>
        /// Y偏移
        /// </summary>
        public float yPadding { get; set; }
        /// <summary>
        /// 骑缝章坐标
        /// </summary>
        public float edgesYPosition { get; set; }
        /// <summary>
        /// 印章BASE64字符串
        /// </summary>
        public String sealData { get; set; }
    }

    #endregion


    #region 枚举
    public enum EnterpriseMasterStatus
    {
        /// <summary>
        /// 删除
        /// </summary>
        DELETE,
        /// <summary>
        /// 正常
        /// </summary>
        NORMAL,
        /// <summary>
        /// 失效
        /// </summary>
        INVALID,
        /// <summary>
        /// 异常
        /// </summary>
        ERROR
    }

    public enum EnterpriseAuthStatus
    {
        /// <summary>
        /// 实名认证通过
        /// </summary>
        RealNameSuccess,
        /// <summary>
        /// 实名认证错误
        /// </summary>
        RealNameError,
        /// <summary>
        /// 打款成功（等待用户回填打款金额）
        /// </summary>
        PayAuthSuccss,
        /// <summary>
        /// 打款失败
        /// </summary>
        PayAuthError,
        /// <summary>
        /// 打款认证通过（企业信息全部通过）
        /// </summary>
        Normal,
        /// <summary>
        /// 企业注册失败
        /// </summary>
        EnterpriseRegError,
        /// <summary>
        /// 企业制章失败
        /// </summary>
        EnterpriseSealError,
        /// <summary>
        /// 法人注册失败
        /// </summary>
        LegalRegError,
        /// <summary>
        /// 法人制章失败
        /// </summary>
        LegalSealError
    }

    public enum EnterpriseToPayStatus
    {
        /// <summary>
        /// 打款错误/打款金额认证失败
        /// </summary>
        Error,
        /// <summary>
        /// 等待打款金额认证
        /// </summary>
        WaitPayAuth,
        /// <summary>
        /// 打款认证通过
        /// </summary>
        Normal
    }

    public enum EnterpriseUserType
    {
        /// <summary>
        /// 平台自身
        /// </summary>
        Local,
        /// <summary>
        /// 经销商
        /// </summary>
        Dealer,
        /// <summary>
        /// 平台自身作废
        /// </summary>
        LocalCancel,
        /// <summary>
        /// 经销商作废
        /// </summary>
        DealerCancel,
        /// <summary>
        /// 平台
        /// </summary>
        LP,
        /// <summary>
        /// OBOR甲方
        /// </summary>
        OBORDealer,
        /// <summary>
        /// OBOR乙方
        /// </summary>
        OBORLP
    }

    public enum EnterpriseSignType
    {
        /// <summary>
        /// 企业签章
        /// </summary>
        Enterprise = 0,
        /// <summary>
        /// 法人签章
        /// </summary>
        LegalPerson = 1
    }
    #endregion
}
