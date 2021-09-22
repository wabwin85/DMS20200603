
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : InterfaceShipmentbscslc
 * Created Time: 2015/12/7 17:03:18
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
    /// InterfaceShipmentbscslc的Dao
    /// </summary>
    public class InterfaceShipmentbscslcDao : BaseSqlMapDao
    {

        /// <summary>
        /// 默认构造函数
        /// </summary>
        public InterfaceShipmentbscslcDao()
            : base()
        {
        }

        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public InterfaceShipmentbscslc GetObject(Guid objKey)
        {
            InterfaceShipmentbscslc obj = this.ExecuteQueryForObject<InterfaceShipmentbscslc>("SelectInterfaceShipmentbscslc", objKey);
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<InterfaceShipmentbscslc> GetAll()
        {
            IList<InterfaceShipmentbscslc> list = this.ExecuteQueryForList<InterfaceShipmentbscslc>("SelectInterfaceShipmentbscslc", null);
            return list;
        }


        /// <summary>
        /// 查询InterfaceShipmentbscslc
        /// </summary>
        /// <returns>返回InterfaceShipmentbscslc集合</returns>
        public IList<InterfaceShipmentbscslc> SelectByFilter(InterfaceShipmentbscslc obj)
        {
            IList<InterfaceShipmentbscslc> list = this.ExecuteQueryForList<InterfaceShipmentbscslc>("SelectByFilterInterfaceShipmentbscslc", obj);
            return list;
        }

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(InterfaceShipmentbscslc obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateInterfaceShipmentbscslc", obj);
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteInterfaceShipmentbscslc", objKey);
            return cnt;
        }




        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(InterfaceShipmentbscslc obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteInterfaceShipmentbscslc", obj);
            return cnt;
        }

        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(InterfaceShipmentbscslc obj)
        {
            this.ExecuteInsert("InsertInterfaceShipmentbscslc", obj);
        }

        
        
        //增加畅联波科发货数据接口（校验接口数据），Add By SongWeiming on 2015-12-07
        public void HandleShipmentBSCSLCData(string BatchNbr, string ClientID, out string IsValid, out string RtnMsg)
        {
            IsValid = string.Empty;
            RtnMsg = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("BatchNbr", BatchNbr);
            ht.Add("ClientID", ClientID);
            ht.Add("IsValid", IsValid);
            ht.Add("RtnMsg", RtnMsg);

            this.ExecuteInsert("GC_Interface_ShipmentBSCSLC", ht);

            IsValid = ht["IsValid"].ToString();
            RtnMsg = ht["RtnMsg"].ToString();
        }


    }
}