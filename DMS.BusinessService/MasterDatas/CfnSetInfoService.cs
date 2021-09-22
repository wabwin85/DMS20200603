using DMS.Business;
using DMS.Common;
using DMS.Common.Common;
using DMS.DataAccess;
using DMS.DataAccess.ContractElectronic;
using DMS.DataAccess.MasterPage;
using DMS.Model;
using DMS.ViewModel.MasterDatas;
using DMS.ViewModel.MasterPage;
using Grapecity.DataAccess.Transaction;
using Lafite.RoleModel.Security;
using Newtonsoft.Json;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace DMS.BusinessService.MasterDatas
{
    public class CfnSetInfoService : ABaseBusinessService
    {

        public CfnSetInfoVO Init(CfnSetInfoVO model)
        {
            try
            {

                ICfnSetBLL _CfnSetBLL = new CfnSetBLL();
                
                model.LstBu = base.GetProductLine();//JsonHelper.DataTableToArrayList(Bu.SelectBU(htbu).Tables[0]);
                if (!string.IsNullOrEmpty(model.InstanceId))
                {
                    Query(model);             
                    using (CfnSetDao dao = new CfnSetDao())
                    {
                        Hashtable ht = new Hashtable();
                        BaseService.AddCommonFilterCondition(ht);
                        DataTable cnfSet = dao.SelectCfnSetById(model.InstanceId, Convert.ToString(ht["SubCompanyId"]), Convert.ToString(ht["BrandId"]));
                        if (cnfSet.Rows.Count > 0)
                        {
                            model.isCanEditUPN = false;
                            model.IptCFNSetChineseName = Convert.ToString(cnfSet.Rows[0]["CFN_ChineseName"]);
                            model.IptCFNSetEnglishName = Convert.ToString(cnfSet.Rows[0]["CFN_EnglishName"]);
                            model.IptCFNSetUOM = Convert.ToString(cnfSet.Rows[0]["CFN_Property3"]);
                            model.IptCFNSetUPN = Convert.ToString(cnfSet.Rows[0]["CFN_CustomerFaceNbr"]);
                            model.IptCFNSetCINO = Convert.ToString(cnfSet.Rows[0]["CFN_Property6"]);
                            model.IptCFNSetPT7 = Convert.ToString(cnfSet.Rows[0]["CFN_Property7"]);
                            model.IptCFNSetPT8 = Convert.ToString(cnfSet.Rows[0]["CFN_Property8"]);
                            model.IptCFNSetDescription = Convert.ToString(cnfSet.Rows[0]["CFN_Description"]);

                            model.IptCFNSetCanOrder = (Convert.ToString(cnfSet.Rows[0]["CFN_Property4"]) == "1" ? true : false);
                            model.IptCFNSetTool = (Convert.ToString(cnfSet.Rows[0]["CFN_Tool"]) == "1" ? true : false);
                            model.IptCFNSetImpant = (Convert.ToString(cnfSet.Rows[0]["CFN_Implant"]) == "1" ? true : false);
                            model.IptCFNSetShare = (Convert.ToString(cnfSet.Rows[0]["CFN_Share"]) == "1" ? true : false);
                            model.IptBu.Key = Convert.ToString(cnfSet.Rows[0]["CFN_ProductLine_BUM_ID"]);
                            model.IptBu.Value = Convert.ToString(cnfSet.Rows[0]["ATTRIBUTE_NAME"]);
                        }
                        
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

        public CfnSetInfoVO Save(CfnSetInfoVO model)
        {
            try
            {
                CfnDao cfnSetDao = new CfnDao();
                CfnSetDetailDao detailDao = new CfnSetDetailDao();
                Cfn mainData = new Cfn();
                Product pmaData = new Product();
                ProductDao pmaDao = new ProductDao();
                mainData.CreateUser = new Guid(RoleModelContext.Current.User.Id);
                mainData.CreateDate = DateTime.Now;
                mainData.LastUpdateUser = new Guid(RoleModelContext.Current.User.Id);
                mainData.LastUpdateDate = DateTime.Now;
                mainData.ChineseName = model.IptCFNSetChineseName;
                mainData.EnglishName = model.IptCFNSetEnglishName;
                mainData.CustomerFaceNbr = model.IptCFNSetUPN;
                mainData.Property3 = model.IptCFNSetUOM;
                mainData.Property6 = model.IptCFNSetCINO;
                mainData.Property7 = model.IptCFNSetPT7;
                mainData.Property8 = model.IptCFNSetPT8;
                mainData.Description = model.IptCFNSetDescription;
                mainData.Property4 = model.IptCFNSetCanOrder?"1":"0";
                mainData.Tool = model.IptCFNSetTool;
                mainData.Implant = model.IptCFNSetImpant;
                mainData.Share = model.IptCFNSetShare;
                mainData.ProductLineBumId = new Guid(model.IptBu.Key);
                mainData.DeletedFlag = false;
                mainData.Property1 = mainData.CustomerFaceNbr;
                mainData.Property2 = "0";
                mainData.Property6 = "0";
                using (TransactionScope trans = new TransactionScope())
                {
                    if (!string.IsNullOrEmpty(model.InstanceId))
                    {
                        mainData.Id = new Guid(model.InstanceId);
                        detailDao.DeleteByCFNSetUPN(model.IptCFNSetUPN);
                        cfnSetDao.Update(mainData);                        
                    }
                    else
                    {
                        mainData.Id = Guid.NewGuid();
                        Cfn cfnPP = cfnSetDao.GetCfnByUpn(model.IptCFNSetUPN);
                        if (cfnPP != null)
                        {
                            model.IsSuccess = false;
                            model.RstDetailList = null;
                            model.ExecuteMessage.Add("UPN已存在");
                            return model;
                        }
                        cfnSetDao.Insert(mainData);
                        //自动插入产品数据
                        pmaData.Cfn = mainData.Id.ToString();
                        pmaData.ConvertFactor = 0;
                        pmaData.Id = Guid.NewGuid();
                        pmaData.Upn = model.IptCFNSetUPN;
                        pmaData.UnitOfMeasure = model.IptCFNSetUOM;
                        pmaData.CreateUser = new Guid(RoleModelContext.Current.User.Id);
                        pmaData.CreateDate = DateTime.Now;
                        pmaData.LastUpdateUser = new Guid(RoleModelContext.Current.User.Id);
                        pmaData.LastUpdateDate = DateTime.Now;
                        pmaData.ProductLineBumId = new Guid(model.IptBu.Key);
                        pmaDao.Insert(pmaData);
                    }
                    
                    foreach (var temp in model.RstDetailList)
                    {
                        CfnSetDetailVO detail = JsonConvert.DeserializeObject<CfnSetDetailVO>(temp.ToString());
                        ProductBOM pbm = new ProductBOM();
                        pbm.MasterUPN= model.IptCFNSetUPN;
                        pbm.BOMUPN = detail.CustomerFaceNbr;
                        pbm.Qty = detail.DefaultQuantity;
                        detailDao.InsertProductBOM(pbm);
                    }
                }
                model.RstDetailList = null;
                model.IsSuccess = true;
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
                model.RstDetailList = null;
                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }

            return model;
        }

        public string Query(CfnSetInfoVO model)
        {
            try
            {
                int outCont = 0;
                int start = (model.Page - 1) * model.PageSize;
                if (!string.IsNullOrEmpty(model.InstanceId))
                {
                    CfnSetDetailDao detailDao = new CfnSetDetailDao();
                    DataSet ds = detailDao.QueryCfnSetDetailByCFNSetUPN(new Guid(model.InstanceId), start, model.PageSize, out outCont);                   
                    model.RstDetailList = JsonHelper.DataTableToArrayList(ds.Tables[0]);
                }
                model.DataCount = outCont;
                model.IsSuccess = true;

            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            var data = new { data = model.RstDetailList, total = model.DataCount };
            var result = new { success = model.IsSuccess, data = data };
            return JsonConvert.SerializeObject(result);
        }





    }
}
