using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.Text;

namespace DMS.Model.ViewModel
{
    public abstract class BaseViewModel
    {
        protected BaseViewModel()
        {
        }

        public String Method { get; set; }

        public bool IsSuccess { get; set; }

        public bool IsCanEdit { get; set; }

        public bool IsCanView { get; set; }

        private StringCollection _executeMessage;
        public StringCollection ExecuteMessage
        {
            get
            {
                if (_executeMessage == null)
                {
                    _executeMessage = new StringCollection();
                }
                return _executeMessage;
            }
            set
            {
                this._executeMessage = value;
            }
        }
    }
}
