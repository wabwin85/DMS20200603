using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.ViewModel
{
    [AttributeUsage(AttributeTargets.Property | AttributeTargets.Field)]
    public class LogAttribute : Attribute
    {
    }
}
