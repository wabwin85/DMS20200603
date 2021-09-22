/*
 * Ibatis.Net for Data Mapper, and Generated by MyGeneration
 * 
 * NameSpace   : DMS.Model 
 * ClassName   : SampleUpn
 * Created Time: 2016/3/8 17:09:23
 *
 ******* Copyright (C) 2009/2010 - GrapeCity **********
 *
******************************************************/

using System;

namespace DMS.Model
{
    /// <summary>
    ///	SampleUpn
    /// </summary>
    [Serializable]
    public class SampleUpn : BaseModel
    {
        #region Private Members 14

        private Guid _sampleupnid;
        private Guid _sampleheadid;
        private string _applyno;
        private string _upnno;
        private string _lot;
        private string _productname;
        private string _productdesc;
        private decimal? _applyquantity;
        private decimal? _confirmquantity;
        private string _lotreuqest;
        private string _productmemo;
        private string _cost;
        private int? _sortno;
        private string _createuser;
        private DateTime? _createdate;
        private string _updateuser; 
        private DateTime? _updatedate;
        #endregion

        #region Default ( Empty ) Class Constuctor
        /// <summary>
        /// default constructor
        /// </summary>
        public SampleUpn()
        {
            _sampleupnid = Guid.Empty;
            _sampleheadid = Guid.Empty;
            _applyno = null;
            _upnno = null;
            _productname = null;
            _productdesc = null;
            _applyquantity = null;
            _confirmquantity = null;
            _lot = null;
            _lotreuqest = null;
            _productmemo = null;
            _sortno = null;
            _cost = null;
            _createuser = null;
            _createdate = null;
            _updateuser = null; 
            _updatedate = null;
        }
        #endregion // End of Default ( Empty ) Class Constuctor

        #region Public Properties

        /// <summary>
        /// 样品UPN ID
        /// </summary>		
        public Guid SampleUpnId
        {
            get { return _sampleupnid; }
            set { _sampleupnid = value; }
        }

        /// <summary>
        /// 样品主ID
        /// </summary>		
        public Guid SampleHeadId
        {
            get { return _sampleheadid; }
            set { _sampleheadid = value; }
        }

        /// <summary>
        /// 申请单编号
        /// </summary>		
        public string ApplyNo
        {
            get { return _applyno; }
            set
            {
                if (value != null && value.Length > 100)
                    throw new ArgumentOutOfRangeException("Invalid value for ApplyNo", value, value.ToString());

                _applyno = value;
            }
        }

        /// <summary>
        /// UPN编号
        /// </summary>		
        public string UpnNo
        {
            get { return _upnno; }
            set
            {
                if (value != null && value.Length > 500)
                    throw new ArgumentOutOfRangeException("Invalid value for UpnNo", value, value.ToString());

                _upnno = value;
            }
        }

        /// <summary>
        /// 产品名称
        /// </summary>		
        public string ProductName
        {
            get { return _productname; }
            set
            {
                if (value != null && value.Length > 500)
                    throw new ArgumentOutOfRangeException("Invalid value for ProductName", value, value.ToString());

                _productname = value;
            }
        }

        /// <summary>
        /// 描述
        /// </summary>		
        public string ProductDesc
        {
            get { return _productdesc; }
            set
            {
                if (value != null && value.Length > 500)
                    throw new ArgumentOutOfRangeException("Invalid value for ProductDesc", value, value.ToString());

                _productdesc = value;
            }
        }

        /// <summary>
        /// 申请数量
        /// </summary>		
        public decimal? ApplyQuantity
        {
            get { return _applyquantity; }
            set
            {
                _applyquantity = value;
            }
        }

        /// <summary>
        /// 确认数量
        /// </summary>		
        public decimal? ConfirmQuantity
        {
            get { return _confirmquantity; }
            set
            {
                _confirmquantity = value;
            }
        }

        /// <summary>
        /// 批号
        /// </summary>		
        public string Lot
        {
            get { return _lot; }
            set
            {
                if (value != null && value.Length > 500)
                    throw new ArgumentOutOfRangeException("Invalid value for Lot", value, value.ToString());

                _lot = value;
            }
        }

        /// <summary>
        /// 批次要求
        /// </summary>		
        public string LotReuqest
        {
            get { return _lotreuqest; }
            set
            {
                if (value != null && value.Length > 500)
                    throw new ArgumentOutOfRangeException("Invalid value for LotReuqest", value, value.ToString());

                _lotreuqest = value;
            }
        }

        /// <summary>
        /// 备注
        /// </summary>		
        public string ProductMemo
        {
            get { return _productmemo; }
            set
            {
                if (value != null && value.Length > 500)
                    throw new ArgumentOutOfRangeException("Invalid value for ProductMemo", value, value.ToString());

                _productmemo = value;
            }
        }

        /// <summary>
        /// 排序序号
        /// </summary>		
        public int? SortNo
        {
            get { return _sortno; }
            set { _sortno = value; }
        }

        /// <summary>
        /// Cost
        /// </summary>		
        public string Cost
        {
            get { return _cost; }
            set
            {
                if (value != null && value.Length > 500)
                    throw new ArgumentOutOfRangeException("Invalid value for Cost", value, value.ToString());

                _cost = value;
            }
        }

        /// <summary>
        /// 更新人
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
        /// 更新时间
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
                if (value != null && value.Length > 20)
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
