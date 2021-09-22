using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DMS.UploadSalesToBSC
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("开始---》");
            new UploadSales().DoExecute();
            Console.WriteLine("结束---》");
        }
    }
}
