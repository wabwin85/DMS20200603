using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Common.Logging;
using Fulper.TaskManager.TaskPlugin;
using Microsoft.Practices.EnterpriseLibrary.Common.Configuration;
using DMS.Business;
using DMS.Model;
using System.Threading;
using DMS.Model.Data;
using System.IO;
using System.Data;

namespace DMS.TaskLib.DataMaster
{
    public class AttachmentArchiveTask : ITask
    {
        //private static ILog _log = LogManager.GetLogger(typeof(AttachmentArchiveTask));
        private IDictionary<string, string> _config = null;

        #region 短信发送属性
        private int Total = 30;
        private object sender;
        #endregion

        public AttachmentArchiveTask()
        {

        }

        #region ITask 成员

        public void Execute()
        {
            AttachmentBLL business = new AttachmentBLL();
            DataSet ds = null;
            DataTable attachmentDt = null;
            //初始化附件的队列
            try
            {
                //_log.Info("Initializing Attachment!");
                ds = business.QueryAttachmentForShipmentAttachment(AttachmentType.ShipmentToHospital);
                if (ds != null && ds.Tables.Count > 0)
                {
                    attachmentDt = ds.Tables[0];
                }
                //_log.Info("Initialize Attachment success.");
            }
            catch (Exception ex)
            {
                //_log.Info(string.Format("Initialize Attachment failed, error Message:{0}", ex.ToString()));
                return;
            }

            //判断是否有待归档的附件
            if (attachmentDt == null || attachmentDt.Rows.Count == 0)
            {
                //_log.Info("No Attachment can be Archive!");
                return;
            }

            //附件归档
            int size = attachmentDt.Rows.Count;// > Total ? Total : attachmentDt.Rows.Count;

            //string sourceUrl = @"E:\work\BSC_DMS\TFS\DMS\Code\Dev\DMS\DMS.Website\Upload\UploadFile\ShipmentAttachment\";
            string sourceUrl = @"E:\APP_PRD\DMS\DMS20140616\Upload\UploadFile\ShipmentAttachment\";
            string targetUrl = @"F:\DMS_Invoice\";

            UploadLog uploadLog = null;
            bool isExistsFile = false;
            try
            {
                foreach (DataRow dr in attachmentDt.Rows)
                {
                    StringBuilder directoryUrl = new StringBuilder();
                    directoryUrl.Append(targetUrl);

                    //1、BU
                    directoryUrl.Append(dr["DivisionName"].ToString());
                    if (!Directory.Exists(directoryUrl.ToString()))
                    {
                        Directory.CreateDirectory(directoryUrl.ToString());
                    }

                    //2、上级
                    directoryUrl.Append(@"\" + dr["ParentName"].ToString());
                    if (!Directory.Exists(directoryUrl.ToString()))
                    {
                        Directory.CreateDirectory(directoryUrl.ToString());
                    }

                    //3、经销商中文名
                    directoryUrl.Append(@"\" + dr["DealerShortName"].ToString());
                    if (!Directory.Exists(directoryUrl.ToString()))
                    {
                        Directory.CreateDirectory(directoryUrl.ToString());
                    }

                    //4、医院中文名
                    directoryUrl.Append(@"\" + dr["HospitalShortName"].ToString());
                    if (!Directory.Exists(directoryUrl.ToString()))
                    {
                        Directory.CreateDirectory(directoryUrl.ToString());
                    }

                    //5、用量日期yyyyMM
                    directoryUrl.Append(@"\" + dr["ShipmentDate"].ToString());
                    if (!Directory.Exists(directoryUrl.ToString()))
                    {
                        Directory.CreateDirectory(directoryUrl.ToString());
                    }

                    //6、销售单号
                    directoryUrl.Append(@"\" + dr["ShipmentNbr"].ToString());
                    if (!Directory.Exists(directoryUrl.ToString()))
                    {
                        Directory.CreateDirectory(directoryUrl.ToString());
                    }
                    //System.GC.Collect();

                    isExistsFile = File.Exists(sourceUrl + dr["Url"].ToString());
                    if (isExistsFile)
                    {
                        File.Copy(sourceUrl + dr["Url"].ToString(), directoryUrl + @"\" + (dr["Name"].ToString().Length > 100 ? dr["Url"].ToString() : dr["Name"].ToString()), true);
                    }

                    uploadLog = new UploadLog();
                    uploadLog.Id = Guid.NewGuid();
                    uploadLog.Type = "销售单发票归档";
                    uploadLog.DmaId = new Guid(dr["DealerId"].ToString());
                    uploadLog.CreateUser = Guid.Empty;
                    uploadLog.UploadDate = DateTime.Now;
                    uploadLog.AtId = new Guid(dr["Id"].ToString());
                    uploadLog.Rev1 = string.Format("{0}|{1}|{2}|{3}|{4}|{5}", dr["DivisionName"].ToString(), dr["ParentName"].ToString(), dr["DealerShortName"].ToString(), dr["HospitalShortName"].ToString(), dr["ShipmentDate"].ToString(), dr["ShipmentNbr"].ToString());
                    uploadLog.Rev2 = dr["MainId"].ToString();
                    uploadLog.Rev3 = isExistsFile ? "1" : "0";

                    business.InsertFileUploadLog(uploadLog);
                }
            }
            catch (Exception ex)
            {
                //_log.Error(string.Format("Attachment Archive failure ,error Message:{0}", ex.ToString()), ex);
            }
            finally
            {
                
            }
        }


        #endregion

        #region ITask 成员

        public Dictionary<string, string> Config
        {
            set
            {
                this._config = value;
                if (this._config.ContainsKey("total"))
                {
                    this.Total = Convert.ToInt32(this._config["total"]);
                }
                //_log.Info("AttachmentArchiveTask Config : Total = " + this.Total);
            }
        }

        #endregion
    }
}
