using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

using Grapecity.DataAccess.Transaction;
using Lafite.RoleModel.Security;
using Lafite.RoleModel.Security.Authorization;
using Grapecity.Logging.CallHandlers;
using DMS.DataAccess;
using DMS.Model;
using System.Web.SessionState;

namespace DMS.Business
{
    public class ProLargessFort2BLL : IProLargessFort2BLL, IRequiresSessionState
    {
        #region IPromotionPolicyBLL 成员
        IRoleModelContext _context = RoleModelContext.Current;

        //用户下载模板直接删除
        public int DeleteLargessForT2Init(Guid userId)
        {
            //调用存储过程验证数据
            using (ProLargessFort2InitDao dao = new ProLargessFort2InitDao())
            {
                return dao.DeleteLargessForT2Init(userId);

            }
        }
        /// <summary>
        /// 积分导入
        /// </summary>
        /// <param name="dt"></param>
        /// <param name="fileName"></param>
        /// <returns></returns>
        public bool ImportLargessForT2(DataTable dt, string fileName)
        {
            System.Diagnostics.Debug.WriteLine("Import Start : " + DateTime.Now.ToString());
            bool result = false;
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    ProLargessFort2InitDao dao = new ProLargessFort2InitDao();
                    //删除上传人的数据
                    dao.DeleteLargessForT2Init(new Guid(_context.User.Id));

                    int lineNbr = 1;
                    IList<ProLargessFort2Init> list = new List<ProLargessFort2Init>();
                    foreach (DataRow dr in dt.Rows)
                    {
                        //string errString = string.Empty;
                        ProLargessFort2Init data = new ProLargessFort2Init();
                        data.Id = Guid.NewGuid();
                        data.UserId = new Guid(_context.User.Id);

                        data.PolicyType = dr[0] == DBNull.Value ? null : dr[0].ToString();
                        if (string.IsNullOrEmpty(data.PolicyType))
                            data.PolicyTypeErrmsg = "赠送类型为空";

                        data.PolicyNo = dr[1] == DBNull.Value ? null : dr[1].ToString();
                        if (string.IsNullOrEmpty(data.PolicyNo))
                            data.PolicyNoErrMsg = "促销编号为空";

                        data.SapCode = dr[2] == DBNull.Value ? null : dr[2].ToString();
                        if (string.IsNullOrEmpty(data.SapCode))
                            data.SapCodeErrMsg = "经销商编号为空";

                        data.Bu = dr[4] == DBNull.Value ? null : dr[4].ToString();
                        if (string.IsNullOrEmpty(data.Bu))
                            data.BuErrMsg = "产品线为空";

                        data.AuthProductType = dr[5] == DBNull.Value ? null : dr[5].ToString();

                        data.PL5 = dr[6] == DBNull.Value ? null : dr[6].ToString();

                        //积分额度校验
                        //if (!string.IsNullOrEmpty(data.PolicyType) && data.PolicyType.Equals("积分"))
                        {
                            data.ValidDate = dr[7] == DBNull.Value ? null : dr[7].ToString();
                            if (!string.IsNullOrEmpty(data.ValidDate))
                            {
                                DateTime date;
                                if (DateTime.TryParse(data.ValidDate, out date))
                                    data.ValidDate = date.ToString("yyyy-MM-dd");
                                else
                                    data.ValidDateErrMsg = "有效期格式不正确";
                            }
                            else
                            {
                                data.ValidDateErrMsg = "有效期为空";
                            }
                        }

                        //积分额度校验
                        if (!string.IsNullOrEmpty(data.PolicyType) && data.PolicyType.Equals("积分"))
                        {
                            data.PointType = dr[8] == DBNull.Value ? null : dr[8].ToString();
                            if (string.IsNullOrEmpty(data.PointType))
                                data.PointTypeErrMsg = "积分类型为空";
                        }

                        if (!string.IsNullOrEmpty(data.PolicyType) && data.PolicyType.Equals("积分"))
                        {
                            data.FreeGoods = dr[9] == DBNull.Value ? null : dr[9].ToString();
                            if (!string.IsNullOrEmpty(data.FreeGoods))
                            {
                                decimal qty;
                                if (!Decimal.TryParse(data.FreeGoods, out qty))
                                    data.FreeGoodsErrMsg = "积分额度格式不正确";
                                else if (Decimal.Parse(data.FreeGoods) < 0)
                                    data.FreeGoodsErrMsg = "积分额度不能小于0";

                            }
                            else
                            {
                                data.FreeGoodsErrMsg = "积分额度为空";
                            }
                        }
                        else
                        {
                            data.FreeGoods = dr[9] == DBNull.Value ? null : dr[9].ToString();
                            if (!string.IsNullOrEmpty(data.FreeGoods))
                            {
                                int qty;
                                if (!Int32.TryParse(data.FreeGoods, out qty))
                                    data.FreeGoodsErrMsg = "赠品数量格式不正确，必须为整数,";
                                else if (Decimal.Parse(data.FreeGoods) < 0)
                                    data.FreeGoodsErrMsg = "赠品数量不能小于0";

                            }
                            else
                            {
                                data.FreeGoodsErrMsg = "赠品数量为空";
                            }
                        }

                        data.CurrentPeriod = dr[10] == DBNull.Value ? null : dr[10].ToString();
                        if (string.IsNullOrEmpty(data.CurrentPeriod))
                            data.CurrentPeriodErrMsg = "促销账期为空";


                        data.LineNbr = lineNbr++;
                        data.ErrorFlag = !(string.IsNullOrEmpty(data.PolicyTypeErrmsg)
                            && string.IsNullOrEmpty(data.PolicyNoErrMsg)
                            && string.IsNullOrEmpty(data.SapCodeErrMsg)
                            && string.IsNullOrEmpty(data.BuErrMsg)
                            && string.IsNullOrEmpty(data.ValidDateErrMsg)
                            && string.IsNullOrEmpty(data.PointTypeErrMsg)
                            && string.IsNullOrEmpty(data.FreeGoodsErrMsg)
                            && string.IsNullOrEmpty(data.CurrentPeriodErrMsg)
                            );

                        if (data.LineNbr != 1)
                        {
                            list.Add(data);
                        }

                    }
                    dao.ProLargessFort2Insert(list);
                    result = true;

                    trans.Complete();
                }
            }
            catch (Exception ex)
            {
                string strEx = ex.Message.ToString();
            }
            System.Diagnostics.Debug.WriteLine("Import Finish : " + DateTime.Now.ToString());

            return result;
        }

        public bool VerifyLargessForT2InitBLL(string ImportType, out string IsValid)
        {
            bool result = false;
            //调用存储过程验证数据
            using (ProLargessFort2InitDao dao = new ProLargessFort2InitDao())
            {
                IsValid = dao.Initialize(ImportType, new Guid(_context.User.Id),BaseService.CurrentBrand?.Key);
                result = true;
            }
            return result;
        }

        public DataSet QueryLargessForT2ErrorData(int start, int limit, out int totalRowCount)
        {
            using (ProLargessFort2InitDao dao = new ProLargessFort2InitDao())
            {
                Hashtable param = new Hashtable();
                param.Add("UserId", new Guid(_context.User.Id));
                //param.Add("ErrorFlag", true);
                return dao.SelectLargessForT2ErrorData(param, start, limit, out totalRowCount);
            }
        }
        public DataSet LargessForT2InitSumString()
        {
            using (ProLargessFort2InitDao dao = new ProLargessFort2InitDao())
            {
                return dao.LargessForT2InitSumString(_context.User.Id);
            }
        }
        #endregion
    }
}
