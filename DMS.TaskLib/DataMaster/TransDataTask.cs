using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Common.Logging;
using Fulper.TaskManager.TaskPlugin;
using Microsoft.Practices.EnterpriseLibrary.Common.Configuration;
using Microsoft.Practices.EnterpriseLibrary.Data;
using DMS.Business;
using DMS.Model;
using System.Threading;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;


namespace DMS.TaskLib.DataMaster
{
    public class TransDataTask : ITask
    {
       // private static ILog _log = LogManager.GetLogger(typeof(TransDataTask));
        private IDictionary<string, string> _config = null;
        private DMS.TaskLib.WeChatService.zzcsc client = null;
        string uid = "EAI";
        string pwd = "midwj#567YU";


        public TransDataTask()
        {
            client = new DMS.TaskLib.WeChatService.zzcsc();
        }

        #region ITask 成员
        public void Execute()
        {
            string ConnectionString = this._config["connectionName"];
            DataTable dtC = client.GetCFNList(uid, pwd).Tables[0];
            DataTable dtP = client.GetProductList(uid, pwd).Tables[0];
            DataTable dtLM = client.GetLotMaster(uid, pwd).Tables[0];
            SqlConnection sqlConn = new SqlConnection(ConnectionString);
            SqlCommand cmd = null;

            #region CFN
            //先清空临时表
            sqlConn.Open();
            cmd = new SqlCommand("", sqlConn);
            cmd.CommandText = "Truncate Table Tmp_CFN";
            cmd.ExecuteNonQuery();
            //sqlConn.Close();

            if (dtC != null && dtC.Rows.Count > 0)
            {

                SqlBulkCopy bulkCopy = new SqlBulkCopy(sqlConn);
                bulkCopy.DestinationTableName = "Tmp_CFN";
                bulkCopy.BatchSize = dtC.Rows.Count;
                foreach (DataColumn col in dtC.Columns)
                {
                    bulkCopy.ColumnMappings.Add(col.ColumnName, col.ColumnName);

                }
                try
                {
                    //sqlConn.Open();
                    bulkCopy.WriteToServer(dtC);
                }
                catch (Exception ex1)
                {
                    throw ex1;
                }
                finally
                {
                    if (bulkCopy != null)
                    {
                        bulkCopy.Close();
                        bulkCopy = null;
                    }
                    if (sqlConn != null)
                    {
                        sqlConn.Close();
                    }

                }
            }


            #endregion

            #region Product
            //先清空临时表
            sqlConn.Open();
            cmd = new SqlCommand("", sqlConn);
            cmd.CommandText = "Truncate Table Tmp_Product";
            cmd.ExecuteNonQuery();
            //sqlConn.Close();

            if (dtP != null && dtP.Rows.Count > 0)
            {

                SqlBulkCopy bulkCopy = new SqlBulkCopy(sqlConn);
                bulkCopy.DestinationTableName = "Tmp_Product";
                bulkCopy.BatchSize = dtP.Rows.Count;
                foreach (DataColumn col in dtP.Columns)
                {
                    bulkCopy.ColumnMappings.Add(col.ColumnName, col.ColumnName);

                }
                try
                {
                    //sqlConn.Open();
                    bulkCopy.WriteToServer(dtP);
                }
                catch (Exception ex1)
                {
                    throw ex1;
                }
                finally
                {
                    if (bulkCopy != null)
                    {
                        bulkCopy.Close();
                        bulkCopy = null;
                    }
                    if (sqlConn != null)
                    {
                        sqlConn.Close();
                    }

                }
            }


            #endregion

            #region LotMaster
            //先清空临时表
            sqlConn.Open();
            cmd = new SqlCommand("", sqlConn);
            cmd.CommandText = "Truncate Table Tmp_LotMaster";
            cmd.ExecuteNonQuery();
            //sqlConn.Close();

            if (dtLM != null && dtLM.Rows.Count > 0)
            {

                SqlBulkCopy bulkCopy = new SqlBulkCopy(sqlConn);
                bulkCopy.DestinationTableName = "Tmp_LotMaster";
                bulkCopy.BatchSize = dtLM.Rows.Count;
                foreach (DataColumn col in dtLM.Columns)
                {
                    bulkCopy.ColumnMappings.Add(col.ColumnName, col.ColumnName);

                }
                try
                {
                    //sqlConn.Open();
                    bulkCopy.WriteToServer(dtLM);
                }
                catch (Exception ex1)
                {
                    throw ex1;
                }
                finally
                {
                    if (bulkCopy != null)
                    {
                        bulkCopy.Close();
                        bulkCopy = null;
                    }
                    if (sqlConn != null)
                    {
                        sqlConn.Close();
                    }

                }
            }
            else
            {
                sqlConn.Close();
            }


            #endregion

            //调用SP同步数据
            sqlConn.Open();
            try
            {
                cmd.CommandText = "exec dbo.GC_TransMasterData";
                cmd.ExecuteNonQuery();
            }
            catch (Exception ex1)
            {
                throw ex1;
            }
            finally
            {
                if (sqlConn != null)
                {
                    sqlConn.Close();
                }

            }
        }

        #endregion

        #region ITask 成员

        public Dictionary<string, string> Config
        {
            set
            {
                this._config = value;
                //_log.Info("TransDataTask Config : Count = " + this._config.Count);
            }
        }

        #endregion
    }
}
