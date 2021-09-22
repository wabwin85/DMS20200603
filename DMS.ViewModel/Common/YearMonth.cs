using System;

namespace DMS.ViewModel.Common
{
    public class YearMonth
    {
        public YearMonth()
        {
        }

        public YearMonth(String Year, String Month)
        {
            this.Year = Year;
            this.Month = Month;
        }

        [LogAttribute]
        public String Year = String.Empty;
        [LogAttribute]
        public String Month = String.Empty;
    }
}
