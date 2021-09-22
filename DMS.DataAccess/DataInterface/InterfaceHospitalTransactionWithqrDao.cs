
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : InterfaceHospitalTransactionWithqr
 * Created Time: 2016/7/13 14:54:03
 *
 ****** Copyright (C) 2009/2010 - GrapeCity*****
 *
***********************************************/

using System;
using System.Collections;
using System.Collections.Generic;
using IBatisNet.DataMapper;
using DMS.Model;

namespace DMS.DataAccess
{
    /// <summary>
    /// InterfaceHospitalTransactionWithqr的Dao
    /// </summary>
    public class InterfaceHospitalTransactionWithqrDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public InterfaceHospitalTransactionWithqrDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public InterfaceHospitalTransactionWithqr GetObject(Guid objKey)
        {
            InterfaceHospitalTransactionWithqr obj = this.ExecuteQueryForObject<InterfaceHospitalTransactionWithqr>("SelectInterfaceHospitalTransactionWithqr", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<InterfaceHospitalTransactionWithqr> GetAll()
        {
            IList<InterfaceHospitalTransactionWithqr> list = this.ExecuteQueryForList<InterfaceHospitalTransactionWithqr>("SelectInterfaceHospitalTransactionWithqr", null);          
            return list;
        }


        /// <summary>
        /// 查询InterfaceHospitalTransactionWithqr
        /// </summary>
        /// <returns>返回InterfaceHospitalTransactionWithqr集合</returns>
		public IList<InterfaceHospitalTransactionWithqr> SelectByFilter(InterfaceHospitalTransactionWithqr obj)
		{ 
			IList<InterfaceHospitalTransactionWithqr> list = this.ExecuteQueryForList<InterfaceHospitalTransactionWithqr>("SelectByFilterInterfaceHospitalTransactionWithqr", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(InterfaceHospitalTransactionWithqr obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateInterfaceHospitalTransactionWithqr", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteInterfaceHospitalTransactionWithqr", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(InterfaceHospitalTransactionWithqr obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteInterfaceHospitalTransactionWithqr", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(InterfaceHospitalTransactionWithqr obj)
        {
            this.ExecuteInsert("InsertInterfaceHospitalTransactionWithqr", obj);           
        }

        public void HandleHospitalTransactionData(string BatchNbr, string ClientID, out string RtnVal, out string RtnMsg)
        {
            RtnVal = string.Empty;
            RtnMsg = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("BatchNbr", BatchNbr);
            ht.Add("ClientID", ClientID);
            ht.Add("RtnVal", RtnVal);
            ht.Add("RtnMsg", RtnMsg);

            this.ExecuteInsert("GC_Interface_HospitalTransactionWithQR", ht);

            RtnVal = ht["RtnVal"].ToString();
            RtnMsg = ht["RtnMsg"].ToString();
        }

        public IList<InterfaceHospitalTransactionWithqr> SelectHospitalTransactionByBatchNbrErrorOnly(string BatchNbr)
        {
            IList<InterfaceHospitalTransactionWithqr> list = this.ExecuteQueryForList<InterfaceHospitalTransactionWithqr>("SelectHospitalTransactionByBatchNbrErrorOnly", BatchNbr);
            return list;
        }
    }
}