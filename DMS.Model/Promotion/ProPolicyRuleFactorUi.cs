/*
 * Ibatis.Net for Data Mapper, and Generated by MyGeneration
 * 
 * NameSpace   : DMS.Model 
 * ClassName   : ProPolicyRuleFactorUi
 * Created Time: 2016/1/14 15:26:22
 *
 ******* Copyright (C) 2009/2010 - GrapeCity **********
 *
******************************************************/

using System;

namespace DMS.Model
{
	/// <summary>
	///	ProPolicyRuleFactorUi
	/// </summary>
	[Serializable]
	public class ProPolicyRuleFactorUi : BaseModel
	{
		#region Private Members 17
		
		private int _rulefactorid; 
		private int? _ruleid; 
		private int? _policyfactorid; 
		private string _logictype; 
		private string _logicsymbol; 
		private decimal? _absolutevalue1; 
		private decimal? _absolutevalue2; 
		private string _relativevalue1; 
		private string _relativevalue2; 
		private decimal? _otherpolicyfactoridratio; 
		private int? _otherpolicyfactorid; 
		private string _createby; 
		private DateTime? _createtime; 
		private string _modifyby; 
		private DateTime? _modifydate; 
		private string _remark1; 
		private string _curruser; 		
		#endregion
		
		#region Default ( Empty ) Class Constuctor
		/// <summary>
		/// default constructor
		/// </summary>
		public ProPolicyRuleFactorUi()
		{
			_rulefactorid = 0; 
			_ruleid = null;
			_policyfactorid = null;
			_logictype = null; 
			_logicsymbol = null; 
			_absolutevalue1 = null;
			_absolutevalue2 = null;
			_relativevalue1 = null; 
			_relativevalue2 = null; 
			_otherpolicyfactoridratio = null;
			_otherpolicyfactorid = null;
			_createby = null; 
			_createtime = null;
			_modifyby = null; 
			_modifydate = null;
			_remark1 = null; 
			_curruser = null; 
		}
		#endregion // End of Default ( Empty ) Class Constuctor
		
		#region Public Properties
			
		/// <summary>
		/// 
		/// </summary>		
		public int RuleFactorId
		{
			get { return _rulefactorid; }
			set { _rulefactorid = value; }
		}
			
		/// <summary>
		/// 
		/// </summary>		
		public int? RuleId
		{
			get { return _ruleid; }
			set { _ruleid = value; }
		}
			
		/// <summary>
		/// 
		/// </summary>		
		public int? PolicyFactorId
		{
			get { return _policyfactorid; }
			set { _policyfactorid = value; }
		}
			
		/// <summary>
		/// 
		/// </summary>		
		public string LogicType
		{
			get { return _logictype; }
			set	
			{
				if( value!= null && value.Length > 20)
					throw new ArgumentOutOfRangeException("Invalid value for LogicType", value, value.ToString());
				
				_logictype = value;
			}
		}
			
		/// <summary>
		/// 
		/// </summary>		
		public string LogicSymbol
		{
			get { return _logicsymbol; }
			set	
			{
				if( value!= null && value.Length > 20)
					throw new ArgumentOutOfRangeException("Invalid value for LogicSymbol", value, value.ToString());
				
				_logicsymbol = value;
			}
		}
			
		/// <summary>
		/// 
		/// </summary>		
		public decimal? AbsoluteValue1
		{
			get { return _absolutevalue1; }
			set { _absolutevalue1 = value; }
		}
			
		/// <summary>
		/// 
		/// </summary>		
		public decimal? AbsoluteValue2
		{
			get { return _absolutevalue2; }
			set { _absolutevalue2 = value; }
		}
			
		/// <summary>
		/// 
		/// </summary>		
		public string RelativeValue1
		{
			get { return _relativevalue1; }
			set	
			{
				if( value!= null && value.Length > 50)
					throw new ArgumentOutOfRangeException("Invalid value for RelativeValue1", value, value.ToString());
				
				_relativevalue1 = value;
			}
		}
			
		/// <summary>
		/// 
		/// </summary>		
		public string RelativeValue2
		{
			get { return _relativevalue2; }
			set	
			{
				if( value!= null && value.Length > 50)
					throw new ArgumentOutOfRangeException("Invalid value for RelativeValue2", value, value.ToString());
				
				_relativevalue2 = value;
			}
		}
			
		/// <summary>
		/// 
		/// </summary>		
		public decimal? OtherPolicyFactorIdRatio
		{
			get { return _otherpolicyfactoridratio; }
			set { _otherpolicyfactoridratio = value; }
		}
			
		/// <summary>
		/// 
		/// </summary>		
		public int? OtherPolicyFactorId
		{
			get { return _otherpolicyfactorid; }
			set { _otherpolicyfactorid = value; }
		}
			
		/// <summary>
		/// 
		/// </summary>		
		public string CreateBy
		{
			get { return _createby; }
			set	
			{
				if( value!= null && value.Length > 50)
					throw new ArgumentOutOfRangeException("Invalid value for CreateBy", value, value.ToString());
				
				_createby = value;
			}
		}
			
		/// <summary>
		/// 
		/// </summary>		
		public DateTime? CreateTime
		{
			get { return _createtime; }
			set { _createtime = value; }
		}
			
		/// <summary>
		/// 
		/// </summary>		
		public string ModifyBy
		{
			get { return _modifyby; }
			set	
			{
				if( value!= null && value.Length > 50)
					throw new ArgumentOutOfRangeException("Invalid value for ModifyBy", value, value.ToString());
				
				_modifyby = value;
			}
		}
			
		/// <summary>
		/// 
		/// </summary>		
		public DateTime? ModifyDate
		{
			get { return _modifydate; }
			set { _modifydate = value; }
		}
			
		/// <summary>
		/// 
		/// </summary>		
		public string Remark1
		{
			get { return _remark1; }
			set	
			{
				if( value!= null && value.Length > 100)
					throw new ArgumentOutOfRangeException("Invalid value for Remark1", value, value.ToString());
				
				_remark1 = value;
			}
		}
			
		/// <summary>
		/// 
		/// </summary>		
		public string CurrUser
		{
			get { return _curruser; }
			set	
			{
				if( value!= null && value.Length > 50)
					throw new ArgumentOutOfRangeException("Invalid value for CurrUser", value, value.ToString());
				
				_curruser = value;
			}
		}
			
		
	
		
		#endregion 
		
		
		
		
		
	}
}
