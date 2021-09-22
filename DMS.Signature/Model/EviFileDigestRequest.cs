using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Signature.Model
{
    public class EviFileDigestRequest
    {
        /// <summary>
        /// 文档信息
        /// </summary>
        public class EviFileDigestInfo
        {
            public string eviName { get; set; }
            public string contentDescription { get; set; }
            public long contentLength { get; set; }
            public string contentDigest { get; set; }
            public List<ESignIds> eSignIds { get; set; }
            public List<BizIds> bizIds { get; set; }
        }

        /// <summary>
        /// eSignIds列表
        /// </summary>
        public class ESignIds
        {
            public int type { get; set; }
            public string value { get; set; }
        }

        /// <summary>
        /// BizIds列表
        /// </summary>
        public class BizIds
        {
            public int type { get; set; }
            public string value { get; set; }
        }

        public class CertificateBean
        {
            public string type { get; set; }
            public string number { get; set; }
            public string name { get; set; }
        }

        public class CertificateInfo
        {
            public string evid { get; set; }
            public List<CertificateBean> certificates { get; set; }
        }

        public class EviFileModel
        {
            /// <summary>
            /// 合同ID
            /// </summary>
            public String applyId { get; set; }
            /// <summary>
            /// 附件ID
            /// </summary>
            public String fileId { get; set; }
            /// <summary>
            /// 经销商ID
            /// </summary>
            public Guid dealerId { get; set; }
            /// /// <summary>
            /// 文件路径
            /// </summary>
            public String filePath { get; set; }
            /// <summary>
            /// 存证文件名
            /// </summary>
            public String eviName { get; set; }
            /// <summary>
            /// 
            /// </summary>
            public List<ESignIds> eSignIds { get; set; }
            /// <summary>
            /// 
            /// </summary>
            public List<BizIds> bizIds { get; set; }
            public Guid CreateUser { get; set; }
            public String CreateUserName { get; set; }
            public DateTime CreateDate { get; set; }

        }

        public class RelateFileModel
        {
            /// <summary>
            /// 合同ID
            /// </summary>
            public String applyId { get; set; }
            /// <summary>
            /// 附件ID
            /// </summary>
            public String fileId { get; set; }
            /// <summary>
            /// 经销商ID
            /// </summary>
            public Guid dealerId { get; set; }
            /// <summary>
            /// 存证文件名
            /// </summary>
            public String evid { get; set; }
            /// <summary>
            /// 用户证件信息
            /// </summary>
            public List<CertificateBean> certificates { get; set; }
            public Guid CreateUser { get; set; }
            public String CreateUserName { get; set; }
            public DateTime CreateDate { get; set; }
        }

        public class FileDigestEviUrlModel
        {
            public CertificateType certificateType { get; set; }
            public String certificateNumber { get; set; }
            public String evid { get; set; }
        }


        public enum CertificateType
        {
            /// <summary>
            /// 身份证
            /// </summary>
            ID_CARD,
            /// <summary>
            /// 组织机构代码
            /// </summary>
            CODE_ORG,
            /// <summary>
            /// 社会统一信用代码
            /// </summary>
            CODE_USC,
            /// <summary>
            /// 工商注册号
            /// </summary>
            CODE_REG,
        }
    }
}
