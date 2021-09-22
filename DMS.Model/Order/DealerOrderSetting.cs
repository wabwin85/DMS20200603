/*
 * Ibatis.Net for Data Mapper, and Generated by MyGeneration
 * 
 * NameSpace   : DMS.Model 
 * ClassName   : DealerOrderSetting
 * Created Time: 2011-2-10 12:08:47
 *
 ******* Copyright (C) 2009/2010 - GrapeCity **********
 *
******************************************************/

using System;

namespace DMS.Model
{
	/// <summary>
	///	DealerOrderSetting
	/// </summary>
	[Serializable]
	public class DealerOrderSetting : BaseModel
	{
		#region Private Members 5
		
		private Guid _id; 
		private Guid _dma_id; 
		private bool _isopen; 
		private decimal? _maxamount; 
		private string _executeday; 		
		#endregion
		
		#region Default ( Empty ) Class Constuctor
		/// <summary>
		/// default constructor
		/// </summary>
		public DealerOrderSetting()
		{
			_id = Guid.Empty; 
			_dma_id = Guid.Empty; 
			_isopen = false; 
			_maxamount = null;
			_executeday = null; 
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
		/// 经销商主键
		/// </summary>		
		public Guid DmaId
		{
			get { return _dma_id; }
			set { _dma_id = value; }
		}
			
		/// <summary>
		/// 是否打开自动生成订单
		/// </summary>		
		public bool IsOpen
		{
			get { return _isopen; }
			set { _isopen = value; }
		}
			
		/// <summary>
		/// 订单最大金额（含税）
		/// </summary>		
		public decimal? MaxAmount
		{
			get { return _maxamount; }
			set { _maxamount = value; }
		}
			
		/// <summary>
		/// 订单执行周期
		/// </summary>		
		public string ExecuteDay
		{
			get { return _executeday; }
			set	
			{
				if( value!= null && value.Length > 20)
					throw new ArgumentOutOfRangeException("Invalid value for ExecuteDay", value, value.ToString());
				
				_executeday = value;
			}
		}
			
		
	
		
		#endregion 
		
		
		
		
		
	}
}
