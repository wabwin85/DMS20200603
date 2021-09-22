
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : InterfaceRedCrossHospitalTransactionWithqr
 * Created Time: 2017/3/12 15:45:28
 *
 ****** Copyright (C) 2009/2010 - GrapeCity*****
 *
***********************************************/

using System;
using System.Collections;
using System.Collections.Generic;
using DMS.Model;

namespace DMS.DataAccess
{
    /// <summary>
    /// InterfaceRedCrossHospitalTransactionWithqr的Dao
    /// </summary>
    public class InterfaceRedCrossHospitalTransactionWithqrDao : BaseSqlMapDao
    {

        /// <summary>
        /// 默认构造函数
        /// </summary>
        public InterfaceRedCrossHospitalTransactionWithqrDao() : base()
        {
        }

        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public InterfaceRedCrossHospitalTransactionWithqr GetObject(Guid objKey)
        {
            InterfaceRedCrossHospitalTransactionWithqr obj = this.ExecuteQueryForObject<InterfaceRedCrossHospitalTransactionWithqr>("SelectInterfaceRedCrossHospitalTransactionWithqr", objKey);
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<InterfaceRedCrossHospitalTransactionWithqr> GetAll()
        {
            IList<InterfaceRedCrossHospitalTransactionWithqr> list = this.ExecuteQueryForList<InterfaceRedCrossHospitalTransactionWithqr>("SelectInterfaceRedCrossHospitalTransactionWithqr", null);
            return list;
        }


        /// <summary>
        /// 查询InterfaceRedCrossHospitalTransactionWithqr
        /// </summary>
        /// <returns>返回InterfaceRedCrossHospitalTransactionWithqr集合</returns>
		public IList<InterfaceRedCrossHospitalTransactionWithqr> SelectByFilter(InterfaceRedCrossHospitalTransactionWithqr obj)
        {
            IList<InterfaceRedCrossHospitalTransactionWithqr> list = this.ExecuteQueryForList<InterfaceRedCrossHospitalTransactionWithqr>("SelectByFilterInterfaceRedCrossHospitalTransactionWithqr", obj);
            return list;
        }

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(InterfaceRedCrossHospitalTransactionWithqr obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateInterfaceRedCrossHospitalTransactionWithqr", obj);
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteInterfaceRedCrossHospitalTransactionWithqr", objKey);
            return cnt;
        }




        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(InterfaceRedCrossHospitalTransactionWithqr obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteInterfaceRedCrossHospitalTransactionWithqr", obj);
            return cnt;
        }

        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(InterfaceRedCrossHospitalTransactionWithqr obj)
        {
            this.ExecuteInsert("InsertInterfaceRedCrossHospitalTransactionWithqr", obj);
        }

        public void HandleRedCrossHospitalTransactionData(string BatchNbr, string ClientID, out string RtnVal, out string RtnMsg)
        {
            RtnVal = string.Empty;
            RtnMsg = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("BatchNbr", BatchNbr);
            ht.Add("ClientID", ClientID);
            ht.Add("RtnVal", RtnVal);
            ht.Add("RtnMsg", RtnMsg);

            this.ExecuteInsert("GC_Interface_RedCrossHospitalTransactionWithQR", ht);

            RtnVal = ht["RtnVal"].ToString();
            RtnMsg = ht["RtnMsg"].ToString();
        }

        public IList<InterfaceRedCrossHospitalTransactionWithqr> SelectRedCrossHospitalTransactionByBatchNbrErrorOnly(string BatchNbr)
        {
            IList<InterfaceRedCrossHospitalTransactionWithqr> list = this.ExecuteQueryForList<InterfaceRedCrossHospitalTransactionWithqr>("SelectRedCrossHospitalTransactionByBatchNbrErrorOnly", BatchNbr);
            return list;
        }

    }
}