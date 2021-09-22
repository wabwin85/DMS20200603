using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using DMS.Model;

namespace DMS.Business
{
    public interface ISpecialPriceBLL
    {
        IList<SpecialPriceMaster> GetSpecialPriceMasterByDealer(Guid DmaId, Guid BumId);
        SpecialPriceMaster GetSpecialPriceMasterByID(Guid Id);
        String GetBOMOrderManHeaderDisc(String PohId);
        DataSet GetPromotionPolicyByCondition(Hashtable table);
        DataSet GetPromotionPolicyById(Guid Id);
        DataSet GetPromotionPolicyNameById(Guid Id);
    }
}
