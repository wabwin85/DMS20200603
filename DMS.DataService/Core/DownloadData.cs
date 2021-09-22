using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using DMS.Common;
using DMS.DataService.Util;

namespace DMS.DataService.Core
{
    public class DownloadData : IDownloadData
    {
        public event EventHandler<DataEventArgs> LoadData;


        public string ClientID { get; set; }
        public DataInterfaceType Type { get; set; }

        public DownloadData()
        {

        }
        
        #region IDownloadData 成员

        public string Execute()
        {
            //下载数据xml格式
            string rtnXml = string.Empty;

            //根据ClientID和接口Type得到接口批处理号
            string batchNumber = DataHelper.GetBatchNumber(this.ClientID, this.Type);

            //开始处理接口，生成日志
            DataHelper.BeginInterfaceLog(batchNumber, this.ClientID, this.Type);

            try
            {
                DataEventArgs args = new DataEventArgs(batchNumber);
                if (LoadData != null)
                {
                    LoadData(this, args);

                    if (!args.Success)
                        throw new Exception(args.Message);

                    rtnXml = args.ReturnXml;
                }

                DataHelper.EndInterfaceLog(batchNumber, DataInterfaceLogStatus.Success, string.Format("输出：\r\n{0}\r\n结果：\r\n{1}", rtnXml, args.Message));
            }
            catch(Exception ex)
            {
                DataHelper.EndInterfaceLog(batchNumber, DataInterfaceLogStatus.Failure, string.Format("输出：\r\n{0}\r\n结果：\r\n{1}", rtnXml, ex.Message));
                throw ex;
            }

            return rtnXml;
        }

        #endregion
    }
}
