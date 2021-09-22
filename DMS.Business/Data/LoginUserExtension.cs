using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Business.Data
{
    using DMS.Business.Cache;
    using Lafite.RoleModel.Security;
    using DMS.Model;

    /// <summary>
    /// LoginUserExtension
    /// </summary>
    public static class LoginUserExtension
    {
        /// <summary>
        /// Gets the name of the corporation.
        /// </summary>
        /// <param name="user">The user.</param>
        /// <returns></returns>
        public static string GetCorporationName(this LoginUser user)
        {
            if (user.CorpId != null)
            {
                Guid cropid = user.CorpId.Value;
                //DealerMaster dealer = biz.GetDealerMaster(cropid);
                string dealerName = DealerCacheHelper.GetDealerName(cropid);
                if (dealerName != null)
                    return dealerName;
            }

            return string.Empty;
        }
    }
}
