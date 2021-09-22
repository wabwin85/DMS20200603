using System;
using System.Collections;

namespace DMS.ViewModel.Common
{
    public class KendoColumn
    {
        public KendoColumn(String field, String title)
        {
            this.field = field;
            this.title = title;
        }

        public KendoColumn(String field, String title, String width)
        {
            this.field = field;
            this.title = title;
            this.width = width;
        }

        public KendoColumn(String field, String title, String width, String format, bool encoded,
            String template)
        {
            this.field = field;
            this.title = title;
            this.width = width;
            this.format = format;
            this.encoded = encoded;
            this.template = template;
        }

        public String field;
        public String title;
        public String width;
        public String format;
        public bool encoded = true;
        public String template;
        public Hashtable attributes = new Hashtable();
        private Hashtable _headerAttributes = new Hashtable();
        public Hashtable headerAttributes
        {
            get
            {
                if (!_headerAttributes.Contains("title") || String.IsNullOrEmpty(_headerAttributes["title"].ToString()))
                {
                    _headerAttributes.Add("title", this.title);
                }
                if (!_headerAttributes.Contains("class") || String.IsNullOrEmpty(_headerAttributes["class"].ToString()))
                {
                    _headerAttributes.Add("class", "center bold");
                }
                return _headerAttributes;
            }
            set
            {
                _headerAttributes = value;
            }
        }
    }
}
