using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.Text;

namespace DMS.ViewModel
{
    public class BaseVO
    {
        public BaseVO()
        {
        }

        private bool _isSuccess = true;
        public bool IsSuccess
        {
            get
            {
                return _isSuccess;
            }
            set
            {
                this._isSuccess = value;
            }
        }

        public void AddExecuteMessage(String message)
        {
            this.ExecuteMessage.Add(message);
        }

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

        public String ToJsonString()
        {
            return JsonConvert.SerializeObject(this);
        }

        public String ToLogJsonString()
        {
            JsonSerializerSettings jsetting = new JsonSerializerSettings();
            jsetting.ContractResolver = new LogContractResolver();
            return JsonConvert.SerializeObject(this, Formatting.Indented, jsetting);
        }
    }
}
