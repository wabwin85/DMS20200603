using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using DMS.Common;
using DMS.DataService.Core;
using DMS.Model.DataInterface;
using DMS.DataService.Util;
using DMS.Model;
using DMS.Business.DataInterface;
using DMS.Business;

namespace DMS.DataService.Handler
{
    public class DealerReturnConfirmUploader : UploadData
    {
        public DealerReturnConfirmUploader(string clientid)
        {
            this.ClientID = clientid;
            this.Type = DataInterfaceType.DealerReturnConfirmUploader;
            this.LoadData += new EventHandler<DataEventArgs>(DealerReturnConfirmUploader_LoadData);
        }

        //空格-32 \r-13 \n-10
        void DealerReturnConfirmUploader_LoadData(object sender, DataEventArgs e)
        {
            try
            {
                if (string.IsNullOrEmpty(e.ReturnXml))
                    throw new Exception("传入字符串为空");

                DealerReturnConfirmDataSet dataSet = DataHelper.Deserialize<DealerReturnConfirmDataSet>(e.ReturnXml);

                if (dataSet == null || dataSet.Records == null || dataSet.Records.Count == 0)
                    throw new Exception("传入数据为空");

                IList<InterfaceDealerReturnConfirm> importData = new List<InterfaceDealerReturnConfirm>();

                int line = 1;

                foreach (DealerReturnConfirmDataRecord record in dataSet.Records)
                {
                    foreach (DealerReturnConfirmDataItem item in record.Items)
                    {
                        String strQRCode = "";
                        if (String.IsNullOrEmpty(item.QRCode))
                        {
                            strQRCode = "NoQR";
                        }
                        //else if (item.QRCode.ToUpper().Contains("NOQR"))
                        //{
                        //    strQRCode = "NoQR";
                        //}
                        else
                        {
                            strQRCode = item.QRCode;
                        }

                        importData.Add(new InterfaceDealerReturnConfirm
                            {
                                Id = Guid.NewGuid(),
                                ReturnNo = record.ReturnNo,
                                ConfirmDate = record.ConfirmDate,
                                IsConfirm = record.IsConfirm,
                                Remark = record.Remark,
                                Upn = item.UPN,
                                Lot = item.Lot + "@@" + strQRCode,
                                WarehouseCode = item.WarehouseCode,
                                Qty = item.Qty,
                                LineNbr = line++,
                                ImportDate = DateTime.Now,
                                Clientid = this.ClientID,
                                BatchNbr = e.BatchNbr,
                                UnitPrice = item.UnitPrice,
                                IsEnd = item.IsEnd,
                                TaxRate = item.TaxRate
                            });
                    }

                }

                //导入接口表
                AdjustBLL business = new AdjustBLL();
                business.ImportInterfaceDealerReturnConfirm(importData);

                ////调用存储过程导入Warehouse表，并返回结果
                string RtnMsg = string.Empty;
                string RtnVal = string.Empty;
                business.HandleDealerReturnConfirmData(e.BatchNbr, this.ClientID, out RtnVal, out RtnMsg);

                ////如果调用过程失败则抛错
                if (!RtnVal.Equals("Success"))
                    throw new Exception(RtnMsg);

                ////如果调用过程成功，则检查是否存在未通过验证的数据
                IList<InterfaceDealerReturnConfirm> errList = business.SelectDealerReturnConfirmByBatchNbrErrorOnly(e.BatchNbr);

                if (errList != null && errList.Count > 0)
                {
                    //存在错误信息
                    e.ReturnXml = "<result><rtnVal>0</rtnVal><rtnMsg><![CDATA[{0}]]></rtnMsg></result>";
                    string errMsg = string.Empty;
                    foreach (InterfaceDealerReturnConfirm errItem in errList)
                    {
                        errMsg += "Line:" + errItem.LineNbr.ToString() + " " + errItem.ErrorMsg + "\r\n";
                    }
                    e.ReturnXml = string.Format(e.ReturnXml, errMsg);
                }
                else
                {
                    //不存在错误信息
                    e.ReturnXml = "<result><rtnVal>1</rtnVal></result>";
                }
                
                e.Message = string.Format("共获取{0}条数据", importData.Count);
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
