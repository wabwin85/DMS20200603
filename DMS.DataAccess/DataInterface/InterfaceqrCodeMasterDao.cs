
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : InterfaceqrCodeMaster
 * Created Time: 2015/12/10 16:37:02
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
    /// InterfaceqrCodeMaster的Dao
    /// </summary>
    public class InterfaceqrCodeMasterDao : BaseSqlMapDao
    {

        /// <summary>
        /// 默认构造函数
        /// </summary>
        public InterfaceqrCodeMasterDao()
            : base()
        {
        }

        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public InterfaceqrCodeMaster GetObject(Guid objKey)
        {
            InterfaceqrCodeMaster obj = this.ExecuteQueryForObject<InterfaceqrCodeMaster>("SelectInterfaceqrCodeMaster", objKey);
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<InterfaceqrCodeMaster> GetAll()
        {
            IList<InterfaceqrCodeMaster> list = this.ExecuteQueryForList<InterfaceqrCodeMaster>("SelectInterfaceqrCodeMaster", null);
            return list;
        }


        /// <summary>
        /// 查询InterfaceqrCodeMaster
        /// </summary>
        /// <returns>返回InterfaceqrCodeMaster集合</returns>
        public IList<InterfaceqrCodeMaster> SelectByFilter(InterfaceqrCodeMaster obj)
        {
            IList<InterfaceqrCodeMaster> list = this.ExecuteQueryForList<InterfaceqrCodeMaster>("SelectByFilterInterfaceqrCodeMaster", obj);
            return list;
        }

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(InterfaceqrCodeMaster obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateInterfaceqrCodeMaster", obj);
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteInterfaceqrCodeMaster", objKey);
            return cnt;
        }




        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(InterfaceqrCodeMaster obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteInterfaceqrCodeMaster", obj);
            return cnt;
        }

        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(InterfaceqrCodeMaster obj)
        {
            this.ExecuteInsert("InsertInterfaceqrCodeMaster", obj);
        }


        //增加二维码主数据接口（校验接口数据），Add By SongWeiming on 2015-12-10
        public void HandleQRMasterData(string BatchNbr, string ClientID, out string IsValid, out string RtnMsg)
        {
            IsValid = string.Empty;
            RtnMsg = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("BatchNbr", BatchNbr);
            ht.Add("ClientID", ClientID);
            ht.Add("IsValid", IsValid);
            ht.Add("RtnMsg", RtnMsg);

            this.ExecuteInsert("GC_Interface_QRCodeMaster", ht);

            IsValid = ht["IsValid"].ToString();
            RtnMsg = ht["RtnMsg"].ToString();
        }

        //获取二维码接口中的错误信息，Add By SongWeiming on 2015-12-10
        public IList<InterfaceqrCodeMaster> SelectInterfaceQRCodeMasterByBatchNbrErrorOnly(string batchNbr)
        {
            IList<InterfaceqrCodeMaster> list = this.ExecuteQueryForList<InterfaceqrCodeMaster>("SelectInterfaceQRCodeMasterByBatchNbrErrorOnly", batchNbr);
            return list;
        }

    }
}