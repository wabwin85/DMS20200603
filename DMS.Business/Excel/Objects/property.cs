using System;
using System.Collections.Generic;
using System.Text;
using System.Collections;

namespace DMS.Business.Excel.Objects
{
    public class property
    {
        private Hashtable _colors;
        public property()
        {

        }

        public Hashtable Colors
        {
            get { return _colors; }
            set { _colors = value; }
        }
    }
}
