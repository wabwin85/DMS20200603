
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : ShipmentInvoiceInit
 * Created Time: 2017-05-09 13:29:30
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
    /// ShipmentInvoiceInit的Dao
    /// </summary>
    public class ShipmentInvoiceInitDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public ShipmentInvoiceInitDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public ShipmentInvoiceInit GetObject(Guid objKey)
        {
            ShipmentInvoiceInit obj = this.ExecuteQueryForObject<ShipmentInvoiceInit>("SelectShipmentInvoiceInit", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<ShipmentInvoiceInit> GetAll()
        {
            IList<ShipmentInvoiceInit> list = this.ExecuteQueryForList<ShipmentInvoiceInit>("SelectShipmentInvoiceInit", null);          
            return list;
        }


        /// <summary>
        /// 查询ShipmentInvoiceInit
        /// </summary>
        /// <returns>返回ShipmentInvoiceInit集合</returns>
		public IList<ShipmentInvoiceInit> SelectByFilter(ShipmentInvoiceInit obj)
		{ 
			IList<ShipmentInvoiceInit> list = this.ExecuteQueryForList<ShipmentInvoiceInit>("SelectByFilterShipmentInvoiceInit", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(ShipmentInvoiceInit obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateShipmentInvoiceInit", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteShipmentInvoiceInit", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(ShipmentInvoiceInit obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteShipmentInvoiceInit", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(ShipmentInvoiceInit obj)
        {
            this.ExecuteInsert("InsertShipmentInvoiceInit", obj);           
        }

        public int DeleteShipmentInvoiceInitByUser(Guid UserId) {
            int cnt = (int)this.ExecuteDelete("DeleteShipmentInvoiceInitByUser", UserId);
            return cnt;
        }

        public IList<ShipmentInvoiceInit> QueryShipmentInvoiceInitErrorData(Hashtable table, int start, int limit, out int totalRowCount)
        {
            return this.ExecuteQueryForList<ShipmentInvoiceInit>("QueryShipmentInvoiceInitErrorData", table, start, limit, out totalRowCount);
        }

        public void BatchInvoiceInsert(IList<ShipmentInvoiceInit> list)
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("SII_ID", typeof(Guid));
            dt.Columns.Add("SII_DMA_ID", typeof(Guid));
            dt.Columns.Add("SII_ShipmentNbr");
            dt.Columns.Add("SII_InvoiceNo");
            dt.Columns.Add("SII_IsError", typeof(bool));
            dt.Columns.Add("SII_Error_Msg");
            dt.Columns.Add("SII_LineNbr", typeof(int));
            dt.Columns.Add("SII_ImportUser", typeof(Guid));
            dt.Columns.Add("SII_ImportDate", typeof(DateTime));

            foreach (ShipmentInvoiceInit data in list)
            {
                DataRow row = dt.NewRow();
                row["SII_ID"] = data.Id;
                row["SII_DMA_ID"] = data.DmaId;
                row["SII_ShipmentNbr"] = data.ShipmentNbr;
                row["SII_InvoiceNo"] = data.InvoiceNo;
                row["SII_IsError"] = data.IsError;
                row["SII_Error_Msg"] = data.ErrorMsg;
                row["SII_LineNbr"] = data.LineNbr;
                row["SII_ImportUser"] = data.ImportUser;
                row["SII_ImportDate"] = data.ImportDate;

                dt.Rows.Add(row);
            }
            this.ExecuteBatchInsert("ShipmentInvoiceInit", dt);
        }

        /// <summary>
        /// 调用存储过程二次初始化库存

        /// </summary>
        /// <param name="UserId"></param>
        /// <returns></returns>
        public void Initialize(Guid UserId, int IsImport, out string RtnVal,out string RtnMsg)
        {
            RtnVal = string.Empty;
            RtnMsg = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("UserId", UserId);
            ht.Add("IsImport", IsImport);
            ht.Add("RtnVal", RtnVal);
            ht.Add("RtnMsg", RtnMsg);

            this.ExecuteInsert("GC_ShipmentInvoiceInit", ht);

            RtnVal = ht["RtnVal"].ToString();
            RtnMsg = ht["RtnMsg"].ToString();
        }
    }
}