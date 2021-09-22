using DMS.ViewModel.Common;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.ViewModel.HCPPassport
{
     public class DealerAccountResetPWDVO : BaseQueryVO
    {
        public String IptUserName;
        public String IptName;

       

        public string IptNewPassword;
        public string IptComNewPassword;
       

        

        public ArrayList RstResultList;

        public String ID;
        

        public bool IsAdmin;

    }
}
