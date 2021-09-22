using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using DMS.DataAccess;

namespace DMS.Business
{
    public class COPs : DMS.Business.ICOPs
    {
        public DataSet SelectCOP_FY()
        {
            using (COPDao dao = new COPDao())
            {
                return dao.SelectCOP_FY();
            }
        }

        public DataSet SelectCOP_FQ()
        {
            using (COPDao dao = new COPDao())
            {
                return dao.SelectCOP_FQ();
            }
        }

        public DataSet SelectCOP_FM()
        {
            using (COPDao dao = new COPDao())
            {
                return dao.SelectCOP_FM();
            }
        }

        public string SelectCOP_CurrentFY()
        {
            using (COPDao dao = new COPDao())
            {
                string retString = string.Empty;
                DataSet ds = dao.SelectCOP_CurrentFY();

                if (ds.Tables.Count > 0)
                {
                    if (ds.Tables[0].Rows.Count > 0)
                    {
                        retString = ds.Tables[0].Rows[0][0].ToString();
                    }
                }

                return retString;
            }
        }

        public string SelectCOP_CurrentFQ()
        {
            using (COPDao dao = new COPDao())
            {
                string retString = string.Empty;
                DataSet ds = dao.SelectCOP_CurrentFQ();

                if (ds.Tables.Count > 0)
                {
                    if (ds.Tables[0].Rows.Count > 0)
                    {
                        retString = ds.Tables[0].Rows[0][0].ToString();
                    }
                }

                return retString;
            }
        }

        public string SelectCOP_CurrentFM()
        {
            using (COPDao dao = new COPDao())
            {
                string retString = string.Empty;
                DataSet ds = dao.SelectCOP_CurrentFM();

                if (ds.Tables.Count > 0)
                {
                    if (ds.Tables[0].Rows.Count > 0)
                    {
                        retString = ds.Tables[0].Rows[0][0].ToString();
                    }
                }

                return retString;
            }
        }
    }
}
