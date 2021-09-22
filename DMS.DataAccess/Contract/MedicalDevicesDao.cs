
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : MedicalDevices
 * Created Time: 2013/11/12 17:41:42
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
    /// MedicalDevices的Dao
    /// </summary>
    public class MedicalDevicesDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public MedicalDevicesDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public MedicalDevices GetObject(Guid objKey)
        {
            MedicalDevices obj = this.ExecuteQueryForObject<MedicalDevices>("SelectMedicalDevices", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<MedicalDevices> GetAll()
        {
            IList<MedicalDevices> list = this.ExecuteQueryForList<MedicalDevices>("SelectMedicalDevices", null);          
            return list;
        }


        /// <summary>
        /// 查询MedicalDevices
        /// </summary>
        /// <returns>返回MedicalDevices集合</returns>
		public IList<MedicalDevices> SelectByFilter(MedicalDevices obj)
		{ 
			IList<MedicalDevices> list = this.ExecuteQueryForList<MedicalDevices>("SelectByFilterMedicalDevices", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(MedicalDevices obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateMedicalDevices", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteMedicalDevices", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(MedicalDevices obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteMedicalDevices", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(MedicalDevices obj)
        {
            this.ExecuteInsert("InsertMedicalDevices", obj);           
        }

        /// <summary>
        /// 查询MedicalDevices
        /// </summary>
        /// <returns>返回MedicalDevices集合</returns>
        public DataSet SelectMedicalDevicesByFilter(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectMedicalDevicesByFilter", table);
            return ds;
        }

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int UpdateMedicalDevicesByFilter(MedicalDevices obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateMedicalDevicesByFilter", obj);
            return cnt;
        }

    }
}