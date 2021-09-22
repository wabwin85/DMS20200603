using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DMS.Model;

namespace DMS.Business.MasterData
{
    public interface IClientBLL
    {
        Client GetClientById(string clientid);
        Client GetClientByCorpId(Guid corpId);
        Client GetParentClientByCorpId(Guid corpId);
    }
}
