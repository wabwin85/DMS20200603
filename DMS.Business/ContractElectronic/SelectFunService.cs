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
using DMS.Model.ViewModel.ContractElectronic;
using System;

namespace DMS.Business.ContractElectronic
{
    public class SelectFunService : BaseService
    {

        public ContractDetailView SelectFunAppointmentByContractID(ContractDetailView model)
        {
            try
            {
                using (QueryDao dao = new QueryDao())
                {
                    DataSet ds = dao.SelectContractByContractId(model);
                    Hashtable ht = new Hashtable();
                    ht.Add("ContractType", model.ContractType);
                    ht.Add("DealerType", model.DealerType);
                    //无草稿，无提交的版本
                    if (model.DealerType == "T2")
                    {
                        if (ds.Tables[0].Rows.Count == 0 || ds.Tables[0].Rows[0]["VersionStatus"].ToString() == "Cancelled")
                        {
                            DataTable tb = dao.SelectFunAppointmentByContractID(model.ContractId).Tables[0];
                            model.ContractList = JsonHelper.DataTableToArrayList(tb);
                            model.DealerId = tb.Rows[0]["DealerId"].ToString();
                            ht.Add("ExportId", null);
                        }
                        else
                        {
                            model.ContractVerList = JsonHelper.DataTableToArrayList(ds.Tables[0]);
                            ht.Add("ExportId", ds.Tables[0].Rows[0]["ExportId"].ToString());
                        }

                    }
                    else
                    {
                        if (ds.Tables[0].Rows.Count == 0)
                        {
                            DataTable tb = dao.SelectFunAppointmentByContractID(model.ContractId).Tables[0];
                            model.ContractList = JsonHelper.DataTableToArrayList(tb);
                            model.DealerId = tb.Rows[0]["DealerId"].ToString();
                            ht.Add("ExportId", null);
                        }
                        else
                        {
                            model.ContractVerList = JsonHelper.DataTableToArrayList(ds.Tables[0]);
                            ht.Add("ExportId", ds.Tables[0].Rows[0]["ExportId"].ToString());
                        }
                    }
                    ht.Add("ProductlineId", model.DeptId);
                    ht.Add("DealerId", model.DealerId);
                    ht.Add("ContractId", model.ContractId);
                    model.ContractAttach = JsonHelper.DataTableToArrayList(dao.SelectExportTemplate(ht).Tables[0]);

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

        public ContractDetailView SelectFunAmendmentByContractID(ContractDetailView model)
        {

            try
            {
                using (QueryDao dao = new QueryDao())
                {

                    DataSet ds = dao.SelectContractByContractId(model);
                    Hashtable ht = new Hashtable();
                    ht.Add("ContractType", model.ContractType);
                    ht.Add("DealerType", model.DealerType);
                    //无草稿，无提交的版本


                    if (ds.Tables[0].Rows.Count == 0)
                    {
                        model.ContractList = JsonHelper.DataTableToArrayList(dao.SelectFunAmendmentByContractID(model.ContractId).Tables[0]);
                        ht.Add("ExportId", null);
                    }
                    else
                    {
                        model.ContractVerList = JsonHelper.DataTableToArrayList(ds.Tables[0]);
                        ht.Add("ExportId", ds.Tables[0].Rows[0]["ExportId"].ToString());
                    }


                    ht.Add("DealerId", model.DealerId);
                    ht.Add("ContractId", model.ContractId);
                    model.ContractAttach = JsonHelper.DataTableToArrayList(dao.SelectExportTemplate(ht).Tables[0]);
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

        public ContractDetailView SelectFunRenewalByContractID(ContractDetailView model)
        {

            try
            {
                using (QueryDao dao = new QueryDao())
                {
                    DataSet ds = dao.SelectContractByContractId(model);
                    Hashtable ht = new Hashtable();
                    ht.Add("ContractType", model.ContractType);
                    ht.Add("DealerType", model.DealerType);
                    //无草稿，无提交的版本
                    if (model.DealerType=="T2") {
                        if (ds.Tables[0].Rows.Count == 0|| ds.Tables[0].Rows[0]["VersionStatus"].ToString() == "Cancelled")
                        {
                            DataTable tb = dao.SelectFunRenewalByContractID(model.ContractId).Tables[0];
                            model.ContractList = JsonHelper.DataTableToArrayList(tb);
                            model.DealerId = tb.Rows[0]["DealerId"].ToString();
                            ht.Add("ExportId", null);
                        }
                        else
                        {
                            model.ContractVerList = JsonHelper.DataTableToArrayList(ds.Tables[0]);
                            ht.Add("ExportId", ds.Tables[0].Rows[0]["ExportId"].ToString());
                        }
                    }
                    else
                    {
                        if (ds.Tables[0].Rows.Count == 0)
                        {
                            DataTable tb = dao.SelectFunRenewalByContractID(model.ContractId).Tables[0];
                            model.ContractList = JsonHelper.DataTableToArrayList(tb);
                            model.DealerId = tb.Rows[0]["DealerId"].ToString();
                            ht.Add("ExportId", null);
                        }
                        else
                        {
                            model.ContractVerList = JsonHelper.DataTableToArrayList(ds.Tables[0]);
                            ht.Add("ExportId", ds.Tables[0].Rows[0]["ExportId"].ToString());
                        }
                    }
                    
                    ht.Add("ProductlineId", model.DeptId);
                    ht.Add("DealerId", model.DealerId);
                    ht.Add("ContractId", model.ContractId);
                    model.ContractAttach = JsonHelper.DataTableToArrayList(dao.SelectExportTemplate(ht).Tables[0]);
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

        public ContractDetailView SelectFunTerminationByContractID(ContractDetailView model)
        {

            try
            {
                using (QueryDao dao = new QueryDao())
                {

                    DataSet ds = dao.SelectContractByContractId(model);
                    Hashtable ht = new Hashtable();
                    //string DealerID = "";
                    string AgreementBegin = "";
                    string AgreementEnd = "";
                    ht.Add("ContractType", model.ContractType);
                    ht.Add("DealerType", model.DealerType);
                    //无草稿，无提交的版本
                    if (ds.Tables[0].Rows.Count == 0)
                    {
                        DataSet dst = dao.SelectFunTerminationByContractID(model.ContractId);
                        model.ContractList = JsonHelper.DataTableToArrayList(dao.SelectFunTerminationByContractID(model.ContractId).Tables[0]);
                        ht.Add("ExportId", null);
                        model.DealerId = dst.Tables[0].Rows[0]["DealerId"].ToString();
                        AgreementBegin = dst.Tables[0].Rows[0]["AgreementBegin"].ToString();
                        AgreementEnd = dst.Tables[0].Rows[0]["AgreementEnd"].ToString();
                        //model.ContractDate = Convert.ToDateTime(dao.GetFunGC_Fn_GetContractDate(DealerID, AgreementBegin, AgreementEnd).Tables[0].Rows[0][0]);
                    }
                    else
                    {
                        model.ContractVerList = JsonHelper.DataTableToArrayList(ds.Tables[0]);
                        ht.Add("ExportId", ds.Tables[0].Rows[0]["ExportId"].ToString());

                    }


                    ht.Add("ProductlineId", model.DeptId);
                    ht.Add("DealerId", model.DealerId);
                    ht.Add("ContractId", model.ContractId);
                    model.ContractAttach = JsonHelper.DataTableToArrayList(dao.SelectExportTemplate(ht).Tables[0]);
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

        public ContractDetailView SelectAttach(ContractDetailView model)
        {
            try
            {
                using (QueryDao dao = new QueryDao())
                {
                    Hashtable ht = new Hashtable();
                    ht.Add("ContractType", model.ContractType);
                    ht.Add("DealerType", model.DealerType);
                    ht.Add("ExportId", model.SelectExportId);
                    ht.Add("ProductlineId", model.DeptId);
                    ht.Add("DealerId", model.DealerId);
                    ht.Add("ContractId", model.ContractId);
                    model.ContractAttach = JsonHelper.DataTableToArrayList(dao.SelectExportTemplate(ht).Tables[0]);
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
    }
}
