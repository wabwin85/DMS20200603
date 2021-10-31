using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using DMS.DataAccess;
using Grapecity.DataAccess.Transaction;
using DMS.DataAccess.MasterData;
using DMS.Model;
using DMS.ViewModel.MasterDatas.Extense;
using DMS.Business.MasterData;
using DMS.Common;
using DMS.Common.Common;
using Newtonsoft.Json;

namespace DMS.BusinessService.MasterDatas
{
    public class InvGoodsCfgImportService: ABaseQueryService
    {
        #region Ajax Method 

        public InvGoodsCfgInitVO Init(InvGoodsCfgInitVO model)
        {
            try
            {

            }
            catch(Exception ex)
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
                    InvGoodsCfgImportDao dao = new InvGoodsCfgImportDao();
                    dao.DeleteInvGoodsCfgImportByUser(UserInfo.Id);

                    int lineNbr = 1;
                    IList<InvGoodsCfgInit> list = new List<InvGoodsCfgInit>();
                    foreach(DataRow dr in dt.Rows)
                    {
                        InvGoodsCfgInit data = new InvGoodsCfgInit();
                        data.Id = Guid.NewGuid();
                        data.ImportUser = new Guid(UserInfo.Id);
                        data.ImportDate = DateTime.Now;
                        
                        data.SubCompanyName = dr[0] == DBNull.Value ? null : dr[0].ToString();
                        if (string.IsNullOrEmpty(data.SubCompanyName))
                            data.ErrorMsg += "分子公司为空";
                        data.BrandName = dr[1] == DBNull.Value ? null : dr[1].ToString();
                        if (string.IsNullOrEmpty(data.BrandName))
                            data.ErrorMsg += "品牌为空";
                        data.ProductLine = dr[2] == DBNull.Value ? null : dr[2].ToString();
                        if (string.IsNullOrEmpty(data.ProductLine))
                            data.ErrorMsg += "产品线为空";
                        data.QryCFN = dr[3] == DBNull.Value ? null : dr[3].ToString();
                        if (string.IsNullOrEmpty(data.QryCFN))
                            data.ErrorMsg += "产品型号为空";
                        data.ProductNameCN = dr[4] == DBNull.Value ? null : dr[4].ToString();
                        if (string.IsNullOrEmpty(data.ProductNameCN))
                            data.ErrorMsg += "产品中文名称为空";
                        data.InvType = dr[5] == DBNull.Value ? null : dr[5].ToString();
                        if (string.IsNullOrEmpty(data.InvType))
                            data.ErrorMsg += "发票规格型号为空";
                        if (lineNbr != 1)
                        {
                            if (string.IsNullOrEmpty(data.ErrorMsg))
                            {
                                data.ErrorMsg = "";
                            }
                            else
                                data.IsError = true;
                            list.Add(data);
                        }
                        lineNbr += 1;

                    }
                    dao.BatchInsert(list);
                    result = true;
                    trans.Complete();

                   
                }
                using (InvGoodsCfgImportDao dao = new InvGoodsCfgImportDao())
                {
                    DataSet ds = dao.GetInvGoodsCfgInitCheckData(new Guid(UserInfo.Id));
                    if (ds.Tables[0].Rows.Count > 0)
                    {
                        dao.UpdateInvGoodsCfgImportValid(ds.Tables[0]);
                        result = false;
                    }
                }

            }
            catch(Exception ex)
            {

            }

            return result;
        }

        public bool VerifyInvGoodsCfgImport(string importType, out string IsValid)
        {
            bool result = false;
            using (InvGoodsCfgImportDao dao = new InvGoodsCfgImportDao())
            {
                IsValid = dao.InitializeInvGoodsInitImport(importType, new Guid(UserInfo.Id));
                result = true;
            }
            return result;
        }

        public string Query(InvGoodsCfgInitVO model)
        {
            try
            {
                InvGoodsCfgImportBLL business = new InvGoodsCfgImportBLL();

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

        #endregion
    }
}
