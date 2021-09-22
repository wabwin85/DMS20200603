/*
 * Ibatis.Net for Data Mapper, and Generated by MyGeneration
 * 
 * NameSpace   : DMS.Model 
 * ClassName   : Warehouse
 * Created Time: 2009-7-10 14:08:13
 *
 ******* Copyright (C) 2009/2010 - GrapeCity **********
 *
******************************************************/

using System;

namespace DMS.Model
{
	/// <summary>
	///	Warehouse
	/// </summary>
	[Serializable]
	public class Warehouse : BaseModel
	{
		#region Private Members
		
		private Guid? _dma_id; 
		private string _name; 
		private string _province; 
		private Guid? _id; 
		private string _city; 
		private string _type; 
		private Guid? _con_id; 
		private string _postalcode; 
		private string _address; 
		private bool? _holdwarehouse; 
		private string _town; 
		private string _district; 
		private string _phone; 
		private string _fax; 
		private bool? _activeflag; 
		private Guid? _hospital_hos_id;
        private string _code;
        private string _dealername;
        private string _typename;
		#endregion
		
		#region Default ( Empty ) Class Constuctor
		/// <summary>
		/// default constructor
		/// </summary>
		public Warehouse()
		{
			_dma_id = null; 
			_name = null; 
			_province = null; 
			_id = null; 
			_city = null; 
			_type = null; 
			_con_id = null; 
			_postalcode = null; 
			_address = null; 
			_holdwarehouse = null; 
			_town = null; 
			_district = null; 
			_phone = null; 
			_fax = null; 
			_activeflag = null; 
			_hospital_hos_id = null;
            _code = null;
            _dealername = null;
            _typename = null;
		}
		#endregion // End of Default ( Empty ) Class Constuctor
		
		#region Public Properties
			
		/// <summary>
		/// 经销商

		/// </summary>		
		public Guid? DmaId
		{
			get { return _dma_id; }
			set { _dma_id = value; }
		}
			
		/// <summary>
		/// 仓库名称
		/// </summary>		
		public string Name
		{
			get { return _name; }
			set	
			{
				if( value!= null && value.Length > 50)
					throw new ArgumentOutOfRangeException("Invalid value for Name", value, value.ToString());
				
				_name = value;
			}
		}
			
		/// <summary>
		/// 省份
		/// </summary>		
		public string Province
		{
			get { return _province; }
			set	
			{
				if( value!= null && value.Length > 50)
					throw new ArgumentOutOfRangeException("Invalid value for Province", value, value.ToString());
				
				_province = value;
			}
		}
			
		/// <summary>
		/// 仓库
		/// </summary>		
		public Guid? Id
		{
			get { return _id; }
			set { _id = value; }
		}
			
		/// <summary>
		/// 城市
		/// </summary>		
		public string City
		{
			get { return _city; }
			set	
			{
				if( value!= null && value.Length > 50)
					throw new ArgumentOutOfRangeException("Invalid value for City", value, value.ToString());
				
				_city = value;
			}
		}
			
		/// <summary>
		/// 仓库的类型

		/// </summary>		
		public string Type
		{
			get { return _type; }
			set	
			{
				if( value!= null && value.Length > 50)
					throw new ArgumentOutOfRangeException("Invalid value for Type", value, value.ToString());
				
				_type = value;
			}
		}
			
		/// <summary>
		/// 联系人

		/// </summary>		
		public Guid? ConId
		{
			get { return _con_id; }
			set { _con_id = value; }
		}
			
		/// <summary>
		/// 邮编
		/// </summary>		
		public string PostalCode
		{
			get { return _postalcode; }
			set	
			{
				if( value!= null && value.Length > 50)
					throw new ArgumentOutOfRangeException("Invalid value for PostalCode", value, value.ToString());
				
				_postalcode = value;
			}
		}
			
		/// <summary>
		/// 地址
		/// </summary>		
		public string Address
		{
			get { return _address; }
			set	
			{
				if( value!= null && value.Length > 200)
					throw new ArgumentOutOfRangeException("Invalid value for Address", value, value.ToString());
				
				_address = value;
			}
		}
			
		/// <summary>
		/// 保留仓库标志
		/// </summary>		
		public bool? HoldWarehouse
		{
			get { return _holdwarehouse; }
			set { _holdwarehouse = value; }
		}
			
		/// <summary>
		/// 镇

		/// </summary>		
		public string Town
		{
			get { return _town; }
			set	
			{
				if( value!= null && value.Length > 50)
					throw new ArgumentOutOfRangeException("Invalid value for Town", value, value.ToString());
				
				_town = value;
			}
		}
			
		/// <summary>
		/// 区或乡

		/// </summary>		
		public string District
		{
			get { return _district; }
			set	
			{
				if( value!= null && value.Length > 50)
					throw new ArgumentOutOfRangeException("Invalid value for District", value, value.ToString());
				
				_district = value;
			}
		}
			
		/// <summary>
		/// 电话
		/// </summary>		
		public string Phone
		{
			get { return _phone; }
			set	
			{
				if( value!= null && value.Length > 50)
					throw new ArgumentOutOfRangeException("Invalid value for Phone", value, value.ToString());
				
				_phone = value;
			}
		}
			
		/// <summary>
		/// 传真
		/// </summary>		
		public string Fax
		{
			get { return _fax; }
			set	
			{
				if( value!= null && value.Length > 50)
					throw new ArgumentOutOfRangeException("Invalid value for Fax", value, value.ToString());
				
				_fax = value;
			}
		}
			
		/// <summary>
		/// 有效标志
		/// </summary>		
		public bool? ActiveFlag
		{
			get { return _activeflag; }
			set { _activeflag = value; }
		}
			
		/// <summary>
		/// 仓库所在医院

		/// </summary>		
		public Guid? HospitalHosId
		{
			get { return _hospital_hos_id; }
			set { _hospital_hos_id = value; }
		}

        /// <summary>
        /// 仓库代码
        /// </summary>		
        public string Code
        {
            get { return _code; }
            set
            {
                if (value != null && value.Length > 50)
                    throw new ArgumentOutOfRangeException("Invalid value for Code", value, value.ToString());

                _code = value;
            }
        }

        /// <summary>
        /// 经销商名称
        /// </summary>
        public string DealerName
        {
            get { return _dealername; }
            set { _dealername = value; }
        }

        /// <summary>
        /// 仓库类型名称
        /// </summary>
        public string TypeName
        {
            get { return _typename; }
            set { _typename = value; }
        }

        #endregion
        

    }
}
