
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : InterfaceAdjust
 * Created Time: 2013/7/12 14:48:24
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
    /// InterfaceAdjust的Dao
    /// </summary>
    public class InterfaceAdjustDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public InterfaceAdjustDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public InterfaceAdjust GetObject(Guid objKey)
        {
            InterfaceAdjust obj = this.ExecuteQueryForObject<InterfaceAdjust>("SelectInterfaceAdjust", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<InterfaceAdjust> GetAll()
        {
            IList<InterfaceAdjust> list = this.ExecuteQueryForList<InterfaceAdjust>("SelectInterfaceAdjust", null);          
            return list;
        }


        /// <summary>
        /// 查询InterfaceAdjust
        /// </summary>
        /// <returns>返回InterfaceAdjust集合</returns>
		public IList<InterfaceAdjust> SelectByFilter(InterfaceAdjust obj)
		{ 
			IList<InterfaceAdjust> list = this.ExecuteQueryForList<InterfaceAdjust>("SelectByFilterInterfaceAdjust", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(InterfaceAdjust obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateInterfaceAdjust", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteInterfaceAdjust", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(InterfaceAdjust obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteInterfaceAdjust", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(InterfaceAdjust obj)
        {
            this.ExecuteInsert("InsertInterfaceAdjust", obj);           
        }

        public void HandleAdjustData(string BatchNbr, string ClientID, string SubCompanyId,string BrandId, out string RtnVal, out string RtnMsg)
        {
            RtnVal = string.Empty;
            RtnMsg = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("BatchNbr", BatchNbr);
            ht.Add("ClientID", ClientID);
            ht.Add("SubCompanyId", SubCompanyId);
            ht.Add("BrandId", BrandId);
            ht.Add("RtnVal", RtnVal);
            ht.Add("RtnMsg", RtnMsg);

            this.ExecuteInsert("GC_Interface_Adjust", ht);

            RtnVal = ht["RtnVal"].ToString();
            RtnMsg = ht["RtnMsg"].ToString();
        }
    }
}