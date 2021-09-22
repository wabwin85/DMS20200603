using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Lafite.RoleModel.Security;
using DMS.Model;
using DMS.DataAccess;
using DMS.Model.Data;

namespace DMS.Business.MasterData
{
    public class ClientBLL : IClientBLL
    {
        private IRoleModelContext _context = RoleModelContext.Current;

        #region IClientBLL 成员

        public Client GetClientById(string clientid)
        {
            using (ClientDao dao = new ClientDao())
            {
                return dao.GetObject(clientid);
            }
        }

        public Client GetClientByCorpId(Guid corpId)
        {
            using (ClientDao dao = new ClientDao())
            {
                return dao.SelectClientByCorpId(corpId);
            }
        }

        public Client GetParentClientByCorpId(Guid corpId) 
        {
            using (ClientDao dao = new ClientDao())
            {
                return dao.SelectParentClientByCorpId(corpId);
            }
        }

        #endregion
    }
}
