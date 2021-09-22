using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Business.Data
{
    using DMS.Model;
    using DMS.Business.Cache;

    public static class DealerContractExtension
    {
        public static string GetDealerName(this DealerContract dealerContract) 
        {
            if (dealerContract.Id != null)
                return DealerCacheHelper.GetDealerName(dealerContract.Id.Value);
            else
                return string.Empty;
        }
    }
}
