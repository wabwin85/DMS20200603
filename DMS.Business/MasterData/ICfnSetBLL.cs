using System;
using System.Collections.Generic;

namespace DMS.Business
{
    using Coolite.Ext.Web;
    using DMS.Model;
    using System.Data;
    using System.Collections;

    public interface ICfnSetBLL
    {        
        bool Insert(CfnSet cfnSet);
        //bool Update(CfnSet cfnSet);
        //bool Delete(Guid Id);
        //bool FakeDelete(Guid Id);
        //bool SaveChanges(ChangeRecords<CfnSet> data);
        DataSet QueryDataByFilterConsignmentCfnSet(Hashtable table, int start, int limit, out int totalRowCount);
        DataSet QueryDataByFilterCfnSet(Hashtable table, int start, int limit, out int totalRowCount);
        DataSet QueryCfnSetDetailByCFNSID(Guid CFNSID, int start, int limit, out int totalRowCount);
        bool SaveCfnSet(ChangeRecords<CfnSetDetail> detailData, CfnSet mainData);
        bool SaveCfnSet(ChangeRecords<CfnSet> mainData);
        bool SaveMainData(CfnSet mainData);
        IList<CfnSet> QueryCfnSetByID(String Id);

        //added by bozhenfei on 20110217
        DataSet QueryCfnSetForPurchaseOrderByAuth(Hashtable table, int start, int limit, out int totalRowCount);
        DataSet QueryCFNSetDetailForPurchaseOrderByAuth(Hashtable table, int start, int limit, out int totalRowCount);
        //end
        //added by bozhenfei on 2015125
        DataSet QueryConsignmenCfnSetDetailByCFNSID(string CFNSId, int start, int limit, out int totalRowCount);

    }
}
