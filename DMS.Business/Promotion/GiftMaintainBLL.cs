using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

using Grapecity.DataAccess.Transaction;
using Lafite.RoleModel.Security;
using Lafite.RoleModel.Security.Authorization;
using Grapecity.Logging.CallHandlers;

using DMS.DataAccess;
using DMS.Model;
using System.Net;
using DMS.Common;
using DMS.Business.EKPWorkflow;
using DMS.Model.EKPWorkflow;
using DMS.DataAccess.Contract;

namespace DMS.Business
{
    public class GiftMaintainBLL : IGiftMaintainBLL
    {
        #region IPromotionPolicyBLL 成员
        IRoleModelContext _context = RoleModelContext.Current;
        public DataSet QueryGiftApprovalList(Hashtable obj, int start, int limit, out int totalCount)
        {
            using (GiftMaintainDao dao = new GiftMaintainDao())
            {
                return dao.QueryGiftApprovalList(obj, start, limit, out totalCount);
            }
        }

        public DataSet QueryPromotionSettlementList(Hashtable obj, int start, int limit, out int totalCount)
        {
            using (GiftMaintainDao dao = new GiftMaintainDao())
            {
                return dao.QueryPromotionSettlementList(obj, start, limit, out totalCount);
            }
        }

        public DataSet GetApprovalCalPeriodByPeriod(string Period)
        {
            using (GiftMaintainDao dao = new GiftMaintainDao())
            {
                return dao.GetApprovalCalPeriodByPeriod(Period);
            }
        }

        public DataSet GetPolicyCalPeriodByPeriod(string Period)
        {
            using (GiftMaintainDao dao = new GiftMaintainDao())
            {
                return dao.GetPolicyCalPeriodByPeriod(Period);
            }
        }

        /// <summary>
        /// 获取产品线信息
        /// </summary>
        public DataSet GetProductInformation(Hashtable obj)
        {
            using (GiftMaintainDao dao = new GiftMaintainDao())
            {
                return dao.GetProductInformation(obj);
            }
        }

        /// <summary>
        /// 获取赠送计算结果
        /// </summary>
        public DataSet GetGiftResult(Hashtable obj)
        {
            using (GiftMaintainDao dao = new GiftMaintainDao())
            {
                return dao.GetGiftResult(obj);
            }
        }

        /// <summary>
        /// 获取积分计算结果
        /// </summary>
        public DataSet GetPointResult(Hashtable obj)
        {
            using (GiftMaintainDao dao = new GiftMaintainDao())
            {
                return dao.GetPointResult(obj);
            }
        }

        /// <summary>
        /// 将赠品导入系统提交审批
        /// </summary>
        public bool ImportGiftToEwf(DataTable dtGift, string description, string flowtype, string markettype, string reason, DateTime begindate, DateTime enddate, string approverole, string attachmentid, out string isValid)
        {
            bool retValue = true;
            isValid = "";
            //1.将datable列名转成英文
            DataTable dtReturn = ConvertTableColumns(dtGift);

            //2. 转换成HTML
            string retHtml = ConertToXml(dtReturn);

            //3. 调用存储程序解析
            Hashtable obj = new Hashtable();
            obj.Add("UserId", _context.User.Id);
            obj.Add("Description", description);
            obj.Add("MarketType", markettype);
            obj.Add("Reason", reason);
            obj.Add("BeginDate", begindate);
            obj.Add("EndDate", enddate);
            obj.Add("ApproveRole", approverole);
            obj.Add("AttachmentId", attachmentid);
            obj.Add("FormXml", retHtml);
            obj.Add("Return", string.Empty);
            obj.Add("ReFlowId", string.Empty);

            GiftMaintainDao dao = new GiftMaintainDao();
            string flowId = "";
            string result = dao.ImportGiftResult(obj, out flowId, out flowId);
            if (!result.Equals("Success"))
            {
                retValue = false;
                isValid = result;
            }
            else
            {
                if (!flowId.Equals(""))
                {

                    //4. 调用E-workflow WebService 同步审批HTML
                    SendEWorkflow(flowId, GetProGiftHtml(flowId), flowtype, markettype, reason);

                    //5. 更新赠品提交审批主表状态为“审批中”
                    Hashtable obj2 = new Hashtable();
                    obj2.Add("flowId", flowId);
                    obj2.Add("Status", "审批中");
                    dao.UpdateGiftFlow(obj2);
                }
                else
                {
                    retValue = false;
                    isValid = "数据错误";
                }
            }
            return retValue;
        }

        /// <summary>
        /// 将赠品导入系统
        /// </summary>
        public bool ImportGift(DataTable dtGift, string description, string flowtype, string markettype, string reason, DateTime begindate, DateTime enddate, string approverole, string attachmentid, out string isValid, out string flowId, out string qtyCheck)
        {
            bool retValue = true;
            isValid = "";
            GiftMaintainDao dao = new GiftMaintainDao();
            ////1.将datable列名转成英文
            //DataTable dtReturn = ConvertTableColumns(dtGift);

            ////2. 转换成HTML
            //string retHtml = ConertToXml(dtReturn);

            //3. 调用存储程序解析
            Hashtable obj = new Hashtable();
            obj.Add("UserId", _context.User.Id);
            obj.Add("Description", description);
            obj.Add("MarketType", markettype);
            obj.Add("Reason", reason);
            obj.Add("BeginDate", begindate);
            obj.Add("EndDate", enddate);
            obj.Add("ApproveRole", approverole);
            obj.Add("AttachmentId", attachmentid);
            obj.Add("PresentType", "赠品");
            obj.Add("Return", string.Empty);
            obj.Add("ReFlowId", string.Empty);
            obj.Add("ReQty", string.Empty);

            //先删除之前上传的内容
            dao.DeleteImportGift(_context.User.Id);

            for (int i = 1; i < dtGift.Rows.Count; i++)
            {
                Hashtable obj2 = new Hashtable();
                obj2.Add("UserId", _context.User.Id);
                obj2.Add("BU", dtGift.Rows[i][0].ToString());
                obj2.Add("Period", dtGift.Rows[i][1].ToString());
                obj2.Add("PolicyNo", dtGift.Rows[i][2].ToString());
                obj2.Add("ParentDealerCode", dtGift.Rows[i][3].ToString());
                obj2.Add("ParentDealerName", dtGift.Rows[i][4].ToString());
                obj2.Add("DealerCode", dtGift.Rows[i][5].ToString());
                obj2.Add("DealerName", dtGift.Rows[i][6].ToString());
                obj2.Add("HospitalCode", dtGift.Rows[i][7].ToString());
                obj2.Add("HospitalName", dtGift.Rows[i][8].ToString());
                obj2.Add("PresentValueConverted", dtGift.Rows[i][9].ToString());
                obj2.Add("PresentType", "实物产品");
                obj2.Add("AdjustPresentValue", dtGift.Rows[i][10].ToString());
                obj2.Add("ActualValueLeft", dtGift.Rows[i][11].ToString());
                //obj.Add("PointType", approverole);
                //obj.Add("LPPointConvertRate", approverole);
                //obj.Add("PointValidEndDate", approverole);
                obj2.Add("UnitPrice", dtGift.Rows[i][12].ToString());

                dao.ImportGiftResult(obj2);
            }

            string result = dao.ImportGiftResult(obj, out flowId, out qtyCheck);
            if (!result.Equals("Success"))
            {
                retValue = false;
                isValid = result;
            }

            return retValue;
        }

        /// <summary>
        /// 后台直接导入
        /// </summary>
        public bool Import(DataTable dtGift)
        {
            GiftMaintainDao dao = new GiftMaintainDao();

            //先删除之前上传的内容
            string PolicyNo = string.Empty;
            PolicyNo = "ZC-" + DateTime.Now.ToString("yyyyMMddHHmmss");
            for (int i = 1; i < dtGift.Rows.Count; i++)
            {
                Hashtable obj2 = new Hashtable();
                obj2.Add("PolicyNo", PolicyNo);
                obj2.Add("ProductLineName", dtGift.Rows[i][0].ToString());
                obj2.Add("SubCompanyName", dtGift.Rows[i][1].ToString());
                obj2.Add("BrandName", dtGift.Rows[i][2].ToString());
                obj2.Add("CA_NameCN", dtGift.Rows[i][3].ToString());
                obj2.Add("PolicyScope", dtGift.Rows[i][4].ToString());
                obj2.Add("SelectCode", dtGift.Rows[i][5].ToString());

                dao.ImportPolicyResult(obj2);
            }
            return true;
        }

        /// <summary>
        /// 将积分导入系统提交审批
        /// </summary>
        public bool ImportPointToEwf(DataTable dtGift, string description, string flowtype, string markettype, string reason, DateTime begindate, DateTime enddate, string approverole, string attachmentid, out string isValid)
        {
            bool retValue = true;
            isValid = "";
            //1.将datable列名转成英文
            DataTable dtReturn = ConvertTableColumnsPoint(dtGift);

            //2. 转换成HTML
            string retHtml = ConertToXml(dtReturn);

            //3. 调用存储程序解析
            Hashtable obj = new Hashtable();
            obj.Add("UserId", _context.User.Id);
            obj.Add("Description", description);
            obj.Add("MarketType", markettype);
            obj.Add("Reason", reason);
            obj.Add("BeginDate", begindate);
            obj.Add("EndDate", enddate);
            obj.Add("ApproveRole", approverole);
            obj.Add("AttachmentId", attachmentid);
            obj.Add("FormXml", retHtml);
            obj.Add("Return", string.Empty);
            obj.Add("ReFlowId", string.Empty);

            GiftMaintainDao dao = new GiftMaintainDao();
            string flowId = "";
            string result = dao.ImportPointResult(obj, out flowId, out flowId);
            if (!result.Equals("Success"))
            {
                retValue = false;
                isValid = result;
            }
            else
            {
                if (!flowId.Equals(""))
                {
                    //4. 调用E-workflow WebService 同步审批HTML
                    SendEWorkflow(flowId, GetProGiftHtml(flowId), flowtype, markettype, reason);

                    //5. 更新赠品提交审批主表状态为“审批中”
                    Hashtable obj2 = new Hashtable();
                    obj2.Add("flowId", flowId);
                    obj2.Add("Status", "审批中");
                    dao.UpdateGiftFlow(obj2);
                }
                else
                {
                    retValue = false;
                    isValid = "数据错误";
                }
            }
            return retValue;
        }

        /// <summary>
        /// 将积分导入系统提交审批
        /// </summary>
        public bool ImportPoint(DataTable dtGift, string description, string flowtype, string markettype, string reason, DateTime begindate, DateTime enddate, string approverole, string attachmentid, out string isValid, out string flowId, out string qtyCheck)
        {
            bool retValue = true;
            isValid = "";
            ////1.将datable列名转成英文
            //DataTable dtReturn = ConvertTableColumns(dtGift);

            ////2. 转换成HTML
            //string retHtml = ConertToXml(dtReturn);

            //3. 调用存储程序解析
            Hashtable obj = new Hashtable();
            obj.Add("UserId", _context.User.Id);
            obj.Add("Description", description);
            obj.Add("MarketType", markettype);
            obj.Add("Reason", reason);
            obj.Add("BeginDate", begindate);
            obj.Add("EndDate", enddate);
            obj.Add("ApproveRole", approverole);
            obj.Add("AttachmentId", attachmentid);
            obj.Add("PresentType", "积分");
            obj.Add("Return", string.Empty);
            obj.Add("ReFlowId", string.Empty);
            obj.Add("ReQty", string.Empty);

            GiftMaintainDao dao = new GiftMaintainDao();

            //先删除之前上传的内容
            dao.DeleteImportGift(_context.User.Id);

            for (int i = 1; i < dtGift.Rows.Count; i++)
            {
                Hashtable obj2 = new Hashtable();
                obj2.Add("UserId", _context.User.Id);
                obj2.Add("BU", dtGift.Rows[i][0].ToString());
                obj2.Add("Period", dtGift.Rows[i][1].ToString());
                obj2.Add("PolicyNo", dtGift.Rows[i][2].ToString());
                obj2.Add("ParentDealerCode", dtGift.Rows[i][3].ToString());
                obj2.Add("ParentDealerName", dtGift.Rows[i][4].ToString());
                obj2.Add("DealerCode", dtGift.Rows[i][5].ToString());
                obj2.Add("DealerName", dtGift.Rows[i][6].ToString());
                obj2.Add("HospitalCode", dtGift.Rows[i][7].ToString());
                obj2.Add("HospitalName", dtGift.Rows[i][8].ToString());
                obj2.Add("PresentValueConverted", dtGift.Rows[i][9].ToString());
                obj2.Add("PresentType", "积分金额");
                obj2.Add("AdjustPresentValue", dtGift.Rows[i][10].ToString());
                obj2.Add("ActualValueLeft", dtGift.Rows[i][11].ToString());
                obj2.Add("PointType", dtGift.Rows[i][12].ToString());
                obj2.Add("LPPointConvertRate", dtGift.Rows[i][13].ToString());
                obj2.Add("PointValidEndDate", dtGift.Rows[i][14].ToString());
                //obj.Add("UnitPrice", dtGift.Rows[i][13].ToString());

                dao.ImportGiftResult(obj2);
            }
            string result = dao.ImportGiftResult(obj, out flowId, out qtyCheck);
            if (!result.Equals("Success"))
            {
                retValue = false;
                isValid = result;
            }
            return retValue;
        }


        /// <summary>
        /// 调用E-workflow接口提交审批
        /// </summary>
        public bool SubmintToEwf(string flowId)
        {
            GiftMaintainDao dao = new GiftMaintainDao();
            bool retValue = true;
            SendEKPEWorkflow(flowId);
            return retValue;
        }

        public void DeleteGift(string flowId)
        {
            using (GiftMaintainDao dao = new GiftMaintainDao())
            {
                dao.DeleteGift(flowId);
            }
        }

        /// <summary>
        /// 将Datatable转换成HTML
        /// </summary>
        public static string ConertToXml(DataTable dt)
        {
            dt.TableName = "Table";
            if (null != dt.DataSet)
            {
                dt.DataSet.DataSetName = "DocumentElement";
            }
            System.IO.MemoryStream ms = new System.IO.MemoryStream();
            dt.WriteXml(ms);
            string xmlContent = System.Text.Encoding.UTF8.GetString(ms.ToArray());
            return string.Format("<?xml   version=\"1.0\"   encoding=\"unicode\"   ?> {0}", xmlContent);
        }

        /// <summary>
        /// 转换表列名
        /// </summary>
        public DataTable ConvertTableColumns(DataTable dt)
        {
            int lineNbr = 1;

            DataTable dtReturn = new DataTable();
            dtReturn.Columns.Add("BU", typeof(string));
            dtReturn.Columns.Add("AccountMonth", typeof(string));
            dtReturn.Columns.Add("PolicyNo", typeof(string));
            dtReturn.Columns.Add("SAPCode", typeof(string));
            dtReturn.Columns.Add("DealerName", typeof(string));
            dtReturn.Columns.Add("HospitalId", typeof(string));
            dtReturn.Columns.Add("HospitalName", typeof(string));
            dtReturn.Columns.Add("OraNum", typeof(string));
            dtReturn.Columns.Add("AdjustNum", typeof(string));

            foreach (DataRow dr in dt.Rows)
            {
                ProGiftDetail data = new ProGiftDetail();
                data.Bu = dr[0] == DBNull.Value ? null : dr[0].ToString();
                data.AccountMonth = dr[1] == DBNull.Value ? null : dr[1].ToString();
                data.PolicyNo = dr[2] == DBNull.Value ? null : dr[2].ToString();
                data.SAPCode = dr[6] == DBNull.Value ? null : dr[6].ToString();
                data.DealerName = dr[7] == DBNull.Value ? null : dr[7].ToString();
                data.HospitalId = dr[8] == DBNull.Value ? null : dr[8].ToString();
                data.HospitalName = dr[9] == DBNull.Value ? null : dr[9].ToString();
                data.OraNum = dr[10] == DBNull.Value ? null : dr[10].ToString();
                data.AdjustNum = dr[11] == DBNull.Value ? null : dr[11].ToString();

                DataRow newRow = dtReturn.NewRow();
                if (lineNbr != 1)
                {
                    newRow[0] = data.Bu;
                    newRow[1] = data.AccountMonth;
                    newRow[2] = data.PolicyNo;
                    newRow[3] = data.SAPCode;
                    newRow[4] = data.DealerName;
                    newRow[5] = data.HospitalId;
                    newRow[6] = data.HospitalName;
                    newRow[7] = data.OraNum;
                    newRow[8] = data.AdjustNum;
                    dtReturn.Rows.Add(newRow);
                }
                lineNbr += 1;
            }

            return dtReturn;
        }

        /// <summary>
        /// 转换表列名（积分）
        /// </summary>
        public DataTable ConvertTableColumnsPoint(DataTable dt)
        {
            int lineNbr = 1;

            DataTable dtReturn = new DataTable();
            dtReturn.Columns.Add("BU", typeof(string));
            dtReturn.Columns.Add("AccountMonth", typeof(string));
            dtReturn.Columns.Add("PolicyNo", typeof(string));
            dtReturn.Columns.Add("SAPCode", typeof(string));
            dtReturn.Columns.Add("DealerName", typeof(string));
            dtReturn.Columns.Add("HospitalId", typeof(string));
            dtReturn.Columns.Add("HospitalName", typeof(string));
            dtReturn.Columns.Add("OraNum", typeof(string));
            dtReturn.Columns.Add("AdjustNum", typeof(string));
            dtReturn.Columns.Add("PointType", typeof(string));
            dtReturn.Columns.Add("Ratio", typeof(string));
            dtReturn.Columns.Add("PointValidDate", typeof(string));

            foreach (DataRow dr in dt.Rows)
            {
                ProGiftDetail data = new ProGiftDetail();
                data.Bu = dr[0] == DBNull.Value ? null : dr[0].ToString();
                data.AccountMonth = dr[1] == DBNull.Value ? null : dr[1].ToString();
                data.PolicyNo = dr[2] == DBNull.Value ? null : dr[2].ToString();
                data.SAPCode = dr[6] == DBNull.Value ? null : dr[6].ToString();
                data.DealerName = dr[7] == DBNull.Value ? null : dr[7].ToString();
                data.HospitalId = dr[8] == DBNull.Value ? null : dr[8].ToString();
                data.HospitalName = dr[9] == DBNull.Value ? null : dr[9].ToString();
                data.OraNum = dr[10] == DBNull.Value ? null : dr[10].ToString();
                data.AdjustNum = dr[11] == DBNull.Value ? null : dr[11].ToString();
                data.PointType = dr[12] == DBNull.Value ? null : dr[12].ToString();
                data.Ratio = dr[13] == DBNull.Value ? null : dr[13].ToString();
                data.PointValidDate = dr[14] == DBNull.Value ? null : dr[14].ToString();

                DataRow newRow = dtReturn.NewRow();
                if (lineNbr != 1)
                {
                    newRow[0] = data.Bu;
                    newRow[1] = data.AccountMonth;
                    newRow[2] = data.PolicyNo;
                    newRow[3] = data.SAPCode;
                    newRow[4] = data.DealerName;
                    newRow[5] = data.HospitalId;
                    newRow[6] = data.HospitalName;
                    newRow[7] = data.OraNum;
                    newRow[8] = data.AdjustNum;
                    newRow[9] = data.PointType;
                    newRow[10] = data.Ratio;
                    newRow[11] = data.PointValidDate;
                    dtReturn.Rows.Add(newRow);
                }
                lineNbr += 1;
            }

            return dtReturn;
        }
        public void SendEKPEWorkflow(string flowId)
        {
            TenderAuthorizationListDao dao2 = new TenderAuthorizationListDao();
            GiftMaintainDao dao = new GiftMaintainDao();

            DataTable dt = dao.GetPromotionGift(flowId).Tables[0];
            if (dt.Rows.Count > 0)
            {
                string flowNo = dao2.GetNextAutoNumberForTender(dt.Rows[0]["ProductLineID"].ToString(), "PRE", "SysSalesUploader");
                Hashtable obj = new Hashtable();
                obj.Add("FlowId", flowId);
                obj.Add("FlowNo", flowNo);
                dao.UpdateGiftPromotionFlowNo(obj);

                string dealerName = "";
                dealerName = dao.GetPromotionGiftSubDealer(flowId);

                //更新OperationState
                dao.UpdateProOperationState(flowId);

                ekpBll.DoSubmit(_context.User.LoginId, dt.Rows[0]["InstanceID"].ToString(), flowNo, "Promotion", string.Format("{0} {1}促销执行申请({2})", flowNo, dealerName, dt.Rows[0]["DivisionName"].ToString()), EkpModelId.Promotion.ToString(), EkpTemplateFormId.PromotionTemplate.ToString());
            }
        }
        public void SendEWorkflow(string flowId, string giftXML, string type, string markettype, string PriceTypeReason)
        {
            if ("1" != SR.CONST_DMS_Promotion_DEVELOP)
            {
                EwfService.WfAction wfAction = new EwfService.WfAction();
                wfAction.Credentials = new NetworkCredential(SR.CONST_EWF_USER_NAME, SR.CONST_EWF_USER_PWD, SR.CONST_EWF_DOMAIN);

                string template = WorkflowTemplate.PromotionGiftTemplate.Clone().ToString();
                string rtnVal = string.Empty;
                string rtnMsg = string.Empty;
                DataTable dt = new DataTable();
                string userAccount = "";
                // 获取 userAccount
                using (ProPolicyDao dao = new ProPolicyDao())
                {
                    userAccount = dao.QueryEWorkflowAccount(_context.User.LoginId);
                }
                using (GiftMaintainDao dao = new GiftMaintainDao())
                {
                    dt = dao.SelectGiftInfo4EWorkflowByFlowId(flowId).Tables[0];
                }
                if (PriceTypeReason.Equals("已获取亚太审批的促销政策"))
                {
                    PriceTypeReason = "1";
                }
                else if (PriceTypeReason.Equals("不需获取亚太审批的促销政策(非红票冲抵)"))
                {
                    PriceTypeReason = "2";
                }
                else if (PriceTypeReason.Equals("不需获取亚太审批的促销政策(红票冲抵)"))
                {
                    PriceTypeReason = "3";
                }

                if (giftXML != "")
                {
                    template = string.Format(template, SR.CONST_PROMOTION_POLICYGIFT_NO, userAccount, userAccount, DateTime.Now, dt.Rows[0]["BuId"].ToString(), dt.Rows[0]["Period"].ToString(), dt.Rows[0]["AdjustNum"].ToString(), type, flowId, giftXML, markettype, PriceTypeReason);
                    using (ProPolicyDao dao2 = new ProPolicyDao())
                    {
                        dao2.InsertPolicyOperationLog(template);
                    }
                    wfAction.StartInstanceXml(template, SR.CONST_EWF_WEB_PWD);
                }
            }
        }

        public string GetProGiftHtml(string flowId)
        {
            string htmlValue = "";
            using (GiftMaintainDao dao = new GiftMaintainDao())
            {
                DataTable dthtml = dao.GetProGiftHtml(flowId).Tables[0];
                if (dthtml != null && dthtml.Rows.Count > 0)
                {
                    htmlValue = dthtml.Rows[0]["HtmlStr"].ToString();
                }
            }
            return htmlValue;
        }

        #endregion

        private EkpWorkflowBLL ekpBll = new EkpWorkflowBLL();

        #region 初始积分导入
        public DataSet QueryInitialPointsList(Hashtable obj, int start, int limit, out int totalCount)
        {
            using (GiftMaintainDao dao = new GiftMaintainDao())
            {
                return dao.QueryInitialPointsList(obj, start, limit, out totalCount);
            }
        }

        public void CreateInitialPoints(string userId)
        {
            using (GiftMaintainDao dao = new GiftMaintainDao())
            {
                dao.CreateInitialPoints(userId);
            }
        }

        public DataSet GetInitialPoints(string userId)
        {
            using (GiftMaintainDao dao = new GiftMaintainDao())
            {
                return dao.GetInitialPoints(userId);
            }
        }

        public DataSet GetInitialPointsDetail(string userId)
        {
            using (GiftMaintainDao dao = new GiftMaintainDao())
            {
                return dao.GetInitialPointsDetail(userId);
            }
        }

        public DataTable GetMaxFlowId(string userId)
        {
            using (GiftMaintainDao dao = new GiftMaintainDao())
            {
                return dao.GetMaxFlowId(userId);
            }
        }

        public void UpdateInitialPoints(ProInitPointFlow header)
        {
            using (GiftMaintainDao dao = new GiftMaintainDao())
            {
                dao.UpdateInitialPoints(header);
            }
        }

        public void UpdateFormsStatus(string flowId,string ProductLineId)
        {
            Hashtable ht = new Hashtable();
            ht["FlowId"] = flowId;
            ht["EWorkFlowNo"] = "";
            ht["Status"] = "审批通过";
            ht["ApprovalType"] = 1;
            ht["ProductLineId"] = ProductLineId;
            using (GiftMaintainDao dao = new GiftMaintainDao())
            {
                dao.UpdateFormsStatus(ht);
            }
        }

        public void UpdateInitialPointsHtmlStr(ProInitPointFlow header)
        {
            using (GiftMaintainDao dao = new GiftMaintainDao())
            {
                dao.UpdateInitialPointsHtmlStr(header);
            }
        }

        public bool DetailImport(DataTable dt, string flowId, out string errmsg)
        {
            System.Diagnostics.Debug.WriteLine("Import Start : " + DateTime.Now.ToString());
            bool result = false;
            errmsg = "";
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    GiftMaintainDao dao = new GiftMaintainDao();
                    string IsValid = "";

                    for (int i = 1; i < dt.Rows.Count; i++)
                    {
                        ProInitPointFlowDetail data = new ProInitPointFlowDetail();
                        if (String.IsNullOrEmpty(flowId))
                        {
                            errmsg = "缺少主键、";
                        }
                        else
                        {
                            data.FlowId = Convert.ToInt32(flowId);
                        }
                        //
                        if (dt.Rows[i][0] != DBNull.Value)
                        {
                            //IsValid = dao.CheckPolicyNo(dt.Rows[i][0].ToString());
                            //if (!IsValid.Equals("错误"))
                            //{
                            //    data.PolicyNo = IsValid;
                            //}
                            //else
                            //{
                            //    errmsg += (" 政策编号[" + dt.Rows[i][0].ToString() + "]填写不正确");
                            //}
                            data.PolicyNo = dt.Rows[i][0].ToString();
                        }
                        else
                        {
                            errmsg += (" 请填写政策编号");
                        }
                        //判断经销商名称填写是否正确
                        if (dt.Rows[i][1] != DBNull.Value)
                        {
                            IsValid = dao.CheckDealerName(dt.Rows[i][1].ToString());
                            if (!IsValid.Equals("错误"))
                            {
                                data.DealerId = new Guid(IsValid);
                            }
                            else
                            {
                                errmsg += (" 经销商编号[" + dt.Rows[i][1].ToString() + "]填写不正确");
                            }
                        }
                        else
                        {
                            errmsg += (" 请填写经销商编号");
                        }

                        if (dt.Rows[i][2] != DBNull.Value && data.DealerId == null)
                        {
                            IsValid = dao.CheckDealerName(dt.Rows[i][2].ToString());
                            if (!IsValid.Equals("错误"))
                            {
                                data.DealerId = new Guid(IsValid);
                            }
                            else
                            {
                                errmsg += (" 经销商名称[" + dt.Rows[i][2].ToString() + "]填写不正确");
                            }
                        }
                        else if (dt.Rows[i][2] == DBNull.Value)
                        {
                            errmsg += (" 请填写经销商名称");
                        }

                        decimal point;
                        if (string.IsNullOrEmpty(dt.Rows[i][3].ToString()))
                        {
                            errmsg += ("请填写积分");
                        }
                        else if (!Decimal.TryParse(dt.Rows[i][3].ToString(), out point))
                        {
                            errmsg += (dt.Rows[i][3].ToString() + "不是有效的格式");
                        }
                        else
                        {
                            data.Point = Convert.ToDecimal(dt.Rows[i][3].ToString());
                        }
                        decimal ratio;
                        if (!string.IsNullOrEmpty(dt.Rows[i][4].ToString()))
                        {
                            if (!Decimal.TryParse(dt.Rows[i][4].ToString(), out ratio))
                            {
                                errmsg += (dt.Rows[i][4].ToString() + "不是有效的格式");
                            }
                            else
                            {
                                data.Ratio = Convert.ToDecimal(dt.Rows[i][4].ToString());
                            }
                        }
                        DateTime date;
                        if (!string.IsNullOrEmpty(dt.Rows[i][5].ToString()))
                        {
                            if (!DateTime.TryParse(dt.Rows[i][5].ToString(), out date))
                            {
                                errmsg += (dt.Rows[i][5].ToString() + "不是有效的日期格式");
                            }
                            else
                            {
                                data.PointExpiredDate = Convert.ToDateTime(dt.Rows[i][5].ToString());
                            }
                        }

                        if (string.IsNullOrEmpty(errmsg))
                        {
                            dao.InsertProInitPointFlowDetail(data);
                        }

                    }

                    result = true;
                    trans.Complete();
                }
            }
            catch
            {

            }
            System.Diagnostics.Debug.WriteLine("Import Finish : " + DateTime.Now.ToString());

            return result;

        }

        public void GetInitPointEWorkFlowHtml(int flowid)
        {
            using (GiftMaintainDao dao = new GiftMaintainDao())
            {
                dao.GetInitPointEWorkFlowHtml(flowid);
            }
        }

        public void DeleteDraft(string flowid)
        {
            using (GiftMaintainDao dao = new GiftMaintainDao())
            {
                dao.DeleteDraft(flowid);
            }
        }

        public void SendEWorkflow(int flowid)
        {
            if ("1" != SR.CONST_DMS_DEVELOP)
            {
                EwfService.WfAction wfAction = new EwfService.WfAction();
                wfAction.Credentials = new NetworkCredential(SR.CONST_EWF_USER_NAME, SR.CONST_EWF_USER_PWD, SR.CONST_EWF_DOMAIN);

                string template = WorkflowTemplate.PromotionInitPointTemplate.Clone().ToString();
                string bu = "";
                string totalamout = "";
                string userAccount = "";
                string markettype = "";

                GiftMaintainDao dao = new GiftMaintainDao();
                DataSet ds = dao.GetInitialPoints(flowid.ToString());

                using (ProPolicyDao dao2 = new ProPolicyDao())
                {
                    userAccount = dao2.QueryEWorkflowAccount(_context.User.LoginId);
                }
                totalamout = dao.GetTotalPointByFlowId(ds.Tables[0].Rows[0]["FlowId"].ToString());
                bu = dao.GetBUCodeByProductLineId(ds.Tables[0].Rows[0]["BU"].ToString()).Tables[0].Rows[0]["DivisionCode"].ToString();
                markettype = ds.Tables[0].Rows[0]["MarketType"].ToString();
                template = string.Format(template, SR.CONST_INIT_POINT_NO, userAccount, userAccount, DateTime.Now.ToString("yyyy-MM-dd"), bu, ds.Tables[0].Rows[0]["PointType"].ToString(), totalamout, flowid, ds.Tables[0].Rows[0]["HtmlStr"].ToString(), markettype);

                wfAction.StartInstanceXml(template, SR.CONST_EWF_WEB_PWD);

                this.InsertPurchaseOrderLog(ds.Tables[0].Rows[0]["FlowId"].ToString(), new Guid(this._context.User.Id), template);
            }
        }

        public void InsertPurchaseOrderLog(string flowId, Guid userId, string operNote)
        {
            using (PurchaseOrderLogDao dao = new PurchaseOrderLogDao())
            {
                PurchaseOrderLog log = new PurchaseOrderLog();
                log.Id = Guid.NewGuid();
                log.PohId = Guid.NewGuid();
                log.OperUser = userId;
                log.OperDate = DateTime.Now;
                log.OperType = "InitPoint:" + flowId;
                log.OperNote = operNote;
                dao.Insert(log);
            }
        }

        public void DeleteInitPointUPN(Hashtable obj)
        {
            using (GiftMaintainDao dao = new GiftMaintainDao())
            {
                dao.DeleteInitPointUPN(obj);
            }
        }

        public int AddInitPointUPN(Hashtable obj)
        {
            using (GiftMaintainDao dao = new GiftMaintainDao())
            {
                return dao.AddInitPointUPN(obj);
            }
        }

        public DataSet SelectUseRangeCondition(Hashtable obj, int start, int limit, out int totalCount)
        {
            using (GiftMaintainDao dao = new GiftMaintainDao())
            {
                return dao.SelectUseRangeCondition(obj, start, limit, out totalCount);
            }
        }

        public DataSet QueryUseRangeSeleted(Hashtable obj, int start, int limit, out int totalCount)
        {
            using (GiftMaintainDao dao = new GiftMaintainDao())
            {
                return dao.SelectUseRangeSeleted(obj, start, limit, out totalCount);
            }
        }
        public DataSet QueryUseRangeSeleted(Hashtable obj)
        {
            using (GiftMaintainDao dao = new GiftMaintainDao())
            {
                return dao.SelectUseRangeSeleted(obj);
            }
        }

        public void SubmintPolicySettlement(Hashtable obj)
        {
            using (GiftMaintainDao dao = new GiftMaintainDao())
            {
                dao.SubmintPolicySettlement(obj);
            }
        }

        public int AddInitPointProductType(Hashtable obj)
        {
            using (GiftMaintainDao dao = new GiftMaintainDao())
            {
                return dao.AddInitPointProductType(obj);
            }
        }

        public DataSet InitialPointAttachment(Hashtable obj, int start, int limit, out int totalCount)
        {
            using (GiftMaintainDao dao = new GiftMaintainDao())
            {
                return dao.InitialPointAttachment(obj, start, limit, out totalCount);
            }
        }

        public void DeleteInitPoint(Hashtable obj)
        {
            using (GiftMaintainDao dao = new GiftMaintainDao())
            {
                dao.DeleteInitPoint(obj);
            }
        }

        public void SendEKPEWorkflow(ProInitPointFlow flowMain)
        {
            string dealerName = "";
            string productBu = "";
            GiftMaintainDao dao = new GiftMaintainDao();
            dealerName = dao.GetPromotionInitPointSubDealer(flowMain.FlowId.ToString());
            productBu = dao.GetPromotionInitPointBUName(flowMain.FlowId.ToString());
            ekpBll.DoSubmit(_context.User.LoginId, flowMain.Instanceid.ToString(), flowMain.FlowNo, "IntegralImport", string.Format("{0} {1} 积分赠送({2})", flowMain.FlowNo, dealerName, productBu), EkpModelId.IntegralImport.ToString(), EkpTemplateFormId.IntegralImportTemplate.ToString());
        }

        public string GetTotalPointByFlowId(string FlowId)
        {
            using (GiftMaintainDao dao = new GiftMaintainDao())
            {
                return dao.GetTotalPointByFlowId(FlowId);
            }
        }

        public DataSet GetImportPoint(string FlowId)
        {
            using (GiftMaintainDao dao = new GiftMaintainDao())
            {
                return dao.GetImportPoint(FlowId);
            }
        }

        #endregion
    }
}

