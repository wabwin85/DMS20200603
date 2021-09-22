using DMS.ViewModel.Common;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.ViewModel.HCPPassport
{
     public class DealerAccountInfoVO : BaseQueryVO
    {

        public String IptName;

        public String IptPhone;

        public String IptEmail;

        public IList<KeyValue> IptRoles;

        public IList<Hashtable> LstRoles;

        public bool IptIsFlag=true;

        public ArrayList RstResultList;

        public String ID;

        public ArrayList Roles;

        public bool IsAdmin;

    }
}
