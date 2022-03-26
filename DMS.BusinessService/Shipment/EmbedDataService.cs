using DMS.Business;
using DMS.BusinessService.Util.DealerFilter;
using DMS.BusinessService.Util.DealerFilter.Impl;
using DMS.Common;
using DMS.Common.Common; 
using DMS.ViewModel.Shipment.Extense;
using Lafite.RoleModel.Security;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace DMS.BusinessService.Shipment
{
    public class EmbedDataService : ABaseQueryService, IDealerFilterFac
    {
        private IRoleModelContext _context = RoleModelContext.Current;
        public ADealerFilter CreateDealerFilter()
        {
            return new AllDealerFilter();
        }

        public EmbedDataModelVO Init(EmbedDataModelVO model)
        {
            return model;
        }

        public string Query(EmbedDataModelVO model)
        {
            try
            {
                Hashtable ht = new Hashtable();
                int totalCount = 0;
                if(model.SelAccountYear != null && model.SelAccountYear.Key != "" && model.SelAccountYear.Key != "全部")
                {
                    ht.Add("AccountYear",model.SelAccountYear.Key);
                }
                if(null != model.SelAccountMonth && model.SelAccountMonth.Key != "" && model.SelAccountMonth.Key != "全部")
                {
                    ht.Add("AccountMonth", model.SelAccountMonth.Key);
                }
                if (null != model.SelSubCompany&& model.SelSubCompany.Key != "" && model.SelSubCompany.Key != "全部")
                {
                    ht.Add("SubCompany",model.SelSubCompany.Key);
                }
                int start = (model.Page - 1) * model.PageSize;
                ht.Add("start", start);
                ht.Add("limit", model.PageSize);

                IEmbedDataBLL business = new EmbedDataBLL();
                DataSet ds = business.QueryEmbedData(ht, start, model.PageSize, out totalCount);
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
            var data = new { data = model.RstResultList, total = model.DataCount };
            var result = new { success = model.IsSuccess, data = data };
            return JsonHelper.Serialize(result);
        }
    }
}
