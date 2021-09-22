using System;
using System.Collections.Generic;
using System.Linq;
using System.ServiceProcess;
using System.Text;
using System.Threading.Tasks;

namespace SendMailService
{
    static class Program
    {
        /// <summary>
        /// 应用程序的主入口点。
        /// </summary>
        static void Main()
        {
#if (!DEBUG)
            ServiceBase[] ServicesToRun;
            ServicesToRun = new ServiceBase[] 
			{ 
				new SendMail() 
			};
            ServiceBase.Run(ServicesToRun);


#else
            // debug code: allows the process to run as a non-service
            // will kick off the service start point, but never kill it
            // shut down the debugger to exit
            SendMail service = new SendMail(false);
            System.Threading.Thread.Sleep(System.Threading.Timeout.Infinite);

#endif
        }
    }
}
