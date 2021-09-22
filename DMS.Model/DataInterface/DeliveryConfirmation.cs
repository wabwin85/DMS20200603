/*
 * Ibatis.Net for Data Mapper, and Generated by MyGeneration
 * 
 * NameSpace   : DMS.Model 
 * ClassName   : DeliveryConfirmation
 * Created Time: 2013/9/2 16:19:18
 *
 ******* Copyright (C) 2009/2010 - GrapeCity **********
 *
******************************************************/

using System;

namespace DMS.Model
{
	/// <summary>
	///	DeliveryConfirmation
	/// </summary>
	[Serializable]
	public class DeliveryConfirmation : BaseModel
	{
		#region Private Members 13
		
		private Guid _id; 
		private string _sapdeliveryno; 
		private DateTime? _confirmdate; 
		private bool? _isconfirm; 
		private string _remark; 
		private int _linenbr; 
		private string _filename; 
		private Guid? _prh_id; 
		private string _problemdescription; 
		private DateTime? _handledate; 
		private DateTime _importdate; 
		private string _clientid; 
		private string _batchnbr; 		
		#endregion
		
		#region Default ( Empty ) Class Constuctor
		/// <summary>
		/// default constructor
		/// </summary>
		public DeliveryConfirmation()
		{
			_id = Guid.Empty; 
			_sapdeliveryno = null; 
			_confirmdate = null;
			_isconfirm = null;
			_remark = null; 
			_linenbr = 0; 
			_filename = null; 
			_prh_id = null;
			_problemdescription = null; 
			_handledate = null;
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
		public bool? IsConfirm
		{
			get { return _isconfirm; }
			set { _isconfirm = value; }
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
		/// 行号
		/// </summary>		
		public int LineNbr
		{
			get { return _linenbr; }
			set { _linenbr = value; }
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
			
		/// <summary>
		/// 关联收货单主键
		/// </summary>		
		public Guid? PrhId
		{
			get { return _prh_id; }
			set { _prh_id = value; }
		}
			
		/// <summary>
		/// 问题描述
		/// </summary>		
		public string ProblemDescription
		{
			get { return _problemdescription; }
			set	
			{
				if( value!= null && value.Length > 200)
					throw new ArgumentOutOfRangeException("Invalid value for ProblemDescription", value, value.ToString());
				
				_problemdescription = value;
			}
		}
			
		/// <summary>
		/// 处理日期
		/// </summary>		
		public DateTime? HandleDate
		{
			get { return _handledate; }
			set { _handledate = value; }
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
		/// 客户端ID（BSC新增）
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
