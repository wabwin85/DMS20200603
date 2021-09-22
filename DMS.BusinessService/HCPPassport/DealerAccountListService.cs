using DMS.Common;
using DMS.Common.Common;
using DMS.DataAccess.HCPPassport;
using DMS.ViewModel.HCPPassport;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.BusinessService.HCPPassport
{
    public class DealerAccountListService : ABaseQueryService
    {
        public DealerAccountListVO Init(DealerAccountListVO model)
        {
            try
            {

                


            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public DealerAccountListVO Query(DealerAccountListVO model)
        {
            try
            {

                DealerAccountDao dao = new DealerAccountDao();

                model.RstResultList = JsonHelper.DataTableToArrayList(dao.SelectIDENTITYList(model.QryName,model.QryPhone,model.QryEmail));

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
