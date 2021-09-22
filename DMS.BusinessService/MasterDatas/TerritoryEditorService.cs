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
    public class TerritoryEditorService : ABaseQueryService
    {
        #region Ajax Method

        public TerritoryEditorVO Init(TerritoryEditorVO model)
        {
            try
            {
                IRoleModelContext context = RoleModelContext.Current;
                model.IsDealer = IsDealer;

                               
                ITerritorys bll = new Territorys();
                TerritoryEx ter;

                if (!string.IsNullOrEmpty(model.IptTerId))
                {
                    ter = bll.GetTerritoryEx(new Guid(model.IptTerId));
                }
                else
                {
                    model.IptTerId = Guid.NewGuid().ToSafeString();
                    ter = null;
                }

                #region 获取下拉框的值
                IDictionary<string, string> dicts = new Dictionary<string, string>()
                {
                     {"Province", "省" },
                     {"City", "地区" },
                     {"County", "区/县" }
                };
                model.LstTerType = JsonHelper.DataTableToArrayList(dicts.ToArray().ToDataSet().Tables[0]);
                IList<Territory> provinces = bll.GetProvinces();
                model.LstProvince = JsonHelper.DataTableToArrayList(provinces.ToDataSet().Tables[0]);
                if (ter!=null && ter.ProvinceId.HasValue)
                {
                    IList<Territory> citys = bll.GetTerritorysByParent(ter.ProvinceId.Value);
                    model.LstCity = JsonHelper.DataTableToArrayList(citys.ToDataSet().Tables[0]);
                }
                #endregion



                model.IptTerType = new KeyValue();
                model.IptProvince = new KeyValue();
                model.IptCity = new KeyValue();

                if (ter != null)//编辑
                {
                    model.IptTerName = ter.Ter_Description;
                    model.IptTerCode = ter.Ter_Code;
                    model.IptTerType.Key = ter.Ter_Type;
                    model.IptProvince.Key = ter.ProvinceId.ToSafeString();
                    model.IptCity.Key = ter.CityId.ToSafeString();
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

        public TerritoryEditorVO ProvinceChange(TerritoryEditorVO model)
        {
            try
            {
                if (!string.IsNullOrEmpty(model.IptProvince.Key))
                {
                    ITerritorys bll = new Territorys();

                    IList<Territory> cities = bll.GetTerritorysByParent(new Guid(model.IptProvince.Key.ToSafeString()));

                    model.LstCity = JsonHelper.DataTableToArrayList(cities.ToDataSet().Tables[0]);
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

        public TerritoryEditorVO RegionChange(TerritoryEditorVO model)
        {
            try
            {
                //if (!string.IsNullOrEmpty(model.IptHPLRegion.Key))
                //{
                //    ITerritorys bll = new Territorys();

                //    IList<Territory> town = bll.GetTerritorysByParent(new Guid(model.IptHPLRegion.Key.ToSafeString()));

                //    model.LstHPLTown = JsonHelper.DataTableToArrayList(town.ToDataSet().Tables[0]);
                //}
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }

            return model;
        }

        public TerritoryEditorVO SaveChanges(TerritoryEditorVO model)
        {
            try
            {
                //检查数据是否合规
                TerritoryDao dao = new TerritoryDao();
                using (TransactionScope trans = new TransactionScope())
                {
                    Hashtable param = new Hashtable();
                    if (model.IptTerType.Key == "Province")
                    {
                        param.Add("ProvinceName", model.IptTerName);
                    }
                    else if (model.IptTerType.Key == "City")
                    {
                        param.Add("ProvinceName", model.IptProvince.Value);
                        param.Add("CityName", model.IptTerName);
                    }
                    else if (model.IptTerType.Key == "County")
                    {
                        param.Add("ProvinceName", model.IptProvince.Value);
                        param.Add("CityName", model.IptCity.Value);
                        param.Add("CountName", model.IptTerName);
                    }

                    
                 

                    //if (dao.SelectNotDeleteHospitalByCode(model.IptHPLCode, model.IptHosID.ToSafeGuid()).Count > 0)
                    //{
                    //    model.IsSuccess = false;
                    //    model.ExecuteMessage.Add("区域编号:" + model.IptHPLCode + "重复。");
                    //    return model;
                    //}


                    TerritoryEx ter = new TerritoryEx();
                    ter.Ter_Id = new Guid(model.IptTerId);
                    ter.Ter_Description = model.IptTerName;
                    ter.Ter_Type = model.IptTerType.Key;
                    ter.Ter_Code = model.IptTerCode;
                    if (ter.Ter_Type == "City")
                    {
                        ter.Ter_ParentId = new Guid(model.IptProvince.Key);
                    }
                    else if (ter.Ter_Type == "County")
                    {
                        ter.Ter_ParentId = new Guid(model.IptCity.Key);
                    }
                    var r = dao.CheckTerritoryExist(ter);
                    if (r.Count() > 0)
                    {
                        model.IsSuccess = false;
                        model.ExecuteMessage.Add("区域名称重复:" + model.IptTerName);
                        return model;
                    }

                    if (model.ChangeType == "UpdateData")
                    {
                        model.IsSuccess = Update(ter);
                        model.ExecuteMessage.Add("修改成功！");
                    }
                    else if (model.ChangeType == "NewData")
                    {
                        model.IsSuccess = Insert(ter);
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

        private bool Update(TerritoryEx ter)
        {
            bool result = false;
            using (TerritoryDao dao = new TerritoryDao())
            {
                dao.Update(ter);
                result = true;
            }
            return result;
        }

        private bool Insert(TerritoryEx ter)
        {
            bool result = false;
            using (TerritoryDao dao = new TerritoryDao())
            {
                dao.Insert(ter);
                result = true;
            }
            return result;
        }

        #endregion
    }
}
