using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using DMS.Business;
using DMS.Business.Cache;
using DMS.BusinessService.Util.DealerFilter;
using DMS.BusinessService.Util.DealerFilter.Impl;
using DMS.Common;
using DMS.Common.Common;
using DMS.Common.Extention;
using DMS.Model;
using DMS.Model.Data;
using DMS.ViewModel.Common;
using DMS.ViewModel.Order;
using Lafite.RoleModel.Security;
using DMS.ViewModel.MasterDatas;
using System.Collections;
using DMS.Business.MasterData;
using System.Collections.Specialized;
using DMS.Business.Excel;
using DMS.ViewModel.MasterDatas.Extense;

namespace DMS.BusinessService.MasterDatas
{
     public class InvGoodsCfgService: ABaseQueryService, IQueryExport
    {
        #region Ajax method
        private IInvGoodsCfgBLL business = new InvGoodsCfgBLL();
        IRoleModelContext _context = RoleModelContext.Current;

        public InvGoodsCfgVO Init(InvGoodsCfgVO model)
        {
            try
            {
                model.LstBu = base.GetProductLine();
                model.IsDealer = IsDealer; 
            } 
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }
       
        public string Query(InvGoodsCfgVO model)
        {
            try
            {
                Hashtable param = new Hashtable();
                if(!string.IsNullOrEmpty(model.QryBu.ToSafeString()))
                {
                    if(model.QryBu.Value!="全部" && model.QryBu.Key != "")
                        param.Add("ProductLine", model.QryBu.Value);
                } 
                if (!string.IsNullOrEmpty(model.QryCFN.ToSafeString()))
                {
                    param.Add("QryCFN", model.QryCFN);
                }
                if (!string.IsNullOrEmpty(model.ProductNameCN.ToSafeString()))
                {
                    param.Add("ProductNameCN", model.ProductNameCN);
                }
                if (!string.IsNullOrEmpty(model.InvType.ToSafeString()))
                {
                    param.Add("InvType", model.InvType);
                }
                int totalCount = 0;
                int start = (model.Page - 1) * model.PageSize;
                DataSet ds = business.QueryInvGoodsCfg(param, start, model.PageSize, out totalCount);
                model.RstResultList = JsonHelper.DataTableToArrayList(ds.Tables[0]);

                model.DataCount = totalCount;
                model.IsSuccess = true;

            }
            catch(Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            var data = new {data = model.RstResultList, total =model.DataCount };
            var result = new { success = model.IsSuccess, data = data };
            return JsonHelper.Serialize(result);
        }

        public InvGoodsCfgVO Delete(InvGoodsCfgVO model)
        {
            bool tag = false;
            try
            {
                if (model.DeleteSeleteID.Count > 0)
                {
                    IInvGoodsCfgBLL business = new InvGoodsCfgBLL();
                    for (int i = 0; i < model.DeleteSeleteID.Count; i++)
                    {
                        Guid id = new Guid(model.DeleteSeleteID[i]);
                        tag = business.Delete(id);
                        model.IsSuccess = true;
                    }
                }
            }
            catch(Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message); 
            }
            return model;
        }

        #endregion

        #region 下载
        public void Export(NameValueCollection Parameters, string DownloadCookie)
        {
            Hashtable param = new Hashtable();
            if (!string.IsNullOrEmpty(Parameters["Bu"].ToSafeString()))
            {
                param.Add("ProductLine", Parameters["Bu"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["QryCFN"].ToSafeString()))
            {
                param.Add("QryCFN", Parameters["QryCFN"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["ProductNameCN"].ToSafeString()))
            {
                param.Add("ProductNameCN", Parameters["ProductNameCN"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["InvType"].ToSafeString()))
            {
                param.Add("InvType", Parameters["InvType"].ToSafeString());
            }
            DataSet ds = business.QueryInvGoodsCfgForExport(param);
            //DataSet ds = null;
            DataSet dsExport = new DataSet("发票商品映射表");

            if (ds != null)
            {
                DataTable dt = ds.Tables[0]; 
                DataTable dtData = dt.Copy(); 

                if(null != dtData)
                {
                    Dictionary<string, string> dict = new Dictionary<string, string>
                        {
                            {"QryBu", "产品线"},
                            {"QryCFN", "产品型号"},
                            {"ProductNameCN", "产品中文名称"},
                            {"InvType", "发票规格型号"}
                        };

                    CommonFunction.SetColumnIndexAndRemoveColumn(dtData, dict);
                    dsExport.Tables.Add(dtData);
                }

                ExportFile(dsExport, DownloadCookie);
            }
        }

        protected void ExportFile(DataSet ds, string Cookie)
        {
            DataSet[] result = new DataSet[1];
            result[0] = ds;

            Hashtable ht = new Hashtable();
            XlsExport xlsExport = new XlsExport("ExportFile");
            xlsExport.Export(ht, result, Cookie);
        }

        #endregion
    }
}
