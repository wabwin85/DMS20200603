using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.ViewModel.OBORESign
{
    public class OBORContractWindowVO : BaseQueryVO
    
    {
        public String Src;

        public String FileName;

        public String ResData;

        public String ES_ID;

        public bool DealerSignReadonly=true;

        public bool LPSignReadonly=true;
    }
}
