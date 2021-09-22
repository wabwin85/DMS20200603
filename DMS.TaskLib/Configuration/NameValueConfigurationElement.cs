using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;

namespace DMS.TaskLib.Configuration
{
    public class NameValueConfigurationElement : ConfigurationElement
	{
        [ConfigurationProperty("name", IsKey = true, IsRequired = true)]
        public string Name
        {
            get { return (string)this["name"]; }
        }

        [ConfigurationProperty("value", IsRequired = false)]
        public virtual string Value
        {
            get { return (string)this["value"]; }
        }

        public NameValueConfigurationElement() { }
    }
}
