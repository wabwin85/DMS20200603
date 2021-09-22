
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : CalendarDate
 * Created Time: 2013/7/23 0:56:05
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
    /// CalendarDate的Dao
    /// </summary>
    public class CalendarDateDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public CalendarDateDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public CalendarDate GetObject(string objKey)
        {
            CalendarDate obj = this.ExecuteQueryForObject<CalendarDate>("SelectCalendarDate", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<CalendarDate> GetAll()
        {
            IList<CalendarDate> list = this.ExecuteQueryForList<CalendarDate>("SelectCalendarDate", null);          
            return list;
        }


        /// <summary>
        /// 查询CalendarDate
        /// </summary>
        /// <returns>返回CalendarDate集合</returns>
		public IList<CalendarDate> SelectByFilter(CalendarDate obj)
		{ 
			IList<CalendarDate> list = this.ExecuteQueryForList<CalendarDate>("SelectByFilterCalendarDate", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(CalendarDate obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateCalendarDate", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(string objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteCalendarDate", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(CalendarDate obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteCalendarDate", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(CalendarDate obj)
        {
            this.ExecuteInsert("InsertCalendarDate", obj);           
        }


    }
}