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
    public class CreateSampleApplyHandler : UploadData
    {
        public CreateSampleApplyHandler(string clientid)
        {
            this.ClientID = clientid;
            this.Type = DataInterfaceType.SampleApplyUploader;
            this.LoadData += new EventHandler<DataEventArgs>(CreateSampleApplyHandler_LoadData);
        }

        //空格-32 \r-13 \n-10
        void CreateSampleApplyHandler_LoadData(object sender, DataEventArgs e)
        {
            try
            {
                if (string.IsNullOrEmpty(e.ReturnXml))
                {
                    throw new Exception("传入字符串为空");
                }

                SoapCreateSampleApply soap = DataHelper.Deserialize<SoapCreateSampleApply>(e.ReturnXml);

                if (soap == null || soap.SampleApplyHead == null)
                {
                    throw new Exception("传入数据为空");
                }

                //DealerMasters dealerMasterBll = new DealerMasters();
                SampleApplyBLL sampleApplyBLL = new SampleApplyBLL();

                SampleApplyHead applyHead = new SampleApplyHead();
                IList<SampleUpn> upnList = new List<SampleUpn>();
                IList<SampleTesting> testingList = new List<SampleTesting>();

                //测试样品经销商
                //IList<DealerMaster> dealerList = dealerMasterBll.GetSapCodeById("133897");
                //if (dealerList.Count == 0)
                //{
                //    e.ReturnXml = "<result><rtnVal>0</rtnVal><rtnMsg><![CDATA[找不到经销商]]></rtnMsg></result>";
                //    e.Success = true;
                //    return;
                //}
                SampleApplyHead existsHead = sampleApplyBLL.GetSampleApplyHeadByApplyNo(soap.SampleApplyHead.ApplyNo);
                if (existsHead != null)
                {
                    e.ReturnXml = "<result><rtnVal>0</rtnVal><rtnMsg><![CDATA[申请号已存在]]></rtnMsg></result>";
                    e.Success = true;
                    return;
                }

                applyHead.SampleApplyHeadId = Guid.NewGuid();
                applyHead.SampleType = soap.SampleApplyHead.SampleType;
                applyHead.ApplyNo = soap.SampleApplyHead.ApplyNo;
                applyHead.DealerId = new Guid("689FBD36-5B21-47CB-844D-4705303B01E8");
                applyHead.ApplyDate = soap.SampleApplyHead.ApplyDate;
                applyHead.ApplyUserId = soap.SampleApplyHead.ApplyUserID;
                applyHead.ApplyUser = soap.SampleApplyHead.ApplyUser;
                applyHead.ProcessUserId = soap.SampleApplyHead.ProcessUserID;
                applyHead.ProcessUser = soap.SampleApplyHead.ProcessUser;
                applyHead.ApplyDept = soap.SampleApplyHead.ApplyDept;
                applyHead.ApplyDivision = soap.SampleApplyHead.ApplyDivision;
                applyHead.CustType = soap.SampleApplyHead.CustType;
                applyHead.CustName = soap.SampleApplyHead.CustName;
                applyHead.ArrivalDate = soap.SampleApplyHead.ArrivalDate;
                applyHead.ApplyPurpose = soap.SampleApplyHead.ApplyPurpose;
                applyHead.ApplyCost = soap.SampleApplyHead.ApplyCost;
                applyHead.IrfNo = soap.SampleApplyHead.IrfNo;
                applyHead.HospName = soap.SampleApplyHead.HospName;
                applyHead.HpspAddress = soap.SampleApplyHead.HpspAddress;
                applyHead.TrialDoctor = soap.SampleApplyHead.TrialDoctor;
                applyHead.ReceiptUser = soap.SampleApplyHead.ReceiptUser;
                applyHead.ReceiptPhone = soap.SampleApplyHead.ReceiptPhone;
                applyHead.ReceiptAddress = soap.SampleApplyHead.ReceiptAddress;
                applyHead.DealerName = soap.SampleApplyHead.DealerName;
                applyHead.ApplyMemo = soap.SampleApplyHead.ApplyMemo;
                applyHead.ConfirmItem1 = soap.SampleApplyHead.ConfirmItem1;
                applyHead.ConfirmItem2 = soap.SampleApplyHead.ConfirmItem2;
                applyHead.ApplyStatus = SampleManageStatus.New.ToString();
                applyHead.CreateDate = DateTime.Now;
                applyHead.UpdateDate = DateTime.Now;
                applyHead.CreateUser = sampleApplyBLL.GetUserAccountByEID(soap.SampleApplyHead.ApplyUserID).Tables[0].Rows[0]["account"].ToString();


                decimal ApplyQuantity = 0;
                if (soap.SampleApplyHead.UpnList != null)
                {
                    for (int i = 0; i < soap.SampleApplyHead.UpnList.Length; i++)
                    {
                        SampleUpn upn = new SampleUpn();
                        upn.SampleUpnId = Guid.NewGuid();
                        upn.SampleHeadId = applyHead.SampleApplyHeadId;
                        upn.UpnNo = soap.SampleApplyHead.UpnList[i].UpnNo;
                        upn.Lot = soap.SampleApplyHead.UpnList[i].Lot;
                        upn.ProductName = soap.SampleApplyHead.UpnList[i].ProductName;
                        upn.ProductDesc = soap.SampleApplyHead.UpnList[i].ProductDesc;
                        upn.ApplyQuantity = Convert.ToDecimal(soap.SampleApplyHead.UpnList[i].ApplyQuantity);
                        ApplyQuantity += upn.ApplyQuantity.Value;
                        upn.LotReuqest = soap.SampleApplyHead.UpnList[i].LotReuqest;
                        upn.ProductMemo = soap.SampleApplyHead.UpnList[i].ProductMemo;
                        upn.SortNo = i + 1;
                        upn.CreateDate = DateTime.Now;
                        upn.UpdateDate = DateTime.Now;

                        upnList.Add(upn);
                    }
                }

                applyHead.ApplyQuantity = ApplyQuantity.ToString("F2");

                if (soap.SampleApplyHead.TestingList != null)
                {
                    for (int i = 0; i < soap.SampleApplyHead.TestingList.Length; i++)
                    {
                        SampleTesting testing = new SampleTesting();
                        testing.SampleTestingId = Guid.NewGuid();
                        testing.SampleHeadId = applyHead.SampleApplyHeadId;
                        testing.Division = soap.SampleApplyHead.TestingList[i].Division;
                        testing.Priority = soap.SampleApplyHead.TestingList[i].Priority;
                        testing.Certificate = soap.SampleApplyHead.TestingList[i].Certificate;
                        testing.CostCenter = soap.SampleApplyHead.TestingList[i].CostCenter;
                        testing.ArrivalDate = soap.SampleApplyHead.TestingList[i].ArrivalDate;
                        testing.Irf = soap.SampleApplyHead.TestingList[i].Irf;
                        testing.Ra = soap.SampleApplyHead.TestingList[i].Ra;
                        testing.SortNo = i + 1;
                        testing.CreateDate = DateTime.Now;
                        testing.UpdateDate = DateTime.Now;

                        testingList.Add(testing);
                    }
                }

                sampleApplyBLL.CreateSampleApply(applyHead, upnList, testingList);

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
