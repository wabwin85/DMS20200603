using System;
using DMS.Common.Common;
using DMS.Common;
using System.Data;
using DMS.BusinessService.Util.DealerFilter;
using DMS.BusinessService.Util.DealerFilter.Impl;
using DMS.Business.DealerTrain;
using DMS.ViewModel.MasterDatas;
using DMS.DataAccess.ContractElectronic;
using System.Collections;
using DMS.Business;
using DMS.DataAccess;
using System.Linq;
using DMS.Model;
using System.Collections.Generic;
using Lafite.RoleModel.Security;
using DMS.Model.Data;
using System.Collections.Specialized;
using DMS.Common.Extention;
using DMS.Business.Excel;
using Newtonsoft.Json;
using DMS.Business.ERPInterface;

namespace DMS.BusinessService.MasterDatas
{
    public class OrderDealerPriceService : ABaseQueryService, IDealerFilterFac, IQueryExport
    {
        #region Ajax Method
        public ADealerFilter CreateDealerFilter()
        {
            return new AllDealerFilter();
        }
        public OrderDealerPriceVO Init(OrderDealerPriceVO model)
        {
            try
            {
                model.ListBu = GetProductLine();
                model.ListPriceType = new ArrayList(DictionaryHelper.GetDictionary(SR.Consts_CFN_PriceType).ToList());
                ITerritorys bll = new Territorys();
                IList<Territory> provinces = bll.GetProvinces();
                model.ListProvince = JsonHelper.DataTableToArrayList(provinces.ToDataSet().Tables[0]);
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
        /// <summary>
        /// 经销商价格查询--OrderDealerPrice
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public OrderDealerPriceVO QueryInit(OrderDealerPriceVO model)
        {
            try
            {
                model.ListBu = GetProductLine();
                model.ListPriceType = new ArrayList(DictionaryHelper.GetDictionary(SR.Consts_CFN_PriceType).ToList());
                ITerritorys bll = new Territorys();
                IList<Territory> provinces = bll.GetProvinces();
                model.ListProvince = JsonHelper.DataTableToArrayList(provinces.ToDataSet().Tables[0]);
                //经销商权限控制,20191218
                if (IsDealer)
                {
                    if (RoleModelContext.Current.User.CorpType.Equals(DealerType.T2.ToString()))
                    {
                        model.hidInitDealerId = RoleModelContext.Current.User.CorpId.Value.ToString();
                        model.DealerType = RoleModelContext.Current.User.CorpType;
                        model.LstDealer = new ArrayList(DealerList().ToList());
                    }
                    else if (RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()) || RoleModelContext.Current.User.CorpType.Equals(DealerType.T1.ToString()))
                    {
                        //查询当前经销商以及下级经销商
                        model.LstDealer = new ArrayList(DealerListByFilter(true).ToList());
                        model.hidInitDealerId = RoleModelContext.Current.User.CorpId.Value.ToString();
                        model.DealerListType = "3";
                    }
                    else
                    {
                        model.LstDealer = new ArrayList(DealerList().ToList());
                    }
                }
                else
                {
                    model.LstDealer = new ArrayList(DealerList().ToList());
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

        public OrderDealerPriceVO ChangeProvince(OrderDealerPriceVO model)
        {
            try
            {
                model.ListBu = GetProductLine();
                model.ListPriceType = new ArrayList(DictionaryHelper.GetDictionary(SR.Consts_CFN_PriceType).ToList());
                ITerritorys bll = new Territorys();
                IList<Territory> citys = bll.GetTerritorysByParent(string.IsNullOrEmpty(model.QryProvince.Key) ? Guid.Empty : new Guid(model.QryProvince.Key));
                model.ListCity = JsonHelper.DataTableToArrayList(citys.ToDataSet().Tables[0]);
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
        public string Query(OrderDealerPriceVO model)
        {
            try
            {
                ICfnPriceService business = new CfnPriceService();
                Hashtable param = GetQueryConditions(model);

                param.Add("SubCompanyId", BaseService.CurrentSubCompany?.Key);
                param.Add("BrandId", BaseService.CurrentBrand?.Key);
                int outCont = 0;
                int start = (model.Page - 1) * model.PageSize;
                DataSet ds = business.QueryDealerPrice(param, start, model.PageSize, out outCont);
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
        public string Query2(OrderDealerPriceVO model)
        {
            try
            {
                if (model.QryDealer != null && !string.IsNullOrEmpty(model.QryDealer.Key))
                {
                    ICfnPriceService business = new CfnPriceService();
                    Hashtable param = GetQueryConditions(model);

                    param.Add("SubCompanyId", BaseService.CurrentSubCompany?.Key);
                    param.Add("BrandId", BaseService.CurrentBrand?.Key);
                    int outCont = 0;
                    int start = (model.Page - 1) * model.PageSize;
                    DataSet ds = business.QueryDealerPrice2(param, start, model.PageSize, out outCont);
                    model.RstResultList = JsonHelper.DataTableToArrayList(ds.Tables[0]);

                    model.DataCount = outCont;
                    model.IsSuccess = true;
                }
                else
                {
                    model.RstResultList = null;
                    model.DataCount = 0;
                    model.IsSuccess = true;
                }

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
        public OrderDealerPriceVO Delete(OrderDealerPriceVO model)
        {
            ICfnPriceService business = new CfnPriceService();
            try
            {
                if (!string.IsNullOrEmpty(model.DeleteCFNPID))
                {
                    CfnPrice cfnp = new CfnPrice();
                    cfnp.Id = new Guid(model.DeleteCFNPID);
                    cfnp.DeletedFlag = true;
                    business.DeleteCFNPrice(cfnp);
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
        public void Export(NameValueCollection Parameters, string DownloadCookie)
        {
            ICfnPriceService business = new CfnPriceService();
            Hashtable param = new Hashtable();

            if (!string.IsNullOrEmpty(Parameters["ProductLineBumId"].ToSafeString()))
            {
                param.Add("ProductLineBumId", Parameters["ProductLineBumId"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["DealerId"].ToSafeString()))
            {
                param.Add("DmaId", Parameters["DealerId"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["PriceType"].ToSafeString()))
            {
                param.Add("PriceType", Parameters["PriceType"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["CfnCode"].ToSafeString()))
            {
                param.Add("CfnCode", Parameters["CfnCode"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["Province"].ToSafeString()))
            {
                param.Add("Province", Parameters["Province"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["City"].ToSafeString()))
            {
                param.Add("City", Parameters["City"].ToSafeString());
            }


            if (IsDealer && (RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()) || RoleModelContext.Current.User.CorpType.Equals(DealerType.LS.ToString())))
            {
                param.Add("LPId", RoleModelContext.Current.User.CorpId);
            }
            param.Add("SubCompanyId", BaseService.CurrentSubCompany?.Key);
            param.Add("BrandId", BaseService.CurrentBrand?.Key);
            DataSet ds = null;
            if (string.IsNullOrEmpty(Parameters["Query"].ToSafeString()))
            {
                ds = business.ExportDealerPrice(param);//dt是从后台生成的要导出的datatable;
            }
            else
            {
                ds = business.ExportDealerPriceQuery(param);
            }
            if (ds != null)
            {
                DataTable dt = ds.Tables[0];
                DataSet[] result = new DataSet[1];
                result[0] = new DataSet();
                result[0].Tables.Add(dt.Copy());

                Hashtable ht = new Hashtable();
                XlsExport xlsExport = new XlsExport("OrderDealerPrice");
                xlsExport.Export(ht, result, DownloadCookie);
            }

        }
        private Hashtable GetQueryConditions(OrderDealerPriceVO model)
        {
            Hashtable param = new Hashtable();

            if (model.QryBu != null && !string.IsNullOrEmpty(model.QryBu.Key))
            {
                param.Add("ProductLineBumId", model.QryBu.Key);
            }
            if (model.QryDealer != null && !string.IsNullOrEmpty(model.QryDealer.Key))
            {
                param.Add("DmaId", model.QryDealer.Key);
            }
            if (model.QryPriceType != null && !string.IsNullOrEmpty(model.QryPriceType.Key))
            {
                param.Add("PriceType", model.QryPriceType.Key);
            }
            if (!string.IsNullOrEmpty(model.QryUPN))
            {
                param.Add("CfnCode", model.QryUPN);
            }
            if (model.QryProvince != null && !string.IsNullOrEmpty(model.QryProvince.Key))
            {
                param.Add("Province", model.QryProvince.Key);
            }
            if (model.QryCity != null && !string.IsNullOrEmpty(model.QryCity.Key))
            {
                param.Add("City", model.QryCity.Key);
            }
            //LP只能查看自己和下属T2价格
            if (IsDealer && RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()))
            {
                param.Add("LPId", RoleModelContext.Current.User.CorpId);
            }
            return param;
        }

        public OrderDealerPriceVO ImportProduct(OrderDealerPriceVO model)
        {
            try
            {
                ProductDao pdd = new ProductDao();
                OrderAndProduct oap = new OrderAndProduct();
                oap.GetMaterials();
                pdd.ProcessERPInterface();
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
