using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace DMS.ViewModel.Common
{
    public class DatePickerRange
    {
        public DatePickerRange()
        {
        }

        public DatePickerRange(String StartDate,String EndDate)
        {
            this.StartDate = StartDate;
            this.EndDate = EndDate;
        }

        [LogAttribute]
        public String StartDate = "";
        [LogAttribute]
        public String EndDate = "";
    }
}
