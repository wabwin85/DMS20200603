
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : ContractAppointment
 * Created Time: 2013/11/29 11:39:48
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
    /// ContractAppointment的Dao
    /// </summary>
    public class ContractAppointmentDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public ContractAppointmentDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public ContractAppointment GetObject(Guid objKey)
        {
            ContractAppointment obj = this.ExecuteQueryForObject<ContractAppointment>("SelectContractAppointment", objKey);           
            return obj;
        }

        public int UpdateAppointmentCmidByConid(Hashtable obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateAppointmentCmidByConid", obj);
            return cnt;
        }

        public int UpdateAppointmentStatusByConid(Hashtable obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateAppointmentStatusByConid", obj);
            return cnt;
        }

        public int UpdateAppointmentCOConfirmByConid(Hashtable obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateAppointmentCOConfirmByConid", obj);
            return cnt;
        }
        //管理员修改合同
        public DataSet SelectAppointmentMain(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectAppointmentMain", table);
            return ds;
        }
        public DataSet SelectAppointmentDealer(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectAppointmentDealer", table);
            return ds;
        }
        public DataSet SelectAppointmentProposals(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectAppointmentProposals", table);
            return ds;
        }
        public void InsertAppointmentMainTemp(Hashtable obj)
        {
            this.ExecuteInsert("InsertAppointmentMainTemp", obj);
        }
        public void InsertAppointmentDealerMainTemp(Hashtable obj)
        {
            this.ExecuteInsert("InsertAppointmentDealerMainTemp", obj);
        }
        public void InsertAppointmentProposalsTemp(Hashtable obj)
        {
            this.ExecuteInsert("InsertAppointmentProposalsTemp", obj);
        }
    }
}