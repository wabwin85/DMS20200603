
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : ComplainInterface
 * Created Time: 2014/10/28 16:05:50
 *
 ****** Copyright (C) 2009/2010 - GrapeCity*****
 *
***********************************************/

using System;
using System.Collections;
using System.Collections.Generic;
using IBatisNet.DataMapper;
using DMS.Model;
using DMS.Model.DataInterface;

namespace DMS.DataAccess
{
    /// <summary>
    /// ComplainInterface的Dao
    /// </summary>
    public class ComplainInterfaceDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public ComplainInterfaceDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public ComplainInterface GetObject(Guid objKey)
        {
            ComplainInterface obj = this.ExecuteQueryForObject<ComplainInterface>("SelectComplainInterface", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<ComplainInterface> GetAll()
        {
            IList<ComplainInterface> list = this.ExecuteQueryForList<ComplainInterface>("SelectComplainInterface", null);          
            return list;
        }


        /// <summary>
        /// 查询ComplainInterface
        /// </summary>
        /// <returns>返回ComplainInterface集合</returns>
		public IList<ComplainInterface> SelectByFilter(ComplainInterface obj)
		{ 
			IList<ComplainInterface> list = this.ExecuteQueryForList<ComplainInterface>("SelectByFilterComplainInterface", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(ComplainInterface obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateComplainInterface", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteComplainInterface", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(ComplainInterface obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteComplainInterface", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(ComplainInterface obj)
        {
            this.ExecuteInsert("InsertComplainInterface", obj);           
        }

        public int InitComplainByClientID(Hashtable ht)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateComplainInterfaceForLpInitByClientID", ht);
            return cnt;
        }

        public IList<LpComplainData> QueryComplainInfoByBatchNbrForLp(string obj)
        {
            IList<LpComplainData> list = this.ExecuteQueryForList<LpComplainData>("QueryComplainInfoByBatchNbrForLp", obj);
            return list;
        }

        public void AfterComplainDataDownload(string BatchNbr, string ClientID, string Success, out string RtnVal)
        {
            RtnVal = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("BatchNbr", BatchNbr);
            ht.Add("ClientID", ClientID);
            ht.Add("Success", Success);
            ht.Add("RtnVal", RtnVal);

            this.ExecuteInsert("GC_LpComplain_AfterDownload", ht);

            RtnVal = ht["RtnVal"].ToString();
        }
    }
}