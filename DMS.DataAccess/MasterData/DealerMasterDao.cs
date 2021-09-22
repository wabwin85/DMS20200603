
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.Model 
 * ClassName   : DealerMaster
 * Created Time: 2009-7-7 12:01:36
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
    /// DealerMaster的Dao
    /// </summary>
    public class DealerMasterDao : BaseSqlMapDao
    {

        /// <summary>
        /// 默认构造函数

        /// </summary>
        public DealerMasterDao()
            : base()
        {
        }

        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public DealerMaster GetObject(Guid objKey)
        {
            DealerMaster obj = this.ExecuteQueryForObject<DealerMaster>("SelectDealerMaster", objKey);
            return obj;
        }

        /// <summary>
        /// 得到BSC公司信息
        /// </summary>
        /// <returns></returns>
        public DealerMaster GetSynthes()
        {
            DealerMaster obj = this.ExecuteQueryForObject<DealerMaster>("SelectDealerMasterForSynthes", null);
            return obj;
        }

        public DealerMaster GetObjectByName(string name)
        {
            DealerMaster obj = this.ExecuteQueryForObject<DealerMaster>("SelectDealerMasterByName", name);
            return obj;
        }
        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<DealerMaster> GetAll()
        {
            IList<DealerMaster> list = this.ExecuteQueryForList<DealerMaster>("SelectByFilterDealerMaster", null);
            return list;
        }


        /// <summary>
        /// 查询DealerMaster
        /// </summary>
        /// <returns>返回DealerMaster集合</returns>
        public IList<DealerMaster> SelectByFilter(DealerMaster obj)
        {
            IList<DealerMaster> list = this.ExecuteQueryForList<DealerMaster>("SelectByFilterDealerMaster", obj);
            return list;
        }

        /// <summary>
        /// 查询DealerMaster,得到翻页用的Dealer集合
        /// </summary>
        /// <returns>返回DealerMaster集合</returns>
        public IList<DealerMaster> SelectByFilter(DealerMaster obj, int start, int limit, out int totalRowCount)
        {
            IList<DealerMaster> list = this.ExecuteQueryForList<DealerMaster>("SelectByFilterDealerMaster", obj, start, limit, out totalRowCount);
            return list;
        }

        public IList<DealerMaster> QueryForDealerMasterByAllUser(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            IList<DealerMaster> list = this.ExecuteQueryForList<DealerMaster>("SelectByFilterDealerMasterByAllUser", obj, start, limit, out totalRowCount);
            return list;
        }

        public DataSet QueryForDealerMaster(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryForDealerMaster", obj, start, limit, out totalRowCount);
            return ds;
        }
        public DataSet QueryForDealerMasterForDD(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryForDealerMasterForDD", obj, start, limit, out totalRowCount);
            return ds;
        }
        public DataSet QueryForDealerProfileMaster(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryForDealerProfileMaster", obj);
            return ds;
        }

        /// <summary>
        /// 根据UserId,或产品线获得当前系统用户相关的Dealer, by donson
        /// </summary>
        /// <param name="userId">The user id.</param>
        /// <param name="productLines">The product lines.</param>
        /// <returns>返回DealerMaster集合</returns>
        public IList<Guid> GetDealersBySales(string userId, Guid[] productLines)
        {
            Hashtable table = new Hashtable();
            table.Add("OwnerId", userId);
            table.Add("ProductLines", productLines);

            IList<Guid> list = this.ExecuteQueryForList<Guid>("GetDealersBySales", table);
            return list;
        }

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(DealerMaster obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateDealerMaster", obj);
            return cnt;
        }

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int UpdateNew(DealerMaster obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateDealerMasterNew", obj);
            return cnt;
        }

        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(DealerMaster obj)
        {
            int cnt = (int)this.ExecuteDelete("DeleteDealerMaster", obj);
            return cnt;
        }




        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(DealerMaster obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteDealerMaster", obj);
            return cnt;
        }

        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(DealerMaster obj)
        {
            this.ExecuteInsert("InsertDealerMaster", obj);
        }

        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void InsertNew(DealerMaster obj)
        {
            this.ExecuteInsert("InsertDealerMasterNew", obj);
        }

        public IList<DealerMaster> SelectDealerMasterForTransferByDealerFromId(Guid DealerFromId)
        {
            IList<DealerMaster> list = this.ExecuteQueryForList<DealerMaster>("SelectDealerMasterForTransferByDealerFromId", DealerFromId);
            return list;
        }

        public DataSet SelectProductLineByDealerId(Guid DealerId)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectProductLineByDealerId", DealerId);
            return ds;
        }

        public DataSet SelectHospitalForDealerByFilter(Hashtable param)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectHospitalForDealerByFilter", param);
            return ds;
        }

        public DataSet SelectProductLineById(Guid ProductId)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectProductLineById", ProductId);
            return ds;
        }

        public DataSet SelectHospitalById(Guid HospitalId)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectHospitalById", HospitalId);
            return ds;
        }

        public IList<DealerMaster> SelectSapCodeById(string SapCode)
        {
            IList<DealerMaster> obj = this.ExecuteQueryForList<DealerMaster>("SelectSapCodeById", SapCode);
            return obj;
        }

        //同一个HQ或者LP下的经销商
        public IList<DealerMaster> SelectSameLevelDealer(Guid DealerId)
        {
            IList<DealerMaster> obj = this.ExecuteQueryForList<DealerMaster>("SelectSameLevelDealer", DealerId);
            return obj;
        }

        public IList<LpDistributorData> QueryLPDistributorInfo(string batchNbr)
        {

            IList<LpDistributorData> list = this.ExecuteQueryForList<LpDistributorData>("QueryLPDistributorInfo", batchNbr);
            return list;
        }

        //经销商信息接口
        public DataSet P_GetCRMDealer()
        {
            DataSet ds = this.ExecuteQueryForDataSet("P_GetCRMDealer", null);
            return ds;
        }

        //经销商对应产品价格
        public DataSet P_GetDealerProductionPrice(string CustomerID, string SubCompanyId, string BrandId)
        {
            Hashtable ht = new Hashtable();
            ht.Add("value", CustomerID);
            ht.Add("SubCompanyId", SubCompanyId);
            ht.Add("BrandId", BrandId);
            DataSet ds = this.ExecuteQueryForDataSet("P_GetDealerProductionPrice", ht);
            return ds;
        }

        //经销商与医院对应信息接口
        public DataSet P_GetCRMDealerHospital()
        {
            DataSet ds = this.ExecuteQueryForDataSet("P_GetCRMDealerHospital", null);
            return ds;
        }

        public IList<DealerMaster> SelectHospitalForDealerByFilterNew(Hashtable param, int start, int limit, out int totalCount)
        {
            IList<DealerMaster> ds = this.ExecuteQueryForList<DealerMaster>("SelectHospitalForDealerByFilterNew", param, start, limit, out totalCount);
            return ds;
        }

        public DataSet SelectHospitalForDealer()
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectHospitalForDealer", null);
            return ds;
        }

        public DataSet SelectParentDealer(Guid dealerId)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectParentDealer", dealerId);
            return ds;
        }

        public DataSet ExportDealerMaster(Guid dealerId)
        {
            DataSet ds = this.ExecuteQueryForDataSet("ExportDealerMasterByDealerId", dealerId);
            return ds;
        }


        //根据红蓝海和用量日期查询医院
        public DataSet SelectHospitalForDealerByShipmentDate(Hashtable param)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectHospitalForDealerByShipmentDate", param);
            return ds;
        }

        //获取经销商合同信息
        public DataSet GetDealerContract(Hashtable param, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectNewDealerContract", param, start, limit, out totalCount);
            return ds;
        }

        public DataSet GetDealerContract(Hashtable param)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectNewDealerContract", param);
            return ds;
        }

        public int UpdateDealerContractThirdParty(Hashtable param)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateDealerContractThirdParty", param);

            return cnt;
        }

        public int UpdateDealerBaseContact(DealerMaster param)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateDealerBaseContact", param);

            return cnt;
        }

        public DataSet GetThirdPartSignature(Hashtable param)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectThirdPartSignature", param);
            return ds;
        }

        public int UpdateThirdPartSignature(Hashtable param)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateThirdPartSignature", param);

            return cnt;
        }

        public DataSet GetDealerMassageByAccount(Hashtable param)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectDealerMassageByAccount", param);
            return ds;
        }

        public DataSet GetHomePageMessage(Hashtable param)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectHomePageMessage", param);
            return ds;
        }

        public void InsertHomePageMessage(Hashtable obj)
        {
            this.ExecuteInsert("InsertHomePageMessage", obj);
        }


        public DataSet GetExcelDealerMasterByAllUser(Hashtable param)
        {
            DataSet ds = this.ExecuteQueryForDataSet("ExcelDealerMasterByAllUser", param);
            return ds;
        }

        //Add By SongWeiming on 2015-09-15 For GSP Project
        public DataSet GetDealerLicenseCatagoryByCatId(Hashtable param)
        {
            DataSet ds = this.ExecuteQueryForDataSet("GetDealerLicenseCatagoryByCatId", param);
            return ds;
        }

        public DataSet GetLicenseCatagoryByCatType(Hashtable param)
        {
            DataSet ds = this.ExecuteQueryForDataSet("GetLicenseCatagoryByCatType", param);
            return ds;
        }
        //End Add By SongWeiming on 2015-09-15 For GSP Project

        public DataSet GetReturnDealerListByFilter(Hashtable param)
        {
            DataSet ds = this.ExecuteQueryForDataSet("GetReturnDealerListByFilter", param);
            return ds;
        }
        public DealerMaster SelectDealerMasterParentTypebyId(Guid Id)
        {
            DealerMaster obj = this.ExecuteQueryForObject<DealerMaster>("SelectDealerMasterParentTypebyId", Id);
            return obj;
        }

        public DataSet GetNoLimitProductLineByDealer(Hashtable param)
        {
            DataSet ds = this.ExecuteQueryForDataSet("GetNoLimitProductLineByDealer", param);
            return ds;
        }
        public DataSet GetNoLimitProductLineByDealerAll(Hashtable param)
        {
            DataSet ds = this.ExecuteQueryForDataSet("GetNoLimitProductLineByDealerAll", param);
            return ds;
        }
        public DataSet GetDealerForLocalSeal(Hashtable param)
        {
            DataSet ds = this.ExecuteQueryForDataSet("GetDealerForLocalSeal", param);
            return ds;
        }

        public DataSet GetDealerMaster(Hashtable param, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("GetDealerMaster", param,start,limit,out  totalCount);
            return ds;

        }
        // 经销商更名T2
        public string UpdateDealerName(Hashtable obj)
        {
            string IsValid = string.Empty;

            this.ExecuteInsert("UpdateDealerName",obj);

            IsValid = obj["IsValid"].ToString();
            return IsValid; ;
        }


        public IList<Hashtable> SelectFilterListConsign(Guid bu, Guid dealerId, String filter)
        {
            Hashtable condition = new Hashtable();
            condition.Add("Bu", bu);
            condition.Add("DealerId", dealerId);
            condition.Add("Filter", filter);
            return this.ExecuteQueryForList<Hashtable>("MasterData.SelectFilterListConsign", condition);
        }

        public IList<Hashtable> SelectFilterListAll(String filter)
        {
            Hashtable condition = new Hashtable();
            condition.Add("Filter", filter);
            return this.ExecuteQueryForList<Hashtable>("MasterData.SelectFilterListAll", condition);
        }

        public DataSet SelectDealerMasterByIdentityType(String CorpId, String IdentityType)
        {
            Hashtable condition = new Hashtable();

            condition.Add("CorpId", CorpId);
            condition.Add("IdentityType", IdentityType);

            DataSet ds = this.ExecuteQueryForDataSet("SelectDealerMasterByIdentityType", condition);
            return ds;
        }

        public IList<Hashtable> SelectDealerMainByDealerID(Guid? DealerID)
        {
            Hashtable condition = new Hashtable();
            condition.Add("DealerId", DealerID);
            return this.ExecuteQueryForList<Hashtable>("GetDealerMasterMain", condition);
        }
    }
}