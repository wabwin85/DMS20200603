
using System;
using System.Collections.Generic;
using System.Collections;
using DMS.ViewModel.Common;

namespace DMS.ViewModel.MasterDatas
{
    public class PositionHospitalVO : BaseQueryVO
    {
        public string AttributeID;
        public string PositionID;
        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;
        public ArrayList PositionOrgs = null;
        public ArrayList HospitalPositions = null;
        public ArrayList RstUploadInfo = null;
        
        public ChangeRecords<View_HospitalPosition> HospitalPosition_ChangeRecords;
    }

    public class View_HospitalPosition
    {
        public System.Guid ID { get; set; }
        public System.Guid PositionID { get; set; }
        public System.Guid ProductLineID { get; set; }
        public System.Guid HospitalID { get; set; }
        public string HOS_Key_Account { get; set; }
        public string HOS_HospitalName { get; set; }
        public string HOS_Province { get; set; }
        public string HOS_City { get; set; }
        public string HOS_District { get; set; }
    }
}
