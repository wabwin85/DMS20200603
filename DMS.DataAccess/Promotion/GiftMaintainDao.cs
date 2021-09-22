using System;
using System.Collections;
using System.Collections.Generic;
using IBatisNet.DataMapper;
using DMS.Model;
using System.Data;

namespace DMS.DataAccess
{
    public class GiftMaintainDao : BaseSqlMapDao
    {
        /// <summary>
        /// 默认构造函数
        /// </summary>
        public GiftMaintainDao()
            : base()
        {
        }

        /// <summary>
        /// 获取提交审批的赠品计算结果
        /// </summary>
        public DataSet QueryGiftApprovalList(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectGiftApprovalList", obj, start, limit, out totalCount);
            return ds;
        }

        /// <summary>
        /// 获取可计算政策信息
        /// </summary>
        public DataSet QueryPromotionSettlementList(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectPromotionSettlementList", obj, start, limit, out totalCount);
            return ds;
        }

        /// <summary>
        /// 获取赠品审批中账期类型
        /// </summary>
        public DataSet GetApprovalCalPeriodByPeriod(string Period)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectApprovalCalPeriodByPeriod", Period);
            return ds;
        }

        /// <summary>
        /// 获取政策信息中账期类型
        /// </summary>
        public DataSet GetPolicyCalPeriodByPeriod(string Period)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectPolicyCalPeriodByPeriod", Period);
            return ds;
        }

        /// <summary>
        /// 获取产品线信息
        /// </summary>
        public DataSet GetProductInformation(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectProduclInformation", obj);
            return ds;
        }

        /// <summary>
        /// 获取赠送计算结果
        /// </summary>
        public DataSet GetGiftResult(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectGiftResult", obj);
            return ds;
        }

        /// <summary>
        /// 获取积分计算结果
        /// </summary>
        public DataSet GetPointResult(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectPointResult", obj);
            return ds;
        }

        /// <summary>
        /// 导入赠品明细与平台汇总表
        /// </summary>
        public string ImportGiftResult(Hashtable obj, out string flowId, out string qtyCheck)
        {
            this.ExecuteInsert("GC_ImportProGiftResult", obj);
            string Result = obj["Return"].ToString();
            flowId = obj["ReFlowId"].ToString();
            qtyCheck = obj["ReQty"].ToString();
            return Result;
        }

        /// <summary>
        /// 导入积分明细与平台汇总表
        /// </summary>
        public string ImportPointResult(Hashtable obj, out string flowId, out string qtyCheck)
        {
            this.ExecuteInsert("GC_ImportProPointResult", obj);
            string Result = obj["Return"].ToString();
            flowId = obj["ReFlowId"].ToString();
            qtyCheck = obj["ReQty"].ToString();
            return Result;
        }

        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int DeleteGift(string flowId)
        {
            int cnt = (int)this.ExecuteDelete("DeleteTProFlow", flowId);
            return cnt;
        }


        /// <summary>
        /// 更新赠品审批状态
        /// </summary>
        public int UpdateGiftFlow(Hashtable obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateProGiftFlow", obj);
            return cnt;
        }

        /// <summary>
        /// 获取赠品审批HTML
        /// </summary>
        public DataSet GetProGiftHtml(string flowId)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectProGiftHtml", flowId);
            return ds;
        }

        /// <summary>
        /// 获取初始积分审批列表
        /// </summary>
        public DataSet QueryInitialPointsList(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectInitialPointsList", obj, start, limit, out totalCount);
            return ds;
        }
        ///<summary>
        ///新建初始化积分导入审批表
        ///</summary>
        public void CreateInitialPoints(string obj)
        {
            ProInitPointFlow flow = new ProInitPointFlow();
            flow.Status = "草稿";
            flow.CreateBy = obj;
            flow.CreateTime = DateTime.Now;
            this.ExecuteInsert("InsertProInitPointFlow", flow);
        }

        public DataTable GetMaxFlowId(string obj)
        {
            DataTable dt = this.ExecuteQueryForDataSet("GetMaxFlowId", obj).Tables[0];
            return dt;
        }

        public DataSet GetInitialPoints(string flowId)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectProInitPointFlowByFlowId", flowId);
            return ds;
        }

        public DataSet GetInitialPointsDetail(string flowId)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectProInitPointFlowDetailByFlowId", flowId);
            return ds;
        }

        public void UpdateInitialPoints(ProInitPointFlow header)
        {
            this.ExecuteUpdate("UpdateProInitPointFlow", header);
        }
        public void UpdateFormsStatus(Hashtable ht)
        {
            this.ExecuteInsert("P_I_EW_InitPoint_Approval", ht);
        }

        public void UpdateInitialPointsHtmlStr(ProInitPointFlow header)
        {
            this.ExecuteUpdate("UpdateInitialPointsHtmlStr", header);
        }

        public string CheckDealerName(string dealerName)
        {
            DataSet ds = this.ExecuteQueryForDataSet("CheckDealerName", dealerName);

            if (ds.Tables.Count > 0 && ds != null)
            {
                if (ds.Tables[0].Rows.Count > 0)
                {
                    return ds.Tables[0].Rows[0]["DMA_ID"].ToString();
                }
                else
                {
                    return "错误";
                }
            }
            else
            {
                return "错误";
            }
        }

        public string CheckPolicyNo(string PolicyNo)
        {
            DataSet ds = this.ExecuteQueryForDataSet("CheckPolicyNo", PolicyNo);

            if (ds.Tables.Count > 0 && ds != null)
            {
                if (ds.Tables[0].Rows.Count > 0)
                {
                    return ds.Tables[0].Rows[0]["PolicyNo"].ToString();
                }
                else
                {
                    return "错误";
                }
            }
            else
            {
                return "错误";
            }
        }

        public void InsertProInitPointFlowDetail(ProInitPointFlowDetail obj)
        {
            this.ExecuteInsert("InsertProInitPointFlowDetail", obj);
        }

        public void DeleteDraft(string obj)
        {
            this.ExecuteDelete("DeleteProInitPointFlow", obj);
        }

        public void GetInitPointEWorkFlowHtml(int flowid)
        {
            Hashtable obj = new Hashtable();
            obj.Add("FlowId", flowid);

            this.ExecuteInsert("GC_InitPointGetEWorkFlowHtml", obj);
        }

        public DataSet GetBUCodeByProductLineId(string ProductLineName)
        {
            DataSet ds = this.ExecuteQueryForDataSet("GetBUCodeByProductLineId", ProductLineName);
            return ds;
        }

        public string GetTotalPointByFlowId(string obj)
        {
            DataTable dt = this.ExecuteQueryForDataSet("GetTotalPointByFlowId", obj).Tables[0];
            if (dt != null && dt.Rows.Count > 0)
            {
                return dt.Rows[0]["Point"].ToString();
            }
            else
            {
                return "0";
            }

        }

        public void DeleteInitPointUPN(Hashtable obj)
        {
            this.ExecuteDelete("DeleteInitPointUPN", obj);
        }

        public int AddInitPointUPN(Hashtable obj)
        {
            int cnt = (int)this.ExecuteUpdate("AddInitPointUPN", obj);
            return cnt;
        }

        public DataSet SelectUseRangeCondition(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectUseRangeCondition", obj, start, limit, out totalCount);
            return ds;
        }

        public DataSet SelectUseRangeSeleted(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectUseRangeSeleted", obj, start, limit, out totalCount);
            return ds;
        }
        public DataSet SelectUseRangeSeleted(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectUseRangeSeleted", obj);
            return ds;
        }

        public DataSet SelectGiftInfo4EWorkflowByFlowId(string obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectGiftInfo4EWorkflowByFlowId", obj);
            return ds;
        }

        public void SubmintPolicySettlement(Hashtable obj)
        {
            this.ExecuteQueryForDataSet("GC_PolicyClosing", obj);
        }

        public int AddInitPointProductType(Hashtable obj)
        {
            int cnt = (int)this.ExecuteUpdate("AddInitPointProductType", obj);
            return cnt;
        }
        public DataSet InitialPointAttachment(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectInitialPointAttachment", obj, start, limit, out totalCount);
            return ds;
        }

        public void DeleteInitPoint(Hashtable obj)
        {
            this.ExecuteUpdate("DeleteInitPoint", obj);
        }

        public DataSet GetPromotionGift(string flowid)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectPromotionGift", flowid);
            return ds;
        }
        public void UpdateGiftPromotionFlowNo(Hashtable obj)
        {
            this.ExecuteUpdate("UpdateGiftPromotionFlowNo", obj);
        }
        public string GetPromotionGiftSubDealer(string flowid)
        {
            string dealerSub = "";
            DataSet ds = this.ExecuteQueryForDataSet("SelectPromotionGiftSubDealer", flowid);
            if (ds.Tables[0].Rows.Count > 0)
            {
                dealerSub = ds.Tables[0].Rows[0]["DealerName"].ToString();
            }
            return dealerSub;
        }

        public string GetPromotionInitPointSubDealer(string flowid)
        {
            string dealerSub = "";
            DataSet ds = this.ExecuteQueryForDataSet("SelectPromotionInitPointSubDealer", flowid);
            if (ds.Tables[0].Rows.Count > 0)
            {
                dealerSub = ds.Tables[0].Rows[0]["DealerName"].ToString();
            }
            return dealerSub;
        }

        public string GetPromotionInitPointBUName(string flowid)
        {
            string buName = "";
            DataSet ds = this.ExecuteQueryForDataSet("SelectPromotionInitPointBUName", flowid);
            if (ds.Tables[0].Rows.Count > 0)
            {
                buName = ds.Tables[0].Rows[0]["DivisionName"].ToString();
            }
            return buName;
        }

        public DataSet GetImportPoint(string flowid)
        {
            DataSet ds = this.ExecuteQueryForDataSet("GetImportPointByFlowId", flowid);
            return ds;
        }

        public void ImportGiftResult(Hashtable obj)
        {
            this.ExecuteInsert("InsertTProFlowImport", obj);            
        }
        public void ImportPolicyResult(Hashtable obj)
        {
            this.ExecuteInsert("InsertTPolicyImport", obj);
        }

        public void DeleteImportGift(String obj)
        {
            this.ExecuteDelete("DeleteImportGift", obj);
        }
        public string GetImportAdjustPresentTotal(String obj)
        {
            DataTable dt = this.ExecuteQueryForDataSet("GetImportAdjustPresentTotal", obj).Tables[0];
            if(dt.Rows.Count > 0)
            {
                return dt.Rows[0]["Total"].ToString();
            }
            else
            {
                return "0";
            }

        }

        public void UpdateProOperationState(string FlowId)
        {
            this.ExecuteUpdate("UpdateProOperationState", FlowId);
        }

    }
}
