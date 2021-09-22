using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;


namespace DMS.Business
{
    using Coolite.Ext.Web;
    using Grapecity.DataAccess.Transaction;
    using Lafite.RoleModel.Security;
    using DMS.DataAccess;
    using DMS.Model;
    using DMS.Common;
    using System.Collections;
    using DataInterface;

    public class DeliveryNotes : IDeliveryNotes
    {
        public DeliveryNotes()
        {
        }

        public DeliveryNote GetDeliveryNote(Guid DNId)
        {
            using (DeliveryNoteDao dao = new DeliveryNoteDao())
            {
                return dao.GetObject(DNId);
            }
        }

        /// <summary>
        /// Gets all dealers , by donson
        /// </summary>
        /// <returns></returns>
        public IList<DeliveryNote> GetAll()
        {
            using (DeliveryNoteDao dao = new DeliveryNoteDao())
            {
                return dao.GetAll();
            }
        }

        public IList<DeliveryNote> GetDeliveryNoteWithoutDealer()
        {
            using (DeliveryNoteDao dao = new DeliveryNoteDao())
            {
                return dao.GetDeliveryNoteWithoutDealer();
            }
        }
        public IList<DeliveryNote> GetDeliveryNoteWithoutCFN()
        {
            using (DeliveryNoteDao dao = new DeliveryNoteDao())
            {
                return dao.GetDeliveryNoteWithoutCFN();
            }
        }

        public void ImportPOReceipt()
        {
            using (DeliveryNoteDao dao = new DeliveryNoteDao())
            {
                dao.ImportPOReceipt();
            }
        }


        public  DataSet GetUnauthorizationPOReceipt()
        {
            using (DeliveryNoteDao dao = new DeliveryNoteDao())
            {
                return dao.GetUnauthorizationPOReceipt();
            }
        }

        public IList<DeliveryNote> QueryForDeliveryNote(DeliveryNote deliveryNote)
        {
            using (DeliveryNoteDao dao = new DeliveryNoteDao())
            {
                return dao.SelectByFilter(deliveryNote);
            }
        }

        #region CUID functions
        /// <summary>
        /// 新增
        /// </summary>
        /// <param name="hospital"></param>
        /// <returns></returns>
        public bool Insert(DeliveryNote deliveryNote)
        {
            bool result = false;
            using (DeliveryNoteDao dao = new DeliveryNoteDao())
            {

                deliveryNote.CreateDate = DateTime.Now;
                dao.Insert(deliveryNote);
                result = true;
            }
            return result;
        }

        /// <summary>
        /// 修改
        /// </summary>
        /// <param name="hospital"></param>
        /// <returns></returns>
        public bool Update(DeliveryNote deliveryNote)
        {
            bool result = false;
            using (DeliveryNoteDao dao = new DeliveryNoteDao())
            {
                int afterRow = dao.Update(deliveryNote);
                result = true;
            }
            return result;
        }

        /// <summary>
        /// 删除
        /// </summary>
        /// <param name="hospitalId"></param>
        /// <returns></returns>
        public bool Delete(Guid id)
        {
            bool result = false;

            using (DeliveryNoteDao dao = new DeliveryNoteDao())
            {
                int afterRow = dao.Delete(id);
            }
            return result;
        }

        #endregion

        public DataSet QueryDeliveryNote(Hashtable table, int start, int limit, out int totalRowCount)
        {
            //获取当前登录身份类型以及所属组织
            table.Add("OwnerIdentityType", this._context.User.IdentityType);
            table.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            table.Add("OwnerId", new Guid(this._context.User.Id));
            table.Add("IsDealerActive", 1);
            BaseService.AddCommonFilterCondition(table);
            using (DeliveryNoteDao dao = new DeliveryNoteDao())
            {
                return dao.SelectByHashtable(table, start, limit, out totalRowCount);
            }
        }

        public DataSet QueryDeliveryNote(Hashtable table)
        {
            //获取当前登录身份类型以及所属组织
            table.Add("OwnerIdentityType", this._context.User.IdentityType);
            table.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            table.Add("OwnerId", new Guid(this._context.User.Id));
            table.Add("IsDealerActive", 1);

            using (DeliveryNoteDao dao = new DeliveryNoteDao())
            {
                return dao.SelectByHashtable(table);
            }
        }
        public IList<DeliveryNote> Import(DataTable dt,string strNbr,string IsVR="")
        {
            try
            {
                IList<InterfaceShipment> importData = new List<InterfaceShipment>();
                int line = 1;
                foreach (DataRow dr in dt.Rows)
                {
                    //string errString = string.Empty;
                    InterfaceShipment data = new InterfaceShipment();
                    data.Id = Guid.NewGuid();
                    data.CreateUser = new Guid(_context.User.Id);
                    data.CreateDate = DateTime.Now;

                    data.DealerSapCode = dr[0] == DBNull.Value ? null : dr[0].ToString();
                    data.OrderNo = dr[1] == DBNull.Value ? null : dr[1].ToString();
                    data.SapDeliveryNo = dr[2] == DBNull.Value ? null : dr[2].ToString();
                    string strDeliveryDate = dr[3] == DBNull.Value ? null : dr[3].ToString();
                    if (!string.IsNullOrEmpty(strDeliveryDate))
                    {
                        DateTime date;
                        if (DateTime.TryParse(strDeliveryDate, out date))
                            data.SapDeliveryDate = date;
                        else
                            data.SapDeliveryDate = null;
                    }
                    else
                    {
                        data.SapDeliveryDate = null;
                    }
                    data.ShipmentType = dr[4] == DBNull.Value ? null : dr[4].ToString();
                    data.ExpressCompany = dr[5] == DBNull.Value ? null : dr[5].ToString();
                    data.ExpressNo = dr[6] == DBNull.Value ? null : dr[6].ToString();
                    data.ShipType = dr[7] == DBNull.Value ? null : dr[7].ToString();
                    data.ArticleNumber = dr[8] == DBNull.Value ? null : dr[8].ToString();
                    data.LotNumber = dr[9] == DBNull.Value ? null : dr[9].ToString();
                    string strExpiredDate = dr[10] == DBNull.Value ? null : dr[10].ToString();
                    if (!string.IsNullOrEmpty(strExpiredDate))
                    {
                        DateTime date;
                        if (DateTime.TryParse(strExpiredDate, out date))
                            data.ExpiredDate = date;
                        else
                            data.ExpiredDate = null;
                    }
                    else
                    {
                        data.ExpiredDate = null;
                    }
                    string strDeliveryQty = dr[11] == DBNull.Value ? null : dr[11].ToString();
                    if (!string.IsNullOrEmpty(strDeliveryQty))
                    {
                        decimal qty;
                        if (Decimal.TryParse(strDeliveryQty, out qty)) {                          
                           if (qty < 0)
                                data.DeliveryQty = 0;
                           else
                            {
                                data.DeliveryQty = qty;
                            }
                        }
                        else
                        {
                            data.DeliveryQty = null;
                        }
                    }
                    else
                    {
                        data.DeliveryQty = null;
                    }
                    string strUnitPrice = dr[12] == DBNull.Value ? null : dr[12].ToString();
                    if (!string.IsNullOrEmpty(strUnitPrice))
                    {
                        decimal qty;
                        if (Decimal.TryParse(strUnitPrice, out qty))
                        {
                            if (qty < 0)
                            {
                                data.UnitPrice = 0;
                            }
                            else
                            {
                                data.UnitPrice = qty;
                            }
                        }
                        else
                        {
                            data.UnitPrice = null;
                        }
                    }
                    else
                    {
                        data.UnitPrice = null;
                    }
                    string strShippingDate = dr[13] == DBNull.Value ? null : dr[13].ToString();
                    if (!string.IsNullOrEmpty(strShippingDate))
                    {
                        DateTime date;
                        if (DateTime.TryParse(strShippingDate, out date))
                            data.ShippingDate = date;
                        else
                            data.ShippingDate = null;
                    }
                    else
                    {
                        data.ShippingDate = null;
                    }
                    //data.ToWhmCode = dr[14] == DBNull.Value ? null : dr[14].ToString();
                    data.QrCode = dr[14] == DBNull.Value ? null : dr[14].ToString();
                    string strTaxRate = dr[15] == DBNull.Value ? null : dr[15].ToString();
                    if (!string.IsNullOrEmpty(strTaxRate))
                    {
                        decimal qty;
                        if (Decimal.TryParse(strTaxRate, out qty))
                        {
                            if (qty < 0)
                                data.TaxRate = 0;
                            else
                            {
                                data.TaxRate = qty;
                            }
                        }
                        else
                        {
                            data.TaxRate = null;
                        }
                    }
                    else
                    {
                        data.TaxRate = null;
                    }
                    data.ERPNbr = dr[16] == DBNull.Value ? null : dr[16].ToString();
                    data.ERPLineNbr = dr[17] == DBNull.Value ? null : dr[17].ToString();
                    string strERPAmount = dr[18] == DBNull.Value ? null : dr[18].ToString();
                    if (!string.IsNullOrEmpty(strERPAmount))
                    {
                        decimal qty;
                        if (Decimal.TryParse(strERPAmount, out qty))
                        {
                            if (qty < 0)
                                data.ERPAmount = 0;
                            else
                            {
                                data.ERPAmount = qty;
                            }
                        }
                        else
                        {
                            data.ERPAmount = null;
                        }
                    }
                    else
                    {
                        data.ERPAmount = null;
                    }
                    string strERPTaxRate = dr[19] == DBNull.Value ? null : dr[19].ToString();
                    if (!string.IsNullOrEmpty(strERPTaxRate))
                    {
                        decimal qty;
                        if (Decimal.TryParse(strERPTaxRate, out qty))
                        {
                            if (qty < 0)
                                data.ERPTaxRate = 0;
                            else
                            {
                                data.ERPTaxRate = qty;
                            }
                        }
                        else
                        {
                            data.ERPTaxRate = null;
                        }
                    }
                    else
                    {
                        data.ERPTaxRate = null;
                    }
                    data.LineNbr = line;
                    data.ImportDate = DateTime.Now;
                    data.Clientid = _context.User.UserName;
                    data.BatchNbr = strNbr;
                    if (line != 1)
                    {
                        importData.Add(data);
                    }
                    line++;
                }
                //导入接口表
                DeliveryBLL business = new DeliveryBLL();
                business.ImportInterfaceShipment(importData);
                //调用存储过程导入DeliveryNote表，并返回结果
                string RtnMsg = string.Empty;
                string IsValid = string.Empty;
                if (IsVR == "1")
                {
                    business.HandleShipmentDataVR(strNbr, _context.User.UserName, out IsValid, out RtnMsg);
                }
                else
                {
                    business.HandleShipmentData(strNbr, _context.User.UserName, out IsValid, out RtnMsg);
                }
                //如果调用过程失败则抛错
                if (!IsValid.Equals("Success"))
                    throw new Exception(RtnMsg);

                //如果调用过程成功，则检查是否存在未通过验证的数据
                IList<DeliveryNote> errList = business.SelectDeliveryNoteByBatchNbrErrorOnly(strNbr);

                return errList;
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }

            
        }
        private IRoleModelContext _context = RoleModelContext.Current;

        #region 发货数据上传
        /// <summary>
        /// 上传文件对应列标，从0开始
        /// </summary>
        public enum DeliveryInitColumnIndex
        {
            OrderNo = 0,
            ArticleNo = 1,
            Batch = 2,
            SapDeliveryNo = 3,
            ShippingDate = 4,
            Carrier = 5,
            TrackingNo = 6,
            DeliveryQty = 7,
            ShipType = 8,
            Note = 9,
            SAPAccount = 10,
        }

        public bool Import(string file, DataSet ds)
        {
            bool result = false;

            using (TransactionScope trans = new TransactionScope())
            {
                DeliveryInitDao dao = new DeliveryInitDao();
                //删除上传人的数据
                dao.DeleteDeliveryInitByUser(new Guid(_context.User.Id));
                //读取DataSet数据至数据库
                int lineNbr = 1;
                bool isRight = true;
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    string errString = string.Empty;
                    DeliveryInit data = new DeliveryInit();

                    data.Id = Guid.NewGuid();
                    data.User = new Guid(_context.User.Id);
                    data.UploadDate = DateTime.Now;
                    data.LineNbr = lineNbr++;
                    data.FileName = file;
                    //OrderNo
                    if (dr[(int)DeliveryInitColumnIndex.OrderNo] == DBNull.Value)
                    {
                        errString += "订单编号不能为空,";
                    }
                    else
                    {
                        data.OrderNo = dr[(int)DeliveryInitColumnIndex.OrderNo].ToString();
                    }
                    //ArticleNo
                    if (dr[(int)DeliveryInitColumnIndex.ArticleNo] == DBNull.Value)
                    {
                        errString += "产品型号不能为空,";
                    }
                    else
                    {
                        data.ArticleNo = dr[(int)DeliveryInitColumnIndex.ArticleNo].ToString();
                    }
                    //Batch
                    if (dr[(int)DeliveryInitColumnIndex.Batch] == DBNull.Value)
                    {
                        errString += "产品批号不能为空,";
                    }
                    else
                    {
                        data.LotNumber = dr[(int)DeliveryInitColumnIndex.Batch].ToString();
                    }
                    //SapDeliveryNo
                    if (dr[(int)DeliveryInitColumnIndex.SapDeliveryNo] == DBNull.Value)
                    {
                        errString += "ERP发货单号不能为空,";
                    }
                    else
                    {
                        data.SapDeliveryNo = dr[(int)DeliveryInitColumnIndex.SapDeliveryNo].ToString();
                    }
                    //ShippingDate
                    if (dr[(int)DeliveryInitColumnIndex.ShippingDate] == DBNull.Value)
                    {
                        errString += "ERP发货日期不能为空,";
                    }
                    else
                    {
                        try
                        {
                            data.ShippingDate = DateTime.Parse(dr[(int)DeliveryInitColumnIndex.ShippingDate].ToString());
                        }
                        catch
                        {
                            errString += "ERP发货日期格式不正确,";
                        }
                    }
                    //Carrier
                    if (dr[(int)DeliveryInitColumnIndex.Carrier] == DBNull.Value)
                    {
                        errString += "承运方不能为空,";
                    }
                    else
                    {
                        data.Carrier = dr[(int)DeliveryInitColumnIndex.Carrier].ToString();
                    }
                    //TrackingNo
                    if (dr[(int)DeliveryInitColumnIndex.TrackingNo] == DBNull.Value)
                    {
                        errString += "运单号不能为空,";
                    }
                    else
                    {
                        data.TrackingNo = dr[(int)DeliveryInitColumnIndex.TrackingNo].ToString();
                    }
                    //DeliveryQty
                    if (dr[(int)DeliveryInitColumnIndex.DeliveryQty] == DBNull.Value)
                    {
                        errString += "发货数量不能为空,";
                    }
                    else
                    {
                        try
                        {
                            data.DeliveryQty = Convert.ToDouble(dr[(int)DeliveryInitColumnIndex.DeliveryQty].ToString());
                        }
                        catch
                        {
                            errString += "发货数量格式不正确,";
                        }
                    }
                    //ShipType
                    if (dr[(int)DeliveryInitColumnIndex.ShipType] == DBNull.Value)
                    {
                        //errString += "运输方式不能为空,";
                    }
                    else
                    {
                        data.ShipType = dr[(int)DeliveryInitColumnIndex.ShipType].ToString();
                    }
                    //Note
                    if (dr[(int)DeliveryInitColumnIndex.Note] == DBNull.Value)
                    {
                        //errString += "说明不能为空,";
                    }
                    else
                    {
                        data.Note = dr[(int)DeliveryInitColumnIndex.Note].ToString();
                    }
                    //SAPAccount
                    if (dr[(int)DeliveryInitColumnIndex.SAPAccount] == DBNull.Value)
                    {
                        errString += "经销商ERP帐号不能为空,";
                    }
                    else
                    {
                        data.SapCode = dr[(int)DeliveryInitColumnIndex.SAPAccount].ToString();
                    }

                    data.ErrorFlag = !string.IsNullOrEmpty(errString);
                    data.ErrorDescription = errString;

                    if (data.ErrorFlag && isRight)
                    {
                        isRight = false;
                    }

                    dao.Insert(data);
                }
                result = isRight;

                trans.Complete();
            }
            return result;
        }

        public IList<DeliveryInit> QueryErrorDeliveryInit(int start, int limit, out int totalRowCount)
        {
            using (DeliveryInitDao dao = new DeliveryInitDao())
            {
                Hashtable param = new Hashtable();
                param.Add("User", new Guid(_context.User.Id));
                param.Add("ErrorFlag", true);
                return dao.QueryErrorDeliveryInit(param, start, limit, out totalRowCount);
            }
        }

        public bool Generate(out string IsValid)
        {
            bool result = false;

            Hashtable ht = new Hashtable();
            BaseService.AddCommonFilterCondition(ht);
            using (DeliveryInitDao dao = new DeliveryInitDao())
            {
                IsValid = dao.Generate(new Guid(_context.User.Id), Convert.ToString(ht["SubCompanyId"]), Convert.ToString(ht["BrandId"]));
                result = true;
            }
            return result;
        }
        #endregion
    }
}
