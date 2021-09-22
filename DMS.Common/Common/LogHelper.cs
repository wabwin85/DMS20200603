using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using log4net;

namespace DMS.Common.Common
{
    public class LogHelper
    {
        private static readonly ILog log = LogManager.GetLogger("log4net");

        public static void Debug(object o, Exception e)
        {
            log.Debug(o, e);
        }

        public static void Debug(object o)
        {
            log.Debug(o);
        }

        public static void Info(object o, Exception e)
        {
            log.Info(o, e);
        }

        public static void Info(object o)
        {
            log.Info(o);
        }

        public static void Warn(object o, Exception e)
        {
            log.Warn(o, e);
        }

        public static void Warn(object o)
        {
            log.Warn(o);
        }

        public static void Error(object o, Exception e)
        {
            log.Error(o, e);
        }

        public static void Error(object o)
        {
            log.Error(o);
        }

        public static void Fatal(object o, Exception e)
        {
            log.Fatal(o, e);
        }

        public static void Fatal(object o)
        {
            log.Fatal(o);
        }
    }
}
