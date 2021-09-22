using System;

namespace DMS.ViewModel.Common
{
    public class KeyValue
    {
        public KeyValue()
        {
        }

        public KeyValue(String Key)
        {
            this.Key = Key;
            this.Value = Key;
        }

        public KeyValue(String Key, String Value)
        {
            this.Key = Key;
            this.Value = Value;
        }

        [LogAttribute]
        public String Key = String.Empty;
        [LogAttribute]
        public String Value = String.Empty;
    }
}
