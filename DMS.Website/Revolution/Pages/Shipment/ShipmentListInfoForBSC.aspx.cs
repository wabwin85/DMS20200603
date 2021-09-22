using DMS.Business;
using DMS.Business.Cache;
using DMS.Common;
using DMS.Common.Common;
using DMS.Common.Extention;
using DMS.DataAccess;
using DMS.Model;
using DMS.Model.Data;
using DMS.ViewModel.Common;
using DMS.ViewModel.Shipment;
using Lafite.RoleModel.Security;
using Newtonsoft.Json;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DMS.Website.Revolution.Pages.Shipment
{
    public partial class ShipmentListInfoForBSC : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        [WebMethod]
        public static string InitDetailWinForBSC(string WinShipmentNbr)
        {
            ShipmentListVO model = new ShipmentListVO();
            try
            {
                //model = JsonConvert.DeserializeObject<ShipmentListVO>(strmodel);
                //IRoleModelContext context = RoleModelContext.Current;
                model.IsDealer = false;

                DealerMasterDao dealerMasterDao = new DealerMasterDao();
                model.LstDealerName = dealerMasterDao.SelectFilterListAll("");

                //产品线
                Guid DealerId = Guid.Empty;
                ShipmentHeaderDao daoShip = new ShipmentHeaderDao();
                bool IsAdminRole = true;
                model.IsAdmin = IsAdminRole;

                if (!IsAdminRole)
                {
                    if (!string.IsNullOrEmpty(model.QryDealerName.Key))
                    {
                        DealerId = new Guid(model.QryDealerName.Key.ToSafeString());
                    }
                    else
                    {
                        DealerId = RoleModelContext.Current.User.CorpId.ToSafeGuid();
                    }
                }
                else
                {
                    if (model.QryDealerName!=null&&!string.IsNullOrEmpty(model.QryDealerName.Key))
                    {
                        DealerId = new Guid(model.QryDealerName.Key.ToSafeString());
                    }
                    else
                    {
                        DealerId = new Guid("FB62D945-C9D7-4B0F-8D26-4672D2C728B7");
                    }
                }
                DealerMasters dm = new DealerMasters();
                model.LstWinSLProductLine = JsonHelper.DataTableToArrayList(dm.GetNoLimitProductLineByDealerAll(DealerId).Tables[0]);

                KeyValue kvDealer = new KeyValue();
                model.WinSLDealer = kvDealer;

                //清空旧页面数据
                model.WinSLOrderNo = string.Empty;
                model.WinSLShipmentDate = null;
                model.WinSLOrderStatus = string.Empty;
                model.WinSLOrderRemark = string.Empty;
                model.WinSLInvoiceDate = null;
                //added by hxw 20130705
                model.WinSLInvoiceHead = string.Empty;
                model.WinSLOrderType = string.Empty;
                //added by songweiming on 20100617
                model.WinSLInvoiceNo = string.Empty;

                Guid id = model.WinSLOrderId.ToSafeGuid();

                ShipmentHeader mainData = null;

                //若id为空，说明为新增，则生成新的id，并新增一条记录
                if (id == Guid.Empty && string.IsNullOrEmpty(model.WinShipmentNbr))
                {
                    id = Guid.NewGuid();
                    mainData = new ShipmentHeader();
                    mainData.Id = id;
                    mainData.DealerDmaId = RoleModelContext.Current.User.CorpId.ToSafeGuid();
                    mainData.Status = ShipmentOrderStatus.Draft.ToString();
                    mainData.UpdateDate = DateTime.Now;// added by songweiming on 20100628
                    mainData.Type = model.WinShipmentType.ToSafeString(); //added by hxw
                    if (IsAdminRole || model.WinIsShipmentUpdate.ToSafeString() == "UpdateShipment")
                    {
                        model.WinIsDetailUpdate = true;
                        mainData.AdjType = model.WinIsShipmentUpdate.ToSafeString();
                        if (IsAdminRole)
                        {
                            mainData.DealerDmaId = new Guid("FB62D945-C9D7-4B0F-8D26-4672D2C728B7");
                        }
                    }

                    daoShip.Insert(mainData);

                    //New 经销商为操作人的Corp
                    //this.hiddenDealerType.Text = RoleModelContext.Current.User.CorpType; // Added By Song Yuqi On 20140317
                    model.WinShipmentType = mainData.Type;
                }
                //根据ID查询主表数据，并初始化页面
                //mainData = daoShip.GetObject(id);
                mainData = daoShip.GetObjectByShipmentNbr(WinShipmentNbr);
                if (mainData == null)
                {
                    throw new Exception("传入参数有误");
                }
                model.WinSLOrderId = mainData.Id.ToString();

                //Added By Song Yuqi On 20140317 Begin
                //获得明细单中经销商的类型
                DealerMaster dma = new DealerMasters().GetDealerMaster(new Guid(mainData.DealerDmaId.ToSafeString()));
                //this.hiddenDealerType.Text = dma.DealerType;
                if (dma != null)
                {
                    model.WinSLDealerType = dma.DealerType;
                    model.LstDealerName = dealerMasterDao.SelectFilterListAll(dma.ChineseShortName);
                    model.WinSLDealer = new KeyValue(dma.Id.ToSafeString(), dma.ChineseShortName);
                }

                KeyValue kvProductLine = new KeyValue();
                if (mainData.ProductLineBumId != null)
                {
                    //this.hiddenProductLineId.Text = mainData.ProductLineBumId.Value.ToString();
                    kvProductLine.Key = mainData.ProductLineBumId.Value.ToString();
                    kvProductLine.Value = new ProductLineBLL().SelectProductLineName(mainData.ProductLineBumId.Value);
                }
                model.WinSLProductLine = kvProductLine;

                model.WinSLOrderNo = mainData.ShipmentNbr;
                if (mainData.ShipmentDate != null)
                {
                    model.WinSLShipmentDate = mainData.ShipmentDate;
                    model.HidShipDate = mainData.ShipmentDate.Value.ToString("yyyy-MM-dd");
                    //this.hiddenShipmentDate.Text = mainData.ShipmentDate.Value.ToString("yyyy-MM-dd");
                }

                KeyValue kvHospital = new KeyValue();
                if (mainData.HospitalHosId != null)
                {
                    HospitalDao hosDao = new HospitalDao();
                    Hospital hos = hosDao.GetHospital(mainData.HospitalHosId.Value);
                    //this.hiddenHospitalId.Text = mainData.HospitalHosId.Value.ToString();
                    kvHospital.Key = mainData.HospitalHosId.Value.ToString();
                    if (hos != null)
                    {
                        kvHospital.Value = hos.HosHospitalName;
                    }
                }
                model.WinSLHospital = kvHospital;

                if (mainData.InvoiceDate != null)
                {
                    model.WinSLInvoiceDate = mainData.InvoiceDate;
                }

                //added by songweiming on 20100617
                if (mainData.InvoiceNo != null)
                {
                    model.WinSLInvoiceNo = mainData.InvoiceNo;
                }

                if (mainData.InvoiceTitle != null)
                {
                    model.WinSLInvoiceHead = mainData.InvoiceTitle;
                }

                if (mainData.IsAuth != null)
                {
                    if (mainData.IsAuth.Value)
                    {
                        model.WinIsAuth = "1";
                    }
                    else
                    {
                        model.WinIsAuth = "0";
                    }
                }
                else
                {
                    model.WinIsAuth = "0";
                }

                //Added By Song Yuqi On 20140317 Begin
                if (mainData.Type != null)
                {
                    model.WinShipmentType = mainData.Type;
                }
                //Added By Song Yuqi On 20140317 End

                model.WinSLOrderStatus = DictionaryCacheHelper.GetDictionaryNameById(SR.Consts_ShipmentOrder_Status, mainData.Status);
                model.WinSLOrderRemark = mainData.NoteForPumpSerialNbr;
                //added by hxw
                if (mainData.Type != null)
                    model.WinSLOrderType = DictionaryCacheHelper.GetDictionaryNameById(SR.Consts_ShipmentOrder_Type, mainData.Type);

                if (!String.IsNullOrEmpty(mainData.Id.ToSafeString()) && !String.IsNullOrEmpty(mainData.ShipmentDate.ToString()))
                {
                    Guid tid = new Guid(mainData.Id.ToSafeString());

                    Hashtable param1 = new Hashtable();
                    ShipmentLotDao daoLot = new ShipmentLotDao();

                    param1.Add("HeaderId", tid);
                    param1.Add("ShipmentDate", mainData.ShipmentDate.ToSafeDateTime().ToString("yyyy-MM-dd"));

                    DataSet ds = daoLot.SelectByFilter(param1);
                    DataSet dsSum = daoLot.SelectSumByFilter(param1);

                    model.WinProductQty = "销售总数量:" + dsSum.Tables[0].Rows[0]["TotalQty"].ToString();
                    model.WinProductSum = "销售总金额:" + dsSum.Tables[0].Rows[0]["TotalPrice"].ToString();
                    model.RstWinSLProductList = JsonHelper.DataTableToArrayList(ds.Tables[0]);

                }

                if (false)
                {

                    if (mainData.Status == ShipmentOrderStatus.Draft.ToString())
                    {

                        //Added By huyong On 20161023 End
                        ShipmentLotDao daoLot = new ShipmentLotDao();
                        model.WinShowReasonBtn = daoLot.SelectShipmentLimitBUCount(RoleModelContext.Current.User.CorpId.Value).Tables[0].Rows[0]["cnt"].ToString() == "0";

                        model = GetShipmentDate(model);
                    }

                    if (mainData.Status == ShipmentOrderStatus.Complete.ToString())
                    {
                        
                    }
                }
                else
                {
                    if (mainData.Status == ShipmentOrderStatus.Complete.ToString())
                    {
                        //this.SubmitButton.Text = GetLocalResourceObject("UpdateInvoiceInfo").ToString();

                        if (IsAdminRole || model.WinIsShipmentUpdate.Equals("UpdateShipment"))
                        {
                            if (mainData.Status == ShipmentOrderStatus.Complete.ToString() && daoShip.SelectAdminRoleAction(mainData.Id))
                            {
                                model.WinDisablePriceBtn = true;
                            }
                            //if (mainData.Status == ShipmentOrderStatus.Complete.ToString() && IsDealer && (context.User.CorpId.Value.ToString() == mainData.DealerDmaId.ToString()))
                            //{
                            //    model.WinDisablePriceBtn = true;
                            //}
                        }

                    }
                }
                //绑定医院
                Hashtable ht = new Hashtable();

                ht.Add("DealerId", mainData.DealerDmaId);
                //param.Add("DealerId", cbDealerWin.SelectedItem.Value);
                ht.Add("ProductLine", mainData.ProductLineBumId);
                ht.Add("ShipmentDate", mainData.ShipmentDate);

                DataSet dsH = dm.SelectHospitalForDealerByShipmentDate(ht);
                DataView dv = dsH.Tables[0].DefaultView;
                DataTable dt = dv.ToTable(true, "Id", "Name");
                model.LstWinSLHospital = JsonHelper.DataTableToArrayList(dt);

                AttachmentDao dao = new AttachmentDao();
                int totalCount = 0;

                Hashtable param = new Hashtable();
                param.Add("MainId", model.WinSLOrderId);
                param.Add("Type", AttachmentType.ShipmentToHospital.ToString());

                int start = 0;
                model.RstWinSLAttachList = JsonHelper.DataTableToArrayList(dao.GetAttachmentByMainId(param, start, int.MaxValue, out totalCount).Tables[0]);


            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model.ToJsonString();
        }
        private static ShipmentListVO GetShipmentDate(ShipmentListVO model)
        {

            ShipmentUtil util = new ShipmentUtil();
            CalendarDate cd = util.GetCalendarDate();

            DealerMasters dm = new DealerMasters();
            DataSet ds = dm.GetProductLineByDealer(RoleModelContext.Current.User.CorpId.Value);

            Nullable<DateTime> EffectiveDate = null;
            Nullable<DateTime> ExpirationDate = null;
            int ActiveFlag;
            int IsShare;
            DataTable dt = util.GetContractDate(RoleModelContext.Current.User.CorpId.Value, string.IsNullOrEmpty(model.WinSLProductLine.Key) ? ds.Tables[0].Rows[0]["Id"].ToString() : model.WinSLProductLine.Key.ToSafeString());
            if (cd != null)
            {
                int limitNo = Convert.ToInt32(cd.Date1);

                int day = DateTime.Now.Day - 1;

                if (dt.Rows.Count > 0)
                {
                    EffectiveDate = Convert.ToDateTime(dt.Rows[0]["EffectiveDate"].ToString());
                    ExpirationDate = Convert.ToDateTime(dt.Rows[0]["ExpirationDate"].ToString());
                    ActiveFlag = Convert.ToInt32(dt.Rows[0]["ActiveFlag"].ToString());
                    IsShare = Convert.ToInt32(dt.Rows[0]["IsShare"].ToString());
                    if (ActiveFlag > 0)
                    {
                        if (day >= limitNo)
                        {
                            model.WinSLShipDate_Min = DateTime.Now.AddDays(-day).Date > EffectiveDate.Value ? DateTime.Now.AddDays(-day).Date : EffectiveDate.Value;
                        }
                        else
                        {
                            model.WinSLShipDate_Min = DateTime.Now.AddDays(-day).AddMonths(-1).Date > EffectiveDate.Value ? DateTime.Now.AddDays(-day).AddMonths(-1).Date : EffectiveDate.Value;
                        }
                        model.WinSLShipDate_Max = DateTime.Now.Date > ExpirationDate.Value ? ExpirationDate.Value : DateTime.Now.Date;
                    }
                    else if (ActiveFlag == 0 && IsShare > 0)
                    {
                        if (day >= limitNo)
                        {
                            model.WinSLShipDate_Min = DateTime.Now.AddDays(-day).Date;
                        }
                        else
                        {
                            model.WinSLShipDate_Min = DateTime.Now.AddDays(-day).AddMonths(-1).Date;
                        }
                        model.WinSLShipDate_Max = DateTime.Now.Date;
                    }
                    else
                    {
                        model.WinSLShipDate_Min = EffectiveDate.Value;
                        model.WinSLShipDate_Max = ExpirationDate.Value;
                    }
                }
                else
                {
                    if (day >= limitNo)
                    {
                        model.WinSLShipDate_Min = DateTime.Now.AddDays(-day).Date;
                    }
                    else
                    {
                        model.WinSLShipDate_Min = DateTime.Now.AddDays(-day).AddMonths(-1).Date;
                    }
                    model.WinSLShipDate_Max = DateTime.Now.Date;
                }

            }
            return model;

        }
    }
}