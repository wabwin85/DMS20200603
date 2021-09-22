using DMS.ViewModel.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Collections;
using Lafite.RoleModel.Domain;
using DMS.ViewModel.Consign.Common;

namespace DMS.ViewModel.Consign
{
    public class ConsignContractInfoVO : BaseBusinessVO
    {
        [LogAttribute]
        public KeyValue IptProductLine;
        [LogAttribute]
        public String IptNo;
        [LogAttribute]
        public KeyValue IptDealer;
        [LogAttribute]
        public String IptStatus;
        [LogAttribute]
        public String IptConsignmentDay;
        [LogAttribute]
        public bool IptIsFixedMoney;
        [LogAttribute]
        public String IptDelayNumber;
        [LogAttribute]
        public bool IptIsFixedQty;
        [LogAttribute]
        public bool IptIsKB;
        [LogAttribute]
        public DatePickerRange IptContractDate;
        [LogAttribute]
        public bool IptIsUseDiscount;
        [LogAttribute]
        public String IptRemark;
        [LogAttribute]
        public String IptContractName;

        public String IptApplyPeople;
        public String IptApplyDate;
        public String QryStatus;
        public String QryInstanceId;
        public String IptCreateDate;
        public String IptNewID;
        public String UPNCheck;
        public ApplyBasic IptApplyBasic;
        public ArrayList IptCFN_Property1;
        public ArrayList IptType;
        public bool CheckCreateUser;
        public IList<KeyValue> LstBu;
       
        public IList<ConsignContractUPN> LstContractDetail;
        public ArrayList RstContractDetail;
        public ArrayList LstDealer = null;
        public ArrayList LstStatus = null;
        public IList<String> LstUpn;
        public IList<String> LstSet;
    }
}
