using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Serialization;
using System.IO;
using System.Xml;

namespace DMS.Common.Common
{
    public class XmlHelper
    {
        #region XML相关：序列化，反序列化
        public static T Deserialize<T>(string xml, Encoding encoding)
        {
            XmlSerializer serializer = new XmlSerializer(typeof(T));

            using (MemoryStream stream = new MemoryStream(encoding.GetBytes(xml)))
            {
                using (StreamReader reader = new StreamReader(stream, encoding))
                {
                    return (T)serializer.Deserialize(reader);
                }
            }
        }

        public static string Serialize<T>(T obj, Encoding encoding)
        {
            string rtnXml = null;

            XmlSerializer serializer = new XmlSerializer(typeof(T));

            XmlWriterSettings settings = new XmlWriterSettings();
            //settings.Indent = true;
            //settings.NewLineChars = "\r\n";
            settings.Encoding = encoding;
            //settings.IndentChars = "    ";
            settings.OmitXmlDeclaration = true;

            //强制指定命名空间，覆盖默认的命名空间
            XmlSerializerNamespaces ns = new XmlSerializerNamespaces();
            ns.Add(string.Empty, string.Empty);

            using (MemoryStream stream = new MemoryStream())
            {
                using (XmlWriter writer = XmlWriter.Create(stream, settings))
                {
                    serializer.Serialize(writer, obj, ns);
                    writer.Close();
                }

                stream.Position = 0;

                using (StreamReader reader = new StreamReader(stream, encoding))
                {
                    rtnXml = reader.ReadToEnd();
                    reader.Close();
                }

                stream.Close();
            }

            return rtnXml;
        }
        #endregion
    }
}
