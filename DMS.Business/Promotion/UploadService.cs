using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.OleDb;
using System.IO;
using DMS.DataAccess;
using Lafite.RoleModel.Security;
using Grapecity.DataAccess.Transaction;
using DMS.Model;
using DMS.Model.ViewModel;
using DMS.Common;
using System.Collections;

namespace DMS.Business.Promotion
{
    public class UploadService
    {
        IRoleModelContext _context = RoleModelContext.Current;
        private IPromotionPolicyBLL _business = new PromotionPolicyBLL();

        //public UploadView IsValidRate(UploadView uv)
        //{
        //    TypeFun(UploadView uv);

        //}
        public UploadView IsValidRate(UploadView uv)
        {
            var u = uv.MaintainType;
            if (u == "SecondRate")
            {
                return SecondRate(uv);
            }
            else if (u == "TopVal")
            {
                return TopVal(uv);
            }
            else if (u == "ProTarget")
            {
                return ProTarget(uv);
            }
            else if (u == "Fiexd")
            {
                return Fiexd(uv);
            }
            else
            {
                return uv;
            }
        }
        #region 数据验证

        private UploadView Fiexd(UploadView uv)
        {
            #region 读取文件到中间表
            //导入到中间表
            DataTable dt = GetDataTable(uv.FilePath, uv.SheetName);
            int count = 0;
            int.TryParse(uv.FieldCount, out count);
            //根据列数量判断文件模板是否正确
            if (dt.Columns.Count < count)
            {
                uv.Status = "error";
                uv.Error = "请使用正确的模板";
            }
            else
            {
                if (dt.Rows.Count > 0)
                {
                    if (_business.ProductStandardPriceImport(dt, uv.PID))
                    {
                        string IsValid = string.Empty;
                        if (_business.VerifyStandardPrice(out IsValid))
                        {
                            if (IsValid == "Error")
                            {
                                uv.Status = "error";
                                uv.Error = "数据包含错误或警告信息，请确认后导入！";
                            }
                        }
                    }
                    else
                    {
                        uv.Status = "error";
                        uv.Error = "Excel数据格式错误！";
                    }
                }
                else
                {
                    uv.Status = "error";
                    uv.Error = "没有数据可导入！";
                }
            }
            #endregion
            return uv;
        }

        /// <summary>
        /// 指定产品指标
        /// </summary>
        /// <param name="uv"></param>
        /// <returns></returns>
        private UploadView ProTarget(UploadView uv)
        {
            DataTable dt = GetDataTable(uv.FilePath, uv.SheetName);
            //应该的文件列数
            int count = 0;
            int.TryParse(uv.FieldCount, out count);

            if (dt.Columns.Count < count)
            {

                uv.Status = "error";
                uv.Error = "请使用正确的模板";
            }
            else
            {
                if (dt.Rows.Count > 0)
                {
                    //ProductIndexImport
                    if (ProductIndexImport(dt, uv.PolicyFactorID, uv.PolicyFactorType))
                    {
                        string IsValid = string.Empty;
                        //VerifyProductIndex
                        if (VerifyProductIndex(out IsValid, uv.PolicyFactorType))
                        {
                            if (IsValid == "Error")
                            {
                                uv.Status = "error";
                                uv.Error = "数据包含错误或警告信息，请确认后导入！";
                            }
                        }
                    }
                    else
                    {
                        uv.Status = "error";
                        uv.Error = "Excel数据格式错误！";
                    }
                }
                else
                {
                    uv.Status = "error";
                    uv.Error = "没有数据可导入！";
                }
            }
            return uv;
        }

        /// <summary>
        /// 二级维护验证
        /// </summary>
        /// <param name="uv"></param>
        /// <returns></returns>
        private UploadView SecondRate(UploadView uv)
        {
            DataTable dt = GetDataTable(uv.FilePath, uv.SheetName);
            //应该的文件列数
            int count = 0;
            int.TryParse(uv.FieldCount, out count);

            if (dt.Columns.Count < count)
            {

                uv.Status = "error";
                uv.Error = "请使用正确的模板";
            }
            else
            {
                if (dt.Rows.Count > 0)
                {
                    if (PointRatioImport(dt, uv.PID))
                    {
                        string IsValid = string.Empty;
                        if (VerifyRatioImport(out IsValid))
                        {
                            if (IsValid == "Error")
                            {
                                uv.Status = "error";
                                uv.Error = "数据包含错误或警告信息，请确认后导入！";
                            }
                        }
                    }
                    else
                    {
                        uv.Status = "error";
                        uv.Error = "Excel数据格式错误！";
                    }
                }
                else
                {
                    uv.Status = "error";
                    uv.Error = "没有数据可导入！";
                }
            }
            return uv;
        }

        /// <summary>
        /// 封顶值验证
        /// </summary>
        /// <param name="uv"></param>
        /// <returns></returns>
        private UploadView TopVal(UploadView uv)
        {
            DataTable dt = GetDataTable(uv.FilePath, uv.SheetName);
            //应该的文件列数
            int count = 0;
            int.TryParse(uv.FieldCount, out count);

            if (dt.Columns.Count < count)
            {
                uv.Status = "error";
                uv.Error = "请使用正确的模板";
            }
            else
            {
                if (dt.Rows.Count > 0)
                {
                    if (TopValueImport(dt, uv.PID, uv.TopValType))
                    {
                        string IsValid = string.Empty;
                        if (VerifyTopValue(out IsValid, uv.TopValType))
                        {
                            if (IsValid == "Error")
                            {
                                uv.Status = "error";
                                uv.Error = "数据包含错误或警告信息，请确认后导入！";
                            }
                        }
                    }
                    else
                    {
                        uv.Status = "error";
                        uv.Error = "Excel数据格式错误！";
                    }
                }
                else
                {
                    uv.Status = "error";
                    uv.Error = "没有数据可导入！";
                }
            }
            return uv;
        }
        #endregion


        /// <summary>
        /// 平台到二级加价率
        /// </summary>
        /// <param name="uv"></param>
        /// <returns></returns>

        public UploadView QueryPointRatio(UploadView uv)
        {
            Hashtable obj = new Hashtable();
            obj.Add("CurrUser", _context.User.Id);
            obj.Add("PolicyId", uv.PID);
            DataSet ds = _business.QueryPointRatio(obj);
            uv.Data = JsonHelper.DataTableToArrayList(ds.Tables[0]);
            if (ds.Tables[0].Rows.Count != 0)
            {
                uv.Status = "success";
                uv.Error = "解析成功！";
            }
            else
            {
                uv.Status = "error";
                uv.Error = "解析出错！";
            }
            return uv;
        }
        /// <summary>
        /// 封顶值数据
        /// </summary>
        /// <param name="uv"></param>
        /// <returns></returns>
        public UploadView PolicyTopValue(UploadView uv)
        {

            Hashtable obj = new Hashtable();
            obj.Add("CurrUser", _context.User.Id);
            obj.Add("PolicyId", uv.PID);
            DataSet ds = _business.QueryTopValue(obj);
            uv.Data = JsonHelper.DataTableToArrayList(ds.Tables[0]);
            if (ds.Tables[0].Rows.Count != 0)
            {
                uv.Status = "success";
                uv.Error = "解析成功！";
            }
            else
            {
                uv.Status = "error";
                uv.Error = "解析出错！";
            }

            return uv;
        }
        public UploadView QueryPolicyProductIndxUi(UploadView uv)
        {

            Hashtable obj = new Hashtable();
            obj.Add("PolicyFactorId", uv.PolicyFactorID);
            obj.Add("CurrUser", _context.User.Id);

            //QueryPolicyProductIndxUi
            DataSet ds = _business.QueryPolicyProductIndxUi(obj, uv.PolicyFactorType);
            uv.Data = JsonHelper.DataTableToArrayList(ds.Tables[0]);
            if (ds.Tables[0].Rows.Count != 0)
            {
                uv.Status = "success";
                uv.Error = "解析成功！";
            }
            else
            {
                uv.Status = "error";
                uv.Error = "解析出错！";
            }
            return uv;
        }

        public UploadView QueryStandardPrice(UploadView uv)
        {
            Hashtable obj = new Hashtable();
            obj.Add("PolicyId", uv.PID);
            obj.Add("CurrUser", _context.User.Id);
            DataTable query = _business.QueryStandardPrice(obj).Tables[0];
            uv.Data = JsonHelper.DataTableToArrayList(query);
            if (query.Rows.Count != 0)
            {
                uv.Status = "success";
                uv.Error = "解析成功！";
            }
            else
            {
                uv.Status = "error";
                uv.Error = "解析出错！";
            }
            return uv;
        }
        public UploadView ParseFile(UploadView uv)
        {

            var u = uv.MaintainType;
            if (u == "SecondRate")
            {
                return QueryPointRatio(uv);
            }
            else if (u == "TopVal")
            {
                return PolicyTopValue(uv);
            }
            else if (u == "ProTarget")
            {
                return QueryPolicyProductIndxUi(uv);
            }
            else if(u== "Fiexd")
            {
                return QueryStandardPrice(uv);
            }
            else
            {
                return uv;
            }

        }


        public static DataTable GetDataTable(string filePath, string sheet)
        {
            System.Diagnostics.Debug.WriteLine("GetDataSet Start : " + DateTime.Now.ToString());
            string fileExtention = System.IO.Path.GetExtension(filePath).ToLower();
            string strConn = null;
            string strTable = string.Format("select * from [{0}$]", sheet);
            DataSet ds = new DataSet();

            //if (fileExtention == ".xls")
            //{
            //    strConn = "Provider=Microsoft.Jet.OLEDB.4.0;" + "Data Source=" + filePath + ";" + "Extended Properties=\"Excel 8.0;HDR=NO;IMEX=1;\"";
            //}
            //else if (fileExtention == ".xlsx")
            //{
            //    strConn = "Provider=Microsoft.ACE.OLEDB.12.0;" + "Data Source=" + filePath + ";" + "Extended Properties=\"Excel 12.0;HDR=NO;IMEX=1;\"";
            //}
            strConn = "Provider=Microsoft.ACE.OLEDB.12.0;" + "Data Source=" + filePath + ";" + "Extended Properties=\"Excel 12.0;HDR=NO;IMEX=1;\"";
            using (OleDbConnection conn = new OleDbConnection(strConn))
            {
                conn.Open();
                OleDbDataAdapter adapter = new OleDbDataAdapter(strTable, strConn);
                adapter.Fill(ds, sheet);
                conn.Close();
            }
            System.Diagnostics.Debug.WriteLine("GetDataSet Finish : " + DateTime.Now.ToString());
            return ds.Tables[sheet];
        }

        /// <summary>
        /// 根据上传的文件，读取指定工作表的数据
        /// </summary>
        /// <param name="filePath"></param>
        /// <param name="sheets"></param>
        /// <returns></returns>
        public static DataSet GetDataSet(string filePath, string[] sheets)
        {
            string fileExtention = Path.GetExtension(filePath).ToLower();
            string strConn = null;

            DataSet ds = new DataSet();

            if (fileExtention == ".xls")
            {
                strConn = "Provider=Microsoft.ACE.OLEDB.12.0;" + "Data Source=" + filePath + ";" + "Extended Properties=\"Excel 8.0;HDR=NO;IMEX=1;\"";
            }
            else if (fileExtention == ".xlsx")
            {
                strConn = "Provider=Microsoft.ACE.OLEDB.12.0;" + "Data Source=" + filePath + ";" + "Extended Properties=\"Excel 12.0;HDR=NO;IMEX=1;\"";
            }

            string errMsg = string.Empty;

            using (OleDbConnection conn = new OleDbConnection(strConn))
            {
                try
                {
                    conn.Open();
                    foreach (string sheet in sheets)
                    {
                        try
                        {
                            OleDbDataAdapter adapter = new OleDbDataAdapter("select * from [" + sheet + "$]", strConn);
                            adapter.Fill(ds, sheet);
                        }
                        catch
                        {
                            //throw new Exception(string.Format("上传的文件不包含工作表[{0}]", sheet));
                            errMsg += string.Format("上传的文件不包含工作表[{0}]<br/>", sheet);
                        }
                    }
                    conn.Close();
                }
                catch (Exception ex)
                {
                    throw ex;
                }
            }

            if (!string.IsNullOrEmpty(errMsg))
                throw new Exception(errMsg);

            return ds;
        }


        #region 1.0 积分政策加价率
        public int DeletePolicyPointRatioByUserId()
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                return dao.DeletePolicyPointRatioByUserId(_context.User.Id);
            }
        }
        /// <summary>
        /// 积分政策加价率
        /// </summary>
        public bool PointRatioImport(DataTable dt, string policyId)
        {
            System.Diagnostics.Debug.WriteLine("Import Start : " + DateTime.Now.ToString());
            bool result = false;
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    ProPolicyDao dao = new ProPolicyDao();
                    int lineNbr = 1;
                    string errmsg = "";
                    IList<ProPolicyPointratioUi> list = new List<ProPolicyPointratioUi>();
                    foreach (DataRow dr in dt.Rows)
                    {
                        errmsg = "";
                        //string errString = string.Empty;
                        ProPolicyPointratioUi data = new ProPolicyPointratioUi();
                        data.CurrUser = _context.User.Id;
                        data.CreateTime = DateTime.Now;
                        data.CreateBy = _context.User.Id;

                        //医院名称

                        if (String.IsNullOrEmpty(policyId))
                        {
                            errmsg = "缺少政策编码、";
                        }
                        else
                        {
                            data.PolicyId = Convert.ToInt32(policyId);
                        }

                        data.SapCode = dr[0] == DBNull.Value ? null : dr[0].ToString();
                        data.AccountMonth = dr[1] == DBNull.Value ? null : dr[1].ToString();

                        if (!string.IsNullOrEmpty(dr[2].ToString()))
                        {
                            decimal price;
                            if (!Decimal.TryParse(dr[2].ToString(), out price))
                                errmsg = "加价率格式不正确、";
                            else
                                data.Ratio = Convert.ToDecimal(dr[2].ToString());
                        }
                        else
                        {
                            errmsg = "加价率为空、";
                        }
                        data.Remark1 = dr[3] == DBNull.Value ? null : dr[3].ToString();

                        data.ErrMsg = errmsg == "" ? "" : errmsg.Substring(0, errmsg.Length - 1);
                        if (lineNbr != 1)
                        {
                            list.Add(data);
                        }
                        lineNbr += 1;
                    }
                    dao.BatchPointRatioInsert(list);
                    result = true;

                    trans.Complete();
                }
            }
            catch
            {

            }
            System.Diagnostics.Debug.WriteLine("Import Finish : " + DateTime.Now.ToString());

            return result;
        }
        public bool VerifyRatioImport(out string IsValid)
        {
            System.Diagnostics.Debug.WriteLine("VerifyPointRatio Start : " + DateTime.Now.ToString());
            bool result = false;
            //调用存储过程验证数据
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                IsValid = dao.PointRatioInitialize(new Guid(_context.User.Id));
                result = true;
            }
            System.Diagnostics.Debug.WriteLine("VerifyPointRatio Finish : " + DateTime.Now.ToString());
            return result;
        }
        #endregion



        #region 2.0 封顶值
        public int DeleteTopValueByUserId()
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                return dao.DeleteTopValueByUserId(_context.User.Id);
            }
        }
        public bool TopValueImport(DataTable dt, string policyId, string topValueType)
        {
            System.Diagnostics.Debug.WriteLine("Import Start : " + DateTime.Now.ToString());
            bool result = false;
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    ProPolicyDao dao = new ProPolicyDao();
                    int lineNbr = 1;
                    string errmsg = "";
                    IList<ProPolicyTopvalueUi> list = new List<ProPolicyTopvalueUi>();
                    foreach (DataRow dr in dt.Rows)
                    {
                        errmsg = "";
                        //string errString = string.Empty;
                        ProPolicyTopvalueUi data = new ProPolicyTopvalueUi();
                        data.CurrUser = _context.User.Id;
                        data.CreateTime = DateTime.Now;
                        data.CreateBy = _context.User.Id;

                        //医院名称

                        if (String.IsNullOrEmpty(policyId))
                        {
                            errmsg = "缺少政策编码、";
                        }
                        else
                        {
                            data.PolicyId = Convert.ToInt32(policyId);
                        }

                        data.SAPCode = dr[0] == DBNull.Value ? null : dr[0].ToString();
                        data.HospitalId = dr[2] == DBNull.Value ? null : dr[2].ToString();
                        //TopValueImportdata.Period = dr[4] == DBNull.Value ? null : dr[4].ToString();
                        if (!string.IsNullOrEmpty(dr[4].ToString()))
                        {
                            decimal price;
                            if (!Decimal.TryParse(dr[4].ToString(), out price))
                                errmsg = "封顶值格式不正确、";
                            else if (Decimal.Parse(dr[4].ToString()) < 0)
                                errmsg = "封顶值不能小于0、";
                            else
                                data.TopValue = Convert.ToDecimal(dr[4].ToString());
                        }
                        else
                        {
                            errmsg = "封顶值为空、";
                        }

                        data.ErrMsg = errmsg == "" ? "" : errmsg.Substring(0, errmsg.Length - 1);
                        if (lineNbr != 1)
                        {
                            list.Add(data);
                        }
                        lineNbr += 1;
                    }
                    dao.BatchTopValueInsert(list);
                    result = true;

                    trans.Complete();
                }
            }
            catch
            {

            }
            System.Diagnostics.Debug.WriteLine("Import Finish : " + DateTime.Now.ToString());

            return result;
        }
        public bool VerifyTopValue(out string IsValid, string TopValueType)
        {
            System.Diagnostics.Debug.WriteLine("VerifyTopValue Start : " + DateTime.Now.ToString());
            bool result = false;
            //调用存储过程验证数据
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                IsValid = dao.TopValueInitialize(new Guid(_context.User.Id), TopValueType);
                result = true;
            }
            System.Diagnostics.Debug.WriteLine("VerifyTopValue Finish : " + DateTime.Now.ToString());
            return result;
        }
        #endregion



        #region 3.0 上传指定产品指标
        public void DeleteProductIndexByUserId(string FactId, string PolicyFactorId)
        {
            Hashtable obj = new Hashtable();
            obj.Add("CurrUser", _context.User.Id);
            obj.Add("PolicyFactorId", PolicyFactorId);

            using (ProPolicyDao dao = new ProPolicyDao())
            {
                if (FactId == "6") { dao.DeleteBSCSalesProductIndxUi(obj); }
                else { dao.DeleteInHospitalProductIndxUi(obj); }
            }
        }
        public bool ProductIndexImport(DataTable dt, string policyFactorId, string factType)
        {
            System.Diagnostics.Debug.WriteLine("Import Start : " + DateTime.Now.ToString());
            bool result = false;
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    ProPolicyDao dao = new ProPolicyDao();
                    int lineNbr = 1;
                    string errmsg = "";
                    IList<ProProductIndexUi> list = new List<ProProductIndexUi>();
                    foreach (DataRow dr in dt.Rows)
                    {
                        errmsg = "";
                        //string errString = string.Empty;
                        ProProductIndexUi data = new ProProductIndexUi();
                        data.CurrUser = _context.User.Id;
                        data.CreateTime = DateTime.Now;
                        data.CreateBy = _context.User.Id;

                        //医院名称

                        if (String.IsNullOrEmpty(policyFactorId))
                        {
                            errmsg = "缺少政策因素编码、";
                        }
                        else
                        {
                            data.PolicyFactorId = Convert.ToInt32(policyFactorId);
                        }

                        data.SapCode = dr[0] == DBNull.Value ? null : dr[0].ToString();
                        data.HospitalId = dr[2] == DBNull.Value ? null : dr[2].ToString();
                        data.Period = dr[3] == DBNull.Value ? null : dr[3].ToString();
                        data.TargetLevel = dr[4] == DBNull.Value ? null : dr[4].ToString();
                        if (!string.IsNullOrEmpty(dr[5].ToString()))
                        {
                            decimal price;
                            if (!Decimal.TryParse(dr[5].ToString(), out price))
                                errmsg = "指标格式不正确、";
                            else if (Decimal.Parse(dr[5].ToString()) < 0)
                                errmsg = "指标不能小于0、";
                            else
                                data.TargetValue = Convert.ToDecimal(dr[5].ToString());
                        }
                        else
                        {
                            errmsg = "指标为空、";
                        }

                        data.ErrMsg = errmsg == "" ? "" : errmsg.Substring(0, errmsg.Length - 1);
                        if (lineNbr != 1)
                        {
                            list.Add(data);
                        }
                        lineNbr += 1;
                    }
                    if (factType == "6" || factType == "14")
                    {
                        dao.BatchBSCSalesIndexInsert(list);
                    }
                    if (factType == "7" || factType == "15")
                    {
                        dao.BatchInHospitalSalesIndexInsert(list);
                    }
                    result = true;

                    trans.Complete();
                }
            }
            catch
            {

            }
            System.Diagnostics.Debug.WriteLine("Import Finish : " + DateTime.Now.ToString());

            return result;
        }
        public bool VerifyProductIndex(out string IsValid, string factType)
        {
            System.Diagnostics.Debug.WriteLine("VerifyProductIndex Start : " + DateTime.Now.ToString());
            bool result = false;
            //调用存储过程验证数据
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                IsValid = dao.ProductIndexInitialize(new Guid(_context.User.Id), factType);
                result = true;
            }
            System.Diagnostics.Debug.WriteLine("VerifyProductIndex Finish : " + DateTime.Now.ToString());
            return result;
        }
        #endregion


        #region 固定积分转换率
        public int DeleteProductStandardPriceByUserId()
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                return dao.DeleteProductStandardPriceByUserId(_context.User.Id);
            }
        }

        public bool ProductStandardPriceImport(DataTable dt, string policyId)
        {
            System.Diagnostics.Debug.WriteLine("Import Start : " + DateTime.Now.ToString());
            bool result = false;
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    ProPolicyDao dao = new ProPolicyDao();
                    int lineNbr = 1;
                    string errmsg = "";
                    IList<ProDealerStdPointUi> list = new List<ProDealerStdPointUi>();
                    foreach (DataRow dr in dt.Rows)
                    {
                        errmsg = "";
                        //string errString = string.Empty;
                        ProDealerStdPointUi data = new ProDealerStdPointUi();
                        data.CurrUser = _context.User.Id;
                        data.CreateTime = DateTime.Now;
                        data.CreateBy = _context.User.Id;

                        //医院名称

                        if (String.IsNullOrEmpty(policyId))
                        {
                            errmsg = "缺少政策编码、";
                        }
                        else
                        {
                            data.PolicyId = Convert.ToInt32(policyId);
                        }

                        data.SapCode = dr[0] == DBNull.Value ? null : dr[0].ToString();

                        if (!string.IsNullOrEmpty(dr[1].ToString()))
                        {
                            decimal price;
                            if (!Decimal.TryParse(dr[1].ToString(), out price))
                                errmsg = "补偿金额格式填写不正确、";
                            else
                                data.Points = Convert.ToDecimal(dr[1].ToString());
                        }
                        else
                        {
                            errmsg = "补偿金额为空、";
                        }

                        data.ErrMsg = errmsg == "" ? "" : errmsg.Substring(0, errmsg.Length - 1);
                        if (lineNbr != 1)
                        {
                            list.Add(data);
                        }
                        lineNbr += 1;
                    }
                    dao.BatchStandardPriceInsert(list);
                    result = true;

                    trans.Complete();
                }
            }
            catch
            {

            }
            System.Diagnostics.Debug.WriteLine("Import Finish : " + DateTime.Now.ToString());

            return result;
        }

        public bool VerifyStandardPrice(out string IsValid)
        {
            System.Diagnostics.Debug.WriteLine("VerifyStandardPrice Start : " + DateTime.Now.ToString());
            bool result = false;
            //调用存储过程验证数据
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                IsValid = dao.StandardPriceInitialize(new Guid(_context.User.Id));
                result = true;
            }
            System.Diagnostics.Debug.WriteLine("VerifyStandardPrice Finish : " + DateTime.Now.ToString());
            return result;
        }
        #endregion


        public int DeletePolicyAttachment(string Id)
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                return dao.DeletePolicyAttachment(Id);
            }
        }
        /// <summary>
        /// 新增政策附件信息
        /// </summary>
        public void InsertPolicyAttachment(Hashtable obj)
        {
            using (ProPolicyDao dao = new ProPolicyDao())
            {
                dao.InsertPolicyAttachment(obj);
            }
        }
    }
}
