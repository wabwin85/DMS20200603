using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Business
{
    using DMS.Model;
    using Coolite.Ext.Web;
    using System.Collections;

    public interface IWarehouses
    {
        Warehouse GetWarehouse(Guid Id);
        IList<Warehouse> QueryForWarehouse(Warehouse warehouse);
        IList<Warehouse> QueryForWarehouse(Warehouse warehouse, int start, int limit, out int totalRowCount);
        IList<Warehouse> GetWarehousesByHashtable(System.Collections.Hashtable hashtable);
        IList<Warehouse> GetWarehousesByHashtable(System.Collections.Hashtable hashtable, int start, int limit, out int totalRowCount);
        IList<Warehouse> GetAllWarehouseByDealer(Guid DealerId);
        bool SaveChanges(ChangeRecords<Warehouse> data);
        bool emptyWarehouse(Guid warehouseId);
        bool duplicateWarehouseName(Hashtable table);
        void ImportInterfaceWarehouse(IList<InterfaceWarehouse> list);

        bool DuplicateWarehouseCode(string code);

        bool DuplicateWarehouseNameUpdate(Hashtable table);

        bool DuplicateWarehouseCodeUpdate(string p);

        System.Data.DataSet GetWarehousesForExport(Hashtable hashtable);
    }
}
