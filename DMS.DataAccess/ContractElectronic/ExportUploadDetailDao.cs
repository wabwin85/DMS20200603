
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : ExportUploadDetail
 * Created Time: 2018/11/19 17:39:11
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
    /// ExportUploadDetail的Dao
    /// </summary>
    public class ExportUploadDetailDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public ExportUploadDetailDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public ExportUploadDetail GetObject(Guid objKey)
        {
            ExportUploadDetail obj = this.ExecuteQueryForObject<ExportUploadDetail>("SelectExportUploadDetail", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<ExportUploadDetail> GetAll()
        {
            IList<ExportUploadDetail> list = this.ExecuteQueryForList<ExportUploadDetail>("SelectExportUploadDetail", null);          
            return list;
        }


        /// <summary>
        /// 查询ExportUploadDetail
        /// </summary>
        /// <returns>返回ExportUploadDetail集合</returns>
		public IList<ExportUploadDetail> SelectByFilter(ExportUploadDetail obj)
		{ 
			IList<ExportUploadDetail> list = this.ExecuteQueryForList<ExportUploadDetail>("SelectByFilterExportUploadDetail", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(ExportUploadDetail obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateExportUploadDetail", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteExportUploadDetail", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(ExportUploadDetail obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteExportUploadDetail", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(ExportUploadDetail obj)
        {
            this.ExecuteInsert("InsertExportUploadDetail", obj);           
        }


        public ExportUploadDetail QueryUploadFileByDealerId(Hashtable table)
        {
            ExportUploadDetail obj = this.ExecuteQueryForObject<ExportUploadDetail>("QueryUploadFileByDealerId", table);
            return obj;
        }

        public DataTable QueryUploadFileTemplateByDealerId(Hashtable table)
        {
            DataSet ds = base.ExecuteQueryForDataSet("QueryUploadFileTemplateByDealerId", table);
            return ds.Tables[0];
        }
        
    }
}