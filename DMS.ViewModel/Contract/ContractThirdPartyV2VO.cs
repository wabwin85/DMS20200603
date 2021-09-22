using DMS.ViewModel.Common;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.ViewModel.Contract
{
    public class ContractThirdPartyV2VO : BaseQueryVO
    {
        //主页面
        public String HidDealerId;
        public String DealerType;
        public String QryDealerName;
        public String QryHospitalName;
        public KeyValue QryType;
        public String DownName;
        public String FileName;
        public bool HideFlag;
        public bool DisableFlag;
        public ArrayList RstAutHospList = null;
        public ArrayList RstPubHospList = null;

        //第三方披露
        public String DisclosureId;
        public String HidType;
        public String HospitalId;
        public String DeleteId;
        public String HidApproveStatus;
        //控制状态文字
        public String BtnApproveText;
        public String BtnSubmitText;
        public bool LPLogin;
        public bool AdminLogin;
        public bool DealerLogin;
        public bool ShowApprove;
        public bool ShowTermDate;
        public bool ShowRenew;
        public bool ShowEndThird;
        public bool ShowRefuseEnd;
        public bool EnableApproveRemark;

        public String WinHospitalName;
        public DateTime WinBeginDate;
        public DateTime WinEndDate;
        public DateTime WinTerminationDate;
        public String WinProductLine;
        public String WinCompanyName;
        public KeyValue WinRsm;
        public String WinSubmitName;
        public String WinPhone;
        public String WinApplicationNote;
        public String WinApprovalRemark;

        public ArrayList RstWinAttachList = null;
        public ArrayList RstWinProductLine = null;

        //分页
        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;
    }
}
