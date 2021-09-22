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
using DMS.Model.Data;
using DMS.Business;

namespace DMS.BusinessService.Consign
{
    public class ConsignInventoryAdjustHeaderListService : ABaseQueryService
    {

        public ConsignInventoryAdjustHeaderListVO Init(ConsignInventoryAdjustHeaderListVO model)
        {

            try
            {
                ConsignInventoryAdjustHeaderDao ConsignInventoryAdjustHeaderDao = new ConsignInventoryAdjustHeaderDao();
                QueryDao Bu = new QueryDao();
                Hashtable htbu = new Hashtable();
                htbu.Add("SubCompanyId", BaseService.CurrentSubCompany?.Key);
                htbu.Add("BrandId", BaseService.CurrentBrand?.Key);
                model.LstProductLine = JsonHelper.DataTableToArrayList(Bu.SelectBU(htbu).Tables[0]);
                model.LstStatus = DictionaryHelper.GetKeyValueList(SR.CONST_AdjustQty_Status);
                model.LstType = JsonHelper.DataTableToArrayList(ConsignInventoryAdjustHeaderDao.GetKeyValueType());
                model.IsDealer = IsDealer;
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public ConsignInventoryAdjustHeaderListVO Query(ConsignInventoryAdjustHeaderListVO model)
        {
            try
            {
                string LPId = "";
                string DealerId = "";
                bool Dealer = true;
                ConsignInventoryAdjustHeaderDao consignInventoryAdjustHeaderDao = new ConsignInventoryAdjustHeaderDao();
                if (IsDealer && (RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()) || RoleModelContext.Current.User.CorpType.Equals(DealerType.LS.ToString())))
                {
                    LPId = RoleModelContext.Current.User.CorpId.ToSafeString();
                }
                if (IsDealer && RoleModelContext.Current.User.CorpType != DealerType.LP.ToString() && RoleModelContext.Current.User.CorpType != DealerType.LS.ToString())
                {
                    DealerId = RoleModelContext.Current.User.CorpId.ToSafeString();
                }
                if (!IsDealer)
                {
                    Dealer = false;
                }
                model.RstResultList = JsonHelper.DataTableToArrayList(consignInventoryAdjustHeaderDao.SelectConsignContractList(model.QryProductLine.Key, model.QryDealer, model.QryType.Key, model.QryApplyDate.StartDate, model.QryApplyDate.EndDate, model.QryApplyNo, model.QryST.Key, model.QryProductModel, model.QryProductBatchNo, model.QryTwoCode, model.QryBillNo, LPId, Dealer, DealerId, BaseService.CurrentSubCompany?.Key, BaseService.CurrentBrand?.Key));
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
