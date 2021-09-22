using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Model.ViewModel
{
    public class HomeVO : BaseViewModel
    {
        public HomeVO()
        {
            RstMenuList = new ArrayList();
        }

        public String IptHomeUrl { get; set; }
        public String IptUserName { get; set; }

        public String IptSubCompanyName;
        public String IptSubCompanyId;

        public String IptBrandName;
        public String IptBrandId;
        public ArrayList RstMenuList { get; set; }
        public ArrayList LstSubCompany;
        public ArrayList LstBrand;
    }
}
