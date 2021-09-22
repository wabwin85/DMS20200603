using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Schema;
using System.Xml;
using System.Xml.Serialization;

namespace DMS.Model.DataInterface.eWorkflow
{
    public class SampleReturnHeaderRow : BaseRequestTableRow, IXmlSerializable
    {
        public string EID { get; set; }
        public string DEPID { get; set; }
        public string SAMPLETYPE { get; set; }
        public string XML { get; set; }
        public string DMSNO { get; set; }

        #region IXmlSerializable 成员

        public XmlSchema GetSchema()
        {
            return null;
        }

        public void ReadXml(XmlReader reader)
        {
            //
        }

        public void WriteXml(XmlWriter writer)
        {
            WriteCDATA(writer, "EID", this.EID);
            WriteCDATA(writer, "DEPID", this.DEPID);
            WriteCDATA(writer, "SAMPLETYPE", this.SAMPLETYPE);
            WriteCDATA(writer, "XML", this.XML);
            WriteCDATA(writer, "DMSNO", this.DMSNO);
        }

        #endregion
    }
}
