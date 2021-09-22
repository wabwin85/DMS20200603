using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Common.Logging;
using Fulper.TaskManager.TaskPlugin;
using Microsoft.Practices.EnterpriseLibrary.Common.Configuration;
using Microsoft.Practices.EnterpriseLibrary.Data;
using DMS.Business;
using DMS.Model;
using System.Threading;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections;
using System.IO;
using ICSharpCode.SharpZipLib.Zip;
using ICSharpCode.SharpZipLib.Checksums;

namespace DMS.TaskLib.DataMaster
{
    public class WMSInterfaceTask : ITask
    {
        //private static ILog _log = LogManager.GetLogger(typeof(AttachmentArchiveTask));
        private IDictionary<string, string> _config = null;

        public WMSInterfaceTask()
        {

        }
        #region ITask 成员
        public void Execute()
        {
            //string filePath = this._config["filePath"];

            IPurchaseOrderBLL _business = new PurchaseOrderBLL();
            string fileName = DateTime.Now.ToString("yyyyMMddHHmmss") + "_" + Guid.NewGuid().ToString();

            string txtFileName = @"E:\DMS_Purchase\" + fileName + ".txt";
            string zipFileName = @"E:\DMS_Purchase\" + fileName + ".zip";
            string zipFileNameBack = @"\\shacdmapp07\dms-purchase\" + fileName + ".zip";
            try
            {
                //Stp1: 更新需要同步订单标记
                Hashtable objStart = new Hashtable();
                objStart.Add("UpdateFlg", "1");
                objStart.Add("FromFlg", "0");
                _business.UpdateOrderWmsSendflg(objStart);

                //Stp2: 获取数据，生成文件
                DataSet ds = _business.GetPurchaseOrderWmsInfo();
                System.Text.StringBuilder builder = new System.Text.StringBuilder();
                if (ds != null && ds.Tables.Count > 0)
                {
                    System.Data.DataTable dt = ds.Tables[0];
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        builder.AppendLine(dt.Rows[i]["PO"] 
                                    + "|" + dt.Rows[i]["CustomerID"] 
                                    + "|" + dt.Rows[i]["DeliveryType"] 
                                    + "|" + dt.Rows[i]["IsStdShipto"] 
                                    + "|" + dt.Rows[i]["ShipToAddress"] 
                                    + "|" + dt.Rows[i]["Consignee"] 
                                    + "|" + dt.Rows[i]["Tel"] 
                                    + "|" + dt.Rows[i]["Carrier"] 
                                    + "|" + dt.Rows[i]["DivisionName"]);
                    }
                    if (dt.Rows.Count > 0)
                    {
                        using (FileStream file = new FileStream(txtFileName, FileMode.Create, FileAccess.Write))
                        {
                            using (TextWriter text = new System.IO.StreamWriter(file, System.Text.Encoding.Default))
                            {
                                text.Write(builder.ToString());
                            }
                        }

                        //Step3:压缩文件
                        ZipFile(txtFileName, zipFileName);

                        //拷贝文件
                        System.IO.File.Copy(zipFileName, zipFileNameBack, true);
                    }
                }

                // Step4:调整订单同步状态
                Hashtable objEnd = new Hashtable();
                objEnd.Add("UpdateFlg", "2");
                objEnd.Add("FromFlg", "1");
                _business.UpdateOrderWmsSendflg(objEnd);
            }
            catch (Exception ex)
            {
                //_log.Info(string.Format("Initialize WMSInterface failed, error Message:{0}", ex.ToString()));
                return;
            }
        }

        #endregion


        #region 压缩文建
        //// <summary>
        /// 压缩文件
        /// </summary>
        /// <param name="FileToZip">要进行压缩的文件名</param>
        /// <param name="ZipedFile">压缩后生成的压缩文件名</param>
        /// <returns></returns>
        private static bool ZipFile(string FileToZip, string ZipedFile)
        {
            //如果文件没有找到，则报错
            if (!File.Exists(FileToZip))
            {
                throw new System.IO.FileNotFoundException("指定要压缩的文件: " + FileToZip + " 不存在!");
            }
            FileStream ZipFile = null;
            ZipOutputStream ZipStream = null;
            ZipEntry ZipEntry = null;
            bool res = true;
            try
            {
                ZipFile = File.OpenRead(FileToZip);
                byte[] buffer = new byte[ZipFile.Length];
                ZipFile.Read(buffer, 0, buffer.Length);
                ZipFile.Close();
                ZipFile = File.Create(ZipedFile);
                ZipStream = new ZipOutputStream(ZipFile);
                ZipEntry = new ZipEntry(Path.GetFileName(FileToZip));
                ZipStream.PutNextEntry(ZipEntry);
                ZipStream.SetLevel(6);
                ZipStream.Write(buffer, 0, buffer.Length);
            }
            catch
            {
                res = false;
            }
            finally
            {
                if (ZipEntry != null)
                {
                    ZipEntry = null;
                }
                if (ZipStream != null)
                {
                    ZipStream.Finish();
                    ZipStream.Close();
                }
                if (ZipFile != null)
                {
                    ZipFile.Close();
                    ZipFile = null;
                }
                GC.Collect();
                GC.Collect(1);
            }
            return res;
        }
        #endregion

        #region ITask 成员

        public Dictionary<string, string> Config
        {
            set
            {
                this._config = value;
                //_log.Info("WMSInterfaceTask Config : Count = " + this._config.Count);
            }
        }

        #endregion
    }
}
