using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using DMS.DataAccess;
using System.Collections;
using DMS.Model;
using Lafite.RoleModel.Security;
using Grapecity.DataAccess.Transaction;

namespace DMS.Business.ScoreCard
{
    public class EndoScoreCardBLL : IEndoScoreCardBLL
    {
        private IRoleModelContext _context = RoleModelContext.Current;

        #region EndoScoreCard
        public DataSet QueryEndoScoreCardByCondition(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            using (EndoScoreCardDao dao = new EndoScoreCardDao())
            {
                obj.Add("OwnerIdentityType", this._context.User.IdentityType);
                obj.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
                obj.Add("OwnerId", new Guid(this._context.User.Id));
                obj.Add("OwnerCorpId", this._context.User.CorpId);
                return dao.QueryEndoScoreCardByCondition(obj, start, limit, out totalRowCount);
            }
        }

        public EndoScoreCard QueryEndoScoreCardByID(Guid Id)
        {
            using (EndoScoreCardDao dao = new EndoScoreCardDao())
            {
                return dao.QueryEndoScoreCardByID(Id);
            }
        }

        

        public DataSet QueryEndoScoreCardByIDForDS(string Id)
        {
            using (EndoScoreCardHeaderDao dao = new EndoScoreCardHeaderDao())
            {
                return dao.QueryEndoScoreCardByIDForDS(Id);
            }
        }

        public DataSet GetEditTotalScoreById(Hashtable obj)
        {
            using (EndoScoreCardDetailDao dao = new EndoScoreCardDetailDao())
            {
                return dao.GetEditTotalScoreById(obj);
            }
        }

        public DataSet GetScoreCardIdByNo(string obj)
        {
            using (EndoScoreCardDao dao = new EndoScoreCardDao())
            {
                return dao.GetScoreCardIdByNo(obj);
            }
        }

        public DataSet GetUserIdByName(string obj)
        {
            using (EndoScoreCardDao dao = new EndoScoreCardDao())
            {
                return dao.GetUserIdByName(obj);
            }
        }

        public int UpdateDealerConfirm(Hashtable obj)
        {
            using (EndoScoreCardHeaderDao dao = new EndoScoreCardHeaderDao())
            {
                return dao.UpdateDealerConfirm(obj);
            }
        }

        public int UpdateLPConfirm(string obj)
        {
            using (EndoScoreCardHeaderDao dao = new EndoScoreCardHeaderDao())
            {
                return dao.UpdateLPConfirm(obj);
            }
        }

        public int UpdateAdminScore(Hashtable obj)
        {
            using (EndoScoreCardDetailDao dao = new EndoScoreCardDetailDao())
            {
                return dao.UpdateAdminScore(obj);
            }
        }

        #endregion

        #region SCAttachment
        public DataSet GetESCAttachment(Guid obj, int start, int limit, out int totalRowCount)
        {
            using (ScAttachmentDao dao = new ScAttachmentDao())
            {
                return dao.GetESCAttachment(obj, start, limit, out totalRowCount);
            }
        }

        public DataSet QueryESCAttachmentByESCNo(string obj, int start, int limit, out int totalRowCount)
        {
            using (ScAttachmentDao dao = new ScAttachmentDao())
            {
                return dao.QueryESCAttachmentByESCNo(obj, start, limit, out totalRowCount);
            }
        }

        public DataSet QueryScoreCardLogByFilter(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            using (ScoreCardLogDao dao = new ScoreCardLogDao())
            {
                return dao.QueryScoreCardLogByFilter(obj, start, limit, out totalRowCount);
            }
        }

        public void Insert(ScoreCardLog obj)
        {
            using (ScoreCardLogDao dao = new ScoreCardLogDao())
            {
                dao.Insert(obj);
            }
        }

        public bool Delete(Guid id)
        {
            bool result = false;

            using (ScAttachmentDao dao = new ScAttachmentDao())
            {
                int afterRow = dao.Delete(id);
            }
            return result;
        }



        public void AddScAttachment(ScAttachment obj)
        {
            using (ScAttachmentDao dao = new ScAttachmentDao())
            {
                dao.Insert(obj);
            }
        }

        public int GetFileCount(Guid obj)
        {
            int result = 0;
            using (ScAttachmentDao dao = new ScAttachmentDao())
            {
                DataSet ds = dao.GetFileCount(obj);
                if (ds.Tables[0].Rows.Count > 0)
                {
                    result = Convert.ToInt32(ds.Tables[0].Rows[0]["cnt"].ToString());
                }
            }
            return result;
        }


        #endregion

        #region EndoScoreCardInit
        public int UpdateImport(EndoScoreCardInit obj)
        {
            using (EndoScoreCardInitDao dao = new EndoScoreCardInitDao())
            {
                return dao.UpdateEndoScoreCardInitForEdit(obj);
            }
        }

        public void DeleteImport(Guid id)
        {
            using (EndoScoreCardInitDao dao = new EndoScoreCardInitDao())
            {
                dao.Delete(id);
            }
        }

        public IList<EndoScoreCardInit> QueryEndoScoreCardInitErrorData( int start, int limit, out int totalRowCount)
        {
            using (EndoScoreCardInitDao dao = new EndoScoreCardInitDao())
            {
                return dao.SelectByHashtable(start,limit,out totalRowCount);
            }
        }

        public bool Import(DataTable dt, string fileName)
        {
            System.Diagnostics.Debug.WriteLine("Import Start : " + DateTime.Now.ToString());
            bool result = false;
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    EndoScoreCardInitDao dao = new EndoScoreCardInitDao();
                    //删除上传人的数据
                    dao.DeleteByUser(new Guid(_context.User.Id));

                    int lineNbr = 1;
                    IList<EndoScoreCardInit> list = new List<EndoScoreCardInit>();
                    foreach (DataRow dr in dt.Rows)
                    {
                        //string errString = string.Empty;
                        EndoScoreCardInit data = new EndoScoreCardInit();
                        data.Id = Guid.NewGuid();
                        data.User = new Guid(_context.User.Id);
                        data.UploadDate = DateTime.Now;
                        data.FileName = fileName;

                        //DealerName
                        data.DealerName = dr[0] == DBNull.Value ? null : dr[0].ToString();
                        if (string.IsNullOrEmpty(data.DealerName))
                            data.DealerNameErrMsg = "经销商名称为空";

                        //Year
                        data.No = dr[1] == DBNull.Value ? null : dr[1].ToString();
                        if (string.IsNullOrEmpty(data.No))
                            data.NoErrMsg = "单据编号为空";

                        //Year
                        data.Year = dr[2] == DBNull.Value ? null : dr[2].ToString();

                        //Quarter
                        data.Quarter = dr[3] == DBNull.Value ? null : dr[3].ToString();
                        if (!string.IsNullOrEmpty(data.Quarter))
                        {
                            decimal qty;
                            if (!Decimal.TryParse(data.Quarter, out qty))
                                data.QuarterErrMsg = "季度格式不正确";
                        }
                        else
                        {
                            data.QuarterErrMsg = "季度为空";
                        }

                        //上报销量与发票准确率
                        data.Score1 = dr[4] == DBNull.Value ? null : dr[4].ToString();
                        if (string.IsNullOrEmpty(data.Score1))
                            data.Score1ErrMsg = "上报销量与发票准确率为空";

                        //数据核实配合度
                        data.Score2 = dr[5] == DBNull.Value ? null : dr[5].ToString();
                        if (string.IsNullOrEmpty(data.Score2))
                            data.Score2ErrMsg = "数据核实配合度为空";

                        //Remark
                        data.Remark = dr[6] == DBNull.Value ? null : dr[6].ToString();

                        data.LineNbr = lineNbr++;
                        data.ErrorFlag = !(string.IsNullOrEmpty(data.DealerNameErrMsg)
                            && string.IsNullOrEmpty(data.NoErrMsg)
                            && string.IsNullOrEmpty(data.QuarterErrMsg)
                            && string.IsNullOrEmpty(data.Score1ErrMsg)
                            && string.IsNullOrEmpty(data.Score2ErrMsg)
                            );
                        if (data.LineNbr != 1)
                        {

                            list.Add(data);
                        }
                    }
                    dao.BatchInsert(list);
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

        /// <summary>
        /// 验证数据是否符合要求
        /// </summary>
        /// <returns></returns>
        public bool VerifyEndoScoreCardInit(string importType, out string IsValid)
        {
            bool result = false;
            //调用存储过程验证数据
            using (EndoScoreCardInitDao dao = new EndoScoreCardInitDao())
            {
                IsValid = dao.Initialize(importType, new Guid(_context.User.Id));
                result = true;
            }
            return result;
        }
        #endregion

        #region New Score Card
        public DataSet QueryEndoScoreCardHeaderByCondition(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            using (EndoScoreCardHeaderDao dao = new EndoScoreCardHeaderDao())
            {
                obj.Add("OwnerIdentityType", this._context.User.IdentityType);
                obj.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
                obj.Add("OwnerId", new Guid(this._context.User.Id));
                obj.Add("OwnerCorpId", this._context.User.CorpId);
                return dao.QueryEndoScoreCardHeaderByCondition(obj, start, limit, out totalRowCount);
            }
        }

        public DataSet QueryEndoScoreCardDetailById(Guid Id, int start, int limit, out int totalRowCount)
        {
            using (EndoScoreCardDetailDao dao = new EndoScoreCardDetailDao())
            {
                return dao.QueryEndoScoreCardDetailById(Id, start, limit, out totalRowCount);
            }
        }

        public EndoScoreCardHeader QueryEndoScoreCardHeaderByID(Guid Id)
        {
            using (EndoScoreCardHeaderDao dao = new EndoScoreCardHeaderDao())
            {
                return dao.QueryEndoScoreCardHeaderByID(Id);
            }
        }

        public DataSet ExportEndoScoreCardDetailForLP(Guid Id)
        {
            using (EndoScoreCardDetailDao dao = new EndoScoreCardDetailDao())
            {
                return dao.ExportEndoScoreCardDetailForLP(Id);
            }
        }
        #endregion
    }
}
