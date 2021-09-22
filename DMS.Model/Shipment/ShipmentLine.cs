/*
 * Ibatis.Net for Data Mapper, and Generated by MyGeneration
 * 
 * NameSpace   : DMS.Model 
 * ClassName   : ShipmentLine
 * Created Time: 2009-8-13 13:51:16
 *
 ******* Copyright (C) 2009/2010 - GrapeCity **********
 *
******************************************************/

using System;

namespace DMS.Model
{
	/// <summary>
	///	ShipmentLine
	/// </summary>
	[Serializable]
	public class ShipmentLine : BaseModel
	{
		#region Private Members
		
		private Guid _id; 
		private Guid _sph_id; 
		private Guid _shipment_pma_id; 
		private double _shipmentqty; 
		private double? _unitprice; 
		private int? _linenbr; 		
		#endregion
		
		#region Default ( Empty ) Class Constuctor
		/// <summary>
		/// default constructor
		/// </summary>
		public ShipmentLine()
		{
			_id = new Guid(); 
			_sph_id = new Guid(); 
			_shipment_pma_id = new Guid(); 
			_shipmentqty = new double(); 
		}
		#endregion // End of Default ( Empty ) Class Constuctor
		
		#region Public Properties
			
		/// <summary>
		/// 发货单行
		/// </summary>		
		public Guid Id
		{
			get { return _id; }
			set { _id = value; }
		}
			
		/// <summary>
		/// 发货单

		/// </summary>		
		public Guid SphId
		{
			get { return _sph_id; }
			set { _sph_id = value; }
		}
			
		/// <summary>
		/// 产品
		/// </summary>		
		public Guid ShipmentPmaId
		{
			get { return _shipment_pma_id; }
			set { _shipment_pma_id = value; }
		}
			
		/// <summary>
		/// 数量
		/// </summary>		
		public double ShipmentQty
		{
			get { return _shipmentqty; }
			set { _shipmentqty = value; }
		}
			
		/// <summary>
		/// 
		/// </summary>		
		public double? UnitPrice
		{
			get { return _unitprice; }
			set { _unitprice = value; }
		}
			
		/// <summary>
		/// 
		/// </summary>		
		public int? LineNbr
		{
			get { return _linenbr; }
			set { _linenbr = value; }
		}
			
		
	
		
		#endregion 
		
		
		
		
		
	}
}
