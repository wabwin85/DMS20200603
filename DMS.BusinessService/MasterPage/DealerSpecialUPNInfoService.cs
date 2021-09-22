using DMS.Business;
using DMS.Common;
using DMS.Common.Common;
using DMS.DataAccess.ContractElectronic;
using DMS.DataAccess.MasterPage;
using DMS.ViewModel.MasterPage;
using Grapecity.DataAccess.Transaction;
using Lafite.RoleModel.Security;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.BusinessService.MasterPage
{
    public class DealerSpecialUPNInfoService : ABaseBusinessService
    {

        public DealerSpecialUPNInfoVO Init(DealerSpecialUPNInfoVO model)
        {
            try
            {

                DealerSpecialUPNDao dao = new DealerSpecialUPNDao();
                QueryDao Bu = new QueryDao();
                model.LstBu = base.GetProductLine();
                if (!string.IsNullOrEmpty(model.InstanceId))
                {
                    model.RstDetailList = JsonHelper.DataTableToArrayList(dao.SelectDealerSpecialUPNInfo(model.InstanceId));
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

        public DealerSpecialUPNInfoVO Save(DealerSpecialUPNInfoVO model)
        {
            try
            {


                using (TransactionScope trans = new TransactionScope())
                {
                    DealerSpecialUPNDao dao = new DealerSpecialUPNDao();

                    
                    dao.Insert(model.InstanceId, model.CFNID, RoleModelContext.Current.User.Id, DateTime.Now);
                    model.RstDetailList = JsonHelper.DataTableToArrayList(dao.SelectDealerSpecialUPNInfo(model.InstanceId));
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

        public DealerSpecialUPNInfoVO Query(DealerSpecialUPNInfoVO model)
        {
            try
            {
                DealerSpecialUPNDao dao = new DealerSpecialUPNDao();

                model.RstDetailList = JsonHelper.DataTableToArrayList(dao.SelectDealerSpecialUPNQuery(model.InstanceId,model.QryFilter,model.QryBu.Key));

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

        public DealerSpecialUPNInfoVO ChangeList(DealerSpecialUPNInfoVO model)
        {
            try
            {
                DealerSpecialUPNDao dao = new DealerSpecialUPNDao();
                
                model.RstDetailList = JsonHelper.DataTableToArrayList(dao.SelectDealerSpecialUPNQuery(model.InstanceId, model.QryFilter, model.QryBu.Key));

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


        public DealerSpecialUPNInfoVO Delete(DealerSpecialUPNInfoVO model)
        {
            try
            {
                DealerSpecialUPNDao dao = new DealerSpecialUPNDao();
                dao.Delete(model.InstanceId, model.CFN_ID);
                model.RstDetailList = JsonHelper.DataTableToArrayList(dao.SelectDealerSpecialUPNQuery(model.InstanceId, model.QryFilter, model.QryBu.Key));

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

        public DealerSpecialUPNInfoVO CheckDelete(DealerSpecialUPNInfoVO model)
        {
            try
            {
                String CFN_ID = "";
                for (int i =0;i<model.CFNID.Count;i++) {

                    CFN_ID += model.CFNID[i] + ",";
                }
                DealerSpecialUPNDao dao = new DealerSpecialUPNDao();
                dao.Delete(model.InstanceId, CFN_ID);

                model.RstDetailList = JsonHelper.DataTableToArrayList(dao.SelectDealerSpecialUPNQuery(model.InstanceId, model.QryFilter, model.QryBu.Key));

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
