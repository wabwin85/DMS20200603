using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Model
{
    [Serializable]
    public class InvHospitalCfg:BaseModel
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
        private string _modifier;
        private DateTime? _created;
        private DateTime? _updated;

        #endregion

        public InvHospitalCfg()
        {
            _id = new Guid(); 
            _dmsHosptialName = null;
            _invHosptialName = null;
            _hoscode = null;
            _sfeHoscode = null;
            _city = null;
            _province = null;
            _district = null;
            _modifier = null;
            _created = null;
            _updated = null;
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

        public string Modifier
        {
            get
            {
                return _modifier;
            }
            set
            {
                _modifier = value;
            }
        }

        public DateTime? Created
        {
            get
            {
                return _created;
            }
            set
            {
                _created = value;
            }
        }

        public DateTime? Updated
        {
            get
            {
                return _updated;
            }
            set
            {
                _updated = value;
            }
        }

        #endregion
    }
}
