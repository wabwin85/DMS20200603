using DMS.Common;
using DMS.Common.Common;
using DMS.DataAccess.HCPPassport;
using DMS.ViewModel.HCPPassport;
using Lafite.RoleModel.Security;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.BusinessService.HCPPassport
{
    public class DealerAccountPickerService : ABaseQueryService
    {
        public DealerAccountPickerVO Init(DealerAccountPickerVO model)
        {
            try
            {
                DealerAccountDao dao = new DealerAccountDao();

                if (RoleModelContext.Current.User.CorpType == "LP")
                {
                    model.RstResultList = JsonHelper.DataTableToArrayList(dao.SelectRoles("LP"));
                }
                else if (RoleModelContext.Current.User.CorpType == "LS")
                {
                    model.RstResultList = JsonHelper.DataTableToArrayList(dao.SelectRoles("LS"));
                }
                else if (RoleModelContext.Current.User.CorpType == "T1")
                {
                    model.RstResultList = JsonHelper.DataTableToArrayList(dao.SelectRoles("T1"));
                }
                else if (RoleModelContext.Current.User.CorpType == "T2")
                {
                    model.RstResultList = JsonHelper.DataTableToArrayList(dao.SelectRoles("T2"));
                }

            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public DealerAccountPickerVO Save(DealerAccountPickerVO model)
        {
            try
            {
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
