using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Business
{
    using DMS.DataAccess;
    using DMS.Model;
    using System.Collections;
    public class VirtualDC : IVirtualDC
    {
        public IList<Virtualdc> QueryForPlant(Guid DmaId,Guid BumId)
        {
            Hashtable hashtable = new Hashtable();
            hashtable.Add("DmaId", DmaId.ToString());
            hashtable.Add("BumId", BumId.ToString());
            
            using (VirtualdcDao dao = new VirtualdcDao())
            {
                return dao.QueryForPlant(hashtable);
            }
        }
    }
}
