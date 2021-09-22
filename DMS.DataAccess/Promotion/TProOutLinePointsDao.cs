
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : TProOutLinePoints
 * Created Time: 2016/7/25 18:04:31
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
    /// TProOutLinePoints的Dao
    /// </summary>
    public class TProOutLinePointsDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public TProOutLinePointsDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public TProOutLinePoints GetObject(int objKey)
        {
            TProOutLinePoints obj = this.ExecuteQueryForObject<TProOutLinePoints>("SelectTProOutLinePoints", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<TProOutLinePoints> GetAll()
        {
            IList<TProOutLinePoints> list = this.ExecuteQueryForList<TProOutLinePoints>("SelectTProOutLinePoints", null);          
            return list;
        }


        /// <summary>
        /// 查询TProOutLinePoints
        /// </summary>
        /// <returns>返回TProOutLinePoints集合</returns>
		public IList<TProOutLinePoints> SelectByFilter(TProOutLinePoints obj)
		{ 
			IList<TProOutLinePoints> list = this.ExecuteQueryForList<TProOutLinePoints>("SelectByFilterTProOutLinePoints", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(TProOutLinePoints obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateTProOutLinePoints", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(int objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteTProOutLinePoints", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(TProOutLinePoints obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteTProOutLinePoints", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(TProOutLinePoints obj)
        {
            this.ExecuteInsert("InsertTProOutLinePoints", obj);           
        }
        /// <summary>
        /// 校验购买积分上传
        /// </summary>
        /// <param name="BatchNbr"></param>
        /// <param name="ClientID"></param>
        /// <param name="RtnVal"></param>
        /// <param name="RtnMsg"></param>
        public void HandleInterfaceOutLinePointsData(string BatchNbr, string ClientID, out string RtnVal, out string RtnMsg)
        {
            RtnVal = string.Empty;
            RtnMsg = string.Empty;
            Hashtable ht = new Hashtable();
            ht.Add("BatchNbr", BatchNbr);
            ht.Add("ClientID", ClientID);
            ht.Add("RtnVal", RtnVal);
            ht.Add("RtnMsg", RtnMsg);
            this.ExecuteInsert("GC_Interface_PROOutLinePoints", ht);
            RtnVal = ht["RtnVal"].ToString();
            RtnMsg = ht["RtnMsg"].ToString();
        }
        public IList<TProOutLinePoints> SelectInterfacePROOutLinePointsonByBatchNbrErrorOnly(string BatchNbr)
        {
            IList<TProOutLinePoints> list = this.ExecuteQueryForList<TProOutLinePoints>("SelectInterfacePROOutLinePointsonByBatchNbrErrorOnly", BatchNbr);
            return list;
        }
        public DataSet QueryDMSCalculatedPoints(string clientID)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryDMSCalculatedPoints", clientID);
            return ds;
        }
    }
}