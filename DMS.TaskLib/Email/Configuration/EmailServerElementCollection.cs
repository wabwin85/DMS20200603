using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;

namespace DMS.TaskLib.Email.Configuration
{
    public class EmailServerElementCollection : ConfigurationElementCollection
    {
        public EmailServerElement this[object key]
        {
            get
            {
                return base.BaseGet(key) as EmailServerElement;
            }
        }

        public EmailServerElement this[int index]
        {
            get
            {
                return base.BaseGet(index) as EmailServerElement;
            }
            set
            {
                if (base.BaseGet(index) != null)
                {
                    base.BaseRemoveAt(index);
                }
                this.BaseAdd(index, value);
            }
        }

        public override ConfigurationElementCollectionType CollectionType
        {
            get
            {
                return ConfigurationElementCollectionType.BasicMap;
            }
        }

        protected override ConfigurationElement CreateNewElement()
        {
            return new EmailServerElement();
        }

        protected override object GetElementKey(ConfigurationElement element)
        {
            return ((EmailServerElement)element).Name;
        }

        protected override string ElementName
        {
            get
            {
                return "server";
            }
        }
    }

}
