using System;
using System.Data;
using System.Collections;
namespace DMS.Business
{
    public interface ICurrentInvBLL
    {
        DataSet QueryCurrentInv(Hashtable table);
        DataSet QueryCurrentCfn(Hashtable table);
        DataSet QueryCurrentCfn(Hashtable table, int start, int limit, out int totalRowCount);
        DataSet QueryCurrentSharedCfn(Hashtable table, int start, int limit, out int totalRowCount);
        DataSet QueryCurrentInvByLotNumber(Hashtable table);
        DataSet QueryCurrentInvForShipmentOrder(Hashtable table);
        DataSet QueryCurrentCfnProduct(Hashtable table, int start, int limit, out int totalRowCount);
        DataSet QueryCurrentInvForShipmentOrderNoAuth(Hashtable table);
        DataSet QueryCurrentCTOSInv(Hashtable table);

        #region Added By Song Yuqi On 20140317
        DataSet QueryCurrentInvForShipmentOrderByT2Consignment(Hashtable table);
        DataSet QueryCurrentInvForReturnByT2Consignment(Hashtable table);
        DataSet QueryCurrentInvForShipmentOrderAdjust(Hashtable table);
        #endregion
    }
}
