using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Model
{
    [Serializable]
	public class ProGiftDetail : BaseModel
    {
        #region Private Members 7
        private string _bu;
        private string _accountmonth;
        private string _policyno;
        private string _sapcode;
        private string _dealername;
        private string _hospitalid;
        private string _hospitalname;
        private string _oranum;
        private string _adjustnum;
        private string _pointtype;
        private string _ratio;
        private string _pointvaliddate;
        #endregion


        #region Default ( Empty ) Class Constuctor
		/// <summary>
		/// default constructor
		/// </summary>
        public ProGiftDetail()
		{
			_bu = null;
            _accountmonth = null;
            _policyno = null;
            _sapcode = null;
            _dealername = null;
            _hospitalid = null;
            _hospitalname = null;
            _oranum = null;
            _adjustnum = null;
            _pointtype = null;
            _ratio = null;
            _pointvaliddate = null;
		}
		#endregion // End of Default ( Empty ) Class Constuctor

        #region Public Properties
        /// <summary>
        /// 
        /// </summary>		
        public string Bu
        {
            get { return _bu; }
            set
            {
                if (value != null && value.Length > 20)
                    throw new ArgumentOutOfRangeException("Invalid value for Bu", value, value.ToString());

                _bu = value;
            }
        }

        /// <summary>
        /// 
        /// </summary>		
        public string AccountMonth
        {
            get { return _accountmonth; }
            set
            {
                if (value != null && value.Length > 20)
                    throw new ArgumentOutOfRangeException("Invalid value for AccountMonth", value, value.ToString());

                _accountmonth = value;
            }
        }

        /// <summary>
        /// 
        /// </summary>		
        public string PolicyNo
        {
            get { return _policyno; }
            set
            {
                if (value != null && value.Length > 50)
                    throw new ArgumentOutOfRangeException("Invalid value for PolicyNo", value, value.ToString());

                _policyno = value;
            }
        }


        /// <summary>
        /// 
        /// </summary>		
        public string SAPCode
        {
            get { return _sapcode; }
            set
            {
                if (value != null && value.Length > 200)
                    throw new ArgumentOutOfRangeException("Invalid value for SAPCode", value, value.ToString());

                _sapcode = value;
            }
        }

        /// <summary>
        /// 
        /// </summary>		
        public string DealerName
        {
            get { return _dealername; }
            set
            {
                if (value != null && value.Length > 200)
                    throw new ArgumentOutOfRangeException("Invalid value for DealerName", value, value.ToString());

                _dealername = value;
            }
        }

        /// <summary>
        /// 
        /// </summary>		
        public string HospitalId
        {
            get { return _hospitalid; }
            set
            {
                if (value != null && value.Length > 200)
                    throw new ArgumentOutOfRangeException("Invalid value for DealerId", value, value.ToString());

                _hospitalid = value;
            }
        }

        /// <summary>
        /// 
        /// </summary>		
        public string HospitalName
        {
            get { return _hospitalname; }
            set
            {
                if (value != null && value.Length > 200)
                    throw new ArgumentOutOfRangeException("Invalid value for HospitalName", value, value.ToString());

                _hospitalname = value;
            }
        }

        /// <summary>
        /// 
        /// </summary>		
        public string OraNum
        {
            get { return _oranum; }
            set
            {
                if (value != null && value.Length > 50)
                    throw new ArgumentOutOfRangeException("Invalid value for OraNum", value, value.ToString());

                _oranum = value;
            }
        }

        /// <summary>
        /// 
        /// </summary>		
        public string AdjustNum
        {
            get { return _adjustnum; }
            set
            {
                if (value != null && value.Length > 50)
                    throw new ArgumentOutOfRangeException("Invalid value for AdjustNum", value, value.ToString());

                _adjustnum = value;
            }
        }


        public string PointType
        {
            get { return _pointtype; }
            set
            {
                if (value != null && value.Length > 50)
                    throw new ArgumentOutOfRangeException("Invalid value for PointType", value, value.ToString());

                _pointtype = value;
            }
        }

        public string Ratio
        {
            get { return _ratio; }
            set
            {
                if (value != null && value.Length > 50)
                    throw new ArgumentOutOfRangeException("Invalid value for Ratio", value, value.ToString());

                _ratio = value;
            }
        }

        public string PointValidDate
        {
            get { return _pointvaliddate; }
            set
            {
                if (value != null && value.Length > 50)
                    throw new ArgumentOutOfRangeException("Invalid value for PointValidDate", value, value.ToString());

                _pointvaliddate = value;
            }
        }
        #endregion 

    }
}
