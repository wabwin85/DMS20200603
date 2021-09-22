using System;
using System.Data;
using System.Collections;
using System.Collections.Generic;

namespace DMS.Business.DP
{
    public interface IDPForecastImportService
    {
        DataSet DPForecastExport(string YearMonth,string  cbProductLine);
        DataSet GetYearMonth();
        DataSet Get3MonthBP();
    }
}
