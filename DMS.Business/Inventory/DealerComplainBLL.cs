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
using System.Web;
using System.Xml;
using DMS.Business.MasterData;
using DMS.Model.DataInterface;
using DMS.Model.EKPWorkflow;
using DMS.Business.EKPWorkflow;
using DMS.Model.ViewModel.InventoryReturn;
using DMS.Common.Common;
using DMS.Common.Office;

namespace DMS.Business
{
    public class DealerComplainBLL : IDealerComplainBLL
    {
        private IRoleModelContext _context = RoleModelContext.Current;
        private IClientBLL _clientBLL = new ClientBLL();
        private EkpWorkflowBLL ekpBll = new EkpWorkflowBLL();
        private IMessageBLL _messageBLL = new MessageBLL();
        private IContractMasterBLL _contractBll = new ContractMasterBLL();
        private IDealerMasters _dealers = new DealerMasters();
        private ICfns _cfns = new Cfns();

        public string DealerComplainSave(Hashtable dealerComplainInfo)
        {
            using (DealerComplainDao dao = new DealerComplainDao())
            {
                return dao.GC_DealerComplain_Save(dealerComplainInfo);
            }
        }

        public DataSet DealerComplainQuery(Hashtable condition, int start, int limit, out int totalRowCount)
        {
            //获取当前登录身份类型以及所属组织
            condition.Add("OwnerIdentityType", this._context.User.IdentityType);
            condition.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            condition.Add("OwnerId", new Guid(this._context.User.Id));
            condition.Add("OwnerCorpId", this._context.User.CorpId);

            using (DealerComplainDao dao = new DealerComplainDao())
            {
                return dao.SelectDealerComplainByHashtable(condition, start, limit, out totalRowCount);
            }
        }

        public DataTable DealerComplainInfo(Hashtable condition)
        {
            using (DealerComplainDao dao = new DealerComplainDao())
            {
                return dao.GC_DealerComplain_Info(condition).Tables[0];
            }
        }

        public DataTable DealerComplainInfo_SpecialDateFormat(Hashtable condition)
        {
            using (DealerComplainDao dao = new DealerComplainDao())
            {
                return dao.GC_DealerComplain_Info_SpecialDateFormat(condition).Tables[0];
            }
        }

        public DataSet GetDealerComplainUPN(Hashtable condition)
        {
            BaseService.AddCommonFilterCondition(condition);
            using (DealerComplainDao dao = new DealerComplainDao())
            {
                return dao.SelectDealerComplainUPN(condition);
            }
        }

        public void DealerComplainCancel(Hashtable condition)
        {
            using (DealerComplainDao dao = new DealerComplainDao())
            {
                dao.UpdateDealerComplainCancel(condition);
            }
        }

        public void DealerComplainConfirm(Hashtable condition)
        {
            BaseService.AddCommonFilterCondition(condition);
            using (DealerComplainDao dao = new DealerComplainDao())
            {
                dao.UpdateDealerComplainConfirm(condition);
            }
        }

        public void UpdateBSCCarrierNumber(Hashtable condition)
        {
            BaseService.AddCommonFilterCondition(condition);
            using (DealerComplainDao dao = new DealerComplainDao())
            {
                dao.UpdateBSCCarrierNumber(condition);
            }
        }

        //对信息进行校验，然后获取错误信息，及返回的产品信息
        public void CheckUPNAndDate(Hashtable condition, out string rtnVal, out string rtnMsg)
        {
            using (DealerComplainDao dao = new DealerComplainDao())
            {
                dao.CheckUPNAndDate(condition, out rtnVal, out rtnMsg);
            }

        }

        //对信息进行校验，然后获取错误信息，及返回的产品信息
        public void CheckUPNAndDateCRM(Hashtable condition, out string rtnVal, out string rtnMsg)
        {
            using (DealerComplainDao dao = new DealerComplainDao())
            {
                dao.CheckUPNAndDateCRM(condition, out rtnVal, out rtnMsg);
            }
        }

        public void DealerComplainConfirmCRM(Hashtable condition)
        {
            BaseService.AddCommonFilterCondition(condition);
            using (DealerComplainDao dao = new DealerComplainDao())
            {
                dao.UpdateDealerComplainConfirmCRM(condition);
            }
        }


        public void UpdateCRMCarrierNumber(Hashtable condition)
        {
            BaseService.AddCommonFilterCondition(condition);
            using (DealerComplainDao dao = new DealerComplainDao())
            {
                dao.UpdateCRMCarrierNumber(condition);
            }
        }

        public void UpdateBSCRevoke(Hashtable condition)
        {
            BaseService.AddCommonFilterCondition(condition);
            using (DealerComplainDao dao = new DealerComplainDao())
            {
                dao.UpdateBSCRevoke(condition);
            }
        }

        public void UpdateCRMRevoke(Hashtable condition)
        {
            using (DealerComplainDao dao = new DealerComplainDao())
            {
                dao.UpdateCRMRevoke(condition);
            }
        }

        #region 投诉接口
        public int InitComplainInterfaceForLpByClientID(string clientid, string batchNbr)
        {
            using (ComplainInterfaceDao dao = new ComplainInterfaceDao())
            {
                Hashtable ht = new Hashtable();
                ht.Add("Clientid", clientid);
                ht.Add("BatchNbr", batchNbr);
                ht.Add("UpdateDate", DateTime.Now);
                return dao.InitComplainByClientID(ht);
            }
        }

        public IList<LpComplainData> QueryComplainInfoByBatchNbrForLp(string batchNbr)
        {
            using (ComplainInterfaceDao dao = new ComplainInterfaceDao())
            {
                return dao.QueryComplainInfoByBatchNbrForLp(batchNbr);
            }
        }

        //根据仓库ID查询物权所属
        public DataSet GetWarehouseTypeById(Guid obj)
        {
            using (WarehouseDao dao = new WarehouseDao())
            {
                return dao.GetWarehouseTypeById(obj);
            }
        }

        public void AfterComplainDataDownload(string BatchNbr, string ClientID, string RtnVal, out string RtnMsg)
        {
            using (ComplainInterfaceDao dao = new ComplainInterfaceDao())
            {
                dao.AfterComplainDataDownload(BatchNbr, ClientID, RtnVal, out RtnMsg);
            }
        }
        #endregion
        public DataTable DealerComplainExport(Hashtable condition)
        {
            using (DealerComplainDao dao = new DealerComplainDao())
            {
                return dao.DealerComplainExport(condition).Tables[0];
            }
        }
        public int UpdateDealerComplainStatus(Hashtable condition)
        {
            using (DealerComplainDao dao = new DealerComplainDao())
            {
                return dao.UpdateDealerComplainStatus(condition);
            }
        }
        public int UpdateDealerComplainStatusCRM(Hashtable condition)
        {
            using (DealerComplainDao dao = new DealerComplainDao())
            {
                return dao.UpdateDealerComplainStatusCRM(condition);
            }
        }
        public int UpdateDealerComplainCourier(Hashtable condition)
        {
            using (DealerComplainDao dao = new DealerComplainDao())
            {
                if (condition["ComplainType"].ToString().Equals("CNF"))
                {
                    return dao.UpdateDealerComplainCourierCNF(condition);
                }
                else
                {
                    return dao.UpdateDealerComplainCourierCRM(condition);
                }
            }
        }
        public int UpdateDealerComplainIAN(Hashtable condition)
        {
            using (DealerComplainDao dao = new DealerComplainDao())
            {
                if (condition["ComplainType"].ToString().Equals("CNF"))
                {
                    return dao.UpdateDealerComplainIANCNF(condition);
                }
                else
                {
                    return dao.UpdateDealerComplainIANCRM(condition);
                }
            }
        }

        public DataTable GetDealerComplainBscInfo(Guid Cmid)
        {
            using (DealerComplainDao dao = new DealerComplainDao())
            {
                return dao.QueryDealerComplainBscInfo(Cmid);
            }
        }

        #region Added By Song Yuqi For 经销商投诉退换货 On 2017-08-23
        public string DealerComplainSaveForNew(Hashtable dealerComplainInfo)
        {
            using (DealerComplainDao dao = new DealerComplainDao())
            {
                return dao.GC_DealerComplain_SaveForNew(dealerComplainInfo);
            }
        }

        public string DealerComplainSaveReturn(Hashtable dealerComplainInfo)
        {
            using (DealerComplainDao dao = new DealerComplainDao())
            {
                string resultValue = dao.GC_DealerComplainForReturn_Save(dealerComplainInfo);

                if (resultValue == "Success"
                    && dealerComplainInfo["ReturnStatus"].ToString() == "Submit")
                {
                    Hashtable param = new Hashtable();
                    param.Add("DC_ID", dealerComplainInfo["InstanceId"]);
                    param.Add("ComplainType", dealerComplainInfo["ComplainType"]);
                    DataTable dt = this.DealerComplainInfo(param);

                    if (dt.Rows.Count > 0)
                    {
                       /* if (dealerComplainInfo["ComplainType"].ToString() == "BSC")
                        {
                            ekpBll.DoSubmit(dt.Rows[0]["FIRSTBSCNAME"].ToString(), dealerComplainInfo["InstanceId"].ToString(), dt.Rows[0]["DC_ComplainNbr"].ToString(),
                            "DealerComplainCNF", string.Format("{0} {1}产品型号投诉退换货", dt.Rows[0]["DC_ComplainNbr"].ToString(), dt.Rows[0]["UPN"].ToString())
                            , EkpModelId.DealerComplain.ToString(), EkpTemplateFormId.DealerComplainTemplate.ToString());
                        }
                        else if (dealerComplainInfo["ComplainType"].ToString() == "CRM")
                        {
                            ekpBll.DoSubmit(dt.Rows[0]["CompletedName"].ToString(), dealerComplainInfo["InstanceId"].ToString(), dt.Rows[0]["DC_ComplainNbr"].ToString(),
                            "DealerComplainCRM", string.Format("{0} {1}产品型号投诉退换货", dt.Rows[0]["DC_ComplainNbr"].ToString(), dt.Rows[0]["Serial"].ToString())
                            , EkpModelId.DealerComplain.ToString(), EkpTemplateFormId.DealerComplainTemplate.ToString());
                        }*/
                        //添加发邮件给销售功能
                        /*Hashtable sendhash = new Hashtable();
                        sendhash.Add("DC_ID", dealerComplainInfo["InstanceId"]);
                        sendhash.Add("DC_Type", dealerComplainInfo["ComplainType"].ToString());
                        dao.SendComplainMailToBSCSales(sendhash);*/

                    }
                    else
                    {
                        throw new Exception("数据获取异常");
                    }
                }

                return resultValue;
            }
        }

        public DataSet SelectInventoryForComplainsDataSet(Hashtable table, int start, int limit, out int totalRowCount)
        {
            using (QueryInventoryDao dao = new QueryInventoryDao())
            {
                return dao.SelectInventoryForComplainsDataSet(table, start, limit, out totalRowCount);
            }
        }

        public DataSet SelectInventoryWarehouseForComplainsDataSet(Hashtable table, int start, int limit, out int totalRowCount)
        {
            BaseService.AddCommonFilterCondition(table);
            using (QueryInventoryDao dao = new QueryInventoryDao())
            {
                return dao.SelectInventoryWarehouseForComplainsDataSet(table, start, limit, out totalRowCount);
            }
        }

        public DataSet QueryDealerComplainProductSaleDate(Hashtable table)
        {
            using (QueryInventoryDao dao = new QueryInventoryDao())
            {
                return dao.QueryDealerComplainProductSaleDate(table);
            }
        }

        public DataSet SelectBscSrForComplain(Hashtable table)
        {
            using (DealerComplainDao dao = new DealerComplainDao())
            {
                return dao.SelectBscSrForComplain(table);
            }
        }

        public void UpdateDealerComplainStatusByFilter(String ComplainType, String Status, String ApprovelRemark, Guid ComplainId, DateTime LastUpdateDate, out String RtnVal, out String RtnMsg)
        {
            using (DealerComplainDao dao = new DealerComplainDao())
            {
                RtnVal = "Success";
                RtnMsg = "";

                if (this.ValidateComplainCanUpdate(ComplainType, ComplainId, LastUpdateDate))
                {
                    Hashtable table = new Hashtable();

                    table.Add("ComplainType", ComplainType);
                    table.Add("ApprovelRemark", ApprovelRemark);
                    table.Add("Status", Status);
                    table.Add("UserId", _context.User.Id);
                    table.Add("ComplainId", ComplainId);

                    dao.UpdateDealerComplainStatusByFilter(table);
                }
                else
                {
                    RtnVal = "Error";
                    RtnMsg = "";
                }
            }
        }

        public bool ValidateComplainCanUpdate(String ComplainType, Guid ComplainId, DateTime LastUpdateDate)
        {
            Hashtable param = new Hashtable();
            param.Add("DC_ID", ComplainId);
            param.Add("ComplainType", ComplainType);
            DataTable dt = this.DealerComplainInfo(param);

            if (dt.Rows.Count == 0
                || (dt.Rows.Count > 0 && LastUpdateDate.CompareTo(DateTime.Parse(dt.Rows[0]["DC_LastModifiedDate"].ToString())) == 0)
                )
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        public bool ValidateReturnCanUpdate(String ComplainType, Guid ComplainId, DateTime ConfirmUpdateDate)
        {
            Hashtable param = new Hashtable();
            param.Add("DC_ID", ComplainId);
            param.Add("ComplainType", ComplainType);
            DataTable dt = this.DealerComplainInfo(param);

            if (dt.Rows.Count == 0
                || (dt.Rows.Count > 0
                    && (dt.Rows[0]["DC_ConfirmUpdateDate"] == DBNull.Value
                    || ConfirmUpdateDate.CompareTo(DateTime.Parse(dt.Rows[0]["DC_ConfirmUpdateDate"].ToString())) == 0))
                )
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        private static string strDateFormat = "yyyy-MM-dd HH:mm:ss.fff";
        public DealerComplainBscVO InitPage(DealerComplainBscVO model, bool isInit)
        {
            using (DealerComplainDao dao = new DealerComplainDao())
            {
                DataTable dt = dao.QueryDealerComplainBscInfo(new Guid(model.ComplainId));

                if (dt != null && dt.Rows.Count > 0)
                {
                    model.ComplainType = dt.Rows[0]["ComplainType"] == DBNull.Value ? string.Empty : dt.Rows[0]["ComplainType"].ToString();
                    model.COMPLAINTID = dt.Rows[0]["COMPLAINTID"] == DBNull.Value ? string.Empty : dt.Rows[0]["COMPLAINTID"].ToString();
                    model.TW = dt.Rows[0]["TW"] == DBNull.Value ? string.Empty : dt.Rows[0]["TW"].ToString();
                    model.PI = dt.Rows[0]["PI"] == DBNull.Value ? string.Empty : dt.Rows[0]["PI"].ToString();
                    model.IAN = dt.Rows[0]["IAN"] == DBNull.Value ? string.Empty : dt.Rows[0]["IAN"].ToString();
                    model.RN = dt.Rows[0]["RN"] == DBNull.Value ? string.Empty : dt.Rows[0]["RN"].ToString();
                    model.ReturnFactoryTrackingNo = dt.Rows[0]["ReturnFactoryTrackingNo"] == DBNull.Value ? string.Empty : dt.Rows[0]["ReturnFactoryTrackingNo"].ToString();
                    model.ReceiveReturnedGoods = dt.Rows[0]["ReceiveReturnedGoods"] == DBNull.Value ? string.Empty : dt.Rows[0]["ReceiveReturnedGoods"].ToString();
                    model.ReceiveReturnedGoodsDate = dt.Rows[0]["ReceiveReturnedGoodsDate"] == DBNull.Value ? string.Empty : dt.Rows[0]["ReceiveReturnedGoodsDate"].ToString();

                    if (model.ComplainType == "CRM")
                        model.ConfirmReturnOrRefundCRM = dt.Rows[0]["ConfirmReturnOrRefund"] == DBNull.Value ? string.Empty : dt.Rows[0]["ConfirmReturnOrRefund"].ToString();
                    else
                    {
                        model.ConfirmReturnOrRefundCNF = dt.Rows[0]["ConfirmReturnOrRefund"] == DBNull.Value ? string.Empty : dt.Rows[0]["ConfirmReturnOrRefund"].ToString();
                    }
                    model.RGA = dt.Rows[0]["RGA"] == DBNull.Value ? string.Empty : dt.Rows[0]["RGA"].ToString();
                    model.Invoice = dt.Rows[0]["Invoice"] == DBNull.Value ? string.Empty : dt.Rows[0]["Invoice"].ToString();
                    model.DN = dt.Rows[0]["DN"] == DBNull.Value ? string.Empty : dt.Rows[0]["DN"].ToString();

                    model.CarrierNumber = dt.Rows[0]["CarrierNumber"] == DBNull.Value ? string.Empty : dt.Rows[0]["CarrierNumber"].ToString();
                    model.LastUpdateTime = dt.Rows[0]["LastUpdateDate"] == DBNull.Value ? string.Empty : DateTime.Parse(dt.Rows[0]["LastUpdateDate"].ToString()).ToString(strDateFormat);
                }

                if (isInit)
                {
                    EkpWorkflowBLL ekpBll = new EkpWorkflowBLL();

                    model.CurrentNodeIds = ekpBll.GetCurrentNodeId(model.ComplainId, _context.User.LoginId);

                    model.HtmlString = this.GetDealerComplainHtmlInfo(model.ComplainId);
                }

                model.IsSuccess = true;
                return model;
            }
        }

        public DealerComplainBscVO DoSave(DealerComplainBscVO model)
        {
            using (DealerComplainDao dao = new DealerComplainDao())
            {
                string lastUpdateDate = model.LastUpdateTime;
                DealerComplainBscVO complainVO = new DealerComplainBscVO();
                complainVO.ComplainId = model.ComplainId;

                if (!string.IsNullOrEmpty(lastUpdateDate))
                {
                    complainVO = this.InitPage(complainVO, false);

                    if (model.LastUpdateTime != lastUpdateDate)
                    {
                        model.IsSuccess = false;
                        model.ExecuteMessage.Add("页面信息已改变，请刷新！");

                        return model;
                    }
                }

                EkpWorkflowBLL ekpBll = new EkpWorkflowBLL();
                List<EkpOperation> operList = ekpBll.GetOperationList(_context.User.LoginId, model.ComplainId);
                EkpOperParam ekpOperParam = ekpBll.GetEkpParam(operList, EkpOperType.handler_pass);
                if (ekpOperParam == null)
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add("当前用户没有修改的权限");
                    return model;
                }

                Hashtable obj = new Hashtable();
                obj["ComplainId"] = model.ComplainId;
                obj["ComplainType"] = model.ComplainType;
                obj["COMPLAINTID"] = model.COMPLAINTID;
                obj["TW"] = model.TW;
                obj["PI"] = model.PI;
                obj["IAN"] = model.IAN;
                obj["RN"] = model.RN;
                obj["ReturnFactoryTrackingNo"] = model.ReturnFactoryTrackingNo;
                obj["ReceiveReturnedGoods"] = model.ReceiveReturnedGoods;
                obj["ReceiveReturnedGoodsDate"] = string.IsNullOrEmpty(model.ReceiveReturnedGoodsDate) ? null : model.ReceiveReturnedGoodsDate;
                obj["ConfirmReturnOrRefundCNF"] = model.ConfirmReturnOrRefundCNF;
                obj["ConfirmReturnOrRefundCRM"] = model.ConfirmReturnOrRefundCRM;
                obj["RGA"] = model.RGA;
                obj["Invoice"] = model.Invoice;
                obj["DN"] = model.DN;
                obj["CarrierNumber"] = model.CarrierNumber;
                obj["UpdateUser"] = _context.User.Id;
                obj["UpdateDate"] = DateTime.Now.ToString(strDateFormat);

                dao.SaveDealerComplainBsc(obj);

                model.CurrentNodeIds = ekpBll.GetCurrentNodeId(model.ComplainId, _context.User.LoginId);
                model.LastUpdateTime = obj["UpdateUser"].ToString();
                model.HtmlString = this.GetDealerComplainHtmlInfo(model.ComplainId);

                model.IsSuccess = true;
                return model;
            }
        }

        public String GetDealerComplainHtmlInfo(String complainId)
        {
            EkpHtmlBLL htmlBll = new EkpHtmlBLL();
            EkpWorkflowBLL ekpBll = new EkpWorkflowBLL();

            FormInstanceMaster formMaster = ekpBll.GetFormInstanceMasterByApplyId(complainId);

            return htmlBll.GetDmsHtmlCommonById(formMaster.ApplyId.ToString(), formMaster.modelId, formMaster.templateFormId, DmsTemplateHtmlType.Normal,"");
        }

        //对信息进行校验，然后获取错误信息，及返回的产品信息
        public void CheckUPNAndDateCNFForEkp(Hashtable table, out string rtnVal, out string rtnMsg)
        {
            using (DealerComplainDao dao = new DealerComplainDao())
            {
                dao.CheckUPNAndDateCNFForEkp(table, out rtnVal, out rtnMsg);
            }

        }

        //对信息进行校验，然后获取错误信息，及返回的产品信息
        public void CheckUPNAndDateCRMForEkp(Hashtable table, out string rtnVal, out string rtnMsg)
        {
            using (DealerComplainDao dao = new DealerComplainDao())
            {
                dao.CheckUPNAndDateCRMForEkp(table, out rtnVal, out rtnMsg);
            }
        }


        #endregion

        #region Added By Ryan Chen For 经销商投诉退换货 On 2018-05-17
        public string DealerComplainCRMExportForm(DataTable dealerComplainInfo)
        {
            string templateFile = HttpContext.Current.Server.MapPath("\\Upload\\DealerComplainTemplate\\CRM.docx");
            string saveFilePath = HttpContext.Current.Server.MapPath("\\Upload\\UploadFile\\DealerComplain");
            string saveFileName = dealerComplainInfo.Rows[0]["DC_ComplainNbr"].ToString() + ".docx";
            string saveFile = Path.Combine(saveFilePath, saveFileName);
            if (!Directory.Exists(saveFilePath))
            {
                Directory.CreateDirectory(saveFilePath);
            }

            File.Delete(saveFile);
            File.Copy(templateFile, saveFile);

            List<Bookmark> list = ListBookMarkCRM(dealerComplainInfo);

            using (WordProcessing word = new WordProcessing(saveFile))
            {
                word.ReplaceBookmarks(list);
                word.Save();
            }

            return saveFileName;
        }

        public string DealerComplainCNFExportForm(DataTable dealerComplainInfo)
        {
            string templateFile = HttpContext.Current.Server.MapPath("\\Upload\\DealerComplainTemplate\\CNF.docx");
            string saveFilePath = HttpContext.Current.Server.MapPath("\\Upload\\UploadFile\\DealerComplain");
            string saveFileName = dealerComplainInfo.Rows[0]["DC_ComplainNbr"].ToString() + ".docx";
            //string saveFileName = Guid.NewGuid().ToString() + ".docx";
            string saveFile = Path.Combine(saveFilePath, saveFileName);
            if (!Directory.Exists(saveFilePath))
            {
                Directory.CreateDirectory(saveFilePath);
            }
            File.Delete(saveFile);
            File.Copy(templateFile, saveFile);

            //若“请选择请判断支架是否仅无法通过病变,不存在其他问题”为是，则导出的word中“产品能否退回”自动为否，退回数量自动为0，不能寄回厂家的原因改为已污染
            if (dealerComplainInfo.Rows.Count > 0)
            {
                if (dealerComplainInfo.Rows[0]["NoProblemButLesionNotPass"].ToString() == "1")
                {
                    dealerComplainInfo.Rows[0]["UPNEXPECTED"] = "2";
                    dealerComplainInfo.Rows[0]["UPNQUANTITY"] = 0;
                    dealerComplainInfo.Rows[0]["NORETURN"] = "10";
                }

                //医院需显示医院名与编号
                dealerComplainInfo.Rows[0]["DISTRIBUTORCUSTOMER"] = (dealerComplainInfo.Rows[0]["HospitalCn"] != DBNull.Value ? dealerComplainInfo.Rows[0]["HospitalCn"].ToString() : "") + (dealerComplainInfo.Rows[0]["DISTRIBUTORCUSTOMER"] != DBNull.Value ? dealerComplainInfo.Rows[0]["DISTRIBUTORCUSTOMER"].ToString() : "");
            }
            List<Bookmark> list = ListBookMarkCNF(dealerComplainInfo);

            using (WordProcessing word = new WordProcessing(saveFile))
            {
                word.ReplaceBookmarks(list);
                word.Save();
            }

            return saveFileName;
        }

        private void AddTextBoxBookMark(List<Bookmark> list, DataRow dr, string colName)
        {
            //XmlNode node = rootNode.SelectSingleNode(nodeName);
            AddBookMark(list, dr, colName, BookmarkType.TextBox);
        }

        private void AddBookMark(List<Bookmark> list, DataRow dr, string colName, BookmarkType type, char split = '\u0000')
        {
            if (dr[colName] != DBNull.Value)
            {
                string colText = dr[colName].ToString();
                string[] colTextList;
                string bookmarkValue;

                if (split != '\u0000')
                {
                    colTextList = colText.Split(split);
                }
                else
                {
                    colTextList = new string[1];
                    colTextList[0] = colText;
                }

                foreach (var text in colTextList)
                {
                    if (!string.IsNullOrEmpty(text))
                    {
                        if (type == BookmarkType.TextBox)
                        {
                            //Edit By SongWeiming ON 2018-12-16 所有日期都是字符型，
                            //DateTime dt;
                            //if (text.Length == 10)
                            //{
                            //    bookmarkValue = text;
                            //} else
                            //{
                            //    bookmarkValue = DateTime.TryParse(text, out dt) ? dt.ToString("dd-MM-yyyy") : text;
                            //}
                            bookmarkValue = text;
                            list.Add(new Bookmark
                            {
                                BookmarkName = colName.Substring(0, colName.Length > 20 ? 20 : colName.Length), //word书签最长20位
                                BookmarkType = type,
                                BookmarkValue = bookmarkValue
                            });
                        }
                        else if (type == BookmarkType.CheckBox)
                        {
                            list.Add(new Bookmark
                            {
                                BookmarkName = colName.Substring(0, (colName + "_" + text).Length > 20 ? 19 - text.Length : colName.Length) + "_" + text,
                                BookmarkType = type,
                                BookmarkValue = "true"
                            });
                        }
                    }
                }
            }
        }

        private void AddCheckBoxBookMark(List<Bookmark> list, DataRow dr, string colName)
        {
            AddBookMark(list, dr, colName, BookmarkType.CheckBox);
        }

        private void AddCheckBoxBookMarkWithSplit(List<Bookmark> list, DataRow dr, string colName)
        {
            AddBookMark(list, dr, colName, BookmarkType.CheckBox, ',');
        }

        private List<Bookmark> ListBookMarkCNF(DataTable dealerComplainInfo)
        {
            //string xmlText = dealerComplainInfo["ComplainInfo"].ToString();
            //XmlDocument xmlDoc = new XmlDocument();
            //xmlDoc.LoadXml(xmlText);

            //XmlNode rootNode = xmlDoc.SelectSingleNode("DealerComplain");
            List<Bookmark> list = new List<Bookmark>();

            DataRow drInfo = dealerComplainInfo.Rows[0];

            ////转换日期格式（DateReceipt、NOTIFYDATE、PatientBirth、INITIALPDATE、IMPLANTEDDATE、EXPLANTEDDATE、EDATE、WHENNOTICED、DeathDate  dd-mm-yyyy）
            //string dateReceipt = drInfo["DateReceipt"].ToString();
            //string nOTIFYDATE = drInfo["NOTIFYDATE"].ToString();
            //string patientBirth = drInfo["PatientBirth"].ToString();
            //string iNITIALPDATE = drInfo["INITIALPDATE"].ToString();
            //string iMPLANTEDDATE = drInfo["IMPLANTEDDATE"].ToString();
            //string eXPLANTEDDATE = drInfo["EXPLANTEDDATE"].ToString();
            //string eDATE = drInfo["EDATE"].ToString();
            //string wHENNOTICED = drInfo["WHENNOTICED"].ToString();
            //string deathDate = drInfo["DeathDate"].ToString();

            //DateTime dt;


            //if (!string.IsNullOrEmpty(dateReceipt) && dateReceipt.Length > 8)
            //    drInfo["DateReceipt"] = DateTime.TryParse(dateReceipt, out dt) ? dt.ToString("dd-MM-yyyy") : dateReceipt; //dateReceipt.Substring(6, 2) + "-" + dateReceipt.Substring(4, 2) + "-" + dateReceipt.Substring(0, 4);

            //if (!string.IsNullOrEmpty(nOTIFYDATE) && nOTIFYDATE.Length > 8)
            //    drInfo["NOTIFYDATE"] = DateTime.TryParse(nOTIFYDATE, out dt) ? dt.ToString("dd-MM-yyyy") : nOTIFYDATE;//nOTIFYDATE.Substring(6, 2) + "-" + nOTIFYDATE.Substring(4, 2) + "-" + nOTIFYDATE.Substring(0, 4);

            //if (!string.IsNullOrEmpty(patientBirth) && patientBirth.Length > 8)
            //    drInfo["PatientBirth"] = DateTime.TryParse(patientBirth, out dt) ? dt.ToString("dd-MM-yyyy") : patientBirth;//patientBirth.Substring(6, 2) + "-" + patientBirth.Substring(4, 2) + "-" + patientBirth.Substring(0, 4);

            //if (!string.IsNullOrEmpty(iNITIALPDATE) && iNITIALPDATE.Length > 8)
            //    drInfo["INITIALPDATE"] = DateTime.TryParse(iNITIALPDATE, out dt) ? dt.ToString("dd-MM-yyyy") : iNITIALPDATE;//iNITIALPDATE.Substring(6, 2) + "-" + iNITIALPDATE.Substring(4, 2) + "-" + iNITIALPDATE.Substring(0, 4);

            //if (!string.IsNullOrEmpty(iMPLANTEDDATE) && iMPLANTEDDATE.Length > 8)
            //    drInfo["IMPLANTEDDATE"] = DateTime.TryParse(iMPLANTEDDATE, out dt) ? dt.ToString("dd-MM-yyyy") : iMPLANTEDDATE;//iMPLANTEDDATE.Substring(6, 2) + "-" + iMPLANTEDDATE.Substring(4, 2) + "-" + iMPLANTEDDATE.Substring(0, 4);

            //if (!string.IsNullOrEmpty(eXPLANTEDDATE) && eXPLANTEDDATE.Length > 8)
            //    drInfo["EXPLANTEDDATE"] = DateTime.TryParse(eXPLANTEDDATE, out dt) ? dt.ToString("dd-MM-yyyy") : eXPLANTEDDATE;//eXPLANTEDDATE.Substring(6, 2) + "-" + eXPLANTEDDATE.Substring(4, 2) + "-" + eXPLANTEDDATE.Substring(0, 4);

            //if (!string.IsNullOrEmpty(eDATE) && eDATE.Length > 8)
            //    drInfo["EDATE"] = DateTime.TryParse(eDATE, out dt) ? dt.ToString("dd-MM-yyyy") : eDATE;//eDATE.Substring(6, 2) + "-" + eDATE.Substring(4, 2) + "-" + eDATE.Substring(0, 4);

            //if (!string.IsNullOrEmpty(wHENNOTICED) && wHENNOTICED.Length > 8)
            //    drInfo["WHENNOTICED"] = DateTime.TryParse(wHENNOTICED, out dt) ? dt.ToString("dd-MM-yyyy") : wHENNOTICED;//wHENNOTICED.Substring(6, 2) + "-" + wHENNOTICED.Substring(4, 2) + "-" + wHENNOTICED.Substring(0, 4);

            //if (!string.IsNullOrEmpty(deathDate) && deathDate.Length > 8)
            //    drInfo["DeathDate"] = DateTime.TryParse(deathDate, out dt) ? dt.ToString("dd-MM-yyyy") : deathDate;//deathDate.Substring(6, 2) + "-" + deathDate.Substring(4, 2) + "-" + deathDate.Substring(0, 4);



            AddTextBoxBookMark(list, drInfo, "IDENTITY_NAME");  //原报告人姓名    Completed By
            AddTextBoxBookMark(list, drInfo, "REQUESTDATE");  //原报告人姓名    Completed On

            AddTextBoxBookMark(list, drInfo, "INITIALNAME");  //原报告人姓名    Initial Reporter Name
            AddTextBoxBookMark(list, drInfo, "INITIALJOB");  //原报告人职位     Initial Reporter Occupation
            AddTextBoxBookMark(list, drInfo, "INITIALPHONE");  //原报告人电话   Initial Reporter Phone
            AddTextBoxBookMark(list, drInfo, "INITIALEMAIL");  //原报告人Email  Initial Reporter Email Address
            AddTextBoxBookMark(list, drInfo, "PHYSICIAN");  //医生姓名          Physician Name
            AddTextBoxBookMark(list, drInfo, "PHYSICIANPHONE");  //医生电话     Physician Phone

            AddTextBoxBookMark(list, drInfo, "BSCSalesName");  //波科销售人员姓名 First BSC Contact Name
            AddTextBoxBookMark(list, drInfo, "DateReceipt");  //波科人员接服日期 BSC Aware Date

            AddTextBoxBookMark(list, drInfo, "NOTIFYDATE");  //投诉通知日期        Complaint Notification Date

            AddCheckBoxBookMark(list, drInfo, "CONTACTMETHOD"); //联系方式      Contact Method   
            AddCheckBoxBookMark(list, drInfo, "COMPLAINTSOURCE"); //投诉来源    Complaint Source 

            AddTextBoxBookMark(list, drInfo, "BSCSOLDTONAME");  //一级经销商名称 BSC Sold To Name or Account Number
            AddTextBoxBookMark(list, drInfo, "DISTRIBUTORCUSTOMER");  //医院名称 Distributor’s Sold To Customer
            AddTextBoxBookMark(list, drInfo, "BSCSOLDTOCITY");  //一级经销商所在城市 BSC Sold To City
            AddTextBoxBookMark(list, drInfo, "DISTRIBUTORCITY");  //医院所在城市 Distributor’s Sold To Customer City

            AddTextBoxBookMark(list, drInfo, "DESCRIPTION");  //UPN描述           UPN description
            AddTextBoxBookMark(list, drInfo, "UPN");  //产品型号（UPN）           UPN#
            AddCheckBoxBookMark(list, drInfo, "BU");  //BU           Business Unit of Product UPN:

            AddTextBoxBookMark(list, drInfo, "LOT");  //产品批号（Lot）           Batch/Lot/Serial #:
            AddCheckBoxBookMark(list, drInfo, "SINGLEUSE");  //是否为一次性器械      Is this a single use device? 
            AddCheckBoxBookMark(list, drInfo, "RESTERILIZED");  //能否重复消毒    Re-sterilized?

            AddTextBoxBookMark(list, drInfo, "PREPROCESSOR");  //如果该器械经过再次处理后用户患者  If reprocessed and used on patient, enter reprocessor’s name and address
            AddCheckBoxBookMark(list, drInfo, "USEDEXPIRY");  //是否在有效期后使用 Used past expiry date?
            AddCheckBoxBookMark(list, drInfo, "UPNEXPECTED");        //产品能否退回   Product Expected? 
            AddTextBoxBookMark(list, drInfo, "UPNQUANTITY");  //退回的数量      Quantity Expected
            AddCheckBoxBookMark(list, drInfo, "NORETURN");  //不能寄回厂家的原因    Reason for No Return
            AddTextBoxBookMark(list, drInfo, "NORETURNREASON");  //不能寄回厂家的原因    Reason for No Return

            AddTextBoxBookMark(list, drInfo, "PatientName");  //患者标识（ID）   Patient Identifier
            AddTextBoxBookMark(list, drInfo, "PatientAge");  //事件发生时患者的年龄   Patient Age at Time of Event
            //todo Age Unit
            AddCheckBoxBookMark(list, drInfo, "PatientIs18");  //患者是否未满18岁    Is patient/user under 18? 
            AddTextBoxBookMark(list, drInfo, "PatientBirth");  //患者出生日期         Patient Date of Birth
            AddTextBoxBookMark(list, drInfo, "PatientWeight");  //患者体重          Patient Weight
            AddCheckBoxBookMark(list, drInfo, "PatientWeightUom");  //体重单位       Weight Unit
            AddCheckBoxBookMark(list, drInfo, "PatientSex");  //患者性别          Patient Sex
            AddTextBoxBookMark(list, drInfo, "AnatomicSite");  //解剖部位/病变部位   Anatomy or lesion location

            AddTextBoxBookMark(list, drInfo, "INITIALPDATE");  //首次手术日期         Initial Procedure Date
            AddTextBoxBookMark(list, drInfo, "PNAME");         //手术名称           Procedure Name
            AddTextBoxBookMark(list, drInfo, "INDICATION");     //手术指征          Indication of procedure
            AddTextBoxBookMark(list, drInfo, "IMPLANTEDDATE");  //植入日期（若有）  Implanted Date, if any
            AddTextBoxBookMark(list, drInfo, "EXPLANTEDDATE");  //移出日期（若有）   Explanted Date, if any
            AddCheckBoxBookMark(list, drInfo, "POUTCOME");       //手术结果           Procedure Outcome
            AddCheckBoxBookMark(list, drInfo, "IVUS");          //是否使用了IVUS      Was IVUS used?
            AddCheckBoxBookMark(list, drInfo, "GENERATOR");       //是否使用了电刀    Was a generator involved?
            AddTextBoxBookMark(list, drInfo, "GENERATORTYPE");   //电刀类型说明       If YES, indicate Type
            AddTextBoxBookMark(list, drInfo, "GENERATORSET");   //电刀设置            and Settings
            AddCheckBoxBookMark(list, drInfo, "PCONDITION");   //患者术后状况如何      What was the patient condition following procedure?

            AddTextBoxBookMark(list, drInfo, "EDATE");            //事件发生日期      Event Date
            AddCheckBoxBookMark(list, drInfo, "WHENNOTICED");     //发现问题的时间    When was the problem noticed
            AddCheckBoxBookMark(list, drInfo, "WHEREOCCUR");      //问题发生在什么位置Where did the problem occur? 
            AddTextBoxBookMark(list, drInfo, "EDESCRIPTION");    //事件描述          Event Description
            AddCheckBoxBookMark(list, drInfo, "WITHLABELEDUSE");       //是在按标示使用器械的    Was the problem associated with labeled use
            AddTextBoxBookMark(list, drInfo, "NOLABELEDUSE");    //如果不是，请解释    If NO, explain

            AddCheckBoxBookMarkWithSplit(list, drInfo, "HandlingEvents");       //医生尝试处理事件的行动    Was the problem associated with labeled use
            AddTextBoxBookMark(list, drInfo, "SurgeryRemark");    //手术治疗（请说明）    Surgery (Describe)
            AddTextBoxBookMark(list, drInfo, "HospitalizationRemark");    //住院或延长住院时间（请说明住院时间/原因）    Hospitalization or prolongation of hospitalization (length of stay and reason)
            AddTextBoxBookMark(list, drInfo, "MedicineRemark");    //药物治疗 （请说明）  Medications (Describe)
            AddTextBoxBookMark(list, drInfo, "BloodTransfusionRemark");    //输血/血液制品（请说明）  Blood/Blood products (Describe)
            AddTextBoxBookMark(list, drInfo, "OtherInterventionalRemark");    //其他介入治疗（请说明）  Other Intervention (Describe)

            AddCheckBoxBookMarkWithSplit(list, drInfo, "Consequence");       //该事件对患者造成的后果    Patient outcome from the event
            AddTextBoxBookMark(list, drInfo, "DeathDate");          //死亡日期 Death     Date (dd/mmm/yyyy)
            AddTextBoxBookMark(list, drInfo, "NotSeriousRemark");   //请说明未严重受伤   No serious injury(describe)
            AddTextBoxBookMark(list, drInfo, "PermanentDamageRemark");//请说明某项身体机能永久受损 Permanent impairment of a body function(describe)
            AddTextBoxBookMark(list, drInfo, "SeriousRemark");          //请说明严重受伤 Serious injury
            AddCheckBoxBookMarkWithSplit(list, drInfo, "EVENTRESOLVED");       //事情是否已解决    Event resolved?

            return list;
        }

        private List<Bookmark> ListBookMarkCRM(DataTable dealerComplainInfo)
        {
            List<Bookmark> list = new List<Bookmark>();

            DataRow drInfo = dealerComplainInfo.Rows[0];
            //转换日期格式（DateEvent、DateReceipt、PatientBirth、DeathDate、Leads1Implant、Leads2Implant、Leads3Implant、ExplantDate  dd-mm-yyyy）
            //string dateEvent = drInfo["DateEvent"].ToString();
            //string dateReceipt = drInfo["DateReceipt"].ToString();
            //string patientBirth = drInfo["PatientBirth"].ToString();
            //string deathDate = drInfo["DeathDate"].ToString();
            //string pulseImplant = drInfo["PulseImplant"].ToString();
            //string leads1Implant = drInfo["Leads1Implant"].ToString();
            //string leads2Implant = drInfo["Leads2Implant"].ToString();
            //string leads3Implant = drInfo["Leads3Implant"].ToString();
            //string explantDate = drInfo["ExplantDate"].ToString();

            //if (!string.IsNullOrEmpty(dateEvent) && dateEvent.Length == 8)
            //    drInfo["DateEvent"] = dateEvent.Substring(6, 2) + "-" + dateEvent.Substring(4, 2) + "-" + dateEvent.Substring(0, 4);

            //if (!string.IsNullOrEmpty(dateReceipt) && dateReceipt.Length == 8)
            //    drInfo["DateReceipt"] = dateReceipt.Substring(6, 2) + "-" + dateReceipt.Substring(4, 2) + "-" + dateReceipt.Substring(0, 4);

            //if (!string.IsNullOrEmpty(patientBirth) && patientBirth.Length == 8)
            //    drInfo["PatientBirth"] = patientBirth.Substring(6, 2) + "-" + patientBirth.Substring(4, 2) + "-" + patientBirth.Substring(0, 4);

            //if (!string.IsNullOrEmpty(deathDate) && deathDate.Length == 8)
            //    drInfo["DeathDate"] = deathDate.Substring(6, 2) + "-" + deathDate.Substring(4, 2) + "-" + deathDate.Substring(0, 4);

            //if (!string.IsNullOrEmpty(pulseImplant) && pulseImplant.Length == 8)
            //    drInfo["PulseImplant"] = pulseImplant.Substring(6, 2) + "-" + pulseImplant.Substring(4, 2) + "-" + pulseImplant.Substring(0, 4);

            //if (!string.IsNullOrEmpty(leads1Implant) && leads1Implant.Length == 8)
            //    drInfo["Leads1Implant"] = leads1Implant.Substring(6, 2) + "-" + leads1Implant.Substring(4, 2) + "-" + leads1Implant.Substring(0, 4);

            //if (!string.IsNullOrEmpty(leads2Implant) && leads2Implant.Length == 8)
            //    drInfo["Leads2Implant"] = leads2Implant.Substring(6, 2) + "-" + leads2Implant.Substring(4, 2) + "-" + leads2Implant.Substring(0, 4);

            //if (!string.IsNullOrEmpty(leads3Implant) && leads3Implant.Length == 8)
            //    drInfo["Leads3Implant"] = leads3Implant.Substring(6, 2) + "-" + leads3Implant.Substring(4, 2) + "-" + leads3Implant.Substring(0, 4);

            //if (!string.IsNullOrEmpty(explantDate) && explantDate.Length == 8)
            //    drInfo["ExplantDate"] = explantDate.Substring(6, 2) + "-" + explantDate.Substring(4, 2) + "-" + explantDate.Substring(0, 4);



            AddTextBoxBookMark(list, drInfo, "BSCSales");  //姓名    Name
            AddTextBoxBookMark(list, drInfo, "CompletedTitle");  //职位   Title
            AddTextBoxBookMark(list, drInfo, "DateEvent");      //事件发生日期   Date of Event
            AddTextBoxBookMark(list, drInfo, "DateReceipt");  //波科人员接报日期  Date BSC Employee Informed
            AddTextBoxBookMark(list, drInfo, "NonBostonName");  //姓名            Name
            AddTextBoxBookMark(list, drInfo, "NonBostonCompany");  //公司         Company
            AddTextBoxBookMark(list, drInfo, "NonBostonAddress");  //地址         Address
            AddTextBoxBookMark(list, drInfo, "NonBostonCity");      //城市        City
            AddTextBoxBookMark(list, drInfo, "NonBostonCountry");  //国家         Country
            AddTextBoxBookMark(list, drInfo, "EventCountry"); //事件发生的国家      Event Occurred in Country
            AddTextBoxBookMark(list, drInfo, "OtherCountry"); //其他国家           If Other, enter country
            AddCheckBoxBookMark(list, drInfo, "NeedSupport");  //是否需要技术支持    Is Technical Assistance Needed

            AddTextBoxBookMark(list, drInfo, "PatientName");  //患者姓名或者字母    Patient Name or  Initials (first, last)
            AddTextBoxBookMark(list, drInfo, "PatientNum");  //患者编号             Patient Number
            AddTextBoxBookMark(list, drInfo, "PatientSex");  //性别                 Patient Gender
            AddCheckBoxBookMark(list, drInfo, "PatientSexInvalid");  //不能获取       Patient Gender unable to obtain
            AddTextBoxBookMark(list, drInfo, "PatientBirth");  //患者出身年月日       Patient Date of Birth
            AddCheckBoxBookMark(list, drInfo, "PatientBirthInvalid");  //不能获取           unable to obtain
            AddTextBoxBookMark(list, drInfo, "PatientWeight");  //患者体重           Patient Weight
            AddCheckBoxBookMark(list, drInfo, "PatientWeightInvalid");  //患者体重     unable to obtain

            AddTextBoxBookMark(list, drInfo, "PhysicianName");  //医生姓名/信息来源者姓名    Physician/Source of Information Name
            AddTextBoxBookMark(list, drInfo, "PhysicianTitle");  //职位                   Title
            AddTextBoxBookMark(list, drInfo, "PhysicianHospital");  //事件发生医院       Hospital
            AddTextBoxBookMark(list, drInfo, "PhysicianAddress");        //地址          Address
            AddTextBoxBookMark(list, drInfo, "PhysicianCity");         //城市            City
            AddTextBoxBookMark(list, drInfo, "PhysicianCountry");       //国家            Country
            AddTextBoxBookMark(list, drInfo, "PhysicianZipcode");       //邮编            Postal Code

            AddCheckBoxBookMarkWithSplit(list, drInfo, "PatientStatus");  //患者状态             PATIENT STATUS
            AddTextBoxBookMark(list, drInfo, "DeathDate");      //死亡日期              Death Date 
            AddTextBoxBookMark(list, drInfo, "DeathTime");      //死亡时间              Death Time    
            AddTextBoxBookMark(list, drInfo, "DeathCause");     //原因                  Cause
            AddCheckBoxBookMark(list, drInfo, "Witnessed");      //上报人是否在场        Witnessed
            AddCheckBoxBookMark(list, drInfo, "RelatedBSC");  //是否怀疑该死亡与波科产品故障有关        Is it suspected that the death was related to a BSC

            AddCheckBoxBookMark(list, drInfo, "IsForBSCProduct");  //是否与波科产品有关   REASONS FOR PRODUCT EXPERIENCE REPORT
            AddCheckBoxBookMarkWithSplit(list, drInfo, "ReasonsForProduct");  //上报原因   REASONS FOR PRODUCT EXPERIENCE REPORT

            AddCheckBoxBookMark(list, drInfo, "Returned");          //产品是否可返回      check all boxes that apply
            AddTextBoxBookMark(list, drInfo, "ReturnedDay");         //手术名称           If yes, how many working days are needed for the return
            AddCheckBoxBookMark(list, drInfo, "AnalysisReport");     //是否要求提供分析报告   Analysis report requested
            AddTextBoxBookMark(list, drInfo, "RequestPhysicianName");  //要求提供报告的医生姓名  Name of physician requesting report
            AddCheckBoxBookMark(list, drInfo, "Warranty");          //是否有保修单   Warranty requested

            AddCheckBoxBookMarkWithSplit(list, drInfo, "Pulse");       //脉冲发生器/控制仪         Pulse generator/Programmer
            AddTextBoxBookMark(list, drInfo, "Pulsebeats");          //起搏抑制（抑制起搏的跳数）      Pacing inhibition Seconds of asystole

            AddCheckBoxBookMarkWithSplit(list, drInfo, "Leads");       //电极/传送系统    Leads/Delivery system
            AddTextBoxBookMark(list, drInfo, "LeadsFracture");   //电极导体断裂       Lead conductor fracture
            AddTextBoxBookMark(list, drInfo, "LeadsIssue");
            AddTextBoxBookMark(list, drInfo, "LeadsDislodgement");
            AddTextBoxBookMark(list, drInfo, "LeadsMeasurements");
            AddTextBoxBookMark(list, drInfo, "LeadsThresholds");
            AddTextBoxBookMark(list, drInfo, "LeadsBeats");
            AddTextBoxBookMark(list, drInfo, "LeadsNoise");
            AddTextBoxBookMark(list, drInfo, "LeadsLoss");

            AddCheckBoxBookMarkWithSplit(list, drInfo, "Clinical");       //临床    Clinical
            AddTextBoxBookMark(list, drInfo, "ClinicalPerforation");
            AddTextBoxBookMark(list, drInfo, "ClinicalBeats");

            AddTextBoxBookMark(list, drInfo, "PulseModel");    //脉冲发生器  Pulse Generator
            AddTextBoxBookMark(list, drInfo, "PulseSerial");
            AddTextBoxBookMark(list, drInfo, "PulseImplant");

            AddTextBoxBookMark(list, drInfo, "Leads1Model");    //电极1  Lead 1
            AddTextBoxBookMark(list, drInfo, "Leads1Serial");
            AddTextBoxBookMark(list, drInfo, "Leads1Implant");

            AddTextBoxBookMark(list, drInfo, "Leads2Model");    //电极2  Lead 2
            AddTextBoxBookMark(list, drInfo, "Leads2Serial");
            AddTextBoxBookMark(list, drInfo, "Leads2Implant");

            AddTextBoxBookMark(list, drInfo, "Leads3Model");    //电极3  Lead 3
            AddTextBoxBookMark(list, drInfo, "Leads3Serial");
            AddTextBoxBookMark(list, drInfo, "Leads3Implant");

            AddCheckBoxBookMark(list, drInfo, "Leads1Position");       //电极位置1    Lead Position1
            AddCheckBoxBookMark(list, drInfo, "Leads2Position");       //电极位置2    Lead Position2
            AddCheckBoxBookMark(list, drInfo, "Leads3Position");       //电极位置3    Lead Position3

            AddTextBoxBookMark(list, drInfo, "AccessoryModel");    //配件  Accessory
            AddTextBoxBookMark(list, drInfo, "AccessorySerial");
            AddTextBoxBookMark(list, drInfo, "AccessoryImplant");
            AddTextBoxBookMark(list, drInfo, "AccessoryLot");       //批号    Lot

            AddTextBoxBookMark(list, drInfo, "ExplantDate");    //移除时间  Explant Date
            AddCheckBoxBookMark(list, drInfo, "RemainsService");    //仍在服务中 Remains in Service
            AddCheckBoxBookMark(list, drInfo, "RemovedService");   //产品已移除体内   Removed from Service

            AddTextBoxBookMark(list, drInfo, "Replace1Model");    //更换的产品信息  Replacement Products
            AddTextBoxBookMark(list, drInfo, "Replace1Serial");
            AddTextBoxBookMark(list, drInfo, "Replace1Implant");

            AddTextBoxBookMark(list, drInfo, "Replace2Model");    //更换的产品信息  Replacement Products
            AddTextBoxBookMark(list, drInfo, "Replace2Serial");
            AddTextBoxBookMark(list, drInfo, "Replace2Implant");

            AddTextBoxBookMark(list, drInfo, "Replace3Model");    //更换的产品信息  Replacement Products
            AddTextBoxBookMark(list, drInfo, "Replace3Serial");
            AddTextBoxBookMark(list, drInfo, "Replace3Implant");

            AddTextBoxBookMark(list, drInfo, "Replace4Model");    //更换的产品信息  Replacement Products
            AddTextBoxBookMark(list, drInfo, "Replace4Serial");
            AddTextBoxBookMark(list, drInfo, "Replace4Implant");

            AddTextBoxBookMark(list, drInfo, "Replace5Model");    //更换的产品信息  Replacement Products
            AddTextBoxBookMark(list, drInfo, "Replace5Serial");
            AddTextBoxBookMark(list, drInfo, "Replace5Implant");

            AddTextBoxBookMark(list, drInfo, "ProductExpDetail");      //产品体验详细的事件描述或临床观察     PRODUCT EXPERIENCE DETAILS
            AddTextBoxBookMark(list, drInfo, "CustomerComment");   //客户意见/扩展需求   CUSTOMER COMMENT

            AddTextBoxBookMark(list, drInfo, "Model");  //型号    model
            AddTextBoxBookMark(list, drInfo, "Lot");  //产品批号    Serial 

            return list;
        }

        public string DealerComplainCNFSendMailWithAttachment(DataTable table)
        {
            string result = "Success";

            MailMessageTemplate mailMessage =
                        _messageBLL.GetMailMessageTemplate(
                            MailMessageTemplateCode.EMAIL_QACOMPLAIN_SUBMITAPPLY.ToString());

            Hashtable tbaddress = new Hashtable();
            tbaddress.Add("MailType", "QAComplainBSC");
            tbaddress.Add("MailTo", "EAI");
            IList<MailDeliveryAddress> Addresslist = _contractBll.GetMailDeliveryAddress(tbaddress);

            if (Addresslist != null && Addresslist.Count > 0)
            {
                if (table.Rows.Count > 0)
                {
                    string formPath = this.DealerComplainCNFExportForm(table);

                    DealerMaster dealerInfo = _dealers.GetDealerMaster(new Guid(table.Rows[0]["DC_CorpId"].ToString()));

                    string UPNDESC = "<table border frame =\"box\" cellspacing=\"0\" style=\"font-family: 微软雅黑\"><tr><td bgcolor=\"#FFC0FF\">Division</td><td bgcolor=\"#FFC0FF\">UPN</td><td bgcolor=\"#FFC0FF\">UPN描述</td></tr><tr><td>"
                                     +
                                     (string.IsNullOrEmpty(table.Rows[0]["BU"].ToString())
                                         ? ""
                                         : table.Rows[0]["BU"].ToString()) + " </td><td >" +
                                     (string.IsNullOrEmpty(table.Rows[0]["UPN"].ToString())
                                         ? ""
                                         : table.Rows[0]["UPN"].ToString()) + "</td><td>"
                                     +
                                     (string.IsNullOrEmpty(table.Rows[0]["DESCRIPTION"].ToString())
                                         ? ""
                                         : table.Rows[0]["DESCRIPTION"].ToString()) + "</td></tr></table>";

                    //发邮件通知EAI
                    foreach (MailDeliveryAddress mailAddress in Addresslist)
                    {
                        MailMessageQueue mail = new MailMessageQueue();
                        mail.Id = Guid.NewGuid();
                        mail.QueueNo = "email";
                        mail.From = "";
                        mail.To = mailAddress.MailAddress;
                        mail.Subject = mailMessage.Subject.Replace("{#UploadNo}",
                            table.Rows[0]["DC_ComplainNbr"].ToString());
                        mail.Body =
                            mailMessage.Body.Replace("{#UploadNo}", table.Rows[0]["DC_ComplainNbr"].ToString())
                                .Replace("{#DealerName}", dealerInfo.ChineseName)
                                .Replace("{#SubmitDate}", DateTime.Now.ToString())
                                .Replace("{#productInfo}", UPNDESC);
                        mail.Status = "Waiting";
                        mail.CreateDate = DateTime.Now;
                        _messageBLL.AddToMailMessageQueue(mail);

                        MailMessageAttachment attachment = new MailMessageAttachment();
                        attachment.Id = Guid.NewGuid();
                        attachment.MmqId = mail.Id;
                        attachment.FilePath = string.Format("{0}://{1}/Upload/UploadFile/DealerComplain/{2}",
                            HttpContext.Current.Request.Url.Scheme, HttpContext.Current.Request.Url.Authority, formPath);
                        attachment.FileType = "docx";
                        attachment.FileIdentifier = "DealerComplainCNF";
                        _messageBLL.AddToMailMessageAttach(attachment);
                    }
                }
                else
                {
                    result = "单据信息不存在";
                }
            }
            else
            {
                result = "邮件地址不存在";
            }

            return result;
        }

        public string DealerComplainCRMSendMailWithAttachment(DataTable table)
        {
            string result = "Success";

            MailMessageTemplate mailMessage =
                        _messageBLL.GetMailMessageTemplate(
                            MailMessageTemplateCode.EMAIL_QACOMPLAIN_SUBMITAPPLY.ToString());

            Hashtable tbaddress = new Hashtable();
            tbaddress.Add("MailType", "QAComplainBSC");
            tbaddress.Add("MailTo", "EAI");
            IList<MailDeliveryAddress> Addresslist = _contractBll.GetMailDeliveryAddress(tbaddress);

            if (Addresslist != null && Addresslist.Count > 0)
            {
                if (table.Rows.Count > 0)
                {
                    string formPath = this.DealerComplainCRMExportForm(table);

                    string dealerName = string.Empty;
                    DealerMaster dealerInfo = _dealers.GetDealerMaster(new Guid(table.Rows[0]["DC_CorpId"].ToString()));
                    if (dealerInfo != null && string.IsNullOrEmpty(dealerInfo.ChineseName) == false)
                    {
                        dealerName = dealerInfo.ChineseName;
                    }

                    string cfnDesc = string.Empty;
                    IList<Cfn> cfnInfo =
                        _cfns.SelectByCustomerFaceNbr(new Cfn { CustomerFaceNbr = table.Rows[0]["Serial"].ToString() });
                    if (cfnInfo.Count > 0 && string.IsNullOrEmpty(cfnInfo[0].Description) == false)
                    {
                        cfnDesc = cfnInfo[0].Description;
                    }

                    string UPNDESC = "<table border frame =\"box\" cellspacing=\"0\" style=\"font-family: 微软雅黑\"><tr><td bgcolor=\"#FFC0FF\">Division</td><td bgcolor=\"#FFC0FF\">UPN</td><td bgcolor=\"#FFC0FF\">UPN描述</td></tr><tr><td>CRM</td><td >" +
                                     (string.IsNullOrEmpty(table.Rows[0]["Serial"].ToString())
                                         ? ""
                                         : table.Rows[0]["Serial"].ToString()) + "</td><td>"
                                     + cfnDesc + "</td></tr></table>";

                    //发邮件通知EAI
                    foreach (MailDeliveryAddress mailAddress in Addresslist)
                    {
                        MailMessageQueue mail = new MailMessageQueue();
                        mail.Id = Guid.NewGuid();
                        mail.QueueNo = "email";
                        mail.From = "";
                        mail.To = mailAddress.MailAddress;
                        mail.Subject = mailMessage.Subject.Replace("{#UploadNo}",
                            table.Rows[0]["DC_ComplainNbr"].ToString());
                        mail.Body =
                            mailMessage.Body.Replace("{#UploadNo}", table.Rows[0]["DC_ComplainNbr"].ToString())
                                .Replace("{#DealerName}", dealerName)
                                .Replace("{#SubmitDate}", DateTime.Now.ToString())
                                .Replace("{#productInfo}", UPNDESC);
                        mail.Status = "Waiting";
                        mail.CreateDate = DateTime.Now;
                        _messageBLL.AddToMailMessageQueue(mail);

                        MailMessageAttachment attachment = new MailMessageAttachment();
                        attachment.Id = Guid.NewGuid();
                        attachment.MmqId = mail.Id;
                        attachment.FilePath = string.Format("{0}://{1}/Upload/UploadFile/DealerComplain/{2}",
                            HttpContext.Current.Request.Url.Scheme, HttpContext.Current.Request.Url.Authority, formPath);
                        attachment.FileType = "docx";
                        attachment.FileIdentifier = "DealerComplainCRM";
                        _messageBLL.AddToMailMessageAttach(attachment);
                    }
                }
                else
                {
                    result = "单据信息不存在";
                }
            }
            else
            {
                result = "邮件地址不存在";
            }

            return result;
        }
        #endregion
    }
}
