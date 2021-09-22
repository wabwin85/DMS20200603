using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Grapecity.Logging.CallHandlers;
using Lafite.RoleModel.Security;
using Lafite.RoleModel.Security.Authorization;
using Grapecity.DataAccess.Transaction;
using DMS.Common;
using DMS.Model;
using DMS.DataAccess;
using System.Data;
using System.Collections;
using DMS.Model.Data;
using DMS.ViewModel.Common;
using DMS.ViewModel.MasterDatas;

namespace DMS.Business
{
    /// <summary>
    /// 授权维护
    /// </summary>
    public class PositionHospitalBLL : BaseBusiness, IPositionHospital
    {
        private IRoleModelContext _context = RoleModelContext.Current;
        HospitalPositionInitDao _initDao = new HospitalPositionInitDao();
        #region Action Define
        public const string Action_PositionHospital = "PositionHospital";
        #endregion

        public DataSet ExportHospitalPosition(string positionID)
        {
            using (PositionHospitalDao dao = new PositionHospitalDao())
            {
                return dao.ExportHospitalPosition(positionID);
            }
        }
        public DataSet SelectOrgsForPositionHospital(string attributeId)
        {
            using (PositionHospitalDao dao = new PositionHospitalDao())
            {
                return dao.SelectOrgsForPositionHospital(attributeId);
            }
        }
        public DataSet SelectHospitalPosition_ValidByFilter(string positionID, int start, int limit, out int rowCount)
        {
            using (PositionHospitalDao dao = new PositionHospitalDao())
            {
                return dao.SelectHospitalPosition_ValidByFilter(positionID,start,limit,out rowCount);
            }
        }

        public bool SaveHospitalPositionMapChanges(ChangeRecords<View_HospitalPosition> data)
        {
            bool success = false;
            using (TransactionScope trans = new TransactionScope())
            {
                using (PositionHospitalDao dao = new PositionHospitalDao())
                {
                    if (data.Created != null && data.Created.Count > 0)
                    {
                        foreach (var model in data.Created)
                        {
                            Hashtable obj = new Hashtable();
                            obj.Add("HPM_ID", model.ID);
                            obj.Add("HPM_PositionID", model.PositionID);
                            obj.Add("HPM_HospitalID", model.HospitalID);
                            obj.Add("HPM_ProductLineID", model.ProductLineID);
                            obj.Add("HPM_CreateDate", DateTime.Now);
                            dao.InsertHospitalPosition(obj);
                        }
                    }
                    if (data.Deleted != null && data.Deleted.Count > 0)
                    {
                        foreach (var model in data.Deleted)
                        {
                            dao.DeleteHospitalPosition(model.ID.ToString());
                        }
                    }
                    success = true;
                    trans.Complete();
                    return success;
                }
            }
        }


        #region Upload  Excel info
        void IPositionHospital.DeleteUploadInfoByUser()
        {
            using (HospitalPositionInitDao dao = new HospitalPositionInitDao())
            {
                dao.DeleteHospitalPositionInitByUser(new Guid(_context.User.Id));
            }

        }
        void IPositionHospital.UploadInfoVerify(int IsImport, out string RtnVal, out string RtnMsg)
        {
            System.Diagnostics.Debug.WriteLine("Verify Start : " + DateTime.Now.ToString());
            //调用存储过程验证数据
            _initDao.HospitalPositionInitVerify(new Guid(_context.User.Id), IsImport, out RtnVal, out RtnMsg);
            System.Diagnostics.Debug.WriteLine("Verify Finish : " + DateTime.Now.ToString());
        }
        bool IPositionHospital.UploadInfoImport(DataTable dt, string fileName)
        {
            System.Diagnostics.Debug.WriteLine("Import Start : " + DateTime.Now.ToString());
            bool result = true;

            using (TransactionScope trans = new TransactionScope())
            {
                HospitalPositionInitDao _initDao2 = new HospitalPositionInitDao();                
                int lineNbr = 2;
                IList<HospitalPositionInit> list = new List<HospitalPositionInit>();
                ////第一条是表头数据，过滤
                dt.Rows.RemoveAt(0);
                foreach (DataRow dr in dt.Rows)
                {
                    HospitalPositionInit data = new HospitalPositionInit();
                    data.Id = Guid.NewGuid();
                    data.LineNbr = lineNbr++;
                    data.ImportDate = DateTime.Now;
                    data.ImportUser = new Guid(_context.User.Id);
                    data.IsError = false;

                    data.HospitalCode = dr["医院编码"] == DBNull.Value ? string.Empty : dr["医院编码"].ToString().Trim();
                    if (string.IsNullOrEmpty(data.HospitalCode.Trim()))
                        data.ErrorMsg = data.ErrorMsg + "医院编码必须填写,";
                
                    if (!string.IsNullOrEmpty(data.ErrorMsg))
                    {
                        data.IsError = true;
                        result = false;
                    }

                    if (data.LineNbr != 1)
                    {
                        list.Add(data);
                    }
                }
                _initDao2.BatchHospitalPositionInitInsert(list);

                trans.Complete();
            }
            System.Diagnostics.Debug.WriteLine("Import Finish : " + DateTime.Now.ToString());

            return result;
        }
        DataSet IPositionHospital.QueryUploadInfo(Hashtable table, int start, int limit, out int totalRowCount)
        {            
                return _initDao.QueryHospitalPositionInitData(table, start, limit, out totalRowCount);          
        }
        #endregion
    }
}
