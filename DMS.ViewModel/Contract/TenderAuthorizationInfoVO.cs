
using System;
using System.Collections.Generic;
using System.Collections;
using DMS.ViewModel.Common;

namespace DMS.ViewModel.Contract
{
    public class TenderAuthorizationInfoVO : BaseQueryVO
    {
        
        public String IptAtuNo = String.Empty;
        public String IptAtuApplyUser = String.Empty;
        public String IptAtuApplyDate = String.Empty;
        public KeyValue IptAuthorizationInfo;
        public ArrayList ListAuthorizationInfo = null;
        public String IptAtuBeginDate = String.Empty;
        public String IptAtuEndDate = String.Empty;
        public KeyValue IptProductLine;
        public IList<KeyValue> ListBu = null;
        public KeyValue IptDealerType;
        public ArrayList ListDealerType = null;
        public KeyValue IptSuperiorDealer;
        public ArrayList ListSuperiorDealer = null;
        public bool IptSAtulicenseType = true;
        public KeyValue IptSubBU;
        public ArrayList ListSubBU = null;
        public String IptDealerName = String.Empty;
        public String IptAtuMailAddress = String.Empty;
        public String IptAtuRemark = String.Empty;
        public String InstanceId = String.Empty;
        public String HospitalId = String.Empty;
        public String PCTId = String.Empty;
        public String Status = String.Empty;
        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;
        public ArrayList RstHospitalDetail = null;
        public ArrayList RstHospitalProduct = null;
        public bool isNewApply = true;


        public String AddHosDepartment = String.Empty;

        public ArrayList RstProductStore = null;
        public String ProductString = String.Empty;
        public String DeleteAttachmentID = String.Empty;
        public String DeleteAttachmentName = String.Empty;
        public ArrayList AttachmentList = null;

        public String HospitalString = String.Empty;
    }
}
