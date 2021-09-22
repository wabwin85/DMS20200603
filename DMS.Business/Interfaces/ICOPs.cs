using System;
using System.Data;
namespace DMS.Business
{
    public interface ICOPs
    {
        DataSet SelectCOP_FQ();
        DataSet SelectCOP_FY();

        string SelectCOP_CurrentFY();
        string SelectCOP_CurrentFQ();
    }
}
