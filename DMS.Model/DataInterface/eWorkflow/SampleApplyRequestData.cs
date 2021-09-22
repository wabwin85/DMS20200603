using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Serialization;
using System.Xml.Schema;
using System.Xml;

namespace DMS.Model.DataInterface.eWorkflow
{
    public class SampleApplyHeaderRow : BaseRequestTableRow, IXmlSerializable
    {
        public string EID { get; set; }
        public string DEPID { get; set; }
        public string SAMPLETYPE { get; set; }
        public string PURPOSETYPE { get; set; }
        public string TOTALAMOUNTUSD { get; set; }
        public string XML { get; set; }
        public string HOSTIPAL { get; set; }
        public string REGTYPE { get; set; }
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
            WriteCDATA(writer, "PURPOSETYPE", this.PURPOSETYPE);
            WriteCDATA(writer, "TOTALAMOUNTUSD", this.TOTALAMOUNTUSD);
            WriteCDATA(writer, "XML", this.XML);
            WriteCDATA(writer, "HOSTIPAL", this.HOSTIPAL);
            WriteCDATA(writer, "REGTYPE", this.REGTYPE);
            WriteCDATA(writer, "DMSNO", this.DMSNO);
        }

        #endregion
    }

    public class SampleApplyDetailRow : BaseRequestTableRow, IXmlSerializable
    {
        public string UPN { get; set; }

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
            WriteCDATA(writer, "UPN", this.UPN);            
        }

        #endregion
    }
}
