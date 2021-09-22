using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Business.Contract
{
    using DMS.Model;
    using System.Data;
    using System.Collections;
    public interface IContractAppointmentService
    {
        ContractAppointment GetContractAppointmentByID(Guid capId);

        int UpdateAppointmentCmidByConid(Hashtable obj);

        int UpdateAppointmentStatusByConid(Hashtable obj);

        int UpdateAppointmentCOConfirmByConid(Hashtable obj);
        DataSet SelectAppointmentMain(Hashtable table);
        DataSet SelectAppointmentDealer(Hashtable table);
        DataSet SelectAppointmentProposals(Hashtable table);
        bool SaveAppointmentUpdate(Hashtable main, Hashtable dealermain, Hashtable proposals, string tempId);


    }
}
