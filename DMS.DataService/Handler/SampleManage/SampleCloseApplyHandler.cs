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
    public class SampleCloseApplyHandler : UploadData
    {

        public SampleCloseApplyHandler(string headerId, out string result)
        {
            
            try
            {
                if (string.IsNullOrEmpty(headerId))
                {
                    throw new Exception("传入字符串为空");
                }
                
                PurchaseOrderBLL orderBLL = new PurchaseOrderBLL();
                PurchaseOrderHeader Header = orderBLL.GetOrderByOrderNo(headerId);
                if (Header == null)
                {
                    result = "<result><rtnVal>0</rtnVal><rtnMsg><![CDATA[申请号不存在]]></rtnMsg></result>";
                    return;
                }

                orderBLL.CloseLPOrder(Header.Id);

                result = "<result><rtnVal>1</rtnVal></result>";
            }
            catch (Exception ex)
            {
                result = ex.Message;
            }
        }
    }
}
