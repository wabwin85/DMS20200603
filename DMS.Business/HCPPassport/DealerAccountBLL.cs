using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using DMS.DataAccess.HCPPassport;

namespace DMS.Business.HCPPassport
{
    public class DealerAccountBLL
    {
        public DataSet SelectByAccount(string Account)
        {
            using (DealerAccountDao dao = new DealerAccountDao())
            {
                return dao.SelectByAccount(Account);
            }
        }
    }
}
