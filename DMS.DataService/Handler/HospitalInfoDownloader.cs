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
    public class HospitalInfoDownloader : DownloadData
    {
        public HospitalInfoDownloader(string clientid)
        {
            this.ClientID = clientid;
            this.Type = DataInterfaceType.HospitalInfoDownloader;
            this.LoadData += new EventHandler<DataEventArgs>(HospitalInfoDownloader_LoadData);
        }

        void HospitalInfoDownloader_LoadData(object sender, DataEventArgs e)
        {
            IHospitals business = new Hospitals();
            try
            {
                ////初始化接口数据
                //int cnt = business.InitLpHospitalInterfaceByClientID(this.ClientID, e.BatchNbr);

                //if (cnt <= 0)
                //    throw new Exception("没有可获取的记录");

                try
                {
                    //生成XML
                    IList<LpHospitalData> data = business.QueryLPHospitalInfo(ClientID.ToString());

                    //构造接口对象
                    var records = (from r in data
                                  
                                       select new LpHospitalDataRecord
                                       {
                                          HospitalID=r.HospitalID,
                                          HospitalName=r.HospitalName,
                                          CityName=r.CityName
                                       }).ToList<LpHospitalDataRecord>();

                    //foreach (var record in records)
                    //{
                    //    var items = (from item in data
                    //                 where item.DistributorID.Equals(record.DistributorID)
                    //                 select new LpHospitalDataItem
                    //                 {
                    //                     UPN = item.UPN,
                    //                     Lot = item.Lot,
                    //                     UnitPrice = item.UnitPrice,
                    //                     Qty = item.Qty
                    //                 }).ToList<LpHospitalDataItem>();
                    //    record.Items = items;
                    //}

                    LpHospitalDataSet dataSet = new LpHospitalDataSet { Count = records.Count, Records = records };
                    //序列化得到XML数据
                    e.ReturnXml = DataHelper.Serialize<LpHospitalDataSet>(dataSet);

                    e.Success = true;
                    e.Message = string.Format("共获取{0}条医院数据", dataSet.Count);
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
                   // business.AfterLpHospitalInfoDownload(e.BatchNbr, this.ClientID, e.Success ? "Success" : "Failure", out rtnMsg);
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
