
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : SendInvoiceInit
 * Created Time: 2011-2-10 14:13:37
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
    /// SendInvoiceInit的Dao
    /// </summary>
    public class SendInvoiceInitDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public SendInvoiceInitDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public SendInvoiceInit GetObject(Guid objKey)
        {
            SendInvoiceInit obj = this.ExecuteQueryForObject<SendInvoiceInit>("SelectSendInvoiceInit", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<SendInvoiceInit> GetAll()
        {
            IList<SendInvoiceInit> list = this.ExecuteQueryForList<SendInvoiceInit>("SelectSendInvoiceInit", null);          
            return list;
        }


        /// <summary>
        /// 查询SendInvoiceInit
        /// </summary>
        /// <returns>返回SendInvoiceInit集合</returns>
		public IList<SendInvoiceInit> SelectByFilter(SendInvoiceInit obj)
		{ 
			IList<SendInvoiceInit> list = this.ExecuteQueryForList<SendInvoiceInit>("SelectByFilterSendInvoiceInit", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(SendInvoiceInit obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateSendInvoiceInit", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteSendInvoiceInit", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(SendInvoiceInit obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteSendInvoiceInit", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(SendInvoiceInit obj)
        {
            this.ExecuteInsert("InsertSendInvoiceInit", obj);           
        }

        /// <summary>
        /// 调用存储过程
        /// </summary>
        /// <param name="UserId"></param>
        /// <param name="FileName"></param>
        /// <returns></returns>
        public string Initialize(Guid UserId)
        {
            string IsValid = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("UserId", UserId);
            ht.Add("IsValid", IsValid);

            this.ExecuteInsert("GC_UploadSendInvoice", ht);

            IsValid = ht["IsValid"].ToString();

            return IsValid;
        }

        /// <summary>
        /// 根据USERID删除上传记录
        /// </summary>
        /// <param name="UserId"></param>
        /// <returns></returns>
        public int DeleteByUserId(Guid UserId)
        {
            int cnt = (int)this.ExecuteUpdate("DeleteByUserIdSendInvoiceInit", UserId);
            return cnt;
        }

        /// <summary>
        /// 根据USERID获取上传错误信息
        /// </summary>
        /// <param name="obj"></param>
        /// <returns></returns>
        public DataSet GetErrorList(Guid UserId)
        {
            SendInvoiceInit obj = new SendInvoiceInit();
            obj.User = UserId;
            DataSet ds = this.ExecuteQueryForDataSet("SelectByUserIdSendInvoiceInit", obj);
            return ds;
        }

    }
}