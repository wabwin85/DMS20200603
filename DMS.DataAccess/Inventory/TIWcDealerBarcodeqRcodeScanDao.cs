
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : TIWcDealerBarcodeqRcodeScan
 * Created Time: 2015/12/23 16:51:41
 *
 ****** Copyright (C) 2009/2010 - GrapeCity*****
 *
***********************************************/

using System;
using System.Collections;
using System.Collections.Generic;
using IBatisNet.DataMapper;
using DMS.Model;
using System.Data;

namespace DMS.DataAccess
{
    /// <summary>
    /// TIWcDealerBarcodeqRcodeScan的Dao
    /// </summary>
    public class TIWcDealerBarcodeqRcodeScanDao : BaseSqlMapDao
    {

        /// <summary>
        /// 默认构造函数
        /// </summary>
        public TIWcDealerBarcodeqRcodeScanDao()
            : base()
        {
        }

        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public TIWcDealerBarcodeqRcodeScan GetObject(Guid objKey)
        {
            TIWcDealerBarcodeqRcodeScan obj = this.ExecuteQueryForObject<TIWcDealerBarcodeqRcodeScan>("SelectTIWcDealerBarcodeqRcodeScan", objKey);
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<TIWcDealerBarcodeqRcodeScan> GetAll()
        {
            IList<TIWcDealerBarcodeqRcodeScan> list = this.ExecuteQueryForList<TIWcDealerBarcodeqRcodeScan>("SelectTIWcDealerBarcodeqRcodeScan", null);
            return list;
        }


        /// <summary>
        /// 查询TIWcDealerBarcodeqRcodeScan
        /// </summary>
        /// <returns>返回TIWcDealerBarcodeqRcodeScan集合</returns>
        public IList<TIWcDealerBarcodeqRcodeScan> SelectByFilter(TIWcDealerBarcodeqRcodeScan obj)
        {
            IList<TIWcDealerBarcodeqRcodeScan> list = this.ExecuteQueryForList<TIWcDealerBarcodeqRcodeScan>("SelectByFilterTIWcDealerBarcodeqRcodeScan", obj);
            return list;
        }

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(TIWcDealerBarcodeqRcodeScan obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateTIWcDealerBarcodeqRcodeScan", obj);
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteTIWcDealerBarcodeqRcodeScan", objKey);
            return cnt;
        }




        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(Guid obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteTIWcDealerBarcodeqRcodeScan", obj);
            return cnt;
        }

        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(TIWcDealerBarcodeqRcodeScan obj)
        {
            this.ExecuteInsert("InsertTIWcDealerBarcodeqRcodeScan", obj);
        }

        /// <summary>
        /// 根据条件查询经销商二维码库存数据
        /// </summary>
        /// <param name="table"></param>
        /// <param name="start"></param>
        /// <param name="limit"></param>
        /// <param name="totalRowCount"></param>
        /// <returns></returns>
        public DataSet QueryTIWcDealerBarcodeqRcodeScanByFilter(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = base.ExecuteQueryForDataSet("QueryTIWcDealerBarcodeqRcodeScanByFilter", table, start, limit, out totalRowCount, true);
            return ds;
        }

        /// <summary>
        /// 根据条件查询经销商二维码库存数据
        /// </summary>
        /// <param name="table"></param>
        /// <returns></returns>
        public DataSet QueryTIWcDealerBarcodeqRcodeScanByFilter(Hashtable table)
        {
            DataSet ds = base.ExecuteQueryForDataSet("QueryTIWcDealerBarcodeqRcodeScanByFilter", table);
            return ds;
        }

        public DataSet QueryInventoryqrOperationByFilter(Hashtable table)
        {
            DataSet ds = base.ExecuteQueryForDataSet("QueryInventoryqrOperationByFilter", table);
            return ds;
        }

        /// <summary>
        /// 添加产品
        /// </summary>
        /// <param name="userId"></param>
        /// <param name="dealerId"></param>
        /// <param name="cfnString"></param>
        /// <param name="rtnVal"></param>
        /// <param name="rtnMsg"></param>
        public void AddItem(Guid userId, Guid dealerId, string lotString, string operationType, out string rtnVal, out string rtnMsg)
        {
            rtnVal = string.Empty;
            rtnMsg = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("UserId", userId);
            ht.Add("DealerId", dealerId);
            ht.Add("LotString", lotString);
            ht.Add("InventoryType", operationType);
            ht.Add("RtnVal", rtnVal);
            ht.Add("RtnMsg", rtnMsg);

            this.ExecuteInsert("GC_InventoryQr_AddCfn", ht);

            rtnVal = ht["RtnVal"].ToString();
            rtnMsg = ht["RtnMsg"].ToString();
        }
        /// <summary>
        /// 根据UPN和二维码得到明细
        /// </summary>
        /// <param name="table"></param>
        /// <param name="start"></param>
        /// <param name="limit"></param>
        /// <param name="totalRowCount"></param>
        /// <returns></returns>
        public DataSet QueryTIWcDealerBarcodeqRcodeScanByUpnCode(Hashtable table)
        {
            DataSet ds = base.ExecuteQueryForDataSet("QueryTIWcDealerBarcodeqRcodeScanByUpnCode", table);
            return ds;
        }
        /// <summary>
        /// 获取产品的产品线
        /// </summary>
        /// <param name="Upn"></param>
        /// <returns></returns>
        public DataSet SelectCfnBUby(string Upn)
        {
            DataSet ds = base.ExecuteQueryForDataSet("SelectCfnBUby",Upn);
            return ds;
        }
        public DataSet QueryTIWShipmentCfnBY(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = base.ExecuteQueryForDataSet("QueryTIWShipmentCfnBY", table, start, limit, out totalRowCount);
            return ds;
        }
        public void QrCodeConvert_CheckSumbit(Guid DealerId, string SubCompanyId, string BrandId, string NewQrCode, string LotString, string LotNumber, string Upn, string QrCode, string User, string ShipHeadId, string PamaId, string WhmId, out string rtnVal, out string rtnMsg)
        { 
            rtnVal = string.Empty;
            rtnMsg = string.Empty;
            Hashtable ht = new Hashtable();
            ht.Add("DealerId", DealerId);
            ht.Add("SubCompanyId", SubCompanyId);
            ht.Add("BrandId", BrandId);
            ht.Add("NewQrCode", NewQrCode);
            ht.Add("LotString", LotString);
            ht.Add("LotNumber", LotNumber);
            ht.Add("Upn", Upn);
            ht.Add("QrCode", QrCode);
            ht.Add("User", User);
            ht.Add("HeadId", ShipHeadId);
            ht.Add("PMAId", PamaId);
            ht.Add("NewWhId", WhmId);
            ht.Add("RtnVal", rtnVal);
            ht.Add("RtnMsg", rtnMsg);
            this.ExecuteInsert("GC_InventoryQr_Submit_QrCodeConvert", ht);
            rtnVal = ht["RtnVal"].ToString();
            rtnMsg = ht["RtnMsg"].ToString();        
        }
        public DataSet SelectStockCfnBYUpnQrCodeLot(Hashtable table)
        {
            DataSet ds = base.ExecuteQueryForDataSet("SelectStockCfnBYUpnQrCodeLot", table);
            return ds;
        }
        public void StockQrCodeConvertCheckedSumbit(Guid DealerId, string StockInQrCode, string LotNumber, string Upn, string UserId, string WhmId, out string RtnVal, out string RtnMsg)
        {
            Hashtable ht=new Hashtable();
            RtnVal=string.Empty;
            RtnMsg=string.Empty;
            ht.Add("DealerId", DealerId);
            ht.Add("QrCode", StockInQrCode);
            ht.Add("LotNumber", LotNumber);
            ht.Add("Upn", Upn);
            ht.Add("User", UserId);
            ht.Add("NewWhId", WhmId);
            ht.Add("RtnVal", RtnVal);
            ht.Add("RtnMsg", RtnMsg);
            this.ExecuteInsert("GC_InventoryQr_Submit_StockQrCodeConvert", ht);
            RtnVal = ht["RtnVal"].ToString();
            RtnMsg = ht["RtnMsg"].ToString();   

        }
        public void UpdateDealerBarcodeRemarkByDmaIdUpnLot(string DmaId, string QrCode, string Upn, string Lot, string Remark)
        {
            Hashtable ht = new Hashtable();
            ht.Add("DmaId", DmaId);
            ht.Add("QrCode", QrCode);
            ht.Add("Upn", Upn);
            ht.Add("Lot", Lot);
            ht.Add("Remark", Remark);
            this.ExecuteUpdate("UpdateDealerBarcodeRemarkByDmaIdUpnLot", ht);

        }
        public void GetCfnPriceHistorybyUpnLotDmaid(string DealerId, string HospId, out string RtnVal, out string RtnMsg)
        {
           Hashtable ht=new Hashtable();
            RtnVal=string.Empty;
            RtnMsg=string.Empty;
            ht.Add("DealerId",DealerId);
            ht.Add("HospId",HospId);
            ht.Add("RtnVal", RtnVal);
            ht.Add("RtnMsg", RtnMsg);
            this.ExecuteInsert("GC_GetCfnPriceHistory", ht);
            RtnVal = ht["RtnVal"].ToString();
            RtnMsg = ht["RtnMsg"].ToString();   
        }

        public DataSet selectremark( string DealerId)
        {
            DataSet ds = base.ExecuteQueryForDataSet("selectremark", DealerId);
            return ds;
        }
    }
}