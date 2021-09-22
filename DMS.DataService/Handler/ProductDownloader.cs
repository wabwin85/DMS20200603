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
    public class ProductDownloader : DownloadData
    {
        public ProductDownloader(string clientid)
        {
            this.ClientID = clientid;
            this.Type = DataInterfaceType.ProductDownloader;
            this.LoadData += new EventHandler<DataEventArgs>(ProductDownloader_LoadData);
        }

        void ProductDownloader_LoadData(object sender, DataEventArgs e)
        {
            ICfns business = new Cfns();
            try
            {
                try
                {
                    //生成XML
                    IList<ProductData> data = business.QueryProductDataInfo();

                    //构造接口对象
                    var records = (from r in data

                                   select new ProductDataRecord
                                        {
                                            UPN = r.UPN,
                                            CNName = r.CNName,
                                            ENName = r.ENName,
                                            ProductLine = r.ProductLine,
                                            RegName = r.RegName,
                                            SourceArea = r.SourceArea
                                        }).ToList<ProductDataRecord>();


                    ProductDataSet dataSet = new ProductDataSet { Count = records.Count, Records = records };
                    //序列化得到XML数据
                    e.ReturnXml = DataHelper.Serialize<ProductDataSet>(dataSet);

                    e.Success = true;
                    e.Message = string.Format("共获取{0}条产品数据", dataSet.Count);
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
