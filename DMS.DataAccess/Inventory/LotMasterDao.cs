
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.Model 
 * ClassName   : LotMaster
 * Created Time: 2009-7-21 11:07:13 AM
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
    /// LotMaster的Dao
    /// </summary>
    public class LotMasterDao : BaseSqlMapDao
    {

        /// <summary>
        /// 默认构造函数

        /// </summary>
        public LotMasterDao()
            : base()
        {
        }

        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public LotMaster GetObject(Guid objKey)
        {
            LotMaster obj = this.ExecuteQueryForObject<LotMaster>("SelectLotMaster", objKey);
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<LotMaster> GetAll()
        {
            IList<LotMaster> list = this.ExecuteQueryForList<LotMaster>("SelectLotMaster", null);
            return list;
        }


        /// <summary>
        /// 查询LotMaster
        /// </summary>
        /// <returns>返回LotMaster集合</returns>
        public IList<LotMaster> SelectByFilter(LotMaster obj)
        {
            IList<LotMaster> list = this.ExecuteQueryForList<LotMaster>("SelectByFilterLotMaster", obj);
            return list;
        }

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(LotMaster obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateLotMaster", obj);
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(LotMaster obj)
        {
            int cnt = (int)this.ExecuteDelete("DeleteLotMaster", obj);
            return cnt;
        }




        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(LotMaster obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteLotMaster", obj);
            return cnt;
        }

        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(LotMaster obj)
        {
            this.ExecuteInsert("InsertLotMaster", obj);
        }

        public IList<LotMaster> SelectLotMasterByLotNumber(Hashtable ht)
        {
            IList<LotMaster> list = this.ExecuteQueryForList<LotMaster>("SelectLotMasterByLotNumber", ht);
            return list;
        }

        public IList<LotMaster> SelectLotMasterByLotNumberCFN(Hashtable ht)
        {
            IList<LotMaster> list = this.ExecuteQueryForList<LotMaster>("SelectLotMasterByLotNumberCFN", ht);
            return list;
        }

        public DataSet P_GetLotMaster(string currentdate)
        {
            return this.ExecuteQueryForDataSet("P_GetLotMaster", currentdate);
        }
        public IList<LotMaster> SelectLotMasterByLotNumberCFNQuCode(Hashtable ht)
        {
            IList<LotMaster> list = this.ExecuteQueryForList<LotMaster>("SelectLotMasterByLotNumberCFNQuCode", ht);
            return list;
        }
        public IList<LotMaster> SelectLotMasterByLotNumberPMAId(Hashtable ht)
        {
            IList<LotMaster> list = this.ExecuteQueryForList<LotMaster>("SelectLotMasterByLotNumberPMAId", ht);
            return list;
        }

        public IList<QrCodeInventoryData> SelectDealerInventoryForHospital(Hashtable ht)
        {
            IList<QrCodeInventoryData> list = this.ExecuteQueryForList<QrCodeInventoryData>("SelectDealerInventoryForHospital", ht);
            return list;
        }
        
        //红会医院接口查询
        public IList<QrCodeInventoryForRedCrossData> SelectDealerInventoryForRedCross(Hashtable ht)
        {
            IList<QrCodeInventoryForRedCrossData> list = this.ExecuteQueryForList<QrCodeInventoryForRedCrossData>("SelectDealerInventoryForRedCross", ht);
            return list;
        }

        //SelectDealerInventoryForRedCross
    }
}