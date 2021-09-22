using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Business.Contract
{
    using DMS.DataAccess;
    using DMS.Model;
    using System.Collections;
    using System.Data;
    using Lafite.RoleModel.Security.Authorization;
    using Lafite.RoleModel.Security;
    using Grapecity.DataAccess.Transaction;

    public class ContractAppointmentService : IContractAppointmentService
    {
        public ContractAppointment GetContractAppointmentByID(Guid capId)
        {
            using (ContractAppointmentDao dao = new ContractAppointmentDao())
            {
                return dao.GetObject(capId);
            }
        }

        public int UpdateAppointmentCmidByConid(Hashtable obj)
        {
            using (ContractAppointmentDao dao = new ContractAppointmentDao())
            {
                return dao.UpdateAppointmentCmidByConid(obj);
            }
        }

        public int UpdateAppointmentStatusByConid(Hashtable obj)
        {
            using (ContractAppointmentDao dao = new ContractAppointmentDao())
            {
                return dao.UpdateAppointmentStatusByConid(obj);
            }
        }

        public int UpdateAppointmentCOConfirmByConid(Hashtable obj)
        {
            using (ContractAppointmentDao dao = new ContractAppointmentDao())
            {
                return dao.UpdateAppointmentCOConfirmByConid(obj);
            }
        }
        //管理员修改合同信息
        public DataSet SelectAppointmentMain(Hashtable table)
        {
            using (ContractAppointmentDao dao = new ContractAppointmentDao())
            {
                return dao.SelectAppointmentMain(table);
            }
        }
        public DataSet SelectAppointmentDealer(Hashtable table)
        {
            using (ContractAppointmentDao dao = new ContractAppointmentDao())
            {
                return dao.SelectAppointmentDealer(table);
            }
        }
        public DataSet SelectAppointmentProposals(Hashtable table)
        {
            using (ContractAppointmentDao dao = new ContractAppointmentDao())
            {
                return dao.SelectAppointmentProposals(table);
            }
        }
        public bool SaveAppointmentUpdate(Hashtable main, Hashtable dealermain, Hashtable proposals,string tempId)
        {
            bool result = false;
            using (TransactionScope trans = new TransactionScope())
            {
                ContractAppointmentDao headerDao = new ContractAppointmentDao();
                ContractAmendmentDao amendDao = new ContractAmendmentDao();

                //为维护主信息到临时表
                headerDao.InsertAppointmentMainTemp(main);
                //维护经销商信息到临时表
                headerDao.InsertAppointmentDealerMainTemp(dealermain);
                //维护修改信息到临时表
                headerDao.InsertAppointmentProposalsTemp(proposals);
                //调用存储过程对现有合同备份 维护正式表
                amendDao.AmendmentInitialize(tempId, "Appointment");
                result = true;
                trans.Complete();
            }
            return result;
        }
    }
}
