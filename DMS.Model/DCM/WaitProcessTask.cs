using System;

namespace DMS.Model
{
    /// <summary>
	///	IssuesList
	/// </summary>
	[Serializable]
	public class WaitProcessTask : BaseModel
    {
        #region Private Members

        private string _modelId;
        private string _recordCount;
        private string _itemQty;
        private string _totalAmount;
        #endregion

        #region Default ( Empty ) Class Constuctor

		/// <summary>
		/// default constructor
		/// </summary>
        public WaitProcessTask()
		{
            _modelId = null;
            _recordCount = null;
            _itemQty = null;
            _totalAmount = null; 
		}
		#endregion // End of Default ( Empty ) Class Constuctor

        #region Public Properties

        /// <summary>
        /// 主键
        /// </summary>		
        public string ModelID
        {
            get { return _modelId; }
            set { _modelId = value; }
        }

        /// <summary>
        /// 记录数
        /// </summary>		
        public string RecordCount
        {
            get { return _recordCount; }
            set {_recordCount = value; }
        }

        /// <summary>
        /// 货物数量
        /// </summary>		
        public string ItemQty
        {
            get { return _itemQty; }
            set {_itemQty = value; }
        }

        /// <summary>
        /// 总价格
        /// </summary>		
        public string TotalAmount
        {
            get { return _totalAmount; }
            set { _totalAmount = value; }
        }


        #endregion 
    }
}
