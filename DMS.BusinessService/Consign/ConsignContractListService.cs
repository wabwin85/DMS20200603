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
using DMS.Business;

namespace DMS.BusinessService.Consign
{
    public class ConsignContractListService : ABaseQueryService
    {
        #region Ajax Method

        public ConsignContractListVO Init(ConsignContractListVO model)
        {
            try
            {
                ContractHeaderDao ContractHeader = new ContractHeaderDao();
                QueryDao Bu = new QueryDao();
                if (IsDealer)
                {
                    Hashtable tb = new Hashtable();
                    tb.Add("OwnerCorpId", UserInfo.CorpId.ToSafeString());
                    model.LstDealer = JsonHelper.DataTableToArrayList(ContractHeader.QueryDealer(tb));
                }
                else
                {
                    model.LstDealer = JsonHelper.DataTableToArrayList(ContractHeader.QueryDealer(new Hashtable()));
                }
                model.IsDealer = IsDealer;
                Hashtable htbu = new Hashtable();
                htbu.Add("SubCompanyId", BaseService.CurrentSubCompany?.Key);
                htbu.Add("BrandId", BaseService.CurrentBrand?.Key);
                model.LstBu = JsonHelper.DataTableToArrayList(Bu.SelectBU(htbu).Tables[0]);
                model.LstStatus = DictionaryHelper.GetKeyValueList(SR.Consign_Contract_Type);


            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public ConsignContractListVO Query(ConsignContractListVO model)
        {
            try
            {
                ContractHeaderDao ContractHeader = new ContractHeaderDao();

                if (IsDealer)
                {
                    model.RstResultList = JsonHelper.DataTableToArrayList(ContractHeader.SelectConsignContractList(model.QryBu.Key.ToSafeString(), model.QryContractNo.ToSafeString(), model.QryDealer.ToSafeString(), model.QryDiscountRule.Key.ToSafeString(),
                    model.QryHasUpn.ToSafeString(), model.QryIsAuto.Key.ToSafeString(), model.QryStatus.Key.ToSafeString(), model.QryContractDate.StartDate, model.QryContractDate.EndDate, RoleModelContext.Current.User.CorpId, BaseService.CurrentSubCompany?.Key, BaseService.CurrentBrand?.Key));
                }
                else
                {
                    model.RstResultList = JsonHelper.DataTableToArrayList(ContractHeader.SelectConsignContractList(model.QryBu.Key.ToSafeString(), model.QryContractNo.ToSafeString(), model.QryDealer.ToSafeString(), model.QryDiscountRule.Key.ToSafeString(),
                    model.QryHasUpn.ToSafeString(), model.QryIsAuto.Key.ToSafeString(), model.QryStatus.Key.ToSafeString(), model.QryContractDate.StartDate, model.QryContractDate.EndDate, null, BaseService.CurrentSubCompany?.Key, BaseService.CurrentBrand?.Key));
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

        #endregion
    }


}
