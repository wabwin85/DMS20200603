using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Model
{
    public class DealerInventoryDetail : BaseModel
    {
        #region Private Members 1
        private int _id;

        #endregion


        #region Default ( Empty ) Class Constuctor
        /// <summary>
        /// default constructor
        /// </summary>
        public DealerInventoryDetail()
        {
            _id = 0;
        }
        #endregion // End of Default ( Empty ) Class Constuctor

        #region Public Properties
        /// <summary>
        /// 
        /// </summary>		
        public int Id
        {
            get { return _id; }
            set { _id = value; }
        }
        /// <summary>
     
       
        #endregion 
    }
}
