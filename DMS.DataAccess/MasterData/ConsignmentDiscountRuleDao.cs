
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : ConsignmentDiscountRule
 * Created Time: 2017/3/8 11:15:09
 *
 ****** Copyright (C) 2009/2010 - GrapeCity*****
 *
***********************************************/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;

using DMS.Model;

namespace DMS.DataAccess
{
    /// <summary>
    /// ConsignmentDiscountRule的Dao
    /// </summary>
    public class ConsignmentDiscountRuleDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public ConsignmentDiscountRuleDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public ConsignmentDiscountRule GetObject(Guid objKey)
        {
            ConsignmentDiscountRule obj = this.ExecuteQueryForObject<ConsignmentDiscountRule>("SelectConsignmentDiscountRule", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<ConsignmentDiscountRule> GetAll()
        {
            IList<ConsignmentDiscountRule> list = this.ExecuteQueryForList<ConsignmentDiscountRule>("SelectConsignmentDiscountRule", null);          
            return list;
        }


        /// <summary>
        /// 查询ConsignmentDiscountRule
        /// </summary>
        /// <returns>返回ConsignmentDiscountRule集合</returns>
		public IList<ConsignmentDiscountRule> SelectByFilter(ConsignmentDiscountRule obj)
		{ 
			IList<ConsignmentDiscountRule> list = this.ExecuteQueryForList<ConsignmentDiscountRule>("SelectByFilterConsignmentDiscountRule", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(ConsignmentDiscountRule obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateConsignmentDiscountRule", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteConsignmentDiscountRule", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(ConsignmentDiscountRule obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteConsignmentDiscountRule", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(ConsignmentDiscountRule obj)
        {
            this.ExecuteInsert("InsertConsignmentDiscountRule", obj);           
        }

        public DataSet QueryOrderDiscountRule(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectOrderDiscountRule", obj, start, limit, out totalRowCount);
            return ds;
        }

        public int DeleteByUser(Guid userId)
        {
            int cnt = (int)this.ExecuteDelete("DeleteOrderDiscountRuleByUser", userId);
            return cnt;
        }

        public void BatchInsert(IList<ConsignmentDiscountRuleInit> list)
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("ID", typeof(Guid));
            dt.Columns.Add("BU");
            dt.Columns.Add("DealerSAP");
            dt.Columns.Add("PctLevel");
            dt.Columns.Add("PctLevelCode");
            dt.Columns.Add("UPN");
            dt.Columns.Add("LOT");
            dt.Columns.Add("QRCode");
            dt.Columns.Add("PctNameGroup");
            dt.Columns.Add("LeftValue");
            dt.Columns.Add("RightValue");
            dt.Columns.Add("DiscountValue");
            dt.Columns.Add("BeginDate");
            dt.Columns.Add("EndDate");
            dt.Columns.Add("ErrMassage");
            dt.Columns.Add("CreateUser", typeof(Guid));
            dt.Columns.Add("CreateDate");

            foreach (ConsignmentDiscountRuleInit data in list)
            {
                DataRow row = dt.NewRow();
                row["ID"] = data.Id;
                row["BU"] = data.Bu;
                row["DealerSAP"] = data.Dealersap;
                row["PctLevel"] = data.PctLevel;
                row["PctLevelCode"] = data.PctLevelCode;
                row["UPN"] = data.Upn;
                row["LOT"] = data.Lot;
                row["QRCode"] = data.QrCode;
                row["PctNameGroup"] = data.PctNameGroup;
                row["LeftValue"] = data.LeftValue;
                row["RightValue"] = data.RightValue;
                row["DiscountValue"] = data.DiscountValue;
                row["BeginDate"] = data.BeginDate;
                row["EndDate"] = data.EndDate;
                row["ErrMassage"] = data.ErrMassage;
                row["CreateUser"] = data.CreateUser;
                row["CreateDate"] = data.CreateDate;
                dt.Rows.Add(row);
            }
            this.ExecuteBatchInsert("ConsignmentDiscountRuleInit", dt);
        }

        /// <summary>
        /// 调用存储过程
        /// </summary>
        /// <param name="UserId"></param>
        /// <returns></returns>
        public string Initialize(string importType, Guid UserId,string SubCompanyId, string BrandId)
        {
            string IsValid = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("UserId", UserId);
            ht.Add("ImportType", importType);
            ht.Add("SubCompanyId", SubCompanyId);
            ht.Add("BrandId", BrandId);
            ht.Add("IsValid", IsValid);
            
            this.ExecuteInsert("GC_OrderDiscountRuleInit", ht);

            IsValid = ht["IsValid"].ToString();

            return IsValid;
        }

        public DataSet QueryErrorData(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectDiscountRuleErrorData", obj, start, limit, out totalRowCount);
            return ds;
        }
    }
}