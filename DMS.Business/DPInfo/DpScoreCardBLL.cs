using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Lafite.RoleModel.Security;
using Lafite.RoleModel.Security.Authorization;
using System.Data;
using System.Collections;
using DMS.DataAccess;
using DMS.Model;
using Grapecity.DataAccess.Transaction;
using Fulper.ExpressionParser;

namespace DMS.Business.DPInfo
{
    public class DpScoreCardBLL
    {
        private IRoleModelContext _context = RoleModelContext.Current;

        #region Action Define
        public const string Action_DealerFinanceScoreCard = "DealerFinanceScoreCard";
        #endregion

        //[AuthenticateHandler(ActionName = Action_DealerFinanceScoreCard, Description = "经销商财务风险评估查询", Permissoin = PermissionType.Read)]
        public DataSet QueryDealerFinanceScoreCard(Hashtable table, int start, int limit, out int totalRowCount)
        {
            table.Add("OwnerIdentityType", this._context.User.IdentityType);
            table.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            table.Add("OwnerId", new Guid(this._context.User.Id));

            using (DpStatementScorecardHeaderDao dao = new DpStatementScorecardHeaderDao())
            {
                return dao.QueryDealerFinanceScoreCard(table, start, limit, out totalRowCount);

            }
        }

        public Hashtable CalculateScoreCard(Guid dealerId, string cy, string fy)
        {
            DpStatementBLL bll = new DpStatementBLL();
            Hashtable ht = new Hashtable();
            ht.Add("CY", cy);
            ht.Add("FY", fy);
            ht.Add("DealerId", dealerId);

            //获取去年和今年同期两份Statement
            DataSet ds = bll.SelectDealerFinanceStatementDetailForCalculationScoreCard(ht);
            //转换成参数表
            Hashtable param = new Hashtable();
            foreach (DataRow dr in ds.Tables[0].Rows)
            {
                param.Add(dr["Key"].ToString(), dr["Value"].ToString());
            }

            RPNParser parser = new RPNParser();
            //计算CashFlow
            DataSet cds = bll.SelectDealerFinanceStatementFieldByType("Cashflow");
            if (cds != null && cds.Tables[0].Rows.Count > 0)
            {
                foreach (DataRow cdr in cds.Tables[0].Rows)
                {
                    object val = "0";
                    if (cdr["Formula"] != DBNull.Value)
                    {
                        val = parser.EvaluateExpression(cdr["Formula"].ToString(), param);
                    }

                    param.Add(cdr["Key"].ToString(), val.ToString());
                }
            }

            //计算Ratio
            DataSet rds = bll.SelectDealerFinanceStatementFieldByType("Ratio");
            if (rds != null && rds.Tables[0].Rows.Count > 0)
            {
                foreach (DataRow rdr in rds.Tables[0].Rows)
                {
                    object val = "0";
                    if (rdr["Formula"] != DBNull.Value)
                    {
                        val = parser.EvaluateExpression(rdr["Formula"].ToString(), param);
                    }

                    param.Add(rdr["Key"].ToString(), val.ToString());
                }
            }

            return param;
        }

        public bool Save(DpStatementScorecardHeader header, Hashtable ht)
        {
            bool result = false;

            using (TransactionScope trans = new TransactionScope())
            {
                DpStatementScorecardHeaderDao headerDao = new DpStatementScorecardHeaderDao();
                DpStatementScorecardDao detailDao = new DpStatementScorecardDao();

                headerDao.Insert(header);

                foreach (DictionaryEntry entry in ht)
                {
                    DpStatementScorecard detail = new DpStatementScorecard();
                    detail.Id = Guid.NewGuid();
                    detail.SthId = header.Id;
                    detail.Key = entry.Key.ToString();
                    detail.Value = entry.Value.ToString();
                    detailDao.Insert(detail);
                }

                trans.Complete();
                result = true;
            }

            return result;
        }

        public IList<DpStatementScorecard> SelectByFilter(DpStatementScorecard obj)
        {
            using (DpStatementScorecardDao dao = new DpStatementScorecardDao())
            {
                return dao.SelectByFilter(obj);
            }
        }

        public DpStatementScorecardHeader SelectDpStatementScorecardHeader(Guid id)
        {
            using (DpStatementScorecardHeaderDao dao = new DpStatementScorecardHeaderDao())
            {
                return dao.GetObject(id);
            }
        }

        public DpStatementScorecardHeader GetCurrentScoreCardVersion(String dealerId)
        {
            using (DpStatementScorecardHeaderDao dao = new DpStatementScorecardHeaderDao())
            {
                return dao.GetCurrentScoreCardVersion(dealerId);
            }
        }

        public DataTable GetDealerCooperationYears(String dealerId)
        {
            using (DpStatementScorecardHeaderDao dao = new DpStatementScorecardHeaderDao())
            {
                return dao.GetDealerCooperationYears(dealerId);
            }
        }
    }
}
