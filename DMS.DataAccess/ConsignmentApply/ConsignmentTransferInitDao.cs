
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : ConsignmentTransferInit
 * Created Time: 2018/11/29 18:47:15
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
    /// ConsignmentTransferInit的Dao
    /// </summary>
    public class ConsignmentTransferInitDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public ConsignmentTransferInitDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public ConsignmentTransferInit GetObject(Guid objKey)
        {
            ConsignmentTransferInit obj = this.ExecuteQueryForObject<ConsignmentTransferInit>("SelectConsignmentTransferInit", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<ConsignmentTransferInit> GetAll()
        {
            IList<ConsignmentTransferInit> list = this.ExecuteQueryForList<ConsignmentTransferInit>("SelectConsignmentTransferInit", null);          
            return list;
        }


        /// <summary>
        /// 查询ConsignmentTransferInit
        /// </summary>
        /// <returns>返回ConsignmentTransferInit集合</returns>
		public IList<ConsignmentTransferInit> SelectByFilter(ConsignmentTransferInit obj)
		{ 
			IList<ConsignmentTransferInit> list = this.ExecuteQueryForList<ConsignmentTransferInit>("SelectByFilterConsignmentTransferInit", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(ConsignmentTransferInit obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateConsignmentTransferInit", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(string objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteConsignmentTransferInit", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(ConsignmentTransferInit obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteConsignmentTransferInit", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(ConsignmentTransferInit obj)
        {
            this.ExecuteInsert("InsertConsignmentTransferInit", obj);           
        }

        public DataSet SelectConsignmentTransferInitList(string Id, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectConsignmentTransferInitList", Id, start, limit, out totalRowCount);
            return ds;
        }
        public int DeleteTransferInitByUser(string objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteConsignmentTransferInitByUser", objKey);
            return cnt;
        }
        public void ConsignmentTransferInit(IList<ConsignmentTransferInit> list)
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("ID");
            dt.Columns.Add("DealerCodeTo");
            dt.Columns.Add("DealerIdTo");
            dt.Columns.Add("DealerCodeFrom");
            dt.Columns.Add("DealerIdFrom");
            dt.Columns.Add("ProductLineName");
            dt.Columns.Add("ProductLineId");
            dt.Columns.Add("Upn");
            dt.Columns.Add("Qty");
            dt.Columns.Add("ContractNo");
            dt.Columns.Add("ContractId");
            dt.Columns.Add("HospitalCode");
            dt.Columns.Add("HospitalName");
            dt.Columns.Add("HospitalId");
            dt.Columns.Add("Remark");
            dt.Columns.Add("ErrFlg");
            dt.Columns.Add("ErrMassages");
            dt.Columns.Add("InputUser");
            dt.Columns.Add("InputDate", typeof(DateTime));
            dt.Columns.Add("LineNbr");

            foreach (ConsignmentTransferInit data in list)
            {
                DataRow row = dt.NewRow();

                row["ID"] = data.Id;
                row["DealerCodeTo"] = data.DealerCodeTo;
                row["DealerIdTo"] = data.DealerIdTo;
                row["DealerCodeFrom"] = data.DealerCodeFrom;
                row["DealerIdFrom"] = data.DealerIdFrom;
                row["ProductLineName"] = data.ProductLineName;
                row["ProductLineId"] = data.ProductLineId;
                row["Upn"] = data.Upn;
                row["Qty"] = data.Qty;
                row["ContractNo"] = data.ContractNo;
                row["ContractId"] = data.ContractId;
                row["HospitalCode"] = data.HospitalCode;
                row["HospitalName"] = data.HospitalName;
                row["HospitalId"] = data.HospitalId;
                row["Remark"] = data.Remark;
                row["ErrFlg"] = data.ErrFlg;
                row["ErrMassages"] = data.ErrMassages;
                row["InputUser"] = data.InputUser;
                row["InputDate"] = data.InputDate;
                row["LineNbr"] = data.LineNbr;

                dt.Rows.Add(row);
            }
            this.ExecuteBatchInsert("ConsignmentTransferInit", dt);
        }
        public string Initialize(string importType, Guid UserId, Guid SubCompanyId, Guid BrandId)
        {
            string IsValid = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("UserId", UserId);
            ht.Add("ImportType", importType);
            ht.Add("SubCompanyId", SubCompanyId);
            ht.Add("BrandId", BrandId);
            ht.Add("IsValid", IsValid);

            this.ExecuteInsert("GC_ConsignmentTransferInit", ht);

            IsValid = ht["IsValid"].ToString();

            return IsValid;
        }
    }
}