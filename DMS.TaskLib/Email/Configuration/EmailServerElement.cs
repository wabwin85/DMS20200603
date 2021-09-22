using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;

namespace DMS.TaskLib.Email.Configuration
{
    public class EmailServerElement :DMS.TaskLib.Configuration.NameValueConfigurationElement
    {
        [ConfigurationProperty("smtp", IsRequired = true)]
        public string Smtp
        {
            get { return (string)this["smtp"]; }
        }

        [ConfigurationProperty("port", IsRequired = false, DefaultValue = 25)]
        public int Port
        {
            get
            {
                object obj = base["port"];
                return obj == null ? 25 : Convert.ToInt32(obj);
            }
        }

        [ConfigurationProperty("ssl", IsRequired = false, DefaultValue = false)]
        public bool EnableSSL
        {
            get
            {
                object obj = base["ssl"];
                return obj == null ? false : Convert.ToBoolean(obj);
            }
        }

        [ConfigurationProperty("from", IsRequired = false)]
        public string From
        {
            get { return (string)this["from"]; }
        }

        [ConfigurationProperty("username", IsRequired = true)]
        public string UserName
        {
            get { return (string)this["username"]; }
        }

        [ConfigurationProperty("password", IsRequired = true)]
        public string Password
        {
            get { return (string)this["password"]; }
        }

        [ConfigurationProperty("concurrency", IsRequired = false, DefaultValue = false)]
        public bool EnableConcurrency
        {
            get
            {
                object obj = base["concurrency"];
                return obj == null ? false : Convert.ToBoolean(obj);
            }
        }

        [ConfigurationProperty("interval", IsRequired = false, DefaultValue = 5000)]
        public int Interval
        {
            get
            {
                object obj = base["interval"];
                return obj == null ? 5000 : Convert.ToInt32(obj);
            }
        }

        [ConfigurationProperty("total", IsRequired = false, DefaultValue = 3)]
        public int Total
        {
            get
            {
                object obj = base["total"];
                return obj == null ? 3 : Convert.ToInt32(obj);
            }
        }

        [ConfigurationProperty("min", IsRequired = false, DefaultValue = 5)]
        public int MinThreadCount
        {
            get
            {
                object obj = base["min"];
                return obj == null ? 5 : Convert.ToInt32(obj);
            }
        }

        [ConfigurationProperty("max", IsRequired = false, DefaultValue = 20)]
        public int MaxThreadCount
        {
            get
            {
                object obj = base["max"];
                return obj == null ? 20 : Convert.ToInt32(obj);
            }
        }
    }
}
