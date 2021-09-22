using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DMS.Model;
using DMS.DataAccess;
using DMS.Business;

namespace DMS.Business
{
    public class PaymentBLL : IPaymentBLL
    {

        /// <summary>
        /// 得到所有付款方式
        /// </summary>
        /// <param name="table">Payment</param>
        /// <returns>IList</returns>
        public IList<Payment> getPaymentALL()
        {
            using (PaymentDao dao = new PaymentDao())
            {
                return dao.GetAll();
            }
        }

    }
}
