
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : InventoryReturnConsignmentInit
 * Created Time: 2014/3/28 17:50:31
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
    /// InventoryReturnConsignmentInit的Dao
    /// </summary>
    public class InventoryReturnConsignmentInitDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public InventoryReturnConsignmentInitDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public InventoryReturnConsignmentInit GetObject(Guid objKey)
        {
            InventoryReturnConsignmentInit obj = this.ExecuteQueryForObject<InventoryReturnConsignmentInit>("SelectInventoryReturnConsignmentInit", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<InventoryReturnConsignmentInit> GetAll()
        {
            IList<InventoryReturnConsignmentInit> list = this.ExecuteQueryForList<InventoryReturnConsignmentInit>("SelectInventoryReturnConsignmentInit", null);          
            return list;
        }


        /// <summary>
        /// 查询InventoryReturnConsignmentInit
        /// </summary>
        /// <returns>返回InventoryReturnConsignmentInit集合</returns>
		public IList<InventoryReturnConsignmentInit> SelectByFilter(InventoryReturnConsignmentInit obj)
		{ 
			IList<InventoryReturnConsignmentInit> list = this.ExecuteQueryForList<InventoryReturnConsignmentInit>("SelectByFilterInventoryReturnConsignmentInit", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(InventoryReturnConsignmentInit obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateInventoryReturnConsignmentInit", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteInventoryReturnConsignmentInit", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(InventoryReturnConsignmentInit obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteInventoryReturnConsignmentInit", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(InventoryReturnConsignmentInit obj)
        {
            this.ExecuteInsert("InsertInventoryReturnConsignmentInit", obj);           
        }

        public int UpdateForEdit(InventoryReturnConsignmentInit obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateInventoryReturnConsignmentInitForEdit", obj);
            return cnt;
        }

        public int DeleteByUser(Guid obj)
        {
            int cnt = (int)this.ExecuteUpdate("DeleteInventoryReturnConsignmentInitByUser", obj);
            return cnt;
        }

        /// <summary>
        /// 根据条件查询
        /// </summary>
        /// <param name="obj"></param>
        /// <returns></returns>
        public IList<InventoryReturnConsignmentInit> SelectByHashtable(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            IList<InventoryReturnConsignmentInit> list = this.ExecuteQueryForList<InventoryReturnConsignmentInit>("SelectInventoryReturnConsignmentInitByHashtable", obj, start, limit, out totalRowCount);
            return list;
        }

        /// <summary>
        /// 调用存储过程
        /// </summary>
        /// <param name="UserId"></param>
        /// <returns></returns>
        public string Initialize(string importType, Guid UserId)
        {
            string IsValid = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("UserId", UserId);
            ht.Add("ImportType", importType);
            ht.Add("IsValid", IsValid);

            this.ExecuteInsert("GC_InventoryReturnConsignmentInit", ht);

            IsValid = ht["IsValid"].ToString();

            return IsValid;
        }

        /// <summary>
        /// 批量插入数据
        /// </summary>
        /// <param name="list"></param>
        public void BatchInsert(IList<InventoryReturnConsignmentInit> list)
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("IRC_ID", typeof(Guid));
            dt.Columns.Add("IRC_USER", typeof(Guid));
            dt.Columns.Add("IRC_UploadDate", typeof(DateTime));
            dt.Columns.Add("IRC_LineNbr", typeof(int));
            dt.Columns.Add("IRC_FileName");
            dt.Columns.Add("IRC_ErrorFlag", typeof(bool));
            dt.Columns.Add("IRC_ErrorDescription");
            dt.Columns.Add("IRC_ArticleNumber");
            dt.Columns.Add("IRC_ReturnQty");
            dt.Columns.Add("IRC_LotNumber");
            dt.Columns.Add("IRC_PurchaseOrderNbr");
            dt.Columns.Add("IRC_DMA_ID", typeof(Guid));
            dt.Columns.Add("IRC_ArticleNumber_ErrMsg");
            dt.Columns.Add("IRC_ReturnQty_ErrMsg");
            dt.Columns.Add("IRC_LotNumber_ErrMsg");
            dt.Columns.Add("IRC_PurchaseOrderNbr_ErrMsg");
            dt.Columns.Add("IRC_QrCode");
            dt.Columns.Add("IRC_Warehouse");
            dt.Columns.Add("IRC_Warehouse_ErrMsg");

            foreach (InventoryReturnConsignmentInit data in list)
            {
                DataRow row = dt.NewRow();
                row["IRC_ID"] = data.Id;
                row["IRC_USER"] = data.User;
                row["IRC_UploadDate"] = data.UploadDate;
                row["IRC_LineNbr"] = data.LineNbr;
                row["IRC_FileName"] = data.FileName;
                row["IRC_ErrorFlag"] = data.ErrorFlag;
                row["IRC_ErrorDescription"] = data.ErrorDescription;
                row["IRC_PurchaseOrderNbr"] = data.PurchaseOrderNbr;
                row["IRC_ArticleNumber"] = data.ArticleNumber;
                row["IRC_ReturnQty"] = data.ReturnQty;
                row["IRC_LotNumber"] = data.LotNumber;
                row["IRC_DMA_ID"] = data.DmaId.Value;
                row["IRC_PurchaseOrderNbr_ErrMsg"] = data.PurchaseOrderNbrErrMsg;
                row["IRC_ArticleNumber_ErrMsg"] = data.ArticleNumberErrMsg;
                row["IRC_ReturnQty_ErrMsg"] = data.ReturnQtyErrMsg;
                row["IRC_LotNumber_ErrMsg"] = data.LotNumberErrMsg;
                row["IRC_QrCode"] = data.QrCode;
                row["IRC_Warehouse"] = data.Warehouse;
                row["IRC_Warehouse_ErrMsg"] = data.WarehouseErrMsg;

                dt.Rows.Add(row);
            }
            this.ExecuteBatchInsert("InventoryReturnConsignmentInit", dt);
        }
    }
}