using NPOI.HSSF.UserModel;
using NPOI.SS.UserModel;
using NPOI.XSSF.UserModel;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BatchImportService
{
    class Program
    {
        public string connectionString = ConfigurationManager.AppSettings["ConnectionString"];
        static void Main(string[] args)
        {
            new DBHelper().Sun();
        }

      

    }
}
