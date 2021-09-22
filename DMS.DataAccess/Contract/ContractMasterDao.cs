
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : ContractMaster
 * Created Time: 2013/11/26 15:40:28
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
    /// ContractMaster的Dao
    /// </summary>
    public class ContractMasterDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public ContractMasterDao(): base()
        {
        }

        public DataSet SelectForContractMaster(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectForContractMaster", obj, start, limit, out totalRowCount);
            return ds;
        }

        public ContractMasterDM GetContractMasterByCmID(Hashtable table )
        {
            ContractMasterDM obj = this.ExecuteQueryForObject<ContractMasterDM>("SelectContractMasterByCmID", table);
            return obj;
        }

        public ContractMasterDM GetContractMasterByDealerID(Guid dealerID)
        {
            ContractMasterDM obj = this.ExecuteQueryForObject<ContractMasterDM>("SelectContractMasterByDealerID", dealerID);
            return obj;
        }
        public DataSet GetTakeEffectStateByContractID(Guid ContractId)
        {
            Hashtable condition = new Hashtable();
            condition.Add("ContractId", ContractId);
            DataSet ds = this.ExecuteQueryForDataSet("ContractTakeEffectState", condition);
            return ds;
        }

        public void UpdateContractFrom3(ContractMasterDM table)
        {
            this.ExecuteUpdate("UpdateContractFrom3", table);
        }

        public void InsertContractFrom3(ContractMasterDM table)
        {
            this.ExecuteInsert("InsertContractFrom3", table);
        }

        public void UpdateContractFrom4(ContractMasterDM table)
        {
           int i= this.ExecuteUpdate("UpdateContractFrom4", table);
        }

        public void InsertContractFrom4(ContractMasterDM table)
        {
            this.ExecuteInsert("InsertContractFrom4", table);
        }

        public void UpdateContractFrom5(ContractMasterDM table)
        {
            int i = this.ExecuteUpdate("UpdateContractFrom5", table);
        }

        public void InsertContractFrom5(ContractMasterDM table)
        {
            this.ExecuteInsert("InsertContractFrom5", table);
        }

        public int  UpdateContractMasterStatus(Hashtable table)
        {
            int i = this.ExecuteUpdate("UpdateContractMasterStatus", table);
            return i;
        }

        public DataSet GetAuthorCodeAndDivName(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectAuthorCodeAndDivName", obj);
            return ds;
        }

        public DataSet SelectActiveContractCount(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectActiveContractCount", obj);
            return ds;
        }

        public void ContractMasterMaintain(Hashtable table) 
        {
            this.ExecuteInsert("ContractMasterMaintain", table);
        }

        public int UpdateAppointmentCmId(Hashtable table)
        {
            int i = this.ExecuteUpdate("UpdateAppointmentCmId", table);
            return i;
        }

        public DataSet GetAmandCurrentJudgeDate()
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectAmandCurrentJudgeDate", null);
            return ds;
        }
        public DataSet SelectSubCompnayAndBrandInfoByBU(string BU)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectSubCompnayAndBrandInfoByBU", BU);
            return ds;
        }
    }
}