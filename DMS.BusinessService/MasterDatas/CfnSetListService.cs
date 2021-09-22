using System;
using DMS.Common.Common;
using DMS.Common;
using System.Data;
using Newtonsoft.Json;
using DMS.BusinessService.Util.DealerFilter;
using DMS.BusinessService.Util.DealerFilter.Impl;
using DMS.Business.DealerTrain;
using DMS.ViewModel.MasterDatas;
using DMS.DataAccess.ContractElectronic;
using System.Collections;
using DMS.Business;
using DMS.DataAccess;
using DMS.Model;
using Lafite.RoleModel.Security;

namespace DMS.BusinessService.MasterDatas
{
    public class CfnSetListService : ABaseQueryService
    {
        #region Ajax Method
        public ADealerFilter CreateDealerFilter()
        {
            return new AllDealerFilter();
        }
        public CfnSetListVO Init(CfnSetListVO model)
        {
            try
            {
                QueryDao Bu = new QueryDao();
                Hashtable htbu = new Hashtable();
                
                model.ListBu = base.GetProductLine();//JsonHelper.DataTableToArrayList(Bu.SelectBU(htbu).Tables[0]);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public string Query(CfnSetListVO model)
        {
            try
            {
                ICfnSetBLL _CfnSetBLL = new CfnSetBLL();
                Hashtable param = new Hashtable();
                if (model.QryBu!=null&&!string.IsNullOrEmpty(model.QryBu.Key))
                {
                    param.Add("ProductLineBumId", model.QryBu.Key);
                }

                if (!string.IsNullOrEmpty(model.QryCFNSetName))
                {
                    param.Add("CfnSetName", model.QryCFNSetName);
                }

                if (!string.IsNullOrEmpty(model.QryCFN))
                {
                    param.Add("CustomerFaceNbr", model.QryCFN);
                }

                if (!string.IsNullOrEmpty(model.QryCFNSetUPN))
                {
                    param.Add("CfnSetUPN", model.QryCFNSetUPN);
                }
                param.Add("SubCompanyId", BaseService.CurrentSubCompany?.Key);
                param.Add("BrandId", BaseService.CurrentBrand?.Key);
                int outCont = 0;
                int start = (model.Page - 1) * model.PageSize;
                DataSet ds = _CfnSetBLL.QueryDataByFilterCfnSet(param, start, model.PageSize, out outCont);
                model.RstResultList = JsonHelper.DataTableToArrayList(ds.Tables[0]);

                model.DataCount = outCont;
                model.IsSuccess = true;

            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            var data = new { data = model.RstResultList, total = model.DataCount };
            var result = new { success = model.IsSuccess, data = data };
            return JsonConvert.SerializeObject(result);
        }

        public CfnSetListVO Delete(CfnSetListVO model)
        {
            CfnDao _CfnSetDao = new CfnDao();
            try
            {
                if (model.DeleteSeleteID.Count>0)
                {
                    foreach(string id in model.DeleteSeleteID)
                    {
                        Cfn temp = new Cfn();
                        temp.Id = new Guid(id);
                        temp.DeletedFlag = true;
                        temp.LastUpdateUser = new Guid(RoleModelContext.Current.User.Id);
                        temp.LastUpdateDate = DateTime.Now;
                        _CfnSetDao.FakeDelete(temp);
                    }
                    model.IsSuccess = true;
                }
                else
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add("删除出错！");
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
        #endregion
    }


}
