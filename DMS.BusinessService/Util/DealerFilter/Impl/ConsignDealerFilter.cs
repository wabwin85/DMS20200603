using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Collections;
using DMS.Model.ViewModel;
using DMS.ViewModel.Util;
using DMS.DataAccess;
using DMS.Common.Extention;

namespace DMS.BusinessService.Util.DealerFilter.Impl
{
    public class ConsignDealerFilter : ADealerFilter
    {
        public override IList<Hashtable> GetDealerList(FilterVO model)
        {
            if (!model.QryString.IsNullOrEmpty())
            {
                DealerMasterDao dealerMasterDao = new DealerMasterDao();

                return dealerMasterDao.SelectFilterListConsign(model.Parameters.GetSafeGuidValue("ProductLine"),
                                                               base.UserInfo.CorpId.Value,
                                                               model.QryString);
            }
            else
            {
                return new List<Hashtable>();
            }
        }
        public override ArrayList GetDealerList(DealerScreenFilterVO model)
        {
            return null;
        }
    }
}
