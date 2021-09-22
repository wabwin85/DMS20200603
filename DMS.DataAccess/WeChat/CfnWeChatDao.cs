
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : CfnWeChat
 * Created Time: 2013/12/3 14:06:49
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
    /// CfnWeChat的Dao
    /// </summary>
    public class CfnWeChatDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public CfnWeChatDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public CfnWeChat GetObject(Guid objKey)
        {
            CfnWeChat obj = this.ExecuteQueryForObject<CfnWeChat>("SelectCfnWeChat", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<CfnWeChat> GetAll()
        {
            IList<CfnWeChat> list = this.ExecuteQueryForList<CfnWeChat>("SelectCfnWeChat", null);          
            return list;
        }


        /// <summary>
        /// 查询CfnWeChat
        /// </summary>
        /// <returns>返回CfnWeChat集合</returns>
		public IList<CfnWeChat> SelectByFilter(CfnWeChat obj)
		{ 
			IList<CfnWeChat> list = this.ExecuteQueryForList<CfnWeChat>("SelectByFilterCfnWeChat", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(CfnWeChat obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateCfnWeChat", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteCfnWeChat", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(CfnWeChat obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteCfnWeChat", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(CfnWeChat obj)
        {
            this.ExecuteInsert("InsertCfnWeChat", obj);           
        }


        /// <summary>
        /// 根据产品线得到产品等级信息
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public DataSet GetCfnLevel1ByProductLine(Guid productLineId)
        {
            DataSet ds = this.ExecuteQueryForDataSet("GetCfnLevel1ByProductLine", productLineId);
            return ds;
        }

        /// <summary>
        /// 根据产品线得到产品等级信息
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public DataSet GetCfnLevel2ByProductLine(Guid productLineId)
        {
            DataSet ds = this.ExecuteQueryForDataSet("GetCfnLevel2ByProductLine", productLineId);
            return ds;
        }

        public DataSet GetCfnLevel2ByFilter(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("GetCfnLevel2ByFilter", table);
            return ds;
        }
    }
}