using DMS.ViewModel.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Collections;

namespace DMS.ViewModel.Consign
{
    public class ConsignApplyListVO : BaseQueryVO
    {

        public String QryBu = String.Empty;

        public String QryDealer = String.Empty;
        public String QryApplyNo = String.Empty;
        public String QryApplyStatus = String.Empty;
        public String QryConsignContract = String.Empty;
        public String QryHospital = String.Empty;
        public String QryHasUpn = String.Empty;
        public DatePickerRange QryApplyDate = null;
        public String QrySale = String.Empty;

        public ArrayList RstResultList = null;

        public ArrayList LstBu = null;
        public ArrayList LstDealer = null;
    }
}
