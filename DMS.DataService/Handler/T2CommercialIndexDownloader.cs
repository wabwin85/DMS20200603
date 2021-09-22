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
using System.Collections;
using DMS.Model.DataInterface;
using DMS.DataAccess;
using DMS.DataAccess.DataInterface;

namespace DMS.DataService.Handler
{
    public class T2CommercialIndexDownloader : DownloadData
    {
        string DealerCode = "";

        public T2CommercialIndexDownloader(string dealercode, string clientid)
        {
            DealerCode = dealercode;
            this.ClientID = clientid;
            this.Type = DataInterfaceType.T2CommercialIndexDownloader;
            this.LoadData += new EventHandler<DataEventArgs>(T2CommercialIndexDownloader_LoadData);
        }

        void T2CommercialIndexDownloader_LoadData(object sender, DataEventArgs e)
        {
            Interfacet2ContactInfoDao business = new Interfacet2ContactInfoDao();
            try
            {
                try
                {
                    //生成XML
                    IList<T2CommercialIndexData> data = business.SelectT2CommercialIndexByCode(DealerCode);

                    //构造接口对象
                    var records = (from r in data
                                   group r by new
                                   {
                                       r.DistributorID,
                                       r.DistributorName
                                   }
                                       into g
                                   select new T2CommercialIndexDataRecord
                                   {
                                       DistributorID = g.Key.DistributorID,
                                       DistributorName = g.Key.DistributorName
                                   }).ToList<T2CommercialIndexDataRecord>();
                    foreach (var record in records)
                    {
                        var items = (from item in data
                                     where item.DistributorID.Equals(record.DistributorID)
                                     select new T2CommercialIndexDataItem
                                     {
                                         BU = item.BU,
                                         ProductLine =item.ProductLine,
                                         SubBUCode = item.SubBUCode,
                                         SubBUName = item.SubBUName,
                                         StartTime = item.StartTime,
                                         EndTime = item.EndTime,
                                         MarketType = item.MarketType,
                                         Year = item.Year,
                                         Month1 = item.Month1,
                                         Month2 = item.Month2,
                                         Month3 = item.Month3,
                                         Month4 = item.Month4,
                                         Month5 = item.Month5,
                                         Month6 = item.Month6,
                                         Month7 = item.Month7,
                                         Month8 = item.Month8,
                                         Month9 = item.Month9,
                                         Month10 = item.Month10,
                                         Month11 = item.Month11,
                                         Month12 = item.Month12,
                                         Amount = item.Amount,
                                     }).ToList<T2CommercialIndexDataItem>();
                        record.Items = items;
                    }

                    T2CommercialIndexDataSet dataSet = new T2CommercialIndexDataSet { Count = records.Count, Records = records };
                    //序列化得到XML数据
                    e.ReturnXml = DataHelper.Serialize<T2CommercialIndexDataSet>(dataSet);

                    e.Success = true;
                    e.Message = string.Format("共获取{0}条经销商库存信息数据", dataSet.Count);
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
