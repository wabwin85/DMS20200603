
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : Dealerqa
 * Created Time: 2013/9/2 16:53:03
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
    /// Dealerqa的Dao
    /// </summary>
    public class AttachmentDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public AttachmentDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public Attachment GetObject(Guid objKey)
        {
            Attachment obj = this.ExecuteQueryForObject<Attachment>("SelectAttachment", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<Attachment> GetAll()
        {
            IList<Attachment> list = this.ExecuteQueryForList<Attachment>("SelectAttachment", null);          
            return list;
        }


        /// <summary>
        /// 查询Attachment
        /// </summary>
        /// <returns>返回Attachment集合</returns>
        public IList<Attachment> SelectByFilter(Dealerqa obj)
		{
            IList<Attachment> list = this.ExecuteQueryForList<Attachment>("SelectByFilterAttachment", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(Attachment obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateAttachment", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteAttachment", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(Attachment obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteAttachment", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(Attachment obj)
        {
            this.ExecuteInsert("InsertAttachment", obj);           
        }

        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public string InsertContractAttachment(Hashtable attInfo)
        {
            Hashtable obj = base.ExecuteQueryForObject<Hashtable>("InsertContractAttachment", attInfo);
            return obj["AttId"].ToString();
        }

        /// <summary>
        /// 查询Attachment
        /// </summary>
        /// <returns>返回Attachment集合</returns>
        public DataSet GetAttachmentByMainId(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryAttachmentByMainId", table);
            return ds;
        }

        /// <summary>
        /// 查询Attachment
        /// </summary>
        /// <param name="table"></param>
        /// <param name="start"></param>
        /// <param name="limit"></param>
        /// <param name="totalRowCount"></param>
        /// <returns></returns>
        public DataSet GetAttachmentByMainId(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryAttachmentByMainId", table, start, limit, out totalRowCount);
            return ds;
        }

        /// <summary>
        /// 查询Contract Attachment
        /// </summary>
        /// <param name="table"></param>
        /// <param name="start"></param>
        /// <param name="limit"></param>
        /// <param name="totalRowCount"></param>
        /// <returns></returns>
        public DataSet GetContractAttachmentByMainId(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryContractAttachmentByMainId", table, start, limit, out totalRowCount);
            return ds;
        }

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int UpdateAttachmentName(Hashtable table)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateAttachmentName", table);
            return cnt;
        }

        public DataSet GetAttachment(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryAttachment", table, start, limit, out totalRowCount);
            return ds;
        }

        public DataSet GetAttachmentContract(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryAttachmentContract", table, start, limit, out totalRowCount);
            return ds;
        }

        public DataSet GetAttachmentContractForDD(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryAttachmentContractForDD", table, start, limit, out totalRowCount);
            return ds;
        }

        public void SendMailByDCMSAnnexNotice(Hashtable table) 
        {
            this.ExecuteQueryForDataSet("SendMailByDCMSAnnexNotice", table);
        }


        /// <summary>
        /// 查询Attachment
        /// </summary>
        /// <returns>返回Attachment集合</returns>
        public DataSet GetAttachmentOther(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryAttachmentOther", table, start, limit, out totalRowCount);
            return ds;
        }

        //Add By SongWeiming on 2015-09-16 For GSP Project 
        //更新附件的ID
        public int UpdateAttachmentMainID(Hashtable table)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateAttachmentMainID", table);
            return cnt;
        }

        //将新添加的附件作为正式的附件
        public int UpdateAttachmentTempMainIDToDealerID(Hashtable table)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateAttachmentTempMainIDToDealerID", table);
            return cnt;
        }

        //End Add By SongWeiming on 2015-09-16

        #region Added By Song Yuqi On 2017-05-05
        public DataSet QueryAttachmentForShipmentAttachment(Hashtable table)
        {
            DataSet list = this.ExecuteQueryForDataSet("QueryAttachmentForShipmentAttachment", table);
            return list;
        }
        #endregion

        public DataTable QueryAttachmentByFilter(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryAttachment", table);
            return ds.Tables[0];
        }
    }
}