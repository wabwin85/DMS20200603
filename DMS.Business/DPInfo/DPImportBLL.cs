using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using Grapecity.DataAccess.Transaction;
using Lafite.RoleModel.Security;
using DMS.DataAccess;
using System.Collections;
using DMS.Model;

namespace DMS.Business.DPInfo
{
    public class DPImportBLL
    {
        private IRoleModelContext _context = RoleModelContext.Current;

        #region Pay

        public bool ImportDPPay(DataTable dt)
        {
            System.Diagnostics.Debug.WriteLine("Import Start : " + DateTime.Now.ToString());
            bool result = false;
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    DPImportDao dao = new DPImportDao();
                    //删除上传人的数据
                    dao.DeleteDPPayImportByUser(_context.User.Id);

                    int lineNbr = 1;
                    decimal num;
                    IList<Hashtable> list = new List<Hashtable>();
                    foreach (DataRow dr in dt.Rows)
                    {
                        //string errString = string.Empty;
                        Hashtable data = new Hashtable();
                        data["ImportUser"] = new Guid(_context.User.Id);
                        data["ImportTime"] = DateTime.Now;
                        data["LineNum"] = lineNbr;
                        //data.ErrorDesc = "";
                        String errorDesc = "";

                        //DealerCode
                        data["DealerCode"] = dr[0] == DBNull.Value ? null : dr[0].ToString().Trim();
                        if (data["DealerCode"] == null || string.IsNullOrEmpty(data["DealerCode"].ToString()))
                        {
                            errorDesc += "客户编码为空;";
                        }
                        data["DealerId"] = DBNull.Value;

                        String PayCredit = dr[2] == DBNull.Value ? null : dr[2].ToString().Trim();
                        if (string.IsNullOrEmpty(PayCredit) || PayCredit == "0")
                        {
                            data["PayCredit"] = "-";
                        }
                        else
                        {
                            if (Decimal.TryParse(PayCredit, out num))
                            {
                                data["PayCredit"] = string.Format("{0:n}", num);
                            }
                            else
                            {
                                data["PayCredit"] = PayCredit;
                            }
                        }
                        data["PayCycle"] = dr[3] == DBNull.Value ? null : dr[3].ToString().Trim();
                        data["PayContact"] = dr[4] == DBNull.Value ? null : dr[4].ToString().Trim();
                        data["PayDealerType"] = dr[5] == DBNull.Value ? null : dr[5].ToString().Trim();
                        String PayAmount = dr[6] == DBNull.Value ? null : dr[6].ToString().Trim();
                        if (string.IsNullOrEmpty(PayAmount) || PayAmount == "0")
                        {
                            data["PayAmount"] = "-";
                        }
                        else
                        {
                            if (Decimal.TryParse(PayAmount, out num))
                            {
                                data["PayAmount"] = string.Format("{0:n}", num);
                            }
                            else
                            {
                                data["PayAmount"] = PayAmount;
                            }
                        }
                        String PayIn = dr[7] == DBNull.Value ? null : dr[7].ToString().Trim();
                        if (string.IsNullOrEmpty(PayIn) || PayIn == "0")
                        {
                            data["PayIn"] = "-";
                        }
                        else
                        {
                            if (Decimal.TryParse(PayIn, out num))
                            {
                                data["PayIn"] = string.Format("{0:n}", num);
                            }
                            else
                            {
                                data["PayIn"] = PayIn;
                            }
                        }
                        String Pay0 = dr[8] == DBNull.Value ? null : dr[8].ToString().Trim();
                        if (string.IsNullOrEmpty(Pay0) || Pay0 == "0")
                        {
                            data["Pay0"] = "-";
                        }
                        else
                        {
                            if (Decimal.TryParse(Pay0, out num))
                            {
                                data["Pay0"] = string.Format("{0:n}", num);
                            }
                            else
                            {
                                data["Pay0"] = Pay0;
                            }
                        }
                        String Pay31 = dr[9] == DBNull.Value ? null : dr[9].ToString().Trim();
                        if (string.IsNullOrEmpty(Pay31) || Pay31 == "0")
                        {
                            data["Pay31"] = "-";
                        }
                        else
                        {
                            if (Decimal.TryParse(Pay31, out num))
                            {
                                data["Pay31"] = string.Format("{0:n}", num);
                            }
                            else
                            {
                                data["Pay31"] = Pay31;
                            }
                        }
                        String Pay61 = dr[10] == DBNull.Value ? null : dr[10].ToString().Trim();
                        if (string.IsNullOrEmpty(Pay61) || Pay61 == "0")
                        {
                            data["Pay61"] = "-";
                        }
                        else
                        {
                            if (Decimal.TryParse(Pay61, out num))
                            {
                                data["Pay61"] = string.Format("{0:n}", num);
                            }
                            else
                            {
                                data["Pay61"] = Pay61;
                            }
                        }
                        String Pay91 = dr[11] == DBNull.Value ? null : dr[11].ToString().Trim();
                        if (string.IsNullOrEmpty(Pay91) || Pay91 == "0")
                        {
                            data["Pay91"] = "-";
                        }
                        else
                        {
                            if (Decimal.TryParse(Pay91, out num))
                            {
                                data["Pay91"] = string.Format("{0:n}", num);
                            }
                            else
                            {
                                data["Pay91"] = Pay91;
                            }
                        }
                        String Pay181 = dr[12] == DBNull.Value ? null : dr[12].ToString().Trim();
                        if (string.IsNullOrEmpty(Pay181) || Pay181 == "0")
                        {
                            data["Pay181"] = "-";
                        }
                        else
                        {
                            if (Decimal.TryParse(Pay181, out num))
                            {
                                data["Pay181"] = string.Format("{0:n}", num);
                            }
                            else
                            {
                                data["Pay181"] = Pay181;
                            }
                        }
                        String Pay361 = dr[13] == DBNull.Value ? null : dr[13].ToString().Trim();
                        if (string.IsNullOrEmpty(Pay361) || Pay361 == "0")
                        {
                            data["Pay361"] = "-";
                        }
                        else
                        {
                            if (Decimal.TryParse(Pay361, out num))
                            {
                                data["Pay361"] = string.Format("{0:n}", num);
                            }
                            else
                            {
                                data["Pay361"] = Pay361;
                            }
                        }

                        data["ErrorDesc"] = errorDesc;
                        data["ErrorFlag"] = !string.IsNullOrEmpty(errorDesc);

                        if (lineNbr != 1)
                        {
                            list.Add(data);
                        }
                        lineNbr++;
                    }
                    dao.BatchInsertDPPayImport(list);
                    result = true;

                    trans.Complete();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine(ex);
            }
            System.Diagnostics.Debug.WriteLine("Import Finish : " + DateTime.Now.ToString());

            return result;
        }

        public bool VerifyDPPay(String version, out string IsValid)
        {
            bool result = false;
            //调用存储过程验证数据
            using (DPImportDao dao = new DPImportDao())
            {
                IsValid = dao.ProcImportDPPay(new Guid(_context.User.Id), version);
                result = true;
            }
            return result;
        }

        public DataSet GetImportDPPayByCondition(Hashtable obj, int start, int limit, out int totalCount)
        {
            using (DPImportDao dao = new DPImportDao())
            {
                return dao.SelectImportDPPayByCondition(obj, start, limit, out totalCount);
            }
        }

        #endregion

        #region Audit

        public bool ImportDPAudit(DataTable dt)
        {
            System.Diagnostics.Debug.WriteLine("Import Start : " + DateTime.Now.ToString());
            bool result = false;
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    DPImportDao dao = new DPImportDao();
                    //删除上传人的数据
                    dao.DeleteDPImportHead(_context.User.Id, "DPAudit");
                    dao.DeleteDPImportLine(_context.User.Id, "DPAudit");

                    int lineNbr = 1;
                    IList<Hashtable> list = new List<Hashtable>();
                    foreach (DataRow dr in dt.Rows)
                    {
                        if ((dr[0] == null || String.IsNullOrEmpty(dr[0].ToString()))
                            && (dr[1] == null || String.IsNullOrEmpty(dr[1].ToString()))
                            && (dr[2] == null || String.IsNullOrEmpty(dr[2].ToString()))
                            && (dr[3] == null || String.IsNullOrEmpty(dr[3].ToString()))
                            && (dr[4] == null || String.IsNullOrEmpty(dr[4].ToString()))
                            && (dr[5] == null || String.IsNullOrEmpty(dr[5].ToString()))
                            && (dr[6] == null || String.IsNullOrEmpty(dr[6].ToString()))
                            && (dr[7] == null || String.IsNullOrEmpty(dr[7].ToString()))
                            && (dr[8] == null || String.IsNullOrEmpty(dr[8].ToString()))
                            && (dr[9] == null || String.IsNullOrEmpty(dr[9].ToString()))
                            && (dr[10] == null || String.IsNullOrEmpty(dr[10].ToString()))
                            && (dr[11] == null || String.IsNullOrEmpty(dr[11].ToString()))
                            && (dr[12] == null || String.IsNullOrEmpty(dr[12].ToString()))
                            && (dr[13] == null || String.IsNullOrEmpty(dr[13].ToString()))
                            && (dr[14] == null || String.IsNullOrEmpty(dr[14].ToString()))
                            && (dr[15] == null || String.IsNullOrEmpty(dr[15].ToString()))
                            && (dr[16] == null || String.IsNullOrEmpty(dr[16].ToString())))
                        {
                            lineNbr++;
                            continue;
                        }

                        //string errString = string.Empty;
                        Hashtable data = new Hashtable();
                        data["HeadId"] = Guid.NewGuid();
                        data["ImportUser"] = new Guid(_context.User.Id);
                        data["ImportType"] = "DPAudit";
                        data["ImportTime"] = DateTime.Now;
                        data["LineNum"] = lineNbr;
                        String errorDesc = "";

                        //DealerCode
                        data["DealerCode"] = dr[1] == DBNull.Value ? null : dr[1].ToString().Trim();
                        if (data["DealerCode"] == null || string.IsNullOrEmpty(data["DealerCode"].ToString()))
                        {
                            errorDesc += "客户编码为空;";
                        }
                        data["DealerId"] = DBNull.Value;

                        data["Column1"] = dr[0] == DBNull.Value ? null : dr[0].ToString().Trim();
                        data["Column2"] = dr[3] == DBNull.Value ? null : dr[3].ToString().Trim();
                        data["Column3"] = dr[4] == DBNull.Value ? null : dr[4].ToString().Trim();
                        data["Column4"] = dr[5] == DBNull.Value ? null : dr[5].ToString().Trim();
                        data["Column5"] = dr[6] == DBNull.Value ? null : dr[6].ToString().Trim();
                        data["Column6"] = dr[7] == DBNull.Value ? null : dr[7].ToString().Trim();
                        data["Column7"] = dr[8] == DBNull.Value ? null : dr[8].ToString().Trim();
                        data["Column8"] = dr[9] == DBNull.Value ? null : dr[9].ToString().Trim();
                        data["Column9"] = dr[10] == DBNull.Value ? null : dr[10].ToString().Trim();
                        data["Column10"] = dr[11] == DBNull.Value ? null : dr[11].ToString().Trim();
                        data["Column11"] = dr[12] == DBNull.Value ? null : dr[12].ToString().Trim();
                        data["Column12"] = dr[13] == DBNull.Value ? null : dr[13].ToString().Trim();
                        data["Column13"] = dr[14] == DBNull.Value ? null : dr[14].ToString().Trim();
                        data["Column14"] = dr[15] == DBNull.Value ? null : dr[15].ToString().Trim();
                        data["Column15"] = dr[16] == DBNull.Value ? null : dr[16].ToString().Trim();

                        data["ErrorDesc"] = errorDesc;
                        data["ErrorFlag"] = !string.IsNullOrEmpty(errorDesc);

                        if (lineNbr != 1)
                        {
                            list.Add(data);
                        }
                        lineNbr++;
                    }
                    dao.BatchInsertDPImportHead(list);
                    result = true;

                    trans.Complete();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine(ex);
            }
            System.Diagnostics.Debug.WriteLine("Import Finish : " + DateTime.Now.ToString());

            return result;
        }

        public bool VerifyDPAudit(out string IsValid)
        {
            bool result = false;
            //调用存储过程验证数据
            using (DPImportDao dao = new DPImportDao())
            {
                IsValid = dao.ProcImportDPAudit(new Guid(_context.User.Id), "DPAudit");
                result = true;
            }
            return result;
        }

        #endregion

        #region Train

        public bool ImportDPTrain(DataTable dt)
        {
            System.Diagnostics.Debug.WriteLine("Import Start : " + DateTime.Now.ToString());
            bool result = false;
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    DPImportDao dao = new DPImportDao();
                    //删除上传人的数据
                    dao.DeleteDPTrainImportByUser(_context.User.Id);

                    int lineNbr = 1;
                    IList<Hashtable> list = new List<Hashtable>();
                    foreach (DataRow dr in dt.Rows)
                    {
                        if ((dr[0] == null || String.IsNullOrEmpty(dr[0].ToString()))
                            && (dr[1] == null || String.IsNullOrEmpty(dr[1].ToString()))
                            && (dr[2] == null || String.IsNullOrEmpty(dr[2].ToString()))
                            && (dr[3] == null || String.IsNullOrEmpty(dr[3].ToString()))
                            && (dr[4] == null || String.IsNullOrEmpty(dr[4].ToString()))
                            && (dr[5] == null || String.IsNullOrEmpty(dr[5].ToString()))
                            && (dr[6] == null || String.IsNullOrEmpty(dr[6].ToString()))
                            && (dr[7] == null || String.IsNullOrEmpty(dr[7].ToString()))
                            && (dr[8] == null || String.IsNullOrEmpty(dr[8].ToString()))
                            && (dr[9] == null || String.IsNullOrEmpty(dr[9].ToString()))
                            && (dr[10] == null || String.IsNullOrEmpty(dr[10].ToString()))
                            && (dr[11] == null || String.IsNullOrEmpty(dr[11].ToString()))
                            && (dr[12] == null || String.IsNullOrEmpty(dr[12].ToString()))
                            && (dr[13] == null || String.IsNullOrEmpty(dr[13].ToString()))
                            && (dr[14] == null || String.IsNullOrEmpty(dr[14].ToString()))
                            && (dr[15] == null || String.IsNullOrEmpty(dr[15].ToString())))
                        {
                            lineNbr++;
                            continue;
                        }

                        //string errString = string.Empty;
                        Hashtable data = new Hashtable();
                        data["ImportUser"] = new Guid(_context.User.Id);
                        data["ImportTime"] = DateTime.Now;
                        data["LineNum"] = lineNbr;
                        //data.ErrorDesc = "";
                        String errorDesc = "";

                        //DealerCode
                        data["DealerCode"] = dr[9] == DBNull.Value ? null : dr[9].ToString().Trim();
                        if (data["DealerCode"] == null || string.IsNullOrEmpty(data["DealerCode"].ToString()))
                        {
                            errorDesc += "客户编码为空;";
                        }
                        data["DealerId"] = DBNull.Value;

                        data["TrainDate"] = dr[0] == DBNull.Value ? null : dr[0].ToString().Trim();
                        data["TrainTime"] = dr[1] == DBNull.Value ? null : dr[1].ToString().Trim();
                        data["TrainDuration"] = dr[2] == DBNull.Value ? null : dr[2].ToString().Trim();
                        data["TrainType"] = dr[3] == DBNull.Value ? null : dr[3].ToString().Trim();
                        data["TrainOrg"] = dr[4] == DBNull.Value ? null : dr[4].ToString().Trim();
                        data["TrainProject"] = dr[5] == DBNull.Value ? null : dr[5].ToString().Trim();
                        data["TrainFunction"] = dr[6] == DBNull.Value ? null : dr[6].ToString().Trim();
                        data["TrainContent"] = dr[7] == DBNull.Value ? null : dr[7].ToString().Trim();
                        data["TrainTeacher"] = dr[8] == DBNull.Value ? null : dr[8].ToString().Trim();
                        data["TrainSales"] = dr[11] == DBNull.Value ? null : dr[11].ToString().Trim();
                        data["TrainPosition"] = dr[12] == DBNull.Value ? null : dr[12].ToString().Trim();
                        data["TrainPhone"] = dr[13] == DBNull.Value ? null : dr[13].ToString().Trim();
                        data["TrainHospCode"] = dr[13] == DBNull.Value ? null : dr[14].ToString().Trim();
                        data["TrainHospName"] = dr[13] == DBNull.Value ? null : dr[15].ToString().Trim();

                        data["ErrorDesc"] = errorDesc;
                        data["ErrorFlag"] = !string.IsNullOrEmpty(errorDesc);

                        if (lineNbr > 8)
                        {
                            list.Add(data);
                        }
                        lineNbr++;
                    }
                    dao.BatchInsertDPTrainImport(list);
                    result = true;

                    trans.Complete();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine(ex);
            }
            System.Diagnostics.Debug.WriteLine("Import Finish : " + DateTime.Now.ToString());

            return result;
        }

        public bool VerifyDPTrain(out string IsValid)
        {
            bool result = false;
            //调用存储过程验证数据
            using (DPImportDao dao = new DPImportDao())
            {
                IsValid = dao.ProcImportDPTrain(new Guid(_context.User.Id));
                result = true;
            }
            return result;
        }

        public DataSet GetImportDPTrainByCondition(Hashtable obj, int start, int limit, out int totalCount)
        {
            using (DPImportDao dao = new DPImportDao())
            {
                return dao.SelectImportDPTrainByCondition(obj, start, limit, out totalCount);
            }
        }

        #endregion

        #region Prize

        public bool ImportDPPrize(DataTable dt)
        {
            System.Diagnostics.Debug.WriteLine("Import Start : " + DateTime.Now.ToString());
            bool result = false;
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    DPImportDao dao = new DPImportDao();
                    //删除上传人的数据
                    dao.DeleteDPPrizeImportByUser(_context.User.Id);

                    int lineNbr = 1;
                    IList<Hashtable> list = new List<Hashtable>();
                    foreach (DataRow dr in dt.Rows)
                    {
                        if ((dr[0] == null || String.IsNullOrEmpty(dr[0].ToString()))
                            && (dr[1] == null || String.IsNullOrEmpty(dr[1].ToString()))
                            && (dr[2] == null || String.IsNullOrEmpty(dr[2].ToString()))
                            && (dr[3] == null || String.IsNullOrEmpty(dr[3].ToString()))
                            && (dr[4] == null || String.IsNullOrEmpty(dr[4].ToString()))
                            && (dr[5] == null || String.IsNullOrEmpty(dr[5].ToString())))
                        {
                            lineNbr++;
                            continue;
                        }

                        //string errString = string.Empty;
                        Hashtable data = new Hashtable();
                        data["ImportUser"] = new Guid(_context.User.Id);
                        data["ImportTime"] = DateTime.Now;
                        data["LineNum"] = lineNbr;
                        //data.ErrorDesc = "";
                        String errorDesc = "";

                        //DealerCode
                        data["DealerCode"] = dr[0] == DBNull.Value ? null : dr[0].ToString().Trim();
                        if (data["DealerCode"] == null || string.IsNullOrEmpty(data["DealerCode"].ToString()))
                        {
                            errorDesc += "客户编码为空;";
                        }
                        data["DealerId"] = DBNull.Value;

                        data["PrizeName"] = dr[2] == DBNull.Value ? null : dr[2].ToString().Trim();
                        data["PrizeYear"] = dr[3] == DBNull.Value ? null : dr[3].ToString().Trim();
                        data["PrizeLevel"] = dr[4] == DBNull.Value ? null : dr[4].ToString().Trim();
                        data["PrizeReason"] = dr[5] == DBNull.Value ? null : dr[5].ToString().Trim();

                        data["ErrorDesc"] = errorDesc;
                        data["ErrorFlag"] = !string.IsNullOrEmpty(errorDesc);

                        if (lineNbr != 1)
                        {
                            list.Add(data);
                        }
                        lineNbr++;
                    }
                    dao.BatchInsertDPPrizeImport(list);
                    result = true;

                    trans.Complete();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine(ex);
            }
            System.Diagnostics.Debug.WriteLine("Import Finish : " + DateTime.Now.ToString());

            return result;
        }

        public bool VerifyDPPrize(out string IsValid)
        {
            bool result = false;
            //调用存储过程验证数据
            using (DPImportDao dao = new DPImportDao())
            {
                IsValid = dao.ProcImportDPPrize(new Guid(_context.User.Id));
                result = true;
            }
            return result;
        }

        public DataSet GetImportDPPrizeByCondition(Hashtable obj, int start, int limit, out int totalCount)
        {
            using (DPImportDao dao = new DPImportDao())
            {
                return dao.SelectImportDPPrizeByCondition(obj, start, limit, out totalCount);
            }
        }

        #endregion

        #region Satisfy

        public bool ImportDPSatisfy(DataTable dt)
        {
            System.Diagnostics.Debug.WriteLine("Import Start : " + DateTime.Now.ToString());
            bool result = false;
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    DPImportDao dao = new DPImportDao();
                    //删除上传人的数据
                    dao.DeleteDPSatisfyImportByUser(_context.User.Id);

                    int lineNbr = 1;
                    IList<Hashtable> list = new List<Hashtable>();
                    foreach (DataRow dr in dt.Rows)
                    {
                        if ((dr[7] == null || String.IsNullOrEmpty(dr[7].ToString()))
                            && (dr[12] == null || String.IsNullOrEmpty(dr[12].ToString())))
                        {
                            lineNbr++;
                            continue;
                        }

                        //string errString = string.Empty;
                        Hashtable data = new Hashtable();
                        data["ImportUser"] = new Guid(_context.User.Id);
                        data["ImportTime"] = DateTime.Now;
                        data["LineNum"] = lineNbr;
                        //data.ErrorDesc = "";
                        String errorDesc = "";

                        //DealerCode
                        data["DealerCode"] = dr[7] == DBNull.Value ? null : dr[7].ToString().Trim();
                        if (data["DealerCode"] == null || string.IsNullOrEmpty(data["DealerCode"].ToString()))
                        {
                            errorDesc += "客户编码为空;";
                        }
                        data["DealerId"] = DBNull.Value;

                        //ProductLine
                        data["ProductLine"] = dr[12] == DBNull.Value ? null : dr[12].ToString().Trim();
                        if (data["ProductLine"] == null || string.IsNullOrEmpty(data["ProductLine"].ToString()))
                        {
                            errorDesc += "合作产品线为空;";
                        }

                        data["Question1"] = dr[14] == DBNull.Value ? null : dr[14].ToString().Trim();
                        data["QuestionComment1"] = dr[15] == DBNull.Value ? null : dr[15].ToString().Trim();
                        data["Question2"] = dr[16] == DBNull.Value ? null : dr[16].ToString().Trim();
                        data["QuestionComment2"] = dr[17] == DBNull.Value ? null : dr[17].ToString().Trim();
                        data["Question3"] = dr[18] == DBNull.Value ? null : dr[18].ToString().Trim();
                        data["QuestionComment3"] = dr[18] == DBNull.Value ? null : dr[19].ToString().Trim();
                        data["Question4"] = dr[20] == DBNull.Value ? null : dr[20].ToString().Trim();
                        data["QuestionComment4"] = dr[21] == DBNull.Value ? null : dr[21].ToString().Trim();
                        data["Question5"] = dr[22] == DBNull.Value ? null : dr[22].ToString().Trim();
                        data["QuestionComment5"] = dr[23] == DBNull.Value ? null : dr[23].ToString().Trim();
                        data["Question6"] = dr[24] == DBNull.Value ? null : dr[24].ToString().Trim();
                        data["QuestionComment6"] = dr[25] == DBNull.Value ? null : dr[25].ToString().Trim();
                        data["Question7"] = dr[26] == DBNull.Value ? null : dr[26].ToString().Trim();
                        data["QuestionComment7"] = dr[27] == DBNull.Value ? null : dr[27].ToString().Trim();
                        data["Question8"] = dr[28] == DBNull.Value ? null : dr[28].ToString().Trim();
                        data["QuestionComment8"] = dr[29] == DBNull.Value ? null : dr[29].ToString().Trim();
                        data["Question9"] = dr[30] == DBNull.Value ? null : dr[30].ToString().Trim();
                        data["QuestionComment9"] = dr[31] == DBNull.Value ? null : dr[31].ToString().Trim();
                        data["Question10"] = dr[32] == DBNull.Value ? null : dr[32].ToString().Trim();
                        data["QuestionComment10"] = dr[33] == DBNull.Value ? null : dr[33].ToString().Trim();
                        data["Question11"] = dr[34] == DBNull.Value ? null : dr[34].ToString().Trim();
                        data["QuestionComment11"] = dr[35] == DBNull.Value ? null : dr[35].ToString().Trim();
                        data["Question12"] = dr[36] == DBNull.Value ? null : dr[36].ToString().Trim();
                        data["QuestionComment12"] = dr[37] == DBNull.Value ? null : dr[37].ToString().Trim();
                        data["Question13"] = dr[38] == DBNull.Value ? null : dr[38].ToString().Trim();
                        data["QuestionComment13"] = dr[39] == DBNull.Value ? null : dr[39].ToString().Trim();
                        data["Question14"] = dr[40] == DBNull.Value ? null : dr[40].ToString().Trim();
                        data["QuestionComment14"] = dr[41] == DBNull.Value ? null : dr[41].ToString().Trim();
                        data["Question15"] = dr[42] == DBNull.Value ? null : dr[42].ToString().Trim();
                        data["QuestionComment15"] = dr[43] == DBNull.Value ? null : dr[43].ToString().Trim();
                        data["Question16"] = dr[44] == DBNull.Value ? null : dr[44].ToString().Trim();
                        data["QuestionComment16"] = dr[45] == DBNull.Value ? null : dr[45].ToString().Trim();
                        data["Question17"] = dr[46] == DBNull.Value ? null : dr[46].ToString().Trim();
                        data["QuestionComment17"] = dr[47] == DBNull.Value ? null : dr[47].ToString().Trim();
                        data["Question18"] = dr[48] == DBNull.Value ? null : dr[48].ToString().Trim();
                        data["QuestionComment18"] = dr[49] == DBNull.Value ? null : dr[49].ToString().Trim();
                        data["Question19"] = dr[50] == DBNull.Value ? null : dr[50].ToString().Trim();
                        data["QuestionComment19"] = dr[51] == DBNull.Value ? null : dr[51].ToString().Trim();
                        data["Question20"] = dr[52] == DBNull.Value ? null : dr[52].ToString().Trim();
                        data["QuestionComment20"] = dr[53] == DBNull.Value ? null : dr[53].ToString().Trim();
                        data["Question21"] = dr[54] == DBNull.Value ? null : dr[54].ToString().Trim();
                        data["QuestionComment21"] = dr[55] == DBNull.Value ? null : dr[55].ToString().Trim();

                        data["ErrorDesc"] = errorDesc;
                        data["ErrorFlag"] = !string.IsNullOrEmpty(errorDesc);

                        if (lineNbr != 1)
                        {
                            list.Add(data);
                        }
                        lineNbr++;
                    }
                    dao.BatchInsertDPSatisfyImport(list);
                    result = true;

                    trans.Complete();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine(ex);
            }
            System.Diagnostics.Debug.WriteLine("Import Finish : " + DateTime.Now.ToString());

            return result;
        }

        public bool VerifyDPSatisfy(String version, out string IsValid)
        {
            bool result = false;
            //调用存储过程验证数据
            using (DPImportDao dao = new DPImportDao())
            {
                IsValid = dao.ProcImportDPSatisfy(new Guid(_context.User.Id), version);
                result = true;
            }
            return result;
        }

        public DataSet GetImportDPSatisfyByCondition(Hashtable obj, int start, int limit, out int totalCount)
        {
            using (DPImportDao dao = new DPImportDao())
            {
                return dao.SelectImportDPSatisfyByCondition(obj, start, limit, out totalCount);
            }
        }

        #endregion

        #region AuditChannel

        public bool ImportDPAuditChannel(DataTable dt)
        {
            System.Diagnostics.Debug.WriteLine("Import Start : " + DateTime.Now.ToString());
            bool result = false;
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    DPImportDao dao = new DPImportDao();
                    //删除上传人的数据
                    dao.DeleteDPImportHead(_context.User.Id, "DPAuditChannel");
                    dao.DeleteDPImportLine(_context.User.Id, "DPAuditChannel");

                    int lineNbr = 1;
                    IList<Hashtable> list = new List<Hashtable>();
                    foreach (DataRow dr in dt.Rows)
                    {
                        //string errString = string.Empty;
                        Hashtable data = new Hashtable();
                        data["HeadId"] = Guid.NewGuid();
                        data["ImportUser"] = new Guid(_context.User.Id);
                        data["ImportType"] = "DPAuditChannel";
                        data["ImportTime"] = DateTime.Now;
                        data["LineNum"] = lineNbr;
                        String errorDesc = "";

                        //DealerCode
                        data["DealerCode"] = dr[0] == DBNull.Value ? null : dr[0].ToString().Trim();
                        if (data["DealerCode"] == null || string.IsNullOrEmpty(data["DealerCode"].ToString()))
                        {
                            errorDesc += "客户编码为空;";
                        }
                        data["DealerId"] = DBNull.Value;

                        for (int i = 1; i < 47; i++)
                        {
                            if (i == 6)
                            {
                                data["Column" + i.ToString()] = dr[i + 1] == DBNull.Value ? null : dr[i + 1].ToString().Trim() + " ";
                            }
                            else
                            {
                                data["Column" + i.ToString()] = dr[i + 1] == DBNull.Value ? null : dr[i + 1].ToString().Trim();
                            }
                        }

                        data["ErrorDesc"] = errorDesc;
                        data["ErrorFlag"] = !string.IsNullOrEmpty(errorDesc);

                        if (lineNbr >= 5)
                        {
                            list.Add(data);
                        }
                        lineNbr++;
                    }
                    dao.BatchInsertDPImportHead(list);
                    result = true;

                    trans.Complete();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine(ex);
            }
            System.Diagnostics.Debug.WriteLine("Import Finish : " + DateTime.Now.ToString());

            return result;
        }

        public bool VerifyDPAuditChannel(out string IsValid)
        {
            bool result = false;
            //调用存储过程验证数据
            using (DPImportDao dao = new DPImportDao())
            {
                IsValid = dao.ProcImportDPAuditChannel(new Guid(_context.User.Id), "DPAuditChannel");
                result = true;
            }
            return result;
        }

        #endregion

        #region BaseComp

        public bool ImportDPBaseComp(DataTable dt)
        {
            System.Diagnostics.Debug.WriteLine("Import Start : " + DateTime.Now.ToString());
            bool result = false;
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    DPImportDao dao = new DPImportDao();
                    //删除上传人的数据
                    dao.DeleteDPImportHead(_context.User.Id, "DPBaseComp");
                    dao.DeleteDPImportLine(_context.User.Id, "DPBaseComp");

                    Guid headId = Guid.NewGuid();
                    String errorDesc = "";

                    IList<Hashtable> headList = new List<Hashtable>();
                    Hashtable head = new Hashtable();
                    head["HeadId"] = headId;
                    head["ImportUser"] = new Guid(_context.User.Id);
                    head["ImportType"] = "DPBaseComp";
                    head["ImportTime"] = DateTime.Now;
                    head["LineNum"] = DBNull.Value;
                    head["DealerCode"] = dt.Rows[0][1] == DBNull.Value ? null : dt.Rows[0][1].ToString().Trim();
                    if (head["DealerCode"] == null || string.IsNullOrEmpty(head["DealerCode"].ToString()))
                    {
                        errorDesc += "客户编码为空;";
                    }
                    head["DealerId"] = DBNull.Value;
                    head["Column1"] = dt.Rows[4][1] == DBNull.Value ? null : dt.Rows[4][1].ToString().Trim() + " ";
                    head["Column2"] = dt.Rows[5][1] == DBNull.Value ? null : dt.Rows[5][1].ToString().Trim() + " ";
                    head["Column3"] = dt.Rows[6][1] == DBNull.Value ? null : dt.Rows[6][1].ToString().Trim() + " ";
                    head["Column4"] = dt.Rows[7][1] == DBNull.Value ? null : dt.Rows[7][1].ToString().Trim() + " ";
                    head["Column5"] = dt.Rows[8][1] == DBNull.Value ? null : dt.Rows[8][1].ToString().Trim() + " ";
                    head["Column6"] = dt.Rows[9][1] == DBNull.Value ? null : dt.Rows[9][1].ToString().Trim() + " ";
                    head["Column7"] = dt.Rows[22][8] == DBNull.Value ? null : dt.Rows[22][8].ToString().Trim() + " ";
                    head["ErrorDesc"] = errorDesc;
                    head["ErrorFlag"] = !string.IsNullOrEmpty(errorDesc);
                    headList.Add(head);
                    dao.BatchInsertDPImportHead(headList);

                    IList<Hashtable> lineList = new List<Hashtable>();
                    for (int i = 0; i < 10; i++)
                    {
                        Hashtable line = new Hashtable();
                        line["LineId"] = Guid.NewGuid();
                        line["HeadId"] = headId;
                        line["ImportUser"] = new Guid(_context.User.Id);
                        line["ImportType"] = "DPBaseComp";
                        line["DealerCode"] = dt.Rows[0][1] == DBNull.Value ? null : dt.Rows[0][1].ToString().Trim();
                        line["DealerId"] = DBNull.Value;
                        line["Column1"] = dt.Rows[4][1] == DBNull.Value ? null : dt.Rows[4][1].ToString().Trim() + " ";
                        line["Column2"] = dt.Rows[5][1] == DBNull.Value ? null : dt.Rows[5][1].ToString().Trim() + " ";
                        line["Column3"] = dt.Rows[12 + i][0] == DBNull.Value ? null : dt.Rows[12 + i][0].ToString().Trim() + " ";
                        line["Column4"] = dt.Rows[12 + i][1] == DBNull.Value ? null : dt.Rows[12 + i][1].ToString().Trim() + " ";
                        line["Column5"] = dt.Rows[12 + i][2] == DBNull.Value ? null : dt.Rows[12 + i][2].ToString().Trim() + " ";
                        line["Column6"] = dt.Rows[12 + i][3] == DBNull.Value ? null : dt.Rows[12 + i][3].ToString().Trim() + " ";
                        line["Column7"] = dt.Rows[12 + i][4] == DBNull.Value ? null : dt.Rows[12 + i][4].ToString().Trim() + " ";
                        line["Column8"] = dt.Rows[12 + i][5] == DBNull.Value ? null : dt.Rows[12 + i][5].ToString().Trim() + " ";
                        line["Column9"] = dt.Rows[12 + i][6] == DBNull.Value ? null : dt.Rows[12 + i][6].ToString().Trim() + " ";
                        line["Column10"] = dt.Rows[12 + i][7] == DBNull.Value ? null : dt.Rows[12 + i][7].ToString().Trim() + " ";
                        line["Column11"] = dt.Rows[12 + i][8] == DBNull.Value ? null : dt.Rows[12 + i][8].ToString().Trim() + " ";
                        line["Column12"] = dt.Rows[12 + i][9] == DBNull.Value ? null : dt.Rows[12 + i][9].ToString().Trim() + " ";
                        lineList.Add(line);
                    }
                    dao.BatchInsertDPImportLine(lineList);

                    result = true;
                    trans.Complete();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine(ex);
            }
            System.Diagnostics.Debug.WriteLine("Import Finish : " + DateTime.Now.ToString());

            return result;
        }

        public bool VerifyDPBaseComp(out string IsValid)
        {
            bool result = false;
            //调用存储过程验证数据
            using (DPImportDao dao = new DPImportDao())
            {
                IsValid = dao.ProcImportDPBaseComp(new Guid(_context.User.Id), "DPBaseComp");
                result = true;
            }
            return result;
        }

        #endregion

        #region DeepComp

        public bool ImportDPDeepComp(DataTable dt)
        {
            System.Diagnostics.Debug.WriteLine("Import Start : " + DateTime.Now.ToString());
            bool result = false;
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    DPImportDao dao = new DPImportDao();
                    //删除上传人的数据
                    dao.DeleteDPImportHead(_context.User.Id, "DPDeepComp");
                    dao.DeleteDPImportLine(_context.User.Id, "DPDeepComp");

                    Guid headId = Guid.NewGuid();
                    String errorDesc = "";

                    IList<Hashtable> headList = new List<Hashtable>();
                    Hashtable head = new Hashtable();
                    head["HeadId"] = headId;
                    head["ImportUser"] = new Guid(_context.User.Id);
                    head["ImportType"] = "DPDeepComp";
                    head["ImportTime"] = DateTime.Now;
                    head["LineNum"] = DBNull.Value;
                    head["DealerCode"] = dt.Rows[0][1] == DBNull.Value ? null : dt.Rows[0][1].ToString().Trim();
                    if (head["DealerCode"] == null || string.IsNullOrEmpty(head["DealerCode"].ToString()))
                    {
                        errorDesc += "客户编码为空;";
                    }
                    head["DealerId"] = DBNull.Value;
                    head["Column1"] = dt.Rows[4][1] == DBNull.Value ? null : dt.Rows[4][1].ToString().Trim() + " ";
                    head["Column2"] = dt.Rows[5][1] == DBNull.Value ? null : dt.Rows[5][1].ToString().Trim() + " ";
                    head["Column3"] = dt.Rows[6][1] == DBNull.Value ? null : dt.Rows[6][1].ToString().Trim() + " ";
                    head["Column4"] = dt.Rows[7][1] == DBNull.Value ? null : dt.Rows[7][1].ToString().Trim() + " ";
                    head["Column5"] = dt.Rows[8][1] == DBNull.Value ? null : dt.Rows[8][1].ToString().Trim() + " ";
                    head["Column6"] = dt.Rows[9][1] == DBNull.Value ? null : dt.Rows[9][1].ToString().Trim() + " ";
                    head["ErrorDesc"] = errorDesc;
                    head["ErrorFlag"] = !string.IsNullOrEmpty(errorDesc);
                    headList.Add(head);
                    dao.BatchInsertDPImportHead(headList);

                    IList<Hashtable> lineList = new List<Hashtable>();
                    for (int i = 0; i < 9; i++)
                    {
                        Hashtable line = new Hashtable();
                        line["LineId"] = Guid.NewGuid();
                        line["HeadId"] = headId;
                        line["ImportUser"] = new Guid(_context.User.Id);
                        line["ImportType"] = "DPDeepComp";
                        line["DealerCode"] = dt.Rows[0][1] == DBNull.Value ? null : dt.Rows[0][1].ToString().Trim();
                        line["DealerId"] = DBNull.Value;
                        line["Column1"] = dt.Rows[4][1] == DBNull.Value ? null : dt.Rows[4][1].ToString().Trim() + " ";
                        line["Column2"] = dt.Rows[5][1] == DBNull.Value ? null : dt.Rows[5][1].ToString().Trim() + " ";
                        line["Column3"] = i + 1;
                        line["Column4"] = dt.Rows[10 + i][0] == DBNull.Value ? null : dt.Rows[10 + i][0].ToString().Trim() + " ";
                        line["Column5"] = dt.Rows[10 + i][1] == DBNull.Value ? null : dt.Rows[10 + i][1].ToString().Trim() + " ";
                        lineList.Add(line);
                    }
                    dao.BatchInsertDPImportLine(lineList);

                    result = true;
                    trans.Complete();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine(ex);
            }
            System.Diagnostics.Debug.WriteLine("Import Finish : " + DateTime.Now.ToString());

            return result;
        }

        public bool VerifyDPDeepComp(out string IsValid)
        {
            bool result = false;
            //调用存储过程验证数据
            using (DPImportDao dao = new DPImportDao())
            {
                IsValid = dao.ProcImportDPDeepComp(new Guid(_context.User.Id), "DPDeepComp");
                result = true;
            }
            return result;
        }

        #endregion

        #region Comp

        public bool VerifyDPComp(String dealerCode, DataSet ds, String fileNameUrl, String fileName)
        {
            bool result = false;

            DealerMasterDao dealerMasterDao = new DealerMasterDao();
            DPImportDao importDao = new DPImportDao();

            DealerMaster dm = new DealerMaster();
            dm.SapCode = dealerCode;
            IList<DealerMaster> list = dealerMasterDao.SelectByFilter(dm);
            DealerMaster d = list.First(e => e.SapCode.Equals(dealerCode));

            if (d != null)
            {
                Hashtable head = new Hashtable();
                List<Hashtable> regChange = new List<Hashtable>();
                List<Hashtable> regPort = new List<Hashtable>();
                List<Hashtable> stoStructure = new List<Hashtable>();
                List<Hashtable> stoState = new List<Hashtable>();
                List<Hashtable> stoInvest = new List<Hashtable>();
                List<Hashtable> staff = new List<Hashtable>();
                List<Hashtable> staffResume = new List<Hashtable>();
                List<Hashtable> opePay = new List<Hashtable>();
                List<Hashtable> pubLawsuit = new List<Hashtable>();

                Guid compId = Guid.NewGuid();
                this.AddValue(ref head, "CompId", compId);
                this.AddValue(ref head, "DealerId", d.Id);
                this.AddValue(ref head, "CreateBy", _context.User.Id);
                this.AddValue(ref head, "Version", importDao.GenerateVersion());
                this.AddValue(ref head, "DownFile", fileNameUrl);
                this.AddValue(ref head, "DownFileName", fileName);

                #region Pro

                this.AddValue(ref head, "ProName", ds.Tables[0].Rows[1][0]);
                this.AddValue(ref head, "ProAddress", ds.Tables[0].Rows[1][1]);
                this.AddValue(ref head, "ProPhone", ds.Tables[0].Rows[1][2]);
                this.AddValue(ref head, "ProFax", ds.Tables[0].Rows[1][3]);
                this.AddValue(ref head, "ProRegNo", ds.Tables[0].Rows[1][4]);
                this.AddValue(ref head, "ProCompanyName", ds.Tables[0].Rows[1][5]);
                this.AddValue(ref head, "ProCompanyNameEn", ds.Tables[0].Rows[1][6]);
                this.AddValue(ref head, "ProCompanyAddress", ds.Tables[0].Rows[1][7]);
                this.AddValue(ref head, "ProCompanyPhone", ds.Tables[0].Rows[1][8]);
                this.AddValue(ref head, "ProCompanyFax", ds.Tables[0].Rows[1][9]);
                this.AddValue(ref head, "ProCompanyZip", ds.Tables[0].Rows[1][10]);

                #endregion

                #region Reg

                this.AddValue(ref head, "RegName", ds.Tables[1].Rows[1][0]);
                this.AddValue(ref head, "RegAddress", ds.Tables[1].Rows[1][1]);
                this.AddValue(ref head, "RegZip", ds.Tables[1].Rows[1][2]);
                this.AddValue(ref head, "RegCapital", ds.Tables[1].Rows[1][3]);
                this.AddValue(ref head, "RegType", ds.Tables[1].Rows[1][4]);
                this.AddValue(ref head, "RegRange", ds.Tables[1].Rows[1][5]);
                this.AddValue(ref head, "RegLegal", ds.Tables[1].Rows[1][6]);
                this.AddValue(ref head, "RegDate", ds.Tables[1].Rows[1][7]);
                this.AddValue(ref head, "RegOrganization", ds.Tables[1].Rows[1][8]);
                this.AddValue(ref head, "RegNo", ds.Tables[1].Rows[1][9]);
                this.AddValue(ref head, "RegTerm", ds.Tables[1].Rows[1][10]);

                for (int i = 0; i < ds.Tables[1].Rows.Count; i++)
                {
                    if (i > 0)
                    {
                        if ((ds.Tables[1].Rows[i][11] == null || String.IsNullOrEmpty(ds.Tables[1].Rows[i][11].ToString()))
                            && (ds.Tables[1].Rows[i][12] == null || String.IsNullOrEmpty(ds.Tables[1].Rows[i][12].ToString()))
                            && (ds.Tables[1].Rows[i][13] == null || String.IsNullOrEmpty(ds.Tables[1].Rows[i][13].ToString()))
                            && (ds.Tables[1].Rows[i][14] == null || String.IsNullOrEmpty(ds.Tables[1].Rows[i][14].ToString())))
                        {
                            break;
                        }
                        Hashtable info = new Hashtable();
                        this.AddValue(ref info, "CompRegChangeId", Guid.NewGuid());
                        this.AddValue(ref info, "CompId", compId);
                        this.AddValue(ref info, "RegChangeDate", ds.Tables[1].Rows[i][11]);
                        this.AddValue(ref info, "RegChangeContent", ds.Tables[1].Rows[i][12]);
                        this.AddValue(ref info, "RegChangeBefore", ds.Tables[1].Rows[i][13]);
                        this.AddValue(ref info, "RegChangeAfter", ds.Tables[1].Rows[i][14]);
                        regChange.Add(info);
                    }
                }

                for (int i = 0; i < ds.Tables[1].Rows.Count; i++)
                {
                    if (i > 0)
                    {
                        if ((ds.Tables[1].Rows[i][15] == null || String.IsNullOrEmpty(ds.Tables[1].Rows[i][15].ToString()))
                            && (ds.Tables[1].Rows[i][16] == null || String.IsNullOrEmpty(ds.Tables[1].Rows[i][16].ToString())))
                        {
                            break;
                        }
                        Hashtable info = new Hashtable();
                        this.AddValue(ref info, "CompRegPortId", Guid.NewGuid());
                        this.AddValue(ref info, "CompId", compId);
                        this.AddValue(ref info, "RegPortContent", ds.Tables[1].Rows[i][15]);
                        this.AddValue(ref info, "RegPortDate", ds.Tables[1].Rows[i][16]);
                        regPort.Add(info);
                    }
                }

                #endregion

                #region Sto

                for (int i = 0; i < ds.Tables[2].Rows.Count; i++)
                {
                    if (i > 0)
                    {
                        if ((ds.Tables[2].Rows[i][0] == null || String.IsNullOrEmpty(ds.Tables[2].Rows[i][0].ToString()))
                            && (ds.Tables[2].Rows[i][1] == null || String.IsNullOrEmpty(ds.Tables[2].Rows[i][1].ToString()))
                            && (ds.Tables[2].Rows[i][2] == null || String.IsNullOrEmpty(ds.Tables[2].Rows[i][2].ToString()))
                            && (ds.Tables[2].Rows[i][3] == null || String.IsNullOrEmpty(ds.Tables[2].Rows[i][3].ToString())))
                        {
                            break;
                        }
                        Hashtable info = new Hashtable();
                        this.AddValue(ref info, "CompStoStructureId", Guid.NewGuid());
                        this.AddValue(ref info, "CompId", compId);
                        this.AddValue(ref info, "StoStructureName", ds.Tables[2].Rows[i][0]);
                        this.AddValue(ref info, "StoStructureCapital", ds.Tables[2].Rows[i][1]);
                        this.AddValue(ref info, "StoStructurePercent", ds.Tables[2].Rows[i][2]);
                        this.AddValue(ref info, "StoStructureUnit", ds.Tables[2].Rows[i][3]);
                        stoStructure.Add(info);
                    }
                }

                for (int i = 0; i < ds.Tables[2].Rows.Count; i++)
                {
                    if (i > 0)
                    {
                        if ((ds.Tables[2].Rows[i][4] == null || String.IsNullOrEmpty(ds.Tables[2].Rows[i][4].ToString()))
                            && (ds.Tables[2].Rows[i][5] == null || String.IsNullOrEmpty(ds.Tables[2].Rows[i][5].ToString()))
                            && (ds.Tables[2].Rows[i][6] == null || String.IsNullOrEmpty(ds.Tables[2].Rows[i][6].ToString()))
                            && (ds.Tables[2].Rows[i][7] == null || String.IsNullOrEmpty(ds.Tables[2].Rows[i][7].ToString()))
                            && (ds.Tables[2].Rows[i][8] == null || String.IsNullOrEmpty(ds.Tables[2].Rows[i][8].ToString())))
                        {
                            break;
                        }
                        Hashtable info = new Hashtable();
                        this.AddValue(ref info, "CompStoStateId", Guid.NewGuid());
                        this.AddValue(ref info, "CompId", compId);
                        this.AddValue(ref info, "StoStateName", ds.Tables[2].Rows[i][4]);
                        this.AddValue(ref info, "StoStateSex", ds.Tables[2].Rows[i][5]);
                        this.AddValue(ref info, "StoStateIdCard", ds.Tables[2].Rows[i][6]);
                        this.AddValue(ref info, "StoStatePosition", ds.Tables[2].Rows[i][7]);
                        this.AddValue(ref info, "StoStateRemark", ds.Tables[2].Rows[i][8]);
                        stoState.Add(info);
                    }
                }

                for (int i = 0; i < ds.Tables[2].Rows.Count; i++)
                {
                    if (i > 0)
                    {
                        if ((ds.Tables[2].Rows[i][9] == null || String.IsNullOrEmpty(ds.Tables[2].Rows[i][9].ToString()))
                            && (ds.Tables[2].Rows[i][10] == null || String.IsNullOrEmpty(ds.Tables[2].Rows[i][10].ToString()))
                            && (ds.Tables[2].Rows[i][11] == null || String.IsNullOrEmpty(ds.Tables[2].Rows[i][11].ToString()))
                            && (ds.Tables[2].Rows[i][12] == null || String.IsNullOrEmpty(ds.Tables[2].Rows[i][12].ToString()))
                            && (ds.Tables[2].Rows[i][13] == null || String.IsNullOrEmpty(ds.Tables[2].Rows[i][13].ToString())))
                        {
                            break;
                        }
                        if ((ds.Tables[2].Rows[i][9] == null || String.IsNullOrEmpty(ds.Tables[2].Rows[i][9].ToString()))
                            && (ds.Tables[2].Rows[i][10] == null || String.IsNullOrEmpty(ds.Tables[2].Rows[i][10].ToString())))
                        {
                            Hashtable info = new Hashtable();
                            this.AddValue(ref info, "CompStoInvestId", Guid.NewGuid());
                            this.AddValue(ref info, "CompId", compId);
                            this.AddValue(ref info, "StoInvestUser", ds.Tables[2].Rows[i][9]);
                            this.AddValue(ref info, "StoInvestContent", "信息核实");
                            this.AddValue(ref info, "StoInvestResult", ds.Tables[2].Rows[i][10]);
                            stoInvest.Add(info);
                        }
                        if ((ds.Tables[2].Rows[i][9] == null || String.IsNullOrEmpty(ds.Tables[2].Rows[i][9].ToString()))
                            && (ds.Tables[2].Rows[i][11] == null || String.IsNullOrEmpty(ds.Tables[2].Rows[i][11].ToString())))
                        {
                            Hashtable info = new Hashtable();
                            this.AddValue(ref info, "CompStoInvestId", Guid.NewGuid());
                            this.AddValue(ref info, "CompId", compId);
                            this.AddValue(ref info, "StoInvestUser", ds.Tables[2].Rows[i][9]);
                            this.AddValue(ref info, "StoInvestContent", "诉讼记录");
                            this.AddValue(ref info, "StoInvestResult", ds.Tables[2].Rows[i][11]);
                            stoInvest.Add(info);
                        }
                        if ((ds.Tables[2].Rows[i][9] == null || String.IsNullOrEmpty(ds.Tables[2].Rows[i][9].ToString()))
                            && (ds.Tables[2].Rows[i][12] == null || String.IsNullOrEmpty(ds.Tables[2].Rows[i][12].ToString())))
                        {
                            Hashtable info = new Hashtable();
                            this.AddValue(ref info, "CompStoInvestId", Guid.NewGuid());
                            this.AddValue(ref info, "CompId", compId);
                            this.AddValue(ref info, "StoInvestUser", ds.Tables[2].Rows[i][9]);
                            this.AddValue(ref info, "StoInvestContent", "媒体信息（涉及行贿、黑名单等其他负面信息）");
                            this.AddValue(ref info, "StoInvestResult", ds.Tables[2].Rows[i][12]);
                            stoInvest.Add(info);
                        }
                        if ((ds.Tables[2].Rows[i][9] == null || String.IsNullOrEmpty(ds.Tables[2].Rows[i][9].ToString()))
                            && (ds.Tables[2].Rows[i][13] == null || String.IsNullOrEmpty(ds.Tables[2].Rows[i][13].ToString())))
                        {
                            Hashtable info = new Hashtable();
                            this.AddValue(ref info, "CompStoInvestId", Guid.NewGuid());
                            this.AddValue(ref info, "CompId", compId);
                            this.AddValue(ref info, "StoInvestUser", ds.Tables[2].Rows[i][9]);
                            this.AddValue(ref info, "StoInvestContent", "与政府、医院、药监局及卫生厅相关的关联记录");
                            this.AddValue(ref info, "StoInvestResult", ds.Tables[2].Rows[i][13]);
                            stoInvest.Add(info);
                        }
                    }
                }

                #endregion

                #region Rel

                this.AddValue(ref head, "RelInstitutions", ds.Tables[3].Rows[1][0]);

                #endregion

                #region Staff

                this.AddValue(ref head, "StaffTotal", ds.Tables[4].Rows[0][1]);
                this.AddValue(ref head, "StaffManage", ds.Tables[4].Rows[1][1]);
                this.AddValue(ref head, "StaffSales", ds.Tables[4].Rows[2][1]);

                int staffNo = 1;
                for (int i = 0; i < ds.Tables[4].Rows.Count; i++)
                {
                    if (i > 0)
                    {
                        if ((ds.Tables[4].Rows[i][2] == null || String.IsNullOrEmpty(ds.Tables[4].Rows[i][2].ToString()))
                            && (ds.Tables[4].Rows[i][3] == null || String.IsNullOrEmpty(ds.Tables[4].Rows[i][3].ToString()))
                            && (ds.Tables[4].Rows[i][4] == null || String.IsNullOrEmpty(ds.Tables[4].Rows[i][4].ToString()))
                            && (ds.Tables[4].Rows[i][5] == null || String.IsNullOrEmpty(ds.Tables[4].Rows[i][5].ToString()))
                            && (ds.Tables[4].Rows[i][6] == null || String.IsNullOrEmpty(ds.Tables[4].Rows[i][6].ToString())))
                        {
                            break;
                        }
                        Hashtable info = new Hashtable();
                        this.AddValue(ref info, "CompStaffId", Guid.NewGuid());
                        this.AddValue(ref info, "CompId", compId);
                        this.AddValue(ref info, "StaffNo", (staffNo++).ToString());
                        this.AddValue(ref info, "StaffName", ds.Tables[4].Rows[i][2]);
                        this.AddValue(ref info, "StaffSex", ds.Tables[4].Rows[i][3]);
                        this.AddValue(ref info, "StaffBirth", ds.Tables[4].Rows[i][4]);
                        this.AddValue(ref info, "StaffPosition", ds.Tables[4].Rows[i][5]);
                        this.AddValue(ref info, "StaffBusiness", ds.Tables[4].Rows[i][6]);
                        staff.Add(info);
                    }
                }

                for (int i = 0; i < ds.Tables[4].Rows.Count; i++)
                {
                    if (i > 0)
                    {
                        if ((ds.Tables[4].Rows[i][7] == null || String.IsNullOrEmpty(ds.Tables[4].Rows[i][7].ToString()))
                            && (ds.Tables[4].Rows[i][8] == null || String.IsNullOrEmpty(ds.Tables[4].Rows[i][8].ToString()))
                            && (ds.Tables[4].Rows[i][9] == null || String.IsNullOrEmpty(ds.Tables[4].Rows[i][9].ToString()))
                            && (ds.Tables[4].Rows[i][10] == null || String.IsNullOrEmpty(ds.Tables[4].Rows[i][10].ToString())))
                        {
                            break;
                        }
                        Hashtable info = new Hashtable();
                        this.AddValue(ref info, "CompStaffResumeId", Guid.NewGuid());
                        foreach (Hashtable s in staff)
                        {
                            if (s["StaffName"].ToString().Trim() == ds.Tables[4].Rows[i][7].ToString().Trim())
                            {
                                this.AddValue(ref info, "CompStaffId", s["CompStaffId"].ToString());
                                break;
                            }
                        }
                        this.AddValue(ref info, "StaffResumeTime", ds.Tables[4].Rows[i][8]);
                        this.AddValue(ref info, "StaffResumeCompany", ds.Tables[4].Rows[i][9]);
                        this.AddValue(ref info, "StaffResumePosition", ds.Tables[4].Rows[i][10]);
                        staffResume.Add(info);
                    }
                }

                #endregion

                #region Ope

                this.AddValue(ref head, "OpeAddress", ds.Tables[5].Rows[1][0]);
                this.AddValue(ref head, "OpePlace", ds.Tables[5].Rows[1][1]);
                this.AddValue(ref head, "OpeBusiness", ds.Tables[5].Rows[1][2]);
                this.AddValue(ref head, "OpePurchase", ds.Tables[5].Rows[1][3]);
                this.AddValue(ref head, "OpeEvaluateName", ds.Tables[5].Rows[1][4]);
                this.AddValue(ref head, "OpeEvaluateAddress", ds.Tables[5].Rows[1][5]);
                this.AddValue(ref head, "OpeEvaluatePhone", ds.Tables[5].Rows[1][6]);
                this.AddValue(ref head, "OpeEvaluateContact", ds.Tables[5].Rows[1][7]);
                this.AddValue(ref head, "OpeEvaluateDate", ds.Tables[5].Rows[1][8]);
                this.AddValue(ref head, "OpeEvaluateProduct", ds.Tables[5].Rows[1][9]);
                this.AddValue(ref head, "OpeEvaluatePay", ds.Tables[5].Rows[1][10]);
                this.AddValue(ref head, "OpeEvaluateMemo", ds.Tables[5].Rows[1][11]);
                this.AddValue(ref head, "OpeSales", ds.Tables[5].Rows[1][12]);

                for (int i = 0; i < ds.Tables[5].Rows.Count; i++)
                {
                    if (i > 0)
                    {
                        if ((ds.Tables[5].Rows[i][13] == null || String.IsNullOrEmpty(ds.Tables[5].Rows[i][13].ToString()))
                            && (ds.Tables[5].Rows[i][14] == null || String.IsNullOrEmpty(ds.Tables[5].Rows[i][14].ToString()))
                            && (ds.Tables[5].Rows[i][15] == null || String.IsNullOrEmpty(ds.Tables[5].Rows[i][15].ToString()))
                            && (ds.Tables[5].Rows[i][16] == null || String.IsNullOrEmpty(ds.Tables[5].Rows[i][16].ToString()))
                            && (ds.Tables[5].Rows[i][17] == null || String.IsNullOrEmpty(ds.Tables[5].Rows[i][17].ToString())))
                        {
                            break;
                        }
                        Hashtable info = new Hashtable();
                        this.AddValue(ref info, "CompOpePayId", Guid.NewGuid());
                        this.AddValue(ref info, "CompId", compId);
                        this.AddValue(ref info, "OpePayCustomer", ds.Tables[5].Rows[i][13]);
                        this.AddValue(ref info, "OpePayType", ds.Tables[5].Rows[i][14]);
                        this.AddValue(ref info, "OpePayCycle", ds.Tables[5].Rows[i][15]);
                        this.AddValue(ref info, "OpePayDelay", ds.Tables[5].Rows[i][16]);
                        this.AddValue(ref info, "OpePayScope", ds.Tables[5].Rows[i][17]);
                        opePay.Add(info);
                    }
                }

                #endregion

                #region Pub

                this.AddValue(ref head, "PubRecord", ds.Tables[6].Rows[1][0]);
                this.AddValue(ref head, "PubLawsuit", ds.Tables[6].Rows[1][1]);

                for (int i = 0; i < ds.Tables[6].Rows.Count; i++)
                {
                    if (i > 0)
                    {
                        if ((ds.Tables[6].Rows[i][2] == null || String.IsNullOrEmpty(ds.Tables[6].Rows[i][2].ToString()))
                            && (ds.Tables[6].Rows[i][3] == null || String.IsNullOrEmpty(ds.Tables[6].Rows[i][3].ToString()))
                            && (ds.Tables[6].Rows[i][4] == null || String.IsNullOrEmpty(ds.Tables[6].Rows[i][4].ToString()))
                            && (ds.Tables[6].Rows[i][5] == null || String.IsNullOrEmpty(ds.Tables[6].Rows[i][5].ToString()))
                            && (ds.Tables[6].Rows[i][6] == null || String.IsNullOrEmpty(ds.Tables[6].Rows[i][6].ToString())))
                        {
                            break;
                        }
                        Hashtable info = new Hashtable();
                        this.AddValue(ref info, "CompPubLawsuitId", Guid.NewGuid());
                        this.AddValue(ref info, "CompId", compId);
                        this.AddValue(ref info, "PubLawsuitDate", ds.Tables[6].Rows[i][2]);
                        this.AddValue(ref info, "PubLawsuitCourt", ds.Tables[6].Rows[i][3]);
                        this.AddValue(ref info, "PubLawsuitNo", ds.Tables[6].Rows[i][4]);
                        this.AddValue(ref info, "PubLawsuitObject", ds.Tables[6].Rows[i][5]);
                        this.AddValue(ref info, "PubLawsuitStatus", ds.Tables[6].Rows[i][6]);
                        pubLawsuit.Add(info);
                    }
                }

                #endregion

                using (TransactionScope trans = new TransactionScope())
                {
                    importDao.InsertDpCompHead(head);

                    foreach (Hashtable info in regChange)
                    {
                        importDao.InsertDpCompRegChange(info);
                    }

                    foreach (Hashtable info in regPort)
                    {
                        importDao.InsertDpCompRegPort(info);
                    }

                    foreach (Hashtable info in stoStructure)
                    {
                        importDao.InsertDpCompStoStructure(info);
                    }

                    foreach (Hashtable info in stoState)
                    {
                        importDao.InsertDpCompStoState(info);
                    }

                    foreach (Hashtable info in stoInvest)
                    {
                        importDao.InsertDpCompStoInvest(info);
                    }

                    foreach (Hashtable info in staff)
                    {
                        importDao.InsertDpCompStaff(info);
                    }

                    foreach (Hashtable info in staffResume)
                    {
                        importDao.InsertDpCompStaffResume(info);
                    }

                    foreach (Hashtable info in opePay)
                    {
                        importDao.InsertDpCompOpePay(info);
                    }

                    foreach (Hashtable info in pubLawsuit)
                    {
                        importDao.InsertDpCompPubLawsuit(info);
                    }

                    trans.Complete();
                    result = true;
                }
            }
            else
            {
                Hashtable info = new Hashtable();
                info.Add("ImportUser", _context.User.Id);
                info.Add("ErrorDesc", "经销商编号不存在");
                importDao.InsertDpCompImport(info);
            }

            return result;
        }

        private void AddValue(ref Hashtable info, String key, Object obj)
        {
            if (obj != null)
            {
                info.Add(key, obj.ToString().Trim());
            }
            else
            {
                info.Add(key, DBNull.Value);
            }
        }

        public DataSet GetImportDPCompByCondition(Hashtable obj, int start, int limit, out int totalCount)
        {
            using (DPImportDao dao = new DPImportDao())
            {
                return dao.SelectImportDPCompByCondition(obj, start, limit, out totalCount);
            }
        }

        #endregion

        public DataSet GetDPImportHead(Hashtable obj, int start, int limit, out int totalCount)
        {
            using (DPImportDao dao = new DPImportDao())
            {
                return dao.SelectDPImportHead(obj, start, limit, out totalCount);
            }
        }
    }
}
