using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Serialization;

namespace DMS.Model.DataInterface.SampleManage
{
    [Serializable]
    public class SoapSampleApplyHead
    {
        public String SampleType { get; set; }
        public String ApplyNo { get; set; }
        public String SapCode { get; set; }
        public String ApplyQuantity { get; set; }
        public String RemainQuantity { get; set; }
        public String ApplyDate { get; set; }
        public String ApplyUserID { get; set; }
        public String ApplyUser { get; set; }
        public String ProcessUserID { get; set; }
        public String ProcessUser { get; set; }
        public String ApplyDept { get; set; }
        public String ApplyDivision { get; set; }
        public String CustType { get; set; }
        public String CustName { get; set; }
        public String ArrivalDate { get; set; }
        public String ApplyPurpose { get; set; }
        public String ApplyCost { get; set; }
        public String IrfNo { get; set; }
        public String HospName { get; set; }
        public String HpspAddress { get; set; }
        public String TrialDoctor { get; set; }
        public String ReceiptUser { get; set; }
        public String ReceiptPhone { get; set; }
        public String ReceiptAddress { get; set; }
        public String DealerName { get; set; }
        public String ApplyMemo { get; set; }
        public String ConfirmItem1 { get; set; }
        public String ConfirmItem2 { get; set; }

        [XmlArray("UpnList"), XmlArrayItem("UpnItem")]
        public SoapSampleUpn[] UpnList;

        [XmlArray("TestingList"), XmlArrayItem("TestingItem")]
        public SoapSampleTesting[] TestingList;
    }
}
