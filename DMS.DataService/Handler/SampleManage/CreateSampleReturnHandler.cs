using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using DMS.DataService.Core;
using DMS.Common;
using System.Text;
using System.Globalization;
using DMS.Model;
using DMS.Business.DataInterface;
using DMS.DataService.Util;
using DMS.Model.DataInterface;
using DMS.Model.DataInterface.SampleManage;
using DMS.Business;

namespace DMS.DataService.Handler
{
    public class CreateSampleReturnHandler : UploadData
    {
        public CreateSampleReturnHandler(string clientid)
        {
            this.ClientID = clientid;
            this.Type = DataInterfaceType.SampleReturnUploader;
            this.LoadData += new EventHandler<DataEventArgs>(CreateSampleReturnHandler_LoadData);
        }

        //空格-32 \r-13 \n-10
        void CreateSampleReturnHandler_LoadData(object sender, DataEventArgs e)
        {
            try
            {
                if (string.IsNullOrEmpty(e.ReturnXml))
                {
                    throw new Exception("传入字符串为空");
                }

                SoapCreateSampleReturn soap = DataHelper.Deserialize<SoapCreateSampleReturn>(e.ReturnXml);

                if (soap == null || soap.SampleReturnHead == null)
                {
                    throw new Exception("传入数据为空");
                }

                DealerMasters dealerMasterBll = new DealerMasters();
                SampleApplyBLL sampleApplyBLL = new SampleApplyBLL();

                SampleReturnHead applyHead = new SampleReturnHead();
                IList<SampleUpn> upnList = new List<SampleUpn>();

                //测试样品经销商
                IList<DealerMaster> dealerList = dealerMasterBll.GetSapCodeById("133897");
                if (dealerList.Count == 0)
                {
                    e.ReturnXml = "<result><rtnVal>0</rtnVal><rtnMsg><![CDATA[找不到经销商]]></rtnMsg></result>";
                    e.Success = true;
                    return;
                }
                SampleReturnHead existsHead = sampleApplyBLL.GetSampleReturnHeadByReturnNo(soap.SampleReturnHead.ReturnNo);
                if (existsHead != null)
                {
                    e.ReturnXml = "<result><rtnVal>0</rtnVal><rtnMsg><![CDATA[退货号已存在]]></rtnMsg></result>";
                    e.Success = true;
                    return;
                }

                String errMsg = "";

                applyHead.SampleReturnHeadId = Guid.NewGuid();
                applyHead.SampleType = soap.SampleReturnHead.SampleType;
                applyHead.ReturnNo = soap.SampleReturnHead.ReturnNo;
                applyHead.DealerId = dealerList[0].Id;
                applyHead.ReturnRequire = soap.SampleReturnHead.ReturnRequire;
                applyHead.ReturnDate = soap.SampleReturnHead.ReturnDate;
                applyHead.ReturnUserId = soap.SampleReturnHead.ReturnUserID;
                applyHead.ReturnUser = soap.SampleReturnHead.ReturnUser;
                applyHead.ProcessUserId = soap.SampleReturnHead.ProcessUserID;
                applyHead.ProcessUser = soap.SampleReturnHead.ProcessUser;
                applyHead.ReturnHosp = soap.SampleReturnHead.ReturnHosp;
                applyHead.ReturnDept = soap.SampleReturnHead.ReturnDept;
                applyHead.ReturnDivision = soap.SampleReturnHead.ReturnDivision;
                applyHead.DealerName = soap.SampleReturnHead.DealerName;
                applyHead.ReturnReason = soap.SampleReturnHead.ReturnReason;
                applyHead.ReturnMemo = soap.SampleReturnHead.ReturnMemo;
                applyHead.ReturnStatus = SampleManageStatus.New.ToString();
                applyHead.CreateDate = DateTime.Now;
                applyHead.UpdateDate = DateTime.Now;
                applyHead.CreateUser = sampleApplyBLL.GetUserAccountByEID(soap.SampleReturnHead.ReturnUserID).Tables[0].Rows[0]["account"].ToString();

                if (soap.SampleReturnHead.UpnList != null && soap.SampleReturnHead.UpnList.Length > 0)
                    applyHead.ApplyNo = soap.SampleReturnHead.UpnList[0].ApplyNo;

                decimal ReturnQuantity = 0;
                if (soap.SampleReturnHead.UpnList != null)
                {
                    for (int i = 0; i < soap.SampleReturnHead.UpnList.Length; i++)
                    {
                        SampleApplyHead apply = sampleApplyBLL.GetSampleApplyHeadByApplyNo(soap.SampleReturnHead.UpnList[i].ApplyNo);
                        if (apply == null)
                        {
                            errMsg += "申请单号(" + soap.SampleReturnHead.UpnList[i].ApplyNo + ")不存在\r\n";
                        }

                        SampleUpn upn = new SampleUpn();
                        upn.SampleUpnId = Guid.NewGuid();
                        upn.SampleHeadId = applyHead.SampleReturnHeadId;
                        upn.ApplyNo = soap.SampleReturnHead.UpnList[i].ApplyNo;
                        upn.UpnNo = soap.SampleReturnHead.UpnList[i].UpnNo;
                        upn.Lot = soap.SampleReturnHead.UpnList[i].Lot;
                        upn.ProductName = soap.SampleReturnHead.UpnList[i].ProductName;
                        upn.ProductDesc = soap.SampleReturnHead.UpnList[i].ProductDesc;
                        upn.ApplyQuantity = Convert.ToDecimal(soap.SampleReturnHead.UpnList[i].ApplyQuantity);
                        ReturnQuantity += upn.ApplyQuantity.Value;
                        upn.LotReuqest = soap.SampleReturnHead.UpnList[i].LotReuqest;
                        upn.ProductMemo = soap.SampleReturnHead.UpnList[i].ProductMemo;
                        upn.SortNo = i + 1;
                        upn.CreateDate = DateTime.Now;
                        upn.UpdateDate = DateTime.Now;

                        upnList.Add(upn);
                    }
                }

                applyHead.ReturnQuantity = ReturnQuantity.ToString("F2");

                if (!String.IsNullOrEmpty(errMsg))
                {
                    e.ReturnXml = string.Format("<result><rtnVal>0</rtnVal><rtnMsg><![CDATA[{0}]]></rtnMsg></result>", errMsg);
                    e.Success = true;
                    return;
                }

                sampleApplyBLL.CreateSampleReturn(applyHead, upnList);

                e.ReturnXml = "<result><rtnVal>1</rtnVal></result>";

                e.Success = true;
            }
            catch (Exception ex)
            {
                e.Success = false;
                e.Message = ex.Message;
            }
        }
    }
}
