using System;
using System.Collections;
using DMS.Common.Common;
using DMS.Common;
using DMS.ViewModel.Inventory;
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

namespace DMS.BusinessService.Inventory
{
    public class WarehouseEditorService : ABaseQueryService
    {
        #region Ajax Method

        public WarehouseEditorVO Init(WarehouseEditorVO model)
        {
            try
            {
                IRoleModelContext context = RoleModelContext.Current;
                model.IsDealer = IsDealer;

                //非经销商用户不能编辑仓库

                if (RoleModelContext.Current.User.IdentityType != SR.Consts_System_Dealer_User)
                {
                    model.EnableHospitalBtn = false;
                    model.EnableSaveBtn = false;
                }
                else
                {
                    model.EnableHospitalBtn = true;
                    model.EnableSaveBtn = true;
                }
                
                //获取仓库信息

                Hashtable hashtable = new Hashtable();
                hashtable.Clear();
                IWarehouses business = new Warehouses();
                if (!string.IsNullOrEmpty(model.IptDmaID))
                {
                    hashtable.Add("DmaId", new Guid(model.IptDmaID));
                }
                else
                {
                    hashtable.Add("DmaId", RoleModelContext.Current.User.CorpId);
                    model.IptDmaID = RoleModelContext.Current.User.CorpId.ToSafeString();
                }
                if (!string.IsNullOrEmpty(model.IptID))
                {
                    hashtable.Add("Id", new Guid(model.IptID));
                }
                else
                {
                    model.IptID = Guid.NewGuid().ToSafeString();
                    hashtable.Add("Id", model.IptID);
                }

                Warehouse warehouse;
                warehouse = business.GetWarehousesByHashtable(hashtable).FirstOrDefault();
                if (warehouse != null)//编辑
                {
                    model.IptWHName = warehouse.Name;
                    KeyValue kv = new KeyValue();
                    kv.Key = warehouse.Type;
                    model.IptWHType = kv;
                    model.IptWHCode = warehouse.Code;
                    model.IptWHActiveFlag = warehouse.ActiveFlag.HasValue ? warehouse.ActiveFlag.Value : false;
                    //获得医院名称
                    Hospitals Hos = new Hospitals();
                    Hospital ho = Hos.GetObject(warehouse.HospitalHosId.HasValue ? warehouse.HospitalHosId.Value : Guid.Empty);
                    if (ho != null)
                    {
                        model.IptWHHospName = ho.HosHospitalName;
                        model.IptHosp = warehouse.HospitalHosId.ToSafeString();
                    }
                    model.IptWHProvince = warehouse.Province;
                    model.IptWHCity = warehouse.City;
                    model.IptWHTown = warehouse.Town;
                    model.IptWHAddress = warehouse.Address;
                    model.IptPostalCOD = warehouse.PostalCode;
                    model.IptWHPhone = warehouse.Phone;
                    model.IptWHFax = warehouse.Fax;
                    model.IptConID = warehouse.ConId.ToSafeString();
                    model.IptHoldWarehouse = warehouse.HoldWarehouse.ToSafeString();
                    model.ChangeType = "UpdateData";
                }
                else//新增
                {
                    KeyValue kv = new KeyValue();
                    kv.Key = "Normal";
                    kv.Value = "普通仓库";
                    model.IptWHType = kv;
                    model.IptWHActiveFlag = true;
                    model.ChangeType = "NewData";
                }

                //获取Type的值
                Hashtable ht = new Hashtable();
                IList<Warehouse> ws;

                ht.Add("DmaId", RoleModelContext.Current.User.CorpId);
                ht.Add("Type", "DefaultWH");
                ws = business.GetWarehousesByHashtable(ht);
                IDictionary<string, string> dictsCompanyType = DictionaryHelper.GetDictionary(SR.Consts_WarehouseType);
                //去掉系统库（SystemHold）项,因为用户不可编辑系统库。

                var query = from t in dictsCompanyType where t.Key != WarehouseType.SystemHold.ToString() select t;

                query = from t in query where t.Key != WarehouseType.LP_Borrow.ToString() select t;
                query = from t in query where t.Key != WarehouseType.LP_Consignment.ToString() select t;
                query = from t in query where t.Key != WarehouseType.Frozen.ToString() select t;

                //if (RoleModelContext.Current.User.CorpType == DealerType.T2.ToString())
                //{
                query = from t in query where t.Key != WarehouseType.Borrow.ToString() select t;
                query = from t in query where t.Key != WarehouseType.Consignment.ToString() select t;
                //}

                if (ws.Count >= 1)
                {
                    query = from t in query where t.Key != WarehouseType.DefaultWH.ToString() select t;
                }
                List<KeyValue> lstType = new List<KeyValue>();
                foreach (KeyValuePair<string, string> value in query)
                {
                    KeyValue kv = new KeyValue();
                    kv.Key = value.Key;
                    kv.Value = value.Value;
                    lstType.Add(kv);
                }
                model.LstWHType = lstType;
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public WarehouseEditorVO SaveChanges(WarehouseEditorVO model)
        {
            try
            {
                //检查数据是否合规
                if (IsDealer)
                {
                    //Warehouses bll = new Warehouses();
                    Hashtable ht = new Hashtable();
                    IList<Warehouse> query;
                    IWarehouses business = new Warehouses();

                    ht.Add("DmaId", model.IptDmaID);
                    ht.Add("Type", "DefaultWH");
                    query = business.GetWarehousesByHashtable(ht);
                    if (query.Count >= 1 && model.IptWHType.Key.ToLower()== "defaultwh")
                    {
                        model.IsSuccess = false;
                        model.ExecuteMessage.Add("设置了多个缺省仓库，缺省仓库只能有一个！(注意：显示的查询结果中可能没有缺省仓库)");
                        return model;
                    }
                }

                IWarehouses wh = new Warehouses();
                Hashtable table = new Hashtable();
                table.Add("Name", model.IptWHName);
                table.Add("DmaId", model.IptDmaID);
                Warehouse whCheck = wh.GetWarehouse(new Guid(model.IptID));
                
                if (wh.duplicateWarehouseName(table))
                {
                    if(whCheck == null || (whCheck != null && whCheck.Name != model.IptWHName))
                    {
                        model.IsSuccess = false;
                        model.ExecuteMessage.Add("仓库名称重复！");
                        return model;
                    }
                }
                
                //如果仓库的状态是有效，则保存修改。否则再去检查库存，有库存就不能将仓库状态设成无效。

                if (model.IptWHActiveFlag == false)
                {
                    if (!wh.emptyWarehouse(new Guid(model.IptID)))
                    {
                        model.IsSuccess = false;
                        model.ExecuteMessage.Add("仓库有库存，不能将仓库状态设为无效！");
                        return model;
                    }
                }

                //仓库实体类
                Warehouse warehouse = new Warehouse();
                warehouse.Id = new Guid(model.IptID);
                warehouse.DmaId = new Guid(model.IptDmaID);
                if (!string.IsNullOrEmpty(model.IptWHCode))
                    warehouse.Code = model.IptWHCode;
                else
                {
                    AutoNumberBLL autoNumberBll = new AutoNumberBLL();
                    string code = autoNumberBll.GetNextAutoNumberForCode(CodeAutoNumberSetting.Next_WarehouseNbr);
                    warehouse.Code = code;
                }
                warehouse.Name = model.IptWHName;
                warehouse.Type = model.IptWHType.Key;
                warehouse.ActiveFlag = model.IptWHActiveFlag;
                if (!string.IsNullOrEmpty(model.IptHosp))
                    warehouse.HospitalHosId = new Guid(model.IptHosp);
                warehouse.Province = model.IptWHProvince;
                warehouse.City = model.IptWHCity;
                warehouse.Town = model.IptWHTown;
                warehouse.Address = model.IptWHAddress;
                warehouse.PostalCode = model.IptPostalCOD;
                warehouse.Phone = model.IptWHPhone;
                warehouse.Fax = model.IptWHFax;
                if (!string.IsNullOrEmpty(model.IptConID))
                    warehouse.ConId = new Guid(model.IptConID);
                warehouse.HoldWarehouse = model.IptHoldWarehouse.ToSafeBool();

                if (model.ChangeType == "UpdateData")
                {
                    model.IsSuccess = Update(warehouse);
                    model.ExecuteMessage.Add("修改成功！");
                }
                else if(model.ChangeType== "NewData")
                {
                    model.IsSuccess = Insert(warehouse);
                    model.ExecuteMessage.Add("新增成功！");
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

        private bool Update(Warehouse warehouse)
        {
            bool result = false;
            using (WarehouseDao dao = new WarehouseDao())
            {
                warehouse.LastUpdateDate = DateTime.Now;
                warehouse.LastUpdateUser = new Guid(RoleModelContext.Current.User.Id);

                int afterRow = dao.Update(warehouse);
                result = true;
            }
            return result;
        }

        private bool Insert(Warehouse warehouse)
        {
            bool result = false;
            AutoNumberBLL autoNumberBll = new AutoNumberBLL();
            string code = autoNumberBll.GetNextAutoNumberForCode(CodeAutoNumberSetting.Next_WarehouseNbr);
            using (WarehouseDao dao = new WarehouseDao())
            {
                warehouse.Code = String.IsNullOrEmpty(warehouse.Code) ? code : warehouse.Code;
                warehouse.LastUpdateDate = DateTime.Now;
                warehouse.LastUpdateUser = new Guid(RoleModelContext.Current.User.Id);

                warehouse.CreateDate = warehouse.LastUpdateDate;
                warehouse.CreateUser = warehouse.LastUpdateUser;

                //dao.InsertWhm(warehouse);
                dao.Insert(warehouse);
                result = true;
            }
            return result;
        }

        #endregion
    }
}
