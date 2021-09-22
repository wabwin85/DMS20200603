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
using DMS.Business;
using Newtonsoft.Json;
using DMS.BusinessService.Util.DealerFilter;
using DMS.BusinessService.Util.DealerFilter.Impl;
using DMS.ViewModel.Common;
using DMS.Model;
using DMS.Model.Data;
using DMS.DataAccess.DataInterface;

namespace DMS.BusinessService.MasterDatas
{
    public class PartsClsfcListService : ABaseQueryService
    {
        private IProductClassifications bizProductClassification = new ProductClassifications();
        private ICfns bizCFNS = new Cfns();
        public PartsClsfcListVO Init(PartsClsfcListVO model)
        {
            try
            {
                model.LstProductLine = base.GetProductLine();
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public PartsClsfcListVO GetPartsClsfcTree(PartsClsfcListVO model)
        {
            try
            {
                model.LstPartsClassification =
                    JsonHelper.DataTableToArrayList(
                        GetPartsClassification(model.QryProductLine.Key, model.ParentID).ToDataSet().Tables[0]);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public PartsClsfcListVO GetContainProducts(PartsClsfcListVO model)
        {
            try
            {
                if (!string.IsNullOrEmpty(model.ProductCatagoryPctId) && model.ProductCatagoryPctId != Guid.Empty.ToString())
                {
                    Cfn param = new Cfn();
                    param.ProductCatagoryPctId = new Guid(model.ProductCatagoryPctId);
                    int total = 0;
                    int start = (model.Page - 1) * model.PageSize;
                    IList<Cfn> query = bizCFNS.SelectByFilter(param, start, model.PageSize, out total);
                    model.LstContainProducts = JsonHelper.DataTableToArrayList(query.ToDataSet().Tables[0]);
                    model.DataCount = total;
                    model.IsSuccess = true;
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

        public PartsClsfcListVO GetCFNList(PartsClsfcListVO model)
        {
            try
            {
                int totalCount = 0;

                Hashtable param = new Hashtable();

                if (model.WinProductLine.ToSafeString() != "" && model.WinProductLine.Key.ToSafeString() != "")
                {
                    param.Add("ProductLineBumId", new Guid(model.WinProductLine.Key.ToSafeString()));
                }
                if (model.WinIsContain.ToSafeString() != "" && model.WinIsContain.Key.ToSafeString() != "")
                {
                    param.Add("IsContain", model.WinIsContain.Key.ToSafeString());
                }
                if (!string.IsNullOrEmpty(model.WinProductModel))
                {
                    param.Add("CustomerFaceNbr", model.WinProductModel.ToSafeString());
                }

                int start = (model.Page - 1) * model.PageSize;
                IList<Cfn> query = bizCFNS.SelectByFilterIsContain(param, start, model.PageSize, out totalCount);
                model.RstProductInfo = JsonHelper.DataTableToArrayList(query.ToDataSet().Tables[0]);
                model.DataCount = totalCount;
                model.IsSuccess = true;
                
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public PartsClsfcListVO SaveCfnPartsRelationChanges(PartsClsfcListVO model)
        {
            try
            {
                if (!string.IsNullOrEmpty(model.ProductCatagoryPctId) &&
                    model.ProductCatagoryPctId != Guid.Empty.ToString()&&
                    !string.IsNullOrEmpty(model.QryProductLine.Key)&&
                    model.QryProductLine.Key != Guid.Empty.ToString())
                {
                    DMS.ViewModel.Common.ChangeRecords<Cfn> data = new DMS.ViewModel.Common.ChangeRecords<Cfn>();
                    Guid catagoryId = new Guid(model.ProductCatagoryPctId);
                    Guid lineId = new Guid(model.QryProductLine.Key);
                    List<Cfn> lstCreated = JsonHelper.Deserialize<List<Cfn>>(model.PartsCls_ChangeRecords_Created);
                    List<Cfn> lstDeleted = JsonHelper.Deserialize<List<Cfn>>(model.PartsCls_ChangeRecords_Deleted);
                    List<Cfn> lstUpdated = new List<Cfn>();
                    data.Created = lstCreated;
                    data.Deleted = lstDeleted;
                    data.Updated = lstUpdated;
                    bizCFNS.SaveCfnPartsRelation(data, catagoryId, lineId);
                    model.IsSuccess = true;
                }
                else
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add("保存失败，产品线或者产品分类为空!");
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

        public PartsClsfcListVO DeleteNode(PartsClsfcListVO model)
        {
            try
            {
                if (!string.IsNullOrEmpty(model.hidSelectNodeId.ToSafeString()))
                {
                    string result = string.Empty;
                    Hashtable param = new Hashtable();
                    
                    param.Add("Name", model.PartName.ToSafeString());
                    param.Add("EnglishName", model.PartENName.ToSafeString());
                    param.Add("Description", model.PartDes.ToSafeString());
                    param.Add("OpName", "Delete");
                    param.Add("Id", model.hidSelectNodeId.ToSafeString());
                    param.Add("ProductLineId", model.ProductLineId.ToSafeGuid());
                    param.Add("ParentId", model.ParentID.ToSafeGuid());
                    param.Add("ParentCode", model.ParentCode.ToSafeString());
                    param.Add("Code", model.Code.ToSafeString());
                    param.Add("ClsNode", model.ClsNode.ToSafeString());

                    result = bizProductClassification.DeletePartsClassification(param);

                    if (result == "Success")
                    {
                        model.IsSuccess = true;
                        model.ExecuteMessage.Add("Success");
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

        public PartsClsfcListVO SaveNode(PartsClsfcListVO model)
        {
            try
            {
                string result = string.Empty;

                PartsClassification part = null;
                Hashtable param = null;
                Guid? newGuid = null;

                string id = model.ChangeNodeId.ToSafeString();

                if (id.Length == 36)
                {
                    
                    newGuid = new Guid(id);
                    part = bizProductClassification.GetObject(newGuid.Value);
                    param = new Hashtable();

                    if (part != null)
                    {
                        param.Add("Name", model.PartName.ToSafeString());
                        param.Add("EnglishName", model.PartENName.ToSafeString());
                        param.Add("Description", model.PartDes.ToSafeString());
                        param.Add("OpName", "Update");
                        param.Add("Id", part.Id.ToSafeString());
                        param.Add("ProductLineId", part.ProductLineId.ToSafeString());
                        param.Add("ParentId", part.ParentId.ToSafeString());
                        param.Add("ParentCode", model.ParentCode.ToSafeString());
                        param.Add("Code", model.Code.ToSafeString());
                        param.Add("ClsNode", model.ClsNode.ToSafeString());
                        result = bizProductClassification.UpdatePartsClassification(param);

                        if (result == "Success")
                        {
                            model.IsSuccess = true;
                            model.ExecuteMessage.Add("Success");
                        }
                    }
                    
                }
                else
                {
                    string newNode = string.Empty;
                    Guid? parentGuid = null;
                    string parentId = model.hidSelectNodeId.ToSafeString();
                    if (!string.IsNullOrEmpty(parentId))
                        parentGuid = new Guid(parentId);
                    
                    part = new PartsClassification();
                    param = new Hashtable();

                    part.Id = DMS.Common.DMSUtility.GetGuid();
                    part.Name = model.PartName.ToSafeString();
                    part.EnglishName = model.PartENName.ToSafeString();
                    part.Description = model.PartDes.ToSafeString();

                    string lineId = model.ProductLineId.ToSafeString();
                    if (!string.IsNullOrEmpty(lineId))
                    {
                        part.ProductLineId = new Guid(lineId);
                        param.Add("ProductLineId", lineId);
                    }

                    if (parentGuid != null && parentGuid != part.ProductLineId)
                    {
                        part.ParentId = parentGuid;
                        param.Add("ParentId", parentId);
                    }

                    param.Add("Name", model.PartName.ToSafeString());
                    param.Add("EnglishName", model.PartENName.ToSafeString());
                    param.Add("Description", model.PartDes.ToSafeString());
                    param.Add("OpName", "Insert");
                    param.Add("Id", part.Id.ToSafeString());
                    param.Add("ParentCode", model.ParentCode.ToSafeString());
                    param.Add("Code", model.Code.ToSafeString());
                    param.Add("ClsNode", model.ClsNode.ToSafeString());

                    result = bizProductClassification.UpdatePartsClassification(param);
                    if (model.ClsNode.ToSafeString() == "Contract")
                        newNode = "Authorization";
                    else if (model.ClsNode.ToSafeString() == "Authorization")
                        newNode = "Quota";
                    model.ChangeNodeId = part.Id.ToSafeString();
                    model.ClsNode = newNode;

                    if (result == "Success")
                    {
                        model.IsSuccess = true;
                        model.ExecuteMessage.Add("Success");
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

        private IList<PartsClassification> GetPartsClassification(string lineId, string prentId = "")
        {
            IList<PartsClassification> list = bizProductClassification.GetClassificationByLine(new Guid(lineId));
            //IList<PartsClassification> listRoot = bizProductClassification.GetRoot();
            IList<PartsClassification> lstResult = null;
            if (!string.IsNullOrEmpty(prentId))
            {
                Guid idParent = new Guid(prentId);

                lstResult = list.Where(item => item.ParentId == idParent).ToList();
            }
            else
            {
                lstResult = list.Where(item => !item.ParentId.HasValue).ToList();
            }
            foreach (var item in lstResult)
            {
                item.HasChildren = list.Any(p => p.ParentId == item.Id);
            }
            //foreach (var item in lstResult)
            //{
            //    item.IsAuthorizationNode = listRoot.Any(p => p.Id == item.ParentId);
            //}
            return lstResult;
        }
        
        /*
        private string RootID = "00000000-0000-0000-0000-000000000000";
        public ICFNMaster bllCFN = WebCommon.CreateInstance<ICFNMaster>();
        public override string GetActionName()
        {
            return "PartsClsfc";
        }

        public override JsonMessage ProcessMessage(JsonMessage message)
        {

            dynamic result = new ExpandoObject();
            result.Message = "";
            try
            {
                var operateType = message.Parameters["OperateType"].ToString();
                //获取列表信息
                if (operateType == "GetPartsClsfcTree")
                {
                    string ID = message.Parameters["ParentID"].ToString();
                    //考虑前台搜索功能改为一次递归全部取出所有数据
                    //前台设置相应属性即可
                    result.TreeList = BindTree(ID);
                }
                //是否新增分类
                else if (operateType == "IfAllowAdd")
                {
                    result.IsExist = IsExistCFNList(message);
                    if (result.IsExist)
                    {
                        result.Message = "该分类下挂有产品，请先移除产品后，再进行本操作";
                    }
                }
                //新增分类
                else if (operateType == "Add")
                {
                    #region
                    AddData(message);
                    #endregion
                    result.Message = "Success";
                }
                //编辑分类
                else if (operateType == "Edit")
                {
                    #region
                    EditData(message);
                    #endregion
                    result.Message = "Success";
                }
                //删除分类
                else if (operateType == "Delete")
                {
                    #region
                    result.Message = DelData(message);
                    #endregion
                }
                //cfn及分类关系
                else if (operateType == "SaveCfnPartsRelationChanges")
                {
                    #region
                    SaveCfnPartsRelationChanges(message);
                    result.Message = "Success";
                    #endregion
                }
                //导出数据
                else if (operateType == "doExport")
                {
                    #region
                    string filePath = DoExport(message);
                    result.Message = "0";
                    result.FilePath = filePath;
                    #endregion
                }
            }
            catch (Exception ex)
            {
                result.Message = ex.Message;
                result.ErrorDetail = ex;
            }

            message.Result = result;
            return message;
        }
        public dynamic BindTree(string PrentID = "")
        {
            dynamic result = new ExpandoObject();
            //BLLCFNMaster cfnSer = new BLLCFNMaster();
            Guid? ID = null;
            if (!string.IsNullOrEmpty(PrentID))
            {
                if (PrentID == "00000000-0000-0000-0000-000000000000")
                {
                    result = bllCFN.GetPartsClsfcTreeList(ID);
                }
                else
                {
                    ID = new Guid(PrentID);
                    result = bllCFN.GetPartsClsfcTreeList(ID);
                }

            }
            else
            {
                View_PartsClsfcTreeNode temp = new View_PartsClsfcTreeNode();
                temp.Id = new Guid("00000000-0000-0000-0000-000000000000");
                temp.Name = "所有产品线";
                temp.hasChildren = 1;
                result = temp;
            }

            return result;
        }

        public dynamic IsExistCFNList(JsonMessage message)
        {

            int page = Convert.ToInt32(message.Parameters["page"]);
            int pageSize = Convert.ToInt32(message.Parameters["pageSize"]);
            string ProductLine = message.Parameters["ProductLine"].ToString();
            string CFN = message.Parameters["CFN"].ToString();
            string PCTID = message.Parameters["ProductCatagoryPctId"].ToString();
            int total = 0;

            //BLLCFNMaster cfnSer = new BLLCFNMaster();
            bllCFN.GetCFNList(page, pageSize, ProductLine, PCTID, CFN, out total);
            if (total > 0)
            {
                return true;
            }

            return false;
        }

        public List<View_CFN> ConvertJsonToObjList(string MainData)
        {
            if (string.IsNullOrWhiteSpace(MainData))
            {
                return new List<View_CFN>(); ;
            }
            try
            {
                var obj = JToken.Parse(MainData);
                return JsonConvert.DeserializeObject<List<View_CFN>>(MainData);
            }
            catch (Exception ex)
            {
                throw new FormatException("前台传输json格式有误.");
            }
        }

        public void AddData(JsonMessage message)
        {
            string strPCTID = message.Parameters["NewId"].ToString();
            string strPCTName = message.Parameters["PartName"].ToString();
            string strPCTDes = message.Parameters["PartDes"].ToString();
            string strShortName = message.Parameters["ShortName"].ToString();
            string strProductLineId = message.Parameters["ProductLineId"].ToString();
            string strPartId = message.Parameters["PartId"].ToString();
            //BLLCFNMaster cfnSer = new BLLCFNMaster();
            bllCFN.AddPartsClsfc(strPCTID, strPCTName, strPCTDes, RootID, strShortName, strProductLineId, strPartId);
        }
        public void EditData(JsonMessage message)
        {
            string strPartId = message.Parameters["PartId"].ToString();
            string strPartName = message.Parameters["PartName"].ToString();
            string strPartDes = message.Parameters["PartDes"].ToString();
            string strProductLineId = message.Parameters["ProductLineId"].ToString();
            string strShortName = message.Parameters["ShortName"].ToString();
            //BLLCFNMaster cfnSer = new BLLCFNMaster();
            bllCFN.EditPartsClsfc(strPartId, strPartName, strPartDes, strProductLineId, strShortName);
        }
        public string DelData(JsonMessage message)
        {
            return bllCFN.DeletePartcClsfc(message.Parameters["PartId"].ToString());
        }

        public void SaveCfnPartsRelationChanges(JsonMessage message)
        {
            string PctID = message.Parameters["PctId"].ToString();
            string ProductLineID = message.Parameters["ProductLineId"].ToString();
            List<View_CFN> cfn_Addlist = ConvertJsonToObjList(message.Parameters["Created"].ToString());
            List<View_CFN> cfn_Dellist = ConvertJsonToObjList(message.Parameters["Deleted"].ToString());
            //BLLCFNMaster cfnSer = new BLLCFNMaster();
            bllCFN.SaveCfnPartsRelationChanges(PctID, ProductLineID, cfn_Addlist, cfn_Dellist);
        }
        public string DoExport(JsonMessage message)
        {
            string filepath = string.Empty;
            //Commons bll = new Commons();

            //DataSet ds = bll.QueryDataSetNoPages(null, "SelectCfnPartCatagoryInfo");
            IList<CfnPartCatagoryInfo> expData = bllCFN.GetExportCFNData();
            DataSet ds = utCommonFunction.ToDataSet<CfnPartCatagoryInfo>(expData);
            Utility2.DataSetTrans(ds, AppSetting.CFN_Parts);
            DataTable dt1 = ds.Tables[0].Copy();
            DataSet dsExcel = new DataSet("产品所属分类");

            DataTable dtData = dt1;
            dtData.TableName = "产品所属分类";

            if (null != dtData)
            {
                dtData.Columns.Add("是否删除");
                dsExcel.Tables.Add(dtData);

                //说明
                DataTable dtReadMe = new DataTable("说明");
                dtReadMe.Columns.Add("序号", Type.GetType("System.String"));
                dtReadMe.Columns.Add("说明", Type.GetType("System.String"));

                dtReadMe.Rows.Add(new object[] { "1)", "此导出数据可用于导入CFN与产品分类关系数据的导入" });
                dtReadMe.Rows.Add(new object[] { "2)", "黄色字段为必填字段。" });
                dtReadMe.Rows.Add(new object[] { "3)", "L1-L5列为产品分类依次层级；且必须连续填写，不得在中间列为空，之后列却有数据；" });
                dtReadMe.Rows.Add(new object[] { "4)", "CFN为产品型号" });
                dtReadMe.Rows.Add(new object[] { "5)", "“是否删除”填“是”表示删除CFN与分类关系；不填或者其他则默认为否；" });
                dtReadMe.Rows.Add(new object[] { "6)", "导入的分类及层级必须在当前系统中存在，且CFN只能挂在最底层节点" });

                dsExcel.Tables.Add(dtReadMe);
            }

            var sheetStyles = new Dictionary<string, SheetStyle>();
            var sheetStyle = new SheetStyle();
            sheetStyle.HeaderStyles = new Dictionary<string, HeaderStyle>() {
                        {"产品线", HeaderStyle.YellowFill },
                        {"CFN", HeaderStyle.YellowFill }
                    };
            sheetStyles.Add("产品所属分类", sheetStyle);
            filepath = ExcelUtility.WriteExcel(dsExcel, sheetStyles, false);
            return filepath;
        }
        */
    }
}
