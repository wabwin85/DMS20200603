using System;
using System.Collections.Generic;
using System.Data;
using System.Collections;
using DMS.Model;

namespace DMS.Business
{
    public interface IGiftMaintainBLL
    {
        DataSet QueryGiftApprovalList(Hashtable obj, int start, int limit, out int totalCount);
        DataSet QueryPromotionSettlementList(Hashtable obj, int start, int limit, out int totalCount);
        DataSet GetApprovalCalPeriodByPeriod(string Period);
        DataSet GetPolicyCalPeriodByPeriod(string Period);
        DataSet GetProductInformation(Hashtable obj);
        DataSet GetGiftResult(Hashtable obj);
        DataSet GetPointResult(Hashtable obj);
        bool ImportGiftToEwf(DataTable dtGift, string description, string flowtype, string markettype, string reason, DateTime begindate, DateTime enddate, string approverole, string attachmentid, out string isValid);
        bool ImportGift(DataTable dtGift, string description, string flowtype, string markettype, string reason, DateTime begindate, DateTime enddate, string approverole, string attachmentid, out string isValid, out string flowId, out string QtyCheck);
        bool Import(DataTable dtGift);
        bool ImportPointToEwf(DataTable dtGift, string description, string flowtype, string markettype, string reason, DateTime begindate, DateTime enddate, string approverole, string attachmentid, out string isValid);
        bool ImportPoint(DataTable dtGift, string description, string flowtype, string markettype, string reason, DateTime begindate, DateTime enddate, string approverole, string attachmentid, out string isValid, out string flowId, out string QtyCheck);

        string GetProGiftHtml(string flowId);
        bool SubmintToEwf(string flowId);
        void DeleteGift(string flowId);

        //初始积分导入
        DataSet QueryInitialPointsList(Hashtable obj, int start, int limit, out int totalCount);
        void CreateInitialPoints(string userId);
        DataTable GetMaxFlowId(string obj);
        DataSet GetInitialPoints(string flowId);
        DataSet GetInitialPointsDetail(string flowId);
        bool DetailImport(DataTable dt, string flowno, out string errmsg);
        void UpdateInitialPoints(ProInitPointFlow header);
        void UpdateFormsStatus(string flowId,string ProductLineId);
        void GetInitPointEWorkFlowHtml(int flowId);
        void SendEWorkflow(int flowid);
        void UpdateInitialPointsHtmlStr(ProInitPointFlow header);
        void DeleteDraft(string flowid);
        void DeleteInitPointUPN(Hashtable obj);
        int AddInitPointUPN(Hashtable obj);
        DataSet SelectUseRangeCondition(Hashtable obj, int start, int limit, out int totalCount);
        DataSet QueryUseRangeSeleted(Hashtable obj, int start, int limit, out int totalCount);
        DataSet QueryUseRangeSeleted(Hashtable obj);
        void SubmintPolicySettlement(Hashtable obj);
        int AddInitPointProductType(Hashtable obj);
        DataSet InitialPointAttachment(Hashtable obj, int start, int limit, out int totalCount);
        void DeleteInitPoint(Hashtable obj);

        void SendEKPEWorkflow(ProInitPointFlow initpointflow);

        string GetTotalPointByFlowId(string FlowId);

        DataSet GetImportPoint(string FlowId);
    }
}
