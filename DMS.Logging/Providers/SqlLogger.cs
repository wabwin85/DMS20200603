using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.Practices.EnterpriseLibrary.Data;
using Microsoft.Practices.EnterpriseLibrary.Common.Configuration;
using System.Data.Common;
using System.Data;

namespace DMS.Logging.Providers
{
    public class SqlLogger : ILogger
    {

        private static object _syncLock = new object();

        private static Database _db = null;

        private static Database db
        {
            get
            {
                if (_db == null)
                {
                    lock (_syncLock)
                    {
                        if (_db == null)
                        {
                            IConfigurationSource source = ConfigurationSourceFactory.Create("enterpriseLibrary");
                            DatabaseProviderFactory factory = new DatabaseProviderFactory(source);
                            _db = factory.CreateDefault();
                        }
                    }
                }
                return _db;
            }
        }

        #region ILogger 成员

        public void WriteLog(LogEntry log)
        {            
            StringBuilder sb = new StringBuilder();
            sb.Append("insert into UserLog (UserId,Category,EventId,EventTime,EventMessage) values (@UserId,@Category,@EventId,@EventTime,@EventMessage);");
            DbCommand cmd = db.GetSqlStringCommand(sb.ToString());
            db.AddInParameter(cmd, "@UserId", DbType.String, IdentityHelper.GetIdentityId());
            db.AddInParameter(cmd, "@Category", DbType.String, log.Category);
            db.AddInParameter(cmd, "@EventId", DbType.String, log.EventId);
            db.AddInParameter(cmd, "@EventTime", DbType.DateTime, DateTime.Now);
            db.AddInParameter(cmd, "@EventMessage", DbType.String, log.EventMessage);
            db.ExecuteNonQuery(cmd);
        }

        #endregion
    }
}
