using DMS.Model;
using DMS.Model.DataInterface;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.DataAccess.DataInterface
{
    public class Interfacet2ContactInfoDao : BaseSqlMapDao
    {

        /// <summary>
        /// 默认构造函数
        /// </summary>
        public Interfacet2ContactInfoDao() : base()
        {
        }

        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public Interfacet2ContactInfo GetObject(Guid objKey)
        {
            Interfacet2ContactInfo obj = this.ExecuteQueryForObject<Interfacet2ContactInfo>("SelectInterfacet2ContactInfo", objKey);
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<Interfacet2ContactInfo> GetAll()
        {
            IList<Interfacet2ContactInfo> list = this.ExecuteQueryForList<Interfacet2ContactInfo>("SelectInterfacet2ContactInfo", null);
            return list;
        }


        /// <summary>
        /// 查询Interfacet2ContactInfo
        /// </summary>
        /// <returns>返回Interfacet2ContactInfo集合</returns>
		public IList<Interfacet2ContactInfo> SelectByFilter(Interfacet2ContactInfo obj)
        {
            IList<Interfacet2ContactInfo> list = this.ExecuteQueryForList<Interfacet2ContactInfo>("SelectByFilterInterfacet2ContactInfo", obj);
            return list;
        }

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(Interfacet2ContactInfo obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateInterfacet2ContactInfo", obj);
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteInterfacet2ContactInfo", objKey);
            return cnt;
        }




        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(Interfacet2ContactInfo obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteInterfacet2ContactInfo", obj);
            return cnt;
        }

        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(Interfacet2ContactInfo obj)
        {
            this.ExecuteInsert("InsertInterfacet2ContactInfo", obj);
        }

        public void HandleInterfacet2ContactInfoData(string BatchNbr, string ClientID, out string RtnVal, out string RtnMsg)
        {
            RtnVal = string.Empty;
            RtnMsg = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("BatchNbr", BatchNbr);
            ht.Add("ClientID", ClientID);
            ht.Add("RtnVal", RtnVal);
            ht.Add("RtnMsg", RtnMsg);

            this.ExecuteInsert("GC_Interface_T2ContractInfo", ht);

            RtnVal = ht["RtnVal"].ToString();
            RtnMsg = ht["RtnMsg"].ToString();
        }

        public IList<Interfacet2ContactInfo> SelectInterfacet2ContactInfoByBatchNbrErrorOnly(string batchNbr)
        {
            IList<Interfacet2ContactInfo> list = this.ExecuteQueryForList<Interfacet2ContactInfo>("SelectInterfacet2ContactInfoByBatchNbrErrorOnly", batchNbr);
            return list;
        }

        public IList<T2CommercialIndexData> SelectT2CommercialIndexByCode(string obj)
        {
            IList<T2CommercialIndexData> list = this.ExecuteQueryForList<T2CommercialIndexData>("SelectT2CommercialIndexByCode", obj);
            return list;
        }

        public IList<T2AuthorizationData> SelectT2AuthorizationByCode(string obj)
        {
            IList<T2AuthorizationData> list = this.ExecuteQueryForList<T2AuthorizationData>("SelectT2AuthorizationByCode", obj);
            return list;
        }

        public IList<Interfacet2ContactInfo> SelectT2ContactInfoByID(Guid obj, int start, int limit, out int totalCount)
        {
            IList<Interfacet2ContactInfo> list = this.ExecuteQueryForList<Interfacet2ContactInfo>("SelectT2ContactInfoByID", obj,start,limit,out totalCount);
            return list;
        }
    }
}
