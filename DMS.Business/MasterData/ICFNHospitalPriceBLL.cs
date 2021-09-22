using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Business
{
    using Coolite.Ext.Web;
    using DMS.DataAccess;
    using DMS.Model;
    using System.Collections;
    using DMS.Common;

    public interface ICFNHospitalPriceBLL
    {
        IList<CfnHospitalPrice> SelectByFilter(Hashtable obj, int start, int limit, out int totalRowCount);
        IList<Hospital> getHospitalList(Guid lineId, IDictionary<string, string>[] changes, SelectTerritoryType selectType, string hosProvince, string hosCity, string hosDistrict);
        bool SaveChanges(ChangeRecords<CfnHospitalPrice> data, Guid ProductLineID, Guid CFN_ID);
        bool SaveChanges(ChangeRecords<CfnHospitalPrice> data);
    }
}
