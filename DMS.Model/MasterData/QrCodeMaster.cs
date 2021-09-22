/*
 * Ibatis.Net for Data Mapper, and Generated by MyGeneration
 * 
 * NameSpace   : DMS.Model 
 * ClassName   : QrCodeMaster
 * Created Time: 2015/12/25 11:01:51
 *
 ******* Copyright (C) 2009/2010 - GrapeCity **********
 *
******************************************************/

using System;

namespace DMS.Model
{
	/// <summary>
	///	QrCodeMaster
	/// </summary>
	[Serializable]
	public class QrCodeMaster : BaseModel
	{
		#region Private Members 8
		
		private Guid _id; 
		private string _qrcode; 
		private int _status; 
		private string _usercode; 
		private string _channel; 
		private DateTime? _importdate; 
		private DateTime? _updatedate; 		
		#endregion
		
		#region Default ( Empty ) Class Constuctor
		/// <summary>
		/// default constructor
		/// </summary>
		public QrCodeMaster()
		{
			_id = Guid.Empty; 
			_qrcode = null; 
			_status = 0; 
			_usercode = null; 
			_channel = null; 
			_importdate = null;
			_updatedate = null;
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
		/// 二维码
		/// </summary>		
		public string QrCode
		{
			get { return _qrcode; }
			set	
			{
				if( value!= null && value.Length > 50)
					throw new ArgumentOutOfRangeException("Invalid value for QrCode", value, value.ToString());
				
				_qrcode = value;
			}
		}
			
		/// <summary>
		/// 状态
		/// </summary>		
		public int Status
		{
			get { return _status; }
			set { _status = value; }
		}
			
		/// <summary>
		/// 使用对象编号
		/// </summary>		
		public string UserCode
		{
			get { return _usercode; }
			set	
			{
				if( value!= null && value.Length > 50)
					throw new ArgumentOutOfRangeException("Invalid value for UserCode", value, value.ToString());
				
				_usercode = value;
			}
		}
			
		/// <summary>
		/// 使用渠道
		/// </summary>		
		public string Channel
		{
			get { return _channel; }
			set	
			{
				if( value!= null && value.Length > 50)
					throw new ArgumentOutOfRangeException("Invalid value for Channel", value, value.ToString());
				
				_channel = value;
			}
		}
			
		/// <summary>
		/// 接口新增日期
		/// </summary>		
		public DateTime? ImportDate
		{
			get { return _importdate; }
			set { _importdate = value; }
		}
			
		/// <summary>
		/// 接口更新日期
		/// </summary>		
		public DateTime? UpdateDate
		{
			get { return _updatedate; }
			set { _updatedate = value; }
		}
			
		
	
		
		#endregion 
		
		
		
		
		
	}
}
