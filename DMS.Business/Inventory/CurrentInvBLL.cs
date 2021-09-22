using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DMS.DataAccess;
using DMS.Model;
using DMS.Common;
using System.Data;
using System.Collections;
using Lafite.RoleModel.Security;
using DMS.Model.Data;

namespace DMS.Business
{
    public class CurrentInvBLL : ICurrentInvBLL
    {
        private IRoleModelContext _context = RoleModelContext.Current;

        public DataSet QueryCurrentInv(Hashtable table)
        {
            table.Add("WarehouseType", "SystemHold");
            table.Add("LotInvQtyMin", 0);
            BaseService.AddCommonFilterCondition(table);
            using (CurrentInvDao dao = new CurrentInvDao())
            {
                return dao.SelectByFilter(table);
            }
        }

        public DataSet QueryCurrentInvForShipmentOrder(Hashtable table)
        {
            table.Add("WarehouseType", "SystemHold");
            table.Add("LotInvQtyMin", 0);
            table.Add("DMAID", this._context.User.CorpId);

            //Edited By Song Yuqi On 2016-06-15
            DealerContracts dc = new DealerContracts();
            dc.GetDealerSpecialAuthByType(table, DealerAuthorizationType.Shipment
                    , new Guid(table["DealerId"].ToString())
                    , new Guid(table["ProductLine"].ToString()));

            using (CurrentInvDao dao = new CurrentInvDao())
            {
                return dao.SelectByFilterShipmentOrder(table);
            }
        }

        public DataSet QueryCurrentCTOSInv(Hashtable table)
        {
            table.Add("WarehouseType", "SystemHold");
            table.Add("LotInvQtyMin", 0);
            using (CurrentInvDao dao = new CurrentInvDao())
            {
                return dao.SelectCTOSByFilterAll(table);
            }
        }

        public DataSet QueryCurrentCfn(Hashtable table)
        {
            using (CurrentInvDao dao = new CurrentInvDao())
            {
                return dao.SelectCurrentCfnByDealer(table);
            }
        }

        public DataSet QueryCurrentCfn(Hashtable table, int start, int limit, out int totalRowCount)
        {
            using (CurrentInvDao dao = new CurrentInvDao())
            {
                return dao.SelectCurrentCfnByDealer(table, start, limit, out totalRowCount);
            }
        }

        public DataSet QueryCurrentSharedCfn(Hashtable table, int start, int limit, out int totalRowCount)
        {
            using (CurrentInvDao dao = new CurrentInvDao())
            {
                return dao.SelectCurrentSharedCfnByDealer(table, start, limit, out totalRowCount);
            }
        }

        public DataSet QueryCurrentInvByLotNumber(Hashtable table)
        {
            using (CurrentInvDao dao = new CurrentInvDao())
            {
                return dao.SelectCurrentInvByLotNumber(table);
            }
        }

        public DataSet QueryCurrentCfnProduct(Hashtable table, int start, int limit, out int totalRowCount)
        {
            using (CurrentInvDao dao = new CurrentInvDao())
            {
                return dao.SelectCurrentCfnProduct(table, start, limit, out totalRowCount);
            }
        }
        public DataSet QueryCurrentInvForShipmentOrderNoAuth(Hashtable table)
        {
            using (CurrentInvDao dao = new CurrentInvDao())
            {
                return dao.SelectByFilterShipmentOrderNoAuth(table);
            }
        }

        #region Added By Song Yuqi On 20140317
        public DataSet QueryCurrentInvForShipmentOrderByT2Consignment(Hashtable table)
        {
            table.Add("LotInvQtyMin", 0);
            //Edited By Song Yuqi On 2016-06-15
            DealerContracts dc = new DealerContracts();
            dc.GetDealerSpecialAuthByType(table, DealerAuthorizationType.Shipment
                    , new Guid(table["DealerId"].ToString())
                    , new Guid(table["ProductLine"].ToString()));

            using (CurrentInvDao dao = new CurrentInvDao())
            {
                return dao.SelectByFilterShipmentOrderByT2Consignment(table);
            }
        }

        public DataSet QueryCurrentInvForReturnByT2Consignment(Hashtable table)
        {
            table.Add("LotInvQtyMin", 0);
            using (CurrentInvDao dao = new CurrentInvDao())
            {
                return dao.SelectByFilterReturnByT2Consignment(table);
            }
        }


        public DataSet QueryCurrentInvForShipmentOrderAdjust(Hashtable table)
        {
            table.Add("WarehouseType", "SystemHold");
            table.Add("LotInvQtyMin", 0);
            using (CurrentInvDao dao = new CurrentInvDao())
            {
                return dao.SelectByFilterShipmentOrderAdjust(table);
            }
        }
        #endregion
    }
}
