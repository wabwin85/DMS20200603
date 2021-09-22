/*
 * Ibatis.Net for Data Mapper, and Generated by MyGeneration
 * 
 * NameSpace   : DMS.Model 
 * ClassName   : RegistrationInit
 * Created Time: 2010-5-21 13:11:52
 *
 ******* Copyright (C) 2009/2010 - GrapeCity **********
 *
******************************************************/

using System;

namespace DMS.Model
{
	/// <summary>
	///	RegistrationInit
	/// </summary>
	[Serializable]
	public class RegistrationInit : BaseModel
	{
		#region Private Members
		
		private Guid _id; 
		private string _registrationnbrcn; 
		private string _registrationnbren;
        private string _registrationproductname; 
		private DateTime _openingdate; 
		private DateTime _expirationdate; 
		private string _articlenumber; 
		private string _chinesename; 
		private string _englishname; 
		private string _specification; 
		private string _manufacturer_id; 
		private string _manufacturer_name; 
		private string _manufacturer_address; 
		private string _manufactory_address; 
		private string _scope; 
		private string _registeredagent; 
		private string _service; 
		private string _import; 
		private string _implant; 
		private string _lot; 
		private string _sn; 
		private string _pacemaker; 
		private string _guaranteeperiod; 
		private string _minunit; 
		private string _barcode1; 
		private string _barcode2; 
		private string _barcode3; 
		private string _barcode4; 
		private Guid _user; 
		private int _linenbr; 
		private bool _error; 
		private string _error_desc; 		
		#endregion
		
		#region Default ( Empty ) Class Constuctor
		/// <summary>
		/// default constructor
		/// </summary>
		public RegistrationInit()
		{
			_id = new Guid(); 
			_registrationnbrcn = null; 
			_registrationnbren = null;
            _registrationproductname = null; 
			_openingdate = new DateTime(); 
			_expirationdate = new DateTime(); 
			_articlenumber = null; 
			_chinesename = null; 
			_englishname = null; 
			_specification = null; 
			_manufacturer_id = null; 
			_manufacturer_name = null; 
			_manufacturer_address = null; 
			_manufactory_address = null; 
			_scope = null; 
			_registeredagent = null; 
			_service = null; 
			_import = null; 
			_implant = null; 
			_lot = null; 
			_sn = null; 
			_pacemaker = null; 
			_guaranteeperiod = null; 
			_minunit = null; 
			_barcode1 = null; 
			_barcode2 = null; 
			_barcode3 = null; 
			_barcode4 = null; 
			_user = new Guid(); 
			_linenbr = 0; 
			_error = false; 
			_error_desc = null; 
		}
		#endregion // End of Default ( Empty ) Class Constuctor
		
		#region Public Properties
			
		/// <summary>
		/// RI_ID
		/// </summary>		
		public Guid Id
		{
			get { return _id; }
			set { _id = value; }
		}
			
		/// <summary>
		/// 中文注册号
		/// </summary>		
		public string RegistrationNbrcn
		{
			get { return _registrationnbrcn; }
			set	
			{
				if( value!= null && value.Length > 200)
					throw new ArgumentOutOfRangeException("Invalid value for RegistrationNbrcn", value, value.ToString());
				
				_registrationnbrcn = value;
			}
		}
			
		/// <summary>
		/// 英文注册号
		/// </summary>		
		public string RegistrationNbren
		{
			get { return _registrationnbren; }
			set	
			{
				if( value!= null && value.Length > 200)
					throw new ArgumentOutOfRangeException("Invalid value for RegistrationNbren", value, value.ToString());
				
				_registrationnbren = value;
			}
		}

        /// <summary>
        /// 注册证产品名称
        /// </summary>		
        public string RegistrationProductName
        {
            get { return _registrationproductname; }
            set
            {
                if (value != null && value.Length > 200)
                    throw new ArgumentOutOfRangeException("Invalid value for RegistrationProductName", value, value.ToString());

                _registrationproductname = value;
            }
        }

		/// <summary>
		/// 注册证发证日期
		/// </summary>		
		public DateTime OpeningDate
		{
			get { return _openingdate; }
			set { _openingdate = value; }
		}
			
		/// <summary>
		/// 注册证有效期
		/// </summary>		
		public DateTime ExpirationDate
		{
			get { return _expirationdate; }
			set { _expirationdate = value; }
		}
			
		/// <summary>
		/// 产品编码
		/// </summary>		
		public string ArticleNumber
		{
			get { return _articlenumber; }
			set	
			{
				if( value!= null && value.Length > 200)
					throw new ArgumentOutOfRangeException("Invalid value for ArticleNumber", value, value.ToString());
				
				_articlenumber = value;
			}
		}
			
		/// <summary>
		/// 产品中文名称
		/// </summary>		
		public string ChineseName
		{
			get { return _chinesename; }
			set	
			{
				if( value!= null && value.Length > 200)
					throw new ArgumentOutOfRangeException("Invalid value for ChineseName", value, value.ToString());
				
				_chinesename = value;
			}
		}
			
		/// <summary>
		/// 产品英文名称
		/// </summary>		
		public string EnglishName
		{
			get { return _englishname; }
			set	
			{
				if( value!= null && value.Length > 200)
					throw new ArgumentOutOfRangeException("Invalid value for EnglishName", value, value.ToString());
				
				_englishname = value;
			}
		}
			
		/// <summary>
		/// 规格型号
		/// </summary>		
		public string Specification
		{
			get { return _specification; }
			set	
			{
				if( value!= null && value.Length > 200)
					throw new ArgumentOutOfRangeException("Invalid value for Specification", value, value.ToString());
				
				_specification = value;
			}
		}
			
		/// <summary>
		/// 生产企业ID
		/// </summary>		
		public string ManufacturerId
		{
			get { return _manufacturer_id; }
			set	
			{
				if( value!= null && value.Length > 200)
					throw new ArgumentOutOfRangeException("Invalid value for ManufacturerId", value, value.ToString());
				
				_manufacturer_id = value;
			}
		}
			
		/// <summary>
		/// 生产者名称
		/// </summary>		
		public string ManufacturerName
		{
			get { return _manufacturer_name; }
			set	
			{
				if( value!= null && value.Length > 200)
					throw new ArgumentOutOfRangeException("Invalid value for ManufacturerName", value, value.ToString());
				
				_manufacturer_name = value;
			}
		}
			
		/// <summary>
		/// 生产者地址
		/// </summary>		
		public string ManufacturerAddress
		{
			get { return _manufacturer_address; }
			set	
			{
				if( value!= null && value.Length > 200)
					throw new ArgumentOutOfRangeException("Invalid value for ManufacturerAddress", value, value.ToString());
				
				_manufacturer_address = value;
			}
		}
			
		/// <summary>
		/// 生产场所地址
		/// </summary>		
		public string ManufactoryAddress
		{
			get { return _manufactory_address; }
			set	
			{
				if( value!= null && value.Length > 200)
					throw new ArgumentOutOfRangeException("Invalid value for ManufactoryAddress", value, value.ToString());
				
				_manufactory_address = value;
			}
		}
			
		/// <summary>
		/// 产品适用范围
		/// </summary>		
		public string Scope
		{
			get { return _scope; }
			set	
			{
				if( value!= null && value.Length > 200)
					throw new ArgumentOutOfRangeException("Invalid value for Scope", value, value.ToString());
				
				_scope = value;
			}
		}
			
		/// <summary>
		/// 注册代理
		/// </summary>		
		public string RegisteredAgent
		{
			get { return _registeredagent; }
			set	
			{
				if( value!= null && value.Length > 200)
					throw new ArgumentOutOfRangeException("Invalid value for RegisteredAgent", value, value.ToString());
				
				_registeredagent = value;
			}
		}
			
		/// <summary>
		/// 售后服务机构
		/// </summary>		
		public string Service
		{
			get { return _service; }
			set	
			{
				if( value!= null && value.Length > 200)
					throw new ArgumentOutOfRangeException("Invalid value for Service", value, value.ToString());
				
				_service = value;
			}
		}
			
		/// <summary>
		/// 是否进口
		/// </summary>		
		public string Import
		{
			get { return _import; }
			set	
			{
				if( value!= null && value.Length > 50)
					throw new ArgumentOutOfRangeException("Invalid value for Import", value, value.ToString());
				
				_import = value;
			}
		}
			
		/// <summary>
		/// 是否植入物
		/// </summary>		
		public string Implant
		{
			get { return _implant; }
			set	
			{
				if( value!= null && value.Length > 50)
					throw new ArgumentOutOfRangeException("Invalid value for Implant", value, value.ToString());
				
				_implant = value;
			}
		}
			
		/// <summary>
		/// 是否按批次（LOT号）
		/// </summary>		
		public string Lot
		{
			get { return _lot; }
			set	
			{
				if( value!= null && value.Length > 50)
					throw new ArgumentOutOfRangeException("Invalid value for Lot", value, value.ToString());
				
				_lot = value;
			}
		}
			
		/// <summary>
		/// 是否按序列号（SN号）
		/// </summary>		
		public string Sn
		{
			get { return _sn; }
			set	
			{
				if( value!= null && value.Length > 50)
					throw new ArgumentOutOfRangeException("Invalid value for Sn", value, value.ToString());
				
				_sn = value;
			}
		}
			
		/// <summary>
		/// 是否起博器
		/// </summary>		
		public string Pacemaker
		{
			get { return _pacemaker; }
			set	
			{
				if( value!= null && value.Length > 50)
					throw new ArgumentOutOfRangeException("Invalid value for Pacemaker", value, value.ToString());
				
				_pacemaker = value;
			}
		}
			
		/// <summary>
		/// 保质期（按天）
		/// </summary>		
		public string GuaranteePeriod
		{
			get { return _guaranteeperiod; }
			set	
			{
				if( value!= null && value.Length > 50)
					throw new ArgumentOutOfRangeException("Invalid value for GuaranteePeriod", value, value.ToString());
				
				_guaranteeperiod = value;
			}
		}
			
		/// <summary>
		/// 最小收费单位
		/// </summary>		
		public string MinUnit
		{
			get { return _minunit; }
			set	
			{
				if( value!= null && value.Length > 50)
					throw new ArgumentOutOfRangeException("Invalid value for MinUnit", value, value.ToString());
				
				_minunit = value;
			}
		}
			
		/// <summary>
		/// 条码1
		/// </summary>		
		public string Barcode1
		{
			get { return _barcode1; }
			set	
			{
				if( value!= null && value.Length > 50)
					throw new ArgumentOutOfRangeException("Invalid value for Barcode1", value, value.ToString());
				
				_barcode1 = value;
			}
		}
			
		/// <summary>
		/// 条码2
		/// </summary>		
		public string Barcode2
		{
			get { return _barcode2; }
			set	
			{
				if( value!= null && value.Length > 50)
					throw new ArgumentOutOfRangeException("Invalid value for Barcode2", value, value.ToString());
				
				_barcode2 = value;
			}
		}
			
		/// <summary>
		/// 条码3
		/// </summary>		
		public string Barcode3
		{
			get { return _barcode3; }
			set	
			{
				if( value!= null && value.Length > 50)
					throw new ArgumentOutOfRangeException("Invalid value for Barcode3", value, value.ToString());
				
				_barcode3 = value;
			}
		}
			
		/// <summary>
		/// 条码4
		/// </summary>		
		public string Barcode4
		{
			get { return _barcode4; }
			set	
			{
				if( value!= null && value.Length > 50)
					throw new ArgumentOutOfRangeException("Invalid value for Barcode4", value, value.ToString());
				
				_barcode4 = value;
			}
		}
			
		/// <summary>
		/// RI_USER
		/// </summary>		
		public Guid User
		{
			get { return _user; }
			set { _user = value; }
		}
			
		/// <summary>
		/// RI_LineNbr
		/// </summary>		
		public int LineNbr
		{
			get { return _linenbr; }
			set { _linenbr = value; }
		}
			
		/// <summary>
		/// RI_ERROR
		/// </summary>		
		public bool Error
		{
			get { return _error; }
			set { _error = value; }
		}
			
		/// <summary>
		/// RI_ERROR_DESC
		/// </summary>		
		public string ErrorDesc
		{
			get { return _error_desc; }
			set	
			{
				if( value!= null && value.Length > 500)
					throw new ArgumentOutOfRangeException("Invalid value for ErrorDesc", value, value.ToString());
				
				_error_desc = value;
			}
		}
			
		
	
		
		#endregion 
		
		
		
		
		
	}
}
