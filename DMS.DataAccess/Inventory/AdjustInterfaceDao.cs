
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : AdjustInterface
 * Created Time: 2013/7/29 12:24:48
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
    /// AdjustInterface的Dao
    /// </summary>
    public class AdjustInterfaceDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public AdjustInterfaceDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public AdjustInterface GetObject(Guid objKey)
        {
            AdjustInterface obj = this.ExecuteQueryForObject<AdjustInterface>("SelectAdjustInterface", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<AdjustInterface> GetAll()
        {
            IList<AdjustInterface> list = this.ExecuteQueryForList<AdjustInterface>("SelectAdjustInterface", null);          
            return list;
        }


        /// <summary>
        /// 查询AdjustInterface
        /// </summary>
        /// <returns>返回AdjustInterface集合</returns>
		public IList<AdjustInterface> SelectByFilter(AdjustInterface obj)
		{ 
			IList<AdjustInterface> list = this.ExecuteQueryForList<AdjustInterface>("SelectByFilterAdjustInterface", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(AdjustInterface obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateAdjustInterface", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteAdjustInterface", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(AdjustInterface obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteAdjustInterface", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(AdjustInterface obj)
        {
            this.ExecuteInsert("InsertAdjustInterface", obj);           
        }

        public int DeleteAdjustInterfaceByIahId(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteAdjustInterfaceByIahId", objKey);
            return cnt;
        }

        public IList<LpReturnData> QueryReturnDetailInfoByBatchNbrForLp(string batchNbr)
        {
            IList<LpReturnData> list = this.ExecuteQueryForList<LpReturnData>("QueryReturnDetailInfoByBatchNbrForLp", batchNbr);
            return list;
        }

        public IList<T2ReturnData> QueryReturnDetailInfoByBatchNbrForT2(string batchNbr)
        {
            IList<T2ReturnData> list = this.ExecuteQueryForList<T2ReturnData>("QueryReturnDetailInfoByBatchNbrForT2", batchNbr);
            return list;
        }


        /// <summary>
        /// 根据客户端ID初始化LP自己的退货单数据
        /// </summary>
        /// <param name="ht"></param>
        /// <returns></returns>
        public int InitLPReturnByClientID(Hashtable ht)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateAdjustReturnInterfaceForLpInitByClientID", ht);
            return cnt;
        }

        /// <summary>
        /// 根据客户端ID初始化T2的退货单数据
        /// </summary>
        /// <param name="ht"></param>
        /// <returns></returns>
        public int InitT2ReturnByClientID(Hashtable ht)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateAdjustReturnInterfaceForT2InitByClientID", ht);
            return cnt;
        }

        public void AfterDownload(string BatchNbr, string ClientID, string Success, out string RtnVal)
        {
            RtnVal = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("BatchNbr", BatchNbr);
            ht.Add("ClientID", ClientID);
            ht.Add("Success", Success);
            ht.Add("RtnVal", RtnVal);

            this.ExecuteInsert("GC_LPReturn_AfterDownload", ht);

            RtnVal = ht["RtnVal"].ToString();
        }

        /// <summary>
        /// 根据客户端ID初始化T2的寄售转销售单数据
        /// </summary>
        /// <param name="ht"></param>
        /// <returns></returns>
        public int InitT2CTOSByClientID(Hashtable ht)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateAdjustCTOSInterfaceForT2InitByClientID", ht);
            return cnt;
        }

        public IList<T2ConsignToSellingData> QueryCTOSDetailInfoByBatchNbr(string batchNbr)
        {
            IList<T2ConsignToSellingData> list = this.ExecuteQueryForList<T2ConsignToSellingData>("QueryCTOSDetailInfoByBatchNbr", batchNbr);
            return list;
        }
    }
}