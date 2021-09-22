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

namespace DMS.DataService.Handler
{
    public class SapDeliveryUploaderNew : UploadData
    {
        public SapDeliveryUploaderNew(string clientid)
        {
            this.ClientID = clientid;
            this.Type = DataInterfaceType.SapDeliveryUploader;
            this.LoadData += new EventHandler<DataEventArgs>(SapDeliveryUploader_LoadData);
        }

        //空格-32 \r-13 \n-10
        void SapDeliveryUploader_LoadData(object sender, DataEventArgs e)
        {
            try
            {
                if (string.IsNullOrEmpty(e.ReturnXml))
                {
                    throw new Exception("传入数据为空");                    
                }
                else
                {
                    SapDeliveryDataSetNew dataSet = DataHelper.Deserialize<SapDeliveryDataSetNew>(e.ReturnXml);
                    if (dataSet == null || dataSet.Records == null || dataSet.Records.Count == 0)
                        throw new Exception("传入数据为空");

                    IList<InterfaceShipment> importData = new List<InterfaceShipment>();
                    int line = 1;

                    foreach (SapDeliveryDataRecordNew record in dataSet.Records)
                    {
                        foreach (SapDeliveryDataItemNew item in record.Items)
                        {
                            importData.Add(new InterfaceShipment
                            {
                                Id = Guid.NewGuid(),
                                DealerSapCode = record.DistributorID,
                                OrderNo = item.OrderNo,
                                SapDeliveryNo = record.DeliveryNo,
                                SapDeliveryDate = record.DeliveryDate,
                                ShipmentType = record.Type,
                                ExpressCompany = record.ExpressCompany,
                                ExpressNo = record.ExpressNo,
                                ShipType = record.ShipType,
                                ArticleNumber = item.UPN,
                                LotNumber = item.Lot,
                                ExpiredDate = item.ExpDate,
                                DeliveryQty = item.Qty,
                                UnitPrice = item.UnitPrice,
                                ShippingDate = item.DomDate,
                                LineNbr = line++,
                                ImportDate = DateTime.Now,
                                Clientid = this.ClientID,
                                BatchNbr = e.BatchNbr,
                                ToWhmCode = item.WHMCode,  //Add By SongWeiming on 2015-06-03 对于寄售转销售，需要使用此字段，用于记录寄售仓库
                                QrCode = item.QRCode,      //Add By SongWeiming on 2016-01-04 二维码功能改造
                                TaxRate = item.TaxRate,     //Add By SongWeiming on 2018-08-30 增加税率
                                ERPLineNbr = item.ERPLineNbr,
                                ERPAmount = item.ERPAmount,
                                ERPTaxRate = item.ERPTaxRate,
                                ERPNbr = record.ERPNbr
                            });
                        }
                    }

                    //导入接口表
                    DeliveryBLL business = new DeliveryBLL();
                    business.ImportInterfaceShipment(importData);

                    //调用存储过程导入DeliveryNote表，并返回结果
                    string RtnMsg = string.Empty;
                    string IsValid = string.Empty;
                    business.HandleShipmentData(e.BatchNbr, this.ClientID, out IsValid, out RtnMsg);
                    //business.HandleShipmentT2NormalData(e.BatchNbr, this.ClientID, out IsValid, out RtnMsg);
                    //如果调用过程失败则抛错
                    if (!IsValid.Equals("Success"))
                        throw new Exception(RtnMsg);

                    //如果调用过程成功，则检查是否存在未通过验证的数据
                    IList<DeliveryNote> errList = business.SelectDeliveryNoteByBatchNbrErrorOnly(e.BatchNbr);

                    if (errList != null && errList.Count > 0)
                    {
                        //存在错误信息
                        e.ReturnXml = "<result><rtnVal>0</rtnVal><rtnMsg>{0}</rtnMsg></result>";
                        string errMsg = string.Empty;
                        foreach (DeliveryNote errItem in errList)
                        {
                            errMsg += "Line:" + errItem.SapDeliveryLineNbr + " " + errItem.ProblemDescription + "\r\n";
                        }
                        e.ReturnXml = string.Format(e.ReturnXml, errMsg);
                    }
                    else
                    {
                        //不存在错误信息
                        e.ReturnXml = "<result><rtnVal>1</rtnVal><rtnMsg></rtnMsg></result>";
                    }


                    e.Message = string.Format("共获取{0}条SAP发货数据", importData.Count);
                    e.Success = true;
                }
            }
            catch (Exception ex)
            {
                e.Success = false;
                e.Message = ex.Message;
            }
        }
    }
}
