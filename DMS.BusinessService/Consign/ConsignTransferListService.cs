using System;
using System.Collections;
using DMS.Common.Common;
using DMS.Common;
using DMS.ViewModel.Consign;
using DMS.DataAccess;
using DMS.Common.Extention;
using DMS.DataAccess.ContractElectronic;
using DMS.ViewModel.Common;
using System.Collections.Generic;
using DMS.DataAccess.Consignment;
using DMS.Business;

namespace DMS.BusinessService.Consign
{
    public class ConsignTransferListService : ABaseQueryService
    {
        #region Ajax Method

        public ConsignTransferListVO Init(ConsignTransferListVO model)
        {
            try
            {
                model.LstQueryType = new List<KeyValue>();
                model.LstQueryType.Add(new KeyValue("In", "移入"));
                model.LstQueryType.Add(new KeyValue("Out", "移出"));

                model.LstBu = base.GetProductLine();
                model.LstStatus = DictionaryHelper.GetKeyValueList(SR.Consign_ConsignTransfer_Status);

                model.IsCanApply = base.IsDealer;

                model.RstResultList = new List<Hashtable>();
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public ConsignTransferListVO Query(ConsignTransferListVO model)
        {
            try
            {
                TransferHeaderDao transferHeaderDao = new TransferHeaderDao();
                model.RstResultList = transferHeaderDao.SelectByCondition(model.QryQueryType.Key, base.IsDealer, base.UserInfo.CorpId, model.QryBu.Key.ToGuid(), model.QryContractNo, model.QryStatus.Key, model.QryDealer, model.QryUpn, BaseService.CurrentSubCompany?.Key, BaseService.CurrentBrand?.Key);
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
