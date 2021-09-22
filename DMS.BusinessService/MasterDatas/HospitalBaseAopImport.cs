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
using Grapecity.DataAccess.Transaction;
using DMS.Model;
using System.Collections.Generic;

namespace DMS.BusinessService.MasterDatas
{
    public class HospitalBaseAopImportService : ABaseQueryService
    {
        #region Ajax Method

        public HospitalBaseAopImportVO Init(HospitalBaseAopImportVO model)
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

        

        public bool Import(DataTable dt)
        {
            System.Diagnostics.Debug.WriteLine("Import Start : " + DateTime.Now.ToString());
            bool result = false;
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    AOPHospitalReferenceDao dao = new AOPHospitalReferenceDao();
                    //删除上传人的数据
                    dao.DeleteAOPHospitalReferencesImportByUser(UserInfo.Id);

                    int lineNbr = 1;
                    IList<AOPHospitalReferenceImport> list = new List<AOPHospitalReferenceImport>();
                    foreach (DataRow dr in dt.Rows)
                    {
                        //string errString = string.Empty;
                        AOPHospitalReferenceImport data = new AOPHospitalReferenceImport();
                        data.Id = Guid.NewGuid();
                        data.UpdateUserId = new Guid(UserInfo.Id);
                        data.UpdateDate = DateTime.Now;

                        //分子公司
                        data.SubCompanyName = dr[0] == DBNull.Value ? null : dr[0].ToString();
                        if (string.IsNullOrEmpty(data.SubCompanyName))
                            data.ErrMassage += "分子公司为空";

                        //价格
                        data.BrandName = dr[1] == DBNull.Value ? null : dr[1].ToString();
                        if (string.IsNullOrEmpty(data.BrandName))
                        {
                            data.ErrMassage += "品牌为空";
                        }
                        data.ProductLineName = dr[2] == DBNull.Value ? null : dr[2].ToString();
                        if (string.IsNullOrEmpty(data.ProductLineName))
                            data.ErrMassage += "产品线为空";
                        data.PCTName = dr[3] == DBNull.Value ? null : dr[3].ToString();

                        //省份
                        data.Year = dr[4] == DBNull.Value ? null : dr[4].ToString();

                        //城市
                        data.HospitalName = dr[5] == DBNull.Value ? null : dr[5].ToString();

                        //开始时间
                        data.HospitalNbr = dr[6] == DBNull.Value ? null : dr[6].ToString();

                        string strqty = "";
                        //1月份指标
                        strqty = dr[7] == DBNull.Value ? null : dr[7].ToString();
                        data.January = GetCurrentValue(data, strqty, "1");
                        //2月份指标
                        strqty = dr[8] == DBNull.Value ? null : dr[8].ToString();
                        data.February = GetCurrentValue(data, strqty, "2");
                        //3月份指标
                        strqty = dr[9] == DBNull.Value ? null : dr[9].ToString();
                        data.March = GetCurrentValue(data, strqty, "3");
                        //4月份指标
                        strqty = dr[10] == DBNull.Value ? null : dr[10].ToString();
                        data.April = GetCurrentValue(data, strqty, "4");
                        //5月份指标
                        strqty = dr[11] == DBNull.Value ? null : dr[11].ToString();
                        data.May = GetCurrentValue(data, strqty, "5");
                        //6月份指标
                        strqty = dr[12] == DBNull.Value ? null : dr[12].ToString();
                        data.June = GetCurrentValue(data, strqty, "6");
                        //7月份指标
                        strqty = dr[13] == DBNull.Value ? null : dr[13].ToString();
                        data.July = GetCurrentValue(data, strqty, "7");
                        //8月份指标
                        strqty = dr[14] == DBNull.Value ? null : dr[14].ToString();
                        data.August = GetCurrentValue(data, strqty, "8");
                        //9月份指标
                        strqty = dr[15] == DBNull.Value ? null : dr[15].ToString();
                        data.September = GetCurrentValue(data, strqty, "9");
                        //10月份指标
                        strqty = dr[16] == DBNull.Value ? null : dr[16].ToString();
                        data.October = GetCurrentValue(data, strqty, "10");
                        //11月份指标
                        strqty = dr[17] == DBNull.Value ? null : dr[17].ToString();
                        data.November = GetCurrentValue(data, strqty, "11");
                        //12月份指标
                        strqty = dr[18] == DBNull.Value ? null : dr[18].ToString();
                        data.December = GetCurrentValue(data, strqty, "12");

                        data.IsDelete = dr[19] == DBNull.Value ? null : dr[19].ToString();
                        if (lineNbr != 1)
                        {
                            if (string.IsNullOrEmpty(data.ErrMassage))
                            {
                                data.ErrMassage = "";
                            }
                            list.Add(data);
                        }
                        lineNbr += 1;
                    }
                    dao.BatchInsert(list);
                    result = true;

                    trans.Complete();
                }
            }
            catch (Exception ex)
            {

            }
            System.Diagnostics.Debug.WriteLine("Import Finish : " + DateTime.Now.ToString());

            return result;
        }
        private double GetCurrentValue(AOPHospitalReferenceImport data,string strqty, string msg)
        {
            if (!string.IsNullOrEmpty(strqty))
            {
                double qty;
                if (!Double.TryParse(strqty, out qty))
                    data.ErrMassage += msg + "月份指标格式不正确";
                else if (Double.Parse(strqty) < 0)
                    data.ErrMassage += msg + "月份指标不能小于0";
                else
                {
                    data.January = qty;
                }
                return qty;
            }
            else
            {
                data.January = 0;
                return 0;
            }
        }
        public bool VerifyAopHospitalReferenceImport(string importType, out string IsValid)
        {
            bool result = false;
            //调用存储过程验证数据
            using (AOPHospitalReferenceDao dao = new AOPHospitalReferenceDao())
            {
                IsValid = dao.InitializeAopHospitalReferenceImport(importType, new Guid(UserInfo.Id));
                result = true;
            }
            return result;
        }

        #endregion
    }


}
