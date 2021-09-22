using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections;


namespace DMS.Business
{
    using DMS.Model;

    public interface IInventories
    {
        //Inventory GetWarehouse(Guid Id);
        //IList<Warehouse> QueryForWarehouse(Warehouse warehouse);
        //IList<Warehouse> QueryForWarehouse(Warehouse warehouse, int start, int limit, out int totalRowCount);
    }

    public interface ILots
    {
        IList<Lot> SelectLotsByLotMasterAndWarehouse(Hashtable ht);
        Lot GetLot(Guid Id);
        bool Insert(Lot lot);
        bool Update(Lot lot);
        bool UpdateLotWithLotMasterWarehouseAndQty(Hashtable ht);
        bool UpdateLotWithQty(Hashtable ht);
        bool Delete(Lot lot);
        IList<Lot> SelectByFilter(Lot lot);
    }

    public interface IInventoryTransactions
    {
    }

    public interface IInventoryTransactionLots
    {

    }

    public interface ILotMasters
    {

    }
}