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

namespace DMS.DataService.Handler
{
    public class SapDeliveryUploader : UploadData
    {
        public SapDeliveryUploader(string clientid)
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
                    throw new Exception("传入字符串为空");
                //char[] charArray = e.ReturnXml.ToCharArray();
                //StringBuilder sb = new StringBuilder();
                //foreach (char c in charArray)
                //{
                //    System.Diagnostics.Debug.WriteLine("FormatString char = " + c.ToString() + " ASCII = " + ((short)c).ToString());
                //}

                //将传入字符串转换为行,首尾字符（"）去除
                string[] strArr = e.ReturnXml.Substring(1, e.ReturnXml.Length - 2).Split(new string[] { "\n", "\r", "\r\n" }, StringSplitOptions.RemoveEmptyEntries);

                if (strArr.Length == 1)
                    throw new Exception("发货单不包含明细行");

                //第一行为表头：发货单号、日期、经销商客户号
                string[] header = strArr[0].Split(new char[] { '|' });
                if (header.Length != 3)
                    throw new Exception("发货单表头数据格式不正确");

                string deliveryNo = header[0];
                DateTime deliveryDate;
                if (!DateTime.TryParseExact(header[1], "yyyyMMdd", CultureInfo.InvariantCulture, DateTimeStyles.None, out deliveryDate))
                    throw new Exception("发货单表头日期格式不正确");

                string dealerSapCode = header[2];

                IList<InterfaceShipment> importData = new List<InterfaceShipment>();

                //处理明细行
                for (int i = 1; i < strArr.Length; i++)
                {
                    string[] detail = strArr[i].Split(new char[] { '|' });
                    if (detail.Length != 6)
                        throw new Exception(string.Format("第{0}行数据格式不正确", i));
                    //UPN
                    string upn = detail[0];
                    //QYT
                    decimal qty;
                    if (!Decimal.TryParse(detail[1], out qty))
                        throw new Exception(string.Format("第{0}行发货数量格式不正确", i));
                    //LOT
                    string lot = detail[2];

                    //DOM
                    DateTime? dom;
                    if (!string.IsNullOrEmpty(detail[3]))
                    {
                        DateTime convDOM;
                        if (!DateTime.TryParseExact(detail[3], "yyyyMMdd", CultureInfo.InvariantCulture, DateTimeStyles.None, out convDOM))
                        {
                            throw new Exception(string.Format("第{0}行生产日期格式不正确", i));
                        }
                        else
                        {
                            dom = convDOM;
                        }
                    }
                    else
                    {
                        dom = null;
                    }

                    //EXPIRY
                    DateTime expiry;
                    if (!DateTime.TryParseExact(detail[4], "yyyyMMdd", CultureInfo.InvariantCulture, DateTimeStyles.None, out expiry))
                        throw new Exception(string.Format("第{0}行有效期格式不正确", i));
                    //ORDERNO
                    string orderNo = detail[5];

                    importData.Add(new InterfaceShipment
                    {
                        Id = Guid.NewGuid(),
                        DealerSapCode = dealerSapCode,
                        OrderNo = orderNo,
                        SapDeliveryNo = deliveryNo,
                        SapDeliveryDate = deliveryDate,
                        ArticleNumber = upn,
                        LotNumber = lot,
                        ShippingDate = dom,
                        ExpiredDate = expiry,
                        DeliveryQty = qty,
                        LineNbr = i,
                        ImportDate = DateTime.Now,
                        Clientid = this.ClientID,
                        BatchNbr = e.BatchNbr
                    });
                }

                //导入接口表
                DeliveryBLL business = new DeliveryBLL();
                business.ImportInterfaceShipment(importData);

                //调用存储过程导入DeliveryNote表，并返回结果
                string RtnMsg = string.Empty;
                string IsValid = string.Empty;
                business.HandleShipmentData(e.BatchNbr, this.ClientID, out IsValid, out RtnMsg);

                //如果调用过程失败则抛错
                if (!IsValid.Equals("Success"))
                    throw new Exception(RtnMsg);

                //如果调用过程成功，则检查是否存在未通过验证的数据
                IList<DeliveryNote> errList = business.SelectDeliveryNoteByBatchNbrErrorOnly(e.BatchNbr);

                if (errList != null && errList.Count > 0)
                {
                    //存在错误信息
                    e.ReturnXml = "<result><rtnVal>0</rtnVal><rtnMsg><![CDATA[{0}]]></rtnMsg></result>";
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
                    e.ReturnXml = "<result><rtnVal>1</rtnVal></result>";
                }


                e.Message = string.Format("共获取{0}条SAP发货数据", importData.Count);
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
