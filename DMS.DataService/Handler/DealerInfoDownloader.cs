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

namespace DMS.DataService.Handler
{
    public class DealerInfoDownloader : DownloadData
    {
        public DealerInfoDownloader(string clientid)
        {
            this.ClientID = clientid;
            this.Type = DataInterfaceType.DealerInfoDownloader;
            this.LoadData += new EventHandler<DataEventArgs>(DealerInfoDownloader_LoadData);
        }

        void DealerInfoDownloader_LoadData(object sender, DataEventArgs e)
        {
            IDealerMasters business = new DealerMasters();
            try
            {
                ////初始化接口数据
                //int cnt = business.InitLpDistributorInterfaceByClientID(this.ClientID, e.BatchNbr);

                //if (cnt <= 0)
                //    throw new Exception("没有可获取的记录");

                try
                {
                    //生成XML
                    IList<LpDistributorData> data = business.QueryLPDistributorInfo("");

                    //构造接口对象
                    var records = (from r in data

                                   select new LpDistributorDataRecord
                                        {
                                            DistributorID = r.DistributorID,
                                            DistributorName = r.DistributorName,
                                            DistributorType = r.DistributorType
                                        }).ToList<LpDistributorDataRecord>();

                    //foreach (var record in records)
                    //{
                    //    var items = (from item in data
                    //                 where item.DistributorID.Equals(record.DistributorID)
                    //                 select new LpDistributorDataItem
                    //                 {
                    //                     UPN = item.UPN,
                    //                     Lot = item.Lot,
                    //                     UnitPrice = item.UnitPrice,
                    //                     Qty = item.Qty
                    //                 }).ToList<LpDistributorDataItem>();
                    //    record.Items = items;
                    //}

                    LpDistributorDataSet dataSet = new LpDistributorDataSet { Count = records.Count, Records = records };
                    //序列化得到XML数据
                    e.ReturnXml = DataHelper.Serialize<LpDistributorDataSet>(dataSet);

                    e.Success = true;
                    e.Message = string.Format("共获取{0}条经销商数据", dataSet.Count);
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
                    //business.AfterLpDistributorInfoDownload(e.BatchNbr, this.ClientID, e.Success ? "Success" : "Failure", out rtnMsg);
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
