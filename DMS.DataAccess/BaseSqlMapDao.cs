/**********************************************
 *
 * NameSpace   : DMS.DataAccess 
 * ClassName   : BaseSqlMapDao
 * Created Time: 2009-7 
 * Author      : Donson
 ****** Copyright (C) 2009/2010 - GrapeCity*****
 *
***********************************************/

using System;
using System.Data;
using System.Data.Common;
using System.Collections;
using System.Collections.Generic;

using System.Text;
using IBatisNet.Common;
using IBatisNet.DataMapper;

using IBatisNet.Common.Exceptions;
using IBatisNet.DataMapper.MappedStatements;
using IBatisNet.DataMapper.Scope;
using IBatisNet.DataMapper.MappedStatements.ResultStrategy;

namespace DMS.DataAccess
{
    using Grapecity.DataAccess;
    using Grapecity.DataAccess.IBatisNet;
    using System.Data.SqlClient;

    /// <summary>
    /// Batis实现的DAO基类
    /// </summary>
    public class BaseSqlMapDao : IBaseSqlDao
    {
        private SqlMapDaoSession _daoSession;
        protected const string ConnectionString = "ConnectionString";
        private static readonly IBatisNet.Common.Logging.ILog _logger = IBatisNet.Common.Logging.LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);


        public BaseSqlMapDao()
        {
            //_daoSession = (SqlMapDaoSession)DaoSessionManager.CreateDaoSession(DAOS_ESSION);
            _daoSession = new SqlMapDaoSession(ConnectionString);
        }

        public BaseSqlMapDao(SqlMapDaoSession daoSession)
        {
            _daoSession = daoSession;
        }

        public SqlMapDaoSession DaoSession
        {
            get
            {
                return _daoSession;
            }
        }

        public ISqlMapper SqlMap
        {
            get { return _daoSession.SqlMap; }
        }

        public void Close()
        {
            if (_daoSession != null)
                _daoSession.Dispose();
        }

        public void Dispose()
        {
            Close();
        }

        #region 针对SqlServer 自定义SqlMapper Method

        private RequestScope PreparedRequestScope(ISqlMapSession session, string statementName, object paramObject)
        {
            ISqlMapper mapper = this.SqlMap;
            IMappedStatement statement = mapper.GetMappedStatement(statementName);
            try
            {
                RequestScope requestScope = statement.Statement.Sql.GetRequestScope(statement, paramObject, session);
                statement.PreparedCommand.Create(requestScope, session, statement.Statement, paramObject);

                return requestScope;
            }
            catch
            {
                throw;
            }
        }

        /// <summary>
        /// Queries for count.
        /// </summary>
        /// <param name="statementName">Name of the statement.</param>
        /// <param name="paramObject">The param object.</param>
        /// <returns></returns>
        public int QueryForCount(string statementName, object paramObject)
        {
            ISqlMapper mapper = this.SqlMap;

            bool isSessionLocal = false;
            ISqlMapSession session = mapper.LocalSession;

            if (session == null)
            {
                session = mapper.CreateSqlMapSession();
                isSessionLocal = true;
            }

            RequestScope scope = PreparedRequestScope(session, statementName, paramObject);
            try
            {
                using (IDbCommand cmd = scope.IDbCommand)
                {

                    cmd.Connection = scope.Session.Connection;

                    cmd.CommandText = string.Format("select count(*) c from ({0}) t ", cmd.CommandText);

                    if (_logger.IsDebugEnabled)
                        _logger.Debug(cmd.CommandText);

                    object row = cmd.ExecuteScalar();
                    return Convert.ToInt32(row);
                }
            }
            finally
            {
                if (isSessionLocal)
                {
                    session.CloseConnection();
                }
            }

        }

        /// <summary>
        /// Executes the query for list.
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="statementName">Name of the statement.</param>
        /// <param name="parameterObject">The parameter object.</param>
        /// <param name="start">The start.</param>
        /// <param name="limit">The limit.</param>
        /// <param name="totalRowCount">The total row count.</param>
        /// <returns></returns>
        public IList<T> ExecuteQueryForList<T>(string statementName, object parameterObject, int start, int limit, out int totalRowCount)
        {
            ISqlMapper mapper = this.SqlMap;

            bool isSessionLocal = false;
            ISqlMapSession session = mapper.LocalSession;

            if (session == null)
            {
                session = mapper.CreateSqlMapSession();
                isSessionLocal = true;
            }

            IMappedStatement statement = mapper.GetMappedStatement(statementName);

            IList<T> resultObject = null;

            try
            {

                RequestScope request = statement.Statement.Sql.GetRequestScope(statement, parameterObject, session);

                statement.PreparedCommand.Create(request, session, statement.Statement, parameterObject);

                using (IDbCommand cmd = request.IDbCommand)
                {
                    cmd.Connection = request.Session.Connection;

                    string sqlText = cmd.CommandText;

                    string cmdText = string.Format("select count(*) c from ({0}) [Extent1] ", sqlText);
                    cmd.CommandText = cmdText;

                    object row = cmd.ExecuteScalar();
                    totalRowCount = Convert.ToInt32(row);


                    cmdText = string.Format("select Extent1.* from ({0})  AS [Extent1] WHERE [Extent1].[row_number] > {1} and [Extent1].[row_number] <= {2} order by [Extent1].[row_number]", sqlText, start, limit + start);

                    cmd.CommandText = cmdText;

                    if (_logger.IsDebugEnabled)
                        _logger.Debug(cmdText);

                    if (statement.Statement.ListClass == null)
                    {
                        resultObject = new List<T>();
                    }
                    else
                    {
                        resultObject = statement.Statement.CreateInstanceOfGenericListClass<T>();
                    }


                    IDataReader reader = cmd.ExecuteReader();

                    try
                    {
                        do
                        {
                            IResultStrategy resultStrategy = ResultStrategyFactory.Get(statement.Statement);

                            while (reader.Read())
                            {
                                object obj = resultStrategy.Process(request, ref reader, null);
                                if (obj != BaseStrategy.SKIP)
                                {
                                    resultObject.Add((T)obj);
                                }
                            }

                        }
                        while (reader.NextResult());
                    }
                    catch
                    {
                        throw;
                    }
                    finally
                    {
                        reader.Close();
                        reader.Dispose();
                    }


                    //statement.ExecutePostSelect(request);
                    //RetrieveOutputParameters(request, session, cmd, parameterObject);
                }
            }
            finally
            {
                if (isSessionLocal)
                {
                    session.CloseConnection();
                }
            }

            return resultObject;

        }


        /// <summary>
        /// Executes the query for data set.
        /// </summary>
        /// <param name="statementName">Name of the statement.</param>
        /// <param name="paramObject">The param object.</param>
        /// <returns></returns>
        public DataSet ExecuteQueryForDataSet(string statementName, object paramObject)
        {
            ISqlMapper mapper = this.SqlMap;

            bool isSessionLocal = false;
            ISqlMapSession session = mapper.LocalSession;

            if (session == null)
            {
                session = mapper.CreateSqlMapSession();
                isSessionLocal = true;
            }

            RequestScope scope = PreparedRequestScope(session, statementName, paramObject);

            DataSet ds = new DataSet();
            try
            {
                using (IDbCommand cmd = session.CreateCommand(CommandType.Text))
                {
                    cmd.CommandTimeout = scope.IDbCommand.CommandTimeout;
                    cmd.Connection = scope.Session.Connection;
                    if (scope.Session.Transaction != null)
                        cmd.Transaction = scope.Session.Transaction;

                    SqlParameter[] clonedParameters = new SqlParameter[scope.IDbCommand.Parameters.Count];

                    for (int i = 0, j = scope.IDbCommand.Parameters.Count; i < j; i++)
                    {
                        clonedParameters[i] = (SqlParameter)((ICloneable)scope.IDbCommand.Parameters[i]).Clone();
                    }

                    foreach (SqlParameter p in clonedParameters)
                    {
                        cmd.Parameters.Add(p);
                    }

                    string sqlText = scope.IDbCommand.CommandText;
                    if (_logger.IsDebugEnabled)
                        _logger.Debug(sqlText);

                    cmd.CommandText = sqlText;

                    IDbDataAdapter adapter = session.CreateDataAdapter(cmd);
                    adapter.Fill(ds);
                }
            }
            finally
            {
                if (isSessionLocal)
                {
                    session.CloseConnection();
                }
            }
            return ds;
        }

        /// <summary>
        /// Executes the query for data set.
        /// </summary>
        /// <param name="statementName">Name of the statement.</param>
        /// <param name="paramObject">The param object.</param>
        /// <param name="start">The start.</param>
        /// <param name="limit">The limit.</param>
        /// <param name="totalRowCount">The total row count.</param>
        /// <returns></returns>
        public DataSet ExecuteQueryForDataSet(string statementName, object paramObject, int start, int limit, out int totalRowCount,bool isRecompile=false)
        {
            ISqlMapper mapper = this.SqlMap;

            bool isSessionLocal = false;
            ISqlMapSession session = mapper.LocalSession;

            if (session == null)
            {
                session = mapper.CreateSqlMapSession();
                isSessionLocal = true;
            }

            RequestScope scope = PreparedRequestScope(session, statementName, paramObject);

            DataSet ds = new DataSet();
            try
            {
                using (IDbCommand cmd = session.CreateCommand(CommandType.Text))
                {
                    cmd.CommandTimeout = scope.IDbCommand.CommandTimeout;
                    cmd.Connection = scope.Session.Connection;
                    if (scope.Session.Transaction != null)
                        cmd.Transaction = scope.Session.Transaction;

                    SqlParameter[] clonedParameters = new SqlParameter[scope.IDbCommand.Parameters.Count];

                    for (int i = 0, j = scope.IDbCommand.Parameters.Count; i < j; i++)
                    {
                        clonedParameters[i] = (SqlParameter)((ICloneable)scope.IDbCommand.Parameters[i]).Clone();
                    }

                    foreach (SqlParameter p in clonedParameters)
                    {
                        cmd.Parameters.Add(p);
                    }

                    string sqlText = scope.IDbCommand.CommandText;

                    string cmdText = string.Format("select count(*) c from ({0}) [Extent1] ", sqlText);

                    cmd.CommandText = cmdText;

                    scope.Session.OpenConnection();

                    object row = cmd.ExecuteScalar();
                    totalRowCount = Convert.ToInt32(row);

                    cmdText = string.Format("select Extent1.* from ({0})  AS [Extent1] WHERE [Extent1].[row_number] > {1} and [Extent1].[row_number] <= {2} order by [Extent1].[row_number]{3}", sqlText, start, limit + start, isRecompile? " option(recompile)" : "");

                    cmd.CommandText = cmdText;

                    if (_logger.IsDebugEnabled)
                        _logger.Debug(cmdText);

                    IDbDataAdapter adapter = session.CreateDataAdapter(cmd);
                    adapter.Fill(ds);
                }
            }
            finally
            {
                if (isSessionLocal)
                {
                    session.CloseConnection();
                }
            }
            return ds;
        }
        #endregion

        #region IBatisNet SqlMapper 原生方法

        /// <summary>
        /// Simple convenience method to wrap the SqlMap method of the same name.
        /// Wraps the exception with a IBatisNetException to isolate the SqlMap framework.
        /// </summary>
        /// <param name="statementName"></param>
        /// <param name="parameterObject"></param>
        /// <returns></returns>
        protected IList ExecuteQueryForList(string statementName, object parameterObject)
        {
            try
            {
                return SqlMap.QueryForList(statementName, parameterObject);
            }
            catch (Exception e)
            {
                throw new IBatisNetException("Error executing query '" + statementName + "' for list.  Cause: " + e.Message, e);
            }
        }

        protected IList<T> ExecuteQueryForList<T>(string statementName, object parameterObject)
        {
            try
            {
                return SqlMap.QueryForList<T>(statementName, parameterObject);
            }
            catch (Exception e)
            {
                throw new IBatisNetException("Error executing query '" + statementName + "' for list.  Cause: " + e.Message, e);
            }
        }

        /// <summary>
        /// Simple convenience method to wrap the SqlMap method of the same name.
        /// Wraps the exception with a IBatisNetException to isolate the SqlMap framework.
        /// </summary>
        /// <param name="statementName"></param>
        /// <param name="parameterObject"></param>
        /// <returns></returns>
        protected object ExecuteQueryForObject(string statementName, object parameterObject)
        {
            try
            {
                return SqlMap.QueryForObject(statementName, parameterObject);
            }
            catch (Exception e)
            {
                throw new IBatisNetException("Error executing query '" + statementName + "' for object.  Cause: " + e.Message, e);
            }
        }


        protected T ExecuteQueryForObject<T>(string statementName, object parameterObject)
        {
            try
            {
                return SqlMap.QueryForObject<T>(statementName, parameterObject);
            }
            catch (Exception e)
            {
                throw new IBatisNetException("Error executing query '" + statementName + "' for object.  Cause: " + e.Message, e);
            }
        }

        /// <summary>
        /// Simple convenience method to wrap the SqlMap method of the same name.
        /// Wraps the exception with a IBatisNetException to isolate the SqlMap framework.
        /// </summary>
        /// <param name="statementName"></param>
        /// <param name="parameterObject"></param>
        /// <returns></returns>
        protected int ExecuteUpdate(string statementName, object parameterObject)
        {
            try
            {
                return SqlMap.Update(statementName, parameterObject);
            }
            catch (Exception e)
            {
                throw new IBatisNetException("Error executing query '" + statementName + "' for update.  Cause: " + e.Message, e);
            }
        }

        /// <summary>
        /// Simple convenience method to wrap the SqlMap method of the same name.
        /// Wraps the exception with a IBatisNetException to isolate the SqlMap framework.
        /// </summary>
        /// <param name="statementName"></param>
        /// <param name="parameterObject"></param>
        /// <returns></returns>
        protected object ExecuteInsert(string statementName, object parameterObject)
        {
            try
            {
                return SqlMap.Insert(statementName, parameterObject);
            }
            catch (Exception e)
            {
                throw new IBatisNetException("Error executing query '" + statementName + "' for insert.  Cause: " + e.Message, e);
            }
        }

        /// <summary>
        /// Simple convenience method to wrap the SqlMap method of the same name.
        /// Wraps the exception with a IBatisNetException to isolate the SqlMap framework.
        /// </summary>
        /// <param name="statementName"></param>
        /// <param name="parameterObject"></param>
        /// <returns></returns>
        protected object ExecuteDelete(string statementName, object parameterObject)
        {
            try
            {
                return SqlMap.Delete(statementName, parameterObject);
            }
            catch (Exception e)
            {
                throw new IBatisNetException("Error executing query '" + statementName + "' for Delete.  Cause: " + e.Message, e);
            }
        }

        /// <summary>
        /// 批量插入数据，使用SqlBulkCopy实现
        /// </summary>
        /// <param name="descTableName"></param>
        /// <param name="dt"></param>
        public void ExecuteBatchInsert(string descTableName, DataTable dt)
        {
            ISqlMapper mapper = this.SqlMap;

            bool isSessionLocal = false;
            ISqlMapSession session = mapper.LocalSession;

            if (session == null)
            {
                session = mapper.CreateSqlMapSession();
                isSessionLocal = true;
            }

            string connStr = this.SqlMap.DataSource.ConnectionString;

            try
            {

                using (SqlBulkCopy sbc = new SqlBulkCopy((SqlConnection)session.Connection, SqlBulkCopyOptions.Default, (SqlTransaction)session.Transaction))
                {
                    sbc.DestinationTableName = descTableName;
                    sbc.BatchSize = 1000;
                    sbc.BulkCopyTimeout = 60;
                    foreach (DataColumn col in dt.Columns)
                    {
                        sbc.ColumnMappings.Add(col.ColumnName, col.ColumnName);

                    }
                    sbc.WriteToServer(dt);
                }
            }
            catch (Exception ex)
            {
                throw new IBatisNetException("Execute Batch Insert.  Cause: " + ex.Message, ex);
            }
            finally
            {
                if (isSessionLocal)
                {
                    session.CloseConnection();
                }
            }

        }


        #endregion
    }
}