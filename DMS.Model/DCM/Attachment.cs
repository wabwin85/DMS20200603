/*
 * Ibatis.Net for Data Mapper, and Generated by MyGeneration
 * 
 * NameSpace   : DMS.Model 
 * ClassName   : Dealerqa
 * Created Time: 2013/9/2 16:53:03
 *
 ******* Copyright (C) 2009/2010 - GrapeCity **********
 *
******************************************************/

using System;

namespace DMS.Model
{
	/// <summary>
	///	Dealerqa
	/// </summary>
	[Serializable]
	public class Attachment : BaseModel
	{
		#region Private Members 7
		
		private Guid _id; 
		private Guid _main_id; 
		private string _name; 
		private string _url; 
        private string _type;
		private Guid _uplpaduser; 
		private DateTime _uploaddate; 		
		#endregion
		
		#region Default ( Empty ) Class Constuctor
		/// <summary>
		/// default constructor
		/// </summary>
        public Attachment()
		{
            _id = Guid.Empty;
            _main_id = Guid.Empty;
            _name = null;
            _url = null;
            _type = null;
            _uplpaduser = Guid.Empty;
            _uploaddate = DateTime.Now;
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
		/// 主ID
		/// </summary>		
        public Guid MainId
		{
            get { return _main_id; }
            set { _main_id = value; }
		}

        /// <summary>
        /// 附件名字
        /// </summary>		
        public string Name
        {
            get { return _name; }
            set
            {
                if (value != null && value.Length > 2000)
                    throw new ArgumentOutOfRangeException("Invalid value for Type", value, value.ToString());

                _name = value;
            }
        }

        /// <summary>
        /// 附件地址
        /// </summary>		
        public string Url
        {
            get { return _url; }
            set
            {
                if (value != null && value.Length > 2000)
                    throw new ArgumentOutOfRangeException("Invalid value for Type", value, value.ToString());

                _url = value;
            }
        }

		/// <summary>
		/// 附件类型
		/// </summary>		
		public string Type
		{
			get { return _type; }
			set	
			{
				if( value!= null && value.Length > 20)
					throw new ArgumentOutOfRangeException("Invalid value for Type", value, value.ToString());
				
				_type = value;
			}
		}

        /// <summary>
        /// 上传人人ID
        /// </summary>		
        public Guid UploadUser
        {
            get { return _uplpaduser; }
            set { _uplpaduser = value; }
        }

		/// <summary>
		/// 上传日期
		/// </summary>		
        public DateTime UploadDate
		{
            get { return _uploaddate; }
            set { _uploaddate = value; }
		}
		
			
		
	
		
		#endregion 
		
		
		
		
		
	}
}
