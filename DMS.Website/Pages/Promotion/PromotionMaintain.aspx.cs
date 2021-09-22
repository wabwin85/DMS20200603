using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Coolite.Ext.Web;
using DMS.Website.Common;
using DMS.Business;
using DMS.Model;
using DMS.Common;
using System.Collections;
using System.Data;
using DMS.Business.Cache;
using DMS.Model.Data;
using Lafite.RoleModel.Security;
using Microsoft.Practices.Unity;
using System.IO;
namespace DMS.Website.Pages.Promotion
{
    public partial class PromotionMaintain : BasePage
    {
        IRoleModelContext _context = RoleModelContext.Current;
        private IPromotionPolicyBLL _business = new PromotionPolicyBLL();
        private IPurchaseOrderBLL _bs = null;
        private IAttachmentBLL _attachmentBLL = null;

        IPOReceipt PORbusiness = new DMS.Business.POReceipt();
        IShipmentBLL Shbll = new ShipmentBLL();


        [Dependency]
        public IAttachmentBLL attachmentBLL
        {
            get { return _attachmentBLL; }
            set { _attachmentBLL = value; }
        }
        [Dependency]
        public IPurchaseOrderBLL bs
        {
            get { return _bs; }
            set { _bs = value; }
        }
        public string PolicyRuleId
        {
            get
            {
                return this.hidWd4PolicyRuleId.Text;
            }
            set
            {
                this.hidWd4PolicyRuleId.Text = value.ToString();
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                this.hiddenMainId.Value = Guid.NewGuid();
            }
        }

        [AjaxMethod]
        public void DelaerAdd(string dealerId, string dealername)
        {
            UpdateContainDealers(dealerId, "包含");
            Hashtable ht = new Hashtable();
            ht.Add("ContractUser", _context.User.Id);
            ht.Add("OperationType", "经销商范围调整");
            ht.Add("Remarks", _context.UserName + "在" + DateTime.Now + "修改了" + this.PromotionID.Value + "的促销结算经销商，添加包含了经销商" + dealername);
            ht.Add("OrderNo", this.PromotionID.Value);
            bs.InsertOrderOperationLog(ht);
        }

        [AjaxMethod]
        public void DelaerExclusive(string dealerId, string dealername)
        {
            UpdateContainDealers(dealerId, "不包含");
            Hashtable ht = new Hashtable();
            ht.Add("ContractUser", _context.User.Id);
            ht.Add("OperationType", "经销商范围调整");
            ht.Add("Remarks", _context.UserName + "在" + DateTime.Now + "修改了" + this.PromotionID.Value + "的促销结算经销商，添加不包含经销商" + dealername);
            ht.Add("OrderNo", this.PromotionID.Value);
            bs.InsertOrderOperationLog(ht);
        }

        [AjaxMethod]
        public void DeleteSelectedDealer(string dealerId, string dealername)
        {

            Hashtable obj = new Hashtable();
            obj.Add("CurrUser", _context.User.Id);
            obj.Add("DEALERID", dealerId);
            _business.DeleteSelectedDealer(obj);
            Hashtable ht = new Hashtable();
            ht.Add("ContractUser", _context.User.Id);
            ht.Add("OperationType", "经销商范围调整");
            ht.Add("Remarks", _context.UserName + "在" + DateTime.Now + "修改了" + this.PromotionID.Value + "的促销结算经销商，删除了经销商" + dealername);
            ht.Add("OrderNo", this.PromotionID.Value);
            bs.InsertOrderOperationLog(ht);
        }
        [AjaxMethod]
        public void show(string PolicyNo)
        {
            string msg = getid(PolicyNo);
            if (msg == "")
            {
                if (this.type.SelectedItem.Value.ToString() == "产品调整" || this.type.SelectedItem.Value.ToString() == "医院调整")
                {
                    this.GridFolicyFactor.Reload();
                    this.PolicyFactorswindow.Show();

                }

                if (this.type.SelectedItem.Value.ToString() == "经销商范围调整")
                {
                    this.GridWd7PolicyDealer.Reload();
                    this.GridWd3PolicyDealerSeleted.Reload();
                    this.wd7PolicyDealer.Show();
                }
                if (this.type.SelectedItem.Value.ToString() == "规则调整")
                {

                    this.GridFactorRule.Reload();
                    this.wd4PolicyRule.Show();
                }

                if (this.type.SelectedItem.Value.ToString() == "状态调整")
                {
                    if (StatusUpdate() == false)
                    {
                        Ext.Msg.Show(new MessageBox.Config
                        {
                            Buttons = MessageBox.Button.OK,
                            Icon = MessageBox.Icon.INFO,
                            Title = "提示",
                            Message = "修改失败！"
                        });

                    }
                    else
                    {
                        Ext.Msg.Show(new MessageBox.Config
                        {
                            Buttons = MessageBox.Button.OK,
                            Icon = MessageBox.Icon.INFO,
                            Title = "提示",
                            Message = "修改成功！"
                        });
                        this.hiddenMainId.Value = Guid.NewGuid();
                    }
                    this.PromotionID.Text = "";
                    this.PolicyTypeNow.Text = "";
                    this.type.SelectedItem.Value = "";
                    this.PolicyTypeChange.Hidden = true;
                    this.PolicyTypeNow.Hidden = true;
                    this.GpWdAttachment.Reload();
                }
            }
            else
            {
                Ext.Msg.Show(new MessageBox.Config
                {
                    Buttons = MessageBox.Button.OK,
                    Icon = MessageBox.Icon.INFO,
                    Title = "提示",
                    Message = msg
                });

            }

        }
        protected void PolicyDealerCanStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            Hashtable obj = new Hashtable();
            obj.Add("PolicyId", this.hidid.Value);
            obj.Add("CurrUser", _context.User.Id);
            obj.Add("ProductLineId", this.Productline.Value);
            if (!this.txtWd7DealerName.Value.ToString().Equals(""))
            {
                obj.Add("DealerName", this.txtWd7DealerName.Value.ToString());
            }
            DataSet dsDealer = _business.QueryDealerCan(obj, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBarPolicyDealersCan.PageSize : e.Limit), out totalCount);
            (this.PolicyDealerCanStore.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
            PolicyDealerCanStore.DataSource = dsDealer;
            PolicyDealerCanStore.DataBind();
        }
        protected void PolicyDealerSeletedStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;

            Hashtable obj = new Hashtable();
            obj.Add("PolicyId", this.hidid.Value);
            obj.Add("CurrUser", _context.User.Id);
            obj.Add("WithType", "ByDealer");
            DataSet dsDealer = _business.QueryPolicyDealerSelected(obj, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBarPolicyDealersSelected.PageSize : e.Limit), out totalCount);
            (this.PolicyDealerSeletedStore.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
            PolicyDealerSeletedStore.DataSource = dsDealer;
            PolicyDealerSeletedStore.DataBind();
        }
        private void UpdateContainDealers(string dealerId, string operType)
        {
            Hashtable obj = new Hashtable();
            obj.Add("DealerId", dealerId);
            obj.Add("OperType", operType);
            obj.Add("WithType", "ByDealer");
            obj.Add("PolicyId", this.hidid.Value);
            obj.Add("CorrUser", _context.User.Id);
            obj.Add("Remark1", "");
            _business.InsertPolicyDealer(obj);
        }
        protected void FactorRuleStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            Hashtable obj = new Hashtable();
            obj.Add("PolicyId", this.hidid.Value);
            DataTable query = _business.SelectPromotionPOLICY_RULE(obj, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBarFactorRule.PageSize : e.Limit), out totalCount).Tables[0];
            (this.FactorRuleStore.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
            FactorRuleStore.DataSource = query;
            FactorRuleStore.DataBind();
        }
        protected void AttachmentStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            DataTable dt = attachmentBLL.GetAttachmentByMainId(new Guid(this.hiddenMainId.Value.ToString()), AttachmentType.ConsignmentDelete, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBarAttachment.PageSize : e.Limit), out totalCount).Tables[0];
            (this.AttachmentStore.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
            this.hiddenCountAttachment.Value = totalCount;
            AttachmentStore.DataSource = dt;
            AttachmentStore.DataBind();
        }
        protected void PolicyFactorXStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            Hashtable factorUi = new Hashtable();
            factorUi.Add("PolicyId", this.hidid.Value);
            DataSet PolicyFactorUiList = _business.SelectPolicyFactor(factorUi);
            PolicyFactorXStore.DataSource = PolicyFactorUiList;
            PolicyFactorXStore.DataBind();
        }
        protected void PolicyFactorRuleStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            Hashtable ht = new Hashtable();
            ht.Add("PolicyFactorId", this.PolicyFactorId.Value.ToString());
            DataSet dt = _business.SelectConditionRule(ht, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);
            (this.PolicyFactorRuleStore.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
            PolicyFactorRuleStore.DataSource = dt;
            PolicyFactorRuleStore.DataBind();
        }
        public string getid(string PolicyNo)
        {
            string msg = "";

            DataSet dt = _business.SelectPromotion(PolicyNo);
            if (dt.Tables[0].Rows.Count > 0)
            {
                this.Productline.Value = dt.Tables[0].Rows[0]["ProductLineID"].ToString();
                this.hidid.Value = dt.Tables[0].Rows[0]["PolicyId"].ToString();
                if (dt.Tables[0].Rows[0]["CalType"].ToString() == "ByHospital" && this.type.SelectedItem.Value.ToString() == "经销商范围调整")
                {
                    msg = "该促销结算对象为医院";

                }
            }
            else
            {
                msg = "请输入正确的政策编号!";


            }
            return msg;

        }
        [AjaxMethod]
        public string  GetPromotionPolicy()
        {
            string massage = "";
            DataSet dt = _business.SelectPromotion(this.PromotionID.Text);
            if (dt.Tables[0].Rows.Count > 0)
            {
                this.PolicyTypeNow.Text = dt.Tables[0].Rows[0]["Status"].ToString();
            }
            else
            {
                massage = "Error";
            }
            return massage;
        }
        [AjaxMethod]
        public void Update()
        {
            Hashtable obj = new Hashtable();
            obj.Add("RuleId", this.PolicyRuleId);
            obj.Add("txtFactorValueX", this.txtFactorValueX.Value.ToString());
            obj.Add("txtFactorValueY", this.txtFactorValueY.Value.ToString());
            obj.Add("RuleDesc", this.areaWd4Desc.Text);
            _business.UpdatePolicy(obj);


            Hashtable ht = new Hashtable();
            ht.Add("ContractUser", _context.User.Id);
            ht.Add("OperationType", "规则调整");
            if (this.HidPolicyStyle.Value.ToString() == "赠品" || this.HidPolicyStyle.Value.ToString() == "即买即赠")
            {
                ht.Add("Remarks", _context.UserName + "在" + DateTime.Now + "修改了促销规则系数，赠品/积分计算系数1修改为" + this.txtFactorValueX.Value.ToString() + "赠品 / 积分计算系数2修改为" + this.txtFactorValueY.Value.ToString());
            }
            else
            {
                ht.Add("Remarks", _context.UserName + "在" + DateTime.Now + "修改了促销规则系数，赠品/积分计算系数2修改为" + this.txtFactorValueY.Value.ToString());
            }
            ht.Add("OrderNo", this.PromotionID.Value);
            _bs.InsertOrderOperationLog(ht);

        }
        [AjaxMethod]
        public void PromotionPolicyRuleSetShow(string PolicyId, string ruleId, string PolicyStyle)
        {
            this.HidPolicyStyle.Value = PolicyStyle;
            this.PolicyRuleId = ruleId;
            DataTable dtRule = new DataTable();
            Hashtable obj = new Hashtable();
            obj.Add("RuleId", PolicyRuleId);
            obj.Add("PolicyId", PolicyId);
            obj.Add("CurrUser", _context.User.Id);
            dtRule = _business.GetPromotionPOLICY_RULE(obj).Tables[0];

            //页面赋值
            ClearFormValue();
            SetFormValue(dtRule);
            //页面控件状态
            ClearDetailWindow(PolicyStyle);

            this.WindowPromotionType.Show();

        }
        private void ClearFormValue()
        {
            this.txtFactorValueX.Clear();
            this.txtFactorValueY.Clear();
            this.txtWd4FactorRemarkX.Clear();
            this.txtWd4FactorRemarkY.Clear();
            this.areaWd4Desc.Clear();
            this.cbWd4PolicyFactorX.SelectedItem.Value = "";
            this.cbWd4PolicyFactorY.SelectedItem.Value = "";
            this.hidWd4PolicyFactorX.Value = "";
            this.cbWd4PolicyFactorY.Items.Clear();
        }

        private void SetFormValue(DataTable dtRule)
        {
            if (dtRule != null && dtRule.Rows.Count > 0)
            {
                DataRow drValues = dtRule.Rows[0];
                //this.cbWd4PolicyFactorX.SelectedItem.Value = drValues["JudgePolicyFactorId"]!=null ? drValues["JudgePolicyFactorId"].ToString():"";
                this.hidWd4PolicyFactorX.Value = drValues["JudgePolicyFactorId"] != null ? drValues["JudgePolicyFactorId"].ToString() : "";
                this.txtWd4FactorRemarkX.Text = drValues["FactDesc"] != null ? drValues["FactDesc"].ToString() : "";
                this.txtFactorValueX.Text = drValues["JudgeValue"] != null ? drValues["JudgeValue"].ToString() : "";
                this.txtFactorValueY.Text = drValues["GiftValue"] != null ? drValues["GiftValue"].ToString() : "";
                this.areaWd4Desc.Text = drValues["RuleDesc"] != null ? drValues["RuleDesc"].ToString() : "";
            }
            Hashtable obj = new Hashtable();
            obj.Add("CurrUser", _context.User.Id);
            DataTable dtGift = _business.GetIsGift(obj).Tables[0];
            if (dtGift != null && dtGift.Rows.Count > 0)
            {
                this.cbWd4PolicyFactorY.AddItem(dtGift.Rows[0]["FactName"].ToString(), dtGift.Rows[0]["GiftPolicyFactorId"].ToString());
                this.cbWd4PolicyFactorY.SelectedItem.Value = dtGift.Rows[0]["GiftPolicyFactorId"].ToString();
                this.txtWd4FactorRemarkY.Text = dtGift.Rows[0]["FactDesc"] != null ? dtGift.Rows[0]["FactDesc"].ToString() : "";
            }
        }

        /// <summary>
        /// 清除页面控件状态
        /// </summary>
        private void ClearDetailWindow(string PolicyStyle)
        {
            this.cbWd4PolicyFactorX.Disabled = true;
            this.txtWd4FactorRemarkX.Disabled = true;
            this.cbWd4PolicyFactorY.Disabled = true;
            this.txtWd4FactorRemarkY.Disabled = true;
            if (PolicyStyle == "积分")
            {
                cbWd4PolicyFactorY.Hidden = true;
                txtWd4FactorRemarkY.Hidden = true;
                txtFactorValueX.Hidden = true;
            }
            else
            {
                cbWd4PolicyFactorY.Hidden = false;
                txtWd4FactorRemarkY.Hidden = false;
                txtFactorValueX.Hidden = false;
            }
        }
        protected void FolicyFactorStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            Hashtable hs = new Hashtable();
            hs.Add("PolicyId", this.hidid.Value);
            if (this.type.SelectedItem.Value.ToString() == "产品调整")
            {
                this.hidFactId.Value = "1";
                hs.Add("FactId", "1");
            }
            if (this.type.SelectedItem.Value.ToString() == "医院调整")
            {
                this.hidFactId.Value = "2";
                hs.Add("FactId", "2");
            }
            DataSet dt = _business.SelectPolicyFactorall(hs, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBarFactor.PageSize : e.Limit), out totalCount);
            (this.FolicyFactorStore.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
            FolicyFactorStore.DataSource = dt;
            FolicyFactorStore.DataBind();
        }
        private bool StatusUpdate()
        {
            bool resule = true;
            Hashtable hs = new Hashtable();
            hs.Add("NewStatus", this.PolicyTypeChange.SelectedItem.Value.ToString());
            hs.Add("PolicyNo", this.PromotionID.Value);
            if (_business.StatusUpdate(hs))
            {
                resule = true;
                Hashtable ht = new Hashtable();
                ht.Add("ContractUser", _context.User.Id);
                ht.Add("OperationType", "状态调整");
                ht.Add("Remarks", _context.UserName + "在" + DateTime.Now + "把政策编号为" + this.PromotionID.Value + "的促销单状态由" + this.PolicyTypeNow.Value.ToString() + "修改为" + this.PolicyTypeChange.SelectedItem.Value.ToString());
                ht.Add("OrderNo", this.PromotionID.Value);
                bs.InsertOrderOperationLog(ht);
            }
            else
            {
                resule = false;
            }
            return resule;
        }
        protected void UploadAttachmentClick(object sender, AjaxEventArgs e)
        {
            this.Hidattmentid.Value = "";
            this.hidurl.Value = "";
            if (this.ufUploadAttachment.HasFile)
            {

                bool error = false;

                string fileName = ufUploadAttachment.PostedFile.FileName;
                string fileExtention = string.Empty;
                string fileExt = string.Empty;
                if (fileName.LastIndexOf(".") < 0)
                {
                    error = true;
                }
                else
                {
                    fileExtention = fileName.Substring(fileName.LastIndexOf("\\") + 1);
                    fileExt = fileName.Substring(fileName.LastIndexOf(".") + 1).ToLower();
                }

                if (error)
                {
                    Ext.Msg.Show(new MessageBox.Config
                    {
                        Buttons = MessageBox.Button.OK,
                        Icon = MessageBox.Icon.INFO,
                        Title = "文件错误",
                        Message = "请上传正确的文件！"
                    });

                    return;
                }

                //构造文件名称

                string newFileName = DateTime.Now.ToFileTime().ToString() + "." + fileExt;

                //上传文件在Upload文件夹

                string file = Server.MapPath("\\Upload\\UploadFile\\DCMS\\" + newFileName);


                //文件上传
                ufUploadAttachment.PostedFile.SaveAs(file);


                Attachment attach = new Attachment();
                attach.Id = Guid.NewGuid();
                this.Hidattmentid.Value = attach.Id;
                attach.MainId = new Guid(this.hiddenMainId.Value.ToString());
                attach.Name = fileExtention;
                attach.Url = newFileName;
                this.hidurl.Value = newFileName;
                attach.UploadDate = DateTime.Now;
                attach.UploadUser = new Guid(_context.User.Id);
                attach.Type = "ConsignmentDelete";
                //维护附件信息
                bool ckUpload = attachmentBLL.AddAttachment(attach);
            }
            else
            {
                Ext.Msg.Show(new MessageBox.Config
                {
                    Buttons = MessageBox.Button.OK,
                    Icon = MessageBox.Icon.ERROR,
                    Title = "上传失败",
                    Message = "文件未被成功上传！"
                });
            }
        }

        [AjaxMethod] //获取发货单时间
        public void GetPoReceiptHeader()
        {
            PoReceiptHeader Head = this.GetPOReceiptHeader(txtReceiptNo.Text);
            if (Head != null)
            {

                BtnOrderUpdate.Disabled = false;
                Label1.Text = "查询完成";
            }
            else
            {
                BtnOrderUpdate.Disabled = true;
                Label1.Text = "发货单号输入错误，没有此发货单号";
            }
        }

        [AjaxMethod] //删除发货单
        public void UpdateOrderSatatus()
        {
            if (!string.IsNullOrEmpty(txtReceiptNo.Text))
            {
                DataSet dt = PORbusiness.DNB_BatchNbr(txtReceiptNo.Text);
                if (dt.Tables[0].Rows.Count > 0)
                {
                    this.BatchNbr.Value = dt.Tables[0].Rows[0]["DNB_BatchNbr"].ToString();
                }
                else
                {

                    this.BatchNbr.Value = "";
                }
                if (PORbusiness.DeletePOReceipt(txtReceiptNo.Text) && PORbusiness.DeliveryNoteBSCSLC(txtReceiptNo.Text))
                {

                    Hashtable ht = new Hashtable();
                    ht.Add("ContractUser", _context.User.Id);
                    ht.Add("OperationType", "删除发货数据");
                    ht.Add("Remarks", _context.UserName + "在" + DateTime.Now + "删除了BatchNbr编号为" + this.BatchNbr.Value + "发货单");
                    ht.Add("OrderNo", txtReceiptNo.Text);
                    bs.InsertOrderOperationLog(ht);
                    Label1.Text = "删除成功!";
                    BtnOrderUpdate.Disabled = true;
                    this.hiddenMainId.Value = Guid.NewGuid();
                    this.GpWdAttachment.Reload();
                }
                else
                {
                    BtnOrderUpdate.Disabled = true;
                    Label1.Text = "删除失败!";
                }

            }

        }

        [AjaxMethod]
        public void GetPoReceiptHeadersap()
        {
            DataSet dt = PORbusiness.GetPOReceiptHeader_SAPNoQR(txtReceiptNo2.Text);
            if (dt.Tables[0].Rows.Count > 0)
            {

                BtnOrderUpdate2.Disabled = false;
                message.Text = "查询完成";
            }
            else
            {
                BtnOrderUpdate2.Disabled = true;
                message.Text = "发货单号输入错误，没有此发货单号";
            }
        }

        [AjaxMethod]
        public void UpdatePoReceipHeaderSAPNoQR()
        {
            if (!string.IsNullOrEmpty(txtReceiptNo2.Text))
            {
                DataSet ds = PORbusiness.DNB_BatchNbr(txtReceiptNo.Text);
                if (ds.Tables[0].Rows.Count > 0)
                {
                    message.Text = "请先删除收货单，在点击重置接口状态！";
                }
                else
                {
                    if (PORbusiness.UpdatePOReceiptHeader_SAPNoQR(txtReceiptNo2.Text))
                    {
                        Hashtable ht = new Hashtable();
                        ht.Add("ContractUser", _context.User.Id);
                        ht.Add("OperationType", "修改ERP接口发货数据");
                        ht.Add("Remarks", _context.UserName + "在" + DateTime.Now + "修改了编号为" + txtReceiptNo2.Text + "发货单,状态重置为UploadSuccess");
                        ht.Add("OrderNo", txtReceiptNo2.Text);
                        bs.InsertOrderOperationLog(ht);
                        BtnOrderUpdate2.Disabled = true;
                        message.Text = "修改成功，请通知仓库重新发货！";
                    }
                    else
                    {
                        BtnOrderUpdate2.Disabled = true;
                        message.Text = "修改失败!";
                    }
                }

            }
        }
        [AjaxMethod]
        public string Verification(string txtOrderNo, string UpdateType)
        {
            string result = "";
            Hashtable hs = new Hashtable();
            hs.Add("OrderNo", txtOrderNo);
            hs.Add("OperationType", UpdateType);
            DataSet dt = _business.SelectOrderOperationLog(hs);
            DataSet dd = _business.SelectAttachment(this.hiddenMainId.Value.ToString());
            if (dt.Tables[0].Rows.Count > 0 && dd.Tables[0].Rows.Count > 0)
            {
                result = "H";
            }
            else
            {
                result = "N";
            }
            return result;
        }
        [AjaxMethod]
        public void DeleteAttachment(string id, string fileName)
        {
            try
            {
                attachmentBLL.DelAttachment(new Guid(id));
                string uploadFile = Server.MapPath("..\\..\\Upload\\UploadFile\\DCMS");
                File.Delete(uploadFile + "\\" + fileName);

            }
            catch (Exception ex)
            {
                Ext.Msg.Alert("Error", "删除附件失败，请联系DMS技术支持").Show();
            }
        }
        [AjaxMethod]
        public void PromotionPolicyFactorSearchShow(string PolicyFactorId, string FactName, string IsGiftName, string IsGift, string IsPoint, string PolicyStyle, string FactId)
        {
            this.txtWd3KeyValue.Text = "";
            this.cbWd3FactorCondition.SelectedItem.Value = "";
            this.cbWd3FactorCondition.Disabled = true;
            this.cbWd3FactorConditionType.SelectedItem.Value = "";
            this.cbWd3FactorConditionType.Disabled = true;
            this.hidFactId.Value = "";
            this.cbWd2Factor.SelectedItem.Value = "";
            this.txaWd2Remark.Clear();
            this.cbWd2IsGift.SelectedItem.Value = "";
            this.cbWd2PointsValue.SelectedItem.Value = "";

            this.hidFactId.Value = FactId;
            this.cbWd2IsGift.SelectedItem.Value = IsGift;
            this.cbWd2Factor.Value = FactName;
            this.txaWd2Remark.Text = IsGiftName;
            this.PolicyFactorId.Value = PolicyFactorId;
            this.cbWd2PointsValue.Value = IsPoint;

            
            this.cbWd2PointsValue.Disabled = true;
            this.cbWd2Factor.Disabled = true;
            this.txaWd2Remark.Disabled = true;
            this.cbWd2IsGift.Disabled = true;

            if (PolicyStyle == "积分" && this.type.SelectedItem.Value.ToString() == "产品调整")
            {
                this.cbWd2IsGift.Hidden = true;
                this.cbWd2PointsValue.Hidden = false;
            }
            else if (PolicyStyle == "积分" && this.type.SelectedItem.Value.ToString() == "医院调整")
            {
                this.cbWd2PointsValue.Hidden = true;
                this.cbWd2IsGift.Hidden = true;
            }
            else if (PolicyStyle == "赠品" && this.type.SelectedItem.Value.ToString() == "医院调整")
            {
                this.cbWd2IsGift.Hidden = true;
                this.cbWd2PointsValue.Hidden = true;
            }
            else if (PolicyStyle == "赠品" && this.type.SelectedItem.Value.ToString() == "产品调整")
            {
                this.cbWd2IsGift.Hidden = false;
                this.cbWd2PointsValue.Hidden = true;

            }
            else if (PolicyStyle == "即时买赠" && this.type.SelectedItem.Value.ToString() == "产品调整")
            {
                this.cbWd2IsGift.Hidden = false;
                this.cbWd2PointsValue.Hidden = true;
            }
            else if (PolicyStyle == "即时买赠" && this.type.SelectedItem.Value.ToString() == "医院调整")
            {
                this.cbWd2IsGift.Hidden = true;
                this.cbWd2PointsValue.Hidden = true;
            }
            this.GridWd2FactorRule.Reload();
            this.wd2PolicyFactor.Show();
        }
        private PoReceiptHeader GetPOReceiptHeader(string OrderNo)
        {
            PoReceiptHeader Heade = PORbusiness.GetPoReceiptHeaderByOrderNo(OrderNo);
            return Heade;
        }

        protected void FactorConditionStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            DataTable qutry = new DataTable();
            if (this.hidFactId.Value.ToString() != "")
            {
                qutry = _business.GetFactorConditionByFactorId(this.hidFactId.Value.ToString()).Tables[0];
            }
            this.FactorConditionStore.DataSource = qutry;
            this.FactorConditionStore.DataBind();
        }
        protected void FactorConditionTypeStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            DataTable qutry = new DataTable();
            if (this.hidFactId.Value.ToString() != "")
            {
                Hashtable obj = new Hashtable();
                obj.Add("FactId", this.hidFactId.Value);
                obj.Add("ConditionId", this.cbWd3FactorCondition.SelectedItem.Value.Equals("") ? "-1" : this.cbWd3FactorCondition.SelectedItem.Value);
                qutry = _business.GetFactorConditionType(obj).Tables[0];
            }
            this.FactorConditionTypeStore.DataSource = qutry;
            this.FactorConditionTypeStore.DataBind();
        }
        protected void Wd3RuleStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            Hashtable obj = new Hashtable();
            obj.Add("FactConditionId", this.HidFactConditionId.Value);
            obj.Add("ProductLineId", this.Productline.Value);
            obj.Add("SubBU", "");
            obj.Add("KeyValue", this.txtWd3KeyValue.Text);
            obj.Add("CurrUser", _context.User.Id);
            DataTable query = _business.SelectFactorConditionRuleCanAll(obj, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount).Tables[0];
            (this.Wd3RuleStore.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
            this.Wd3RuleStore.DataSource = query;
            this.Wd3RuleStore.DataBind();
        }
        protected void Wd3RuleSeletedStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            Hashtable obj = new Hashtable();
            obj.Add("FactConditionId", this.HidFactConditionId.Value);
            obj.Add("CurrUser", _context.User.Id);
            DataTable query = _business.SelectFactorConditionRuleSeletedALL(obj, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar2.PageSize : e.Limit), out totalCount).Tables[0];
            (this.Wd3RuleSeletedStore.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
            this.Wd3RuleSeletedStore.DataSource = query;
            this.Wd3RuleSeletedStore.DataBind();

        }
        protected void Wd3FactorRelationStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            DataTable qutry = new DataTable();
            if (this.hidid.Value.ToString() != "")
            {
                Hashtable obj = new Hashtable();
                obj.Add("PolicyId", this.hidid.Value);
                obj.Add("PolicyFactorId", this.PolicyFactorId.Value);
                obj.Add("CurrUser", _context.User.Id);
                qutry = _business.GetFactorRelationeUiCan(obj).Tables[0];
            }
            this.Wd3FactorRelationStore.DataSource = qutry;
            this.Wd3FactorRelationStore.DataBind();
        }

        [AjaxMethod]
        public void wd3PolicyFactorConditionshow(string ConditionId, string FactorId)
        {
            this.HidFactConditionId.Value = ConditionId;
            this.HidFactorId.Value = FactorId;
            Hashtable obj = new Hashtable();
            obj.Add("FactConditionId", this.HidFactConditionId.Value);

            DataTable dtFactCondition = _business.SelectPolicyFactorCondition(obj).Tables[0];
            if (dtFactCondition != null && dtFactCondition.Rows.Count > 0)
            {
                DataRow drValues = dtFactCondition.Rows[0];
                this.cbWd3FactorCondition.SelectedItem.Value = drValues["ConditionId"].ToString();
                this.cbWd3FactorConditionType.SelectedItem.Value = drValues["OperTag"] != null ? drValues["OperTag"].ToString() : "";
            }

            this.GridWd3FactorRuleCondition.Reload();
            this.GridWd3FactorRuleConditionSeleted.Reload();
            this.wd3PolicyFactorCondition.Show();
        }
        [AjaxMethod]
        public void PromotionPolicyFactorRuleSearchDeleteRule(string valueId)
        {
            Hashtable obj = new Hashtable();
            obj.Add("FactConditionId", this.HidFactConditionId.Value);
            obj.Add("ConditionValueDelete", valueId);
            _business.FactorConditionRuleDelete(obj);
            Hashtable ht = new Hashtable();
            ht.Add("ContractUser", _context.User.Id);
            if (this.type.SelectedItem.Value == "产品调整")
            {
                ht.Add("OperationType", "产品调整");
                ht.Add("Remarks", _context.UserName + "在" + DateTime.Now + "删除了" + this.PromotionID.Value + "的已包含产品" + valueId);
            }
            if (this.type.SelectedItem.Value == "医院调整")
            {
                ht.Add("OperationType", "医院调整");
                ht.Add("Remarks", _context.UserName + "在" + DateTime.Now + "删除了" + this.PromotionID.Value + "的已包含医院" + valueId);
            }
            ht.Add("OrderNo", this.PromotionID.Value);
            bs.InsertOrderOperationLog(ht);
        }
        [AjaxMethod]
        public void PromotionPolicyFactorRuleSearchAddRule(string valueId)
        {
            Hashtable obj = new Hashtable();
            obj.Add("FactConditionId", this.HidFactConditionId.Value);
            obj.Add("ConditionValueAdd", valueId);
            obj.Add("FactorId", this.HidFactorId.Value);
            int i = _business.FactorConditionRuleSet(obj);
            Hashtable ht = new Hashtable();
            ht.Add("ContractUser", _context.User.Id);
            if (this.type.SelectedItem.Value == "产品调整")
            {
                ht.Add("OperationType", "产品调整");
                ht.Add("Remarks", _context.UserName + "在" + DateTime.Now + "修改了编号为" + this.PromotionID.Value + "的政策添加了产品" + valueId);
            }
            if (this.type.SelectedItem.Value == "医院调整")
            {
                ht.Add("OperationType", "医院调整");
                ht.Add("Remarks", _context.UserName + "在" + DateTime.Now + "修改了编号为" + this.PromotionID.Value + "的政策添加了医院" + valueId);

            }
            ht.Add("OrderNo", this.PromotionID.Value);
            bs.InsertOrderOperationLog(ht);
        }

    }
}