/*
 * Ibatis.Net for Data Mapper, and Generated by MyGeneration
 * 
 * NameSpace   : DMS.Model 
 * ClassName   : PurchaseOrderHeader
 * Created Time: 2011-2-11 17:06:58
 *
 ******* Copyright (C) 2009/2010 - GrapeCity **********
 *
******************************************************/

using System;

namespace DMS.Model
{
    /// <summary>
    ///	PurchaseOrderHeader
    /// </summary>
    [Serializable]
    public class PurchaseOrderHeader : BaseModel
    {
        #region Private Members 35

        private Guid _id;
        private string _orderno;
        private Guid? _productline_bum_id;
        private Guid? _dma_id;
        private string _vendorid;
        private string _territorycode;
        private DateTime? _rdd;
        private string _contactperson;
        private string _contact;
        private string _contactmobile;
        private string _consignee;
        private string _shiptoaddress;
        private string _consigneephone;
        private string _remark;
        private string _invoicecomment;
        private string _createtype;
        private Guid? _updateuser;
        private DateTime? _updatedate;
        private Guid? _submituser;
        private DateTime? _submitdate;
        private Guid? _lastbrowseuser;
        private DateTime? _lastbrowsedate;
        private string _orderstatus;
        private DateTime? _latestauditdate;
        private bool _islocked;
        private string _sap_orderno;
        private DateTime? _sap_confirmdate;
        private int _lastversion;
        private string _ordertype;
        private string _virtualdc;
        private Guid? _specialpriceid;
        private Guid? _whm_id;
        private Guid? _poh_id;
        private string _salesaccount;
        private string _pointtype;
        private string _isusepro;
        private string __dctype;
        private string _sendhospital;
        private string _sendaddress;
        private int? _sendwmsflg;
        #endregion

        #region Default ( Empty ) Class Constuctor
        /// <summary>
        /// default constructor
        /// </summary>
        public PurchaseOrderHeader()
        {
            _id = Guid.Empty;
            _orderno = null;
            _productline_bum_id = null;
            _dma_id = null;
            _vendorid = null;
            _territorycode = null;
            _rdd = null;
            _contactperson = null;
            _contact = null;
            _contactmobile = null;
            _consignee = null;
            _shiptoaddress = null;
            _consigneephone = null;
            _remark = null;
            _invoicecomment = null;
            _createtype = null;
            _updateuser = null;
            _updatedate = null;
            _submituser = null;
            _submitdate = null;
            _lastbrowseuser = null;
            _lastbrowsedate = null;
            _orderstatus = null;
            _latestauditdate = null;
            _islocked = false;
            _sap_orderno = null;
            _sap_confirmdate = null;
            _lastversion = 0;
            _ordertype = null;
            _virtualdc = null;
            _specialpriceid = null;
            _whm_id = null;
            _poh_id = null;
            _salesaccount = null;
            _pointtype = null;
            _isusepro = null;
            __dctype = null;
            _sendhospital = null;
            _sendaddress = null;
            _sendwmsflg = null;
        }
        #endregion // End of Default ( Empty ) Class Constuctor

        #region Public Properties

        /// <summary>
        /// 表头主键
        /// </summary>		
        public Guid Id
        {
            get { return _id; }
            set { _id = value; }
        }

        /// <summary>
        /// 订单号
        /// </summary>		
        public string OrderNo
        {
            get { return _orderno; }
            set
            {
                if (value != null && value.Length > 30)
                    throw new ArgumentOutOfRangeException("Invalid value for OrderNo", value, value.ToString());

                _orderno = value;
            }
        }

        /// <summary>
        /// 产品线
        /// </summary>		
        public Guid? ProductLineBumId
        {
            get { return _productline_bum_id; }
            set { _productline_bum_id = value; }
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
        /// 供应商 BSC公司
        /// </summary>		
        public string Vendorid
        {
            get { return _vendorid; }
            set
            {
                if (value != null && value.Length > 100)
                    throw new ArgumentOutOfRangeException("Invalid value for Vendorid", value, value.ToString());

                _vendorid = value;
            }
        }

        /// <summary>
        /// 区域代码
        /// </summary>		
        public string TerritoryCode
        {
            get { return _territorycode; }
            set
            {
                if (value != null && value.Length > 200)
                    throw new ArgumentOutOfRangeException("Invalid value for TerritoryCode", value, value.ToString());

                _territorycode = value;
            }
        }

        /// <summary>
        /// 期望到货日期
        /// </summary>		
        public DateTime? Rdd
        {
            get { return _rdd; }
            set { _rdd = value; }
        }

        /// <summary>
        /// 订单联系人
        /// </summary>		
        public string ContactPerson
        {
            get { return _contactperson; }
            set
            {
                if (value != null && value.Length > 100)
                    throw new ArgumentOutOfRangeException("Invalid value for ContactPerson", value, value.ToString());

                _contactperson = value;
            }
        }

        /// <summary>
        /// 联系方式
        /// </summary>		
        public string Contact
        {
            get { return _contact; }
            set
            {
                if (value != null && value.Length > 100)
                    throw new ArgumentOutOfRangeException("Invalid value for Contact", value, value.ToString());

                _contact = value;
            }
        }

        /// <summary>
        /// 手机号码
        /// </summary>		
        public string ContactMobile
        {
            get { return _contactmobile; }
            set
            {
                if (value != null && value.Length > 100)
                    throw new ArgumentOutOfRangeException("Invalid value for ContactMobile", value, value.ToString());

                _contactmobile = value;
            }
        }

        /// <summary>
        /// 收货人
        /// </summary>		
        public string Consignee
        {
            get { return _consignee; }
            set
            {
                if (value != null && value.Length > 100)
                    throw new ArgumentOutOfRangeException("Invalid value for Consignee", value, value.ToString());

                _consignee = value;
            }
        }

        /// <summary>
        /// 收货地址
        /// </summary>		
        public string ShipToAddress
        {
            get { return _shiptoaddress; }
            set
            {
                if (value != null && value.Length > 200)
                    throw new ArgumentOutOfRangeException("Invalid value for ShipToAddress", value, value.ToString());

                _shiptoaddress = value;
            }
        }

        /// <summary>
        /// 收货人电话
        /// </summary>		
        public string ConsigneePhone
        {
            get { return _consigneephone; }
            set
            {
                if (value != null && value.Length > 200)
                    throw new ArgumentOutOfRangeException("Invalid value for ConsigneePhone", value, value.ToString());

                _consigneephone = value;
            }
        }

        /// <summary>
        /// 订单备注
        /// </summary>		
        public string Remark
        {
            get { return _remark; }
            set
            {
                if (value != null && value.Length > 4000)
                    throw new ArgumentOutOfRangeException("Invalid value for Remark", value, value.ToString());

                _remark = value;
            }
        }

        /// <summary>
        /// 发票备注
        /// </summary>		
        public string InvoiceComment
        {
            get { return _invoicecomment; }
            set
            {
                if (value != null && value.Length > 200)
                    throw new ArgumentOutOfRangeException("Invalid value for InvoiceComment", value, value.ToString());

                _invoicecomment = value;
            }
        }

        /// <summary>
        /// 订单创建类型<br/>   Dealer 经销商人工下的订单<br/>   System 系统帮助经销商自动生成的订单
        /// </summary>		
        public string CreateType
        {
            get { return _createtype; }
            set
            {
                if (value != null && value.Length > 20)
                    throw new ArgumentOutOfRangeException("Invalid value for CreateType", value, value.ToString());

                _createtype = value;
            }
        }

        /// <summary>
        /// 订单更新人
        /// </summary>		
        public Guid? UpdateUser
        {
            get { return _updateuser; }
            set { _updateuser = value; }
        }

        /// <summary>
        /// 订单更新时间
        /// </summary>		
        public DateTime? UpdateDate
        {
            get { return _updatedate; }
            set { _updatedate = value; }
        }

        /// <summary>
        /// 订单提交人
        /// </summary>		
        public Guid? SubmitUser
        {
            get { return _submituser; }
            set { _submituser = value; }
        }

        /// <summary>
        /// 订单提交时间
        /// </summary>		
        public DateTime? SubmitDate
        {
            get { return _submitdate; }
            set { _submitdate = value; }
        }

        /// <summary>
        /// 最近一次浏览人
        /// </summary>		
        public Guid? LastBrowseUser
        {
            get { return _lastbrowseuser; }
            set { _lastbrowseuser = value; }
        }

        /// <summary>
        /// 最近一次浏览时间
        /// </summary>		
        public DateTime? LastBrowseDate
        {
            get { return _lastbrowsedate; }
            set { _lastbrowsedate = value; }
        }

        /// <summary>
        /// 订单状态<br/>   草稿<br/>   已提交<br/>   已同意<br/>   已拒绝<br/>   已生成接口<br/>   已进入SAP<br/>   部分发货<br/>   已完成
        /// </summary>		
        public string OrderStatus
        {
            get { return _orderstatus; }
            set
            {
                if (value != null && value.Length > 20)
                    throw new ArgumentOutOfRangeException("Invalid value for OrderStatus", value, value.ToString());

                _orderstatus = value;
            }
        }

        /// <summary>
        /// 最晚审核日期
        /// </summary>		
        public DateTime? LatestAuditDate
        {
            get { return _latestauditdate; }
            set { _latestauditdate = value; }
        }

        /// <summary>
        /// 是否锁定
        /// </summary>		
        public bool IsLocked
        {
            get { return _islocked; }
            set { _islocked = value; }
        }

        /// <summary>
        /// SAP订单编号
        /// </summary>		
        public string SapOrderNo
        {
            get { return _sap_orderno; }
            set
            {
                if (value != null && value.Length > 50)
                    throw new ArgumentOutOfRangeException("Invalid value for SapOrderNo", value, value.ToString());

                _sap_orderno = value;
            }
        }

        /// <summary>
        /// SAP处理时间
        /// </summary>		
        public DateTime? SapConfirmDate
        {
            get { return _sap_confirmdate; }
            set { _sap_confirmdate = value; }
        }

        /// <summary>
        /// 上一版本号
        /// </summary>		
        public int LastVersion
        {
            get { return _lastversion; }
            set { _lastversion = value; }
        }

        /// <summary>
        /// 订单类型
        /// </summary>		
        public string OrderType
        {
            get { return _ordertype; }
            set
            {
                if (value != null && value.Length > 20)
                    throw new ArgumentOutOfRangeException("Invalid value for OrderType", value, value.ToString());

                _ordertype = value;
            }
        }

        /// <summary>
        /// 虚拟库位
        /// </summary>		
        public string Virtualdc
        {
            get { return _virtualdc; }
            set
            {
                if (value != null && value.Length > 50)
                    throw new ArgumentOutOfRangeException("Invalid value for Virtualdc", value, value.ToString());

                _virtualdc = value;
            }
        }

        /// <summary>
        /// 特殊价格
        /// </summary>		
        public Guid? SpecialPriceid
        {
            get { return _specialpriceid; }
            set { _specialpriceid = value; }
        }

        /// <summary>
        /// 仓库ID
        /// </summary>		
        public Guid? WhmId
        {
            get { return _whm_id; }
            set { _whm_id = value; }
        }

        /// <summary>
        /// 关联表头主键
        /// </summary>		
        public Guid? PohId
        {
            get { return _poh_id; }
            set { _poh_id = value; }
        }


        /// <summary>
        /// RSM
        /// </summary>		
        public string SalesAccount
        {
            get { return _salesaccount; }
            set
            {
                if (value != null && value.Length > 50)
                    throw new ArgumentOutOfRangeException("Invalid value for SalesAccount", value, value.ToString());

                _salesaccount = value;
            }
        }

        /// <summary>
        /// 积分类型
        /// </summary>
        public string PointType
        {
            get { return _pointtype; }
            set
            {
                if (value != null && value.Length > 100)
                    throw new ArgumentOutOfRangeException("Invalid value for PointType", value, value.ToString());

                _pointtype = value;
            }
        }

        public string IsUsePro
        {
            get { return _isusepro; }
            set
            {
                if (value != null && value.Length > 5)
                    throw new ArgumentOutOfRangeException("Invalid value for IsUsePro", value, value.ToString());

                _isusepro = value;
            }
        }
        public string DcType
        {
            get { return __dctype; }
            set
            {
                if (value != null && value.Length > 20)
                    throw new ArgumentOutOfRangeException("Invalid value for DcType", value, value.ToString());

                __dctype = value;
            }
        }
        public string SendHospital
        {
            get { return _sendhospital; }
            set
            {
                if (value != null && value.Length > 200)
                    throw new ArgumentOutOfRangeException("Invalid value for SendHospital", value, value.ToString());

                _sendhospital = value;
            }
        }
        public string SendAddress
        {
            get { return _sendaddress; }
            set
            {
                if (value != null && value.Length > 500)
                    throw new ArgumentOutOfRangeException("Invalid value for SendAddress", value, value.ToString());

                _sendaddress = value;
            }
        }
        /// <summary>
		/// 
		/// </summary>		
		public int? SendwmsFlg
        {
            get { return _sendwmsflg; }
            set { _sendwmsflg = value; }
        }
        #endregion





    }
}
