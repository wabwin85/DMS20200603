using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Model
{
    public class DealerMasterDD
    {
        #region Private Members 13

        private Guid _dmdd_id;
        private Guid? _dmdd_contractid;
        private string _dmdd_reportname;
        private DateTime? _dmdd_startdate;
        private DateTime? _dmdd_enddate;
        private Guid? _dmdd_dealerid;
        private string _dmdd_createuser;
        private DateTime? _dmdd_createdate;
        private string _dmdd_updateuser;
        private DateTime? _dmdd_updatedate;
        private string _dmdd_dd;
        private bool? _dmdd_ishaveredflag;
        #endregion

        #region Default ( Empty ) Class Constuctor
        /// <summary>
        /// default constructor
        /// </summary>
        public DealerMasterDD()
        {
            _dmdd_id = Guid.Empty;
            _dmdd_contractid = null;
            _dmdd_reportname = null;
            _dmdd_startdate = null;
            _dmdd_enddate = null;
            _dmdd_dealerid = null;
            _dmdd_createuser = null;
            _dmdd_createdate = null;
            _dmdd_updateuser = null;
            _dmdd_updatedate = null;
            _dmdd_dd = null;
            _dmdd_ishaveredflag = null;
        }
        #endregion // End of Default ( Empty ) Class Constuctor

        #region Public Properties

        /// <summary>
        /// 
        /// </summary>		
        public Guid DMDD_ID
        {
            get { return _dmdd_id; }
            set { _dmdd_id = value; }
        }

        /// <summary>
        /// 
        /// </summary>		
        public Guid? DMDD_ContractID
        {
            get { return _dmdd_contractid; }
            set { _dmdd_contractid = value; }
        }

        /// <summary>
        /// 
        /// </summary>		
        public string DMDD_ReportName
        {
            get { return _dmdd_reportname; }
            set
            {
                if (value != null && value.Length > 200)
                    throw new ArgumentOutOfRangeException("Invalid value for DMDD_ReportName", value, value.ToString());

                _dmdd_reportname = value;
            }
        }

        /// <summary>
        /// 
        /// </summary>		
        public DateTime? DMDD_StartDate
        {
            get { return _dmdd_startdate; }
            set
            {
                _dmdd_startdate = value;
            }
        }

        /// <summary>
        /// 
        /// </summary>		
        public DateTime? DMDD_EndDate
        {
            get { return _dmdd_enddate; }
            set
            {
                _dmdd_enddate = value;
            }
        }

        /// <summary>
        /// 
        /// </summary>		
        public Guid? DMDD_DealerID
        {
            get { return _dmdd_dealerid; }
            set
            {
                _dmdd_dealerid = value;
            }
        }

        /// <summary>
        /// 
        /// </summary>		
        public string DMDD_CreateUser
        {
            get { return _dmdd_createuser; }
            set
            {
                if (value != null && value.Length > 50)
                    throw new ArgumentOutOfRangeException("Invalid value for DMDD_CreateUser", value, value.ToString());

                _dmdd_createuser = value;
            }
        }
        public DateTime? DMDD_CreateDate
        {
            get { return _dmdd_createdate; }
            set
            {
                _dmdd_createdate = value;
            }
        }
        /// <summary>
        /// 
        /// </summary>		
        public string DMDD_UpdateUser
        {
            get { return _dmdd_updateuser; }
            set
            {
                if (value != null && value.Length > 50)
                    throw new ArgumentOutOfRangeException("Invalid value for DMDD_CreateUser", value, value.ToString());

                _dmdd_updateuser = value;
            }
        }
        public DateTime? DMDD_UpdateDate
        {
            get { return _dmdd_updatedate; }
            set
            {
                _dmdd_updatedate = value;
            }
        }
        public string DMDD_DD
        {
            get { return _dmdd_dd; }
            set
            {
                _dmdd_dd = value;
            }
        }


        public bool? DMDD_IsHaveRedFlag
        {
            get { return _dmdd_ishaveredflag; }
            set
            {
                _dmdd_ishaveredflag = value;
            }
        }
        #endregion
    }
}
