
using DMS.Model.ViewModel;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Model
{
    public class QueryView: BaseViewModel
    {
        public QueryView()
        {
            QryBUList = new ArrayList();
            QryList = new ArrayList();
            QryClassContractList = new ArrayList();
            QryEffectStateList = new ArrayList();
        }
        public string QryContractID { get; set; }
        /// <summary>
        /// 合同编号
        /// </summary>
        public string QryContractNO { get; set; }
        /// <summary>
        /// 合同类型，LP，T1，T2
        /// </summary>
        public string QryContractType { get; set; }
        public string QryContractStatus { get; set; }
        /// <summary>
        /// 经销商类型
        /// </summary>
        public string QryDealerType { get; set; }
        /// <summary>
        /// 合同分类
        /// </summary>
        public string QryCCNameCN { get; set; }
        /// <summary>
        /// 经销商
        /// </summary>
        public string QryDealerName { get; set; }
        /// <summary>
        /// 产品线BU
        /// </summary>
        public string QryProductLine { get; set; }
        /// <summary>
        /// 是否是T2，true--T2，false--LP、T1
        /// </summary>
        public string QryIsT2 { get; set; }


        //public string QryDivisionCode { get; set; }

        public ArrayList QryBUList { get; set; }
        public ArrayList QryClassContractList { get; set; }
        public ArrayList QryList { get; set; }
        public ArrayList QryEffectStateList { get; set; }

        public string IsNewContract { get; set; }

        //生成授权书相关
        public string hidDealerId { get; set; }
        public string hidDealerName { get; set; }
        public DateTime? hidEffectiveDate { get; set; }
        public string hidSuBU { get; set; }
        public DateTime? hidExpirationDate { get; set; }
        public bool ShowAuthorization { get; set; }
        public string IptAuthorizationCode { get; set; }
        public string IptAuthorizationContacts { get; set; }
        public string IptAuthorizationPhone { get; set; }
        public string IptContractId { get; set; }
        public string IptDealerType { get; set; }
        public string IptContractType { get; set; }



        //public int CurrentPageIndex { get; set; }
        //public int PageSize { get; set; }
    }
    public class ReqData
    {
        public string DealerId { get; set; }
        public string AccountUid { get; set; }
        public string DealerName { get; set; }
        public string Code { get; set; }
        public string FileSrcPath { get; set; }
        public string FileSrcName { get; set; }
        public string ApplyId { get; set; }
        public string FileId { get; set; }

        public string BeginDate { get; set; }
        public string EndDate { get; set; }
        public string ContractNo { get; set; }
        public string ContractStatus { get; set; }
        public int page { get; set; }
        public int pageSize { get; set; }
        public int take { get; set; }
        public int skip { get; set; }
        public string ProductLine { get; set; }
    }
}
