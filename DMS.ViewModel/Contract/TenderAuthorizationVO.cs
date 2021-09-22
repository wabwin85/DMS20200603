
using System;
using System.Collections.Generic;
using System.Collections;
using DMS.ViewModel.Common;

namespace DMS.ViewModel.Contract
{
    public class TenderAuthorizationVO : BaseQueryVO
    {
        
        public String QryAuthorizationNo = String.Empty;
        public DatePickerRange QryAuthorizationStart;
        public DatePickerRange QryAuthorizationEnd;
        public DatePickerRange QryApproveDate;
        public String QryDealer = String.Empty;
        public KeyValue QryApproveStatus;
        public KeyValue QryAuthorizationType;
        public String QryHospital = String.Empty;
        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;
        public ArrayList RstResultList = null;
        public ArrayList ListApproveStatus = null;
        public ArrayList ListAuthorizationType = null;

        //操作按钮使用
        public String DTMID = String.Empty;
        public String ApprovalUrl = String.Empty;
        public String DTMNO = String.Empty;
        public String ApplicType = String.Empty;
        public String DealerType = String.Empty;
        public ArrayList ListAuthorizationTypeExt = null;
        public KeyValue IptAuthorizationTypeExt;
        public String PdfName = String.Empty;
    }
}
