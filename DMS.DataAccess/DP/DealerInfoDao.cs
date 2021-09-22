
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : SIMS.DataAccess 
 * ClassName   : DealerInfo
 * Created Time: 2012/4/17 11:33:16
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
    /// DealerInfo的Dao
    /// </summary>
    public class DealerInfoDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
        public DealerInfoDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public DealerInfo GetObject(Guid objKey)
        {
            DealerInfo obj = this.ExecuteQueryForObject<DealerInfo>("SelectDealerInfo", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<DealerInfo> GetAll()
        {
            IList<DealerInfo> list = this.ExecuteQueryForList<DealerInfo>("SelectDealerInfo", null);          
            return list;
        }


        /// <summary>
        /// 查询DealerInfo
        /// </summary>
        /// <returns>返回DealerInfo集合</returns>
		public IList<DealerInfo> SelectByFilter(DealerInfo obj)
		{ 
			IList<DealerInfo> list = this.ExecuteQueryForList<DealerInfo>("SelectByFilterDealerInfo", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(DealerInfo obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateDealerInfo", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteDealerInfo", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(DealerInfo obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteDealerInfo", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(DealerInfo obj)
        {
            this.ExecuteInsert("InsertDealerInfo", obj);           
        }

        public DataSet GetDealerInfoAllByModleID(Guid ModleID)
        {
            DataSet ds = base.ExecuteQueryForDataSet("SelectDealerInfoAllbyModleID", ModleID);
            return ds;
        }

        public DataSet GetDealerInfoMain(Hashtable obj)
        {
            DataSet ds = base.ExecuteQueryForDataSet("SelectDealerInfoByMain", obj);
            return ds;
        }

        public DataSet GetDealerVersionByCustCD(Hashtable obj)
        {
            DataSet ds = base.ExecuteQueryForDataSet("SelectVersionByCustCD", obj);
            return ds;
        }

        public DataSet MaintainBasicData(Hashtable obj)
        {
            DataSet ds = base.ExecuteQueryForDataSet("InsertDealersInformation", obj);
             return ds;
        }

        public DataSet GetDearDataForLatest(string obj)
        {
            DataSet ds = base.ExecuteQueryForDataSet("GetDearDataForLatest", obj);
            return ds;
        }

        public DataSet GetDealerDataByVersion(Hashtable obj)
        {
            DataSet ds = base.ExecuteQueryForDataSet("GetDearDataByVersion", obj);
            return ds;
        }

        public DataSet GetGridData(string obj)
        {
            DataSet ds = base.ExecuteQueryForDataSet("SelectGridData", obj);
            return ds;
        }

        public DataSet GetVersionComparison(Hashtable obj)
        {
            DataSet ds = base.ExecuteQueryForDataSet("SelectVersionComparison", obj);
            return ds;
        }

        public DataSet GetKeyPerformance(Hashtable obj)
        {
            DataSet ds = base.ExecuteQueryForDataSet("SelectGetKeyPerformance", obj);
            return ds;
        }

        public DataSet GetKeyPerformanceForKPI(Hashtable obj)
        {
            DataSet ds = base.ExecuteQueryForDataSet("SelectGetKeyPerformanceForKPI", obj);
            return ds;
        }

        public DataSet GetKPILogeDate(Hashtable obj)
        {
            DataSet ds = base.ExecuteQueryForDataSet("SelectKPILogeDate", obj);
            return ds;
        }

        public DataSet GetKPIStandard(Hashtable obj)
        {
            DataSet ds = base.ExecuteQueryForDataSet("SelectKPIStandard", obj);
            return ds;
        }
       
        public int DeleteDealerInfo(Hashtable obj)
        {
            //this.LogRuntimeSql("DeleteDealerInfoByModleID", obj);
            int cnt = (int)this.ExecuteDelete("DeleteDealerInfoByModleID", obj);
            return cnt;
        }

        public DataSet GetDstrTwoByUdstrId(string obj)
        {
            DataSet ds = base.ExecuteQueryForDataSet("SelectDstrTwoByUdstrId", obj);
            return ds;
        }

        public DataSet GetFModePermissions(Hashtable obj)
        {
            DataSet ds = base.ExecuteQueryForDataSet("SelectFModePermissions", obj);
            return ds;
        }


        // added by songyuqi on 2012.05.23
        public DataSet GetDealerInfoBySmallClass(Hashtable table)
        {
            DataSet ds = base.ExecuteQueryForDataSet("SelectDealerInfoBySmallClass", table);
            return ds;
        }

        public DataSet SelectDealerInfoByUdstrDP(Hashtable table)
        {
            DataSet ds = base.ExecuteQueryForDataSet("SelectDealerInfoByUdstrDP", table);
            return ds;
        }
        //end


        public DataSet GetKPIStandardList(Hashtable obj)
        {
            DataSet ds = base.ExecuteQueryForDataSet("SelectKPIStandardList", obj);
            return ds;
        }

        public DataSet GetKPIStandardByKPIDateAndModleID(Hashtable obj)
        {
            DataSet ds = base.ExecuteQueryForDataSet("SelectKPIStandardByKPIDateAndModleID", obj);
            return ds;
        }

        public int DeleteKPIStandard(Hashtable obj)
        {
            //this.LogRuntimeSql("DeleteKPIStandardByModleIDAndKPIDate", obj);
            int cnt = (int)this.ExecuteDelete("DeleteKPIStandardByModleIDAndKPIDate", obj);
            return cnt;
        }

        public DataSet GetCheckIsNoHaveYear(Hashtable obj)
        {
            DataSet ds = base.ExecuteQueryForDataSet("CheckIsNoHaveYear", obj);
            return ds;
        }

        public int UpdateDealerInfoForAssessData(Hashtable obj)
        {
            //this.LogRuntimeSql("UpdateDealerInfoForAssessData", obj);
            int cnt = (int)this.ExecuteDelete("UpdateDealerInfoForAssessData", obj);
            return cnt;
        }

        public DataSet InsertKPIStandard(Hashtable obj)
        {
            DataSet ds = base.ExecuteQueryForDataSet("InsertKPIStandard", obj);
            return ds;
        }


        public DataSet GetDepartmentByTrain(Hashtable obj)
        {
            DataSet ds = base.ExecuteQueryForDataSet("SelectDepartment", obj);
            return ds;
        }

        public DataSet GetDstrByUdstrId(string UdstrId)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectTDstrByUdstrId", UdstrId);
            return ds;
        }

        //获取合同信息
        public DataSet GetContractDate(string Cust_CD)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectContractDate", Cust_CD);
            return ds;
        }
        //获取文件信息
        public DataSet GetAuthorizeDate(string Cust_CD)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectAuthorizeDate", Cust_CD);
            return ds;
        }

        //获取奖励信息
        public DataSet GetRewardDate(string Cust_CD)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectRewardDate", Cust_CD);
            return ds;
        }

        //获取处罚信息
        public DataSet GetPunishDate(string Cust_CD)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectPunishDate", Cust_CD);
            return ds;
        }

        //获取处罚信息
        public DataSet GetRight(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("GetRight", obj);
            return ds;
        }

        public DataSet GetGridDataByPMID(Hashtable obj)
        {
            DataSet ds = base.ExecuteQueryForDataSet("SelectGridDataByPMID", obj);
            return ds;
        }

        public DataSet GetDealerLatestDataByPMID(Hashtable obj)
        {
            DataSet ds = base.ExecuteQueryForDataSet("GetDealerLatestDataByPMID", obj);
            return ds;
        }

        public DataSet GetDealerDetailByPMID(Hashtable obj)
        {
            DataSet ds = base.ExecuteQueryForDataSet("GetDealerDetailByPMID", obj);
            return ds;
        }

        public DataSet GetDateChanngNameGrid(Hashtable obj)
        {
            DataSet ds = base.ExecuteQueryForDataSet("GetDateChanngNameGrid", obj);
            return ds;
        }
        //Add by BSC Project
        public DataSet GetReminderTime()
        {
            DataSet ds = base.ExecuteQueryForDataSet("SelectReminderTime", null);
            return ds;
        }
        public DataSet GetDealerNameByID(string id)
        {
            DataSet ds = base.ExecuteQueryForDataSet("SelectDealerNameByID", id);
            return ds;
        }

        public DataSet GetRoleList(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            DataSet ds = base.ExecuteQueryForDataSet("SelectRoleList", obj, start, limit, out totalRowCount);
            return ds;
        }
    }
}