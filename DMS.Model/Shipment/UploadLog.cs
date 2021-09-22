/*
 * Ibatis.Net for Data Mapper, and Generated by MyGeneration
 * 
 * NameSpace   : DMS.Model 
 * ClassName   : UploadLog
 * Created Time: 2013/9/2 14:32:16
 *
 ******* Copyright (C) 2009/2010 - GrapeCity **********
 *
******************************************************/

using System;

namespace DMS.Model
{
	/// <summary>
	///	UploadLog
	/// </summary>
	[Serializable]
	public class UploadLog : BaseModel
	{
		#region Private Members 5
		
		private Guid _id; 
		private string _type; 
		private Guid? _dma_id; 
		private DateTime? _uploaddate; 		
        private string _rev1;
        private string _rev2;
        private string _rev3;
        private Guid? _atid;
        private Guid? _productlineid;
        #endregion

        #region Default ( Empty ) Class Constuctor
        /// <summary>
        /// default constructor
        /// </summary>
        public UploadLog()
        {
            _id = Guid.Empty;
            _type = null;
            _dma_id = null;
            _uploaddate = null;
            _rev1 = null;
            _rev2 = null;
            _rev3 = null;
            _atid = null;
            _productlineid = null;
        }
		#endregion // End of Default ( Empty ) Class Constuctor
		
		#region Public Properties
			
		/// <summary>
		/// 主键
		/// </summary>		
		public Guid Id
		{
			get { return _id; }
			set { _id = value; }
		}
			
		/// <summary>
		/// 类型
		/// </summary>		
		public string Type
		{
			get { return _type; }
			set	
			{
				if( value!= null && value.Length > 200)
					throw new ArgumentOutOfRangeException("Invalid value for Type", value, value.ToString());
				
				_type = value;
			}
		}
			
		/// <summary>
		/// 经销商主键
		/// </summary>		
		public Guid? DmaId
		{
			get { return _dma_id; }
			set { _dma_id = value; }
		}
			
		/// <summary>
		/// 上传时间
		/// </summary>		
		public DateTime? UploadDate
		{
			get { return _uploaddate; }
			set { _uploaddate = value; }
		}


        /// <summary>
        /// 备注一
        /// </summary>		
        public string Rev1
        {
            get { return _rev1; }
            set { _rev1 = value; }
        }

        /// <summary>
		/// 备注二
		/// </summary>		
		public string Rev2
        {
            get { return _rev2; }
            set { _rev2 = value; }
        }

        /// <summary>
		/// 备注三
		/// </summary>		
		public string Rev3
        {
            get { return _rev3; }
            set { _rev3 = value; }
        }

        /// <summary>
		/// Attachment Id
		/// </summary>		
		public Guid? AtId
        {
            get { return _atid; }
            set { _atid = value; }
        }

        /// <summary>
        ///产品线 
        /// </summary>
        public Guid? ProductLineID
        {
            get { return _productlineid; }
            set { _productlineid = value; }
        }
        #endregion





    }
}
