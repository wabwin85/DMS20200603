using System;
using DMS.Common.Common;
using DMS.Common;
using DMS.ViewModel.Consign;
using DMS.DataAccess;
using DMS.DataAccess.ContractElectronic;
using DMS.Model;
using DMS.Model.Data;
using DMS.Business.Cache;
using DMS.DataAccess.Consignment;
using DMS.Business;

namespace DMS.BusinessService.Consign
{
    public class ConsignInventoryAdjustPickerService : ABaseQueryService
    {

        public ConsignInventoryAdjustPickerVO Init(ConsignInventoryAdjustPickerVO model)
        {
            try
            {
                ConsignInventoryAdjustHeaderDao ConsignInventoryAdjustHeaderDao = new ConsignInventoryAdjustHeaderDao();
                QueryDao Bu = new QueryDao();
                WarehouseDao dao = new WarehouseDao();
                //if (model.QryType == "UPN")
                //{
                //    model.LstUPN = JsonHelper.DataTableToArrayList(ContractHeader.QueryUPN(model.QryBu, model.QryDealer, null, null));
                //}
                //else
                //{
                //model.LstProduct = JsonHelper.DataTableToArrayList(ConsignInventoryAdjustHeaderDao.SelectADDProduct(model.QryProductLine,model.QryDealer,null, null,null,null));

                //model.QryDealer = "a00fcd75-951d-4d91-8f24-a29900da5e85";
                DealerMaster dealer = DealerCacheHelper.GetDealerById(new Guid(model.QryDealer));

                switch ((DealerType)Enum.Parse(typeof(DealerType), dealer.DealerType, true))
                {

                    case DealerType.LP:
                        //平台，显示波科寄售库/借货库
                        model.LstWarehouse = JsonHelper.DataTableToArrayList(dao.GetAllByDealerDT(model.QryDealer, WarehouseType.Consignment.ToString(), WarehouseType.Borrow.ToString(),""));
                        break;
                    case DealerType.LS:
                        //与平台相同
                        model.LstWarehouse = JsonHelper.DataTableToArrayList(dao.GetAllByDealerDT(model.QryDealer, WarehouseType.Consignment.ToString(), WarehouseType.Borrow.ToString(), ""));
                        break;
                    case DealerType.T1:
                        //T1 ,显示波科寄售库/借货库
                        model.LstWarehouse = JsonHelper.DataTableToArrayList(dao.GetAllByDealerDT(model.QryDealer, WarehouseType.Consignment.ToString(), WarehouseType.Borrow.ToString(), ""));
                        break;
                    case DealerType.T2:
                        //二级经销商，显示平台寄售库/借货库 波科寄售库
                        model.LstWarehouse = JsonHelper.DataTableToArrayList(dao.GetAllByDealerDT(model.QryDealer, WarehouseType.LP_Consignment.ToString(), WarehouseType.LP_Borrow.ToString(), WarehouseType.Consignment.ToString()));
                        break;
                    default: break;

                }
               
                //}

                //model.LstBu = JsonHelper.DataTableToArrayList(Bu.SelectBU().Tables[0]);
                //model.LstStatus = JsonHelper.DataTableToArrayList(ContractHeader.QueryConsignContractType(SR.Consign_Contract_Type));

            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public ConsignInventoryAdjustPickerVO Query(ConsignInventoryAdjustPickerVO model)
        {
            try
            {
                ConsignInventoryAdjustHeaderDao consignInventoryAdjustHeaderDao = new ConsignInventoryAdjustHeaderDao();


                model.RstResultList = JsonHelper.DataTableToArrayList(consignInventoryAdjustHeaderDao.SelectADDProduct(model.QryProductLine, model.QryDealer, model.QryWarehouse.Key, model.QryLotNumber, model.QryProductModel, model.QryTwoCode, BaseService.CurrentSubCompany?.Key, BaseService.CurrentBrand?.Key));
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
