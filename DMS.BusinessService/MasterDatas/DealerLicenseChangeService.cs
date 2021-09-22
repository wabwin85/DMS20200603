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
using DMS.BusinessService.Util.DealerFilter;
using DMS.BusinessService.Util.DealerFilter.Impl;
using DMS.ViewModel.Common;
using DMS.Model;
using DMS.Model.Data;
using DMS.DataAccess.DataInterface;
using DMS.Business;

namespace DMS.BusinessService.MasterDatas
{
    public class DealerLicenseChangeService : ABaseQueryService, IDealerFilterFac
    {
        #region Ajax Method
        public ADealerFilter CreateDealerFilter()
        {
            return new AllDealerFilter();
        }
        public DealerLicenseChangeVO Init(DealerLicenseChangeVO model)
        {
            try
            {
                //初始查询部分
                IRoleModelContext context = RoleModelContext.Current;
                model.IsDealer = IsDealer;

                DealerMasterDao dealerMasterDao = new DealerMasterDao();
                model.LstLCDealerName = dealerMasterDao.SelectFilterListAll("");
                
                if (!string.IsNullOrEmpty(model.hidDealerId.ToSafeString()))
                {
                    KeyValue kvDealer = new KeyValue();
                    DealerMaster dealer = dealerMasterDao.GetObject(model.hidDealerId.ToSafeGuid());
                    kvDealer.Key = model.hidDealerId.ToSafeString();
                    kvDealer.Value = dealer.ChineseShortName;
                    model.QryLCDealerName = kvDealer;
                    model.LstLCDealerName = dealerMasterDao.SelectFilterListAll(dealer.ChineseShortName);
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

        public DealerLicenseChangeVO InitLCDetailWin(DealerLicenseChangeVO model)
        {
            try
            {
                //初始窗体部分
                DealerMasterLicenseDao dao = new DealerMasterLicenseDao();
                Hashtable param = new Hashtable();
                if (!string.IsNullOrEmpty(model.QryLCDealerName.Key))
                {
                    param.Add("DmaId", model.QryLCDealerName.Key.ToSafeString());
                }
                string DMAId = model.QryLCDealerName.Key.ToSafeString();

                model.LstLCSales = JsonHelper.DataTableToArrayList(dao.GetSalesRepByParam(param).Tables[0]);
                if (string.IsNullOrEmpty(model.WinDMLID.ToSafeString()))
                {
                    DataTable licenseTable = dao.GetDealerMasterLicenseToTable(model.QryLCDealerName.Key.ToSafeString()).Tables[0];
                    if (licenseTable.Rows.Count > 0)
                    {
                        DataRow licenseRow = licenseTable.Rows[0];
                        //给当前的控件赋值
                        model.WinLCLicenseNo = licenseRow["CurLicenseNo"] == null ? "" : licenseRow["CurLicenseNo"].ToString();

                        model.WinLCHeadOfCorp = licenseRow["CurRespPerson"] == null ? "" : licenseRow["CurRespPerson"].ToString();

                        model.WinLCLegalRep = licenseRow["CurLegalPerson"] == null ? "" : licenseRow["CurLegalPerson"].ToString();

                        if (licenseRow["CurLicenseValidFrom"] != null && !String.IsNullOrEmpty(licenseRow["CurLicenseValidFrom"].ToString()))
                        {
                            model.WinLCLicenseStart = Convert.ToDateTime(licenseRow["CurLicenseValidFrom"]);//.ToShortDateString();
                        }

                        if (licenseRow["CurLicenseValidTo"] != null && !String.IsNullOrEmpty(licenseRow["CurLicenseValidTo"].ToString()))
                        {
                            model.WinLCLicenseEnd = Convert.ToDateTime(licenseRow["CurLicenseValidTo"]);//.ToShortDateString();
                        }

                        model.WinLCRecordNo = licenseRow["CurFilingNo"] == null ? "" : licenseRow["CurFilingNo"].ToString();

                        if (licenseRow["CurFilingValidFrom"] != null && !String.IsNullOrEmpty(licenseRow["CurFilingValidFrom"].ToString()))
                        {
                            model.WinLCRecordStart = Convert.ToDateTime(licenseRow["CurFilingValidFrom"]);//.ToShortDateString();
                        }
                        if (licenseRow["CurFilingValidTo"] != null && !String.IsNullOrEmpty(licenseRow["CurFilingValidTo"].ToString()))
                        {
                            model.WinLCRecordEnd = Convert.ToDateTime(licenseRow["CurFilingValidTo"]);//.ToShortDateString();
                        }

                        if (licenseRow["SecondClass2012"] != null)
                        {
                            Hashtable obj = new Hashtable();
                            obj.Add("strCatId", licenseRow["SecondClass2012"].ToString());
                            obj.Add("catType", LicenseCatagoryLevel.二类.ToString());
                            obj.Add("versionNumber", "2002版");
                            using (DealerMasterDao daoProduct = new DealerMasterDao())
                            {
                                model.RstLCProductList202 = JsonHelper.DataTableToArrayList(daoProduct.GetDealerLicenseCatagoryByCatId(obj).Tables[0]);
                            }
                        }

                        if (licenseRow["SecondClass2017"] != null)
                        {
                            Hashtable obj = new Hashtable();
                            obj.Add("strCatId", licenseRow["SecondClass2017"].ToString());
                            obj.Add("catType", LicenseCatagoryLevel.二类.ToString());
                            obj.Add("versionNumber", "2017版");
                            using (DealerMasterDao daoProduct = new DealerMasterDao())
                            {
                                model.RstLCProductList217 = JsonHelper.DataTableToArrayList(daoProduct.GetDealerLicenseCatagoryByCatId(obj).Tables[0]);
                            }
                        }

                        if (licenseRow["ThirdClass2012"] != null)
                        {
                            Hashtable obj = new Hashtable();
                            obj.Add("strCatId", licenseRow["ThirdClass2012"].ToString());
                            obj.Add("catType", LicenseCatagoryLevel.三类.ToString());
                            obj.Add("versionNumber", "2002版");
                            using (DealerMasterDao daoProduct = new DealerMasterDao())
                            {
                                model.RstLCProductList302 = JsonHelper.DataTableToArrayList(daoProduct.GetDealerLicenseCatagoryByCatId(obj).Tables[0]);
                            }
                        }

                        if (licenseRow["ThirdClass2017"] != null)
                        {
                            Hashtable obj = new Hashtable();
                            obj.Add("strCatId", licenseRow["ThirdClass2017"].ToString());
                            obj.Add("catType", LicenseCatagoryLevel.三类.ToString());
                            obj.Add("versionNumber", "2017版");
                            using (DealerMasterDao daoProduct = new DealerMasterDao())
                            {
                                model.RstLCProductList317 = JsonHelper.DataTableToArrayList(daoProduct.GetDealerLicenseCatagoryByCatId(obj).Tables[0]);
                            }
                        }
                        //if (!String.IsNullOrEmpty(dml.SalesRep))
                        //{
                        //    this.winHidSalesRep.Text = dml.SalesRep;
                        //}
                    }
                    else
                    {
                        model = new DealerLicenseChangeVO();
                        model.LstLCSales = JsonHelper.DataTableToArrayList(dao.GetSalesRepByParam(param).Tables[0]);
                        //model.WinLCHeadOfCorp = "";
                        //model.WinLCLegalRep = "";
                        //model.WinLCLicenseNo = "";
                        //model.WinLCRecordNo = "";
                        //model.WinLCLicenseStart = null;
                        //model.WinLCLicenseEnd = null;
                        //model.WinLCRecordStart = null;
                        //model.WinLCRecordEnd = null;
                    }

                    if (dao.GetShiptoAddress(model.WinDMLID.ToSafeGuid()).Tables[0].Rows.Count > 0)
                        model.WinDefaultAddress = dao.GetShiptoAddress(model.WinDMLID.ToSafeGuid()).Tables[0].Rows[0]["ST_Address"].ToString();
                    else
                        model.WinDefaultAddress = "N";
                    //新建单据
                    model.WinDMLID = Guid.NewGuid().ToSafeString();
                    model.hidApplyStatus = "new";
                    dao.insertShipToAddress(model.WinDMLID.ToSafeGuid(), DMAId.ToSafeGuid());
                }
                else
                {
                    DataTable dml = dao.GetCFDAProcess(model.WinDMLID.ToSafeGuid().ToSafeString()).Tables[0];
                    string DMLID = model.WinDMLID.ToSafeString();
                    if (dml != null)
                    {
                        //给当前的控件赋值
                        model.hidApplyStatus = dml.Rows[0]["DML_NewApplyStatus"].ToString();
                        model.WinLCLicenseNo = dml.Rows[0]["DML_NewLicenseNo"].ToString();
                        model.WinLCHeadOfCorp = dml.Rows[0]["DML_NewCurRespPerson"].ToString();
                        model.WinLCLegalRep = dml.Rows[0]["DML_NewCurLegalPerson"].ToString();
                        if (dml.Rows[0]["DML_NewLicenseValidFrom"] != null && !String.IsNullOrEmpty(dml.Rows[0]["DML_NewLicenseValidFrom"].ToString()))
                        {
                            model.WinLCLicenseStart = Convert.ToDateTime(dml.Rows[0]["DML_NewLicenseValidFrom"]);//.ToShortDateString();
                        }
                        if (dml.Rows[0]["DML_NewLicenseValidTo"] != null && !String.IsNullOrEmpty(dml.Rows[0]["DML_NewLicenseValidTo"].ToString()))
                        {
                            model.WinLCLicenseEnd = Convert.ToDateTime(dml.Rows[0]["DML_NewLicenseValidTo"]);//.ToShortDateString();
                        }
                        model.WinLCRecordNo = dml.Rows[0]["DML_NewFilingNo"].ToString();
                        if (dml.Rows[0]["DML_NewFilingValidFrom"] != null && !String.IsNullOrEmpty(dml.Rows[0]["DML_NewFilingValidFrom"].ToString()))
                        {
                            model.WinLCRecordStart = Convert.ToDateTime(dml.Rows[0]["DML_NewFilingValidFrom"]);//.ToShortDateString();
                        }
                        if (dml.Rows[0]["DML_NewLicenseValidTo"] != null && !String.IsNullOrEmpty(dml.Rows[0]["DML_NewLicenseValidTo"].ToString()))
                        {
                            model.WinLCRecordEnd = Convert.ToDateTime(dml.Rows[0]["DML_NewLicenseValidTo"]);//.ToShortDateString();
                        }
                        if (dml.Rows[0]["SecondClass2012"] != null)
                        {
                            Hashtable obj = new Hashtable();
                            obj.Add("strCatId", dml.Rows[0]["SecondClass2012"].ToString());
                            obj.Add("catType", LicenseCatagoryLevel.二类.ToString());
                            obj.Add("versionNumber", "2002版");
                            using (DealerMasterDao daoProduct = new DealerMasterDao())
                            {
                                model.RstLCProductList202 = JsonHelper.DataTableToArrayList(daoProduct.GetDealerLicenseCatagoryByCatId(obj).Tables[0]);
                            }
                        }

                        if (dml.Rows[0]["SecondClass2017"] != null)
                        {
                            Hashtable obj = new Hashtable();
                            obj.Add("strCatId", dml.Rows[0]["SecondClass2017"].ToString());
                            obj.Add("catType", LicenseCatagoryLevel.二类.ToString());
                            obj.Add("versionNumber", "2017版");
                            using (DealerMasterDao daoProduct = new DealerMasterDao())
                            {
                                model.RstLCProductList217 = JsonHelper.DataTableToArrayList(daoProduct.GetDealerLicenseCatagoryByCatId(obj).Tables[0]);
                            }
                        }

                        if (dml.Rows[0]["ThirdClass2012"] != null)
                        {
                            Hashtable obj = new Hashtable();
                            obj.Add("strCatId", dml.Rows[0]["ThirdClass2012"].ToString());
                            obj.Add("catType", LicenseCatagoryLevel.三类.ToString());
                            obj.Add("versionNumber", "2002版");
                            using (DealerMasterDao daoProduct = new DealerMasterDao())
                            {
                                model.RstLCProductList302 = JsonHelper.DataTableToArrayList(daoProduct.GetDealerLicenseCatagoryByCatId(obj).Tables[0]);
                            }
                        }

                        if (dml.Rows[0]["ThirdClass2017"] != null)
                        {
                            Hashtable obj = new Hashtable();
                            obj.Add("strCatId", dml.Rows[0]["ThirdClass2017"].ToString());
                            obj.Add("catType", LicenseCatagoryLevel.三类.ToString());
                            obj.Add("versionNumber", "2017版");
                            using (DealerMasterDao daoProduct = new DealerMasterDao())
                            {
                                model.RstLCProductList317 = JsonHelper.DataTableToArrayList(daoProduct.GetDealerLicenseCatagoryByCatId(obj).Tables[0]);
                            }
                        }

                        if (dml.Rows[0]["DML_SalesRep"] != null)
                        {
                            KeyValue kvSales = new KeyValue();
                            kvSales.Key = dml.Rows[0]["DML_SalesRep"].ToString();
                            model.WinLCSales = kvSales;
                        }
                        if (dml.Rows[0]["DML_NewApplyNO"] != null)
                        {
                            model.WinHidAppNo = dml.Rows[0]["DML_NewApplyNO"].ToString();
                        }
                    }
                    else
                    {
                        model = new DealerLicenseChangeVO();
                        model.hidApplyStatus = "";
                        model.LstLCSales = JsonHelper.DataTableToArrayList(dao.GetSalesRepByParam(param).Tables[0]);
                    }

                    if (dao.GetShiptoAddress(model.WinDMLID.ToSafeGuid()).Tables[0].Rows.Count > 0)
                        model.WinDefaultAddress = dao.GetShiptoAddress(model.WinDMLID.ToSafeGuid()).Tables[0].Rows[0]["ST_Address"].ToString();
                    else
                        model.WinDefaultAddress = "N";
                    model.WinDMLID = DMLID;

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

        public string QueryMainInfo(DealerLicenseChangeVO model)
        {
            try
            {
                DealerMasterLicenseDao dao = new DealerMasterLicenseDao();
                int totalCount = 0;

                Hashtable hs = new Hashtable();
                if (!string.IsNullOrEmpty(model.QryLCDealerName.Key))
                {
                    hs.Add("DmaId", model.QryLCDealerName.Key.ToSafeString());
                }
                if (!string.IsNullOrEmpty(model.QryLCFlowNo.ToSafeString()))
                {
                    hs.Add("NewApplyNO", model.QryLCFlowNo.ToSafeString());
                }
                if (!string.IsNullOrEmpty(model.QryLCApplyStatus.Key.ToSafeString()))
                {

                    hs.Add("NewApplyStatus", model.QryLCApplyStatus.Key.ToSafeString());
                }

                int start = (model.Page - 1) * model.PageSize;
                model.RstLCResultList = JsonHelper.DataTableToArrayList(dao.GetCFDAHead(hs, start, model.PageSize, out totalCount).Tables[0]);

                model.DataCount = totalCount;
                model.IsSuccess = true;
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }

            var data = new { data = model.RstLCResultList, total = model.DataCount };
            var result = new { success = model.IsSuccess, data = data };
            return JsonConvert.SerializeObject(result);
        }

        public string QueryAddressInfo(DealerLicenseChangeVO model)
        {
            try
            {
                using (DealerMasterLicenseDao dao = new DealerMasterLicenseDao())
                {
                    int totalCount = 0;
                    int start = (model.Page - 1) * model.PageSize;
                    model.RstLCAddressList = JsonHelper.DataTableToArrayList(dao.GetAddress(model.WinDMLID.ToSafeGuid(), start, model.PageSize, out totalCount).Tables[0]);

                    model.DataCount = totalCount;
                    model.IsSuccess = true;
                }
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }

            var data = new { data = model.RstLCAddressList, total = model.DataCount };
            var result = new { success = model.IsSuccess, data = data };
            return JsonConvert.SerializeObject(result);
        }

        public string QueryAttachInfo(DealerLicenseChangeVO model)
        {
            try
            {
                using (AttachmentDao dao = new AttachmentDao())
                {
                    int totalCount = 0;
                    Hashtable table = new Hashtable();
                    table.Add("MainId", model.WinDMLID.ToSafeGuid());
                    table.Add("Type", AttachmentType.DealerLicense.ToString());

                    int start = (model.Page - 1) * model.PageSize;
                    model.RstLCAttachList = JsonHelper.DataTableToArrayList(dao.GetAttachmentByMainId(table, start, model.PageSize, out totalCount).Tables[0]);

                    model.DataCount = totalCount;
                    model.IsSuccess = true;
                }
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }

            var data = new { data = model.RstLCAttachList, total = model.DataCount };
            var result = new { success = model.IsSuccess, data = data };
            return JsonConvert.SerializeObject(result);
        }

        public DealerLicenseChangeVO SearchLCProduct(DealerLicenseChangeVO model)
        {
            try
            {
                using (DealerMasterDao dao = new DealerMasterDao())
                {
                    Hashtable param = new Hashtable();
                    string catType = string.Empty;
                    string verNo = string.Empty;
                    if (model.WinProductCat == "202")//二类02版
                    {
                        catType = "二类";
                        verNo = "2002版";
                    }
                    else if (model.WinProductCat == "217")//二类17版
                    {
                        catType = "二类";
                        verNo = "2017版";
                    }
                    else if (model.WinProductCat == "302")//三类02版
                    {
                        catType = "三类";
                        verNo = "2002版";
                    }
                    else if (model.WinProductCat == "317")//三类17版
                    {
                        catType = "三类";
                        verNo = "2017版";
                    }
                    
                    if (!string.IsNullOrEmpty(model.WinProductCode))
                    {
                        param.Add("catId", model.WinProductCode.ToSafeString());
                    }
                    if (!string.IsNullOrEmpty(model.WinProductName))
                    {
                        param.Add("catName", model.WinProductName.ToSafeString());
                    }
                    //if (!string.IsNullOrEmpty(model.WinCatType))
                    //{
                        param.Add("catType", catType);
                    //}
                    //if (!string.IsNullOrEmpty(model.WinVerNo))
                    //{
                        param.Add("versionNumber", verNo);
                    //}
                    model.RstLCWinProductList = JsonHelper.DataTableToArrayList(dao.GetLicenseCatagoryByCatType(param).Tables[0]);
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

        public DealerLicenseChangeVO DeleteAddress(DealerLicenseChangeVO model)
        {
            try
            {
                using (DealerMasterLicenseDao dao = new DealerMasterLicenseDao())
                { 
                    if (model.WinAddrCode == "" || model.WinAddrCode == null)
                    {
                        dao.DeleteSAPWarehouseAddress_temp(model.WinAddrID);
                    }
                    else
                    {
                        dao.updateaddress(model.WinAddrID);
                    }
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

        public DealerLicenseChangeVO UpdateAddress(DealerLicenseChangeVO model)
        {
            try
            {
                using (DealerMasterLicenseDao dao = new DealerMasterLicenseDao())
                { 
                    if (model.WinAddrIsSend == "是" && model.WinAddrID != "")
                    {
                        dao.updateshiptoaddressbtn(model.WinAddrID, "0");
                    }
                    if (model.WinAddrIsSend == "否" && model.WinAddrID != "")
                    {
                        dao.updateshiptoaddress(model.QryLCDealerName.Key.ToSafeGuid());
                        dao.updateshiptoaddressbtn(model.WinAddrID, "1");
                    }
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

        public DealerLicenseChangeVO DeleteAttach(DealerLicenseChangeVO model)
        {
            try
            {
                using (AttachmentDao dao = new AttachmentDao())
                {
                    dao.Delete(model.WinAttachId.ToSafeGuid());
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

        public DealerLicenseChangeVO SaveShipToAddress(DealerLicenseChangeVO model)
        {
            try
            {
                using (DealerMasterLicenseDao dao = new DealerMasterLicenseDao())
                {
                    if (model.WinDefaultAddress != "N" && model.IsDefaultAddr == "是")
                    {
                        dao.updateshiptoaddress(model.QryLCDealerName.Key.ToSafeGuid());
                    }
                    Hashtable hs = new Hashtable();
                    hs.Add("id", Guid.NewGuid());
                    hs.Add("dealerid", model.QryLCDealerName.Key.ToSafeString());
                    hs.Add("Type", model.WinLCAddressType.Key.ToSafeString());
                    hs.Add("Address", model.WinLCAddressInfo.ToSafeString());
                    hs.Add("ActiveFlag", "1");
                    hs.Add("MID", model.WinDMLID.ToSafeGuid().ToSafeString());
                    if (model.IsDefaultAddr == "是")
                    {
                        hs.Add("IsSendAddress", "1");
                    }
                    else
                        hs.Add("IsSendAddress", "0");
                    hs.Add("CreateDate", DateTime.Now);
                    dao.addaddress(hs);
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

        public DealerLicenseChangeVO SubmitToFlow(DealerLicenseChangeVO model)
        {
            try
            {
                using (DealerMasterLicenseDao dao = new DealerMasterLicenseDao())
                {
                    DataSet ds = dao.SelectSAPWarehouseAddress_temp(model.WinDMLID.ToSafeGuid());
                    if (ds.Tables[0].Rows.Count > 1)
                    {

                        if (model.hidApplyStatus.ToSafeString() == "new")
                        {
                            DataSet dt = dao.GetCFDAHeadAll(model.QryLCDealerName.Key.ToSafeString(), "审批中");
                            if (dt.Tables[0].Rows.Count > 0)
                            {
                                model.IsSuccess = false;
                                model.ExecuteMessage.Add("该经销商拥有未完成审批的申请！");
                            }
                            else
                            {
                                insert("审批中", model, "submit");
                            }
                        }
                        else if (model.hidApplyStatus.ToSafeString() == "草稿" || model.hidApplyStatus.ToSafeString() == "审批拒绝")
                        {
                            DataSet dt = dao.GetCFDAHeadAll(model.QryLCDealerName.Key.ToSafeString(), "审批中");
                            if (dt.Tables[0].Rows.Count > 0)
                            {
                                model.IsSuccess = false;
                                model.ExecuteMessage.Add("该经销商拥有未完成审批的申请！");
                            }
                            else
                            {
                                update("审批中", model, "submit");
                            }
                        }
                    }
                    else
                    {
                        model.IsSuccess = false;
                        model.ExecuteMessage.Add("请维护仓库地址和经营地址！");
                    }
                }
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            model.RstLCProductList202 = null;
            model.RstLCProductList217 = null;
            model.RstLCProductList302 = null;
            model.RstLCProductList317 = null;
            return model;
        }

        public DealerLicenseChangeVO SaveDraft(DealerLicenseChangeVO model)
        {
            try
            {
                using (DealerMasterLicenseDao dao = new DealerMasterLicenseDao())
                {
                    DataSet ds = dao.SelectSAPWarehouseAddress_temp(model.WinDMLID.ToSafeGuid());

                    if (ds.Tables[0].Rows.Count > 1)
                    {
                        if (model.hidApplyStatus.ToSafeString() == "new")
                        {
                            insert("草稿", model, "save");
                        }
                        else if (model.hidApplyStatus.ToSafeString() == "草稿" || model.hidApplyStatus.ToSafeString() == "审批拒绝")
                        {
                            update("草稿", model, "save");
                        }
                    }
                    else
                    {
                        model.IsSuccess = false;
                        model.ExecuteMessage.Add("仓库地址和经营地址必须维护！");
                    }
                }
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            model.RstLCProductList202 = null;
            model.RstLCProductList217 = null;
            model.RstLCProductList302 = null;
            model.RstLCProductList317 = null;
            return model;
        }

        public DealerLicenseChangeVO DeleteDraft(DealerLicenseChangeVO model)
        {
            try
            {
                using (DealerMasterLicenseDao dao = new DealerMasterLicenseDao())
                {
                    dao.DeleteAttachment(model.WinDMLID.ToSafeGuid());
                    dao.DeleteShipToAddress(model.WinDMLID.ToSafeGuid());
                    dao.DeleteDealerMasterLicenseModify(model.WinDMLID.ToSafeGuid());
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

        public void update(string ApplyStatus, DealerLicenseChangeVO model, string opType)
        {
            string strCatIdSecd = string.Empty;
            string StrCatIdThrd = string.Empty;
            if (model.RstLCProductList202 != null)
            {
                //foreach (Newtonsoft.Json.Linq.JObject item in model.RstLCProductList202)
                //{
                for (int i = 0; i < model.RstLCProductList202.Count; i++)
                {
                    Newtonsoft.Json.Linq.JObject item = Newtonsoft.Json.Linq.JObject.Parse(model.RstLCProductList202[i].ToString());
                    strCatIdSecd += item["CatagoryID"].ToString().Replace("\"", "") + ",";
                }
                model.RstLCProductList202 = null;
            }
            if (model.RstLCProductList217 != null)
            {
                //foreach (Newtonsoft.Json.Linq.JObject item in model.RstLCProductList217)
                //{
                for (int i = 0; i < model.RstLCProductList217.Count; i++)
                {
                    Newtonsoft.Json.Linq.JObject item = Newtonsoft.Json.Linq.JObject.Parse(model.RstLCProductList217[i].ToString());
                    strCatIdSecd += item["CatagoryID"].ToString().Replace("\"", "") + ",";
                }
                model.RstLCProductList217 = null;
            }
            if (model.RstLCProductList302 != null)
            {
                //foreach (Newtonsoft.Json.Linq.JObject item in model.RstLCProductList302)
                //{
                for (int i = 0; i < model.RstLCProductList302.Count; i++)
                {
                    Newtonsoft.Json.Linq.JObject item = Newtonsoft.Json.Linq.JObject.Parse(model.RstLCProductList302[i].ToString());
                    StrCatIdThrd += item["CatagoryID"].ToString().Replace("\"", "") + ",";
                }
                model.RstLCProductList302 = null;
            }
            if (model.RstLCProductList317 != null)
            {
                //foreach (Newtonsoft.Json.Linq.JObject item in model.RstLCProductList317)
                //{
                for (int i = 0; i < model.RstLCProductList317.Count; i++)
                {
                    Newtonsoft.Json.Linq.JObject item = Newtonsoft.Json.Linq.JObject.Parse(model.RstLCProductList317[i].ToString());
                    StrCatIdThrd += item["CatagoryID"].ToString().Replace("\"", "") + ",";
                }
                model.RstLCProductList317 = null;
            }

            DealerMasterLicenseDao dao = new DealerMasterLicenseDao();
            string appNo = dao.GetNextCFDANo("CFDA", "Next_CFDA");
            Hashtable hs = new Hashtable();
            hs.Add("DML_NewCurLegalPerson", model.WinLCLegalRep.ToSafeString());
            hs.Add("DML_NewCurRespPerson", model.WinLCHeadOfCorp.ToSafeString());
            hs.Add("DML_MID", model.WinDMLID.ToSafeGuid());
            hs.Add("DML_DMA_ID", model.QryLCDealerName.Key.ToSafeGuid());
            hs.Add("DML_NewApplyStatus", ApplyStatus);
            if (model.hidApplyStatus.ToSafeString() == "草稿" && opType == "submit")
            {
                hs.Add("DML_NewApplyNO", appNo);
            }
            else if (opType == "submit")
            {
                hs.Add("DML_NewApplyNO", model.WinHidAppNo.ToSafeString());
            }

            hs.Add("DML_NewLicenseNo", model.WinLCLicenseNo);
            if (model.WinLCLicenseStart != DateTime.MinValue)
            {
                hs.Add("DML_NewLicenseValidFrom", model.WinLCLicenseStart.ToString("yyyy-MM-dd"));
            }
            if (model.WinLCLicenseEnd != DateTime.MinValue)
            {
                hs.Add("DML_NewLicenseValidTo", model.WinLCLicenseEnd.ToString("yyyy-MM-dd"));
            }
            hs.Add("DML_NewSecondClassCatagory", strCatIdSecd);
            hs.Add("DML_NewFilingNo", model.WinLCRecordNo.ToSafeString());
            if (model.WinLCRecordStart != DateTime.MinValue)
            {
                hs.Add("DML_NewFilingValidFrom", model.WinLCRecordStart.ToString("yyyy-MM-dd"));
            }
            if (model.WinLCRecordEnd != DateTime.MinValue)
            {
                hs.Add("DML_NewFilingValidTo", model.WinLCRecordEnd.ToString("yyyy-MM-dd"));
            }
            hs.Add("DML_NewThirdClassCatagory", StrCatIdThrd);
            hs.Add("DML_NewApplyDate", DateTime.Now);
            hs.Add("DML_NewApplyUser", new Guid(RoleModelContext.Current.User.Id));
            hs.Add("DML_SalesRep", model.WinLCSales.Key.ToSafeString());
            dao.UpdateDealerMasterLicenseModify(hs);

            if (ApplyStatus.Equals("审批中"))
            {
                IDealerMasters dllDealer = new DealerMasters();
                dllDealer.SubmintCfdaMflow(model.WinDMLID.ToSafeString(), appNo, model.WinLCSales.Key.ToSafeString());
            }
        }

        public void insert(string ApplyStatus, DealerLicenseChangeVO model, string opType)
        {
            string strCatIdSecd = string.Empty;
            string StrCatIdThrd = string.Empty;
            if (model.RstLCProductList202 != null)
            {
                //foreach (Newtonsoft.Json.Linq.JObject item in model.RstLCProductList202)
                //{
                for (int i = 0; i < model.RstLCProductList202.Count; i++)
                {
                    Newtonsoft.Json.Linq.JObject item = Newtonsoft.Json.Linq.JObject.Parse(model.RstLCProductList202[i].ToString());
                    strCatIdSecd += item["CatagoryID"].ToString().Replace("\"", "") + ",";
                }
                model.RstLCProductList202 = null;
            }
            if (model.RstLCProductList217 != null)
            {
                //foreach (Newtonsoft.Json.Linq.JObject item in model.RstLCProductList217)
                //{
                for (int i = 0; i < model.RstLCProductList217.Count; i++)
                {
                    Newtonsoft.Json.Linq.JObject item = Newtonsoft.Json.Linq.JObject.Parse(model.RstLCProductList217[i].ToString());
                    strCatIdSecd += item["CatagoryID"].ToString().Replace("\"", "") + ",";
                }
                model.RstLCProductList217 = null;
            }
            if (model.RstLCProductList302 != null)
            {
                //foreach (Newtonsoft.Json.Linq.JObject item in model.RstLCProductList302)
                //{
                for (int i = 0; i < model.RstLCProductList302.Count; i++)
                {
                    Newtonsoft.Json.Linq.JObject item = Newtonsoft.Json.Linq.JObject.Parse(model.RstLCProductList302[i].ToString());
                    StrCatIdThrd += item["CatagoryID"].ToString().Replace("\"", "") + ",";
                }
                model.RstLCProductList302 = null;
            }
            if (model.RstLCProductList317 != null)
            {
                //foreach (Newtonsoft.Json.Linq.JObject item in model.RstLCProductList317)
                //{
                for (int i = 0; i < model.RstLCProductList317.Count; i++)
                {
                    Newtonsoft.Json.Linq.JObject item = Newtonsoft.Json.Linq.JObject.Parse(model.RstLCProductList317[i].ToString());
                    StrCatIdThrd += item["CatagoryID"].ToString().Replace("\"", "") + ",";
                }
                model.RstLCProductList317 = null;
            }

            DealerMasterLicenseDao dao = new DealerMasterLicenseDao();
            string appNo = dao.GetNextCFDANo("CFDA", "Next_CFDA");

            Hashtable hs = new Hashtable();
            hs.Add("DML_NewCurLegalPerson", model.WinLCLegalRep.ToSafeString());
            hs.Add("DML_NewCurRespPerson", model.WinLCHeadOfCorp.ToSafeString());
            hs.Add("DML_MID", model.WinDMLID.ToSafeGuid());
            hs.Add("DML_DMA_ID", model.QryLCDealerName.Key.ToSafeGuid());
            if (model.hidApplyStatus.ToSafeString() == "new" && opType == "submit")
            {
                hs.Add("DML_NewApplyNO", appNo);
            }
            hs.Add("DML_NewApplyStatus", ApplyStatus);
            hs.Add("DML_NewLicenseNo", model.WinLCLicenseNo.ToSafeString());
            if (model.WinLCLicenseStart != DateTime.MinValue)
            {
                hs.Add("DML_NewLicenseValidFrom", model.WinLCLicenseStart.ToString("yyyy-MM-dd"));
            }
            if (model.WinLCLicenseEnd != DateTime.MinValue)
            {
                hs.Add("DML_NewLicenseValidTo", model.WinLCLicenseEnd.ToString("yyyy-MM-dd"));
            }
            hs.Add("DML_NewSecondClassCatagory", strCatIdSecd);
            hs.Add("DML_NewFilingNo", model.WinLCRecordNo);
            if (model.WinLCRecordStart != DateTime.MinValue)
            {
                hs.Add("DML_NewFilingValidFrom", model.WinLCRecordStart.ToString("yyyy-MM-dd"));
            }
            if (model.WinLCRecordEnd != DateTime.MinValue)
            {
                hs.Add("DML_NewFilingValidTo", model.WinLCRecordEnd.ToString("yyyy-MM-dd"));
            }
            hs.Add("DML_NewThirdClassCatagory", StrCatIdThrd);
            hs.Add("DML_NewApplyDate", DateTime.Now);
            hs.Add("DML_NewApplyUser", new Guid(RoleModelContext.Current.User.Id));
            hs.Add("DML_SalesRep", model.WinLCSales.Key.ToSafeString());
            dao.insertDealerMasterLicenseModify(hs);

            if (ApplyStatus.Equals("审批中"))
            {
                IDealerMasters dllDealer = new DealerMasters();
                dllDealer.SubmintCfdaMflow(model.WinDMLID.ToSafeString(), appNo, model.WinLCSales.Key.ToSafeString());
            }
        }

        #endregion
    }
}
