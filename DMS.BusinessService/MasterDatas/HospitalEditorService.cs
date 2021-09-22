using System;
using System.Collections;
using DMS.Common.Common;
using DMS.Common;
using DMS.ViewModel.MasterDatas;
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
using DMS.Model.Data;
using DMS.Business;
using DMS.Model;
using DMS.ViewModel.Common;
using Grapecity.DataAccess.Transaction;

namespace DMS.BusinessService.MasterDatas
{
    public class HospitalEditorService : ABaseQueryService
    {
        #region Ajax Method

        public HospitalEditorVO Init(HospitalEditorVO model)
        {
            try
            {
                IRoleModelContext context = RoleModelContext.Current;
                model.IsDealer = IsDealer;

                //获取下拉框的值
                IDictionary<string, string> dicts = DictionaryHelper.GetDictionary(SR.Consts_Hospital_Grade);
                model.LstHPLGrade = JsonHelper.DataTableToArrayList(dicts.ToArray().ToDataSet().Tables[0]);
                ITerritorys bll = new Territorys();
                IList<Territory> provinces = bll.GetProvinces();
                model.LstHPLProvince = JsonHelper.DataTableToArrayList(provinces.ToDataSet().Tables[0]);

                //获取医院信息

                IHospitals business = new Hospitals();
                
                Hospital hospital;
                if (!string.IsNullOrEmpty(model.IptHosID))
                {
                    hospital = business.GetObject(new Guid(model.IptHosID));
                }
                else
                {
                    model.IptHosID = Guid.NewGuid().ToSafeString();
                    hospital = null;
                }
                KeyValue kvGrade = new KeyValue();
                KeyValue kvProvince = new KeyValue();
                KeyValue kvRegion = new KeyValue();
                KeyValue kvTown = new KeyValue();
                model.IptHPLGrade = kvGrade;
                model.IptHPLProvince = kvProvince;
                model.IptHPLRegion = kvRegion;
                model.IptHPLTown = kvTown;
                if (hospital != null)//编辑
                {
                    model.IptHPLName = hospital.HosHospitalName;
                    model.IptHPLSName = hospital.HosHospitalShortName;
                    model.IptHPLCode = hospital.HosKeyAccount;
                    model.IptHPLPhone = hospital.HosPhone;
                    model.IptHPLAddress = hospital.HosAddress;
                    model.IptHPLPostalCOD = hospital.HosPostalCode;
                    model.IptHPLDean = hospital.HosDirector;
                    model.IptHPLDeanContact = hospital.HosDirectorContact;
                    model.IptHPLHead = hospital.HosChiefEquipment;
                    model.IptHPLHeadContact = hospital.HosChiefEquipmentContact;
                    model.IptHPLWeb = hospital.HosWebsite;
                    kvGrade.Key = hospital.HosGrade;
                    kvGrade.Value = hospital.HosGrade;
                    model.IptHPLGrade = kvGrade;
                    model.IptHPLBSCode = hospital.HosKeyBSAccount;
                    //获取省市区县信息
                    IList<Territory> ttInfo = bll.GetTerritorys();
                    foreach (Territory item in provinces)
                    {
                        if (item.Description == hospital.HosProvince)
                        {
                            kvProvince.Key = item.TerId.ToSafeString();
                            kvProvince.Value = item.Description;
                            model.IptHPLProvince = kvProvince;
                        }
                    }
                    foreach (Territory item in ttInfo)
                    {
                        if (item.Description == hospital.HosCity)
                        {
                            kvRegion.Key = item.TerId.ToSafeString();
                            kvRegion.Value = item.Description;
                            model.IptHPLRegion = kvRegion;
                        }
                        if (item.Description == hospital.HosTown || item.Description == hospital.HosDistrict)
                        {
                            kvTown.Key = item.TerId.ToSafeString();
                            kvTown.Value = item.Description;
                            model.IptHPLTown = kvTown;
                        }
                    }

                    model.ChangeType = "UpdateData";
                }
                else//新增
                {
                    model.ChangeType = "NewData";
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

        public HospitalEditorVO ProvinceChange(HospitalEditorVO model)
        {
            try
            {
                if (!string.IsNullOrEmpty(model.IptHPLProvince.Key))
                {
                    ITerritorys bll = new Territorys();

                    IList<Territory> cities = bll.GetTerritorysByParent(new Guid(model.IptHPLProvince.Key.ToSafeString()));

                    model.LstHPLRegion = JsonHelper.DataTableToArrayList(cities.ToDataSet().Tables[0]);
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

        public HospitalEditorVO RegionChange(HospitalEditorVO model)
        {
            try
            {
                if (!string.IsNullOrEmpty(model.IptHPLRegion.Key))
                {
                    ITerritorys bll = new Territorys();

                    IList<Territory> town = bll.GetTerritorysByParent(new Guid(model.IptHPLRegion.Key.ToSafeString()));

                    model.LstHPLTown = JsonHelper.DataTableToArrayList(town.ToDataSet().Tables[0]);
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

        public HospitalEditorVO SaveChanges(HospitalEditorVO model)
        {
            try
            {
                //检查数据是否合规
                HospitalDao dao = new HospitalDao();
                using (TransactionScope trans = new TransactionScope())
                {
                    if (dao.SelectNotDeleteHospitalByName(model.IptHPLName, model.IptHosID.ToSafeGuid()).Count > 0)
                    {
                        model.IsSuccess = false;
                        model.ExecuteMessage.Add("医院名称:" + model.IptHPLName + "重复。");
                        return model;
                    }
                        
                    if (dao.SelectNotDeleteHospitalByCode(model.IptHPLCode, model.IptHosID.ToSafeGuid()).Count > 0)
                    {
                        model.IsSuccess = false;
                        model.ExecuteMessage.Add("医院编号:" + model.IptHPLCode + "重复。");
                        return model;
                    }

                    //构建Hospital
                    Hospital hospital = new Hospital();
                    hospital.HosId = model.IptHosID.ToSafeGuid();
                    hospital.HosHospitalName = model.IptHPLName;
                    if (!string.IsNullOrEmpty(model.IptHPLGrade.Key))
                        hospital.HosGrade = model.IptHPLGrade.Value;
                    AutoNumberBLL autoNumberBll = new AutoNumberBLL();
                    string code = autoNumberBll.GetNextAutoNumberForCode(CodeAutoNumberSetting.Next_HospitalNbr);
                    hospital.HosKeyAccount = string.IsNullOrEmpty(model.IptHPLCode) ? code : model.IptHPLCode.ToSafeString();
                    hospital.HosHospitalShortName = model.IptHPLSName;
                    if (!string.IsNullOrEmpty(model.IptHPLProvince.Key ))
                        hospital.HosProvince = model.IptHPLProvince.Value;
                    if (!string.IsNullOrEmpty(model.IptHPLRegion.Key))
                        hospital.HosCity = model.IptHPLRegion.Value;
                    if (!string.IsNullOrEmpty(model.IptHPLTown.Key))
                        hospital.HosTown = model.IptHPLTown.Value;
                    hospital.HosDistrict = model.IptHPLTown.Value;
                    hospital.HosPhone = model.IptHPLPhone;
                    hospital.HosAddress = model.IptHPLAddress;
                    hospital.HosPostalCode = model.IptHPLPostalCOD;
                    hospital.HosDirector = model.IptHPLDean;
                    hospital.HosDirectorContact = model.IptHPLDeanContact;
                    hospital.HosChiefEquipment = model.IptHPLHead;
                    hospital.HosChiefEquipmentContact = model.IptHPLHeadContact;
                    hospital.HosWebsite = model.IptHPLWeb;
                    hospital.HosKeyBSAccount = model.IptHPLBSCode;

                    if (model.ChangeType == "UpdateData")
                    {
                        model.IsSuccess = Update(hospital);
                        model.ExecuteMessage.Add("修改成功！");
                    }
                    else if (model.ChangeType == "NewData")
                    {
                        model.IsSuccess = Insert(hospital);
                        model.ExecuteMessage.Add("新增成功！");
                    }
                    trans.Complete();
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

        private bool Update(Hospital hospital)
        {
            bool result = false;
            using (HospitalDao dao = new HospitalDao())
            {
                hospital.LastUpdateDate = DateTime.Now;
                hospital.LastUpdateUser = new Guid(RoleModelContext.Current.User.Id);

                int afterRow = dao.Update(hospital);
                result = true;
            }
            return result;
        }

        private bool Insert(Hospital hospital)
        {
            bool result = false;
            using (HospitalDao dao = new HospitalDao())
            {
                hospital.LastUpdateDate = DateTime.Now;
                hospital.LastUpdateUser = new Guid(RoleModelContext.Current.User.Id);

                hospital.HosCreatedDate = DateTime.Now;
                hospital.HosCreatedBy = new Guid(RoleModelContext.Current.User.Id);

                dao.Insert(hospital);
                result = true;
            }
            return result;
        }

        #endregion
    }
}
