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
    public class T2AuthorizationDownloader : DownloadData
    {
        string DealerCode = "";

        public T2AuthorizationDownloader(string dealercode, string clientid)
        {
            DealerCode = dealercode;
            this.ClientID = clientid;
            this.Type = DataInterfaceType.T2AuthorizationDownloader;
            this.LoadData += new EventHandler<DataEventArgs>(T2AuthorizationDownloader_LoadData);
        }

        void T2AuthorizationDownloader_LoadData(object sender, DataEventArgs e)
        {
            Interfacet2ContactInfoDao business = new Interfacet2ContactInfoDao();
            try
            {
                try
                {
                    //生成XML
                    IList<T2AuthorizationData> data = business.SelectT2AuthorizationByCode(DealerCode);

                    //构造接口对象
                    var records = (from r in data
                                   group r by new
                                   {
                                       r.DistributorID,
                                       r.DistributorName
                                   }
                                       into g
                                   select new T2AuthorizationDataRecord
                                   {
                                       DistributorID = g.Key.DistributorID,
                                       DistributorName = g.Key.DistributorName
                                   }).ToList<T2AuthorizationDataRecord>();
                    foreach (var record in records)
                    {
                        var items = (from item in data
                                     where item.DistributorID.Equals(record.DistributorID)
                                     select new T2AuthorizationDataItem
                                     {
                                         HospitalCode = item.HospitalCode,
                                         HospitalName = item.HospitalName,
                                         BU = item.BU,
                                         ProductLine = item.ProductLine,
                                         SubBUCode = item.SubBUCode,
                                         SubBUName = item.SubBUName,
                                         AuthCode = item.AuthCode,
                                         AuthName = item.AuthName,
                                         AuthType = item.AuthType,
                                         AuthStartTime = item.AuthStartTime,
                                         AuthEndTime =item.AuthEndTime 
                                     }).ToList<T2AuthorizationDataItem>();
                        record.Items = items;
                    }

                    T2AuthorizationDataSet dataSet = new T2AuthorizationDataSet { Count = records.Count, Records = records };
                    //序列化得到XML数据
                    e.ReturnXml = DataHelper.Serialize<T2AuthorizationDataSet>(dataSet);

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