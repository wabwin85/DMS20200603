using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.ViewModel.Util
{
    public class FilterVO : BaseVO
    {
        public String DelegateBusiness;

        public Hashtable Parameters;

        public String QryString;
        
        public IList<Hashtable> RstResult;
    }
}
