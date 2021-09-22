
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : InterfaceSales
 * Created Time: 2013/7/12 14:48:25
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
    /// InterfaceSales的Dao
    /// </summary>
    public class InterfaceSalesDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public InterfaceSalesDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public InterfaceSales GetObject(Guid objKey)
        {
            InterfaceSales obj = this.ExecuteQueryForObject<InterfaceSales>("SelectInterfaceSales", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<InterfaceSales> GetAll()
        {
            IList<InterfaceSales> list = this.ExecuteQueryForList<InterfaceSales>("SelectInterfaceSales", null);          
            return list;
        }


        /// <summary>
        /// 查询InterfaceSales
        /// </summary>
        /// <returns>返回InterfaceSales集合</returns>
		public IList<InterfaceSales> SelectByFilter(InterfaceSales obj)
		{ 
			IList<InterfaceSales> list = this.ExecuteQueryForList<InterfaceSales>("SelectByFilterInterfaceSales", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(InterfaceSales obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateInterfaceSales", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteInterfaceSales", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(InterfaceSales obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteInterfaceSales", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(InterfaceSales obj)
        {
            this.ExecuteInsert("InsertInterfaceSales", obj);           
        }

        public void HandleSalesData(string BatchNbr, string ClientID, string SubCompanyId, string BrandId, out string RtnVal, out string RtnMsg)
        {
            RtnVal = string.Empty;
            RtnMsg = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("BatchNbr", BatchNbr);
            ht.Add("ClientID", ClientID);
            ht.Add("SubCompanyId", SubCompanyId);
            ht.Add("BrandId", BrandId);
            ht.Add("UserId", null);
            ht.Add("RtnVal", RtnVal);
            ht.Add("RtnMsg", RtnMsg);

            this.ExecuteInsert("GC_Interface_Sales", ht);

            RtnVal = ht["RtnVal"].ToString();
            RtnMsg = ht["RtnMsg"].ToString();
        }

        public void UploadHospitalSales(string Upn, string Lot, string HosId, string SubUser, string Rv1, string Rv2, string Rv3, out string rtnVal, out string rtnMsg)
        {
            rtnVal = string.Empty;
            rtnMsg = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("UPN", Upn);
            ht.Add("LOT", Lot);
            ht.Add("HOS_ID", HosId);
            ht.Add("Sub_User", SubUser);
            ht.Add("Rv1", Rv1);
            ht.Add("Rv2", Rv2);
            ht.Add("Rv3", Rv3);
            ht.Add("RtnVal", rtnVal);
            ht.Add("RtnMsg", rtnMsg);
            try
            {
                this.ExecuteInsert("GC_UploadHospitalSalesByDateBox", ht);

                rtnVal = ht["RtnVal"].ToString();
                rtnMsg = ht["RtnMsg"].ToString();
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        public DataSet SelectHospitalSalesByBatchNbr(string BatchNbr)
        {
            return base.ExecuteQueryForDataSet("SelectHospitalSalesByBachNumber", BatchNbr);
        }

    }
}