using DMS.Business;
using DMS.Business.Cache;
using DMS.Common;
using DMS.Common.Common;
using DMS.Common.Extention;
using DMS.Model;
using DMS.Model.Data;
using DMS.ViewModel.MasterDatas;
using Lafite.RoleModel.Security;
using Newtonsoft.Json;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Web.SessionState;

namespace DMS.BusinessService.MasterDatas
{
    public class DealerContractEditorService : ABaseQueryService, IRequiresSessionState
    {
        IRoleModelContext _context = RoleModelContext.Current;
        public IDealerContracts _dealerContractBiz = new DealerContracts();
        public IAttachmentBLL attachBll = new AttachmentBLL();
        public DealerContractEditorVO Init(DealerContractEditorVO model)
        {
            try
            {
                IDictionary<string, string> dicts = DictionaryHelper.GetDictionary("Dealer_Annex");
                // model.LstFileType = JsonHelper.DataTableToArrayList(dicts.ToArray().ToDataSet().Tables[0]);
                model.IsDealer = IsDealer;
                if (!string.IsNullOrEmpty(model.hidDealerId))
                {
                    Guid dealerid = new Guid(model.hidDealerId);
                    model.DealerName = DealerCacheHelper.GetDealerName(dealerid);
                }
                model.LstProductLine = base.GetProductLine();
                model.LstAuthType = new ArrayList(DictionaryHelper.GetDictionary(SR.CONST_DMS_Authentication_Type).ToArray());
                model.LstApplyAuthType = new ArrayList(Bind_AuthTypeForEdit());
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }
        /// <summary>
        /// 授权列表
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public string QueryAuthorization(DealerContractEditorVO model)
        {
            try
            {
                if (!string.IsNullOrEmpty(model.ContractId))
                {
                    Guid conId = new Guid(model.ContractId);

                    //Edited By Song Yuqi On 2016-05-23 
                    DealerAuthorization param = new DealerAuthorization();
                    param.DclId = conId;
                    if (!string.IsNullOrEmpty(model.QryAuthStartDate.StartDate.ToSafeString()))
                    {
                        param.AuthStartBeginDate = Convert.ToDateTime(model.QryAuthStartDate.StartDate);
                    }
                    if (!string.IsNullOrEmpty(model.QryAuthStartDate.EndDate.ToSafeString()))
                    {
                        param.AuthStartEndDate = Convert.ToDateTime(model.QryAuthStartDate.EndDate);
                    }
                    if (!string.IsNullOrEmpty(model.QryAuthStopDate.StartDate.ToSafeString()))
                    {
                        param.AuthStopBeginDate = Convert.ToDateTime(model.QryAuthStopDate.StartDate);
                    }
                    if (!string.IsNullOrEmpty(model.QryAuthStopDate.EndDate.ToSafeString()))
                    {
                        param.AuthStopEndDate = Convert.ToDateTime(model.QryAuthStopDate.EndDate);
                    }
                    if (!string.IsNullOrEmpty(model.ProductLine.ToSafeString()))
                    {
                        if (!string.IsNullOrEmpty(model.AuthType.Key))
                            param.Type = model.AuthType.Key.ToString();
                    }
                    if (!string.IsNullOrEmpty(model.ProductLine.ToSafeString()))
                    {
                        if (!string.IsNullOrEmpty(model.ProductLine.Key))
                            param.ProductLineBumId = new Guid(model.ProductLine.Key);
                    }

                    DataSet query = _dealerContractBiz.GetAuthorizationListForDataSet(param);
                    if (query != null)
                    {
                        if (query.Tables.Count > 0)
                        {
                            model.RstResultList = JsonHelper.DataTableToArrayList(query.Tables[0]);
                            model.DataCount = query.Tables[0].Rows.Count;
                        }
                    }
                }
                model.IsSuccess = true;
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }

            var data = new { data = model.RstResultList, total = model.DataCount };
            var result = new { success = model.IsSuccess, data = data };
            return JsonConvert.SerializeObject(result);
        }
        /// <summary>
        ///包含医院
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public string QueryAuthHospitalList(DealerContractEditorVO model)
        {
            try
            {
                if (!string.IsNullOrEmpty(model.hiddenId))
                {
                    Guid conId = new Guid(model.hiddenId);

                    IHospitals bll = new Hospitals();

                    Hashtable table = new Hashtable();

                    if (!string.IsNullOrEmpty(model.HosHospitalName))
                    {
                        table.Add("HosHospitalName", model.HosHospitalName);
                    }
                    if (!string.IsNullOrEmpty(model.QryHosStartDate.StartDate))
                    {
                        table.Add("HosStartBeginDate", Convert.ToDateTime(model.QryHosStartDate.StartDate).ToString("yyyy-MM-dd"));
                    }
                    if (!string.IsNullOrEmpty(model.QryHosStartDate.EndDate))
                    {
                        table.Add("HosStartEndDate", Convert.ToDateTime(model.QryHosStartDate.EndDate).ToString("yyyy-MM-dd"));
                    }
                    if (!string.IsNullOrEmpty(model.QryHosStopDate.StartDate))
                    {
                        table.Add("HosStopBeginDate", Convert.ToDateTime(model.QryHosStopDate.StartDate).ToString("yyyy-MM-dd"));
                    }
                    if (!string.IsNullOrEmpty(model.QryHosStopDate.EndDate))
                    {
                        table.Add("HosStopEndDate", Convert.ToDateTime(model.QryHosStopDate.EndDate).ToString("yyyy-MM-dd"));
                    }
                    if (Convert.ToBoolean(model.HosNoAuthDate))
                    {
                        table.Add("HosNoAuthDate", "1");
                    }

                    table.Add("AuthorizationId", conId);

                    int totalCount = 0;
                    int start = (model.Page - 1) * model.PageSize;
                    List<Hospital> query = bll.QueryAuthorizationHospitalList(table, start, model.PageSize, out totalCount).ToList();
                    model.RstResultList = new ArrayList(query);
                    model.DataCount = totalCount;
                }
                model.IsSuccess = true;
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }

            var data = new { data = model.RstResultList, total = model.DataCount };
            var result = new { success = model.IsSuccess, data = data };
            return JsonConvert.SerializeObject(result);
        }

        /// <summary>
        /// 经销商授权确认保存
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public DealerContractEditorVO ValidAttachment(DealerContractEditorVO model)
        {
            try
            {
                if (!string.IsNullOrEmpty(model.hiddenId))
                {
                    AttachmentBLL attachBll = new AttachmentBLL();
                    DataSet ds = attachBll.GetAttachmentByMainId(new Guid(model.hiddenId), AttachmentType.DealerAuthorization);//authId

                    if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                    {
                        model.hiddenRtnMsg = "Success";
                    }
                    else
                    {
                        model.hiddenRtnMsg = "Failure";
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

        /// <summary>
        /// 保存授权信息
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public DealerContractEditorVO SaveAuthorization(DealerContractEditorVO model)
        {
            try
            {
                //you can add own logic for save using one of above data representation and then set e.Cancel=true for canceling Store events
                string optionStatus = model.isCreated;// Deleted Created Updated
                if (!string.IsNullOrEmpty(model.ContractId))
                {
                    DealerAuthorization data = JsonConvert.DeserializeObject<DealerAuthorization>(model.submitStrParam);
                    Guid lineId = new Guid(model.ContractId);

                    _dealerContractBiz.SaveAuthorizationChanges(data, optionStatus);

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
        /// <summary>
        /// 删除经销商授权信息
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public DealerContractEditorVO DeleteAuthorization(DealerContractEditorVO model)
        {
            try
            {
                if (!string.IsNullOrEmpty(model.hiddenId))
                {
                    Guid id = string.IsNullOrEmpty(model.hiddenId) ? Guid.Empty : new Guid(model.hiddenId);
                    bool isdeleted = _dealerContractBiz.DeleteAuthorization(id);
                    if (!isdeleted)
                    {
                        model.IsSuccess = false;
                        model.ExecuteMessage.Add("删除失败，请先删除授权医院!！");
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

        /// <summary>
        /// 授权属性
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public DealerContractEditorVO InitAuthorization(DealerContractEditorVO model)
        {
            try
            {
                model.hiddenId = DMS.Common.DMSUtility.NewGuid();
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

        /// <summary>
        /// 经销商授权选择产品分类保存
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public DealerContractEditorVO SavePartsType(DealerContractEditorVO model)
        {
            try
            {
                Guid catagoryId = new Guid();
                if (string.IsNullOrEmpty(model.PartType))
                {
                    catagoryId = new Guid(model.PartTypeLine);
                }
                else
                    catagoryId = new Guid(model.PartType);
                Guid dealerId = new Guid(model.hidDealerId);
                int flag = 0;
                string errormsg = string.Empty;
                if (!_dealerContractBiz.CheckAuthorizationParts(catagoryId, dealerId, out flag))
                {
                    switch (flag)
                    {
                        case 1: errormsg = "您选择的分类或产品线已存在，请重新选择!"; break;
                        case 2: errormsg = "您选择的产品线包含已存在的分类，请重新选择!"; break;
                        case 3: errormsg = "您选择的分类被已经存在的产品线包含，请重新选择"; break;
                        case 4: errormsg = "您选择的分类包含已存在的分类，请重新选择"; break;
                        case 5: errormsg = "您选择的分类被已存在的分类包含，请重新选择"; break;
                        default:
                            errormsg = "您的选择存在冲突，请重新选择";
                            break;
                    }
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add(errormsg);
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
        /// <summary>
        /// 选择医院Query
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public DealerContractEditorVO HospitalSelectorDlgQuery(DealerContractEditorVO model)
        {
            try
            {


            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        /// <summary>
        /// 复制医院
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public DealerContractEditorVO HospitalCopyDlgQuery(DealerContractEditorVO model)
        {
            try
            {


            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        /// <summary>
        /// 删除医院-查找医院
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public DealerContractEditorVO HospitalSelectdDelQuery(DealerContractEditorVO model)
        {
            try
            {
                if (!string.IsNullOrEmpty(model.hiddenId))
                {
                    Guid conId = new Guid(model.hiddenId);

                    IHospitals bll = new Hospitals();

                    int totalCount = 0;
                    int start = (model.Page - 1) * model.PageSize;
                    Hospital param = new Hospital();
                    param.HosHospitalName = model.SearchHospitalName.Trim();

                    param.HosProvince = model.QryProvince.Trim();
                    param.HosCity = model.QryCity.Trim();
                    param.HosDistrict = model.QryDistrict.Trim();
                    IList<Hospital> query = bll.SelectByAsAuthorization(param, conId, start, model.PageSize, out totalCount);
                    model.RstResultList = new ArrayList(query.ToList());
                    model.DataCount = totalCount;

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
        #region 医院选择
        /// <summary>
        /// 删除医院-删除操作
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public DealerContractEditorVO DeleteHospital(DealerContractEditorVO model)
        {
            try
            {
                //you can add own logic for save using one of above data representation and then set e.Cancel=true for canceling Store events
                if (!string.IsNullOrEmpty(model.hiddenId))
                {
                    Guid datId = new Guid(model.hiddenId);
                    IList<Hospital> selDeleted = JsonConvert.DeserializeObject<List<Hospital>>(model.submitStrParam);
                    Guid[] hosList = (from p in selDeleted select p.HosId).ToArray<Guid>();

                    IDealerContracts bll = new DealerContracts();
                    bll.DetachHospitalFromAuthorization(datId, hosList);

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


        /// <summary>
        /// 选择医院-省份选择
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public DealerContractEditorVO ChangeChoiceHosProvince(DealerContractEditorVO model)
        {
            try
            {
                IDictionary<string, string> storeData = null;

                string hosProvince = model.QryProvince;
                string hosCity = model.QryCity;
                string hosDistrict = model.QryDistrict;
                string hosName = model.SearchHospitalName;

                if (string.IsNullOrEmpty(hosProvince) && string.IsNullOrEmpty(hosName))
                    return model;

                if ((!string.IsNullOrEmpty(hosCity) && !string.IsNullOrEmpty(hosDistrict)) || !string.IsNullOrEmpty(hosName))
                {

                    IHospitals bll = new Hospitals();

                    Hospital param = new Hospital();

                    param.HosProvince = model.HosProvinceText;
                    param.HosCity = model.HosCityText;
                    param.HosDistrict = model.HosDistrictText;
                    param.HosHospitalName = model.SearchHospitalName;
                    //param.HosHospitalShortName = this.txtHospital.Text;

                    IList<Hospital> query = null;

                    if (!string.IsNullOrEmpty(model.hiddenProductLine))
                    {   //查询当前产品线下所有医院


                        Guid lineId = new Guid(model.hiddenProductLine);
                        query = bll.SelectByProductLine(param, ExistsState.IsExists, lineId);
                    }
                    else
                    {
                        //所有医院


                        query = bll.SelectByFilter(param);
                    }
                    storeData = query.ToDictionary(c => c.HosId.ToString(), c => c.HosHospitalName);
                }
                else if (!string.IsNullOrEmpty(hosCity))
                {
                    ITerritorys bll = new Territorys();

                    IList<Territory> cities = bll.GetTerritorysByParent(new Guid(hosCity));
                    storeData = cities.ToDictionary(c => c.TerId.ToString(), c => c.Description);
                }
                else
                {
                    ITerritorys bll = new Territorys();

                    IList<Territory> cities = bll.GetTerritorysByParent(new Guid(hosProvince));
                    storeData = cities.ToDictionary(c => c.TerId.ToString(), c => c.Description);
                }

                model.RstResultCityList = new ArrayList(storeData.ToList());
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }


        /// <summary>
        /// 选择医院-保存确认
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public DealerContractEditorVO ChoiceHospitalSave(DealerContractEditorVO model)
        {
            try
            {
                string SelectType = string.Empty;
                if (model.QryDistrict != string.Empty || !string.IsNullOrEmpty(model.SearchHospitalName))
                    SelectType = SelectTerritoryType.Default.ToString();
                else
                {
                    if (string.IsNullOrEmpty(model.QryCity))
                        SelectType = SelectTerritoryType.City.ToString();
                    else
                        SelectType = SelectTerritoryType.District.ToString();
                }

                SelectTerritoryType selectType = (SelectTerritoryType)Enum.Parse(typeof(SelectTerritoryType), SelectType);
                IDictionary<string, string>[] selected = JsonConvert.DeserializeObject<Dictionary<string, string>[]>(model.submitStrParam);

                IDealerContracts bll = new DealerContracts();
                Guid datId = new Guid(model.hiddenId);
                string hosProvince = model.HosProvinceText;
                string hosCity = model.HosCityText;
                string hosDistrict = model.HosDistrictText;
                string dept = "";
                Guid lineId = new Guid(model.hiddenProductLine);

                IList<DealerAuthorization> dealerAuth = bll.GetAuthorizationList(new DealerAuthorization() { Id = datId });

                if (dealerAuth != null && dealerAuth.Count() > 0
                        && dealerAuth.First<DealerAuthorization>().StartDate.HasValue
                        && dealerAuth.First<DealerAuthorization>().EndDate.HasValue)
                {
                    bll.SaveHospitalOfAuthorization(datId, selected, selectType, hosProvince, hosCity, hosDistrict, lineId, dept
                        , dealerAuth.First<DealerAuthorization>().StartDate.Value
                        , dealerAuth.First<DealerAuthorization>().EndDate.Value);
                }
                else
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add("请先维护授权的开始时间和截止时间");
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

        #endregion

        #region 授权医院复制
        /// <summary>
        /// 复制医院查询
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public DealerContractEditorVO CopyHospitalQuery(DealerContractEditorVO model)
        {
            try
            {
                string contractId = model.ContractId.Trim();
                string authId = model.hiddenId.Trim();
                if (!string.IsNullOrEmpty(contractId) && !string.IsNullOrEmpty(authId))
                {
                    DataSet ds = _dealerContractBiz.GetAuthorizationListForDataSetExclude(new Guid(contractId), new Guid(authId));
                    if (ds != null)
                    {
                        model.RstResultList = JsonHelper.DataTableToArrayList(ds.Tables[0]);
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
        /// <summary>
        /// 复制医院提交保存
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public DealerContractEditorVO CopyHospitalSubmit(DealerContractEditorVO model)
        {
            try
            {
                string datId = model.hiddenId;


                IList<DealerAuthorization> dealerAuth = _dealerContractBiz.GetAuthorizationList(new DealerAuthorization() { Id = new Guid(datId) });

                if (dealerAuth != null && dealerAuth.Count() > 0
                        && dealerAuth.First<DealerAuthorization>().StartDate.HasValue
                        && dealerAuth.First<DealerAuthorization>().EndDate.HasValue)
                {
                    IList<DealerAuthorization> data = JsonConvert.DeserializeObject<List<DealerAuthorization>>(model.submitStrParam);
                    if (data.Count <= 0)
                    {
                        return model;
                    }
                    Guid fromDatId = data[0].Id.Value;
                    _dealerContractBiz.CopyHospitalFromOtherAuth(new Guid(datId), fromDatId
                        , dealerAuth.First<DealerAuthorization>().StartDate.Value
                        , dealerAuth.First<DealerAuthorization>().EndDate.Value);

                }
                else
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add("请先维护授权的开始时间和截止时间");
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
        #endregion

        #region 包含医院序列功能
        /// <summary>
        /// 包含医院--删除医院
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public DealerContractEditorVO DeleteHospitalListEvent(DealerContractEditorVO model)
        {
            try
            {
                //you can add own logic for save using one of above data representation and then set e.Cancel=true for canceling Store events

                if (!string.IsNullOrEmpty(model.hiddenId))
                {
                    Guid datId = new Guid(model.hiddenId);

                    IList<Hospital> selDeleted = JsonConvert.DeserializeObject<List<Hospital>>(model.submitStrParam);
                    Guid[] hosList = (from p in selDeleted select p.HosId).ToArray<Guid>();

                    IDealerContracts bll = new DealerContracts();
                    bll.DetachHospitalFromAuthorization(datId, hosList);
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
        /// <summary>
        /// 包含医院--授权时间修改
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public DealerContractEditorVO UpdateHospitalAuthDate(DealerContractEditorVO model)
        {
            try
            {
                if (!string.IsNullOrEmpty(model.hiddenId) && !string.IsNullOrEmpty(model.HospitalId) && !string.IsNullOrEmpty(model.AuthStartDate) && !string.IsNullOrEmpty(model.AuthEndDate))
                {
                    Guid datId = new Guid(model.hiddenId);
                    _dealerContractBiz.SaveHositalAuthDate(datId, new Guid(model.HospitalId), DateTime.Parse(model.AuthStartDate), DateTime.Parse(model.AuthEndDate));
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
        #endregion


        #region 私有方法
        private IList Bind_AuthTypeForEdit()
        {
            IDictionary<string, string> dicts = DictionaryHelper.GetDictionary(SR.CONST_DMS_Authentication_Type);
            IList list = dicts.ToList().FindAll(item => item.Key != DealerAuthorizationType.Normal.ToString());
            return list;
        }

        public DealerContractEditorVO AttachmentStore_Refresh(DealerContractEditorVO model)
        {
            try
            {
                //FolderName
                if (!string.IsNullOrEmpty(model.hiddenId))
                {
                    Guid InstanceId = new Guid(model.hiddenId);
                    int totalCount = 0;
                    DataSet ds = attachBll.GetAttachmentByMainId(InstanceId, (AttachmentType)Enum.Parse(typeof(AttachmentType), "DealerAuthorization"), 0, int.MaxValue, out totalCount);
                    model.DataCount = totalCount;
                    if (ds != null)
                        model.LstAttachmentList = JsonHelper.DataTableToArrayList(ds.Tables[0]);
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
        public DealerContractEditorVO DeleteAttachment(DealerContractEditorVO model)
        {
            try
            {
                attachBll.DelAttachment(new Guid(model.AttachmentId));
                string uploadFile = Server.MapPath("\\Upload\\UploadFile\\" + model.FolderName);
                File.Delete(uploadFile + "\\" + model.fileName);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }
        #endregion

        #region 选择产品分类
        private IProductClassifications bizProductClassification = new ProductClassifications();
        private ICfns bizCFNS = new Cfns();
        public DealerContractEditorVO PartsSelectorInit(DealerContractEditorVO model)
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

        #endregion
        #region 删除医院
        //*****省份联动数据获取********//
        public DealerContractEditorVO DelHospitalInit(DealerContractEditorVO model)
        {
            try
            {
                IList<Territory> Provinces = Store_RefreshProvinces();
                ArrayList res = new ArrayList();
                res.AddRange(Provinces.ToList());
                model.RstResultProvincesList = res;

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

        public DealerContractEditorVO BindCity(DealerContractEditorVO model)
        {
            try
            {
                string parentId = model.parentId;
                IList<Territory> Provinces = Store_RefreshTerritorys(parentId);
                ArrayList res = new ArrayList();
                res.AddRange(Provinces.ToList());
                model.RstResultCityList = res;
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
        public DealerContractEditorVO BindArea(DealerContractEditorVO model)
        {
            try
            {
                string parentId = model.parentId;
                IList<Territory> Provinces = Store_RefreshTerritorys(parentId);
                ArrayList res = new ArrayList();
                res.AddRange(Provinces.ToList());
                model.RstResultAreaList = res;

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
        //*****省份联动数据获取********//

        #endregion

    }
}
