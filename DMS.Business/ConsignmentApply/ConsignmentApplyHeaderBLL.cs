using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DMS.DataAccess;
using DMS.Model;
using DMS.Model.Data;
using DMS.Common;
using System.Data;
using System.Collections;
using Grapecity.DataAccess.Transaction;
using Lafite.RoleModel.Security;
using Lafite.RoleModel.Security.Authorization;
using System.IO;
using DMS.Business.MasterData;
using System.Net;
using DMS.Business.EKPWorkflow;
using DMS.Model.EKPWorkflow;
using DMS.DataAccess.Consignment;

namespace DMS.Business
{
    public class ConsignmentApplyHeaderBLL : IConsignmentApplyHeaderBLL
    {
        private EkpWorkflowBLL ekpBll = new EkpWorkflowBLL();
        private IRoleModelContext _context = RoleModelContext.Current;

        public DataSet QueryConsignmentApplyHeaderDealer(Hashtable table, int start, int limit, out int totalRowCount)
        {
            table.Add("OwnerIdentityType", this._context.User.IdentityType);
            table.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            table.Add("OwnerId", new Guid(this._context.User.Id));
            using (ConsignmentApplyHeaderDao dao = new ConsignmentApplyHeaderDao())
            {
                DataSet ds = dao.QueryConsignmentApplyHeaderDealer(table, start, limit, out totalRowCount);
                return ds;
            }
        }
        public ConsignmentApplyHeader GetConsignmentApplyHeaderSing(Guid id)
        {
            using (ConsignmentApplyHeaderDao dao = new ConsignmentApplyHeaderDao())
            {
                ConsignmentApplyHeader obj = dao.GetObject(id);
                return obj;
            }
        }
        public void AddHeader(ConsignmentApplyHeader header)
        {

            using (ConsignmentApplyHeaderDao dao = new ConsignmentApplyHeaderDao())
            {
                dao.Insert(header);

            }

        }
        /// <summary>
        /// 记录订单操作
        /// </summary>
        /// <param name="header"></param>
        /// <returns></returns>
        public void InsertPurchaseOrderLog(Guid headerId, Guid userId, ConsignmentOrderType operType, string operNote)
        {
            using (PurchaseOrderLogDao dao = new PurchaseOrderLogDao())
            {
                PurchaseOrderLog log = new PurchaseOrderLog();
                log.Id = Guid.NewGuid();
                log.PohId = headerId;
                log.OperUser = userId;
                log.OperDate = DateTime.Now;
                log.OperType = operType.ToString();
                log.OperNote = operNote;
                dao.Insert(log);
            }
        }
        public bool SaveDraft(ConsignmentApplyHeader header)
        {
            bool resur = false;

            using (ConsignmentApplyHeaderDao dao = new ConsignmentApplyHeaderDao())
            {
                ConsignmentApplyHeader hd = dao.GetObject(header.Id);
                if (hd.OrderStatus == ConsignmentOrderType.Draft.ToString())
                {
                    dao.Update(header);
                    resur = true;
                }


            }
            return resur;
        }

        public bool Sumbit(ConsignmentApplyHeader header, out string resMsg)
        {
            bool resur = false;
            try
            {
                using (ConsignmentApplyHeaderDao dao = new ConsignmentApplyHeaderDao())
                {
                    resMsg = "";
                    ConsignmentApplyHeader hd = dao.GetObject(header.Id);
                    if (hd.OrderStatus == ConsignmentOrderType.Draft.ToString())
                    {
                        string rtnVal = string.Empty;
                        string rtnMsg = string.Empty;
                        string userAccount = string.Empty;
                        decimal totalAmount = 0;

                        DataSet ds = dao.GetSaleInfoByFilter(header.SalesName, header.SalesEmail);

                        if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                        {
                            userAccount = ds.Tables[0].Rows[0]["Code"] != null ? ds.Tables[0].Rows[0]["Code"].ToString() : "";
                        }

                        if (string.IsNullOrEmpty(userAccount))
                        {
                            resMsg = "波科销售不存在";
                            return false;
                        }

                        //如果订单号不存在那么生成新的订单号（防止重复提交后会提交生成新的订单号）
                        if (string.IsNullOrEmpty(header.OrderNo))
                        {
                            AutoNumberBLL autoNbr = new AutoNumberBLL();
                            string orderNo = autoNbr.GetNextAutoNumberForPO(header.DmaId.Value, OrderType.Next_PurchaseOrder, header.ProductLineId.Value, PurchaseOrderType.Consignment.ToString());
                            header.OrderNo = string.Format("{0}{1}{2}", "R", orderNo, "ST");
                        }

                        dao.Update(header);
                        /*创建订单*/
                        //ConsignCommonDao consignDao = new ConsignCommonDao();
                        //string RtnVal = "";
                        //string RtnMsg = "";
                        //consignDao.ProcConsignPurchaseOrderCreate("KB", "ConsignmentApply", header.OrderNo,"1",out RtnVal,out RtnMsg);
                        //if  (!RtnVal.Equals("Success")) throw new Exception(RtnMsg);

                        //记录操作日志
                        //this.InsertPurchaseOrderLog(header.Id, new Guid(this._context.User.Id), ConsignmentOrderType.Approved, "提交订单");

                        //如果为开发环境则不会调用接口

                        IConsignmentApplyDetailsBLL DtBll = new ConsignmentApplyDetailsBLL();
                        DataSet sumds = DtBll.SelecConsignmentApplyDetailsCfnSum(header.Id.ToString());
                        if (sumds.Tables[0].Rows.Count > 0)
                        {
                            totalAmount = sumds.Tables[0].Rows[0]["Pricesum"] == DBNull.Value ? 0 : decimal.Parse(sumds.Tables[0].Rows[0]["Pricesum"].ToString());
                        }

                        kmReviewWebserviceBLL ekpBll = new kmReviewWebserviceBLL();
                        string templateId = DictionaryHelper.GetDictionaryNameById("CONST_TemplateId", "Consignment");
                        if (string.IsNullOrEmpty(templateId))
                        {
                            throw new Exception("OA流程ID未配置！");
                        }
                        ekpBll.DoSubmit(userAccount, header.Id.ToString(), header.OrderNo, "Consignment", string.Format("{0} {1}经销商寄售", header.OrderNo, Cache.DealerCacheHelper.GetDealerById(header.DmaId.Value).ChineseName)
                            , EkpModelId.Consignment.ToString(), EkpTemplateFormId.ConsignmentTemplate.ToString(), templateId);


                        resur = true;

                        //if ("1" != SR.CONST_DMS_DEVELOP)
                        //{
                        //    EwfService.WfAction wfAction = new EwfService.WfAction();
                        //    wfAction.Credentials = new NetworkCredential(SR.CONST_EWF_USER_NAME, SR.CONST_EWF_USER_PWD, SR.CONST_EWF_DOMAIN);

                        //    string template = WorkflowTemplate.ConsignmentTemplate.Clone().ToString();

                        //    bool result = GetApplyOrderHtml(header.Id, out rtnVal, out rtnMsg);
                        //    if (result)
                        //    {
                        //        template = string.Format(template, SR.CONST_CONSIGNMENT_FLOWNO, userAccount, userAccount, "", header.OrderNo, "1", header.CmConsignmentDay, rtnMsg, totalAmount);

                        //        wfAction.StartInstanceXml(template, SR.CONST_EWF_WEB_PWD);

                        //        this.GetConsignmentApplyMail(header);

                        //        resur = true;
                        //    }
                        //    else
                        //    {
                        //        resMsg = "接口调用失败";
                        //        resur = false;
                        //    }
                        //}
                        //else
                        //{
                        //    //this.GetConsignmentApplyMail(header);
                        //    resur = true;
                        //}
                    }
                }
            }
            catch (Exception ex)
            {
                //若提交失败，那么自动将单据状态还原为“草稿”
                //接口成功同步到Ewf后，Ewf会调用DMS存储过程将草稿状态的单据置为“提交”，防止由于网络延迟而造成的错误
                using (ConsignmentApplyHeaderDao dao = new ConsignmentApplyHeaderDao())
                {
                    header.OrderStatus = ConsignmentOrderType.Draft.ToString();
                    dao.UpdateConsignmentApplyHeaderOrderStatus(header);
                }
                resMsg = "提交失败";
                resur = false;
                throw ex;
            }

            return resur;
        }
        /// <summary>
        /// 删除草稿
        /// </summary>
        /// <param name="headid"></param>
        /// <returns></returns>
        public bool DeltetDraft(Guid headid)
        {
            bool result = false;
            using (ConsignmentApplyHeaderDao dao = new ConsignmentApplyHeaderDao())
            {
                ConsignmentApplyHeader header = null;
                header = dao.GetObject(headid);
                if (header.OrderStatus == ConsignmentOrderType.Draft.ToString())//判断订单状态是否改变
                {
                    using (ConsignmentApplyDetailsDao ddao = new ConsignmentApplyDetailsDao())
                    {
                        ///删除明细表
                        ddao.DeleteHeaderConsignmentApplyDetails(headid);
                        ///删除主表
                        dao.Delete(headid);
                        ///删除日志表
                        PurchaseOrderLogDao logDao = new PurchaseOrderLogDao();
                        logDao.DeletePurchaseOrderLogByHeaderId(headid);
                        result = true;

                    }
                }
                return result;
            }
        }
        public DataSet GetDealerSale(string code)
        {


            using (ConsignmentApplyHeaderDao dao = new ConsignmentApplyHeaderDao())
            {
                DataSet ds = dao.GetProductLineVsDealerSale(code);
                return ds;
            }
        }
        public DataSet GetDealerSaleByPL(string PL, string DmaId)
        {


            using (ConsignmentApplyHeaderDao dao = new ConsignmentApplyHeaderDao())
            {
                DataSet ds = dao.GetDealerSaleByPL(PL, DmaId);
                return ds;
            }
        }
        public DataSet GetProductLineVsDivisionCode(string ProductLineId)
        {
            using (ConsignmentApplyHeaderDao dao = new ConsignmentApplyHeaderDao())
            {
                DataSet ds = dao.GetProductLineVsDivisionCode(ProductLineId);
                return ds;
            }
        }
        public DataSet QueryInventoryAdjustHeaderList(Hashtable table, int start, int limit, out int totalRowCount)
        {
            using (ConsignmentApplyHeaderDao dao = new ConsignmentApplyHeaderDao())
            {
                DataSet ds = dao.QueryInventoryAdjustHeaderList(table, start, limit, out totalRowCount);
                return ds;
            }
        }
        public DataSet QueryInventoryAdjustCfnList(string Id, int start, int limit, out int totalRowCount)
        {
            using (ConsignmentApplyHeaderDao dao = new ConsignmentApplyHeaderDao())
            {
                DataSet ds = dao.QueryInventoryAdjustCfnList(Id, start, limit, out totalRowCount);
                return ds;
            }
        }

        public bool SetDelayStatus(ConsignmentApplyHeader header, out string resMsg)
        {
            bool result = false;

            try
            {
                resMsg = "";
                decimal totalAmount = 0;
                using (ConsignmentApplyHeaderDao dao = new ConsignmentApplyHeaderDao())
                {
                    string rtnVal = string.Empty;
                    string rtnMsg = string.Empty;

                    string userAccount = string.Empty;

                    DataSet ds = dao.GetSaleInfoByFilter(header.SalesName, header.SalesEmail);

                    if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                    {
                        userAccount = ds.Tables[0].Rows[0]["UserDomainName"] != null ? ds.Tables[0].Rows[0]["UserDomainName"].ToString() : "";
                    }

                    if (string.IsNullOrEmpty(userAccount))
                    {
                        resMsg = "波科销售不存在";
                        return false;
                    }

                    //Added By Song Yuqi For EKP Consignment Delay Apply
                    //延期申请，自动创建新的延期申请Id
                    header.CahId = Guid.NewGuid();

                    dao.Update(header);
                    //记录操作日志
                    this.InsertPurchaseOrderLog(header.Id, new Guid(this._context.User.Id), ConsignmentOrderType.Submitted, "申请延期");

                    //如果为开发环境则不会调用接口
                    DataSet pricds = SelecPOReceiptPriceSum(header.Id.ToString());
                    if (pricds.Tables[0].Rows.Count > 0)
                    {
                        totalAmount = pricds.Tables[0].Rows[0]["TotalAmount"] == DBNull.Value ? 0 : decimal.Parse(pricds.Tables[0].Rows[0]["TotalAmount"].ToString());
                    }

                    EkpWorkflowBLL ekpBll = new EkpWorkflowBLL();

                    ekpBll.DoSubmitForConsignmentDelayApply(userAccount, header.CahId.Value.ToString(), header.Id.ToString(), header.OrderNo, "Consignment", string.Format("{0} {1}经销商寄售", header.OrderNo, Cache.DealerCacheHelper.GetDealerById(header.DmaId.Value).ChineseName)
                        , EkpModelId.Consignment.ToString(), EkpTemplateFormId.ConsignmentTemplate.ToString());

                    result = true;

                    //if ("1" != SR.CONST_DMS_DEVELOP)
                    //{
                    //    EwfService.WfAction wfAction = new EwfService.WfAction();
                    //    wfAction.Credentials = new NetworkCredential(SR.CONST_EWF_USER_NAME, SR.CONST_EWF_USER_PWD, SR.CONST_EWF_DOMAIN);

                    //    string template = WorkflowTemplate.ConsignmentTemplate.Clone().ToString();

                    //    bool flag = GetApplyOrderDelayHtml(header.Id, out rtnVal, out rtnMsg);
                    //    if (flag)
                    //    {
                    //        template = string.Format(template, SR.CONST_CONSIGNMENT_FLOWNO, userAccount, userAccount, "", header.OrderNo, "2",header.CmConsignmentDay, rtnMsg, totalAmount);

                    //        wfAction.StartInstanceXml(template, SR.CONST_EWF_WEB_PWD);
                    //        GetConsignmentApplyMailDelay(header);
                    //        resMsg = "提交失败";
                    //        result = true;
                    //    }
                    //    else
                    //    {
                    //        result = false;
                    //    }
                    //}
                    //else
                    //{
                    //    result = true;
                    //}
                }
            }
            catch (Exception ex)
            {
                //若提交失败，那么自动将单据状态还原为“空”
                //接口成功同步到Ewf后，Ewf会调用DMS存储过程将草稿状态的单据置为“提交”，防止由于网络延迟而造成的错误
                using (ConsignmentApplyHeaderDao dao = new ConsignmentApplyHeaderDao())
                {
                    header.DelayOrderStatus = string.Empty;
                    dao.UpdateConsignmentApplyHeaderDelayOrderStatus(header);
                }
                resMsg = "提交失败";
                result = false;
                throw ex;
            }

            return result;
        }

        /// <summary>
        /// 查询寄售产品追踪汇总信息
        /// </summary>
        /// <param name="Id"></param>
        /// <param name="RtnVal"></param>
        /// <param name="RtnMsg"></param>
        /// <returns></returns>
        public DataSet QueryConsignmentTrackByOrderId(Guid Id, out string RtnVal, out string RtnMsg)
        {
            using (ConsignmentApplyHeaderDao dao = new ConsignmentApplyHeaderDao())
            {
                return dao.QueryConsignmentTrackByOrderId(Id, out RtnVal, out RtnMsg);
            }
        }


        public bool GetApplyOrderHtml(Guid headerId, out string rtnVal, out string rtnMsg)
        {
            bool result = false;
            using (ConsignmentApplyDetailsDao dao = new ConsignmentApplyDetailsDao())
            {
                DataSet ds = dao.GC_GetApplyOrderHtml(headerId, "Id", "V_ConsignmentApplyForm", "Id", "V_ConsignmentApplyTable", out rtnVal, out rtnMsg);

                if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                {
                    rtnVal = "Success";
                    rtnMsg = ds.Tables[0].Rows[0]["HtmlStr"] != null ? ds.Tables[0].Rows[0]["HtmlStr"].ToString() : "";
                    result = true;
                }
                else
                {
                    rtnVal = "Failure";
                    result = false;
                }
            }
            return result;
        }

        public bool GetApplyOrderDelayHtml(Guid headerId, out string rtnVal, out string rtnMsg)
        {
            bool result = false;
            using (ConsignmentApplyDetailsDao dao = new ConsignmentApplyDetailsDao())
            {
                DataSet ds = dao.GC_GetConsignmentDelayApplyOrderHtml(headerId, "Id", "V_ConsignmentDelayApplyForm", "", "", out rtnVal, out rtnMsg);

                if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                {
                    rtnVal = "Success";
                    rtnMsg = ds.Tables[0].Rows[0]["HtmlStr"] != null ? ds.Tables[0].Rows[0]["HtmlStr"].ToString() : "";
                    result = true;
                }
                else
                {
                    rtnVal = "Failure";
                    result = false;
                }
            }
            return result;
        }
        public DataSet SelecPOReceiptPriceSum(string CAID)
        {
            using (ConsignmentApplyHeaderDao dao = new ConsignmentApplyHeaderDao())
            {
                DataSet ds = dao.SelecPOReceiptPriceSum(CAID);
                return ds;
            }
        }
        public bool GetConsignmentApplyMailDelay(ConsignmentApplyHeader header)
        {
            bool result = false;
            StringBuilder sb = new StringBuilder();
            MessageBLL msgBll = new MessageBLL();
            using (ConsignmentApplyDetailsDao detailDao = new ConsignmentApplyDetailsDao())
            {
                Dictionary<String, String> dictMailSubject = new Dictionary<String, String>();
                Dictionary<String, String> dictMailBody = new Dictionary<String, String>();
                dictMailSubject.Add("DealerName", this._context.User.CorpName);
                dictMailSubject.Add("OrderNo", header.OrderNo);

                dictMailBody.Add("SubmitDate", header.SubmitDate.Value.ToString());
                dictMailBody.Add("DealerName", this._context.User.CorpName);
                dictMailBody.Add("OrderNo", header.OrderNo);
                msgBll.AddToMailMessageQueue(MailMessageTemplateCode.EMAIL_DEALER_COMSIGNMENTAPPLY_DELAY, dictMailSubject, dictMailBody, header.SalesEmail);
            }
            return result;
        }
        public bool GetConsignmentApplyMail(ConsignmentApplyHeader header)
        {
            bool result = false;
            StringBuilder sb = new StringBuilder();
            MessageBLL msgBll = new MessageBLL();

            using (ConsignmentApplyDetailsDao detailDao = new ConsignmentApplyDetailsDao())
            {
                Dictionary<String, String> dictMailSubject = new Dictionary<String, String>();
                Dictionary<String, String> dictMailBody = new Dictionary<String, String>();
                dictMailSubject.Add("DealerName", this._context.User.CorpName);
                dictMailSubject.Add("OrderNo", header.OrderNo);

                dictMailBody.Add("SubmitDate", header.SubmitDate.Value.ToString());
                dictMailBody.Add("DealerName", this._context.User.CorpName);
                dictMailBody.Add("OrderNo", header.OrderNo);

                Hashtable table = new Hashtable();
                table.Add("CAH_ID", header.Id);

                DataSet ds = detailDao.SelectConsignmentApplyProList(table);
                sb.Append("<TR>");
                sb.Append("<TD style=\"BACKGROUND: #ccfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt\">");
                sb.Append("<STRONG><SPAN style=\"FONT-FAMILY: 宋体\">产品型号</SPAN></STRONG>");
                sb.Append("</TD>");
                sb.Append("<TD style=\"BACKGROUND: #ccfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt\">");
                sb.Append("<STRONG><SPAN style=\"FONT-FAMILY: 宋体\">批次号</SPAN></STRONG>");
                sb.Append("</TD>");
                sb.Append("<TD style=\"BACKGROUND: #ccfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt\">");
                sb.Append("<STRONG><SPAN style=\"FONT-FAMILY: 宋体\">数量</SPAN></STRONG>");
                sb.Append("</TD>");
                sb.Append("<TD style=\"BACKGROUND: #ccfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt\">");
                sb.Append("<STRONG><SPAN style=\"FONT-FAMILY: 宋体\">单位</SPAN></STRONG>");
                sb.Append("</TD>");
                sb.Append("</TR>");

                foreach (DataRow row in ds.Tables[0].Rows)
                {
                    sb.Append("<tr>");
                    sb.Append("<td style=\"BACKGROUND: #fcfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt\">");
                    sb.Append(row["CustomerFaceNbr"].ToString());
                    sb.Append("</td>");
                    sb.Append("<td style=\"BACKGROUND: #fcfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt\">");
                    sb.Append(row["LotNumber"].ToString());
                    sb.Append("</td>");
                    sb.Append("<td style=\"BACKGROUND: #fcfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt\">");
                    sb.Append(row["Qty"].ToString());
                    sb.Append("</td>");
                    sb.Append("<td style=\"BACKGROUND: #fcfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt\">");
                    sb.Append(row["UOM"].ToString());
                    sb.Append("</td>");
                    sb.Append("</tr>");
                }

                dictMailBody.Add("CfnList", sb.ToString());

                msgBll.AddToMailMessageQueue(MailMessageTemplateCode.EMAIL_DEALER_COMSIGNMENTAPPLY_SUBMIT, dictMailSubject, dictMailBody, header.SalesEmail);
            }
            return result;
        }
        public DataSet SelectHospitSale(string hospitId, string DivisionID)
        {
            using (ConsignmentApplyHeaderDao dao = new ConsignmentApplyHeaderDao())
            {
                DataSet ds = dao.SelectHospitSale(hospitId, DivisionID);
                return ds;
            }

        }
        public bool SelectSalesSing(string Name, string Email)
        {
            using (ConsignmentApplyHeaderDao dao = new ConsignmentApplyHeaderDao())
            {
                bool bl = dao.SelectSalesSing(Name, Email);
                return bl;
            }
        }
        public DataSet SelectConsignmentApplyProSumList(Guid id, int start, int limit, out int totalRowCount)
        {
            using (ConsignmentApplyHeaderDao dao = new ConsignmentApplyHeaderDao())
            {
                DataSet ds = dao.QueryConsignmentApplyProSumList(id.ToString(), start, limit, out totalRowCount);
                return ds;
            }
        }
        public DataSet SelectConsignmentApplyInitList(int start, int limit, out int totalRowCount)
        {
            using (ConsignmentApplyHeaderDao dao = new ConsignmentApplyHeaderDao())
            {
                DataSet ds = dao.SelectConsignmentApplyInitList(_context.User.Id.ToString(), start, limit, out totalRowCount);
                return ds;
            }
        }
        public bool Import(DataTable dt, string fileName)
        {
            System.Diagnostics.Debug.WriteLine("Import Start : " + DateTime.Now.ToString());
            bool result = false;
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    ConsignmentApplyHeaderDao dao = new ConsignmentApplyHeaderDao();
                    //删除上传人的数据
                    dao.DeleteApplyInitByUser(new Guid(_context.User.Id));

                    int lineNbr = 1;
                    IList<ConsignmentApplyInit> list = new List<ConsignmentApplyInit>();
                    foreach (DataRow dr in dt.Rows)
                    {
                        //string errString = string.Empty;
                        ConsignmentApplyInit data = new ConsignmentApplyInit();
                        data.Id = Guid.NewGuid().ToString();
                        data.InputUserId = _context.User.Id;
                        data.InputDate = DateTime.Now;

                        //Dealersap
                        data.Dealersap = dr[0] == DBNull.Value ? null : dr[0].ToString();

                        //ProductLine
                        data.ProductLineName = dr[2] == DBNull.Value ? null : dr[2].ToString();

                        //HospitalName
                        data.HospitalName = dr[3] == DBNull.Value ? null : dr[3].ToString();

                        //Upn
                        data.Upn = dr[4] == DBNull.Value ? null : dr[4].ToString();

                        //Qty
                        decimal qtyinput = 0;
                        decimal qty;
                        if (dr[5] != DBNull.Value && Decimal.TryParse(dr[5].ToString(), out qty))
                        {
                            qtyinput = Convert.ToDecimal(dr[5].ToString());
                        }
                        data.Qty = qtyinput;

                        //寄售合同编号
                        data.CchNo = dr[6] == DBNull.Value ? null : dr[6].ToString();

                        data.LineNbr = lineNbr++;

                        if (data.LineNbr != 1)
                        {
                            list.Add(data);
                        }
                    }
                    dao.ConsignmentApplyInit(list);
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

        public bool VerifyConsignmentApplyInit(string IsImport, out string IsValid)
        {
            System.Diagnostics.Debug.WriteLine("Verify Start : " + DateTime.Now.ToString());
            bool result = false;
            //调用存储过程验证数据
            using (ConsignmentApplyHeaderDao dao = new ConsignmentApplyHeaderDao())
            {
                Hashtable ht = new Hashtable();
                BaseService.AddCommonFilterCondition(ht);
                IsValid = dao.Initialize(IsImport, new Guid(_context.User.Id), Convert.ToString(ht["SubCompanyId"]), Convert.ToString(ht["BrandId"]));
                result = true;
            }
            System.Diagnostics.Debug.WriteLine("Verify Finish : " + DateTime.Now.ToString());
            return result;
        }

        public DataSet SelectConsignmentTransferInitList(int start, int limit, out int totalRowCount)
        {
            using (ConsignmentTransferInitDao dao = new ConsignmentTransferInitDao())
            {
                DataSet ds = dao.SelectConsignmentTransferInitList(_context.User.Id.ToString(), start, limit, out totalRowCount);
                return ds;
            }
        }

        public bool ImportTransfer(DataTable dt, string fileName)
        {
            System.Diagnostics.Debug.WriteLine("Import Start : " + DateTime.Now.ToString());
            bool result = false;
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    ConsignmentTransferInitDao dao = new ConsignmentTransferInitDao();
                    //删除上传人的数据
                    dao.DeleteTransferInitByUser(_context.User.Id);

                    int lineNbr = 1;
                    IList<ConsignmentTransferInit> list = new List<ConsignmentTransferInit>();
                    foreach (DataRow dr in dt.Rows)
                    {
                        //string errString = string.Empty;
                        ConsignmentTransferInit data = new ConsignmentTransferInit();
                        data.Id = Guid.NewGuid().ToString();
                        data.InputUser = _context.User.Id;
                        data.InputDate = DateTime.Now;
                        data.ErrFlg = 0;

                        //DealerCodeTo
                        data.DealerCodeTo = dr[0] == DBNull.Value ? null : dr[0].ToString();
                        data.DealerCodeFrom = dr[2] == DBNull.Value ? null : dr[2].ToString();
                        data.ProductLineName = dr[4] == DBNull.Value ? null : dr[4].ToString();
                        data.Upn = dr[5] == DBNull.Value ? null : dr[5].ToString();
                        //Qty
                        int qtyinput = 0;
                        int qty;
                        if (dr[6] != DBNull.Value && Int32.TryParse(dr[6].ToString(), out qty))
                        {
                            qtyinput = Convert.ToInt32(dr[6].ToString());
                        }
                        data.Qty = qtyinput;

                        //HospitalName
                        data.HospitalCode = dr[7] == DBNull.Value ? null : dr[7].ToString();

                        //ProductLine
                        data.ContractNo = dr[8] == DBNull.Value ? null : dr[8].ToString();

                        data.LineNbr = lineNbr++;

                        if (data.LineNbr != 1)
                        {
                            list.Add(data);
                        }
                    }
                    dao.ConsignmentTransferInit(list);
                    result = true;

                    trans.Complete();
                }
            }
            catch (Exception ex)
            {

            }
            System.Diagnostics.Debug.WriteLine("Import Finish : " + DateTime.Now.ToString());

            return result;
        }

        public bool VerifyConsignmentTransferInit(string IsImport, out string IsValid)
        {
            System.Diagnostics.Debug.WriteLine("Verify Start : " + DateTime.Now.ToString());
            bool result = false;
            //调用存储过程验证数据
            Hashtable ht = new Hashtable();
            BaseService.AddCommonFilterCondition(ht);
            using (ConsignmentTransferInitDao dao = new ConsignmentTransferInitDao())
            {
                Guid SubCompanyId = string.IsNullOrEmpty(Convert.ToString(ht["SubCompanyId"])) ? Guid.Empty : new Guid(ht["SubCompanyId"].ToString());
                Guid BrandId = string.IsNullOrEmpty(Convert.ToString(ht["BrandId"])) ? Guid.Empty : new Guid(ht["BrandId"].ToString());
                IsValid = dao.Initialize(IsImport, new Guid(_context.User.Id), SubCompanyId, BrandId);
                result = true;
            }
            System.Diagnostics.Debug.WriteLine("Verify Finish : " + DateTime.Now.ToString());
            return result;
        }
        public int ConsignmentTransferDelete(string id)
        {
            using (ConsignmentTransferInitDao dao = new ConsignmentTransferInitDao())
            {
                return dao.Delete(id);
            }
        }
    }
}