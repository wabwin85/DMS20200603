using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using DMS.Common;
using DMS.DataService.Core;
using DMS.Model.DataInterface;
using DMS.DataService.Util;
using DMS.Model;
using DMS.Business.DataInterface;
using DMS.Business;
using DMS.DataAccess.DataInterface;

namespace DMS.DataService.Handler
{
    public class T2ContactInfoUploader: UploadData
    {
        public T2ContactInfoUploader(string clientid)
        {
            this.ClientID = clientid;
            this.Type = DataInterfaceType.T2ContactInfoUploader;
            this.LoadData += new EventHandler<DataEventArgs>(T2ContactInfoUploader_LoadData);
        }

        void T2ContactInfoUploader_LoadData(object sender, DataEventArgs e)
        {
            try
            {
                if (string.IsNullOrEmpty(e.ReturnXml))
                    throw new Exception("传入字符串为空");

                T2ContractInfoDataSet dataSet = DataHelper.Deserialize<T2ContractInfoDataSet>(e.ReturnXml);

                if (dataSet == null || dataSet.Records == null || dataSet.Records.Count == 0)
                    throw new Exception("传入数据为空");

                IList<Interfacet2ContactInfo> importData = new List<Interfacet2ContactInfo>();

                int line = 1;

                foreach (T2ContractInfoDataRecord record in dataSet.Records)
                {
                    foreach (T2ContractInfoDataItem item in record.Items)
                    {
                        importData.Add(new Interfacet2ContactInfo
                        {
                            Id = Guid.NewGuid(),
                            Distributorid = record.DistributorID,
                            DistributorName = record.DistributorName,
                            Position = item.Position,
                            Contract = item.Contact,
                            Phone = item.Phone,
                            Mobile = item.Mobile,
                            Remark = item.Remark,
                            Address = item.Address,
                            Email = item.EMail,
                            LineNbr = line++,
                            ImportDate = DateTime.Now,
                            Clientid = this.ClientID,
                            BatchNbr = e.BatchNbr
                        });
                    }

                }

                //导入接口表
                Interfacet2ContactInfoDao business = new Interfacet2ContactInfoDao();
                foreach (Interfacet2ContactInfo item in importData)
                {
                    business.Insert(item);
                }
                

                ////调用存储过程导入Interfacet2ContactInfo表，并返回结果
                string RtnMsg = string.Empty;
                string RtnVal = string.Empty;
                business.HandleInterfacet2ContactInfoData(e.BatchNbr, this.ClientID, out RtnVal, out RtnMsg);

                ////如果调用过程失败则抛错
                if (!RtnVal.Equals("Success"))
                    throw new Exception(RtnMsg);

                ////如果调用过程成功，则检查是否存在未通过验证的数据
                IList<Interfacet2ContactInfo> errList = business.SelectInterfacet2ContactInfoByBatchNbrErrorOnly(e.BatchNbr);

                if (errList != null && errList.Count > 0)
                {
                    //存在错误信息
                    e.ReturnXml = "<result><rtnVal>0</rtnVal><rtnMsg><![CDATA[{0}]]></rtnMsg></result>";
                    string errMsg = string.Empty;
                    foreach (Interfacet2ContactInfo errItem in errList)
                    {
                        errMsg += "Line:" + errItem.LineNbr.ToString() + " " + errItem.ErrorMsg + "\r\n";
                    }
                    e.ReturnXml = string.Format(e.ReturnXml, errMsg);
                }
                else
                {
                    //不存在错误信息
                    e.ReturnXml = "<result><rtnVal>1</rtnVal></result>";
                }

                e.Message = string.Format("共获取{0}条数据", importData.Count);
                e.Success = true;

            }
            catch (Exception ex)
            {
                e.Success = false;
                e.Message = ex.Message;
            }
        }
    }

}