using DMS.ViewModel.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Collections;

namespace DMS.ViewModel.DataInterface
{
    public class InterfaceDataListVO : BaseQueryVO
    {
        //查询条件
        public KeyValue QryInterfaceType;
        public KeyValue QryInterfaceStatus;
        public KeyValue QryClient;
        public DatePickerRange QryInterfaceDate;
        public String QryBatchNbr;
        public String QryHeaderNo;
        public String ParamID;
        public String ExecStatus;

        public ArrayList LstInterfaceType = null;
        public ArrayList LstInterfaceStatus = null;
        public ArrayList LstClient = null;
        public ArrayList RstResultList = null;

        //分页
        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;
    }
}
