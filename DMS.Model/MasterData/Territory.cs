/*
 * Ibatis.Net for Data Mapper
 * Copyright (C) 2009/2010 - GrapeCity
 * 
 * NameSpace : DMS.Model 
 * ClassName : Territory
 *  
*/
using System;

namespace DMS.Model
{
	/// <summary>
	///	Generated by MyGeneration using the IBatis Object Mapping template
	/// </summary>
	[Serializable]
	public sealed class Territory : BaseModel
	{
		#region Private Members
		
		private string _ter_description; 
		private Guid? _ter_id; 
		private Guid? _ter_parentid; 		
		#endregion
		
		#region Default ( Empty ) Class Constuctor
		/// <summary>
		/// default constructor
		/// </summary>
		public Territory()
		{
			_ter_description = null; 
			_ter_id = null; 
			_ter_parentid = null; 
		}
		#endregion // End of Default ( Empty ) Class Constuctor
		
		#region Public Properties
			
		/// <summary>
		/// 
		/// </summary>		
		public string Description
		{
			get { return _ter_description; }
			set	
			{
				if( value!= null && value.Length > 200)
					throw new ArgumentOutOfRangeException("Invalid value for Description", value, value.ToString());
				
				_ter_description = value;
			}
		}
			
		/// <summary>
		/// 
		/// </summary>		
		public Guid? TerId
		{
			get { return _ter_id; }
			set { _ter_id = value; }
		}
			
		/// <summary>
		/// 
		/// </summary>		
		public Guid? ParentId
		{
			get { return _ter_parentid; }
			set { _ter_parentid = value; }
		}
			
		
	
		
		#endregion 
		
		
		#region Public Functions
		
	
		
		#endregion
		
		
	}
}
