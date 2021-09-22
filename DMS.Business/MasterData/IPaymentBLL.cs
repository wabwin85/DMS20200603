using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DMS.Model;

namespace DMS.Business
{
    public interface IPaymentBLL
    {
        IList<Payment> getPaymentALL();
    }
}
