/*
 * Ibatis.Net for Data Mapper, and Generated by MyGeneration
 * 
 * NameSpace   : DMS.Model 
 * ClassName   : SalesNote
 * Created Time: 2013/9/2 16:51:42
 *
 ******* Copyright (C) 2009/2010 - GrapeCity **********
 *
******************************************************/

using System;

namespace DMS.Model
{
	/// <summary>
	///	SalesNote
	/// </summary>
	[Serializable]
	public class SalesNote : BaseModel
	{
		#region Private Members 35
		
		private Guid _id; 
		private string _hospitalcode; 
		private string _hospitalname; 
		private string _hospitaloffice; 
		private string _invoicenumber; 
		private string _invoicetitle; 
		private DateTime? _invoicedate; 
		private string _saletype; 
		private DateTime? _saledate; 
		private string _articlenumber; 
		private string _lotnumber; 
		private decimal? _unitprice; 
		private string _remark; 
		private DateTime? _expireddate; 
		private string _uom; 
		private decimal? _lotqty; 
		private string _warehouse; 
		private bool? _writeoff; 
		private int _linenbr; 
		private string _filename; 
		private DateTime _importdate; 
		private string _clientid; 
		private string _batchnbr; 
		private Guid? _dma_id; 
		private Guid? _whm_id; 
		private Guid? _cfn_id; 
		private Guid? _pma_id; 
		private Guid? _bum_id; 
		private Guid? _pct_id; 
		private Guid? _hos_id; 
		private Guid? _ltm_id; 
		private Guid? _slt_id; 
		private bool? _authorized; 
		private string _problemdescription; 
		private DateTime? _handledate;
        private Guid? _cah_id;
		#endregion
		
		#region Default ( Empty ) Class Constuctor
		/// <summary>
		/// default constructor
		/// </summary>
		public SalesNote()
		{
			_id = Guid.Empty; 
			_hospitalcode = null; 
			_hospitalname = null; 
			_hospitaloffice = null; 
			_invoicenumber = null; 
			_invoicetitle = null; 
			_invoicedate = null;
			_saletype = null; 
			_saledate = null;
			_articlenumber = null; 
			_lotnumber = null; 
			_unitprice = null;
			_remark = null; 
			_expireddate = null;
			_uom = null; 
			_lotqty = null;
			_warehouse = null; 
			_writeoff = null;
			_linenbr = 0; 
			_filename = null; 
			_importdate = new DateTime(); 
			_clientid = null; 
			_batchnbr = null; 
			_dma_id = null;
			_whm_id = null;
			_cfn_id = null;
			_pma_id = null;
			_bum_id = null;
			_pct_id = null;
			_hos_id = null;
			_ltm_id = null;
			_slt_id = null;
			_authorized = null;
			_problemdescription = null; 
			_handledate = null;
            _cah_id = null;
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
		/// 医院代码
		/// </summary>		
		public string HospitalCode
		{
			get { return _hospitalcode; }
			set	
			{
				if( value!= null && value.Length > 50)
					throw new ArgumentOutOfRangeException("Invalid value for HospitalCode", value, value.ToString());
				
				_hospitalcode = value;
			}
		}
			
		/// <summary>
		/// 医院名称
		/// </summary>		
		public string HospitalName
		{
			get { return _hospitalname; }
			set	
			{
				if( value!= null && value.Length > 200)
					throw new ArgumentOutOfRangeException("Invalid value for HospitalName", value, value.ToString());
				
				_hospitalname = value;
			}
		}
			
		/// <summary>
		/// 医院科室
		/// </summary>		
		public string HospitalOffice
		{
			get { return _hospitaloffice; }
			set	
			{
				if( value!= null && value.Length > 200)
					throw new ArgumentOutOfRangeException("Invalid value for HospitalOffice", value, value.ToString());
				
				_hospitaloffice = value;
			}
		}
			
		/// <summary>
		/// 发票号码
		/// </summary>		
		public string InvoiceNumber
		{
			get { return _invoicenumber; }
			set	
			{
				if( value!= null && value.Length > 200)
					throw new ArgumentOutOfRangeException("Invalid value for InvoiceNumber", value, value.ToString());
				
				_invoicenumber = value;
			}
		}
			
		/// <summary>
		/// 发票抬头
		/// </summary>		
		public string InvoiceTitle
		{
			get { return _invoicetitle; }
			set	
			{
				if( value!= null && value.Length > 200)
					throw new ArgumentOutOfRangeException("Invalid value for InvoiceTitle", value, value.ToString());
				
				_invoicetitle = value;
			}
		}
			
		/// <summary>
		/// 发票日期
		/// </summary>		
		public DateTime? InvoiceDate
		{
			get { return _invoicedate; }
			set { _invoicedate = value; }
		}
			
		/// <summary>
		/// 销售类型
		/// </summary>		
		public string SaleType
		{
			get { return _saletype; }
			set	
			{
				if( value!= null && value.Length > 20)
					throw new ArgumentOutOfRangeException("Invalid value for SaleType", value, value.ToString());
				
				_saletype = value;
			}
		}
			
		/// <summary>
		/// 销售时间
		/// </summary>		
		public DateTime? SaleDate
		{
			get { return _saledate; }
			set { _saledate = value; }
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
		/// 销售价格
		/// </summary>		
		public decimal? UnitPrice
		{
			get { return _unitprice; }
			set { _unitprice = value; }
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
		/// 产品有效期
		/// </summary>		
		public DateTime? ExpiredDate
		{
			get { return _expireddate; }
			set { _expireddate = value; }
		}
			
		/// <summary>
		/// 产品单位
		/// </summary>		
		public string Uom
		{
			get { return _uom; }
			set	
			{
				if( value!= null && value.Length > 20)
					throw new ArgumentOutOfRangeException("Invalid value for Uom", value, value.ToString());
				
				_uom = value;
			}
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
		/// 仓库名称
		/// </summary>		
		public string Warehouse
		{
			get { return _warehouse; }
			set	
			{
				if( value!= null && value.Length > 50)
					throw new ArgumentOutOfRangeException("Invalid value for Warehouse", value, value.ToString());
				
				_warehouse = value;
			}
		}
			
		/// <summary>
		/// 是否冲红
		/// </summary>		
		public bool? WriteOff
		{
			get { return _writeoff; }
			set { _writeoff = value; }
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
		/// 医院ID
		/// </summary>		
		public Guid? HosId
		{
			get { return _hos_id; }
			set { _hos_id = value; }
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
		/// 关联销售单批次主键
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


        public Guid? CahId
        {
            get { return _cah_id; }
            set { _cah_id = value; }
        }
		
		#endregion 
		
		
		
		
		
	}
}
