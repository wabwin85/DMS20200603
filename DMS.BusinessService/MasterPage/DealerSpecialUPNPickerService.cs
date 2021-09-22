using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Data;
using System.Collections.Specialized;
using DMS.Common.Common;
using DMS.Common;
using DMS.ViewModel.Consign;
using DMS.ViewModel.Common;
using DMS.DataAccess;
using Lafite.RoleModel.Security;
using DMS.Model.Data;
using DMS.Common.Extention;
using DMS.DataAccess.ContractElectronic;
using DMS.DataAccess.Consignment;
using DMS.ViewModel.MasterPage;
using DMS.DataAccess.MasterPage;
using Grapecity.DataAccess.Transaction;
using DMS.Business;

namespace DMS.BusinessService.MasterPage
{
    public class DealerSpecialUPNPickerService : ABaseQueryService
    {

        public DealerSpecialUPNPickerVO Init(DealerSpecialUPNPickerVO model)
        {
            try
            {
                QueryDao Bu = new QueryDao();
                Hashtable htbu = new Hashtable();
                htbu.Add("SubCompanyId", BaseService.CurrentSubCompany?.Key);
                htbu.Add("BrandId", BaseService.CurrentBrand?.Key);
                model.LstBu = JsonHelper.DataTableToArrayList(Bu.SelectBU(htbu).Tables[0]);

            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }


        public DealerSpecialUPNPickerVO Query(DealerSpecialUPNPickerVO model)
        {
            try
            {
                
                DealerSpecialUPNDao dao = new DealerSpecialUPNDao();
              

                model.RstResultList = JsonHelper.DataTableToArrayList(dao.DealerSpecialUPNPicker(model.InstanceId,model.QryFilter,model.QryBu.Key));
                

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

        public DealerSpecialUPNPickerVO Save(DealerSpecialUPNPickerVO model)
        {
            try
            {


                using (TransactionScope trans = new TransactionScope())
                {
                    DealerSpecialUPNDao dao = new DealerSpecialUPNDao();

                    //dao.Delete(model.InstanceId);
                    dao.Insert(model.InstanceId, model.CFNID, RoleModelContext.Current.User.Id, DateTime.Now);
                    model.RstResultList = null;
                    trans.Complete();
                }

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
