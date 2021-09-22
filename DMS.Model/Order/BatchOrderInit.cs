using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Model
{
    /// <summary>
    ///	BatchOrderInit
    /// </summary>
    [Serializable]
    public class BatchOrderInit : BaseModel
    {
        #region Private Members 30

        private string _id;
        private string _user;
        private DateTime _uploaddate;
        private int _linenbr;
        private string _filename;
        private bool _errorflag;
        private string _errordescription;
        private string _poh_id;
        private string _pod_id;
        private string _ordertype;
        private string _articlenumber;
        private string _requiredqty;
        private string _lotnumber;
        private string _sap_code;
        private string _dma_id;
        private string _cfn_id;
        private string _bum_id;
        private string _territorycode;
        private string _warehouse;
        private string _whm_id;
        private string _ordertypename;
        private string _sap_code_errmsg;
        private string _ordertype_errmsg;
        private string _articlenumber_errmsg;
        private string _requiredqty_errmsg;
        private string _lotnumber_errmsg;
        private string _amount;
        private string _amount_errmsg;
        private string _productline;
        private string _productline_errmsg;
        #endregion

        #region Default ( Empty ) Class Constuctor
        /// <summary>
        /// default constructor
        /// </summary>
        public BatchOrderInit()
        {
            _id = null;
            _user = null;
            _uploaddate = new DateTime();
            _linenbr = 0;
            _filename = null;
            _errorflag = false;
            _errordescription = null;
            _poh_id = null;
            _pod_id = null;
            _ordertype = null;
            _articlenumber = null;
            _requiredqty = null;
            _lotnumber = null;
            _sap_code = null;
            _dma_id = null;
            _cfn_id = null;
            _bum_id = null;
            _territorycode = null;
            _warehouse = null;
            _whm_id = null;
            _ordertypename = null;
            _sap_code_errmsg = null;
            _ordertype_errmsg = null;
            _articlenumber_errmsg = null;
            _requiredqty_errmsg = null;
            _lotnumber_errmsg = null;
            _amount = null;
            _amount_errmsg = null;
            _productline = null;
            _productline_errmsg = null;
        }
        #endregion // End of Default ( Empty ) Class Constuctor

        #region Public Properties

        /// <summary>
        /// 
        /// </summary>		
        public string Id
        {
            get { return   _id; }
            set
            {
                if (value != null && value.Length > 50)
                    throw new ArgumentOutOfRangeException("Invalid value for Id", value, value.ToString());

                _id = value;
            }
        }

        /// <summary>
        /// 
        /// </summary>		
        public string User
        {
            get { return _user; }
            set
            {
                if (value != null && value.Length > 50)
                    throw new ArgumentOutOfRangeException("Invalid value for User", value, value.ToString());

                _user = value;
            }
        }

        /// <summary>
        /// 
        /// </summary>		
        public DateTime UploadDate
        {
            get { return _uploaddate; }
            set { _uploaddate = value; }
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
                if (value != null && value.Length > 200)
                    throw new ArgumentOutOfRangeException("Invalid value for FileName", value, value.ToString());

                _filename = value;
            }
        }

        /// <summary>
        /// 
        /// </summary>		
        public bool ErrorFlag
        {
            get { return _errorflag; }
            set { _errorflag = value; }
        }

        /// <summary>
        /// 
        /// </summary>		
        public string ErrorDescription
        {
            get { return _errordescription; }
            set
            {
                if (value != null && value.Length > 100)
                    throw new ArgumentOutOfRangeException("Invalid value for ErrorDescription", value, value.ToString());

                _errordescription = value;
            }
        }

        /// <summary>
        /// 
        /// </summary>		
        public string PohId
        {
            get { return _poh_id; }
            set
            {
                if (value != null && value.Length > 50)
                    throw new ArgumentOutOfRangeException("Invalid value for PohId", value, value.ToString());

                _poh_id = value;
            }
        }

        /// <summary>
        /// 
        /// </summary>		
        public string PodId
        {
            get { return _pod_id; }
            set
            {
                if (value != null && value.Length > 50)
                    throw new ArgumentOutOfRangeException("Invalid value for PohId", value, value.ToString());

                _pod_id = value;
            }
        }

        /// <summary>
        /// 
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
        /// 
        /// </summary>		
        public string ArticleNumber
        {
            get { return _articlenumber; }
            set
            {
                if (value != null && value.Length > 30)
                    throw new ArgumentOutOfRangeException("Invalid value for ArticleNumber", value, value.ToString());

                _articlenumber = value;
            }
        }

        /// <summary>
        /// 
        /// </summary>		
        public string RequiredQty
        {
            get { return _requiredqty; }
            set
            {
                if (value != null && value.Length > 20)
                    throw new ArgumentOutOfRangeException("Invalid value for RequiredQty", value, value.ToString());

                _requiredqty = value;
            }
        }

        /// <summary>
        /// 
        /// </summary>		
        public string LotNumber
        {
            get { return _lotnumber; }
            set
            {
                if (value != null && value.Length > 20)
                    throw new ArgumentOutOfRangeException("Invalid value for LotNumber", value, value.ToString());

                _lotnumber = value;
            }
        }

        /// <summary>
        /// 
        /// </summary>		
        public string SapCode
        {
            get { return _sap_code; }
            set
            {
                if (value != null && value.Length > 50)
                    throw new ArgumentOutOfRangeException("Invalid value for SapCode", value, value.ToString());

                _sap_code = value;
            }
        }

        /// <summary>
        /// 
        /// </summary>		
        public string DmaId
        {
            get { return _dma_id; }
            set
            {
                if (value != null && value.Length > 50)
                    throw new ArgumentOutOfRangeException("Invalid value for DmaId", value, value.ToString());
                 _dma_id = value;
            }
        }

        /// <summary>
        /// 
        /// </summary>		
        public string CfnId
        {
            get { return _cfn_id; }
            set
            {
                if (value != null && value.Length > 50)
                    throw new ArgumentOutOfRangeException("Invalid value for CfnId", value, value.ToString());
                _cfn_id = value;
            }
        }

        /// <summary>
        /// 
        /// </summary>		
        public string BumId
        {
            get { return _bum_id; }
            set
            {
                if (value != null && value.Length > 50)
                    throw new ArgumentOutOfRangeException("Invalid value for BumId", value, value.ToString());
                _bum_id = value;
            }
        }

        /// <summary>
        /// 
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
        /// 
        /// </summary>		
        public string Warehouse
        {
            get { return _warehouse; }
            set
            {
                if (value != null && value.Length > 50)
                    throw new ArgumentOutOfRangeException("Invalid value for Warehouse", value, value.ToString());

                _warehouse = value;
            }
        }

        /// <summary>
        /// 
        /// </summary>		
        public string WhmId
        {
            get { return _whm_id; }
            set
            {
                if (value != null && value.Length > 50)
                    throw new ArgumentOutOfRangeException("Invalid value for WhmId", value, value.ToString());

                _whm_id = value;
            }
        }

        /// <summary>
        /// 
        /// </summary>		
        public string OrderTypeName
        {
            get { return _ordertypename; }
            set
            {
                if (value != null && value.Length > 50)
                    throw new ArgumentOutOfRangeException("Invalid value for OrderTypeName", value, value.ToString());

                _ordertypename = value;
            }
        }

        /// <summary>
        /// 
        /// </summary>		
        public string SapCodeErrMsg
        {
            get { return _sap_code_errmsg; }
            set
            {
                if (value != null && value.Length > 50)
                    throw new ArgumentOutOfRangeException("Invalid value for SapCodeErrMsg", value, value.ToString());

                _sap_code_errmsg = value;
            }
        }

        /// <summary>
        /// 
        /// </summary>		
        public string OrderTypeErrMsg
        {
            get { return _ordertype_errmsg; }
            set
            {
                if (value != null && value.Length > 100)
                    throw new ArgumentOutOfRangeException("Invalid value for OrderTypeErrMsg", value, value.ToString());

                _ordertype_errmsg = value;
            }
        }

        /// <summary>
        /// 
        /// </summary>		
        public string ArticleNumberErrMsg
        {
            get { return _articlenumber_errmsg; }
            set
            {
                if (value != null && value.Length > 100)
                    throw new ArgumentOutOfRangeException("Invalid value for ArticleNumberErrMsg", value, value.ToString());

                _articlenumber_errmsg = value;
            }
        }

        /// <summary>
        /// 
        /// </summary>		
        public string RequiredQtyErrMsg
        {
            get { return _requiredqty_errmsg; }
            set
            {
                if (value != null && value.Length > 100)
                    throw new ArgumentOutOfRangeException("Invalid value for RequiredQtyErrMsg", value, value.ToString());

                _requiredqty_errmsg = value;
            }
        }

        /// <summary>
        /// 
        /// </summary>		
        public string LotNumberErrMsg
        {
            get { return _lotnumber_errmsg; }
            set
            {
                if (value != null && value.Length > 100)
                    throw new ArgumentOutOfRangeException("Invalid value for LotNumberErrMsg", value, value.ToString());

                _lotnumber_errmsg = value;
            }
        }

        /// <summary>
        /// 
        /// </summary>		
        public string Amount
        {
            get { return _amount; }
            set
            {
                if (value != null && value.Length > 20)
                    throw new ArgumentOutOfRangeException("Invalid value for Amount", value, value.ToString());

                _amount = value;
            }
        }

        /// <summary>
        /// 
        /// </summary>		
        public string AmountErrMsg
        {
            get { return _amount_errmsg; }
            set
            {
                if (value != null && value.Length > 100)
                    throw new ArgumentOutOfRangeException("Invalid value for AmountErrMsg", value, value.ToString());

                _amount_errmsg = value;
            }
        }

        /// <summary>
        /// 
        /// </summary>		
        public string ProductLine
        {
            get { return _productline; }
            set
            {
                if (value != null && value.Length > 50)
                    throw new ArgumentOutOfRangeException("Invalid value for ProductLine", value, value.ToString());

                _productline = value;
            }
        }

        /// <summary>
        /// 
        /// </summary>		
        public string ProductLineErrMsg
        {
            get { return _productline_errmsg; }
            set
            {
                if (value != null && value.Length > 100)
                    throw new ArgumentOutOfRangeException("Invalid value for ProductLineErrMsg", value, value.ToString());

                _productline_errmsg = value;
            }
        }
        #endregion

    }
}
