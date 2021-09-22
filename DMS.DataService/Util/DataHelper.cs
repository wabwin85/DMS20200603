using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using DMS.Common;
using DMS.Business;
using DMS.DataAccess;
using DMS.Model;
using System.Collections;
using System.IO;
using System.Xml;
using System.Xml.Serialization;
using System.Text;
using DMS.Business.MasterData;
using System.Web.Services.Protocols;

namespace DMS.DataService.Util
{
    public class DataHelper
    {
        public static string XmlDeclaration = "<?xml version=\"1.0\" encoding=\"utf-8\"?>";

        #region 数据库相关操作：批处理号，日志
        public static string GetBatchNumber(string clientid, DataInterfaceType type)
        {
            AutoNumberBLL autoNbr = new AutoNumberBLL();
            return autoNbr.GetNextAutoNumberForInt(clientid, type);
        }

        public static void BeginInterfaceLog(string batchNumber, string clientid, DataInterfaceType type)
        {
            using (InterfaceLogDao dao = new InterfaceLogDao())
            {
                InterfaceLog log = new InterfaceLog();
                log.Id = Guid.NewGuid();
                log.Name = type.ToString();
                log.StartTime = DateTime.Now;
                log.Status = DataInterfaceLogStatus.Processing.ToString();
                log.Clientid = clientid;
                log.BatchNbr = batchNumber;
                dao.Insert(log);
            }
        }

        public static void EndInterfaceLog(string batchNumber, DataInterfaceLogStatus status, string msg)
        {
            using (InterfaceLogDao dao = new InterfaceLogDao())
            {
                Hashtable ht = new Hashtable();
                ht.Add("BatchNbr", batchNumber);
                ht.Add("EndTime", DateTime.Now);
                ht.Add("Status", status.ToString());
                ht.Add("Message", msg);
                dao.UpdateByBatchNbr(ht);
            }
        }
        #endregion

        #region XML相关：序列化，反序列化
        public static T Deserialize<T>(string xml)
        {
            T obj = default(T);

            StringReader strReader = new StringReader(xml);
            XmlReader xmlReader = XmlReader.Create(strReader);
            XmlSerializer serializer = new XmlSerializer(typeof(T));
            try
            {
                obj = (T)serializer.Deserialize(xmlReader);
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message + " " + ex.InnerException.Message);
            }

            return obj;
        }

        public static string Serialize<T>(T obj)
        {
            string rtnXml = string.Empty;

            StringBuilder sb = new StringBuilder();
            XmlWriterSettings settings = new XmlWriterSettings();
            settings.OmitXmlDeclaration = true;
            XmlWriter writer = XmlWriter.Create(sb, settings);
            XmlSerializerNamespaces ns = new XmlSerializerNamespaces();
            ns.Add("", "");
            XmlSerializer serializer = new XmlSerializer(typeof(T));
            try
            {
                serializer.Serialize(writer, obj, ns);
                rtnXml = XmlDeclaration + sb.ToString();
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message + " " + ex.InnerException.Message);
            }
            finally
            {
                writer.Close();
            }
            return rtnXml;
        }
        #endregion
    }
}
