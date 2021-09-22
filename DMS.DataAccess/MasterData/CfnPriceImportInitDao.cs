
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : CfnPriceImportInit
 * Created Time: 2019/10/18 9:10:01
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
    /// CfnPriceImportInit的Dao
    /// </summary>
    public class CfnPriceImportInitDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public CfnPriceImportInitDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public CfnPriceImportInit GetObject(Guid objKey)
        {
            CfnPriceImportInit obj = this.ExecuteQueryForObject<CfnPriceImportInit>("SelectCfnPriceImportInit", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<CfnPriceImportInit> GetAll()
        {
            IList<CfnPriceImportInit> list = this.ExecuteQueryForList<CfnPriceImportInit>("SelectCfnPriceImportInit", null);          
            return list;
        }


        /// <summary>
        /// 查询CfnPriceImportInit
        /// </summary>
        /// <returns>返回CfnPriceImportInit集合</returns>
		public IList<CfnPriceImportInit> SelectByFilter(CfnPriceImportInit obj)
		{ 
			IList<CfnPriceImportInit> list = this.ExecuteQueryForList<CfnPriceImportInit>("SelectByFilterCfnPriceImportInit", obj);          
            return list;
		}

        public DataSet QueryErrorData(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectDealerPriceErrorData", obj, start, limit, out totalRowCount);
            return ds;
        }
        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(CfnPriceImportInit obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateCfnPriceImportInit", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(CfnPrice objKey)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteCfnPrice", objKey);            
            return cnt;
        }

        public int DeleteByUser(string UserId)
        {
            int cnt = (int)this.ExecuteDelete("DeleteCfnPriceImportInitByUser", UserId);
            return cnt;
        }



	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(CfnPriceImportInit obj)
        {
            this.ExecuteInsert("InsertCfnPriceImportInit", obj);           
        }
        public void BatchInsert(IList<CfnPriceImportInit> list)
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("CFNPI_ID", typeof(Guid));
            dt.Columns.Add("CFNPI_Group_ID", typeof(Guid));
            dt.Columns.Add("CFNPI_SAP_Code");
            dt.Columns.Add("CFNPI_ChineseName");
            dt.Columns.Add("CFNPI_CFN_ID", typeof(Guid));
            dt.Columns.Add("CFNPI_CustomerFaceNbr");
            dt.Columns.Add("CFNPI_Price");
            dt.Columns.Add("CFNPI_Province");
            dt.Columns.Add("CFNPI_Province_ID", typeof(Guid));
            dt.Columns.Add("CFNPI_City");
            dt.Columns.Add("CFNPI_City_ID", typeof(Guid));
            dt.Columns.Add("CFNPI_LevelValue");
            dt.Columns.Add("CFNPI_LevelKey");
            dt.Columns.Add("CFNPI_ValidDateFrom");
            dt.Columns.Add("CFNPI_ValidDateTo");
            dt.Columns.Add("CFNPI_DealerType");
            dt.Columns.Add("CFNPI_SubCompanyId", typeof(Guid));
            dt.Columns.Add("CFNPI_BrandId", typeof(Guid));
            dt.Columns.Add("ErrMassage");
            dt.Columns.Add("CreateUser", typeof(Guid));
            dt.Columns.Add("CreateDate");

            foreach (CfnPriceImportInit data in list)
            {
                DataRow row = dt.NewRow();
                row["CFNPI_ID"] = data.Id;
                row["CFNPI_CustomerFaceNbr"] = data.CustomerFaceNbr;
                row["CFNPI_Price"] = data.Price;
                row["CFNPI_LevelValue"] = data.LevelValue;
                row["CFNPI_SAP_Code"] = data.SapCode;
                row["CFNPI_Province"] = data.Province;
                row["CFNPI_City"] = data.City;
                row["CFNPI_ValidDateFrom"] = data.ValidDateFrom;
                row["CFNPI_ValidDateTo"] = data.ValidDateTo;
                row["CFNPI_DealerType"] = data.DealerType;
                row["ErrMassage"] = data.ErrMassage;
                row["CreateUser"] = data.CreateUser;
                row["CreateDate"] = data.CreateDate;
                dt.Rows.Add(row);
            }
            this.ExecuteBatchInsert("CfnPriceImportInit", dt);
        }
        /// <summary>
        /// 调用存储过程
        /// </summary>
        /// <param name="UserId"></param>
        /// <returns></returns>
        public string Initialize(string importType, Guid UserId, string SubCompanyId, string BrandId)
        {
            string IsValid = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("UserId", UserId);
            ht.Add("ImportType", importType);
            ht.Add("SubCompanyId", SubCompanyId);
            ht.Add("BrandId", BrandId);
            ht.Add("IsValid", IsValid);

            this.ExecuteInsert("GC_DealerPriceImportInit", ht);

            IsValid = ht["IsValid"].ToString();

            return IsValid;
        }
    }
}