/*
 * Ibatis.Net for Data Mapper, and Generated by MyGeneration
 * 
 * NameSpace   : DMS.Model 
 * ClassName   : DealeriafSign
 * Created Time: 2014/6/13 14:02:20
 *
 ******* Copyright (C) 2009/2010 - GrapeCity **********
 *
******************************************************/

using System;

namespace DMS.Model
{
	/// <summary>
	///	DealeriafSign
	/// </summary>
	[Serializable]
	public class DealeriafSign : BaseModel
	{
        #region Private Members 19

        private Guid _cm_id;
        private string _from3_company;
        private string _from3_user;
        private DateTime? _from3_date;
        private string _from3_national_id;
        private DateTime? _from3_birth;
        private string _from3_position;
        private string _from5_thirdparty;
        private string _from5_name;
        private string _from5_title;
        private DateTime? _from5_date;
        private string _from6_thirdparty;
        private DateTime? _from6_date;
        private string _from6_presentedby;
        private string _from6_rep_name;
        private string _from6_rep_tital;
        private string _thirdparty_user;
        private string _thirdparty_position;
        private DateTime? _thirdparty_date;
        #endregion

        #region Default ( Empty ) Class Constuctor
        /// <summary>
        /// default constructor
        /// </summary>
        public DealeriafSign()
        {
            _cm_id = Guid.Empty;
            _from3_company = null;
            _from3_user = null;
            _from3_date = null;
            _from3_national_id = null;
            _from3_birth = null;
            _from3_position = null;
            _from5_thirdparty = null;
            _from5_name = null;
            _from5_title = null;
            _from5_date = null;
            _from6_thirdparty = null;
            _from6_date = null;
            _from6_presentedby = null;
            _from6_rep_name = null;
            _from6_rep_tital = null;
            _thirdparty_user = null;
            _thirdparty_position = null;
            _thirdparty_date = null;
        }
        #endregion // End of Default ( Empty ) Class Constuctor

        #region Public Properties

        /// <summary>
        /// DIS_CM_ID
        /// </summary>		
        public Guid CmId
        {
            get { return _cm_id; }
            set { _cm_id = value; }
        }

        /// <summary>
        /// DIS_From3_Company
        /// </summary>		
        public string From3Company
        {
            get { return _from3_company; }
            set
            {
                if (value != null && value.Length > 500)
                    throw new ArgumentOutOfRangeException("Invalid value for From3Company", value, value.ToString());

                _from3_company = value;
            }
        }

        /// <summary>
        /// DIS_From3_User
        /// </summary>		
        public string From3User
        {
            get { return _from3_user; }
            set
            {
                if (value != null && value.Length > 500)
                    throw new ArgumentOutOfRangeException("Invalid value for From3User", value, value.ToString());

                _from3_user = value;
            }
        }

        /// <summary>
        /// DIS_From3_Date
        /// </summary>		
        public DateTime? From3Date
        {
            get { return _from3_date; }
            set { _from3_date = value; }
        }

        /// <summary>
        /// DIS_From3_National_ID
        /// </summary>		
        public string From3NationalId
        {
            get { return _from3_national_id; }
            set
            {
                if (value != null && value.Length > 50)
                    throw new ArgumentOutOfRangeException("Invalid value for From3NationalId", value, value.ToString());

                _from3_national_id = value;
            }
        }

        /// <summary>
        /// DIS_From3_Birth
        /// </summary>		
        public DateTime? From3Birth
        {
            get { return _from3_birth; }
            set { _from3_birth = value; }
        }

        /// <summary>
        /// DIS_From3_Position
        /// </summary>		
        public string From3Position
        {
            get { return _from3_position; }
            set
            {
                if (value != null && value.Length > 200)
                    throw new ArgumentOutOfRangeException("Invalid value for From3Position", value, value.ToString());

                _from3_position = value;
            }
        }

        /// <summary>
        /// DIS_From5_ThirdParty
        /// </summary>		
        public string From5ThirdParty
        {
            get { return _from5_thirdparty; }
            set
            {
                if (value != null && value.Length > 500)
                    throw new ArgumentOutOfRangeException("Invalid value for From5ThirdParty", value, value.ToString());

                _from5_thirdparty = value;
            }
        }

        /// <summary>
        /// DIS_From5_Name
        /// </summary>		
        public string From5Name
        {
            get { return _from5_name; }
            set
            {
                if (value != null && value.Length > 500)
                    throw new ArgumentOutOfRangeException("Invalid value for From5Name", value, value.ToString());

                _from5_name = value;
            }
        }

        /// <summary>
        /// DIS_From5_Title
        /// </summary>		
        public string From5Title
        {
            get { return _from5_title; }
            set
            {
                if (value != null && value.Length > 200)
                    throw new ArgumentOutOfRangeException("Invalid value for From5Title", value, value.ToString());

                _from5_title = value;
            }
        }

        /// <summary>
        /// DIS_From5_Date
        /// </summary>		
        public DateTime? From5Date
        {
            get { return _from5_date; }
            set { _from5_date = value; }
        }

        /// <summary>
        /// DIS_From6_ThirdParty
        /// </summary>		
        public string From6ThirdParty
        {
            get { return _from6_thirdparty; }
            set
            {
                if (value != null && value.Length > 500)
                    throw new ArgumentOutOfRangeException("Invalid value for From6ThirdParty", value, value.ToString());

                _from6_thirdparty = value;
            }
        }

        /// <summary>
        /// DIS_From6_Date
        /// </summary>		
        public DateTime? From6Date
        {
            get { return _from6_date; }
            set { _from6_date = value; }
        }

        /// <summary>
        /// DIS_From6_PresentedBy
        /// </summary>		
        public string From6PresentedBy
        {
            get { return _from6_presentedby; }
            set
            {
                if (value != null && value.Length > 200)
                    throw new ArgumentOutOfRangeException("Invalid value for From6PresentedBy", value, value.ToString());

                _from6_presentedby = value;
            }
        }

        /// <summary>
        /// DIS_From6_Rep_Name
        /// </summary>		
        public string From6RepName
        {
            get { return _from6_rep_name; }
            set
            {
                if (value != null && value.Length > 200)
                    throw new ArgumentOutOfRangeException("Invalid value for From6RepName", value, value.ToString());

                _from6_rep_name = value;
            }
        }

        /// <summary>
        /// DIS_From6_Rep_Tital
        /// </summary>		
        public string From6RepTital
        {
            get { return _from6_rep_tital; }
            set
            {
                if (value != null && value.Length > 200)
                    throw new ArgumentOutOfRangeException("Invalid value for From6RepTital", value, value.ToString());

                _from6_rep_tital = value;
            }
        }

        /// <summary>
        /// 
        /// </summary>		
        public string ThirdPartyUser
        {
            get { return _thirdparty_user; }
            set
            {
                if (value != null && value.Length > 200)
                    throw new ArgumentOutOfRangeException("Invalid value for ThirdPartyUser", value, value.ToString());

                _thirdparty_user = value;
            }
        }

        /// <summary>
        /// 
        /// </summary>		
        public string ThirdPartyPosition
        {
            get { return _thirdparty_position; }
            set
            {
                if (value != null && value.Length > 200)
                    throw new ArgumentOutOfRangeException("Invalid value for ThirdPartyPosition", value, value.ToString());

                _thirdparty_position = value;
            }
        }

        /// <summary>
        /// 
        /// </summary>		
        public DateTime? ThirdPartyDate
        {
            get { return _thirdparty_date; }
            set { _thirdparty_date = value; }
        }




        #endregion 
		
	}
}
