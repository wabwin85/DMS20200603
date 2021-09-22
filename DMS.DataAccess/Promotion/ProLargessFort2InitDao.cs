
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : ProLargessFort2Init
 * Created Time: 2019/5/14 18:05:46
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
    /// ProLargessFort2Init的Dao
    /// </summary>
    public class ProLargessFort2InitDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public ProLargessFort2InitDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public ProLargessFort2Init GetObject(Guid objKey)
        {
            ProLargessFort2Init obj = this.ExecuteQueryForObject<ProLargessFort2Init>("SelectProLargessFort2Init", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<ProLargessFort2Init> GetAll()
        {
            IList<ProLargessFort2Init> list = this.ExecuteQueryForList<ProLargessFort2Init>("SelectProLargessFort2Init", null);          
            return list;
        }


        /// <summary>
        /// 查询ProLargessFort2Init
        /// </summary>
        /// <returns>返回ProLargessFort2Init集合</returns>
		public IList<ProLargessFort2Init> SelectByFilter(ProLargessFort2Init obj)
		{ 
			IList<ProLargessFort2Init> list = this.ExecuteQueryForList<ProLargessFort2Init>("SelectByFilterProLargessFort2Init", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(ProLargessFort2Init obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateProLargessFort2Init", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteProLargessFort2Init", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(ProLargessFort2Init obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteProLargessFort2Init", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(ProLargessFort2Init obj)
        {
            this.ExecuteInsert("InsertProLargessFort2Init", obj);           
        }

        public int DeleteLargessForT2Init(Guid userId)
        {
            int cnt = (int)this.ExecuteDelete("DeleteLargessForT2Init", userId);
            return cnt;
        }

        public void ProLargessFort2Insert(IList<ProLargessFort2Init> list)
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("Id", typeof(Guid));
            dt.Columns.Add("PolicyType");
            dt.Columns.Add("PolicyTypeErrmsg");
            dt.Columns.Add("PolicyNo");
            dt.Columns.Add("PolicyNoErrMsg");
            dt.Columns.Add("SAPCode");
            dt.Columns.Add("SAPCodeErrMsg");
            dt.Columns.Add("BU");
            dt.Columns.Add("BUErrMsg");
            dt.Columns.Add("ValidDate");
            dt.Columns.Add("ValidDateErrMsg");
            dt.Columns.Add("PointType");
            dt.Columns.Add("PointTypeErrMsg");
            dt.Columns.Add("FreeGoods");
            dt.Columns.Add("FreeGoodsErrMsg");
            dt.Columns.Add("CurrentPeriod");
            dt.Columns.Add("CurrentPeriodErrMsg");
            dt.Columns.Add("AuthProductType");
            dt.Columns.Add("AuthProductTypeErrMsg");
            dt.Columns.Add("PL5");
            dt.Columns.Add("PL5ErrMsg");
            dt.Columns.Add("RemarMag");
            dt.Columns.Add("UserId", typeof(Guid));
            dt.Columns.Add("LineNbr", typeof(int));
            dt.Columns.Add("ErrorFlag", typeof(bool));
            foreach (ProLargessFort2Init data in list)
            {
                DataRow row = dt.NewRow();
                row["Id"] = data.Id;
                row["PolicyType"] = data.PolicyType;
                row["PolicyTypeErrmsg"] = data.PointTypeErrMsg;
                row["PolicyNo"] = data.PolicyNo;
                row["PolicyNoErrMsg"] = data.PolicyNoErrMsg;
                row["SAPCode"] = data.SapCode;
                row["SAPCodeErrMsg"] = data.SapCodeErrMsg;
                row["BU"] = data.Bu;
                row["BUErrMsg"] = data.BuErrMsg;
                row["ValidDate"] = data.ValidDate;
                row["ValidDateErrMsg"] = data.ValidDateErrMsg;
                row["PointType"] = data.PointType;
                row["PointTypeErrMsg"] = data.PointTypeErrMsg;
                row["FreeGoods"] = data.FreeGoods;
                row["FreeGoodsErrMsg"] = data.FreeGoodsErrMsg;
                row["CurrentPeriod"] = data.CurrentPeriod;
                row["CurrentPeriodErrMsg"] = data.CurrentPeriodErrMsg;
                row["AuthProductType"] = data.AuthProductType;
                row["AuthProductTypeErrMsg"] = data.AuthProductTypeErrMsg;
                row["PL5"] = data.PL5;
                row["PL5ErrMsg"] = data.PL5ErrMsg;
                row["RemarMag"] = data.RemarMag;
                row["UserId"] = data.UserId;
                row["LineNbr"] = data.LineNbr;
                row["ErrorFlag"] = data.ErrorFlag;

                dt.Rows.Add(row);
            }
            this.ExecuteBatchInsert("Pro_LargessForT2_Init", dt);
        }

        public string Initialize(string importType, Guid UserId,string BrandId)
        {
            string IsValid = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("UserId", UserId);
            ht.Add("ImportType", importType);
            ht.Add("IsValid", IsValid);
            ht.Add("BrandId", BrandId);
            this.ExecuteInsert("GC_LargessForT2Init", ht);

            IsValid = ht["IsValid"].ToString();

            return IsValid;
        }
        public DataSet SelectLargessForT2ErrorData(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectLargessForT2InitByHashtable", obj, start, limit, out totalRowCount);
            return ds;
        }
        public DataSet LargessForT2InitSumString(string userId)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectLargessForT2InitSumString", userId);
            return ds;
        }
        
    }
}