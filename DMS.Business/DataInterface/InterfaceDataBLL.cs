using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DMS.Model;
using Grapecity.DataAccess.Transaction;
using DMS.DataAccess;
using DMS.Model.DataInterface;
using System.Collections;
using System.Data;


namespace DMS.Business.DataInterface
{
    public class InterfaceDataBLL
    {
        public DataSet QueryInterfaceData(Hashtable table)
        {
            using (InterfaceLogDao dao = new InterfaceLogDao())
            {
                return dao.QueryInterfaceeDataByCondition(table);
            }
        }
        public void UpdateInterfaceData(string DataStr, Guid UserId, string Status, string DataType, out string RtnVal, out string RtnMsg)
        {
            using (InterfaceLogDao dao = new InterfaceLogDao())
            {
                 dao.UpdateInterfaceData(DataStr,UserId,Status,DataType,out RtnVal,out RtnMsg);
            }
        }

        public DataSet SelectInterfaceDataType(string type)
        {
            using (InterfaceLogDao dao = new InterfaceLogDao())
            {
             return   dao.SelectInterfaceDataType(type);
            }
        }
    }
}
