/*
 * Ibatis.Net for Data Mapper, and Generated by MyGeneration
 * 
 * NameSpace   : DMS.Model 
 * ClassName   : MedicalDevices
 * Created Time: 2013/11/12 17:41:42
 *
 ******* Copyright (C) 2009/2010 - GrapeCity **********
 *
******************************************************/

using System;

namespace DMS.Model
{
	/// <summary>
	///	MedicalDevices
	/// </summary>
	[Serializable]
	public class MedicalDevices : BaseModel
	{
		#region Private Members 8
		
		private Guid _id; 
		private Guid _cm_id; 
		private string _name; 
		private string _describe; 
		private DateTime? _update_date; 
		private Guid? _update_user; 		
		#endregion
		
		#region Default ( Empty ) Class Constuctor
		/// <summary>
		/// default constructor
		/// </summary>
		public MedicalDevices()
		{
			_id = Guid.Empty; 
			_cm_id = Guid.Empty; 
			_name = null; 
			_describe = null; 
			_update_date = null;
			_update_user = null;
		}
		#endregion // End of Default ( Empty ) Class Constuctor
		
		#region Public Properties
			
		/// <summary>
		/// ID
		/// </summary>		
		public Guid Id
		{
			get { return _id; }
			set { _id = value; }
		}
			
		/// <summary>
		/// 公司ID
		/// </summary>		
		public Guid CmId
		{
			get { return _cm_id; }
			set { _cm_id = value; }
		}
			
		/// <summary>
		/// MD_Name
		/// </summary>		
		public string Name
		{
			get { return _name; }
			set	
			{
				if( value!= null && value.Length > 100)
					throw new ArgumentOutOfRangeException("Invalid value for Name", value, value.ToString());
				
				_name = value;
			}
		}
			
		/// <summary>
		/// MD_Describe
		/// </summary>		
		public string Describe
		{
			get { return _describe; }
			set	
			{
				if( value!= null && value.Length > 200)
					throw new ArgumentOutOfRangeException("Invalid value for Describe", value, value.ToString());
				
				_describe = value;
			}
		}
			
		/// <summary>
		/// 更新日期
		/// </summary>		
		public DateTime? UpdateDate
		{
			get { return _update_date; }
			set { _update_date = value; }
		}
			
		/// <summary>
		/// 更新人
		/// </summary>		
		public Guid? UpdateUser
		{
			get { return _update_user; }
			set { _update_user = value; }
		}
			
		
	
		
		#endregion 
		
		
		
		
		
	}
}
