/*
 * Ibatis.Net for Data Mapper, and Generated by MyGeneration
 * 
 * NameSpace   : DMS.Model 
 * ClassName   : DeliveryInterface
 * Created Time: 2013/7/18 12:02:02
 *
 ******* Copyright (C) 2009/2010 - GrapeCity **********
 *
******************************************************/

using System;

namespace DMS.Model
{
	/// <summary>
	///	DeliveryInterface
	/// </summary>
	[Serializable]
	public class DeliveryInterface : BaseModel
	{
		#region Private Members 12
		
		private Guid _id; 
		private string _batchnbr; 
		private string _recordnbr; 
		private string _sapdeliveryno; 
		private string _status; 
		private string _processtype; 
		private string _filename; 
		private Guid? _updateuser; 
		private DateTime? _updatedate; 
		private string _clientid; 		
		#endregion
		
		#region Default ( Empty ) Class Constuctor
		/// <summary>
		/// default constructor
		/// </summary>
		public DeliveryInterface()
		{
			_id = Guid.Empty; 
			_batchnbr = null; 
			_recordnbr = null; 
			_sapdeliveryno = null; 
			_status = null; 
			_processtype = null; 
			_filename = null; 
			_updateuser = null;
			_updatedate = null;
			_clientid = null; 
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
			
		/// <summary>
		/// 处理记录号
		/// </summary>		
		public string RecordNbr
		{
			get { return _recordnbr; }
			set	
			{
				if( value!= null && value.Length > 30)
					throw new ArgumentOutOfRangeException("Invalid value for RecordNbr", value, value.ToString());
				
				_recordnbr = value;
			}
		}
			
		/// <summary>
		/// SAP发货单号（根据发货单号到DeliveryNote表中查找明细行）
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
		/// 处理状态（待处理Pending，处理中Processing，处理成功Success，处理失败Failure）
		/// </summary>		
		public string Status
		{
			get { return _status; }
			set	
			{
				if( value!= null && value.Length > 20)
					throw new ArgumentOutOfRangeException("Invalid value for Status", value, value.ToString());
				
				_status = value;
			}
		}
			
		/// <summary>
		/// 处理类型（Manual人工，System系统）
		/// </summary>		
		public string ProcessType
		{
			get { return _processtype; }
			set	
			{
				if( value!= null && value.Length > 20)
					throw new ArgumentOutOfRangeException("Invalid value for ProcessType", value, value.ToString());
				
				_processtype = value;
			}
		}
			
		/// <summary>
		/// 生成文件物理路径（BSC不使用）
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
		/// 更新人
		/// </summary>		
		public Guid? UpdateUser
		{
			get { return _updateuser; }
			set { _updateuser = value; }
		}
			
		/// <summary>
		/// 更新日期
		/// </summary>		
		public DateTime? UpdateDate
		{
			get { return _updatedate; }
			set { _updatedate = value; }
		}
			
		/// <summary>
		/// 客户端ID（BSC新增：保存接口ClientID，这样可以根据ClientID区分要获取的数据）
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
			
		
	
		
		#endregion 
		
		
		
		
		
	}
}
