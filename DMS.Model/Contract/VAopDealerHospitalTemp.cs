using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Model
{
    /// <summary>
    ///	VAopDealerHospitalTemp
    /// </summary>
    [Serializable]
    public class VAopDealerHospitalTemp : BaseModel
    {
        #region Private Members 10

        private Guid _id;
        private Guid _contract_id;
        private Guid _dealer_dma_id;
        private Guid? _dealer_dma_id_actual;
        private Guid _productline_bum_id;
        private Guid _hospital_id;
        private string _year;
        private string _month;
        private Guid? _update_user_id;
        private DateTime? _update_date;
        private Guid? _pct_id;
        private string _market_type;
        private Guid? _cc_id;

        private double? _amount1;
        private double? _amount2;
        private double? _amount3;
        private double? _amount4;
        private double? _amount5;
        private double? _amount6;
        private double? _amount7;
        private double? _amount8;
        private double? _amount9;
        private double? _amount10;
        private double? _amount11;
        private double? _amount12;
        #endregion

        #region Default ( Empty ) Class Constuctor
        /// <summary>
        /// default constructor
        /// </summary>
        public VAopDealerHospitalTemp()
        {
            _id = Guid.Empty;
            _contract_id = Guid.Empty;
            _dealer_dma_id = Guid.Empty;
            _dealer_dma_id_actual = null;
            _productline_bum_id = Guid.Empty;
            _hospital_id = Guid.Empty;
            _year = null;
            _month = null;
            _update_user_id = null;
            _update_date = null;
            _pct_id = null;
            _market_type = null;
            _cc_id = null;

            _amount1 = null;
            _amount2 = null;
            _amount3 = null;
            _amount4 = null;
            _amount5 = null;
            _amount6 = null;
            _amount7 = null;
            _amount8 = null;
            _amount9 = null;
            _amount10 = null;
            _amount11 = null;
            _amount12 = null;
        }
        #endregion // End of Default ( Empty ) Class Constuctor

        #region Public Properties

        /// <summary>
        /// AOPDH_ID
        /// </summary>		
        public Guid Id
        {
            get { return _id; }
            set { _id = value; }
        }

        /// <summary>
        /// AOPD_Contract_ID
        /// </summary>		
        public Guid ContractId
        {
            get { return _contract_id; }
            set { _contract_id = value; }
        }

        /// <summary>
        /// AOPDH_Dealer_DMA_ID
        /// </summary>		
        public Guid DealerDmaId
        {
            get { return _dealer_dma_id; }
            set { _dealer_dma_id = value; }
        }

        /// <summary>
        /// AOPDH_Dealer_DMA_ID_Actual
        /// </summary>		
        public Guid? DealerDmaIdActual
        {
            get { return _dealer_dma_id_actual; }
            set { _dealer_dma_id_actual = value; }
        }

        /// <summary>
        /// AOPDH_ProductLine_BUM_ID
        /// </summary>		
        public Guid ProductLineBumId
        {
            get { return _productline_bum_id; }
            set { _productline_bum_id = value; }
        }

        /// <summary>
        /// AOPDH_Hospital_ID
        /// </summary>		
        public Guid HospitalId
        {
            get { return _hospital_id; }
            set { _hospital_id = value; }
        }

        /// <summary>
        /// AOPDH_Year
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
        /// AOPDH_Month
        /// </summary>		
        public string Month
        {
            get { return _month; }
            set
            {
                if (value != null && value.Length > 50)
                    throw new ArgumentOutOfRangeException("Invalid value for Month", value, value.ToString());

                _month = value;
            }
        }

        /// <summary>
        /// AOPDH_Update_User_ID
        /// </summary>		
        public Guid? UpdateUserId
        {
            get { return _update_user_id; }
            set { _update_user_id = value; }
        }

        /// <summary>
        /// AOPDH_Update_Date
        /// </summary>		
        public DateTime? UpdateDate
        {
            get { return _update_date; }
            set { _update_date = value; }
        }

        public Guid? PctId
        {
            get { return _pct_id; }
            set { _pct_id = value; }
        }

        public Guid? CcId
        {
            get { return _cc_id; }
            set { _cc_id = value; }
        }

        /// <summary>
        /// AOPDH_Amount1
        /// </summary>		
        public double? Amount1
        {
            get { return _amount1; }
            set { _amount1 = value; }
        }

        /// <summary>
        /// AOPDH_Amount2
        /// </summary>		
        public double? Amount2
        {
            get { return _amount2; }
            set { _amount2 = value; }
        }

        /// <summary>
        /// AOPDH_Amount3
        /// </summary>		
        public double? Amount3
        {
            get { return _amount3; }
            set { _amount3 = value; }
        }

        /// <summary>
        /// AOPDH_Amount4
        /// </summary>		
        public double? Amount4
        {
            get { return _amount4; }
            set { _amount4 = value; }
        }

        /// <summary>
        /// AOPDH_Amount5
        /// </summary>		
        public double? Amount5
        {
            get { return _amount5; }
            set { _amount5 = value; }
        }

        /// <summary>
        /// AOPDH_Amount6
        /// </summary>		
        public double? Amount6
        {
            get { return _amount6; }
            set { _amount6 = value; }
        }

        /// <summary>
        /// AOPDH_Amount7
        /// </summary>		
        public double? Amount7
        {
            get { return _amount7; }
            set { _amount7 = value; }
        }

        /// <summary>
        /// AOPDH_Amount8
        /// </summary>		
        public double? Amount8
        {
            get { return _amount8; }
            set { _amount8 = value; }
        }

        /// <summary>
        /// AOPDH_Amount9
        /// </summary>		
        public double? Amount9
        {
            get { return _amount9; }
            set { _amount9 = value; }
        }

        /// <summary>
        /// AOPDH_Amount10
        /// </summary>		
        public double? Amount10
        {
            get { return _amount10; }
            set { _amount10 = value; }
        }

        /// <summary>
        /// AOPDH_Amount11
        /// </summary>		
        public double? Amount11
        {
            get { return _amount11; }
            set { _amount11 = value; }
        }

        /// <summary>
        /// AOPDH_Amount12
        /// </summary>		
        public double? Amount12
        {
            get { return _amount12; }
            set { _amount12 = value; }
        }


        /// <summary>
        /// MarketType
        /// </summary>		
        public string MarketType
        {
            get { return _market_type; }
            set
            {
                if (value != null && value.Length > 10)
                    throw new ArgumentOutOfRangeException("Invalid value for MarketType", value, value.ToString());

                _market_type = value;
            }
        }
        #endregion 
    }
}
