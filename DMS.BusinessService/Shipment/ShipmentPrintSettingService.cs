using System;
using System.Collections;
using DMS.Common.Common;
using DMS.Common;
using DMS.ViewModel.Shipment;
using DMS.DataAccess;
using DMS.Common.Extention;
using DMS.DataAccess.ContractElectronic;
using DMS.DataAccess.Consignment;
using Lafite.RoleModel.Security;
using DMS.Business.Cache;
using System.Linq;
using System.Collections.Generic;
using System.Data;
using DMS.Business.Excel;
using System.Collections.Specialized;
using Newtonsoft.Json;
using DMS.BusinessService.Util.DealerFilter;
using DMS.BusinessService.Util.DealerFilter.Impl;
using DMS.ViewModel.Common;
using DMS.Model;
using DMS.Model.Data;
using DMS.DataAccess.DataInterface;
using DMS.Business;
using Grapecity.DataAccess.Transaction;

namespace DMS.BusinessService.Shipment
{
    public class ShipmentPrintSettingService : ABaseQueryService
    {
        public ShipmentPrintSettingVO Init(ShipmentPrintSettingVO model)
        {
            try
            {
                IShipmentBLL business = new ShipmentBLL();
                DealerCommonSetting dcSetting = business.QueryGetDealerCommonSetting(RoleModelContext.Current.User.CorpId.Value);
                if (dcSetting == null)
                {
                    model.HidIsNew = "True";
                    model.HidInstanceId = Guid.NewGuid().ToString();
                    dcSetting = GetNewDealerCommonSetting(model.HidInstanceId);
                }
                else
                {
                    model.HidIsNew = "False";
                    model.HidInstanceId = dcSetting.Id.ToString();
                }
                //页面赋值
                if (dcSetting.SettingValue != null)
                {
                    model.SwCertificateName = dcSetting.SettingValue.Contains('0');
                    model.SwProductType = dcSetting.SettingValue.Contains('1');
                    model.SwLot = dcSetting.SettingValue.Contains('2');
                    model.SwExpiryDate = dcSetting.SettingValue.Contains('3');
                    model.SwShipmentQty = dcSetting.SettingValue.Contains('4');
                    model.SwUnit = dcSetting.SettingValue.Contains('5');
                    model.SwUnitPrice = dcSetting.SettingValue.Contains('6');
                    model.SwCertificateNo = dcSetting.SettingValue.Contains('7');
                    model.SwCertificateENNo = dcSetting.SettingValue.Contains('8');
                    model.SwStartDate = dcSetting.SettingValue.Contains('9');
                    model.SwExpireDate = dcSetting.SettingValue.Contains('a');
                    model.SwEnglishName = dcSetting.SettingValue.Contains('b');
                    
                }
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public ShipmentPrintSettingVO SaveSetting(ShipmentPrintSettingVO model)
        {
            try
            {
                IShipmentBLL business = new ShipmentBLL();
                DealerCommonSetting dcSetting = GetFormValue(model);
                dcSetting.ActiveFlag = true;
                dcSetting.SettingName = "销售单打印设定";

                if (model.HidIsNew == "True")
                {
                    business.InsertDealerCommonSetting(dcSetting);
                    model.HidIsNew = "False";
                }
                else
                {
                    business.UpdateDealerCommonSetting(dcSetting);
                }
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        private DealerCommonSetting GetNewDealerCommonSetting(string instanceId)
        {
            DealerCommonSetting dcSetting = new DealerCommonSetting();
            dcSetting.Id = new Guid(instanceId);
            dcSetting.DmaId = RoleModelContext.Current.User.CorpId.Value;
            return dcSetting;
        }

        private DealerCommonSetting GetFormValue(ShipmentPrintSettingVO model)
        {
            DealerCommonSetting dcSetting = new DealerCommonSetting();
            dcSetting.Id = new Guid(model.HidInstanceId);
            dcSetting.DmaId = RoleModelContext.Current.User.CorpId.Value;
            dcSetting.SettingValue = "";
            if (model.SwCertificateName)
            {
                dcSetting.SettingValue += "0,";
            }

            if (model.SwProductType)
            {
                dcSetting.SettingValue += "1,";
            }
            if (model.SwLot)
            {
                dcSetting.SettingValue += "2,";
            }
            if (model.SwExpiryDate)
            {
                dcSetting.SettingValue += "3,";
            }
            if (model.SwShipmentQty)
            {
                dcSetting.SettingValue += "4,";
            }

            if (model.SwUnit)
            {
                dcSetting.SettingValue += "5,";
            }
            if (model.SwUnitPrice)
            {
                dcSetting.SettingValue += "6,";
            }

            if (model.SwCertificateNo)
            {
                dcSetting.SettingValue += "7,";
            }

            if (model.SwCertificateENNo)
            {
                dcSetting.SettingValue += "8,";
            }
            if (model.SwStartDate)
            {
                dcSetting.SettingValue += "9,";
            }
            if (model.SwExpireDate)
            {
                dcSetting.SettingValue += "a,";
            }
            if (model.SwEnglishName)
            {
                dcSetting.SettingValue += "b,";
            }

            if (!String.IsNullOrEmpty(dcSetting.SettingValue))
            {
                dcSetting.SettingValue = dcSetting.SettingValue.Substring(0, dcSetting.SettingValue.Length - 1);
            }
            return dcSetting;
        }
    }
}
