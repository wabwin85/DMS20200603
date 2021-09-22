using DMS.TaskLib.Email;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Text;
using System.Threading.Tasks;

namespace TimingTaskService
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("开始---》");
            new MailHelper().DoExecute();
            Console.WriteLine("结束---》");
        }

    }
}
