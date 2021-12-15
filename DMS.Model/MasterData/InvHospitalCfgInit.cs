using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Model
{
    public class InvHospitalCfgInit: BaseModel
    {
        #region Private Members

        private Guid _id; 
        private string _dmsHosptialName;
        private string _invHosptialName;
        private string _hoscode;
        private string _sfeHoscode;
        private string _province;
        private string _city;
        private string _district;
        private Guid? _importUser;
        private bool _isError;
        private DateTime? _importDate;
        private string _errorMsg;

        #endregion

        public InvHospitalCfgInit()
        {
            _id = new Guid(); 
            _dmsHosptialName = null;
            _invHosptialName = null;
            _hoscode = null;
            _sfeHoscode = null;
            _city = null;
            _importUser = null;
            _province = null;
            _district = null;
            _isError = false;
            _importDate = null;
            _errorMsg = null;
        }

        #region Public Member
        public Guid Id
        {
            get { return _id; }
            set { _id = value; }
        } 

        public string DMSHospitalName
        {
            get
            {
                return _dmsHosptialName;
            }
            set
            {
                _dmsHosptialName = value;
            }
        }

        public string InvHospitalName
        {
            get
            {
                return _invHosptialName;
            }
            set
            {
                _invHosptialName = value;
            }
        }

        public string Hos_Code
        {
            get
            {
                return _hoscode;
            }
            set
            {
                _hoscode = value;
            }
        }

        public string Hos_SFECode
        {
            get
            {
                return _sfeHoscode;
            }
            set
            {
                _sfeHoscode = value;
            }
        }

        public string Province
        {
            get
            {
                return _province;
            }
            set
            {
                _province = value;
            }
        }

        public string City
        {
            get
            {
                return _city;
            }
            set
            {
                _city = value;
            }
        }

        public string District
        {
            get
            {
                return _district;
            }
            set
            {
                _district = value;
            }
        }

        public bool IsError
        {
            get
            {
                return _isError;
            }
            set
            {
                _isError = value;
            }
        }

        public Guid? ImportUser
        {
            get
            {
                return _importUser;
            }
            set
            {
                _importUser = value; 
            }
        }

        public string ErrorMsg
        {
            get
            {
                return _errorMsg;
            }
            set
            {
                _errorMsg = value;
            }
        }

        public DateTime? ImportDate
        {
            get
            {
                return _importDate;
            }
            set
            {
                _importDate = value;
            }
        }


        #endregion
    }
}
