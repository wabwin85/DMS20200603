using System;
using System.Collections.Generic;

namespace DMS.Business
{
    using Coolite.Ext.Web;
    using DMS.Model;
    using DMS.Common;
    using System.Data;
    using System.Collections;

    public interface IHospitals
    {
        Hospital GetObject(Guid hosId);

        IList<Hospital> SelectByFilter(Hospital hospital);
        IList<Hospital> SelectByFilter(Hospital hospital, int start, int limit, out int totalRowCount);
        DataSet SelectByFilter_DataSet(Hospital hospital, int start, int limit, out int totalRowCount);

        IList<Hospital> GetListByProductLine(Guid lineId);
        IList<Hospital> SelectByProductLine(Hospital hospital, ExistsState isCheckProductLine, Guid productLineId);
        IList<Hospital> SelectByProductLine(Hospital hospital, ExistsState isCheckProductLine, Guid productLineId, int start, int limit, out int totalRowCount);
        DataSet SelectByProductLine_DataSet(Hospital hospital, ExistsState isCheckProductLine, Guid productLineId,
            int start, int limit, out int totalRowCount);
        DataSet SelectByProductLineForDCMS(Hashtable hospital, int start, int limit, out int totalRowCount);

        IList<Hospital> GetListByProductLine(Guid lineId, string hosName);
        IList<Hospital> SelectByProductLine(Hospital hospital, ExistsState isCheckProductLine, Guid productLineId, string hosName);
        IList<Hospital> SelectByProductLine(Hospital hospital, ExistsState isCheckProductLine, Guid productLineId, string hosName, int start, int limit, out int totalRowCount);


        IList<Hospital> GetListBySales(Guid lineId, Guid saleId);
        IList<Hospital> SelectBySales(Hospital hospital, ExistsState isCheckSales, Guid lineId, Guid saleId);
        IList<Hospital> SelectBySales(Hospital hospital, ExistsState isCheckSales, Guid lineId, Guid saleId, int start, int limit, out int totalRowCount);

        IList<Hospital> SelectByAsAuthorization(Hospital hospital, Guid authorizationId, int start, int limit, out int totalRowCount);
        DataSet SelectByAsAuthorizationTemp(Hospital hospital, Guid authorizationId, DateTime EffectiveDate, string isEmerging, int start, int limit, out int totalRowCount);
        DataSet SelectByAsAuthorizationTemp(Hospital hospital, Guid authorizationId, DateTime EffectiveDate, string isEmerging);

        bool SaveHospitalOfSalesChanges(ChangeRecords<Hospital> data, Guid lineId, Guid saleId);
        bool SaveHospitalOfSales(Guid saleId, IDictionary<string, string>[] changes, SelectTerritoryType selectType, string hosProvince, string hosCity, string hosDistrict, Guid productLineId);
        bool SaveHospitalOfProductLineChanges(ChangeRecords<Hospital> data, Guid productLineId);
        IList<Hospital> SelectHospitalListOfDealerAuthorized(Hospital hospital, Guid DealerID, int start, int limit, out int totalRowCount);

        bool Insert(Hospital hospital);
        bool Update(Hospital hospital);
        bool Delete(Guid hospitalId);
        bool FakeDelete(Guid hospitalId);
        bool SaveChanges(ChangeRecords<Hospital> data);
        IList<LpHospitalData> QueryLPHospitalInfo(string batchNbr);

        IList<Hospital> QueryAuthorizationHospitalList(Hashtable table, int start, int limit, out int totalRowCount);
        DataSet GetAuthorizationHospitalList(Hashtable tb, int start, int limit, out int totalRowCount);
        DataSet GetAuthorizationHospitalListT1(Hashtable tb, int start, int limit, out int totalRowCount);

        bool ExistsHospitalCode(string keyAccount);
    }
}
