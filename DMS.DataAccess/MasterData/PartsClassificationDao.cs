
/**********************************************

 * NameSpace   : DMS.DataAccess 
 * ClassName   : PartsClassification
 * Created Time: 2009-7-6 13:11:30
 * Author      : Donson
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
    /// PartsClassification的Dao
    /// </summary>
    public class PartsClassificationDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public PartsClassificationDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public PartsClassification GetObject(Guid objKey)
        {
            PartsClassification obj = this.ExecuteQueryForObject<PartsClassification>("SelectPartsClassification", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<PartsClassification> GetAll()
        {
            IList<PartsClassification> list = this.ExecuteQueryForList<PartsClassification>("SelectPartsClassification", null);          
            return list;
        }

        /// <summary>
        /// 得到树的根节点
        /// </summary>
        /// <returns></returns>
        public IList<PartsClassification> GetRoot()
        {
            IList<PartsClassification> list = this.ExecuteQueryForList<PartsClassification>("SelectRootPartsClassification", null);
            return list;
        }

        /// <summary>
        /// 查询PartsClassification
        /// </summary>
        /// <returns>返回PartsClassification集合</returns>
		public IList<PartsClassification> SelectByFilter(PartsClassification obj)
		{ 
			IList<PartsClassification> list = this.ExecuteQueryForList<PartsClassification>("SelectByFilterPartsClassification", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(PartsClassification obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdatePartsClassification", obj);            
            return cnt;
        }

        public string ModifyPartsClassification(Hashtable obj)
        {
            string IsValid = string.Empty;

            this.ExecuteInsert("ModifyPartsClassification", obj);

            IsValid = obj["IsValid"].ToString();
            return IsValid;
        }


        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid partId)
        {
            int cnt = (int)this.ExecuteDelete("DeletePartsClassification", partId);            
            return cnt;
        }

	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(PartsClassification obj)
        {
            this.ExecuteInsert("InsertPartsClassification", obj);           
        }


    }
}