using DMS.ViewModel.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Collections;

namespace DMS.ViewModel.MasterDatas
{
    public class DealerMaintainListVO : BaseQueryVO
    {
        public KeyValue QryDealerName;
        public KeyValue QryDealerType;
        public String QrySAPNo;
        public String QryDealerAddress;

        public ArrayList RstResultList = null;

        public IList<Hashtable> LstDealerName = null;
        public ArrayList LstDealerType = null;

        //窗体部分
        public String SelectDealerId;
        public String SelectSAPNo;
        public String SelectDealerType;
        public ArrayList LstDealerContact = null;
        public String WinOldCName;
        public String WinNewCName;
        public String WinOldEName;
        public String WinNewEName;
        
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
        public ArrayList RstLCAddressList = null;
        public ArrayList RstLCAttachList = null;
        public ArrayList RstLCProductList202 = null;
        public ArrayList RstLCProductList217 = null;
        public ArrayList RstLCProductList302 = null;
        public ArrayList RstLCProductList317 = null;

        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;
    }
}
