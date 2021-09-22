using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using DMS.DataService.Core;
using DMS.Common;
using DMS.Business;
using DMS.Model;
using DMS.DataService.Util;
using DMS.Business.DataInterface;
using DMS.Model.DataInterface;
using System.Data;

namespace DMS.DataService.Handler
{
    public class DMSCalculatedPointsDownloader : DownloadData
    {
        public DMSCalculatedPointsDownloader(string clientid)
        {
            this.ClientID = clientid;
            this.Type = DataInterfaceType.T2PointsDownloader;
            this.LoadData += new EventHandler<DataEventArgs>(DMSCalculatedPointsDownloader_LoadData);
        }
        void DMSCalculatedPointsDownloader_LoadData(object sender, DataEventArgs e)
        {
            TProOutLinePointsBLL business = new TProOutLinePointsBLL();
            try
            {
                try
                {
                    //生成XML
                    DataSet data = business.QueryDMSCalculatedPoints(this.ClientID);

                    //构造接口对象

                    IList<DMSCalculatedPointsRecord> list = new List<DMSCalculatedPointsRecord>();

                    foreach (DataRow row in data.Tables[0].Rows)
                    {
                        DMSCalculatedPointsRecord obj = new DMSCalculatedPointsRecord
                        {
                            Tier2DealerCode = row["Tier2DealerCode"].ToString(),
                            PolicyCode = row["PolicyCode"].ToString(),
                            PolicyName = row["PolicyName"].ToString(),
                            BSCBU = row["BSCBU"].ToString(),
                            AccountMonth = row["AccountMonth"].ToString(),
                            LargessDesc = row["LargessDesc"].ToString(),
                            PointsValidToDate = DateTime.Parse(row["PointsValidToDate"].ToString()),
                            PointsAmount = decimal.Parse(row["PointsAmount"].ToString()),
                            ProductLine = row["BSCBU"].ToString()
                        };
                        list.Add(obj);
                    }
                    var records = list.ToList<DMSCalculatedPointsRecord>();
                    DMSCalculatedPointsDataSet dataSet = new DMSCalculatedPointsDataSet { Records = records };
                    //序列化得到XML数据
                    e.ReturnXml = DataHelper.Serialize<DMSCalculatedPointsDataSet>(dataSet);

                    e.Success = true;
                    e.Message = string.Format("共获取{0}条订单数据", records.Count);
                }

                finally
                {
                    //更新接口状态
                    string rtnVal = string.Empty;
                    //business.AfterComplainDataDownload(e.BatchNbr, this.ClientID, e.Success ? "Success" : "Failure", out rtnVal);
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
