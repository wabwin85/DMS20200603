using DMS.Common;
using DMS.Common.Common;
using DMS.DataAccess;
using DMS.Model.ViewModel.Promotion;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Lafite.RoleModel.Security;
using DMS.Model;
using DMS.Common.Extention;
using Grapecity.DataAccess.Transaction;
using System.Net;
using System.Data;

namespace DMS.Business.Promotion
{
    public class MaintainAppointedDealerService : BaseService
    {
        #region Ajax Method

        public MaintainAppointedDealerVO InitPage(MaintainAppointedDealerVO model)
        {
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    ProPolicyDao policyDao = new ProPolicyDao();
                    ProDescriptionDao descritptionDao = new ProDescriptionDao();

                    Hashtable condition = new Hashtable();
                    condition.Add("PolicyId", model.IptPolicyId);
                    condition.Add("CurrUser", UserInfo.Id);
                    condition.Add("WithType", "ByDealer");
                    model.RstPolicyDealer = JsonHelper.DataTableToArrayList(policyDao.QueryPolicyDealerSelected(condition).Tables[0]);

                    model.LstPolicyDealerDesc = descritptionDao.SelectProDescriptioinList("PolicyDealer");

                    if (model.IptPageType == "Modify" && model.IptPromotionState == SR.PRO_Status_Draft)
                    {
                        model.IsCanEdit = true;
                    }
                    else
                    {
                        model.IsCanEdit = false;
                    }

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

        public MaintainAppointedDealerVO Save(MaintainAppointedDealerVO model)
        {
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    ProPolicyDao policyDao = new ProPolicyDao();

                    policyDao.DeleteDealersByUserId(UserInfo.Id);

                    String[] dealerCode = model.IptDealerCode.Split(new String[] { "\n" }, StringSplitOptions.RemoveEmptyEntries);
                    if (dealerCode.Length == 0)
                    {
                        model.IsSuccess = false;
                        model.ExecuteMessage.Add("请填写经销商Code");
                    }
                    else
                    {
                        IList<ProDealerInputUi> list = new List<ProDealerInputUi>();
                        foreach (String code in dealerCode)
                        {
                            ProDealerInputUi data = new ProDealerInputUi();
                            data.CurrUser = UserInfo.Id;
                            data.PolicyId = model.IptPolicyId.ToInt();
                            data.SapCode = code;
                            data.ErrMsg = "";

                            list.Add(data);
                        }
                        policyDao.BatchDealersInsert(list);

                        policyDao.VerifyDealers(new Guid(UserInfo.Id), model.IptProductLine, model.IptSubBu);

                        policyDao.DealersUiSubmintSuccess(UserInfo.Id, model.IptOperType);

                        Hashtable errorCondition = new Hashtable();
                        errorCondition.Add("CurrUser", UserInfo.Id);
                        DataTable result = policyDao.QueryPolicyDealerUpload(errorCondition).Tables[0];

                        model.IptImportSuccess = result.Select("ISErr = 0").Length;
                        DataRow[] fail = result.Select("ISErr = 1");
                        model.IptImportFail = fail.Length;

                        foreach (DataRow row in fail)
                        {
                            Dictionary<string, object> dictionary = new Dictionary<string, object>();  //实例化一个参数集合
                            dictionary.Add("SAPCode", row.GetSafeStringValue("SAPCode"));
                            dictionary.Add("ErrMsg", row.GetSafeStringValue("ErrMsg"));

                            model.RstImportFailList.Add(dictionary); //ArrayList集合中添加键值
                        }

                        Hashtable condition = new Hashtable();
                        condition.Add("PolicyId", model.IptPolicyId);
                        condition.Add("CurrUser", UserInfo.Id);
                        condition.Add("WithType", "ByDealer");
                        model.RstPolicyDealer = JsonHelper.DataTableToArrayList(policyDao.QueryPolicyDealerSelected(condition).Tables[0]);

                        model.IsSuccess = true;

                        trans.Complete();
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

        public MaintainAppointedDealerVO Remove(MaintainAppointedDealerVO model)
        {
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    ProPolicyDao policyDao = new ProPolicyDao();

                    Hashtable obj = new Hashtable();
                    obj.Add("CurrUser", UserInfo.Id);
                    obj.Add("DEALERID", model.IptDealerId);
                    policyDao.DeleteSelectedDealer(obj);

                    Hashtable condition = new Hashtable();
                    condition.Add("PolicyId", model.IptPolicyId);
                    condition.Add("CurrUser", UserInfo.Id);
                    condition.Add("WithType", "ByDealer");
                    model.RstPolicyDealer = JsonHelper.DataTableToArrayList(policyDao.QueryPolicyDealerSelected(condition).Tables[0]);

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

        #endregion

        #region Internal Function

        #endregion
    }
}
