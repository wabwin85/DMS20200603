using DMS.ViewModel.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Collections;

namespace DMS.ViewModel.Inventory
{
    public class ReturnPositionSearchVO : BaseQueryVO
    {
        //隐藏值
        public String WinIDCode;
        public String WinProductline;
        public String Winamount;

        //主页面
        public KeyValue QryDealer;
        public KeyValue QryProductLine;
        public String DealerType;

        public IList<Hashtable> LstDealer = null;
        public IList<KeyValue> LstProductLine = null;
        public ArrayList RstResultList = null;

        //Detail窗体
        public ArrayList RstWinDetail = null;

        //PromotionType窗体
        public KeyValue WinDealer;
        public KeyValue WinProductLine;
        public KeyValue WinQuarter;
        public String WinYears;
        public String WinAmount;
        public String WinRemark;

        public IList<Hashtable> LstWinDealer = null;
        public IList<KeyValue> LstWinProductLine = null;

        //分页
        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;
    }
}
