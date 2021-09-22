/*
 * Ibatis.Net for Data Mapper, and Generated by MyGeneration
 * 
 * NameSpace   : DMS.Model 
 * ClassName   : CfnSet
 * Created Time: 2010-4-26 16:43:42
 *
 ******* Copyright (C) 2009/2010 - GrapeCity **********
 *
******************************************************/

using System;

namespace DMS.Model
{
	/// <summary>
	///	CfnSet
	/// </summary>
	[Serializable]
	public class CfnSet : BaseModel
	{
		#region Private Members
		
		private Guid _id; 
		private string _chinesename; 
		private string _englishname; 
		private Guid _productline_bum_id; 
		private Guid? _updateuser; 
		private DateTime? _updatedate; 
		private bool _deleteflag; 		
		#endregion
		
		#region Default ( Empty ) Class Constuctor
		/// <summary>
		/// default constructor
		/// </summary>
		public CfnSet()
		{
			_id = new Guid(); 
			_chinesename = null; 
			_englishname = null; 
			_productline_bum_id = new Guid(); 
			_updateuser = null;
			_updatedate = null;
			_deleteflag = false; 
		}
		#endregion // End of Default ( Empty ) Class Constuctor
		
		#region Public Properties
			
		/// <summary>
		/// CFNS_ID
		/// </summary>		
		public Guid Id
		{
			get { return _id; }
			set { _id = value; }
		}
			
		/// <summary>
		/// CFNS_ChineseName
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
		/// CFNS_EnglishName
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
		/// CFNS_ProductLine_BUM_ID
		/// </summary>		
		public Guid ProductLineBumId
		{
			get { return _productline_bum_id; }
			set { _productline_bum_id = value; }
		}
			
		/// <summary>
		/// CFNS_UpdateUser
		/// </summary>		
		public Guid? UpdateUser
		{
			get { return _updateuser; }
			set { _updateuser = value; }
		}
			
		/// <summary>
		/// CFNS_UpdateDate
		/// </summary>		
		public DateTime? UpdateDate
		{
			get { return _updatedate; }
			set { _updatedate = value; }
		}
			
		/// <summary>
		/// CFNS_DeleteFlag
		/// </summary>		
		public bool DeleteFlag
		{
			get { return _deleteflag; }
			set { _deleteflag = value; }
		}
			
		
	
		
		#endregion 
		
		
		
		
		
	}
}
