using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.ViewModel.Common
{
    public class ChangeRecords<T>
    {
        public List<T> Created { get; set; }
        public List<T> Deleted { get; set; }
        public List<T> Updated { get; set; }
    }
}
