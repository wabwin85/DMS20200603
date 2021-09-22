
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.Model 
 * ClassName   : Transfer
 * Created Time: 2009-7-27 14:45:49
 *
 ****** Copyright (C) 2009/2010 - GrapeCity*****
 *
***********************************************/

using System;
using System.Collections;
using System.Collections.Generic;
using IBatisNet.DataMapper;
using DMS.Model;
using DMS.Model.DataInterface;
using System.Data;
using DMS.Model.Data;

namespace DMS.DataAccess
{
    /// <summary>
    /// Transfer的Dao
    /// </summary>
    public class TransferDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public TransferDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public Transfer GetObject(Guid objKey)
        {
            Transfer obj = this.ExecuteQueryForObject<Transfer>("SelectTransfer", objKey);           
            return obj;
        }

        public Transfer GetDealerTransferByTransferNumber(string TransferNumber)
        {
            Hashtable param = new Hashtable();
            param.Add("TransferNumber", TransferNumber);
            param.Add("Type", TransferType.Rent.ToString());
            Transfer obj = this.ExecuteQueryForObject<Transfer>("SelectTransferByTransferNumber", param);
            return obj;
        }

        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<Transfer> GetAll()
        {
            IList<Transfer> list = this.ExecuteQueryForList<Transfer>("SelectTransfer", null);          
            return list;
        }


        /// <summary>
        /// 查询Transfer
        /// </summary>
        /// <returns>返回Transfer集合</returns>
		public IList<Transfer> SelectByFilter(Transfer obj)
		{ 
			IList<Transfer> list = this.ExecuteQueryForList<Transfer>("SelectByFilterTransfer", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(Transfer obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateTransfer", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid id)
        {
            int cnt = (int)this.ExecuteDelete("DeleteTransfer", id);            
            return cnt;
        }


		
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(Transfer obj)
        {
            this.ExecuteInsert("InsertTransfer", obj);           
        }

        public DataSet SelectByFilter(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectByFilterTransferAll", table, start, limit, out totalRowCount);
            return ds;
        }
        public DataSet SelectByFilterTransferExport(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectByFilterTransferExport", table);
            return ds;
        }
        

        //LP HQ移库查询
        public DataSet SelectByFilterTransferForAudit(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectByFilterTransferForAudit", table, start, limit, out totalRowCount);
            return ds;
        }

        //LP HQ寄售库查询
        public DataSet SelectByFilterTransferCommit(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectByFilterTransferCommit", table, start, limit, out totalRowCount);
            return ds;
        }

        #region 借货下载接口
        public int InitTransferByClientID(Hashtable ht)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateTransferInterfaceForLpInitByClientID", ht);
            return cnt;
        }

        public IList<LpRentData> QueryRentInfoByBatchNbrForLp(string obj)
        {
            IList<LpRentData> list = this.ExecuteQueryForList<LpRentData>("QueryRentInfoByBatchNbrForLp", obj);
            return list;
        }

        public void AfterLpRentDataDownload(string BatchNbr, string ClientID, string Success, out string RtnVal)
        {
            RtnVal = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("BatchNbr", BatchNbr);
            ht.Add("ClientID", ClientID);
            ht.Add("Success", Success);
            ht.Add("RtnVal", RtnVal);

            this.ExecuteInsert("GC_LpRent_AfterDownload", ht);

            RtnVal = ht["RtnVal"].ToString();
        }
        #endregion

        //历史移库单导出
        public DataSet SelectByFilterTransferForExport(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectByFilterTransferForExport", table);
            return ds;
        }

        //查询是否有受限制的产品线
        public DataSet SelectLimitBUCount(Guid obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectLimitBUCount", obj);
            return ds;
        }

        public DataSet SelectLimitReason(Guid obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectLimitReason", obj);
            return ds;
        }
        public DataSet SelectLimitWarehouse(Guid obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectLimitWarehouse", obj);
            return ds;
        }

        public DataSet SelectByFilterTransferFrozen(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectByFilterTransferFrozen", table, start, limit, out totalRowCount);
            return ds;
        }

        public DataTable SelectIsHuaXiDealer(Guid obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("IsHuaXiDealer", obj);
            return ds.Tables[0];

        }
        public DataSet GetPushTransferLot(Guid obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("PushTransferLot", obj);
            return ds;
        }
        /// <summary>
        /// 移入仓库是否是北京协和医院
        /// </summary>
        public DataTable SelectIsXieHeHospital(Guid obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("IsXieHeHospital", obj);
            return ds.Tables[0];
        }

        public void XieHeGetExpressInfo(Guid obj)
        {
            this.ExecuteInsert("Proc_XieHe_GetExpressInfo", obj);
            
        }

        public DataTable SelectDealerMarketType(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectDealerMarketType", obj);
            return ds.Tables[0];
        }
    }
}