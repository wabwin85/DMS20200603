using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using DMS.Common;
using DMS.DataService.Util;

namespace DMS.DataService.Core
{
    public class UploadData : IUploadData
    {

        public event EventHandler<DataEventArgs> LoadData;


        public string ClientID { get; set; }
        public DataInterfaceType Type { get; set; }

        public UploadData()
        {

        }


        #region IUploadData 成员

        public string Execute(string strXml)
        {
            //根据ClientID和接口Type得到接口批处理号
            string batchNumber = DataHelper.GetBatchNumber(this.ClientID, this.Type);

            //开始处理接口，生成日志
            DataHelper.BeginInterfaceLog(batchNumber, this.ClientID, this.Type);

            try
            {

                DataEventArgs args = new DataEventArgs(batchNumber, strXml);
                //写入接口表
                if (LoadData != null)
                {
                    LoadData(this, args);

                    if (!args.Success)
                        throw new Exception(args.Message);
                }

                DataHelper.EndInterfaceLog(batchNumber, DataInterfaceLogStatus.Success, string.Format("输入：\r\n{0}\r\n结果：\r\n{1}", strXml, args.Message));

                return args.ReturnXml;
            }
            catch (Exception ex)
            {
                DataHelper.EndInterfaceLog(batchNumber, DataInterfaceLogStatus.Failure, string.Format("输入：\r\n{0}\r\n结果：\r\n{1}", strXml, ex.Message));
                throw ex;
            }
        }

        #endregion
    }
}
