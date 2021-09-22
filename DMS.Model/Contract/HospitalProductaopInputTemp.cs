/*
 * Ibatis.Net for Data Mapper, and Generated by MyGeneration
 * 
 * NameSpace   : DMS.Model 
 * ClassName   : HospitalProductaopInputTemp
 * Created Time: 2016/7/15 14:48:54
 *
 ******* Copyright (C) 2009/2010 - GrapeCity **********
 *
******************************************************/

using System;

namespace DMS.Model
{
    /// <summary>
    ///	HospitalProductaopInputTemp
    /// </summary>
    [Serializable]
    public class HospitalProductaopInputTemp : BaseModel
    {
        #region Private Members 20

        private string _contractid;
        private string _year;
        private string _hospitalcode;
        private string _hospitalname;
        private string _productcode;
        private string _productname;
        private double _m1;
        private double _m2;
        private double _m3;
        private double _m4;
        private double _m5;
        private double _m6;
        private double _m7;
        private double _m8;
        private double _m9;
        private double _m10;
        private double _m11;
        private double _m12;
        private string _errmassage;
        #endregion

        #region Default ( Empty ) Class Constuctor
        /// <summary>
        /// default constructor
        /// </summary>
        public HospitalProductaopInputTemp()
        {
            _contractid = null;
            _year = null;
            _hospitalcode = null;
            _hospitalname = null;
            _productcode = null;
            _productname = null;
            _m1 = 0;
            _m2 = 0;
            _m3 = 0;
            _m4 = 0;
            _m5 = 0;
            _m6 = 0;
            _m7 = 0;
            _m8 = 0;
            _m9 = 0;
            _m10 = 0;
            _m11 = 0;
            _m12 = 0;
            _errmassage = null;
        }
        #endregion // End of Default ( Empty ) Class Constuctor

        #region Public Properties

        /// <summary>
        /// 
        /// </summary>		
        public string Contractid
        {
            get { return _contractid; }
            set
            {
                if (value != null && value.Length > 36)
                    throw new ArgumentOutOfRangeException("Invalid value for Contractid", value, value.ToString());

                _contractid = value;
            }
        }

        /// <summary>
        /// 
        /// </summary>		
        public string Year
        {
            get { return _year; }
            set
            {
                if (value != null && value.Length > 30)
                    throw new ArgumentOutOfRangeException("Invalid value for Year", value, value.ToString());

                _year = value;
            }
        }

        /// <summary>
        /// 
        /// </summary>		
        public string HospitalCode
        {
            get { return _hospitalcode; }
            set
            {
                if (value != null && value.Length > 50)
                    throw new ArgumentOutOfRangeException("Invalid value for HospitalCode", value, value.ToString());

                _hospitalcode = value;
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
                if (value != null && value.Length > 100)
                    throw new ArgumentOutOfRangeException("Invalid value for HospitalName", value, value.ToString());

                _hospitalname = value;
            }
        }

        /// <summary>
        /// 
        /// </summary>		
        public string ProductCode
        {
            get { return _productcode; }
            set
            {
                if (value != null && value.Length > 50)
                    throw new ArgumentOutOfRangeException("Invalid value for ProductCode", value, value.ToString());

                _productcode = value;
            }
        }

        /// <summary>
        /// 
        /// </summary>		
        public string ProductName
        {
            get { return _productname; }
            set
            {
                if (value != null && value.Length > 100)
                    throw new ArgumentOutOfRangeException("Invalid value for ProductName", value, value.ToString());

                _productname = value;
            }
        }

        /// <summary>
        /// 
        /// </summary>		
        public double M1
        {
            get { return _m1; }
            set { _m1 = value; }
        }

        /// <summary>
        /// 
        /// </summary>		
        public double M2
        {
            get { return _m2; }
            set { _m2 = value; }
        }

        /// <summary>
        /// 
        /// </summary>		
        public double M3
        {
            get { return _m3; }
            set { _m3 = value; }
        }

        /// <summary>
        /// 
        /// </summary>		
        public double M4
        {
            get { return _m4; }
            set { _m4 = value; }
        }

        /// <summary>
        /// 
        /// </summary>		
        public double M5
        {
            get { return _m5; }
            set { _m5 = value; }
        }

        /// <summary>
        /// 
        /// </summary>		
        public double M6
        {
            get { return _m6; }
            set { _m6 = value; }
        }

        /// <summary>
        /// 
        /// </summary>		
        public double M7
        {
            get { return _m7; }
            set { _m7 = value; }
        }

        /// <summary>
        /// 
        /// </summary>		
        public double M8
        {
            get { return _m8; }
            set { _m8 = value; }
        }

        /// <summary>
        /// 
        /// </summary>		
        public double M9
        {
            get { return _m9; }
            set { _m9 = value; }
        }

        /// <summary>
        /// 
        /// </summary>		
        public double M10
        {
            get { return _m10; }
            set { _m10 = value; }
        }

        /// <summary>
        /// 
        /// </summary>		
        public double M11
        {
            get { return _m11; }
            set { _m11 = value; }
        }

        /// <summary>
        /// 
        /// </summary>		
        public double M12
        {
            get { return _m12; }
            set { _m12 = value; }
        }

        /// <summary>
        /// 
        /// </summary>		
        public string ErrMassage
        {
            get { return _errmassage; }
            set
            {
                if (value != null && value.Length > 1073741823)
                    throw new ArgumentOutOfRangeException("Invalid value for ErrMassage", value, value.ToString());

                _errmassage = value;
            }
        }




        #endregion





    }
}
