
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : InterfaceTransfer
 * Created Time: 2013/7/12 14:48:26
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
    /// InterfaceTransfer的Dao
    /// </summary>
    public class InterfaceTransferDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public InterfaceTransferDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public InterfaceTransfer GetObject(Guid objKey)
        {
            InterfaceTransfer obj = this.ExecuteQueryForObject<InterfaceTransfer>("SelectInterfaceTransfer", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<InterfaceTransfer> GetAll()
        {
            IList<InterfaceTransfer> list = this.ExecuteQueryForList<InterfaceTransfer>("SelectInterfaceTransfer", null);          
            return list;
        }


        /// <summary>
        /// 查询InterfaceTransfer
        /// </summary>
        /// <returns>返回InterfaceTransfer集合</returns>
		public IList<InterfaceTransfer> SelectByFilter(InterfaceTransfer obj)
		{ 
			IList<InterfaceTransfer> list = this.ExecuteQueryForList<InterfaceTransfer>("SelectByFilterInterfaceTransfer", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(InterfaceTransfer obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateInterfaceTransfer", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteInterfaceTransfer", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(InterfaceTransfer obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteInterfaceTransfer", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(InterfaceTransfer obj)
        {
            this.ExecuteInsert("InsertInterfaceTransfer", obj);           
        }

        public void HandleTransferData(string BatchNbr, string ClientID, string SubCompanyId, string BrandId, out string RtnVal, out string RtnMsg)
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

            this.ExecuteInsert("GC_Interface_Transfer", ht);

            RtnVal = ht["RtnVal"].ToString();
            RtnMsg = ht["RtnMsg"].ToString();
        }

        public void HandleTransferLSData(string BatchNbr, string ClientID, out string RtnVal, out string RtnMsg)
        {
            RtnVal = string.Empty;
            RtnMsg = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("BatchNbr", BatchNbr);
            ht.Add("ClientID", ClientID);
            ht.Add("RtnVal", RtnVal);
            ht.Add("RtnMsg", RtnMsg);

            this.ExecuteInsert("GC_Interface_TransferForls", ht);

            RtnVal = ht["RtnVal"].ToString();
            RtnMsg = ht["RtnMsg"].ToString();
        }

        public void HandleTransferForlsData(string BatchNbr, string ClientID, string SubCompanyId, string BrandId, out string RtnVal, out string RtnMsg)
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

            this.ExecuteInsert("GC_Interface_Transfer", ht);

            RtnVal = ht["RtnVal"].ToString();
            RtnMsg = ht["RtnMsg"].ToString();
        }

    }
}