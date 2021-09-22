using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Business
{
    using DMS.Model;
    using Coolite.Ext.Web;
    using DMS.Business.MasterData;

    public interface IVirtualDC
    {
        IList<Virtualdc> QueryForPlant(Guid DmaId, Guid BumId);
    }
}
