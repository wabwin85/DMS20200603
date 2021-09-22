using System;
using System.Collections.Generic;
using System.Data;
using System.Collections;
namespace DMS.Business
{
    public interface IAopDealerBLL
    {
        DMS.Model.AopDealer GetAopDealerByKey(Guid id);

        bool RemoveAopDealers(Guid dmaId, Guid prodLineId, string year);

        bool SaveAopDealers(IList<DMS.Model.AopDealer> aopDealers);

        bool SaveAopDealers(DMS.Model.VAopDealer aopDealers);

        DataSet GetAopDealersByQuery(Guid? dmaId, Guid? prodLineId, string year, int start, int limit, out int totalCount);
        DataSet ExportAop(Hashtable obj);
        DataSet ExportHospitalAop(Hashtable obj);
        DataSet ExportHospitalProductAop(Hashtable obj);

        DataSet GetAopDealersByFiller(Hashtable obj, int start, int limit, out int totalCount);
        DataSet ExporAopDealersByFiller(Hashtable obj);

        DataSet GetHospitalProductFiller(Hashtable obj, int start, int limit, out int totalCount);
        DataSet ExportHospitalProductFiller(Hashtable obj);

        DMS.Model.VAopDealer GetYearAopDealers(Guid dmaId, Guid prodLineId, string year);

        double? GetDealerCurrentQAop(Guid dmaId, Guid prodLineId);

        double GetDealerCurrentQAmount(Guid dmaId, Guid prodLineId);
    }
}
