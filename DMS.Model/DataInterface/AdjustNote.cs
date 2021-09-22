/*
 * Ibatis.Net for Data Mapper, and Generated by MyGeneration
 * 
 * NameSpace   : DMS.Model 
 * ClassName   : AdjustNote
 * Created Time: 2013/9/2 17:09:23
 *
 ******* Copyright (C) 2009/2010 - GrapeCity **********
 *
******************************************************/

using System;

namespace DMS.Model
{
	/// <summary>
	///	AdjustNote
	/// </summary>
	[Serializable]
	public class AdjustNote : BaseModel
	{
		#region Private Members 24
		
		private Guid _id; 
		private string _articlenumber; 
		private string _lotnumber; 
		private DateTime? _expireddate; 
		private decimal? _lotqty; 
		private DateTime? _adjustdate; 
		private string _adjusttype; 
		private string _remark; 
		private int _linenbr; 
		private string _filename; 
		private DateTime _importdate; 
		private string _batchnbr; 
		private string _clientid; 
		private Guid? _dma_id; 
		private Guid? _whm_id; 
		private Guid? _cfn_id; 
		private Guid? _pma_id; 
		private Guid? _bum_id; 
		private Guid? _pct_id; 
		private Guid? _ltm_id; 
		private Guid? _slt_id; 
		private bool? _authorized; 
		private string _problemdescription; 
		private DateTime? _handledate; 		
		#endregion
		
		#region Default ( Empty ) Class Constuctor
		/// <summary>
		/// default constructor
		/// </summary>
		public AdjustNote()
		{
			_id = Guid.Empty; 
			_articlenumber = null; 
			_lotnumber = null; 
			_expireddate = null;
			_lotqty = null;
			_adjustdate = null;
			_adjusttype = null; 
			_remark = null; 
			_linenbr = 0; 
			_filename = null; 
			_importdate = new DateTime(); 
			_batchnbr = null; 
			_clientid = null; 
			_dma_id = null;
			_whm_id = null;
			_cfn_id = null;
			_pma_id = null;
			_bum_id = null;
			_pct_id = null;
			_ltm_id = null;
			_slt_id = null;
			_authorized = null;
			_problemdescription = null; 
			_handledate = null;
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
		/// 产品型号
		/// </summary>		
		public string ArticleNumber
		{
			get { return _articlenumber; }
			set	
			{
				if( value!= null && value.Length > 30)
					throw new ArgumentOutOfRangeException("Invalid value for ArticleNumber", value, value.ToString());
				
				_articlenumber = value;
			}
		}
			
		/// <summary>
		/// 序列号
		/// </summary>		
		public string LotNumber
		{
			get { return _lotnumber; }
			set	
			{
				if( value!= null && value.Length > 50)
					throw new ArgumentOutOfRangeException("Invalid value for LotNumber", value, value.ToString());
				
				_lotnumber = value;
			}
		}
			
		/// <summary>
		/// 有效期
		/// </summary>		
		public DateTime? ExpiredDate
		{
			get { return _expireddate; }
			set { _expireddate = value; }
		}
			
		/// <summary>
		/// 数量
		/// </summary>		
		public decimal? LotQty
		{
			get { return _lotqty; }
			set { _lotqty = value; }
		}
			
		/// <summary>
		/// 调整时间
		/// </summary>		
		public DateTime? AdjustDate
		{
			get { return _adjustdate; }
			set { _adjustdate = value; }
		}
			
		/// <summary>
		/// 调整类型
		/// </summary>		
		public string AdjustType
		{
			get { return _adjusttype; }
			set	
			{
				if( value!= null && value.Length > 50)
					throw new ArgumentOutOfRangeException("Invalid value for AdjustType", value, value.ToString());
				
				_adjusttype = value;
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
		/// 导入时间
		/// </summary>		
		public DateTime ImportDate
		{
			get { return _importdate; }
			set { _importdate = value; }
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
		/// 经销商主键
		/// </summary>		
		public Guid? DmaId
		{
			get { return _dma_id; }
			set { _dma_id = value; }
		}
			
		/// <summary>
		/// 仓库主键
		/// </summary>		
		public Guid? WhmId
		{
			get { return _whm_id; }
			set { _whm_id = value; }
		}
			
		/// <summary>
		/// 产品主键
		/// </summary>		
		public Guid? CfnId
		{
			get { return _cfn_id; }
			set { _cfn_id = value; }
		}
			
		/// <summary>
		/// 物料主键
		/// </summary>		
		public Guid? PmaId
		{
			get { return _pma_id; }
			set { _pma_id = value; }
		}
			
		/// <summary>
		/// 产品线ID
		/// </summary>		
		public Guid? BumId
		{
			get { return _bum_id; }
			set { _bum_id = value; }
		}
			
		/// <summary>
		/// 产品分类ID
		/// </summary>		
		public Guid? PctId
		{
			get { return _pct_id; }
			set { _pct_id = value; }
		}
			
		/// <summary>
		/// 批次号主键
		/// </summary>		
		public Guid? LtmId
		{
			get { return _ltm_id; }
			set { _ltm_id = value; }
		}
			
		/// <summary>
		/// 关联销售单批次行主键
		/// </summary>		
		public Guid? SltId
		{
			get { return _slt_id; }
			set { _slt_id = value; }
		}
			
		/// <summary>
		/// 是否授权
		/// </summary>		
		public bool? Authorized
		{
			get { return _authorized; }
			set { _authorized = value; }
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
			
		
	
		
		#endregion 
		
		
		
		
		
	}
}
