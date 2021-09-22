using DMS.ViewModel.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Collections;

namespace DMS.ViewModel.MasterDatas
{
    public class DealerLicenseChangeVO : BaseQueryVO
    {
        public KeyValue QryLCDealerName;
        public KeyValue QryLCApplyStatus;
        public String QryLCFlowNo;
        public String hidDealerId;

        public ArrayList RstLCResultList = null;

        public IList<Hashtable> LstLCDealerName = null;

        #region 窗体部分
        //基本信息
        public String WinDMLID;
        public String hidApplyStatus;
        public String WinHidAppNo;
        public String WinAddrID;
        public String WinAddrCode;
        public String WinAddrIsSend;
        public String WinAttachId;
        public KeyValue WinLCSales;
        public String WinLCHeadOfCorp;
        public String WinLCLegalRep;
        public String WinLCLicenseNo;
        public DateTime WinLCLicenseStart;
        public DateTime WinLCLicenseEnd;
        public String WinLCRecordNo;
        public DateTime WinLCRecordStart;
        public DateTime WinLCRecordEnd;

        public ArrayList LstLCSales = null;

        //ShipTo
        public ArrayList RstLCAddressList = null;
        public KeyValue WinLCAddressType;
        public String WinLCAddressInfo;
        public String IsDefaultAddr;
        public String WinDefaultAddress;
        //附件
        public ArrayList RstLCAttachList = null;
        //产品分类
        public String WinProductCode;
        public String WinProductName;
        //public String WinCatType;
        //public String WinVerNo;
        public String WinProductCat;
        public ArrayList RstLCWinProductList = null;
        public ArrayList RstLCProductList202 = null;
        public ArrayList RstLCProductList217 = null;
        public ArrayList RstLCProductList302 = null;
        public ArrayList RstLCProductList317 = null;

        #endregion

        //分页
        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;
        
    }
}
