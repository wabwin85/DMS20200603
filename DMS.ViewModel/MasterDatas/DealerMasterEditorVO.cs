using DMS.ViewModel.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Collections;

namespace DMS.ViewModel.MasterDatas
{
    public class DealerMasterEditorVO : BaseQueryVO
    {
        //经销商ID,Type
        public String IptDmaID;
        public String IptDealerType;

        //基本信息
        public String IptDmaCName;
        public String IptDmaCSName;
        public String IptDmaEName;
        public String IptDmaESName;
        public String IptDmaNo;
        public String IptDmaSapNo;
        public KeyValue IptDmaProvince;
        public KeyValue IptDmaRegion;
        public KeyValue IptDmaTown;
        public String IptCorpType;
        public String IptDmaType;
        public String IptTaxType;
        public String IptSNDealer;
        public bool IptSalesMode;
        public DateTime IptFirstSignDate;
        public String IptDealerAuthentication;
        public DateTime IptSystemStartDate;
        public String IptCarrier;
        public bool IptActiveFlag;

        public ArrayList LstDmaProvince = null;
        public ArrayList LstDmaRegion = null;
        public ArrayList LstDmaTown = null;
        public ArrayList LstDmaType = null;
        public ArrayList LstDmaTaxType = null;
        public ArrayList LstDmaAuthentication = null;

        //地址信息
        public String IptDmaRegisterAddress;
        public String IptDmaAddress;
        public String IptDmaShipToAddress;
        public String IptDmaPostalCOD;
        public String IptDmaPhone;
        public String IptDmaFax;
        public String IptDmaContact;
        public String IptDmaEmail;

        //工商注册信息
        public String IptDmaGeneralManager;
        public String IptDmaLegalRep;
        public String IptDmaRegisteredCapital;
        public String IptDmaBankAccount;
        public String IptDmaBank;
        public String IptDmaTaxNo;
        public String IptDmaLicense;
        public String IptDmaLicenseLimit;
        public DateTime IptDmaEstablishDate;

        //财务信息
        public String IptDmaFinance;
        public String IptDmaFinancePhone;
        public String IptDmaFinanceEmail;
        public String IptDmaPayment;

        public ArrayList LstDmaPayment = null;

        //经销商附件
        public String IptDmaAttachName;
        public KeyValue IptDmaAttachType;

        public ArrayList LstDmaAttachType = null;
        public ArrayList RstAttachList = null;

        //授权-指标导出
        public ArrayList LstExportType = null;
        public ArrayList LstProductLine = null;
        public ArrayList LstAllProductLine = null;
        public ArrayList LstYear = null;

        //分页
        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;
    }
}
