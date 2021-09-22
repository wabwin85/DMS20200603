using DMS.ViewModel.Common;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.ViewModel.MasterDatas
{
    public class DealerContractEditorVO : BaseQueryVO
    {
        public string hidDealerId;
        public String DealerName;
        public KeyValue QryDealer;
        public IList<KeyValue> LstProductLine;
        public ArrayList LstAuthType;
        public String QryContractNumber = String.Empty;
        public String QryContractYears = String.Empty;
        public String ContractId;
        public String AuthStartBeginDate;
        public String AuthStartEndDate;
        public String AuthStopBeginDate;
        public String AuthStopEndDate;
        public string DeleteDealerAutID;
        public KeyValue AuthType;
        public KeyValue ProductLine;
        public string hiddenRtnMsg;

        public string hiddenId;
        public string HospitalId;
        public string AuthStartDate;
        public string AuthEndDate;
        public string FolderName;//文件
        public string fileName;
        public string AttachmentId;
        public String HosHospitalName;
        public String HosStartBeginDate;
        public String HosStartEndDate;
        public String HosStopBeginDate;
        public string HosStopEndDate;
        public string HosNoAuthDate;
        public DatePickerRange QryHosStartDate;
        public DatePickerRange QryHosStopDate;
        public DatePickerRange QryAuthStartDate;
        public DatePickerRange QryAuthStopDate;
        
        public ArrayList LstApplyAuthType;
        public string PartTypeLine;
        public string PartType;
        public string PartCatagoryName;
        public string PartCatagory;

        public string hiddenSelectedId;
        public string hiddenProductLine;
        public string HosProvinceText;
        public string HosCityText;
        public string HosDistrictText;
        public string SearchHospitalName;
        public string submitStrParam;
        public string isCreated;

        public String QryProvince;
        public String QryCity;
        public String QryDistrict;
        public String QryHospitalName;
        public string QrySelectedProductLine;
        public String parentId;
        public bool IsFilterAuth = false;
        public bool IsMuliteSelect = false;
        public bool IsFilterProductLine = false;
        public string ProductLineID = string.Empty;
        public ArrayList RstResultProvincesList = null;
        public ArrayList RstResultCityList = null;
        public ArrayList RstResultAreaList = null;
        public ArrayList RstHospitalResultList = null;
        public ArrayList LstAttachmentList = null;

        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;
        public ArrayList RstResultList = null;
        public ArrayList ListDealer = null;

        public String DeleteDealerContractID = null;

        public String AddDealerContractID = null;
        public KeyValue AddDealer = null;
        public String AddContractNumber = String.Empty;
        public String AddContractYears = String.Empty;
        public DateTime AddStartDate;
        public DateTime AddStopDate;
    }

}
