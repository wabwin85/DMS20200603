using System;
using System.Collections;
using System.Collections.Generic;
using IBatisNet.DataMapper;
using DMS.Model;
using System.Data;
using DMS.Model.Consignment;
using Lafite.RoleModel.Security;

namespace DMS.DataAccess.Consignment
{
    public class ConsignInventoryAdjustHeaderDao : BaseSqlMapDao
    {
        public ConsignInventoryAdjustHeaderDao()
            : base()
        {
        }

        private IRoleModelContext _context = RoleModelContext.Current;
        public DataTable SelectConsignContractList(string ProductLine, string Dealer, string Type, string StartDate, string EndDate, string ApplyNo, string Status, string ProductModel, string ProductBatchNo, string TwoCode, string BillNo, string LPId, bool IsDealer, string DealerId, string SubCompanyId, string BrandId)
        {


            Hashtable ConsignContract = new Hashtable();
            ConsignContract.Add("QryProductLine", ProductLine);
            ConsignContract.Add("QryDealer", Dealer);
            ConsignContract.Add("QryType", Type);
            ConsignContract.Add("QryStartDate", StartDate);
            ConsignContract.Add("QryEndDate", EndDate);
            ConsignContract.Add("QryApplyNo", ApplyNo);
            ConsignContract.Add("QryStatus", Status);
            ConsignContract.Add("QryProductModel", ProductModel);
            ConsignContract.Add("QryProductBatchNo", ProductBatchNo);
            ConsignContract.Add("QryTwoCode", TwoCode);
            ConsignContract.Add("LPId", LPId);
            ConsignContract.Add("IsDealer", IsDealer);
            ConsignContract.Add("DealerId", DealerId);
            ConsignContract.Add("UserDescription", BillNo);
            ConsignContract.Add("SubCompanyId", SubCompanyId);
            ConsignContract.Add("BrandId", BrandId);
            DataTable ds = this.ExecuteQueryForDataSet("Consignment.ConsignInventoryAdjustHeader.SelectConsignInventoryAdjustHeaderList", ConsignContract).Tables[0];
            return ds;
        }

        public DataTable SelectADDProduct(string ProductLine, string Dealer, string WarehouseId, string LotNumber, string ProductModel, string TwoCode, string SubCompanyId, string BrandId)
        {
            Hashtable ConsignContract = new Hashtable();
            //ConsignContract.Add("QryProductLine", "0f71530b-66d5-44af-9cab-ad65d5449c51");
            //ConsignContract.Add("QryDealer", "a00fcd75-951d-4d91-8f24-a29900da5e85");
            ConsignContract.Add("QryProductLine", ProductLine);
            ConsignContract.Add("QryDealer", Dealer);
            ConsignContract.Add("QryWarehouseId", WarehouseId);
            ConsignContract.Add("QryLotNumber", LotNumber);
            ConsignContract.Add("QryProductModel", ProductModel);
            ConsignContract.Add("QryTwoCode", TwoCode);
            ConsignContract.Add("SubCompanyId", SubCompanyId);
            ConsignContract.Add("BrandId", BrandId);
            DataTable ds = this.ExecuteQueryForDataSet("Consignment.ConsignInventoryAdjustHeader.SelectADDProduct", ConsignContract).Tables[0];
            return ds;
        }

        //public void InsertConsignInventoryAdjustSave(Guid ID,string DealerID,string ProductLine,string Type,string BoSales,string Status,string Remark,string SubMit)
        //{
        //    ConsignInventoryAdjustHeaderPO ConsignInventoryAdjustHeader = new ConsignInventoryAdjustHeaderPO();
        //    ConsignInventoryAdjustHeader.IAH_ID = ID;
            
        //    ConsignInventoryAdjustHeader.IAH_DMA_ID =new Guid(DealerID);
        //    ConsignInventoryAdjustHeader.IAH_ProductLine_BUM_ID = new Guid(ProductLine);
        //    ConsignInventoryAdjustHeader.IAH_Reason = "CTOS";
        //    ConsignInventoryAdjustHeader.IAH_Status = "Draft";
        //    ConsignInventoryAdjustHeader.IAH_CreatedDate =DateTime.Now;
        //    ConsignInventoryAdjustHeader.SaleRep = BoSales;

        //    this.ExecuteInsert("Consignment.ConsignInventoryAdjustHeader.Insert", ConsignInventoryAdjustHeader);
        //}

        public DataTable QueryLotCount(string DealerID,string ProductID,string LotBumber)
        {
            Hashtable obj = new Hashtable();
            obj.Add("WHM_DMA_ID", DealerID);
            obj.Add("UPN", ProductID);
            obj.Add("LTM_LotNumber", LotBumber);
            DataTable ds = this.ExecuteQueryForDataSet("Consignment.ConsignInventoryAdjustHeader.QueryLotCount", obj).Tables[0];
            return ds;
        }

        public Guid WareHouseID(Guid DealerID)
        {
            Hashtable obj = new Hashtable();
            obj.Add("DealerID", DealerID);
            DataTable ds = this.ExecuteQueryForDataSet("Consignment.ConsignInventoryAdjustHeader.WareHouseID", obj).Tables[0];
            return new Guid(ds.Rows[0]["WHM_ID"].ToString());
        }

        public Guid ProductID(string UPN)
        {
            Hashtable obj = new Hashtable();
            obj.Add("UPN", UPN);
            DataTable ds = this.ExecuteQueryForDataSet("Consignment.ConsignInventoryAdjustHeader.ProductID", obj).Tables[0];
            return new Guid(ds.Rows[0]["PMA_ID"].ToString());
        }

        public void Consignment_Proc_InventoryAdjust( string BillType, string BillNo, string OperationType, out string rtnVal, out string rtnMsg)
        {
            rtnVal = string.Empty;
            rtnMsg = string.Empty;
            Hashtable ht = new Hashtable();
            ht.Add("BillType", BillType);
            ht.Add("BillNo", BillNo);
            ht.Add("OperationType", OperationType);
           
            this.ExecuteInsert("Consignment.ConsignInventoryAdjustHeader.ConsignmentInventoryAdjust", ht);
            rtnVal = ht["RtnVal"].ToString();
            rtnMsg = ht["RtnMsg"].ToString();

        }

        public void ConsignInventoryAdjustHeaderUpdateStatus(string Number)
        {
            this.ExecuteUpdate("Consignment.ConsignInventoryAdjustHeader.UpdateStatus", Number);
        }

        public ConsignInventoryAdjustHeaderPO SelectConsignInventoryAdjustHeader(String ID)
        {
            return this.ExecuteQueryForObject<ConsignInventoryAdjustHeaderPO>("Consignment.ConsignInventoryAdjustHeader.SelectConsignInventoryAdjustHeader", ID);
        }

        public DataTable QueryInventoryAdjustDetail(string ID)
        {
            Hashtable ConsignContract = new Hashtable();
            ConsignContract.Add("IAD_IAH_ID", ID);

            DataTable ds = this.ExecuteQueryForDataSet("Consignment.ConsignInventoryAdjustHeader.QueryInventoryAdjustDetail", ConsignContract).Tables[0];
            return ds;
        }

        public int DeleteInventoryAdjustDetail(Guid IAD_IAH_ID)
        {
            int cnt = (int)this.ExecuteDelete("Consignment.ConsignInventoryAdjustHeader.DeleteInventoryAdjustDetail", IAD_IAH_ID);
            return cnt;
        }

        public int DeleteInventoryAdjustLot(Guid IAD_IAH_ID)
        {
            int cnt = (int)this.ExecuteDelete("Consignment.ConsignInventoryAdjustHeader.DeleteInventoryAdjustLot", IAD_IAH_ID);
            return cnt;
        }

        public DataTable SelectUserName(string IAH_CreatedBy_USR_UserID)
        {
            Hashtable obj = new Hashtable();
            obj.Add("IAH_CreatedBy_USR_UserID", IAH_CreatedBy_USR_UserID);
           
            DataTable ds = this.ExecuteQueryForDataSet("Consignment.ConsignInventoryAdjustHeader.SelectUserName", obj).Tables[0];
            return ds;
        }

        public DataTable GetKeyValueType()
        {
            Hashtable ConsignContract = new Hashtable();

            DataTable ds = this.ExecuteQueryForDataSet("Consignment.ConsignInventoryAdjustHeader.GetKeyValueType", ConsignContract).Tables[0];
            return ds;
        }
        public String GetNumber(Guid ID)
        {
            Hashtable ConsignContract = new Hashtable();
            ConsignContract.Add("ID", ID);
            DataTable ds = this.ExecuteQueryForDataSet("Consignment.ConsignInventoryAdjustHeader.GetNumber", ConsignContract).Tables[0];
            return ds.Rows.Count>0?ds.Rows[0]["IAH_Inv_Adj_Nbr"].ToString():null;
        }
        public String GetAccount(string EID)
        {
            Hashtable ConsignContract = new Hashtable();
            ConsignContract.Add("EID", EID);
            DataTable ds = this.ExecuteQueryForDataSet("Consignment.ConsignInventoryAdjustHeader.GetAccount", ConsignContract).Tables[0];
            return ds.Rows.Count > 0 ? ds.Rows[0]["account"].ToString() : null;
        }
        public String GetSalesName(string UserAccount)
        {
            Hashtable ConsignContract = new Hashtable();
            ConsignContract.Add("UserAccount", UserAccount);
            DataTable ds = this.ExecuteQueryForDataSet("Consignment.ConsignInventoryAdjustHeader.GetSalesName", ConsignContract).Tables[0];
            return ds.Rows.Count > 0 ? ds.Rows[0]["Name"].ToString() : null;
        }

        public void UpdateInventoryAdjustHeaderSave(string ID, string BoSales, string Remark)
        {
            Hashtable InventoryAdjustHeader = new Hashtable();

            InventoryAdjustHeader.Add("ID", ID);
            InventoryAdjustHeader.Add("BoSales", BoSales);
            InventoryAdjustHeader.Add("Remark", Remark);
            this.ExecuteUpdate("Consignment.ConsignInventoryAdjustHeader.Update", InventoryAdjustHeader);

        }
        public DataSet QueryConsignmentApplyHeaderDealer(Hashtable table, int start, int limit, out int totalRowCount)
        {
            //table.Add("OwnerIdentityType", this._context.User.IdentityType);
            //table.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            //table.Add("OwnerId", new Guid(this._context.User.Id));
            using (ConsignmentApplyHeaderDao dao = new ConsignmentApplyHeaderDao())
            {
                DataSet ds = dao.QueryConsignmentApplyHeaderDealer(table, start, limit, out totalRowCount);
                return ds;
            }
        }
    }
}
