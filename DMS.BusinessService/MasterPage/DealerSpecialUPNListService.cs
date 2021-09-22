using System;
using System.Collections;
using DMS.Common.Common;
using DMS.Common;
using DMS.ViewModel.Consign;
using DMS.DataAccess;
using DMS.Common.Extention;
using DMS.DataAccess.ContractElectronic;
using DMS.DataAccess.Consignment;
using Lafite.RoleModel.Security;
using DMS.ViewModel.MasterPage;
using DMS.DataAccess.MasterPage;
using DMS.BusinessService.Util.DealerFilter;
using DMS.BusinessService.Util.DealerFilter.Impl;
using System.Collections.Generic;

namespace DMS.BusinessService.MasterPage
{
    public class DealerSpecialUPNListService : ABaseQueryService, IDealerFilterFac
    {
        public ADealerFilter CreateDealerFilter()
        {
            return new AllDealerFilter();
        }

        public DealerSpecialUPNListVO Init(DealerSpecialUPNListVO model)
        {
            try
            {
                DealerSpecialUPNDao dao = new DealerSpecialUPNDao();
                model.LstDealerType= JsonHelper.DataTableToArrayList(dao.DealerType(SR.Consts_Dealer_Type));
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public DealerSpecialUPNListVO Query(DealerSpecialUPNListVO model)
        {
            try
            {
                DealerSpecialUPNDao dao = new DealerSpecialUPNDao();
                model.RstResultList = JsonHelper.DataTableToArrayList(dao.SelectDealerSpecialUPNList(model.IptDealer.Key,model.QryDealerType.Key));

                model.IsSuccess = true;
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }

            return model;
        }
    }
}
