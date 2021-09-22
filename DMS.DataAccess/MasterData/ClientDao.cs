
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : Client
 * Created Time: 2013/7/16 10:33:14
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
    /// Client的Dao
    /// </summary>
    public class ClientDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public ClientDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public Client GetObject(string objKey)
        {
            Client obj = this.ExecuteQueryForObject<Client>("SelectClient", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<Client> GetAll()
        {
            IList<Client> list = this.ExecuteQueryForList<Client>("SelectClient", null);          
            return list;
        }


        /// <summary>
        /// 查询Client
        /// </summary>
        /// <returns>返回Client集合</returns>
		public IList<Client> SelectByFilter(Client obj)
		{ 
			IList<Client> list = this.ExecuteQueryForList<Client>("SelectByFilterClient", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(Client obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateClient", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(string objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteClient", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(Client obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteClient", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(Client obj)
        {
            this.ExecuteInsert("InsertClient", obj);
        }

        #region added by bozhenfei on 20130716
        /// <summary>
        /// 根据CorpId取得客户端信息
        /// </summary>
        /// <param name="corpId"></param>
        /// <returns></returns>
        public Client SelectClientByCorpId(Guid corpId)
        {
            Client obj = this.ExecuteQueryForObject<Client>("SelectClientByCorpId", corpId);
            return obj;
        }

        /// <summary>
        /// 根据CorpId取得上级经销商的客户端信息
        /// </summary>
        /// <param name="corpId"></param>
        /// <returns></returns>
        public Client SelectParentClientByCorpId(Guid corpId)
        {
            Client obj = this.ExecuteQueryForObject<Client>("SelectParentClient", corpId);
            return obj;
        }
        #endregion
    }
}