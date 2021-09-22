using DMS.ViewModel.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Collections;

namespace DMS.ViewModel.OBORESign
{
    public class OBORESignInfoVO : BaseQueryVO
    {

        public String ES_ID;

        public String IptAgreementNo;

        //public KeyValue IptSubBu;

        //public ArrayList LstSubBu;


        public IList<KeyValue> IptSubBu;

        public IList<Hashtable> LstSubBu;


        public String IptSignA;

        public KeyValue IptSignB;

        public ArrayList LstSignB;

        public String IptCreateUser;

        public String IptCreateDate;

        public ArrayList RstDetailList;

        public String Status;

        public KeyValue IptBu;

        public ArrayList LstBu;

        public String Src;

        public String FileName;

        public bool SignReadonly=true;

        public bool DeleteReadonly = true;

        public bool RevokeReadonly = true;

        public bool SubmitReadonly = true;

        public bool UploadReadonly = true;

    }
}
