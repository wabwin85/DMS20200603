/*
 * Ibatis.Net for Data Mapper, and Generated by MyGeneration
 * 
 * NameSpace   : DMS.Model 
 * ClassName   : Interfacet2DeliveryConfirmation
 * Created Time: 2016/12/8 19:05:20
 *
 ******* Copyright (C) 2009/2010 - GrapeCity **********
 *
******************************************************/

using System;

namespace DMS.Model
{
	/// <summary>
	///	Interfacet2DeliveryConfirmation
	/// </summary>
	[Serializable]
	public class Interfacet2DeliveryConfirmation 
	{
		#region Private Members 9
		
		private Guid _id; 
		private string _sapdeliveryno; 
		private DateTime? _confirmdate; 
		private string _isconfirm; 
		private string _remark; 
		private string _filename;
        private int _linenbr;
		private DateTime _importdate; 
		private string _clientid; 
		private string _batchnbr; 		
		#endregion
		
		#region Default ( Empty ) Class Constuctor
		/// <summary>
		/// default constructor
		/// </summary>
		public Interfacet2DeliveryConfirmation()
		{
			_id = Guid.Empty; 
			_sapdeliveryno = null; 
			_confirmdate = null;
			_isconfirm = null;
			_remark = null; 
			_filename = null;
            _linenbr = 0;
            _importdate = new DateTime(); 
			_clientid = null; 
			_batchnbr = null; 
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
		/// SAP发货单号
		/// </summary>		
		public string SapDeliveryNo
		{
			get { return _sapdeliveryno; }
			set	
			{
				if( value!= null && value.Length > 50)
					throw new ArgumentOutOfRangeException("Invalid value for SapDeliveryNo", value, value.ToString());
				
				_sapdeliveryno = value;
			}
		}
			
		/// <summary>
		/// 确认时间
		/// </summary>		
		public DateTime? ConfirmDate
		{
			get { return _confirmdate; }
			set { _confirmdate = value; }
		}

        /// <summary>
        /// 是否确认
        /// </summary>		
        public string IsConfirm
		{
			get { return _isconfirm; }
			set {
                if (value != null && value.Length > 50)
                    throw new ArgumentOutOfRangeException("Invalid value for IsConfirm", value, value.ToString());
                _isconfirm = value;
            }
		}
			
		/// <summary>
		/// 备注
		/// </summary>		
		public string Remark
		{
			get { return _remark; }
			set	
			{
				if( value!= null && value.Length > 200)
					throw new ArgumentOutOfRangeException("Invalid value for Remark", value, value.ToString());
				
				_remark = value;
			}
		}
			
		/// <summary>
		/// 文件名
		/// </summary>		
		public string FileName
		{
			get { return _filename; }
			set	
			{
				if( value!= null && value.Length > 200)
					throw new ArgumentOutOfRangeException("Invalid value for FileName", value, value.ToString());
				
				_filename = value;
			}
		}
        public int LineNbr
        {
            get { return _linenbr; }
            set { _linenbr = value; }
        }
        /// <summary>
        /// 导入时间
        /// </summary>		
        public DateTime ImportDate
		{
			get { return _importdate; }
			set { _importdate = value; }
		}
			
		/// <summary>
		/// 客户端ID
		/// </summary>		
		public string Clientid
		{
			get { return _clientid; }
			set	
			{
				if( value!= null && value.Length > 50)
					throw new ArgumentOutOfRangeException("Invalid value for Clientid", value, value.ToString());
				
				_clientid = value;
			}
		}
			
		/// <summary>
		/// 处理批次
		/// </summary>		
		public string BatchNbr
		{
			get { return _batchnbr; }
			set	
			{
				if( value!= null && value.Length > 30)
					throw new ArgumentOutOfRangeException("Invalid value for BatchNbr", value, value.ToString());
				
				_batchnbr = value;
			}
		}
			
		
	
		
		#endregion 
		
		
		
		
		
	}
}
