
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.Model 
 * ClassName   : ShipmentLine
 * Created Time: 2009-8-13 13:51:16
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
    /// ShipmentLine的Dao
    /// </summary>
    public class ShipmentLineDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数

        /// </summary>
		public ShipmentLineDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public ShipmentLine GetObject(Guid objKey)
        {
            ShipmentLine obj = this.ExecuteQueryForObject<ShipmentLine>("SelectShipmentLine", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<ShipmentLine> GetAll()
        {
            IList<ShipmentLine> list = this.ExecuteQueryForList<ShipmentLine>("SelectShipmentLine", null);          
            return list;
        }


        /// <summary>
        /// 查询ShipmentLine
        /// </summary>
        /// <returns>返回ShipmentLine集合</returns>
		public IList<ShipmentLine> SelectByFilter(ShipmentLine obj)
		{ 
			IList<ShipmentLine> list = this.ExecuteQueryForList<ShipmentLine>("SelectByFilterShipmentLine", obj);          
            return list;
		}

        public IList<ShipmentLine> SelectByHashtable(Hashtable obj)
        {
            IList<ShipmentLine> list = this.ExecuteQueryForList<ShipmentLine>("SelectShipmentLineByHashtable", obj);
            return list;
        }

        public IList<ShipmentLine> SelectByHeaderId(Guid Id)
        {
            Hashtable param = new Hashtable();
            param.Add("SphId", Id);
            IList<ShipmentLine> list = this.ExecuteQueryForList<ShipmentLine>("SelectShipmentLineByHashtable", param);
            return list;
        }
        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(ShipmentLine obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateShipmentLine", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid id)
        {
            int cnt = (int)this.ExecuteDelete("DeleteShipmentLine", id);            
            return cnt;
        }


        public int DeleteByHeaderId(Guid id)
        {
            int cnt = (int)this.ExecuteDelete("DeleteShipmentLineByHeaderId", id);
            return cnt;
        }

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(ShipmentLine obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteShipmentLine", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(ShipmentLine obj)
        {
            this.ExecuteInsert("InsertShipmentLine", obj);           
        }

        public string DeleteShipmentNotAuthCfn(Hashtable obj)
        {
            string Result = "";
            obj.Add("retMassage", Result);
            this.ExecuteInsert("GC_DeleteShipmentNotAuthCfn", obj);

            Result = obj["retMassage"].ToString();

            return Result;
        }

        
    }
}