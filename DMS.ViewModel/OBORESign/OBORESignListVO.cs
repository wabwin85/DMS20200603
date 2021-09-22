using DMS.ViewModel.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Collections;

namespace DMS.ViewModel.OBORESign
{
    public class OBORESignListVO : BaseQueryVO
    {

        public String QryAgreementNo;

        public KeyValue QryProductLineID;

        public ArrayList LstProductLineID = null;

        public KeyValue QrySubBu;

        public ArrayList LstSubBu = null;


        //public IList<KeyValue> QrySubBu;

        //public IList<Hashtable> LstSubBu;


        public KeyValue QrySignA;

        public ArrayList LstSignA;

        public KeyValue QrySignB;

        public ArrayList LstSignB;

        public KeyValue QryStatus;

        public ArrayList LstStatus = null;

        public KeyValue QryAgreementType;

        public ArrayList LstAgreementType = null;

        public DatePickerRange QryCreateDate;

        public ArrayList RstResultList = null;

        public bool ButtomReadonly = true;

        public String NewID;
    }
}
