using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;

namespace DMS.TaskLib.Email.Configuration
{
    public class EmailSettings : ConfigurationSection
    {
        public const string SectionName = "emailSettings";

        [ConfigurationProperty("", IsDefaultCollection = true)]
        public EmailServerElementCollection Servers
        {
            get
            {
                return (EmailServerElementCollection)base[""];
            }
        }

        [ConfigurationProperty("default", IsRequired = false)]
        public string Default
        {
            get { return (string)this["default"]; }
        }
    }
}
