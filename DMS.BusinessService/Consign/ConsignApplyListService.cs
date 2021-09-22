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

namespace DMS.BusinessService.Consign
{
    public class ConsignApplyListService : ABaseQueryService
    {

        public ConsignApplyListVO Init(ConsignApplyListVO model)

        {
            try
            {
                ProPolicyDao policyDao = new ProPolicyDao();


                //if (RoleModelContext.Current.User.CorpType.Equals(DealerType.T2.ToString()) || RoleModelContext.Current.User.CorpType.Equals(DealerType.T1.ToString()))
                //{
                //    model.LstDealer = JsonHelper.DataTableToArrayList(policyDao.QueryDealer(new Hashtable()));
                //}
                //else if (RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()))
                //{
                //    model.LstDealer = JsonHelper.DataTableToArrayList(policyDao.QueryDealer(new Hashtable()));
                //}
                //else
                //{
                //    model.LstDealer = JsonHelper.DataTableToArrayList(policyDao.QueryDealer(new Hashtable()));
                //}

                //model.QryApplyDate = new DatePickerRange();
                //model.LstBu = JsonHelper.DataTableToArrayList(policyDao.QueryBu(new Hashtable()));
                ////model.LstDealer= JsonHelper.DataTableToArrayList(policyDao.QueryBu(new Hashtable()));
                //model.RstResultList = JsonHelper.DataTableToArrayList(policyDao.SelectConsignContractList(new Hashtable()));


            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public ConsignApplyListVO Query(ConsignApplyListVO model)

        {

            try
            {
                ProPolicyDao policyDao = new ProPolicyDao();
                Hashtable ConsignContract = new Hashtable();

                ConsignContract.Add("QryBu", Isnull(model.QryBu));
                ConsignContract.Add("QryApplyNo", model.QryApplyNo);
                ConsignContract.Add("QryDealer", Isnull(model.QryDealer));
                ConsignContract.Add("QryApplyStatus", Isnull(model.QryApplyStatus));
                ConsignContract.Add("QryHasUpn", Isnull(model.QryHasUpn));
                ConsignContract.Add("QryConsignContract", Isnull(model.QryConsignContract));
                ConsignContract.Add("QryHospital", Isnull(model.QryHospital));
                ConsignContract.Add("QrySale", Isnull(model.QrySale));
                ConsignContract.Add("StartDate", Isnull(model.QryApplyDate.StartDate));
                ConsignContract.Add("EndDate", Isnull(model.QryApplyDate.EndDate));

                model.RstResultList = JsonHelper.DataTableToArrayList(policyDao.SelectConsignApplyList(ConsignContract));
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

        public string Isnull(string Model)
        {
            if (string.IsNullOrEmpty(Model))
            {
                return null;
            }
            else
            {
                return Model.Trim();
            }

        }

    }
}
