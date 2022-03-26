using DMS.Common.Common;
using DMS.ViewModel.MasterDatas.Extense;
using System;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Grapecity.DataAccess.Transaction;
using DMS.DataAccess.MasterData;
using DMS.Model;
using DMS.Business.MasterData;
using DMS.Common;
using Newtonsoft.Json;

namespace DMS.BusinessService.MasterDatas
{
    public class InvHospitalImportService: ABaseQueryService
    {
        public InvHospitalCfgInitVO Init(InvHospitalCfgInitVO model)
        {
            try
            {

            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public bool ImportTemp(DataTable dt, out bool isError)
        {
            System.Diagnostics.Debug.WriteLine("Import Start : " + DateTime.Now.ToString());
            bool result = false;
            isError = false;
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    InvHospitalCfgImportDao dao = new InvHospitalCfgImportDao();
                    dao.DeleteHospitalCfgImportByUser(UserInfo.Id);

                    int lineNbr = 1;
                    IList<InvHospitalCfgInit> list = new List<InvHospitalCfgInit>();
                    if(dt.Rows.Count>0)
                    {
                        foreach(DataRow dr in dt.Rows)
                        {
                            InvHospitalCfgInit data = new InvHospitalCfgInit();
                            data.Id = Guid.NewGuid();
                            data.ImportUser = new Guid(UserInfo.Id);
                            data.ImportDate = DateTime.Now;

                            //data.SubCompanyName = dr[0] == DBNull.Value ? null : dr[0].ToString();
                            //if (string.IsNullOrEmpty(data.SubCompanyName))
                            //    data.ErrorMsg += "分子公司为空";
                            //data.BrandName = dr[1] == DBNull.Value ? null : dr[1].ToString();
                            //if (string.IsNullOrEmpty(data.BrandName))
                            //    data.ErrorMsg += "品牌为空";
                            data.DMSHospitalName = dr[0] == DBNull.Value ? null : dr[0].ToString();
                            if (string.IsNullOrEmpty(data.DMSHospitalName))
                                data.ErrorMsg += "DMS医院名称为空";
                            data.InvHospitalName = dr[1] == DBNull.Value ? null : dr[1].ToString();
                            if (string.IsNullOrEmpty(data.InvHospitalName))
                                data.ErrorMsg += "发票医院名称为空";
                            data.Hos_Code = dr[2] == DBNull.Value ? null : dr[2].ToString();
                            if (string.IsNullOrEmpty(data.Hos_Code))
                                data.ErrorMsg += "医院Code为空"; 
                            data.Province = dr[4] == DBNull.Value ? null : dr[4].ToString();
                            data.City = dr[5] == DBNull.Value ? null : dr[5].ToString();
                            data.District = dr[6] == DBNull.Value ? null : dr[6].ToString();
                            if (lineNbr != 1)
                            {
                                if (string.IsNullOrEmpty(data.ErrorMsg))
                                {
                                    data.ErrorMsg = "";
                                }
                                else
                                {
                                    data.IsError = true;
                                    isError = true;
                                }
                                list.Add(data);
                            }
                            lineNbr += 1;

                        }
                    }
                    dao.BatchInsert(list);
                    result = true;
                    trans.Complete();
                }
                bool tag = IsExistsInvHospitalImport();
                if (tag)
                    result = false;
            }
            catch(Exception ex)
            {
                result = false;
            }
            return result;
        }

        private bool IsExistsInvHospitalImport()
        {
            bool result = false;
            using (InvHospitalCfgImportDao dao = new InvHospitalCfgImportDao())
            {
                DataSet ds = dao.GetInvHospitalCfgInitCheckData(new Guid(UserInfo.Id));
                if (ds.Tables[0].Rows.Count > 0)
                {
                    //data.ErrorMsg += "发票规格型号为空"; 
                    dao.UpdateInvHospitalCfgImportValid(ds.Tables[0]);
                    result = true;
                }
            }
            return result;
        }

        public string Query(InvHospitalCfgInitVO model)
        {
            try
            {
                IInvHospitalCfgImportBLL business = new InvHospitalCfgImportBLL();

                int outCont = 0;
                int start = (model.Page - 1) * model.PageSize;
                DataSet ds = business.QueryErrorData(start, model.PageSize, out outCont);
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

        public InvHospitalCfgInitVO InvHospitalCfgImportToDB(InvHospitalCfgInitVO model)
        {
            InvHospitalImportService business = new InvHospitalImportService();
            string IsValid = string.Empty;
            bool tag = InvHospitalCfgImport("Import", out IsValid);
            if (tag)
            {
                //var lstresult = new { result = "Success", msg = "上传数据成功" };
                //HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));
                model.IsSuccess = true;
                model.Msg = "上传数据成功";
            }
            else
            {
                //var lstresult = new { result = "Failed", msg = "上传数据失败，请检查原因" };
                //HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));
                model.IsSuccess = false;
                model.Msg = "上传数据失败，请管理员检查原因";
            }
            return model;
        }

        public bool InvHospitalCfgImport(string importType, out string IsValid)
        {
            bool result = false;
            DeleteDuplicateInvRecords();

            using (InvHospitalCfgImportDao dao = new InvHospitalCfgImportDao())
            {
                IsValid = dao.InitializeInvHospitalInitImport(importType, new Guid(UserInfo.Id));
                result = true;
            }
            return result;
        }

        private void DeleteDuplicateInvRecords()
        {
            using (InvHospitalCfgImportDao dao = new InvHospitalCfgImportDao())
            {
                DataSet ds = dao.GetInvHospitalCfgInitCheckData(new Guid(UserInfo.Id));
                if (ds.Tables[0].Rows.Count > 0)
                {
                    for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                        dao.DeleteInvHospitalCfg(new Guid(ds.Tables[0].Rows[i]["InvHospitalCfgId"].ToString()));
                }
            }
        }
    }
}
