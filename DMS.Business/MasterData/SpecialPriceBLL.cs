using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using DMS.Model;
using DMS.DataAccess;
using System.Collections;

namespace DMS.Business
{
    public class SpecialPriceBLL : ISpecialPriceBLL
    {
        public IList<SpecialPriceMaster> GetSpecialPriceMasterByDealer(Guid DmaId, Guid BumId)
        {
            Hashtable hashtable = new Hashtable();
            hashtable.Add("DmaId", DmaId.ToString());
            hashtable.Add("BumId", BumId.ToString());          
            using (SpecialPriceMasterDao dao = new SpecialPriceMasterDao())
            {
                return dao.GetSpecialPriceMasterByDealer(hashtable);
            }

        }

        public SpecialPriceMaster GetSpecialPriceMasterByID(Guid Id)
        {
            using (SpecialPriceMasterDao dao = new SpecialPriceMasterDao())
            {
                return dao.GetObject(Id);
            }
        }

        public String GetBOMOrderManHeaderDisc(String PohId)
        {
           
            using (SpecialPriceMasterDao dao = new SpecialPriceMasterDao())
            {
                return dao.GetBOMOrderManHeaderDisc(PohId);
            }

        }

        public DataSet GetPromotionPolicyByCondition(Hashtable table)
        {

            using (SpecialPriceMasterDao dao = new SpecialPriceMasterDao())
            {
                return dao.GetPromotionPolicyByCondition(table);
            }

        }

        public DataSet GetPromotionPolicyById(Guid Id)
        {

            using (SpecialPriceMasterDao dao = new SpecialPriceMasterDao())
            {
                return dao.GetPromotionPolicyById(Id);
            }

        }

        public DataSet GetPromotionPolicyNameById(Guid Id)
        {
            using (SpecialPriceMasterDao dao = new SpecialPriceMasterDao())
            {
                return dao.GetPromotionPolicyNameById(Id);
            }

        }
    }
}
