
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.Model 
 * ClassName   : InventoryInit
 * Created Time: 2009-9-1 12:46:56
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
    /// InventoryInit的Dao
    /// </summary>
    public class InventoryInitDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public InventoryInitDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public InventoryInit GetObject(Guid objKey)
        {
            InventoryInit obj = this.ExecuteQueryForObject<InventoryInit>("SelectInventoryInit", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<InventoryInit> GetAll()
        {
            IList<InventoryInit> list = this.ExecuteQueryForList<InventoryInit>("SelectInventoryInit", null);          
            return list;
        }


        /// <summary>
        /// 查询InventoryInit
        /// </summary>
        /// <returns>返回InventoryInit集合</returns>
		public IList<InventoryInit> SelectByFilter(InventoryInit obj)
		{ 
			IList<InventoryInit> list = this.ExecuteQueryForList<InventoryInit>("SelectByFilterInventoryInit", obj);          
            return list;
		}

        public IList<InventoryInit> SelectByHashtable(Hashtable obj)
        {
            IList<InventoryInit> list = this.ExecuteQueryForList<InventoryInit>("SelectInventoryInitByHashtable", obj);
            return list;
        }

        public IList<InventoryInit> SelectByHashtable(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            IList<InventoryInit> list = this.ExecuteQueryForList<InventoryInit>("SelectInventoryInitByHashtable", obj, start, limit, out totalRowCount);
            return list;
        }
        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(InventoryInit obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateInventoryInit", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid obj)
        {
            int cnt = (int)this.ExecuteDelete("DeleteInventoryInit", obj);            
            return cnt;
        }

        public int DeleteByUser(Guid UserId)
        {
            int cnt = (int)this.ExecuteDelete("DeleteInventoryInitByUser", UserId);
            return cnt;
        }
		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(InventoryInit obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteInventoryInit", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(InventoryInit obj)
        {
            this.ExecuteInsert("InsertInventoryInit", obj);           
        }

        /// <summary>
        /// 批量插入数据
        /// </summary>
        /// <param name="list"></param>
        public void BatchInsert(IList<InventoryInit> list)
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("II_ID", typeof(Guid));
            dt.Columns.Add("II_USER", typeof(Guid));
            dt.Columns.Add("II_UploadDate", typeof(DateTime));
            dt.Columns.Add("II_LineNbr", typeof(int));
            dt.Columns.Add("II_FileName");
            dt.Columns.Add("II_ErrorFlag", typeof(bool));
            dt.Columns.Add("II_ErrorDescription");
            dt.Columns.Add("II_SAP_CODE");
            dt.Columns.Add("II_WHM_NAME");
            dt.Columns.Add("II_CFN");
            dt.Columns.Add("II_LTM_LotNumber");
            dt.Columns.Add("II_LTM_ExpiredDate");
            dt.Columns.Add("II_QTY");
            dt.Columns.Add("II_SAP_CODE_ErrMsg");
            dt.Columns.Add("II_WHM_NAME_ErrMsg");
            dt.Columns.Add("II_CFN_ErrMsg");
            dt.Columns.Add("II_LTM_LotNumber_ErrMsg");
            dt.Columns.Add("II_LTM_ExpiredDate_ErrMsg");
            dt.Columns.Add("II_QTY_ErrMsg");

            foreach (InventoryInit data in list)
            {
                DataRow row = dt.NewRow();
                row["II_ID"] = data.Id;
                row["II_USER"] = data.User;
                row["II_UploadDate"] = data.UploadDate;
                row["II_LineNbr"] = data.LineNbr;
                row["II_FileName"] = data.FileName;
                row["II_ErrorFlag"] = data.ErrorFlag;
                row["II_ErrorDescription"] = data.ErrorDescription;
                row["II_SAP_CODE"] = data.SapCode;
                row["II_WHM_NAME"] = data.WhmName;
                row["II_CFN"] = data.Cfn;
                row["II_LTM_LotNumber"] = data.LtmLotNumber;
                row["II_LTM_ExpiredDate"] = data.LtmExpiredDate;
                row["II_QTY"] = data.Qty;
                row["II_SAP_CODE_ErrMsg"] = data.SapCodeErrMsg;
                row["II_WHM_NAME_ErrMsg"] = data.WhmNameErrMsg;
                row["II_CFN_ErrMsg"] = data.CfnErrMsg;
                row["II_LTM_LotNumber_ErrMsg"] = data.LtmLotNumberErrMsg;
                row["II_LTM_ExpiredDate_ErrMsg"] = data.LtmExpiredDateErrMsg;
                row["II_QTY_ErrMsg"] = data.QtyErrMsg;
              
                dt.Rows.Add(row);
            }
            this.ExecuteBatchInsert("InventoryInit", dt);
        }
        /// <summary>
        /// 调用存储过程初始化库存
        /// </summary>
        /// <param name="UserId"></param>
        /// <returns></returns>
        public string Initialize(Guid UserId, Guid SubCompanyId, Guid BrandId)
        {
            string IsValid = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("UserId", UserId);
            ht.Add("SubCompanyId", SubCompanyId);
            ht.Add("BrandId", BrandId);
            ht.Add("IsValid", IsValid);

            this.ExecuteInsert("GC_InventoryInit", ht);

            IsValid = ht["IsValid"].ToString();

            return IsValid;
        }

        /// <summary>
        /// 调用存储过程二次初始化库存

        /// </summary>
        /// <param name="UserId"></param>
        /// <returns></returns>
        public string Initialize2(Guid UserId)
        {
            string IsValid = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("UserId", UserId);
            ht.Add("IsValid", IsValid);

            this.ExecuteInsert("GC_InventoryInit2", ht);

            IsValid = ht["IsValid"].ToString();

            return IsValid;
        }


        public int UpdateForEdit(InventoryInit obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateInventoryInitForEdit", obj);
            return cnt;
        }
    }
}