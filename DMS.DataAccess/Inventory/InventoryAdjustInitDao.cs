
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : InventoryAdjustInit
 * Created Time: 2015/10/19 15:16:17
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
    /// InventoryAdjustInit的Dao
    /// </summary>
    public class InventoryAdjustInitDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public InventoryAdjustInitDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public InventoryAdjustInit GetObject(Guid objKey)
        {
            InventoryAdjustInit obj = this.ExecuteQueryForObject<InventoryAdjustInit>("SelectInventoryAdjustInit", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<InventoryAdjustInit> GetAll()
        {
            IList<InventoryAdjustInit> list = this.ExecuteQueryForList<InventoryAdjustInit>("SelectInventoryAdjustInit", null);          
            return list;
        }


        /// <summary>
        /// 查询InventoryAdjustInit
        /// </summary>
        /// <returns>返回InventoryAdjustInit集合</returns>
		public IList<InventoryAdjustInit> SelectByFilter(InventoryAdjustInit obj)
		{ 
			IList<InventoryAdjustInit> list = this.ExecuteQueryForList<InventoryAdjustInit>("SelectByFilterInventoryAdjustInit", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(InventoryAdjustInit obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateInventoryAdjustInit", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteInventoryAdjustInit", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(InventoryAdjustInit obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteInventoryAdjustInit", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(InventoryAdjustInit obj)
        {
            this.ExecuteInsert("InsertInventoryAdjustInit", obj);           
        }

        public int UpdateForEdit(InventoryAdjustInit obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateInventoryAdjustInitForEdit", obj);
            return cnt;
        }

        /// <summary>
        /// 根据用户删除数据
        /// </summary>
        /// <param name="UserId"></param>
        /// <returns></returns>
        public int DeleteByUser(Guid UserId)
        {
            int cnt = (int)this.ExecuteDelete("DeleteInventoryAdjustInitByUser", UserId);
            return cnt;
        }

        /// <summary>
        /// 根据条件查询
        /// </summary>
        /// <param name="obj"></param>
        /// <returns></returns>
        public IList<InventoryAdjustInit> SelectByHashtable(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            IList<InventoryAdjustInit> list = this.ExecuteQueryForList<InventoryAdjustInit>("SelectInventoryAdjustInitByHashtable", obj, start, limit, out totalRowCount);
            return list;
        }

        /// <summary>
        /// 调用存储过程
        /// </summary>
        /// <param name="UserId"></param>
        /// <returns></returns>
        public string Initialize(string importType, Guid UserId, string SubCompanyId, string BrandId)
        {
            string IsValid = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("UserId", UserId);
            ht.Add("ImportType", importType);
            ht.Add("SubCompanyId", SubCompanyId);
            ht.Add("BrandId", BrandId);
            ht.Add("IsValid", IsValid);

            this.ExecuteInsert("GC_InventoryAdjustInit", ht);

            IsValid = ht["IsValid"].ToString();

            return IsValid;
        }

        /// <summary>
        /// 批量插入数据
        /// </summary>
        /// <param name="list"></param>
        public void BatchInsert(IList<InventoryAdjustInit> list)
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("IAI_ID", typeof(Guid));
            dt.Columns.Add("IAI_USER", typeof(Guid));
            dt.Columns.Add("IAI_UploadDate", typeof(DateTime));
            dt.Columns.Add("IAI_LineNbr", typeof(int));
            dt.Columns.Add("IAI_FileName");
            dt.Columns.Add("IAI_ErrorFlag", typeof(bool));
            dt.Columns.Add("IAI_ErrorDescription");
            dt.Columns.Add("IAI_ChineseName");
            dt.Columns.Add("IAI_ArticleNumber");
            dt.Columns.Add("IAI_ReturnQty");
            dt.Columns.Add("IAI_LotNumber");
            dt.Columns.Add("IAI_Warehouse");
            dt.Columns.Add("IAI_ArticleNumber_ErrMsg");
            dt.Columns.Add("IAI_ChineseName_ErrMsg");
            dt.Columns.Add("IAI_ReturnQty_ErrMsg");
            dt.Columns.Add("IAI_LotNumber_ErrMsg");
            dt.Columns.Add("IAI_Warehouse_ErrMsg");
            dt.Columns.Add("IAI_AdjustType");
            dt.Columns.Add("IAI_AdjustType_ErrMsg");
            dt.Columns.Add("IAI_SAPCode");
            dt.Columns.Add("IAI_SAPCodeErrMsg");
            dt.Columns.Add("IAI_QRCode");
            dt.Columns.Add("IAI_QRCodeErrMsg");

            foreach (InventoryAdjustInit data in list)
            {
                DataRow row = dt.NewRow();
                row["IAI_ID"] = data.Id;
                row["IAI_USER"] = data.User;
                row["IAI_UploadDate"] = data.UploadDate;
                row["IAI_LineNbr"] = data.LineNbr;
                row["IAI_FileName"] = data.FileName;
                row["IAI_ErrorFlag"] = data.ErrorFlag;
                row["IAI_ErrorDescription"] = data.ErrorDescription;
                row["IAI_ChineseName"] = data.ChineseName;
                row["IAI_Warehouse"] = data.Warehouse;
                row["IAI_ArticleNumber"] = data.ArticleNumber;
                row["IAI_ReturnQty"] = data.ReturnQty;
                row["IAI_LotNumber"] = data.LotNumber;
                row["IAI_ChineseName_ErrMsg"] = data.ChineseNameErrMsg;
                row["IAI_Warehouse_ErrMsg"] = data.WarehouseErrMsg;
                row["IAI_ArticleNumber_ErrMsg"] = data.ArticleNumberErrMsg;
                row["IAI_ReturnQty_ErrMsg"] = data.ReturnQtyErrMsg;
                row["IAI_LotNumber_ErrMsg"] = data.LotNumberErrMsg;
                row["IAI_AdjustType"] = data.AdjustType;
                row["IAI_AdjustType_ErrMsg"] = data.AdjustTypeErrMsg;
                row["IAI_SAPCode"] = data.SAPCode;
                row["IAI_SAPCodeErrMsg"] = data.SAPCodeErrMsg;
                row["IAI_QRCode"] = data.QrCode;
                row["IAI_QRCodeErrMsg"] = data.QrCodeErrMsg;
                dt.Rows.Add(row);
            }
            this.ExecuteBatchInsert("InventoryAdjustInit", dt);
        }

    }
}