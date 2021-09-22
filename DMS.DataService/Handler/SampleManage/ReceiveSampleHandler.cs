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
using System.Data;

namespace DMS.DataService.Handler
{
    public class ReceiveSampleHandler : UploadData
    {
        public ReceiveSampleHandler(string clientid)
        {
            this.ClientID = clientid;
            this.Type = DataInterfaceType.SampleReceiveUploader;
            this.LoadData += new EventHandler<DataEventArgs>(ReceiveSampleHandler_LoadData);
        }

        //空格-32 \r-13 \n-10
        void ReceiveSampleHandler_LoadData(object sender, DataEventArgs e)
        {
            try
            {
                if (string.IsNullOrEmpty(e.ReturnXml))
                {
                    throw new Exception("传入字符串为空");
                }

                SoapReceiveSample soap = DataHelper.Deserialize<SoapReceiveSample>(e.ReturnXml);

                if (soap == null || soap.ReceiveSampleHead == null)
                {
                    throw new Exception("传入数据为空");
                }

                SampleApplyBLL sampleApplyBLL = new SampleApplyBLL();

                SampleApplyHead existsHead = sampleApplyBLL.GetSampleApplyHeadByApplyNo(soap.ReceiveSampleHead.ApplyNo);
                if (existsHead == null)
                {
                    e.ReturnXml = "<result><rtnVal>0</rtnVal><rtnMsg><![CDATA[申请号不存在]]></rtnMsg></result>";
                    e.Success = true;
                    return;
                }
                DataTable delivery = sampleApplyBLL.GetSampleApplyDelivery(soap.ReceiveSampleHead.ApplyNo, soap.ReceiveSampleHead.DeliveryNo);
                if (delivery == null || delivery.Rows.Count == 0)
                {
                    e.ReturnXml = "<result><rtnVal>0</rtnVal><rtnMsg><![CDATA[发货单号不存在]]></rtnMsg></result>";
                    e.Success = true;
                    return;
                }
                sampleApplyBLL.ReceiveSample(soap.ReceiveSampleHead.DeliveryNo);

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
