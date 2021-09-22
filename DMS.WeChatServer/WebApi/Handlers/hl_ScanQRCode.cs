using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Dynamic;
using System.IO;
using System.Linq;
using System.Web;
using DMS.Business.Excel;
using DMS.DataService.Util;
using DMS.Model;
using DMS.Model.DataInterface;
using DMS.Model.WeChat;
using DMS.WeChatServer.Common;

namespace DMS.WeChatServer.WebApi.Handlers
{
    public class hl_ScanQRCode : hl_Base
    {
        public override List<string> GetActionName()
        {
            return new List<string> { "ScanQRCode" };
        }
        public override HandleResult ProcessMessage(WeChatParams mobileParams)
        {
            HandleResult result = new HandleResult();
            bool isSuccess = false;
            try
            {
                var operateType = mobileParams.MethodName;

                if (operateType == "InitQRHeaderInfo")
                {
                    result = InitQRHeaderInfo(mobileParams);
                }
                else if (operateType == "SubmitQRHeaderInfo")
                {
                    result = SubmitQRHeaderInfo(mobileParams);
                }
                else if (operateType == "ExportQRHeaderInfo")
                {
                    result = ExportQRHeaderInfo(mobileParams);
                }
                else if (operateType == "InsertWechatQRCodeDetail")
                {
                    result = InsertWechatQRCodeDetail(mobileParams);
                }
                else if (operateType == "DeleteWechatQRCodeDetail")
                {
                    result = DeleteWechatQRCodeDetail(mobileParams);
                }
                else if (operateType == "SearchHeaderInfo")
                {
                    result = SearchHeaderInfo(mobileParams);
                }
                else if (operateType == "DeleteHeaderInfo")
                {
                    result = DeleteHeaderInfo(mobileParams);
                }
            }
            catch (Exception ex)
            {
                result.success = false;
                result.msg = ex.Message.ToString();
            }
            return result;
        }

        #region 
        public static HandleResult InitQRHeaderInfo(WeChatParams message)
        {
            string strQrHeaderNo = message.Parameters["QRHeaderNo"].ToString();
            string strDealerId = message.Parameters["DealerId"].ToString();
            string strUserId = message.Parameters["UserId"].ToString();

            HandleResult handleResult = new HandleResult { success = false, msg = string.Empty };
            if (string.IsNullOrEmpty(strQrHeaderNo))
            {
                strQrHeaderNo = bllWeChat.GetWechatQRCodeHeaderNo(strDealerId, strUserId);
            }

            DataSet dsQRHeader = bllWeChat.SelectWechatQRCodeHeader(strDealerId, strQrHeaderNo);
            if (null != dsQRHeader && dsQRHeader.Tables.Count > 0 && dsQRHeader.Tables[0].Rows.Count > 0)
            {
                DataRow drQRHeader = dsQRHeader.Tables[0].Rows[0];
                dynamic data = new ExpandoObject();
                dynamic HeaderInfo = new ExpandoObject();
                string strHeaderID = string.Empty;
                HeaderInfo.No = drQRHeader["WQH_No"] != DBNull.Value ? drQRHeader["WQH_No"] : null;
                if (drQRHeader["WQH_ID"] == DBNull.Value)
                {
                    handleResult.msg = "该单据信息不存在。";
                }
                else
                {
                    HeaderInfo.ID = strHeaderID = drQRHeader["WQH_ID"].ToString();
                    HeaderInfo.Remark = drQRHeader["WQH_Remark"] != DBNull.Value ? drQRHeader["WQH_Remark"] : null;
                    HeaderInfo.UploadStatus = drQRHeader["WQH_UploadStatus"] != DBNull.Value
                        ? drQRHeader["WQH_UploadStatus"]
                        : null;
                    data.HeaderInfo = HeaderInfo;

                    DataSet dsQRDetail = bllWeChat.SelectWechatQRCodeDetail(strHeaderID);
                    if (null != dsQRDetail && dsQRDetail.Tables.Count > 0 && dsQRDetail.Tables[0].Rows.Count > 0)
                    {
                        List<ExpandoObject> lstDetail = new List<ExpandoObject>();
                        foreach (DataRow drQRDetail in dsQRDetail.Tables[0].Rows)
                        {
                            dynamic DetailInfo = new ExpandoObject();
                            DetailInfo.ID = drQRDetail["WQD_ID"] != DBNull.Value ? drQRDetail["WQD_ID"] : null;
                            DetailInfo.QRCode = drQRDetail["WQD_QRCode"] != DBNull.Value
                                ? drQRDetail["WQD_QRCode"]
                                : null;
                            DetailInfo.UPN = drQRDetail["WQD_UPN"] != DBNull.Value ? drQRDetail["WQD_UPN"] : null;
                            DetailInfo.Lot = drQRDetail["WQD_Lot"] != DBNull.Value ? drQRDetail["WQD_Lot"] : null;
                            DetailInfo.WeChatStatus = drQRDetail["WQD_WeChatStatus"] != DBNull.Value
                                ? drQRDetail["WQD_WeChatStatus"]
                                : null;
                            DetailInfo.DMSStatus = drQRDetail["WQD_DMSStatus"] != DBNull.Value
                                ? drQRDetail["WQD_DMSStatus"]
                                : null;
                            DetailInfo.Status = drQRDetail["WQD_Status"] != DBNull.Value
                                ? drQRDetail["WQD_Status"]
                                : null;
                            lstDetail.Add(DetailInfo);
                        }
                        data.DetailInfo = lstDetail;
                    }
                }

                handleResult.data = data;
                handleResult.success = true;
            }
            else
            {
                handleResult.msg = "扫描信息不存在。";
            }
            return handleResult;
        }

        public static HandleResult SubmitQRHeaderInfo(WeChatParams message)
        {
            string strQrHeaderNo = message.Parameters["QRHeaderNo"].ToString();
            string strDealerId = message.Parameters["DealerId"].ToString();
            string strUserId = message.Parameters["UserId"].ToString();
            string strUserName = message.Parameters["UserName"].ToString();
            string strRemark = message.Parameters["Remark"].ToString();

            HandleResult handleResult = new HandleResult { success = false, msg = string.Empty };

            try
            {
                DataSet dsQRHeader = bllWeChat.SelectWechatQRCodeHeader(strDealerId, strQrHeaderNo);
                if (null != dsQRHeader && dsQRHeader.Tables.Count > 0 && dsQRHeader.Tables[0].Rows.Count > 0)
                {
                    DataRow drQRHeader = dsQRHeader.Tables[0].Rows[0];
                    if (drQRHeader["WQH_ID"] == DBNull.Value)
                    {
                        handleResult.msg = "该单据信息不存在。";
                    }
                    else
                    {
                        string strHeaderId = drQRHeader["WQH_ID"].ToString();
                        DealerTransactionDataSet dealerTransactionDataSet = new DealerTransactionDataSet();
                        DealerTransactionDataRecord dealerTransactionDataRecord = new DealerTransactionDataRecord();
                        dealerTransactionDataRecord.DealerCode = drQRHeader["DMA_SAP_Code"].ToString();
                        dealerTransactionDataRecord.UserName = strUserName;
                        dealerTransactionDataRecord.DataType = "上报销量";
                        dealerTransactionDataRecord.Remark = !string.IsNullOrEmpty(strRemark)
                            ? strRemark
                            : strQrHeaderNo;
                        dealerTransactionDataRecord.UploadDate = DateTime.Now;
                        dealerTransactionDataRecord.Items = new List<DealerTransactionDataItem>();
                        DataSet dsQRDetail = bllWeChat.SelectWechatQRCodeDetail(strHeaderId);
                        if (null != dsQRDetail && dsQRDetail.Tables.Count > 0 && dsQRDetail.Tables[0].Rows.Count > 0)
                        {
                            foreach (DataRow drQRDetail in dsQRDetail.Tables[0].Rows)
                            {
                                DealerTransactionDataItem dealerTransactionDataItem = new DealerTransactionDataItem
                                {
                                    RowNo = int.Parse(drQRDetail["row_number"].ToString()),
                                    QRCode = drQRDetail["WQD_QRCode"].ToString(),
                                    LOT = drQRDetail["WQD_Lot"].ToString(),
                                    UPN = drQRDetail["WQD_UPN"].ToString()
                                };
                                dealerTransactionDataRecord.Items.Add(dealerTransactionDataItem);
                            }
                        }
                        dealerTransactionDataSet.Records = new List<DealerTransactionDataRecord>
                        {
                            dealerTransactionDataRecord
                        };
                        var AuthHeader = new BPPlatformService.AuthHeader()
                        {
                            User = Config.BPPlatformServiceUser,
                            Password = Config.BPPlatformServicePassword
                        };
                        string strXml = DataHelper.Serialize(dealerTransactionDataSet);

                        BPPlatformService.PlatformSoapClient soapBPPlatform =
                            new BPPlatformService.PlatformSoapClient();
                        string strResult = soapBPPlatform.UploadDealerTransaction(AuthHeader, strXml);
                        bool isDMSReceiveSuccess = strResult.Equals("<result><rtnVal>1</rtnVal></result>",
                            StringComparison.OrdinalIgnoreCase);
                        bllWeChat.UpdateWechatQRCodeInfo(strHeaderId, strResult, isDMSReceiveSuccess, strRemark);
                        handleResult.success = true;
                    }
                }
                else
                {
                    handleResult.msg = "扫描信息不存在。";
                }
            }
            catch (Exception ex)
            {
                handleResult.msg = string.Format("提交出错：{0}", ex.ToString());
            }
            return handleResult;
        }

        public static HandleResult ExportQRHeaderInfo(WeChatParams message)
        {
            string strDealerId = message.Parameters["DealerId"].ToString();
            string strHeaderId = message.Parameters["HeaderId"].ToString();
            HandleResult handleResult = new HandleResult { success = false, msg = string.Empty };
            try
            {
                DataSet dsQRInfo = bllWeChat.ExportWechatQRCodeInfo(strDealerId, strHeaderId);
                if (dsQRInfo != null)
                {
                    DataTable dt = dsQRInfo.Tables[0];
                    DataSet[] result = new DataSet[1];
                    result[0] = new DataSet();
                    result[0].Tables.Add(dt.Copy());

                    Hashtable ht = new Hashtable();
                    XlsExport xlsExport = new XlsExport("ExportFile");
                    string strFilePath = xlsExport.ExportWithoutDelete(ht, result);
                    handleResult.data = Path.GetFileName(strFilePath);
                    handleResult.success = true;
                }
            }
            catch (Exception ex)
            {
                handleResult.msg = string.Format("导出出错：{0}", ex.ToString());
            }
            return handleResult;
        }

        public static HandleResult InsertWechatQRCodeDetail(WeChatParams message)
        {
            string strQRCode = message.Parameters["QRCode"].ToString();
            string strHeaderId = message.Parameters["HeaderId"].ToString();
            string strUserId = message.Parameters["UserId"].ToString();

            HandleResult handleResult = new HandleResult { success = false, msg = string.Empty };
            Guid idDetail = Guid.Empty;
            bool isInsertSuccess = false;
            string strMessage = string.Empty;
            bllWeChat.InsertWechatQRCodeDetail(strQRCode, strHeaderId, strUserId, out idDetail, out isInsertSuccess, out strMessage);
            if (isInsertSuccess)
            {
                DataSet dsQRDetail = bllWeChat.SelectWechatQRCodeDetail(strHeaderId, idDetail.ToString());
                if (null != dsQRDetail && dsQRDetail.Tables.Count > 0 && dsQRDetail.Tables[0].Rows.Count > 0)
                {
                    dynamic data = new ExpandoObject();
                    List<ExpandoObject> lstDetail = new List<ExpandoObject>();
                    foreach (DataRow drQRDetail in dsQRDetail.Tables[0].Rows)
                    {
                        dynamic DetailInfo = new ExpandoObject();
                        DetailInfo.ID = drQRDetail["WQD_ID"] != DBNull.Value ? drQRDetail["WQD_ID"] : null;
                        DetailInfo.QRCode = drQRDetail["WQD_QRCode"] != DBNull.Value ? drQRDetail["WQD_QRCode"] : null;
                        DetailInfo.UPN = drQRDetail["WQD_UPN"] != DBNull.Value ? drQRDetail["WQD_UPN"] : null;
                        DetailInfo.Lot = drQRDetail["WQD_Lot"] != DBNull.Value ? drQRDetail["WQD_Lot"] : null;
                        DetailInfo.WeChatStatus = drQRDetail["WQD_WeChatStatus"] != DBNull.Value
                            ? drQRDetail["WQD_WeChatStatus"]
                            : null;
                        DetailInfo.DMSStatus = drQRDetail["WQD_DMSStatus"] != DBNull.Value
                            ? drQRDetail["WQD_DMSStatus"]
                            : null;
                        DetailInfo.Status = drQRDetail["WQD_Status"] != DBNull.Value ? drQRDetail["WQD_Status"] : null;
                        lstDetail.Add(DetailInfo);
                    }
                    data.DetailInfo = lstDetail;
                    handleResult.data = data;
                    handleResult.success = true;
                }
            }
            else
            {
                handleResult.msg = strMessage;
            }
            return handleResult;
        }

        public static HandleResult DeleteWechatQRCodeDetail(WeChatParams message)
        {
            string strDetailId = message.Parameters["DetailId"].ToString();
            string strUserId = message.Parameters["UserId"].ToString();
            HandleResult handleResult = new HandleResult { success = false, msg = string.Empty };
            if (bllWeChat.FakeDeleteWechatQRCodeDetail(strDetailId, strUserId))
            {
                handleResult.success = true;
            }
            else
            {
                handleResult.msg = "删除失败，请稍候再试";
            }
            return handleResult;
        }

        public static HandleResult SearchHeaderInfo(WeChatParams message)
        {
            string strKeyWord = message.Parameters["KeyWord"].ToString();
            string strDealerId = message.Parameters["DealerId"].ToString();

            HandleResult handleResult = new HandleResult { success = false, msg = string.Empty };

            DataSet dsQRHeader = bllWeChat.SelectWechatQRCodeHeader(strDealerId, string.Empty, strKeyWord);
            if (null != dsQRHeader && dsQRHeader.Tables.Count > 0 && dsQRHeader.Tables[0].Rows.Count > 0)
            {
                List<dynamic> lstData = new List<dynamic>();
                foreach (DataRow drQRHeader in dsQRHeader.Tables[0].Rows)
                {
                    dynamic data = new ExpandoObject();
                    data.No = drQRHeader["WQH_No"] != DBNull.Value ? drQRHeader["WQH_No"] : null;
                    data.ID = drQRHeader["WQH_ID"].ToString();
                    data.DetailCount = drQRHeader["DetailCount"] != DBNull.Value
                           ? drQRHeader["DetailCount"]
                           : null;
                    data.UploadStatus = drQRHeader["WQH_UploadStatus"] != DBNull.Value
                            ? drQRHeader["WQH_UploadStatus"]
                            : null;
                    lstData.Add(data);
                }
                handleResult.data = lstData;
                handleResult.success = true;
            }
            else
            {
                handleResult.msg = "单据不存在。";
            }
            return handleResult;
        }

        public static HandleResult DeleteHeaderInfo(WeChatParams message)
        {
            string strHeaderId = message.Parameters["HeaderId"].ToString();
            string strUserId = message.Parameters["UserId"].ToString();
            HandleResult handleResult = new HandleResult { success = false, msg = string.Empty };
            if (bllWeChat.FakeDeleteWechatQRCodeHeader(strHeaderId, strUserId))
            {
                handleResult.success = true;
            }
            else
            {
                handleResult.msg = "删除失败，请稍候再试";
            }
            return handleResult;
        }
        #endregion
    }
}