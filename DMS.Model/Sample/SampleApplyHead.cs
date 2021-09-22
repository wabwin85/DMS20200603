/*
 * Ibatis.Net for Data Mapper, and Generated by MyGeneration
 * 
 * NameSpace   : DMS.Model 
 * ClassName   : SampleApplyHead
 * Created Time: 2016/5/19 11:11:36
 *
 ******* Copyright (C) 2009/2010 - GrapeCity **********
 *
******************************************************/

using System;

namespace DMS.Model
{
	/// <summary>
	///	SampleApplyHead
	/// </summary>
	[Serializable]
	public class SampleApplyHead : BaseModel
	{
		#region Private Members 35
		
		private Guid _sampleapplyheadid; 
		private string _sampletype; 
		private string _applyno; 
		private Guid? _dealerid; 
		private string _applyquantity; 
		private string _remainquantity; 
		private string _applydate; 
		private string _applyuserid; 
		private string _applyuser; 
		private string _processuserid; 
		private string _processuser; 
		private string _applydept; 
		private string _applydivision; 
		private string _custtype; 
		private string _custname; 
		private string _arrivaldate; 
		private string _applypurpose; 
		private string _applycost; 
		private string _irfno; 
		private string _hospname; 
		private string _hpspaddress; 
		private string _trialdoctor; 
		private string _receiptuser; 
		private string _receiptphone; 
		private string _receiptaddress; 
		private string _dealername; 
		private string _applymemo; 
		private string _confirmitem1; 
		private string _confirmitem2;
        private string _confirmitem3; 
		private string _costcenter;
        private string _applystatus;
        private string _createuser;
        private DateTime? _createdate; 
		private string _updateuser; 
		private DateTime? _updatedate; 		
		#endregion
		
		#region Default ( Empty ) Class Constuctor
		/// <summary>
		/// default constructor
		/// </summary>
		public SampleApplyHead()
		{
			_sampleapplyheadid = Guid.Empty; 
			_sampletype = null; 
			_applyno = null; 
			_dealerid = null;
			_applyquantity = null; 
			_remainquantity = null; 
			_applydate = null; 
			_applyuserid = null; 
			_applyuser = null; 
			_processuserid = null; 
			_processuser = null; 
			_applydept = null; 
			_applydivision = null; 
			_custtype = null; 
			_custname = null; 
			_arrivaldate = null; 
			_applypurpose = null; 
			_applycost = null; 
			_irfno = null; 
			_hospname = null; 
			_hpspaddress = null; 
			_trialdoctor = null; 
			_receiptuser = null; 
			_receiptphone = null; 
			_receiptaddress = null; 
			_dealername = null; 
			_applymemo = null; 
			_confirmitem1 = null; 
			_confirmitem2 = null;
            _confirmitem3 = null; 
			_costcenter = null;
            _applystatus = null;
            _createuser = null;
            _createdate = null;
			_updateuser = null; 
			_updatedate = null;
		}
		#endregion // End of Default ( Empty ) Class Constuctor
		
		#region Public Properties
			
		/// <summary>
		/// 样品申请主ID
		/// </summary>		
		public Guid SampleApplyHeadId
		{
			get { return _sampleapplyheadid; }
			set { _sampleapplyheadid = value; }
		}
			
		/// <summary>
		/// 样品类型
		/// </summary>		
		public string SampleType
		{
			get { return _sampletype; }
			set	
			{
				if( value!= null && value.Length > 500)
					throw new ArgumentOutOfRangeException("Invalid value for SampleType", value, value.ToString());
				
				_sampletype = value;
			}
		}
			
		/// <summary>
		/// 申请单编号
		/// </summary>		
		public string ApplyNo
		{
			get { return _applyno; }
			set	
			{
				if( value!= null && value.Length > 100)
					throw new ArgumentOutOfRangeException("Invalid value for ApplyNo", value, value.ToString());
				
				_applyno = value;
			}
		}
			
		/// <summary>
		/// 经销商ID
		/// </summary>		
		public Guid? DealerId
		{
			get { return _dealerid; }
			set { _dealerid = value; }
		}
			
		/// <summary>
		/// 申请数量
		/// </summary>		
		public string ApplyQuantity
		{
			get { return _applyquantity; }
			set	
			{
				if( value!= null && value.Length > 500)
					throw new ArgumentOutOfRangeException("Invalid value for ApplyQuantity", value, value.ToString());
				
				_applyquantity = value;
			}
		}
			
		/// <summary>
		/// 剩余库存数量
		/// </summary>		
		public string RemainQuantity
		{
			get { return _remainquantity; }
			set	
			{
				if( value!= null && value.Length > 500)
					throw new ArgumentOutOfRangeException("Invalid value for RemainQuantity", value, value.ToString());
				
				_remainquantity = value;
			}
		}
			
		/// <summary>
		/// 申请日期
		/// </summary>		
		public string ApplyDate
		{
			get { return _applydate; }
			set	
			{
				if( value!= null && value.Length > 500)
					throw new ArgumentOutOfRangeException("Invalid value for ApplyDate", value, value.ToString());
				
				_applydate = value;
			}
		}
			
		/// <summary>
		/// 申请人ID
		/// </summary>		
		public string ApplyUserId
		{
			get { return _applyuserid; }
			set	
			{
				if( value!= null && value.Length > 500)
					throw new ArgumentOutOfRangeException("Invalid value for ApplyUserId", value, value.ToString());
				
				_applyuserid = value;
			}
		}
			
		/// <summary>
		/// 申请者
		/// </summary>		
		public string ApplyUser
		{
			get { return _applyuser; }
			set	
			{
				if( value!= null && value.Length > 500)
					throw new ArgumentOutOfRangeException("Invalid value for ApplyUser", value, value.ToString());
				
				_applyuser = value;
			}
		}
			
		/// <summary>
		/// 使用人ID
		/// </summary>		
		public string ProcessUserId
		{
			get { return _processuserid; }
			set	
			{
				if( value!= null && value.Length > 500)
					throw new ArgumentOutOfRangeException("Invalid value for ProcessUserId", value, value.ToString());
				
				_processuserid = value;
			}
		}
			
		/// <summary>
		/// 使用人
		/// </summary>		
		public string ProcessUser
		{
			get { return _processuser; }
			set	
			{
				if( value!= null && value.Length > 500)
					throw new ArgumentOutOfRangeException("Invalid value for ProcessUser", value, value.ToString());
				
				_processuser = value;
			}
		}
			
		/// <summary>
		/// 部门
		/// </summary>		
		public string ApplyDept
		{
			get { return _applydept; }
			set	
			{
				if( value!= null && value.Length > 500)
					throw new ArgumentOutOfRangeException("Invalid value for ApplyDept", value, value.ToString());
				
				_applydept = value;
			}
		}
			
		/// <summary>
		/// 事业部
		/// </summary>		
		public string ApplyDivision
		{
			get { return _applydivision; }
			set	
			{
				if( value!= null && value.Length > 500)
					throw new ArgumentOutOfRangeException("Invalid value for ApplyDivision", value, value.ToString());
				
				_applydivision = value;
			}
		}
			
		/// <summary>
		/// 客户类型
		/// </summary>		
		public string CustType
		{
			get { return _custtype; }
			set	
			{
				if( value!= null && value.Length > 500)
					throw new ArgumentOutOfRangeException("Invalid value for CustType", value, value.ToString());
				
				_custtype = value;
			}
		}
			
		/// <summary>
		/// 客户名称
		/// </summary>		
		public string CustName
		{
			get { return _custname; }
			set	
			{
				if( value!= null && value.Length > 500)
					throw new ArgumentOutOfRangeException("Invalid value for CustName", value, value.ToString());
				
				_custname = value;
			}
		}
			
		/// <summary>
		/// 期望到货时间
		/// </summary>		
		public string ArrivalDate
		{
			get { return _arrivaldate; }
			set	
			{
				if( value!= null && value.Length > 500)
					throw new ArgumentOutOfRangeException("Invalid value for ArrivalDate", value, value.ToString());
				
				_arrivaldate = value;
			}
		}
			
		/// <summary>
		/// 申请目的
		/// </summary>		
		public string ApplyPurpose
		{
			get { return _applypurpose; }
			set	
			{
				if( value!= null && value.Length > 500)
					throw new ArgumentOutOfRangeException("Invalid value for ApplyPurpose", value, value.ToString());
				
				_applypurpose = value;
			}
		}
			
		/// <summary>
		/// 费用分摊
		/// </summary>		
		public string ApplyCost
		{
			get { return _applycost; }
			set	
			{
				if( value!= null && value.Length > 500)
					throw new ArgumentOutOfRangeException("Invalid value for ApplyCost", value, value.ToString());
				
				_applycost = value;
			}
		}
			
		/// <summary>
		/// IRF编号
		/// </summary>		
		public string IrfNo
		{
			get { return _irfno; }
			set	
			{
				if( value!= null && value.Length > 500)
					throw new ArgumentOutOfRangeException("Invalid value for IrfNo", value, value.ToString());
				
				_irfno = value;
			}
		}
			
		/// <summary>
		/// 医院名称
		/// </summary>		
		public string HospName
		{
			get { return _hospname; }
			set	
			{
				if( value!= null && value.Length > 500)
					throw new ArgumentOutOfRangeException("Invalid value for HospName", value, value.ToString());
				
				_hospname = value;
			}
		}
			
		/// <summary>
		/// 医院地址
		/// </summary>		
		public string HpspAddress
		{
			get { return _hpspaddress; }
			set	
			{
				if( value!= null && value.Length > 500)
					throw new ArgumentOutOfRangeException("Invalid value for HpspAddress", value, value.ToString());
				
				_hpspaddress = value;
			}
		}
			
		/// <summary>
		/// 试用医生姓名
		/// </summary>		
		public string TrialDoctor
		{
			get { return _trialdoctor; }
			set	
			{
				if( value!= null && value.Length > 500)
					throw new ArgumentOutOfRangeException("Invalid value for TrialDoctor", value, value.ToString());
				
				_trialdoctor = value;
			}
		}
			
		/// <summary>
		/// 收货人
		/// </summary>		
		public string ReceiptUser
		{
			get { return _receiptuser; }
			set	
			{
				if( value!= null && value.Length > 500)
					throw new ArgumentOutOfRangeException("Invalid value for ReceiptUser", value, value.ToString());
				
				_receiptuser = value;
			}
		}
			
		/// <summary>
		/// 收货人联系方式
		/// </summary>		
		public string ReceiptPhone
		{
			get { return _receiptphone; }
			set	
			{
				if( value!= null && value.Length > 500)
					throw new ArgumentOutOfRangeException("Invalid value for ReceiptPhone", value, value.ToString());
				
				_receiptphone = value;
			}
		}
			
		/// <summary>
		/// 收货地址
		/// </summary>		
		public string ReceiptAddress
		{
			get { return _receiptaddress; }
			set	
			{
				if( value!= null && value.Length > 500)
					throw new ArgumentOutOfRangeException("Invalid value for ReceiptAddress", value, value.ToString());
				
				_receiptaddress = value;
			}
		}
			
		/// <summary>
		/// 经销商
		/// </summary>		
		public string DealerName
		{
			get { return _dealername; }
			set	
			{
				if( value!= null && value.Length > 500)
					throw new ArgumentOutOfRangeException("Invalid value for DealerName", value, value.ToString());
				
				_dealername = value;
			}
		}
			
		/// <summary>
		/// 备注
		/// </summary>		
		public string ApplyMemo
		{
			get { return _applymemo; }
			set	
			{
				if( value!= null && value.Length > 500)
					throw new ArgumentOutOfRangeException("Invalid value for ApplyMemo", value, value.ToString());
				
				_applymemo = value;
			}
		}
			
		/// <summary>
		/// 已确认事项1
		/// </summary>		
		public string ConfirmItem1
		{
			get { return _confirmitem1; }
			set	
			{
				if( value!= null && value.Length > 500)
					throw new ArgumentOutOfRangeException("Invalid value for ConfirmItem1", value, value.ToString());
				
				_confirmitem1 = value;
			}
		}
			
		/// <summary>
		/// 已确认事项2
		/// </summary>		
		public string ConfirmItem2
		{
			get { return _confirmitem2; }
			set	
			{
				if( value!= null && value.Length > 500)
					throw new ArgumentOutOfRangeException("Invalid value for ConfirmItem2", value, value.ToString());
				
				_confirmitem2 = value;
			}
		}

        /// <summary>
        /// 已确认事项3
        /// </summary>		
        public string ConfirmItem3
        {
            get { return _confirmitem3; }
            set
            {
                if (value != null && value.Length > 500)
                    throw new ArgumentOutOfRangeException("Invalid value for ConfirmItem3", value, value.ToString());

                _confirmitem3 = value;
            }
        }

		/// <summary>
		/// CostCenter
		/// </summary>		
		public string CostCenter
		{
			get { return _costcenter; }
			set	
			{
				if( value!= null && value.Length > 500)
					throw new ArgumentOutOfRangeException("Invalid value for CostCenter", value, value.ToString());
				
				_costcenter = value;
			}
		}
			
		/// <summary>
		/// New 新申请<br/>   InApproval 审批中<br/>   Approved 审批通过<br/>   Delivery 已发货<br/>   Receive 收货确认<br/>   Deny 审批拒绝<br/>   Complete Complete
		/// </summary>		
		public string ApplyStatus
		{
			get { return _applystatus; }
			set	
			{
				if( value!= null && value.Length > 20)
					throw new ArgumentOutOfRangeException("Invalid value for ApplyStatus", value, value.ToString());
				
				_applystatus = value;
			}
		}

        /// <summary>
        /// 创建人
        /// </summary>		
        public string CreateUser
        {
            get { return _createuser; }
            set
            {
                if (value != null && value.Length > 20)
                    throw new ArgumentOutOfRangeException("Invalid value for CreateUser", value, value.ToString());

                _createuser = value;
            }
        }

        /// <summary>
        /// 创建时间
        /// </summary>		
        public DateTime? CreateDate
        {
            get { return _createdate; }
            set { _createdate = value; }
        }

		/// <summary>
		/// 更新人
		/// </summary>		
		public string UpdateUser
		{
			get { return _updateuser; }
			set	
			{
				if( value!= null && value.Length > 20)
					throw new ArgumentOutOfRangeException("Invalid value for UpdateUser", value, value.ToString());
				
				_updateuser = value;
			}
		}
			
		/// <summary>
		/// 更新时间
		/// </summary>		
		public DateTime? UpdateDate
		{
			get { return _updatedate; }
			set { _updatedate = value; }
		}
			
		
	
		
		#endregion 
		
		
		
		
		
	}
}
