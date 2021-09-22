
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : DealerMasterLicense
 * Created Time: 2015/9/14 14:59:05
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
    /// DealerMasterLicense的Dao
    /// </summary>
    public class DealerMasterLicenseDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public DealerMasterLicenseDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public DealerMasterLicense GetObject(Guid objKey)
        {
            DealerMasterLicense obj = this.ExecuteQueryForObject<DealerMasterLicense>("SelectDealerMasterLicense", objKey);           
            return obj;
        }
        public DataSet GetDealerMasterLicenseToTable(string DealerId)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectDealerMasterLicenseToTable", DealerId);
            return ds;
        }
        

        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<DealerMasterLicense> GetAll()
        {
            IList<DealerMasterLicense> list = this.ExecuteQueryForList<DealerMasterLicense>("SelectDealerMasterLicense", null);          
            return list;
        }


        /// <summary>
        /// 查询DealerMasterLicense
        /// </summary>
        /// <returns>返回DealerMasterLicense集合</returns>
		public IList<DealerMasterLicense> SelectByFilter(DealerMasterLicense obj)
		{ 
			IList<DealerMasterLicense> list = this.ExecuteQueryForList<DealerMasterLicense>("SelectByFilterDealerMasterLicense", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(DealerMasterLicense obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateDealerMasterLicense", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteDealerMasterLicense", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(DealerMasterLicense obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteDealerMasterLicense", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(DealerMasterLicense obj)
        {
            this.ExecuteInsert("InsertDealerMasterLicense", obj);           
        }

        //证照信息更新申请-审批通过（将新的证照信息更新为正式的证照信息，并将单据状态修改为审批通过）
        public int approveLicenseApplication(Guid dealerId,Guid approveUserId,string status,string remark)
        {
            Hashtable param = new Hashtable();
            param.Add("ApproveUserId", approveUserId);
            param.Add("NewApplyStatus", status);
            param.Add("DealerId", dealerId);
            param.Add("Remark", remark);
            int cnt = (int)this.ExecuteUpdate("ApproveLicenseApplication", param);
            return cnt;
        }

        //证照信息更新申请-审批拒绝（更新单据状态）
        public int rejectLicenseApplication(Guid dealerId, Guid approveUserId, string status,string remark)
        {
            Hashtable param = new Hashtable();
            param.Add("ApproveUserId", approveUserId);
            param.Add("NewApplyStatus", status);
            param.Add("DealerId", dealerId);
            param.Add("Remark", remark);
            int cnt = (int)this.ExecuteUpdate("RejectLicenseApplication", param);
            return cnt;
        }

      
        /// 查询需要导出的数据      
        public DataSet SelectDealerLicenseForExport(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectDealerLicenseForExport", table);
            return ds;
        }
        ///查询经销商授权的产品信息
        public DataSet SelectDealerLicenseCfnForExport(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectDealerLicenseCfnForExport", table);
            return ds;
        }
        ///查询经销商授权的医院信息
        public DataSet SelectDealerAuthHospitalExport(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectDealerAuthHospitalExport", table);
            return ds;
        }
        public DataSet GetShiptoAddress(Guid NewApplyId)
        {
            DataSet ds = this.ExecuteQueryForDataSet("GetShiptoAddress", NewApplyId);
            return ds;
        }
        public void addaddress(Hashtable hs)
        {
            this.ExecuteInsert("insertaddaddress", hs);

        }
        public DataSet GetAddress(Guid NewApplyId, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("GetAddress", NewApplyId, start, limit, out totalRowCount);
            return ds;

        }
        public void updateaddress(string id)
        {
            this.ExecuteUpdate("updateaddress", id);

        }
        public void updateshiptoaddress(Guid DealerId)
        {
            this.ExecuteUpdate("updateshiptoaddress", DealerId);
        }
        public void insertDealerMasterLicenseModify(Hashtable hs)
        {
            this.ExecuteInsert("insertDealerMasterLicenseModify", hs);

        }
        public DataSet GetCFDAHead(Hashtable hs, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("GetCFDAHead", hs, start, limit, out totalRowCount);
            return ds;
        }
        public DataSet GetCFDAHeadAll(string DealerId, string ApplyStatus)
        {
            Hashtable ht = new Hashtable();
            ht.Add("DMA_ID", DealerId);
            ht.Add("ApplyStatus", ApplyStatus);
            DataSet ds = this.ExecuteQueryForDataSet("GetCFDAHeadAll", ht);
            return ds;
        }

        public DataSet GetCFDAProcess(string MID)
        {
            DataSet ds = this.ExecuteQueryForDataSet("GetCFDAProcess", MID);
            return ds;
        }
        public void UpdateDealerMasterLicenseModify(Hashtable hs)
        {
            this.ExecuteUpdate("UpdateDealerMasterLicenseModify", hs);

        }
        public string GetNextCFDANo(string clientid, string strSettings)
        {
            string strNextAutoNumber = "";
            Hashtable ht = new Hashtable();
            ht.Add("ClientID", clientid);
            ht.Add("Settings", strSettings);
            ht.Add("nextnbr", strNextAutoNumber);
            this.ExecuteInsert("GetNextCFDANo", ht);
            strNextAutoNumber = ht["nextnbr"].ToString();
            return strNextAutoNumber;
        }

        public void DeleteShipToAddress(Guid DML_MID)
        {
            this.ExecuteDelete("DeleteShipToAddress", DML_MID);
        }
        public void DeleteAttachment(Guid DML_MID)
        {
            this.ExecuteDelete("DeleteAttachmentByMainid", DML_MID);
        }
        public void DeleteDealerMasterLicenseModify(Guid DML_MID)
        {
            this.ExecuteDelete("DeleteDealerMasterLicenseModify", DML_MID);
        }

        public void insertShipToAddress(Guid DML_MID, Guid DealerId)
        {
            Hashtable hs = new Hashtable();
            hs.Add("DML_MID", DML_MID);
            hs.Add("DealerId", DealerId);
            this.ExecuteInsert("insertShipToAddress", hs);
        }

        public DataSet SelectSAPWarehouseAddress(Guid DealerId)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectSAPWarehouseAddressByDealerId", DealerId);
            return ds;
        }
        public void updateshiptoaddressbtn(string ID, string IsSendAddress)
        {
            Hashtable hs = new Hashtable();
            hs.Add("ID", ID);
            hs.Add("IsSendAddress", IsSendAddress);
            this.ExecuteDelete("updateshiptoaddressbtn", hs);
        }
        public void DeleteSAPWarehouseAddress_temp(string id)
        {
            this.ExecuteDelete("DeleteSAPWarehouseAddress_temp", id);
        }
        public DataSet SelectSAPWarehouseAddress_temp(Guid DML_MID)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectSAPWarehouseAddress_temp", DML_MID);
            return ds;
        }
        public DataSet GetSalesRepByParam(Hashtable Param)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectSalesRepByParam", Param);
            return ds;
        }


    }
}