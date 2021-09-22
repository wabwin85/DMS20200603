using DMS.DataAccess;
using DMS.ViewModel.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DMS.Common.Extention;
using DMS.DataAccess.Interface;
using DMS.DataAccess.MasterData;

namespace DMS.BusinessService.Util
{
    public class KeyValueHelper
    {
        public static KeyValue CreateHospital(Guid? hospitalId)
        {
            if (hospitalId == null)
            {
                return new KeyValue();
            }
            else
            {
                return KeyValueHelper.CreateHospital(hospitalId.Value);
            }
        }

        public static KeyValue CreateHospital(Guid hospitalId)
        {
            if (hospitalId.Equals(Guid.Empty))
            {
                return new KeyValue();
            }
            else
            {
                HospitalDao hospitalDao = new HospitalDao();

                return new KeyValue(hospitalId.ToSafeString(),
                                    hospitalDao.GetHospital(hospitalId).HosHospitalName);
            }
        }

        public static KeyValue CreateDealer(Guid? dealerId)
        {
            if (dealerId == null)
            {
                return new KeyValue();
            }
            else
            {
                return KeyValueHelper.CreateDealer(dealerId.Value);
            }
        }

        public static KeyValue CreateDealer(Guid dealerId)
        {
            if (dealerId.Equals(Guid.Empty))
            {
                return new KeyValue();
            }
            else
            {
                DealerMasterDao dealerMasterDao = new DealerMasterDao();

                return new KeyValue(dealerId.ToSafeString(),
                                    dealerMasterDao.GetObject(dealerId).ChineseShortName);
            }
        }

        public static KeyValue CreateSales(String salesId)
        {
            if (salesId.IsNullOrEmpty())
            {
                return new KeyValue();
            }
            else
            {
                MdmEmployeeMasterDao mdmEmployeeMasterDao = new MdmEmployeeMasterDao();

                return new KeyValue(salesId,
                                    mdmEmployeeMasterDao.SelectEmployeeName(salesId));
            }
        }

        public static KeyValue CreateProductLine(Guid? productLineId)
        {
            if (productLineId == null)
            {
                return new KeyValue();
            }
            else
            {
                return KeyValueHelper.CreateProductLine(productLineId.Value);
            }
        }

        public static KeyValue CreateProductLine(Guid productLineId)
        {
            if (productLineId.Equals(Guid.Empty))
            {
                return new KeyValue();
            }
            else
            {
                ProductLineDao productLineDao = new ProductLineDao();

                return new KeyValue(productLineId.ToSafeString(),
                                    productLineDao.SelectProductLineName(productLineId));
            }
        }
    }
}
