using DMS.Business;
using DMS.Common;
using DMS.Common.Common;
using DMS.DataAccess;
using DMS.DataAccess.ContractElectronic;
using DMS.DataAccess.MasterPage;
using DMS.Model;
using DMS.ViewModel.MasterDatas;
using DMS.ViewModel.MasterPage;
using Grapecity.DataAccess.Transaction;
using Lafite.RoleModel.Security;
using Newtonsoft.Json;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace DMS.BusinessService.MasterDatas
{
    public class ConsignmentCfnSetInfoService : ABaseBusinessService
    {

        public ConsignmentCfnSetInfoVO Init(ConsignmentCfnSetInfoVO model)
        {
            try
            {

                ICfnSetBLL _CfnSetBLL = new CfnSetBLL();
                model.LstBu =  base.GetProductLine();
                if (!string.IsNullOrEmpty(model.InstanceId))
                {
                    IList<CfnSet> cnfSet = _CfnSetBLL.QueryCfnSetByID(model.InstanceId);
                    if (cnfSet.Count > 0)
                    {
                        model.IptCFNSetChineseName = cnfSet[0].ChineseName;
                        model.IptCFNSetEnglishName = cnfSet[0].EnglishName;
                        model.IptBu.Key = Convert.ToString(cnfSet[0].ProductLineBumId);

                    }

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

        public ConsignmentCfnSetInfoVO Save(ConsignmentCfnSetInfoVO model)
        {
            try
            {
                CfnSetDao cfnSetDao = new CfnSetDao();
                CfnSetDetailDao detailDao = new CfnSetDetailDao();
                using (TransactionScope trans = new TransactionScope())
                {
                    if (!string.IsNullOrEmpty(model.InstanceId))
                    {
                        detailDao.DeleteByCfnsID(new Guid(model.InstanceId));
                        cfnSetDao.Delete(new Guid(model.InstanceId));
                    }
                    else
                    {
                        model.InstanceId = Guid.NewGuid().ToString();
                    }
                    CfnSet mainData = new CfnSet();
                    mainData.Id = new Guid(model.InstanceId);
                    mainData.CreateUser = new Guid(RoleModelContext.Current.User.Id);
                    mainData.CreateDate = DateTime.Now;
                    mainData.ChineseName = model.IptCFNSetChineseName;
                    mainData.EnglishName = model.IptCFNSetEnglishName;
                    mainData.ProductLineBumId = new Guid(model.IptBu.Key);
                    mainData.DeletedFlag = false;
                    cfnSetDao.Insert(mainData);
                    foreach (var temp in model.RstDetailList)
                    {
                        CfnSetDetailVO detail = JsonConvert.DeserializeObject<CfnSetDetailVO>(temp.ToString());
                        CfnSetDetail csd = new CfnSetDetail();
                        csd.CfnId = new Guid(detail.CfnId);
                        csd.Id = Guid.NewGuid();
                        csd.CfnsId = new Guid(model.InstanceId);
                        csd.DefaultQuantity = detail.DefaultQuantity;
                        detailDao.Insert(csd);
                    }
                }
                model.RstDetailList = null;
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

        public string Query(ConsignmentCfnSetInfoVO model)
        {
            try
            {
                int outCont = 0;
                int start = (model.Page - 1) * model.PageSize;
                if (!string.IsNullOrEmpty(model.InstanceId))
                {
                    ICfnSetBLL _CfnSetBLL = new CfnSetBLL();

                    DataSet ds = _CfnSetBLL.QueryCfnSetDetailByCFNSID(new Guid(model.InstanceId), start, model.PageSize, out outCont);
                    model.RstDetailList = JsonHelper.DataTableToArrayList(ds.Tables[0]);
                }
                model.DataCount = outCont;
                model.IsSuccess = true;

            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            var data = new { data = model.RstDetailList, total = model.DataCount };
            var result = new { success = model.IsSuccess, data = data };
            return JsonConvert.SerializeObject(result);
        }





    }
}
