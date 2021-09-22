using DMS.ViewModel.Common;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.ViewModel.DataInterface
{
    public class InterfaceLogListVO : BaseQueryVO
    {
        //查询条件
        public KeyValue QryIlName;
        public KeyValue QryIlStatus;
        public KeyValue QryDealer;
        public DatePickerRange QryIlDate;
        public String QryIlBatchNbr;

        public ArrayList LstIlName = null;
        public ArrayList LstIlStatus = null;
        public ArrayList LstDealer = null;
        public ArrayList RstResultList = null;

        //详细信息
        public String IlId;
        public String WinIlName;
        public String WinIlStartTime;
        public String WinIlEndTime;
        public String WinIlStatus;
        public String WinIlDealerName;
        public String WinIlBatchNbr;
        public String WinIlMessage;

        //分页
        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;
    }
}
