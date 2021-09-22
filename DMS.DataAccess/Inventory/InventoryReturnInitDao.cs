
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : InventoryReturnInit
 * Created Time: 2013/12/15 10:47:27
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
    /// InventoryReturnInit的Dao
    /// </summary>
    public class InventoryReturnInitDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public InventoryReturnInitDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public InventoryReturnInit GetObject(Guid objKey)
        {
            InventoryReturnInit obj = this.ExecuteQueryForObject<InventoryReturnInit>("SelectInventoryReturnInit", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<InventoryReturnInit> GetAll()
        {
            IList<InventoryReturnInit> list = this.ExecuteQueryForList<InventoryReturnInit>("SelectInventoryReturnInit", null);          
            return list;
        }


        /// <summary>
        /// 查询InventoryReturnInit
        /// </summary>
        /// <returns>返回InventoryReturnInit集合</returns>
		public IList<InventoryReturnInit> SelectByFilter(InventoryReturnInit obj)
		{ 
			IList<InventoryReturnInit> list = this.ExecuteQueryForList<InventoryReturnInit>("SelectByFilterInventoryReturnInit", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(InventoryReturnInit obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateInventoryReturnInit", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteInventoryReturnInit", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(InventoryReturnInit obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteInventoryReturnInit", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(InventoryReturnInit obj)
        {
            this.ExecuteInsert("InsertInventoryReturnInit", obj);           
        }

         /// <summary>
        /// 根据用户删除数据
        /// </summary>
        /// <param name="UserId"></param>
        /// <returns></returns>
        public int DeleteByUser(Guid UserId)
        {
            int cnt = (int)this.ExecuteDelete("DeleteInventoryReturnInitByUser", UserId);
            return cnt;
        }

        /// <summary>
        /// 根据条件查询
        /// </summary>
        /// <param name="obj"></param>
        /// <returns></returns>
        public IList<InventoryReturnInit> SelectByHashtable(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            IList<InventoryReturnInit> list = this.ExecuteQueryForList<InventoryReturnInit>("SelectInventoryReturnInitByHashtable", obj, start, limit, out totalRowCount);
            return list;
        }

        /// <summary>
        /// 调用存储过程
        /// </summary>
        /// <param name="UserId"></param>
        /// <returns></returns>
        public string Initialize(string importType,Guid UserId, string SubCompanyId, string BrandId)
        {
            string IsValid = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("UserId", UserId);
            ht.Add("SubCompanyId", SubCompanyId);
            ht.Add("BrandId", BrandId);
            ht.Add("ImportType", importType);
            ht.Add("IsValid", IsValid);

            this.ExecuteInsert("GC_InventoryReturnInit", ht);

            IsValid = ht["IsValid"].ToString();

            return IsValid;
        }

        /// <summary>
        /// 批量插入数据
        /// </summary>
        /// <param name="list"></param>
        public void BatchInsert(IList<InventoryReturnInit> list)
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("IRI_ID", typeof(Guid));
            dt.Columns.Add("IRI_USER", typeof(Guid));
            dt.Columns.Add("IRI_UploadDate", typeof(DateTime));
            dt.Columns.Add("IRI_LineNbr", typeof(int));
            dt.Columns.Add("IRI_FileName");
            dt.Columns.Add("IRI_ErrorFlag", typeof(bool));
            dt.Columns.Add("IRI_ErrorDescription");
            dt.Columns.Add("IRI_ArticleNumber");
            dt.Columns.Add("IRI_ReturnQty");
            dt.Columns.Add("IRI_LotNumber");
            dt.Columns.Add("IRI_Warehouse");
            dt.Columns.Add("IRI_DMA_ID", typeof(Guid));
            dt.Columns.Add("IRI_ArticleNumber_ErrMsg");
            dt.Columns.Add("IRI_ReturnQty_ErrMsg");
            dt.Columns.Add("IRI_LotNumber_ErrMsg");
            dt.Columns.Add("IRI_Warehouse_ErrMsg");
            dt.Columns.Add("IRI_PurchaseOrderNbr");
            dt.Columns.Add("IRI_PurchaseOrderNbr_ErrMsg");
            dt.Columns.Add("IRI_QrCode");
            dt.Columns.Add("IRI_QrCode_ErrMsg");
            foreach (InventoryReturnInit data in list)
            {
                DataRow row = dt.NewRow();
                row["IRI_ID"] = data.Id;
                row["IRI_USER"] = data.User;
                row["IRI_UploadDate"] = data.UploadDate;
                row["IRI_LineNbr"] = data.LineNbr;
                row["IRI_FileName"] = data.FileName;
                row["IRI_ErrorFlag"] = data.ErrorFlag;
                row["IRI_ErrorDescription"] = data.ErrorDescription;
                row["IRI_Warehouse"] = data.Warehouse;
                row["IRI_ArticleNumber"] = data.ArticleNumber;
                row["IRI_ReturnQty"] = data.ReturnQty;
                row["IRI_LotNumber"] = data.LotNumber;
                row["IRI_DMA_ID"] = data.DmaId.Value;
                row["IRI_Warehouse_ErrMsg"] = data.WarehouseErrMsg;
                row["IRI_ArticleNumber_ErrMsg"] = data.ArticleNumberErrMsg;
                row["IRI_ReturnQty_ErrMsg"] = data.ReturnQtyErrMsg;
                row["IRI_LotNumber_ErrMsg"] = data.LotNumberErrMsg;
                row["IRI_PurchaseOrderNbr"] = data.PurchaseOrderNbr;
                row["IRI_PurchaseOrderNbr_ErrMsg"] = data.PurchaseOrderNbrErrMsg;
                row["IRI_QrCode"] = data.QrCode;
                row["IRI_QrCode_ErrMsg"] = data.QrCodeErrMsg;
                dt.Rows.Add(row);
            }
            this.ExecuteBatchInsert("InventoryReturnInit", dt);
        }

        public int UpdateForEdit(InventoryReturnInit obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateInventoryReturnInitForEdit", obj);
            return cnt;
        }
    }
}