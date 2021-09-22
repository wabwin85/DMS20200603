
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : InterfaceHospitalSalesFort2
 * Created Time: 2016/12/14 18:47:26
 *
 ****** Copyright (C) 2009/2010 - GrapeCity*****
 *
***********************************************/

using System;
using System.Collections;
using System.Collections.Generic;
using DMS.Model;
using System.Data;

namespace DMS.DataAccess
{
    /// <summary>
    /// InterfaceHospitalSalesFort2的Dao
    /// </summary>
    public class InterfaceHospitalSalesFort2Dao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public InterfaceHospitalSalesFort2Dao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public InterfaceHospitalSalesFort2 GetObject(Guid objKey)
        {
            InterfaceHospitalSalesFort2 obj = this.ExecuteQueryForObject<InterfaceHospitalSalesFort2>("SelectInterfaceHospitalSalesFort2", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<InterfaceHospitalSalesFort2> GetAll()
        {
            IList<InterfaceHospitalSalesFort2> list = this.ExecuteQueryForList<InterfaceHospitalSalesFort2>("SelectInterfaceHospitalSalesFort2", null);          
            return list;
        }


        /// <summary>
        /// 查询InterfaceHospitalSalesFort2
        /// </summary>
        /// <returns>返回InterfaceHospitalSalesFort2集合</returns>
		public IList<InterfaceHospitalSalesFort2> SelectByFilter(InterfaceHospitalSalesFort2 obj)
		{ 
			IList<InterfaceHospitalSalesFort2> list = this.ExecuteQueryForList<InterfaceHospitalSalesFort2>("SelectByFilterInterfaceHospitalSalesFort2", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(InterfaceHospitalSalesFort2 obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateInterfaceHospitalSalesFort2", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteInterfaceHospitalSalesFort2", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(InterfaceHospitalSalesFort2 obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteInterfaceHospitalSalesFort2", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(InterfaceHospitalSalesFort2 obj)
        {
            this.ExecuteInsert("InsertInterfaceHospitalSalesFort2", obj);           
        }

        public void HandleSalesData(string BatchNbr, string ClientID, out string RtnVal, out string RtnMsg)
        {
            RtnVal = string.Empty;
            RtnMsg = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("BatchNbr", BatchNbr);
            ht.Add("ClientID", ClientID);
            ht.Add("UserId", null);
            ht.Add("RtnVal", RtnVal);
            ht.Add("RtnMsg", RtnMsg);

            this.ExecuteInsert("GC_Interface_SalesForT2", ht);

            RtnVal = ht["RtnVal"].ToString();
            RtnMsg = ht["RtnMsg"].ToString();
        }

        public DataSet SelectHospitalSalesByBatchNbr(string BatchNbr)
        {
            return base.ExecuteQueryForDataSet("SelectHospitalSalesForT2ByBachNumber", BatchNbr);
        }
    }
}