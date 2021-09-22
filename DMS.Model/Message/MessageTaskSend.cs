
using System;

namespace DMS.Model
{
    /// <summary>
    ///	DPS邮件短信服务
    /// </summary>
    [Serializable]
    public class MessageTaskSend : BaseModel
    {
        #region Private Members 27

        private string _SendMode;
        private string _UserAccount;
        private string _Email;
        private string _CC;
        private string _EmailWechatSubject;
        private string _EmailWechatContent;
        private string _MsgPhone;
        private string _MsgTaskID;
        private string _AttachmentID_1;
        private string _AttachmentID_2;
        private string _AttachmentID_3;
        private string _AttachmentID_4;
        private string _AttachmentID_5;
        private string _AttachmentID_6;
        private string _Parameter_1;
        private string _Parameter_2;
        private string _Parameter_3;
        private string _Parameter_4;
        private string _Parameter_5;
        private string _Parameter_6;
        private string _HtmlTranslationFLG;
        private string _InsertQueFLG;
        private string _SendAdminFLG;
        private string _InsertQueStatus;
        private DateTime? _InsertTime;
        private string _InsertOrigin;
        private string _GUID;
        #endregion

        #region Default ( Empty ) Class Constuctor
        /// <summary>
        /// default constructor
        /// </summary>
        public MessageTaskSend()
        {
            _SendMode = null;
            _UserAccount = null;
            _Email = null;
            _CC = null;
            _EmailWechatSubject = null;
            _EmailWechatContent = null;
            _MsgPhone = null;
            _MsgTaskID = null;
            _AttachmentID_1 = null;
            _AttachmentID_2 = null;
            _AttachmentID_3 = null;
            _AttachmentID_4 = null;
            _AttachmentID_5 = null;
            _AttachmentID_6 = null;
            _Parameter_1 = null;
            _Parameter_2 = null;
            _Parameter_3 = null;
            _Parameter_4 = null;
            _Parameter_5 = null;
            _Parameter_6 = null;
            _HtmlTranslationFLG = null;
            _InsertQueFLG = null;
            _SendAdminFLG = null;
            _InsertQueStatus = null;
            _InsertTime = null;
            _InsertOrigin = null;
            _GUID = null;
        }
        #endregion // End of Default ( Empty ) Class Constuctor

        #region Public Properties
    
        public string SendMode
        {
            get { return _SendMode; }
            set
            {
                if (value != null && value.Length > 10)
                    throw new ArgumentOutOfRangeException("Invalid value for SendMode", value, value.ToString());

                _SendMode = value;
            }
        }
        public string UserAccount
        {
            get { return _UserAccount; }
            set
            {
                if (value != null && value.Length > 2000)
                    throw new ArgumentOutOfRangeException("Invalid value for UserAccount", value, value.ToString());

                _UserAccount = value;
            }
        }
        public string Email
        {
            get { return _Email; }
            set
            {
                if (value != null && value.Length > 2000)
                    throw new ArgumentOutOfRangeException("Invalid value for Email", value, value.ToString());

                _Email = value;
            }
        }
        public string CC
        {
            get { return _CC; }
            set
            {
                if (value != null && value.Length > 2000)
                    throw new ArgumentOutOfRangeException("Invalid value for CC", value, value.ToString());

                _CC = value;
            }
        }
        public string EmailWechatSubject
        {
            get { return _EmailWechatSubject; }
            set
            {
                if (value != null && value.Length > 2000)
                    throw new ArgumentOutOfRangeException("Invalid value for EmailWechatSubject", value, value.ToString());

                _EmailWechatSubject = value;
            }
        }
        public string EmailWechatContent
        {
            get { return _EmailWechatContent; }
            set
            {
                if (value != null && value.Length > 2000)
                    throw new ArgumentOutOfRangeException("Invalid value for EmailWechatContent", value, value.ToString());

                _EmailWechatContent = value;
            }
        }
        public string MsgPhone
        {
            get { return _MsgPhone; }
            set
            {
                if (value != null && value.Length > 2000)
                    throw new ArgumentOutOfRangeException("Invalid value for MsgPhone", value, value.ToString());

                _MsgPhone = value;
            }
        }
        public string MsgTaskID
        {
            get { return _MsgTaskID; }
            set
            {
                if (value != null && value.Length > 2000)
                    throw new ArgumentOutOfRangeException("Invalid value for MsgTaskID", value, value.ToString());

                _MsgTaskID = value;
            }
        }
        public string AttachmentID_1
        {
            get { return _AttachmentID_1; }
            set
            {
                if (value != null && value.Length > 2000)
                    throw new ArgumentOutOfRangeException("Invalid value for AttachmentID_1", value, value.ToString());

                _AttachmentID_1 = value;
            }
        }
        public string AttachmentID_2
        {
            get { return _AttachmentID_2; }
            set
            {
                if (value != null && value.Length > 2000)
                    throw new ArgumentOutOfRangeException("Invalid value for AttachmentID_2", value, value.ToString());

                _AttachmentID_2 = value;
            }
        }
        public string AttachmentID_3
        {
            get { return _AttachmentID_3; }
            set
            {
                if (value != null && value.Length > 2000)
                    throw new ArgumentOutOfRangeException("Invalid value for AttachmentID_3", value, value.ToString());

                _AttachmentID_3 = value;
            }
        }
        public string AttachmentID_4
        {
            get { return _AttachmentID_4; }
            set
            {
                if (value != null && value.Length > 2000)
                    throw new ArgumentOutOfRangeException("Invalid value for AttachmentID_4", value, value.ToString());

                _AttachmentID_4 = value;
            }
        }
        public string AttachmentID_5
        {
            get { return _AttachmentID_5; }
            set
            {
                if (value != null && value.Length > 2000)
                    throw new ArgumentOutOfRangeException("Invalid value for AttachmentID_5", value, value.ToString());

                _AttachmentID_5 = value;
            }
        }
        public string AttachmentID_6
        {
            get { return _AttachmentID_6; }
            set
            {
                if (value != null && value.Length > 2000)
                    throw new ArgumentOutOfRangeException("Invalid value for AttachmentID_6", value, value.ToString());

                _AttachmentID_6 = value;
            }
        }
        public string Parameter_1
        {
            get { return _Parameter_1; }
            set
            {
                if (value != null && value.Length > 2000)
                    throw new ArgumentOutOfRangeException("Invalid value for Parameter_1", value, value.ToString());

                _Parameter_1 = value;
            }
        }
        public string Parameter_2
        {
            get { return _Parameter_2; }
            set
            {
                if (value != null && value.Length > 2000)
                    throw new ArgumentOutOfRangeException("Invalid value for Parameter_2", value, value.ToString());

                _Parameter_2 = value;
            }
        }
        public string Parameter_3
        {
            get { return _Parameter_3; }
            set
            {
                if (value != null && value.Length > 2000)
                    throw new ArgumentOutOfRangeException("Invalid value for Parameter_3", value, value.ToString());

                _Parameter_3 = value;
            }
        }
        public string Parameter_4
        {
            get { return _Parameter_4; }
            set
            {
                if (value != null && value.Length > 2000)
                    throw new ArgumentOutOfRangeException("Invalid value for Parameter_4", value, value.ToString());

                _Parameter_4 = value;
            }
        }
        public string Parameter_5
        {
            get { return _Parameter_5; }
            set
            {
                if (value != null && value.Length > 2000)
                    throw new ArgumentOutOfRangeException("Invalid value for Parameter_5", value, value.ToString());

                _Parameter_5 = value;
            }
        }
        public string Parameter_6
        {
            get { return _Parameter_6; }
            set
            {
                if (value != null && value.Length > 2000)
                    throw new ArgumentOutOfRangeException("Invalid value for Parameter_6", value, value.ToString());

                _Parameter_6 = value;
            }
        }
        public string HtmlTranslationFLG
        {
            get { return _HtmlTranslationFLG; }
            set
            {
                if (value != null && value.Length > 1)
                    throw new ArgumentOutOfRangeException("Invalid value for HtmlTranslationFLG", value, value.ToString());

                _HtmlTranslationFLG = value;
            }
        }
        public string InsertQueFLG
        {
            get { return _InsertQueFLG; }
            set
            {
                if (value != null && value.Length > 1)
                    throw new ArgumentOutOfRangeException("Invalid value for InsertQueFLG", value, value.ToString());

                _InsertQueFLG = value;
            }
        }
        public string SendAdminFLG
        {
            get { return _SendAdminFLG; }
            set
            {
                if (value != null && value.Length > 1)
                    throw new ArgumentOutOfRangeException("Invalid value for SendAdminFLG", value, value.ToString());

                _SendAdminFLG = value;
            }
        }
        public string InsertQueStatus
        {
            get { return _InsertQueStatus; }
            set
            {
                if (value != null && value.Length > 2000)
                    throw new ArgumentOutOfRangeException("Invalid value for InsertQueStatus", value, value.ToString());

                _InsertQueStatus = value;
            }
        }
      
        public DateTime? InsertTime
        {
            get { return _InsertTime; }
            set { _InsertTime = value; }
        }
        public string InsertOrigin
        {
            get { return _InsertOrigin; }
            set
            {
                if (value != null && value.Length > 200)
                    throw new ArgumentOutOfRangeException("Invalid value for InsertOrigin", value, value.ToString());

                _InsertOrigin = value;
            }
        }
        public string GUID
        {
            get { return _GUID; }
            set
            {
                if (value != null && value.Length > 200)
                    throw new ArgumentOutOfRangeException("Invalid value for GUID", value, value.ToString());

                _GUID = value;
            }
        }

        #endregion
    }
}
