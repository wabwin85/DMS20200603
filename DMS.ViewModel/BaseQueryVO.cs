using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.Text;

namespace DMS.ViewModel
{
    public class BaseQueryVO : BaseVO
    {
        public BaseQueryVO()
        {
        }

        public bool IsDealer;
        public bool IsCanApply;
        public bool IsMaxQueryCount;
        public string DealerListType = "1";
    }
}
