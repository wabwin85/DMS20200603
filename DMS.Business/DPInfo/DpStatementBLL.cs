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
    public class DpStatementBLL
    {
        private IRoleModelContext _context = RoleModelContext.Current;

        #region Action Define
        public const string Action_DealerFinanceStatement = "DealerFinanceStatement";
        #endregion

        //[AuthenticateHandler(ActionName = Action_DealerFinanceStatement, Description = "经销商财务风险评估查询", Permissoin = PermissionType.Read)]
        public DataSet QueryDealerFinanceStatement(Hashtable table, int start, int limit, out int totalRowCount)
        {
            table.Add("OwnerIdentityType", this._context.User.IdentityType);
            table.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            table.Add("OwnerId", new Guid(this._context.User.Id));

            using (DpStatementHeaderDao dao = new DpStatementHeaderDao())
            {
                return dao.QueryDealerFinanceStatement(table, start, limit, out totalRowCount);

            }
        }

        public DpStatementHeader GetDealerFinanceStatementHeaderById(Guid id)
        {
            using (DpStatementHeaderDao dao = new DpStatementHeaderDao())
            {
                return dao.GetObject(id);

            } 
        }

        public IList<DpStatementDetail> SelectDealerFinanceStatementDetailById(Guid id)
        {
            using (DpStatementDetailDao dao = new DpStatementDetailDao())
            {
                return dao.SelectDealerFinanceStatementDetailById(id);

            }
        }

        public IList<DpStatementDetail> SelectChangedDealerFinanceStatementDetailById(Guid id)
        {
            using (DpStatementDetailDao dao = new DpStatementDetailDao())
            {
                return dao.SelectChangedDealerFinanceStatementDetailById(id);

            }
        }

        public IList<DpStatementDetail> SelectDealerFinanceStatementDetailByDealer(Guid dealerId, string yearMonth)
        {
            using (DpStatementDetailDao dao = new DpStatementDetailDao())
            {
                Hashtable ht = new Hashtable();
                ht.Add("DealerId", dealerId);
                ht.Add("YearMonth", yearMonth);
                return dao.SelectDealerFinanceStatementDetailByDealer(ht);

            }
        }

        public IList<DpStatementRatio> SelectDealerFinanceStatementRatioByDealer(Guid dealerId, string yearMonth)
        {
            using (DpStatementRatioDao dao = new DpStatementRatioDao())
            {
                Hashtable ht = new Hashtable();
                ht.Add("DealerId", dealerId);
                ht.Add("YearMonth", yearMonth);
                return dao.SelectDealerFinanceStatementRatioByDealer(ht);

            }
        }

        public IList<DpStatementCashflow> SelectDealerFinanceStatementCashFlowByDealer(Guid dealerId, string yearMonth)
        {
            using (DpStatementCashflowDao dao = new DpStatementCashflowDao())
            {
                Hashtable ht = new Hashtable();
                ht.Add("DealerId", dealerId);
                ht.Add("YearMonth", yearMonth);
                return dao.SelectDealerFinanceStatementCashFlowByDealer(ht);

            }
        }

        public DataSet SelectDealerFinanceStatementFieldByType(string type)
        {
            using (DpStatementFieldDao dao = new DpStatementFieldDao())
            {
                return dao.SelectDealerFinanceStatementFieldByType(type);

            }
        }

        public bool Submit(DpStatementHeader header, Hashtable ht)
        {
            bool result = false;

            using (TransactionScope trans = new TransactionScope())
            {
                DpStatementHeaderDao headerDao = new DpStatementHeaderDao();
                DpStatementDetailDao detailDao = new DpStatementDetailDao();

                headerDao.Insert(header);

                foreach (DictionaryEntry entry in ht)
                {
                    DpStatementDetail detail = new DpStatementDetail();
                    detail.Id = Guid.NewGuid();
                    detail.SthId = header.Id;
                    detail.Key = entry.Key.ToString();
                    detail.Value = entry.Value.ToString();
                    detailDao.Insert(detail);
                }

                //计算CashFlow & Ratio
                this.Calculate(header);

                trans.Complete();
                result = true;
            }

            return result;
        }

        public bool Save(Guid headerId, Hashtable ht)
        {
            bool result = false;

            using (TransactionScope trans = new TransactionScope())
            {
                DpStatementHeaderDao headerDao = new DpStatementHeaderDao();
                DpStatementDetailDao detailDao = new DpStatementDetailDao();
                DpStatementChangeLogDao changeDao = new DpStatementChangeLogDao();

                DpStatementHeader header = headerDao.GetObject(headerId);
                IList<DpStatementDetail> detailList = detailDao.SelectDealerFinanceStatementDetailById(headerId);

                int changeCount = 0;
                foreach (DictionaryEntry entry in ht)
                {
                    DpStatementDetail detail = detailList.FirstOrDefault<DpStatementDetail>(t => t.Key == entry.Key.ToString());
                    if (detail != null)
                    {
                        if (Convert.ToDecimal(detail.Value) != Convert.ToDecimal(entry.Value.ToString()))
                        {
                            DpStatementChangeLog log = new DpStatementChangeLog();
                            log.Id = Guid.NewGuid();
                            log.StdId = detail.Id;
                            log.ValueOld = detail.Value;
                            log.ValueNew = entry.Value.ToString();
                            log.CreateUser = new Guid(this._context.User.Id);
                            log.CreateDate = DateTime.Now;
                            changeDao.Insert(log);

                            detail.Value = entry.Value.ToString();
                            detailDao.Update(detail);
                            changeCount++;
                        }
                    }
                }

                if (changeCount > 0)
                {
                    header.UpdateUser = new Guid(this._context.User.Id);
                    header.UpdateDate = DateTime.Now;

                    headerDao.Update(header);
                }

                //计算CashFlow & Ratio
                this.Calculate(header);

                trans.Complete();
                result = true;
            }

            return result;
        }


        public DataSet SelectDealerFinanceStatementDetailChangeLogByKey(Hashtable table, int start, int limit, out int totalRowCount)
        {
            using (DpStatementChangeLogDao dao = new DpStatementChangeLogDao())
            {
                return dao.SelectDealerFinanceStatementDetailChangeLogByKey(table, start, limit, out totalRowCount);

            }
        }

        public DataSet SelectDealerFinanceStatementDetailForCalculation(Hashtable ht)
        {
            using (DpStatementDetailDao dao = new DpStatementDetailDao())
            {
                return dao.SelectDealerFinanceStatementDetailForCalculation(ht);
            }
        }

        public DataSet SelectDealerFinanceStatementDetailForCalculationScoreCard(Hashtable ht)
        {
            using (DpStatementDetailDao dao = new DpStatementDetailDao())
            {
                return dao.SelectDealerFinanceStatementDetailForCalculationScoreCard(ht);
            }
        }

        public DataSet GetDealerFinanceStatementYearList(Hashtable table)
        {
            table.Add("OwnerIdentityType", this._context.User.IdentityType);
            table.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            table.Add("OwnerId", new Guid(this._context.User.Id));

            using (DpStatementHeaderDao dao = new DpStatementHeaderDao())
            {
                return dao.GetDealerFinanceStatementYearList(table);
            }
        }

        public DataSet GetDealerFinanceStatementYearMonthList(Hashtable table)
        {
            using (DpStatementHeaderDao dao = new DpStatementHeaderDao())
            {
                return dao.GetDealerFinanceStatementYearMonthList(table);
            }
        }

        public DataSet GetDealerFinanceStatementMonthByYear(Hashtable ht)
        {
            using (DpStatementHeaderDao dao = new DpStatementHeaderDao())
            {
                return dao.GetDealerFinanceStatementMonthByYear(ht);
            }
        }

        public void Calculate(DpStatementHeader header)
        {
            //计算当年
            CalculateByStatement(header);

            //计算下一年
            using (DpStatementHeaderDao dao = new DpStatementHeaderDao())
            {
                Hashtable ht = new Hashtable();
                ht.Add("DealerId",header.DmaId);
                ht.Add("Year",header.Year);
                ht.Add("Month",header.Month);

                DpStatementHeader headerNext = dao.GetDealerFinanceStatementNextYear(ht);

                if (headerNext != null)
                {
                    CalculateByStatement(headerNext);
                }
            }
        }

        public void CalculateByStatement(DpStatementHeader header)
        {
            string lastYear = (Convert.ToInt32(header.Year) - 1).ToString();

            Hashtable ht = new Hashtable();
            ht.Add("LastYear", lastYear);
            ht.Add("Year", header.Year);
            ht.Add("Month", header.Month);
            ht.Add("DealerId", header.DmaId);

            //获取去年和今年同期两份Statement
            DataSet ds = this.SelectDealerFinanceStatementDetailForCalculation(ht);
            //转换成参数表
            Hashtable param = new Hashtable();
            foreach (DataRow dr in ds.Tables[0].Rows)
            {
                param.Add(dr["Key"].ToString(), dr["Value"].ToString());
            }

            RPNParser parser = new RPNParser();
            //计算CashFlow
            DataSet cds = this.SelectDealerFinanceStatementFieldByType("Cashflow");
            if (cds != null && cds.Tables[0].Rows.Count > 0)
            {
                using (DpStatementCashflowDao dao = new DpStatementCashflowDao())
                {
                    dao.DeleteDpStatementCashflowByHeaderId(header.Id);
                    foreach (DataRow cdr in cds.Tables[0].Rows)
                    {
                        object val = "0";
                        if (cdr["Formula"] != DBNull.Value)
                        {
                            val = parser.EvaluateExpression(cdr["Formula"].ToString(), param);
                        }

                        param.Add(cdr["Key"].ToString(), val.ToString());

                        DpStatementCashflow cashflow = new DpStatementCashflow();
                        cashflow.Id = Guid.NewGuid();
                        cashflow.SthId = header.Id;
                        cashflow.Key = cdr["Key"].ToString();
                        cashflow.Value = val.ToString();
                        dao.Insert(cashflow);
                    }
                }
            }

            //计算Ratio
            DataSet rds = this.SelectDealerFinanceStatementFieldByType("Ratio");
            if (rds != null && rds.Tables[0].Rows.Count > 0)
            {
                using (DpStatementRatioDao dao = new DpStatementRatioDao())
                {
                    dao.DeleteDpStatementRatioByHeaderId(header.Id);
                    foreach (DataRow rdr in rds.Tables[0].Rows)
                    {
                        object val = "0";
                        if (rdr["Formula"] != DBNull.Value)
                        {
                            val = parser.EvaluateExpression(rdr["Formula"].ToString(), param);
                        }

                        param.Add(rdr["Key"].ToString(), val.ToString());

                        DpStatementRatio ratio = new DpStatementRatio();
                        ratio.Id = Guid.NewGuid();
                        ratio.SthId = header.Id;
                        ratio.Key = rdr["Key"].ToString();
                        ratio.Value = val.ToString();
                        dao.Insert(ratio);
                    }
                }
            }
        }

    }
}
