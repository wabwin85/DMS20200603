
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : QrCodeMaster
 * Created Time: 2015/12/25 11:01:52
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
using DMS.Model.DataInterface;

namespace DMS.DataAccess
{
    /// <summary>
    /// QrCodeMaster的Dao
    /// </summary>
    public class QrCodeMasterDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public QrCodeMasterDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public QrCodeMaster GetObject(Guid objKey)
        {
            QrCodeMaster obj = this.ExecuteQueryForObject<QrCodeMaster>("SelectQrCodeMaster", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<QrCodeMaster> GetAll()
        {
            IList<QrCodeMaster> list = this.ExecuteQueryForList<QrCodeMaster>("SelectQrCodeMaster", null);          
            return list;
        }


        /// <summary>
        /// 查询QrCodeMaster
        /// </summary>
        /// <returns>返回QrCodeMaster集合</returns>
		public IList<QrCodeMaster> SelectByFilter(QrCodeMaster obj)
		{ 
			IList<QrCodeMaster> list = this.ExecuteQueryForList<QrCodeMaster>("SelectByFilterQrCodeMaster", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(QrCodeMaster obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateQrCodeMaster", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteQrCodeMaster", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(QrCodeMaster obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteQrCodeMaster", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(QrCodeMaster obj)
        {
            this.ExecuteInsert("InsertQrCodeMaster", obj);           
        }

        public DataSet QueryQrCodeIsExist(string QrCode)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectIsExistByQrCode", QrCode);
            return ds;
        }


        public IList<ChannelLogisticInfoWithQRData> SelectChannelLogisticInfoWithQR(string QrCode)
        {
            IList<ChannelLogisticInfoWithQRData> list = this.ExecuteQueryForList<ChannelLogisticInfoWithQRData>("SelectChannelLogisticInfoWithQR", QrCode);
            return list;
        }
    }
}