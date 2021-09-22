
/**********************************************
 * NameSpace   : DMS.DataAccess 
 * ClassName   : DealerAuthorization
 * Created Time: 2009-7-17 9:34:44
 * Author      : Donson
 ****** Copyright (C) 2009/2010 - GrapeCity*****
 *
***********************************************/

using System;
using System.Collections;
using System.Collections.Generic;
using IBatisNet.DataMapper;
using DMS.Model;
using Grapecity.DataAccess;
using System.Data;
using System.Data.Common;
using System.Linq;

namespace DMS.DataAccess
{
    /// <summary>
    /// DealerAuthorization的Dao
    /// </summary>
    public class DealerAuthorizationDao : BaseSqlMapDao
    {

        /// <summary>
        /// 默认构造函数

        /// </summary>
        public DealerAuthorizationDao()
            : base()
        {
        }

        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public DealerAuthorization GetObject(Guid? objKey)
        {
            DealerAuthorization obj = this.ExecuteQueryForObject<DealerAuthorization>("SelectDealerAuthorization", objKey);
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<DealerAuthorization> GetAll()
        {
            IList<DealerAuthorization> list = this.ExecuteQueryForList<DealerAuthorization>("SelectDealerAuthorization", null);
            return list;
        }


        /// <summary>
        /// 查询DealerAuthorization
        /// </summary>
        /// <returns>返回DealerAuthorization集合</returns>
        public IList<DealerAuthorization> SelectByFilter(DealerAuthorization obj)
        {
            IList<DealerAuthorization> list = this.ExecuteQueryForList<DealerAuthorization>("SelectByFilterDealerAuthorization", obj);
            return list;
        }

        /// <summary>
        /// 查询DealerAuthorization
        /// </summary>
        /// <param name="obj"></param>
        /// <returns>返回DataSet</returns>
        public DataSet SelectByFilterForDataSet(DealerAuthorization obj)
        {
            DataSet list = this.ExecuteQueryForDataSet("SelectByFilterDealerAuthorizationForDataSet", obj);
            return list;
        }

        public DataSet SelectByFilterForDataSetExclude(DealerAuthorization obj)
        {
            DataSet list = this.ExecuteQueryForDataSet("SelectByFilterDealerAuthorizationForDataSetExclude", obj);
            return list;
        }
        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(DealerAuthorization obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateDealerAuthorization", obj);
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid primaryKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteDealerAuthorization", primaryKey);
            return cnt;
        }



        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(DealerAuthorization obj)
        {
            this.ExecuteInsert("InsertDealerAuthorization", obj);
        }


        /// <summary>
        /// Checks the authorization parts. 
        /// 检查选择的分类是否已存在，如果存在则验证通不过则返回false, 验证通过返回true
        /// </summary>
        /// <param name="categoryID">The category ID.</param>
        /// <param name="dealerID">The dealer ID.</param>
        /// <param name="flag">The flag.</param>
        /// <returns></returns>
        public bool CheckAuthorizationParts(Guid categoryID, Guid dealerID, out int flag)
        {
            bool result = false;
            flag = 0;

            using (DaabDaoSession db = new DaabDaoSession(BaseSqlMapDao.ConnectionString))
            {
                using (DbCommand command = db.GetStoredProcCommand("dbo.GC_CheckAuthorizationParts"))
                {
                    db.AddInParameter(command, "CatagoryID", DbType.Guid, categoryID);
                    db.AddInParameter(command, "DealerID", DbType.Guid, dealerID);

                    DbParameter parameter1 = command.CreateParameter();
                    parameter1.ParameterName = "Flag";
                    parameter1.DbType = DbType.Int32;
                    parameter1.Direction = ParameterDirection.Output;
                    command.Parameters.Add(parameter1);

                    DbParameter parameter2 = command.CreateParameter();
                    parameter2.ParameterName = "ReturnValue";
                    parameter2.DbType = DbType.Int32;
                    parameter2.Direction = ParameterDirection.ReturnValue;
                    command.Parameters.Add(parameter2);

                    db.ExecuteNonQuery(command);

                    flag = (parameter2.Value != null) ? (int)parameter2.Value : -1;

                    if ((flag == 0) && ((parameter1.Value != null) ? ((int)parameter1.Value) : -1) == 0)
                    {
                        result = true;
                    }
                }
            }

            return result;
        }

        public DataSet GetDealerProductLine(Guid dealerId)
        {
            DataSet list = this.ExecuteQueryForDataSet("SelectDealerProductLine", dealerId);
            return list;
        }

        public DataSet ExportDealerAuthorization(Hashtable obj)
        {
            DataSet list = this.ExecuteQueryForDataSet("ExportDealerAuthorization", obj);
            return list;
        }

        //Added By Song Yuqi On 2016-06-21
        public int SaveHositalAuthDate(Hashtable table)
        {
            int cnt = (int)this.ExecuteUpdate("SaveHositalAuthDate", table);
            return cnt;
        }

        //Added By Song Yuqi On 2016-06-21
        public void InsertDealerAuthorizationLog(Hashtable table)
        {
            this.ExecuteInsert("InsertDealerAuthorizationLog", table);
        }

        public IList<DealerAuthorization> SelectByFilterLimit(DealerAuthorization obj)
        {
            IList<DealerAuthorization> list = this.ExecuteQueryForList<DealerAuthorization>("SelectByFilterDealerAuthorizationLimit", obj);
            return list;
        }

        public DataSet GetAuthSubCompany(Guid[] productLines)
        {
            Hashtable table = new Hashtable();
            if (!productLines.Any())
            {
                productLines = new Guid[] {Guid.Empty};
            }
            table.Add("ProductLines", productLines);

            return this.ExecuteQueryForDataSet("DealerAuthorization.GetAuthSubCompany", table);
        }

        public DataSet GetAuthBrand(Guid subCompanyId, Guid[] productLines)
        {
            Hashtable table = new Hashtable();
            table.Add("SubCompanyId", subCompanyId);
            table.Add("ProductLines", productLines);

            return this.ExecuteQueryForDataSet("DealerAuthorization.GetAuthBrand", table);
        }
    }
}