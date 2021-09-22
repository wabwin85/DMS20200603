using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Common
{
    using Coolite.Ext.Web;

    public delegate void AfterSelectedRow(SelectedEventArgs e);

    /// <summary>
    /// SelectedEventArgs
    /// </summary>
    public class SelectedEventArgs : EventArgs
    {
        private ParameterCollection _parameterCollection = null;

        private string _jsonData = string.Empty;
        private string _disSelectJsonData = string.Empty;

        #region 构造函数
        /// <summary>
        /// Initializes a new instance of the <see cref="SelectedEventArgs"/> class.
        /// </summary>
        /// <param name="jsonData">The json data.</param>
        public SelectedEventArgs(string jsonData)
        {
            _jsonData = jsonData;
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="SelectedEventArgs"/> class.
        /// </summary>
        /// <param name="selectData">The select data.</param>
        /// <param name="disSelectData">The dis select data.</param>
        public SelectedEventArgs(string selectData, string disSelectData)
        {
            _jsonData = selectData;
            _disSelectJsonData = disSelectData;
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="SelectedEventArgs"/> class.
        /// </summary>
        /// <param name="selectData">The select data.</param>
        /// <param name="disSelectData">The dis select data.</param>
        /// <param name="paramCollection">The param collection.</param>
        public SelectedEventArgs(string selectData, string disSelectData, ParameterCollection paramCollection)
        {
            _jsonData = selectData;
            _disSelectJsonData = disSelectData;
            _parameterCollection = paramCollection;
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="SelectedEventArgs"/> class.
        /// </summary>
        /// <param name="paramCollection">The param collection.</param>
        public SelectedEventArgs(ParameterCollection paramCollection)
        {
            _parameterCollection = paramCollection;
        }
        #endregion

        public string JsonData { get { return _jsonData; } }

        public string DisSelectJsonData { get { return _disSelectJsonData; } }

        public IList<T> ToList<T>()
        {
            IList<T> list = JSON.Deserialize <List<T>>(_jsonData);

            return list;
        }

        public IDictionary<string, string>[] ToDictionarys()
        {
            IDictionary<string, string>[] data = JSON.Deserialize<Dictionary<string, string>[]>(_jsonData);

            return data;
        }

        public ParameterCollection Parameters
        { get { return _parameterCollection; } }

        public IList<T> GetDisSelectList<T>()
        {
            IList<T> list = JSON.Deserialize<List<T>>(_disSelectJsonData);

            return list;
        }

        public IDictionary<string, string>[] GetDisSelectDictionarys()
        {
            IDictionary<string, string>[] data = JSON.Deserialize<Dictionary<string, string>[]>(_disSelectJsonData);

            return data;
        }

        /// <summary>
        /// Gets or sets a value indicating whether this <see cref="SelectedEventArgs"/> is success.
        /// </summary>
        /// <value><c>true</c> if success; otherwise, <c>false</c>.</value>
        public bool Success { get; set; }


        /// <summary>
        /// Gets or sets the error message.
        /// </summary>
        /// <value>The error message.</value>
        public string ErrorMessage { get; set; }
    }


}
