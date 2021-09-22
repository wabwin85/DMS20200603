
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : ConsignmentApplyHeader
 * Created Time: 2015/11/13 15:23:26
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
    /// ConsignmentApplyHeader的Dao
    /// </summary>
    public class ConsignmentApplyHeaderDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public ConsignmentApplyHeaderDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public ConsignmentApplyHeader GetObject(Guid objKey)
        {
            ConsignmentApplyHeader obj = this.ExecuteQueryForObject<ConsignmentApplyHeader>("SelectConsignmentApplyHeader", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<ConsignmentApplyHeader> GetAll()
        {
            IList<ConsignmentApplyHeader> list = this.ExecuteQueryForList<ConsignmentApplyHeader>("SelectConsignmentApplyHeader", null);          
            return list;
        }


        /// <summary>
        /// 查询ConsignmentApplyHeader
        /// </summary>
        /// <returns>返回ConsignmentApplyHeader集合</returns>
		public IList<ConsignmentApplyHeader> SelectByFilter(ConsignmentApplyHeader obj)
		{ 
			IList<ConsignmentApplyHeader> list = this.ExecuteQueryForList<ConsignmentApplyHeader>("SelectByFilterConsignmentApplyHeader", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(ConsignmentApplyHeader obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateConsignmentApplyHeader", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteConsignmentApplyHeader", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(ConsignmentApplyHeader obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteConsignmentApplyHeader", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(ConsignmentApplyHeader obj)
        {
            this.ExecuteInsert("InsertConsignmentApplyHeader", obj);           
        }

        public DataSet QueryConsignmentApplyHeaderDealer(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryConsignmentApplyHeaderDealer", table, start, limit, out totalRowCount);
            return ds;
        }
        /// <summary>
        /// 获取产品线和经销商对应的销售
        /// </summary>
        /// <param name="DivisionID"></param>
        /// <returns></returns>
        public DataSet GetProductLineVsDealerSale(string DivisionID)
        {
            IList<String> buList =new List<String>();
            buList.Add(DivisionID);

            Hashtable obj = new Hashtable();
            if (DivisionID != null && (DivisionID.Equals("17") || DivisionID.Equals("18")))
            {
                buList.Add("36");
            }

            obj.Add("BuList", buList);
         
            DataSet ds = this.ExecuteQueryForDataSet("GetProductLineVsDealerSale", obj);
            return ds;
        }

        /// <summary>
        /// 获取产品线和经销商对应的销售
        /// </summary>
        /// <param name="DivisionID"></param>
        /// <returns></returns>
        public DataSet GetDealerSaleByPL(string PL,string DmaId)
        {
          
            Hashtable obj = new Hashtable();
            
            obj.Add("PL", PL);
            if (!string.IsNullOrEmpty(DmaId))
            {
                obj.Add("DMAID", DmaId);
            }
            DataSet ds = this.ExecuteQueryForDataSet("GetDealerSaleByPL", obj);
            return ds;
        }
        public DataSet GetProductLineVsDivisionCode(string Id)
        {
            DataSet ds = this.ExecuteQueryForDataSet("GetProductLineVsDivisionCode", Id);
            return ds;
        }

        public DataSet GetSaleInfoByFilter(string name, string email)
        {
            Hashtable table = new Hashtable();
            table.Add("Name", name);
            table.Add("Email", email);
            DataSet ds = this.ExecuteQueryForDataSet("GetSaleCodeByFilter", table);
            return ds;
        }

        /// <summary>
        /// 查询经销商退货
        /// </summary>
        /// <param name="table"></param>
        /// <param name="start"></param>
        /// <param name="limit"></param>
        /// <param name="totalRowCount"></param>
        /// <returns></returns>
        public DataSet QueryInventoryAdjustHeaderList(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryInventoryAdjustHeaderList", table, start, limit, out totalRowCount);
            return ds;
        }
        /// <summary>
        /// 查询退货单的产品
        /// </summary>
        /// <param name="Id"></param>
        /// <param name="start"></param>
        /// <param name="limit"></param>
        /// <param name="totalRowCount"></param>
        /// <returns></returns>
        public DataSet QueryInventoryAdjustCfnList(string Id, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryInventoryAdjustCfnList", Id, start, limit, out totalRowCount);
            return ds;
        }

        public DataSet QueryConsignmentTrackByOrderId(Guid Id, out string RtnVal, out string RtnMsg)
        {
            RtnVal = string.Empty;
            RtnMsg = string.Empty;
            Hashtable table = new Hashtable();
            table.Add("OrderId", Id);
            table.Add("RtnVal", RtnVal);
            table.Add("RtnMsg", RtnMsg);

            DataSet ds = this.ExecuteQueryForDataSet("QueryConsignmentTrackByOrderId", table);

            RtnVal = table["RtnVal"].ToString();
            RtnMsg = table["RtnMsg"].ToString();
            
            return ds;            
        }

        public int UpdateConsignmentApplyHeaderOrderStatus(ConsignmentApplyHeader obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateConsignmentApplyHeaderOrderStatus", obj);
            return cnt;
        }

        public int UpdateConsignmentApplyHeaderDelayOrderStatus(ConsignmentApplyHeader obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateConsignmentApplyHeaderDelayOrderStatus", obj);
            return cnt;
        }
        public DataSet SelecPOReceiptPriceSum(string CAID)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelecPOReceiptPriceSum", CAID);
            return ds;
        }
        public DataSet SelectHospitSale(string hospitId, string DivisionID)
        {
            Hashtable ht = new Hashtable();
            ht.Add("DivisionID", DivisionID);
            ht.Add("hospitId", hospitId);
            DataSet ds = this.ExecuteQueryForDataSet("SelectHospitSale", ht);
            return ds;
        }
        public bool SelectSalesSing(string Name, string Email)
        {
            Hashtable ht = new Hashtable();
            ht.Add("Name", Name);
            ht.Add("Email", Email);
            DataSet ds = this.ExecuteQueryForDataSet("SelectSalesSing", ht);
            if (ds.Tables[0].Rows.Count> 0)
            {
                if (int.Parse(ds.Tables[0].Rows[0]["Cnt"].ToString()) > 0)
                {
                    return true;
                }
            }
            return false;
        }
        public DataSet QueryConsignmentApplyProSumList(string Id, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryConsignmentApplyProSumList", Id, start, limit, out totalRowCount);
            return ds;
        }
        public DataSet SelectConsignmentApplyInitList(string Id, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectConsignmentApplyInitList", Id, start, limit, out totalRowCount);
            return ds;
        }

        /// <summary>
        /// 删除导入历史数据
        /// </summary>
        /// <param name="objKey"></param>
        /// <returns></returns>
        public int DeleteApplyInitByUser(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteConsignmentApplyInitByUser", objKey);
            return cnt;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="list"></param>
        public void ConsignmentApplyInit(IList<ConsignmentApplyInit> list)
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("CAI_ID");
            dt.Columns.Add("CAI_DealerSAP");
            dt.Columns.Add("CAI_No"); 
            dt.Columns.Add("CAI_ProductLineName");
            dt.Columns.Add("CAI_UPN");
            dt.Columns.Add("CAI_CCH_No");
            dt.Columns.Add("CAI_Qty");
            dt.Columns.Add("CAI_HospitalName");
            dt.Columns.Add("CAI_InputUserId");
            dt.Columns.Add("CAI_InputDate", typeof(DateTime));
            dt.Columns.Add("CAI_DMA_ID");
            dt.Columns.Add("CAI_ProductLine_BUM_ID");
            dt.Columns.Add("CAI_CFN_ID");
            dt.Columns.Add("CAI_HospitalId");
            dt.Columns.Add("CAI_CCH_ID");
            dt.Columns.Add("CAI_ErrorFlg");
            dt.Columns.Add("CAI_ErrorMessage");
            dt.Columns.Add("CAI_CAH_ID");
            dt.Columns.Add("CAI_LineNbr");

            foreach (ConsignmentApplyInit data in list)
            {
                DataRow row = dt.NewRow();

                row["CAI_ID"] = data.Id;
                row["CAI_DealerSAP"] = data.Dealersap;
                row["CAI_No"] = data.No;
                row["CAI_ProductLineName"] = data.ProductLineName;
                row["CAI_UPN"] = data.Upn;
                row["CAI_CCH_No"] = data.CchNo;
                row["CAI_Qty"] = data.Qty;
                row["CAI_HospitalName"] = data.HospitalName;
                row["CAI_InputUserId"] = data.InputUserId;
                row["CAI_InputDate"] = data.InputDate;

                row["CAI_DMA_ID"] = data.DmaId;
                row["CAI_ProductLine_BUM_ID"] = data.ProductLineBumId;
                row["CAI_CFN_ID"] = data.CfnId;
                row["CAI_HospitalId"] = data.HospitalId;
                row["CAI_CCH_ID"] = data.CchId;
                row["CAI_ErrorFlg"] = data.ErrorFlg;
                row["CAI_ErrorMessage"] = data.ErrorMessage;
                row["CAI_CAH_ID"] = data.CahId;
                row["CAI_LineNbr"] = data.LineNbr;

                dt.Rows.Add(row);
            }
            this.ExecuteBatchInsert("ConsignmentApplyInit", dt);
        }
        public string Initialize(string importType, Guid UserId, string SubCompanyId, string BrandId)
        {
            string IsValid = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("UserId", UserId);
            ht.Add("SubCompanyId", SubCompanyId);
            ht.Add("BrandId", BrandId);
            ht.Add("ImportType", importType);
            ht.Add("IsValid", IsValid);

            this.ExecuteInsert("GC_ConsignmentApplyInit", ht);

            IsValid = ht["IsValid"].ToString();

            return IsValid;
        }
    }
}