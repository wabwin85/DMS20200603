using System;
namespace DMS.Model
{
    /// <summary>
    ///	ViewProductLine
    /// </summary>
    [Serializable]
    public class ViewProductLine : Lafite.RoleModel.Domain.AttributeDomain
    {
        #region Private Members

        private string _SubCompanyId;
        private string _SubCompanyName;
        private string _SubCompanyAbbr;
        private string _BrandId;
        private string _BrandName;
        private string _BrandAbbr;

        #endregion


        #region Public Properties

        public string SubCompanyId
        {
            get { return _SubCompanyId; }
            set { _SubCompanyId = value; }
        }

        public string SubCompanyName
        {
            get { return _SubCompanyName; }
            set { _SubCompanyName = value; }
        }
        public string SubCompanyAbbr
        {
            get { return _SubCompanyAbbr; }
            set { _SubCompanyAbbr = value; }
        }

        public string BrandId
        {
            get { return _BrandId; }
            set { _BrandId = value; }
        }

        public string BrandName
        {
            get { return _BrandName; }
            set { _BrandName = value; }
        }
        public string BrandAbbr
        {
            get { return _BrandAbbr; }
            set { _BrandAbbr = value; }
        }
        #endregion

    }
}
