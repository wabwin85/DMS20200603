using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DMS.Common;
using DMS.Common.Common;
using System.Data;
using System.Collections;
using DMS.DataAccess.ContractElectronic;
using DMS.Model;
using System.Text.RegularExpressions;
using Lafite.RoleModel.Security;
using DMS.DataAccess;
using DMS.Model.Data;
using DMS.Business.Contract;

namespace DMS.Business
{
    public class QueryService : BaseService
    {
        private IRoleModelContext _context = RoleModelContext.Current;
        public QueryView SelectAllContractByApproved(QueryView model)
        {
            try
            {
                using (QueryDao dao = new QueryDao())
                {
                    if (model.Method == "QueryLPORT1" || model.Method == "InitPageLPT1")
                    {
                        if (string.IsNullOrEmpty(model.QryDealerType))
                        {
                            // model.QryDealerType = null;
                            model.QryIsT2 = "1";
                        }
                        else
                        {
                            model.QryIsT2 = null;
                        }
                    }
                    if (model.Method == "QueryT2" || model.Method == "InitPageT2")
                    {
                        model.QryDealerType = "T2";
                        model.QryIsT2 = null;
                    }
                    if (string.IsNullOrEmpty(model.QryDealerType))
                    {
                        model.QryDealerType = null;
                    }
                    if (string.IsNullOrEmpty(model.QryContractNO) || string.IsNullOrEmpty(model.QryContractNO.Trim()))
                    {
                        model.QryContractNO = null;
                    }
                    else
                    {
                        model.QryContractNO = Regex.Replace(model.QryContractNO, @"\s", "");
                        // model.QryContractNO.Replace(" ","");
                    }


                    if (string.IsNullOrEmpty(model.QryContractType))
                    {
                        model.QryContractType = null;
                    }
                    if (string.IsNullOrEmpty(model.QryDealerName) || string.IsNullOrEmpty(model.QryDealerName.Trim()))
                    {
                        model.QryDealerName = null;
                    }
                    else
                    {
                        model.QryDealerName = Regex.Replace(model.QryDealerName, @"\s", "");
                    }

                    if (string.IsNullOrEmpty(model.QryProductLine))
                    {
                        model.QryProductLine = null;
                    }
                    if (string.IsNullOrEmpty(model.QryCCNameCN))
                    {
                        model.QryCCNameCN = null;
                    }


                    Hashtable ht = new Hashtable();
                    //ht.Add("ContractID", model.QryContractID);
                    if (_context.User.IdentityType == "User")
                    {
                        ht.Add("InitDealerName", _context.User.Id);
                    }
                    else
                    {
                        ht.Add("InitDealerName", "00000000-0000-0000-0000-000000000000");
                    }


                    ht.Add("ContractNo", model.QryContractNO == null ? "" : model.QryContractNO);
                    ht.Add("ContractStatus", model.IsNewContract == null ? "" : model.IsNewContract);
                    ht.Add("ContractType", model.QryContractType == null ? "" : model.QryContractType);
                    ht.Add("CNameCN", model.QryCCNameCN == null ? "" : model.QryCCNameCN);
                    ht.Add("DealerType", model.QryDealerType == null ? "" : model.QryDealerType);
                    //ht.Add("DealerName", model.QryDealerName==null?"": model.QryDealerName);

                    ht.Add("CorpType", _context.User.CorpType == null ? "" : _context.User.CorpType);

                    if (model.QryDealerType == "T2")
                    {
                        if (_context.User.CorpType == "T2")
                        {
                            ht.Add("DealerName", _context.User.CorpName == null ? "" : _context.User.CorpName);
                            ht.Add("DealerID", _context.User.CorpId == null ? "" : _context.User.CorpId.ToString());
                        }
                        else if (_context.User.CorpType == "LP")
                        {
                            ht.Add("DealerName", model.QryDealerName == null ? "" : model.QryDealerName);
                            ht.Add("DealerID", _context.User.CorpId == null ? "" : _context.User.CorpId.ToString());
                        }
                        else
                        {
                            ht.Add("DealerName", model.QryDealerName == null ? "" : model.QryDealerName);
                            ht.Add("DealerID", "");
                        }
                        
                    }
                    else
                    {
                        ht.Add("DealerName", model.QryDealerName == null ? "" : model.QryDealerName);
                        ht.Add("DealerID", "");
                    }


                    ht.Add("ProductLine", model.QryProductLine==null?"": model.QryProductLine);
                    ht.Add("IsNewContract", model.IsNewContract==null?"" : model.IsNewContract);
                    ht.Add("ContractTypeName", "");

                    //ht.Add("CurrentPageIndex", model.CurrentPageIndex);
                    //ht.Add("PageSize", model.PageSize);
                    ht.Add("SubCompanyId", CurrentSubCompany?.Key);
                    ht.Add("BrandId", CurrentBrand?.Key);
                    Hashtable htbu = new Hashtable();
                    htbu.Add("SubCompanyId", CurrentSubCompany?.Key);
                    htbu.Add("BrandId", CurrentBrand?.Key);
                    model.QryList = JsonHelper.DataTableToArrayList(dao.SelectAllContractByApproved(ht).Tables[0]);
                    model.QryBUList = JsonHelper.DataTableToArrayList(dao.SelectBU(htbu).Tables[0]);


                    model.IsSuccess = true;
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
        public QueryView SelectClassContractByBU(QueryView model)
        {
            try
            {
                using (QueryDao dao = new QueryDao())
                {
                    model.QryClassContractList = JsonHelper.DataTableToArrayList(dao.SelectClassContractByBU(model.QryProductLine).Tables[0]);
                    model.IsSuccess = true;
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

        public QueryView SelectEffectStateById(QueryView model)
        {
            try
            {
                using (ContractMasterDao dao = new ContractMasterDao())
                {
                    model.QryEffectStateList = JsonHelper.DataTableToArrayList(dao.GetTakeEffectStateByContractID(new Guid(model.QryContractID)).Tables[0]);
                    model.IsSuccess = true;
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

        public QueryView CheckIfCanAuthorization(QueryView model)
        {
            try
            {
                #region 非设备经销商
                if (model.IptDealerType.ToString().Equals(DealerType.T1.ToString()) || model.IptDealerType.ToString().Equals(DealerType.LP.ToString()) || model.IptDealerType.ToString().Equals(DealerType.LS.ToString()))
                {
                    #region T1 LP 合同查看
                    if (RoleModelContext.Current.User.Roles.Contains(SR.Const_UserRole_ChannelOperation) || RoleModelContext.Current.User.Roles.Contains(SR.Const_UserRole_ContractQuery))
                    {
                        if (model.IptContractType.ToString().Equals("Appointment"))
                        {
                            if (RoleModelContext.Current.User.Roles.Contains(SR.Const_UserRole_ChannelOperation))
                            {
                                model.ShowAuthorization = true;
                            }
                        }
                        else if (model.IptContractType.ToString().Equals(ContractType.Amendment.ToString()))
                        {
                            if (RoleModelContext.Current.User.Roles.Contains(SR.Const_UserRole_ChannelOperation))
                            {
                                model.ShowAuthorization = true;
                            }
                        }
                        else if (model.IptContractType.ToString().Equals(ContractType.Renewal.ToString()))
                        {
                            if (RoleModelContext.Current.User.Roles.Contains(SR.Const_UserRole_ChannelOperation))
                            {
                                model.ShowAuthorization = true;
                            }
                        }
                        else if (model.IptContractType.ToString().Equals(ContractType.Termination.ToString()))
                        {
                            model.ShowAuthorization = false;
                        }
                    }
                    #endregion
                }
                else if (model.IptDealerType.ToString().Equals(DealerType.T2.ToString()))
                {
                    #region 二级经销商
                    if ((model.IptContractType.ToString().Equals(ContractType.Appointment.ToString())
                        || model.IptContractType.ToString().Equals(ContractType.Amendment.ToString())
                        || model.IptContractType.ToString().Equals(ContractType.Renewal.ToString()))
                        && RoleModelContext.Current.User.CorpType != null && RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()))
                    {
                        model.ShowAuthorization = true;
                    }
                    
                    #endregion
                }
                #endregion
               
                if (RoleModelContext.Current.User.Roles.Contains(SR.Const_UserRole_ContractQuery.ToString()))
                {
                    model.ShowAuthorization = false;
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

        public QueryView GetContractDetailInfo(QueryView model)
        {
            try
            {
                IContractAmendmentService _contAmendment = new ContractAmendmentService();
                IContractAppointmentService _contAppointment = new ContractAppointmentService();
                IContractRenewalService _renewal = new ContractRenewalService();
                IContractTerminationService _termination = new ContractTerminationService();
                if (model.IptContractType.ToString().Equals(ContractType.Appointment.ToString()))
                {
                    ContractAppointment ConApm = _contAppointment.GetContractAppointmentByID(new Guid(model.IptContractId.ToString()));
                    if (ConApm != null)
                    {
                        model.hidDealerId = ConApm.CapDmaId.ToString();
                        model.hidDealerName = ConApm.CapCompanyName;
                        model.hidEffectiveDate = ConApm.CapEffectiveDate;
                        model.hidExpirationDate = ConApm.CapExpirationDate;
                        model.hidSuBU = ConApm.CapSubdepId;

                    }
                }
                if (model.IptContractType.ToString().Equals(ContractType.Amendment.ToString()))
                {
                    ContractAmendment amendment = _contAmendment.GetContractAmendmentByID(new Guid(model.IptContractId.ToString()));
                    if (amendment != null)
                    {
                        model.hidDealerId = amendment.CamDmaId.ToString();
                        model.hidDealerName = amendment.CamDealerName;
                        model.hidEffectiveDate = amendment.CamAmendmentEffectiveDate;
                        model.hidExpirationDate = amendment.CamAgreementExpirationDate;
                        model.hidSuBU = amendment.CamSubDepid;
                    }
                }
                if (model.IptContractType.ToString().Equals(ContractType.Renewal.ToString()))
                {
                    ContractRenewal renewal = _renewal.GetContractRenewalByID(new Guid(model.IptContractId.ToString()));
                    if (renewal != null)
                    {
                        model.hidDealerId = renewal.CreDmaId.ToString();
                        model.hidDealerName = renewal.CreDealerName;
                        model.hidEffectiveDate = renewal.CreAgrmtEffectiveDateRenewal;
                        model.hidExpirationDate = renewal.CreAgrmtExpirationDateRenewal;
                        model.hidSuBU = renewal.CreSubDepid;
                    }
                }
                if (model.IptContractType.ToString().Equals(ContractType.Termination.ToString()))
                {
                    ContractTermination term = _termination.GetContractTerminationByID(new Guid(model.IptContractId.ToString()));
                    if (term != null)
                    {
                        model.hidDealerId = term.CteDmaId.ToString();
                        model.hidDealerName = term.CteDealerName;
                        model.hidSuBU = term.CteSubDepid;
                    }
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
        #region 电子合同查询
        public DataSet GetContractListByDealerId(Hashtable ht)
        {
            DataSet Ds = new DataSet();
            using (LPandT1Dao dao = new LPandT1Dao())
            {
                Ds = dao.GetContractListByDealerId(ht);
            }
            return Ds;
        }
        #endregion
    }
}
