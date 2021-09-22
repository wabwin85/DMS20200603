using System;
using System.Collections;
using DMS.Common.Common;
using DMS.Common;
using DMS.ViewModel.MasterDatas;
using System.Linq;
using System.Data;
using DMS.Business;
using DMS.ViewModel.Common;
using Lafite.RoleModel.Security;
using Newtonsoft.Json;
using System.Collections.Specialized;
using DMS.Common.Extention;
using DMS.Business.Excel;

namespace DMS.BusinessService.MasterDatas
{
    public class PositionHospitalService : ABaseQueryService, IQueryExport
    {
        #region Ajax Method

        private static DataTable allOrgs = null;
        public PositionHospitalVO GetPositionOrgs(PositionHospitalVO model)
        {
            try
            {
                string id = model.AttributeID;
                IPositionHospital bllPositionHospital = new PositionHospitalBLL();
                DataTable dtResult = new DataTable();
                if (string.IsNullOrEmpty(id) || allOrgs == null)
                {
                    DataSet dsAllOrgs = bllPositionHospital.SelectOrgsForPositionHospital(id);
                    if (dsAllOrgs.Tables.Count > 0)
                    {
                        allOrgs = dsAllOrgs.Tables[0];
                        var authProductLine = GetProductLine(true);
                        string[] arrProductLine =
                            authProductLine.Where(item => !string.IsNullOrEmpty(item.Key))
                                .Select(o => "'" + o.Key.ToString() + "'")
                                .ToArray();
                        string strProductLines = string.Join(",", arrProductLine);
                        DataView dvAllOrgs = allOrgs.DefaultView;
                        dvAllOrgs.RowFilter = " AttributeType='Product_Line' AND AttributeID IN (" + strProductLines + ")";
                        dvAllOrgs.Sort = "AttributeName";
                        dtResult = dvAllOrgs.ToTable();
                    }
                }
                else
                {
                    DataView dvAllOrgs = allOrgs.DefaultView;
                    dvAllOrgs.RowFilter = " ParentID='" + id + "'";
                    dvAllOrgs.Sort = "AttributeName";
                    dtResult = dvAllOrgs.ToTable();
                }
                model.PositionOrgs = JsonHelper.DataTableToArrayList(dtResult);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public string GetHospitalPosition(PositionHospitalVO model)
        {
            try
            {
                int outCont = 0;
                int start = (model.Page - 1) * model.PageSize;
                IPositionHospital bllPositionHospital = new PositionHospitalBLL();
                if (!string.IsNullOrEmpty(model.PositionID))
                {
                    model.HospitalPositions =
                        JsonHelper.DataTableToArrayList(
                            bllPositionHospital.SelectHospitalPosition_ValidByFilter(model.PositionID, start,
                                model.PageSize,
                                out outCont).Tables[0]);
                    model.DataCount = outCont;
                }
                else
                {
                    model.HospitalPositions = null;
                    model.DataCount = 0;
                }
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            var data = new { data = model.HospitalPositions, total = model.DataCount };
            var result = new { success = model.IsSuccess, data = data };
            return JsonHelper.Serialize(result);
        }

        public PositionHospitalVO SaveHospitalPositionMapChanges(PositionHospitalVO model)
        {
            try
            {
                IPositionHospital bllPositionHospital = new PositionHospitalBLL();
                model.IsSuccess = bllPositionHospital.SaveHospitalPositionMapChanges(model.HospitalPosition_ChangeRecords);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }



        public string QueryUploadPositionHospitalInfo(PositionHospitalVO model)
        {
            try
            {
                int totalCount = 0;

                Hashtable param = new Hashtable();
                param.Add("UserId", new Guid(RoleModelContext.Current.User.Id));
                IPositionHospital bll = new PositionHospitalBLL();

                int start = (model.Page - 1) * model.PageSize;
                model.RstUploadInfo = JsonHelper.DataTableToArrayList(bll.QueryUploadInfo(param, start, model.PageSize, out totalCount).Tables[0]);

                model.DataCount = totalCount;
                model.IsSuccess = true;
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }

            var data = new { data = model.RstUploadInfo, total = model.DataCount };
            var result = new { success = model.IsSuccess, data = data };
            return JsonConvert.SerializeObject(result);
        }
        #endregion

        #region 下载
        public void Export(NameValueCollection Parameters, string DownloadCookie)
        {
            IPositionHospital business = new PositionHospitalBLL();
            string positionID = "";
            if (!string.IsNullOrEmpty(Parameters["PositionID"].ToSafeString()))
            {
                positionID = Parameters["PositionID"].ToSafeString();
            }
            int r = 0;
            DataSet ds = business.ExportHospitalPosition(positionID);
            if (ds != null)
            {
                DataTable dt = ds.Tables[0];
                DataSet[] result = new DataSet[1];
                result[0] = new DataSet();
                result[0].Tables.Add(dt.Copy());

                Hashtable ht = new Hashtable();
                XlsExport xlsExport = new XlsExport("ExportFile");
                xlsExport.Export(ht, result, DownloadCookie);
            }

        }
        #endregion
    }
}
