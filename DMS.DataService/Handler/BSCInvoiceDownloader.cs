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
using DMS.Business;
using DMS.DataAccess;

namespace DMS.DataService.Handler
{
    public class BSCInvoiceDownloader: DownloadData
    {
        public BSCInvoiceDownloader(string clientid)
        {
            this.ClientID = clientid;
            this.Type = DataInterfaceType.BSCInvoiceDownloader;
            this.LoadData += new EventHandler<DataEventArgs>(BSCInvoiceDownloader_LoadData);
        }

        void BSCInvoiceDownloader_LoadData(object sender, DataEventArgs e)
        {
            TIIfInvoiceDao business = new TIIfInvoiceDao();
            try
            {
                try
                {
                    //生成XML
                    IList<BSCInvoiceData> data = business.QueryBSCInvoiceInfo(this.ClientID);

                    //构造接口对象
                    var records = (from r in data

                                   select new BSCInvoiceDataRecord
                                        {
                                            OrderNo = r.OrderNo,
                                            InvoiceNo = r.InvoiceNo,
                                            InvoiceDate = r.InvoiceDate,
                                            InvoiceAmount = r.InvoiceAmount,
                                            ID733 = r.ID733,
                                            DeliveryNo = r.DeliveryNo
                                        }).ToList<BSCInvoiceDataRecord>();


                    BSCInvoiceDataSet dataSet = new BSCInvoiceDataSet { Count = records.Count, Records = records };
                    //序列化得到XML数据
                    e.ReturnXml = DataHelper.Serialize<BSCInvoiceDataSet>(dataSet);

                    e.Success = true;
                    e.Message = string.Format("共获取{0}条波科发票信息数据", dataSet.Count);
                }
                catch (Exception innerException)
                {
                    e.Success = false;
                    throw innerException;
                }
                finally
                {
                    //更新接口状态
                    string rtnMsg = string.Empty;

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
