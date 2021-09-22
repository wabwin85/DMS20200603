using DMS.ViewModel.Common;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace DMS.ViewModel.Consign.Common
{
    public class ConsignContract
    {
        public ConsignContract()
        {
        }

        public ConsignContract(String ContractId,
                               String ContractName,
                               String ContractNo,
                               String ConsignDay,
                               String DelayTimes,
                               String ContractDate,
                               bool Kb,
                               bool FixedMoney,
                               bool FixedQuantity,
                               bool UseDiscount,
                               String Remark)
        {
            this.ContractId = ContractId;
            this.ContractName = ContractName;
            this.ContractNo = ContractNo;
            this.ConsignDay = ConsignDay;
            this.DelayTimes = DelayTimes;
            this.ContractDate = ContractDate;
            this.Kb = Kb;
            this.FixedMoney = FixedMoney;
            this.FixedQuantity = FixedQuantity;
            this.UseDiscount = UseDiscount;
            this.Remark = Remark;
        }

        [LogAttribute]
        public String ContractId;
        [LogAttribute]
        public String ContractName;
        [LogAttribute]
        public String ContractNo;
        [LogAttribute]
        public String ConsignDay;
        [LogAttribute]
        public String DelayTimes;
        [LogAttribute]
        public String ContractDate;
        [LogAttribute]
        public bool Kb;
        [LogAttribute]
        public bool FixedMoney;
        [LogAttribute]
        public bool FixedQuantity;
        [LogAttribute]
        public bool UseDiscount;
        [LogAttribute]
        public String Remark;
    }
}
