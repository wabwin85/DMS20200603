/*
 * Ibatis.Net for Data Mapper, and Generated by MyGeneration
 * 
 * NameSpace   : DMS.Model 
 * ClassName   : Interfacet2ContactInfo
 * Created Time: 2017/10/16 11:15:03
 *
 ******* Copyright (C) 2009/2010 - GrapeCity **********
 *
******************************************************/

using System;

namespace DMS.Model
{
	/// <summary>
	///	Interfacet2ContactInfo
	/// </summary>
	[Serializable]
	public class Interfacet2ContactInfo 
	{
		#region Private Members 16
		
		private Guid _id; 
		private string _distributorid; 
		private string _distributorname; 
		private string _position; 
		private string _contract; 
		private string _phone; 
		private string _mobile; 
		private string _email; 
		private string _address; 
		private string _remark; 
		private int _linenbr; 
		private string _filename; 
		private DateTime _importdate; 
		private string _clientid; 
		private string _batchnbr; 
		private string _errormsg; 		
		#endregion
		
		#region Default ( Empty ) Class Constuctor
		/// <summary>
		/// default constructor
		/// </summary>
		public Interfacet2ContactInfo()
		{
			_id = Guid.Empty; 
			_distributorid = null; 
			_distributorname = null; 
			_position = null; 
			_contract = null; 
			_phone = null; 
			_mobile = null; 
			_email = null; 
			_address = null; 
			_remark = null; 
			_linenbr = 0; 
			_filename = null; 
			_importdate = new DateTime(); 
			_clientid = null; 
			_batchnbr = null; 
			_errormsg = null; 
		}
		#endregion // End of Default ( Empty ) Class Constuctor
		
		#region Public Properties
			
		/// <summary>
		/// 
		/// </summary>		
		public Guid Id
		{
			get { return _id; }
			set { _id = value; }
		}
			
		/// <summary>
		/// 
		/// </summary>		
		public string Distributorid
		{
			get { return _distributorid; }
			set	
			{
				if( value!= null && value.Length > 50)
					throw new ArgumentOutOfRangeException("Invalid value for Distributorid", value, value.ToString());
				
				_distributorid = value;
			}
		}
			
		/// <summary>
		/// 
		/// </summary>		
		public string DistributorName
		{
			get { return _distributorname; }
			set	
			{
				if( value!= null && value.Length > 200)
					throw new ArgumentOutOfRangeException("Invalid value for DistributorName", value, value.ToString());
				
				_distributorname = value;
			}
		}
			
		/// <summary>
		/// 
		/// </summary>		
		public string Position
		{
			get { return _position; }
			set	
			{
				_position = value;
			}
		}
			
		/// <summary>
		/// 
		/// </summary>		
		public string Contract
		{
			get { return _contract; }
			set	
			{
				_contract = value;
			}
		}
			
		/// <summary>
		/// 
		/// </summary>		
		public string Phone
		{
			get { return _phone; }
			set	
			{
				_phone = value;
			}
		}
			
		/// <summary>
		/// 
		/// </summary>		
		public string Mobile
		{
			get { return _mobile; }
			set	
			{
				_mobile = value;
			}
		}
			
		/// <summary>
		/// 
		/// </summary>		
		public string Email
		{
			get { return _email; }
			set	
			{
				_email = value;
			}
		}
			
		/// <summary>
		/// 
		/// </summary>		
		public string Address
		{
			get { return _address; }
			set	
			{
				_address = value;
			}
		}
			
		/// <summary>
		/// 
		/// </summary>		
		public string Remark
		{
			get { return _remark; }
			set	
			{
				_remark = value;
			}
		}
			
		/// <summary>
		/// 
		/// </summary>		
		public int LineNbr
		{
			get { return _linenbr; }
			set { _linenbr = value; }
		}
			
		/// <summary>
		/// 
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
		/// 
		/// </summary>		
		public DateTime ImportDate
		{
			get { return _importdate; }
			set { _importdate = value; }
		}
			
		/// <summary>
		/// 
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
		/// 
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
		/// 
		/// </summary>		
		public string ErrorMsg
		{
			get { return _errormsg; }
			set	
			{
				if( value!= null && value.Length > 2000)
					throw new ArgumentOutOfRangeException("Invalid value for ErrorMsg", value, value.ToString());
				
				_errormsg = value;
			}
		}
			
		
	
		
		#endregion 
		
		
		
		
		
	}
}
