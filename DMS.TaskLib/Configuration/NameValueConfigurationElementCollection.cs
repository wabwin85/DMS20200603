using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;

namespace DMS.TaskLib.Configuration
{
    public class NameValueConfigurationElementCollection: ConfigurationElementCollection
    {

        public NameValueConfigurationElement this[object key]
        {
            get
            {
                return base.BaseGet(key) as NameValueConfigurationElement;
            }
        }

        public NameValueConfigurationElement this[int index]
        {
            get
            {
                return base.BaseGet(index) as NameValueConfigurationElement;
            }
            set
            {
                if (base.BaseGet(index) != null)
                {
                    base.BaseRemoveAt(index);
                }
                //
                this.BaseAdd(index, value);
            }
        }

        public override ConfigurationElementCollectionType CollectionType
        {
            get
            {
                return ConfigurationElementCollectionType.AddRemoveClearMap;
            }
        }

        public NameValueConfigurationElementCollection() { }

        protected override ConfigurationElement CreateNewElement()
        {
            return new NameValueConfigurationElement();
        }

        protected override object GetElementKey(ConfigurationElement element)
        {
            return ((NameValueConfigurationElement)element).Name;
        }
    }
}
