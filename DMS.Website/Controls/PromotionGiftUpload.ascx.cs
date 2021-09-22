using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using Coolite.Ext.Web;
using DMS.Website.Common;
using Lafite.RoleModel.Security;
using DMS.Business;
using System.IO;
using DMS.Business.Contract;

namespace DMS.Website.Controls
{
    [AjaxMethodProxyID(IDMode = AjaxMethodProxyIDMode.Alias, Alias = "PromotionGiftUpload")]
    public partial class PromotionGiftUpload : BaseUserControl
    {
        #region 公用
        IRoleModelContext _context = RoleModelContext.Current;
        private IGiftMaintainBLL _business = new GiftMaintainBLL();
        private IPromotionPolicyBLL _businessPolicy = new PromotionPolicyBLL();
        private TenderAuthorizationListBLL Bll = new TenderAuthorizationListBLL();
        #endregion

        #region 公开属性

        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void AttachmentStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            Hashtable obj = new Hashtable();
            obj.Add("GiftId", this.hidAttachmentId.Text);
            obj.Add("Type", "Gift");
            int totalCount = 0;
            this.AttachmentStore.DataSource = _businessPolicy.QueryPolicyAttachment(obj, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar3.PageSize : e.Limit), out totalCount);
            this.AttachmentStore.DataBind();
            e.TotalCount = totalCount;
        }


        #region Ajax Method
        [AjaxMethod]
        public void Show()
        {
            this.hidAttachmentId.Clear();
            this.hidAttachmentId.Text = Guid.NewGuid().ToString();
            this.wdGiftUpload.Show();
        }

        [AjaxMethod]
        public void DeleteAttachment(string id, string fileName)
        {
            try
            {
                //逻辑删除
                _businessPolicy.DeletePolicyAttachment(id);
                //物理删除
                string uploadFile = Server.MapPath("..\\..\\Upload\\UploadFile\\Promotion");
                File.Delete(uploadFile + "\\" + fileName);
            }
            catch (Exception ex)
            {
                Ext.Msg.Alert("Error", "删除失败").Show();
            }
        }
        #endregion

        [AjaxMethod]
        public string inputSubmint()
        {
            this.hidQtyCheck.Clear();
            this.hidFlowId.Clear();
            this.hidMassage.Clear();

            string errMassage = "fales";
            if (this.FileUploadField1.HasFile)
            {
                #region 上传文件至服务器
                System.Diagnostics.Debug.WriteLine("Upload Start : " + DateTime.Now.ToString());
                bool error = false;

                string fileName = FileUploadField1.PostedFile.FileName;
                string fileExtention = string.Empty;
                if (fileName.LastIndexOf(".") < 0)
                {
                    error = true;
                }
                else
                {
                    fileExtention = fileName.Substring(fileName.LastIndexOf(".") + 1).ToLower();
                    if (fileExtention != "xls" && fileExtention != "xlsx")
                    {
                        error = true;
                    }
                }

                if (error)
                {
                    this.hidMassage.Text = "请使用正确的模板文件，模板文件为EXCEL文件!";
                    return errMassage;
                }

                //构造文件名称

                string newFileName = Guid.NewGuid().ToString() + "." + fileExtention;

                //上传文件在Upload文件夹

                string file = Server.MapPath("\\Upload\\PROOther\\" + newFileName);


                //文件上传
                FileUploadField1.PostedFile.SaveAs(file);

                System.Diagnostics.Debug.WriteLine("Upload Finish : " + DateTime.Now.ToString());
                #endregion

                #region 读取文件导入数据提交E-workflow
                //读取数据
                DataTable dt = ExcelHelper.GetDataTable(file, "DetailDate");

                //根据列数量判断文件模板是否正确
                if (dt.Columns.Count < 6)
                {
                    this.hidMassage.Text = "请使用正确的上传表格!";
                }
                else
                {
                    if (dt.Rows.Count > 1)
                    {
                        string IsValid = string.Empty;
                        string FlowId = string.Empty;
                        string QtyCheck = string.Empty;

                        if (!_business.Import(dt))
                        {
                            errMassage = IsValid.ToString();
                        }
                        else
                        {
                            errMassage = "true";
                            this.hidQtyCheck.Text = QtyCheck;
                            this.hidFlowId.Text = FlowId;
                        }
                        //if (cbType.SelectedItem.Value == "赠品")
                        //{
                        //    if (!_business.ImportGift(dt, this.wdTaRemark.Text, this.cbType.SelectedItem.Value, this.cbMarketType.SelectedItem.Value, this.cbPriceTypeReason.SelectedItem.Value, this.dfBeginDate.SelectedDate, this.dfEndDate.SelectedDate, "审核通过", this.hidAttachmentId.Text, out IsValid, out FlowId, out QtyCheck))
                        //    {
                        //        errMassage = IsValid.ToString();
                        //    }
                        //    else
                        //    {
                        //        errMassage = "true";
                        //        this.hidQtyCheck.Text = QtyCheck;
                        //        this.hidFlowId.Text = FlowId;
                        //    }
                        //}
                        //else
                        //{
                        //    if (!_business.ImportPoint(dt, this.wdTaRemark.Text, this.cbType.SelectedItem.Value, this.cbMarketType.SelectedItem.Value, this.cbPriceTypeReason.SelectedItem.Value, this.dfBeginDate.SelectedDate, this.dfEndDate.SelectedDate, "审核通过", this.hidAttachmentId.Text, out IsValid, out FlowId, out QtyCheck))
                        //    {
                        //        errMassage = IsValid.ToString();
                        //    }
                        //    else
                        //    {
                        //        errMassage = "true";
                        //        this.hidQtyCheck.Text = QtyCheck;
                        //        this.hidFlowId.Text = FlowId;
                        //    }
                        //}
                    }
                    else
                    {
                        this.hidMassage.Text = "没有数据可导入";
                    }
                }
                #endregion
            }
            else
            {
                this.hidMassage.Text = "文件未被成功上传!";
            }

            return errMassage;
        }


        [AjaxMethod]
        public string InputSubmintToEwf()
        {
            string errMassage = "true";
            if (!_business.SubmintToEwf(this.hidFlowId.Text))
            {
                errMassage = "数据错误";
            }
            return errMassage;
        }

        [AjaxMethod]
        public void DeleteGift()
        {
            if (!this.hidFlowId.Text.Equals(""))
            {
                _business.DeleteGift(this.hidFlowId.Text);
            }
        }


        #region 页面私有方法

        protected void UploadClick(object sender, AjaxEventArgs e)
        {
            if (this.FileUploadField1.HasFile)
            {
                #region 上传文件至服务器
                System.Diagnostics.Debug.WriteLine("Upload Start : " + DateTime.Now.ToString());
                bool error = false;

                string fileName = FileUploadField1.PostedFile.FileName;
                string fileExtention = string.Empty;
                if (fileName.LastIndexOf(".") < 0)
                {
                    error = true;
                }
                else
                {
                    fileExtention = fileName.Substring(fileName.LastIndexOf(".") + 1).ToLower();
                    if (fileExtention != "xls" && fileExtention != "xlsx")
                    {
                        error = true;
                    }
                }

                if (error)
                {
                    Ext.Msg.Show(new MessageBox.Config
                    {
                        Buttons = MessageBox.Button.OK,
                        Icon = MessageBox.Icon.INFO,
                        Title = "文件错误",
                        Message = "请使用正确的模板文件，模板文件为EXCEL文件!"
                    });

                    return;
                }

                //构造文件名称

                string newFileName = Guid.NewGuid().ToString() + "." + fileExtention;

                //上传文件在Upload文件夹

                string file = Server.MapPath("\\Upload\\PROOther\\" + newFileName);


                //文件上传
                FileUploadField1.PostedFile.SaveAs(file);

                System.Diagnostics.Debug.WriteLine("Upload Finish : " + DateTime.Now.ToString());
                #endregion

                #region 读取文件导入数据提交E-workflow
                //读取数据
                DataTable dt = ExcelHelper.GetDataTable(file, "DetailDate");

                //根据列数量判断文件模板是否正确
                if (dt.Columns.Count < 12)
                {
                    Ext.Msg.Alert("错误", "请使用正确的上传表格!").Show();
                }
                else
                {
                    if (dt.Rows.Count > 1)
                    {
                        string IsValid = string.Empty;
                        string FlowId = string.Empty;
                        string QtyCheck = string.Empty;

                        if (cbType.SelectedItem.Value == "赠品")
                        {
                            if (!_business.ImportGift(dt, this.wdTaRemark.Text, this.cbType.SelectedItem.Value, this.cbMarketType.SelectedItem.Value, this.cbPriceTypeReason.SelectedItem.Value, this.dfBeginDate.SelectedDate, this.dfEndDate.SelectedDate, "审核通过", this.hidAttachmentId.Text, out IsValid, out FlowId, out QtyCheck))
                            {
                                Ext.Msg.Alert("错误", IsValid.ToString()).Show();
                            }
                            else
                            {
                                Ext.Msg.Alert("成功", "导入成功!").Show();
                            }
                        }
                        else
                        {
                            if (!_business.ImportPointToEwf(dt, this.wdTaRemark.Text, this.cbType.SelectedItem.Value, this.cbMarketType.SelectedItem.Value, this.cbPriceTypeReason.SelectedItem.Value, this.dfBeginDate.SelectedDate, this.dfEndDate.SelectedDate, "审核通过", this.hidAttachmentId.Text, out IsValid))
                            {
                                Ext.Msg.Alert("错误", IsValid.ToString()).Show();
                            }
                            else
                            {
                                Ext.Msg.Alert("成功", "导入成功!").Show();
                            }
                        }
                    }
                    else
                    {
                        Ext.Msg.Alert("错误", "没有数据可导入!").Show();
                    }
                }
                #endregion
            }
            else
            {
                Ext.Msg.Show(new MessageBox.Config
                {
                    Buttons = MessageBox.Button.OK,
                    Icon = MessageBox.Icon.ERROR,
                    Title = "上传失败",
                    Message = "文件未被成功上传!"
                });
            }
        }

        protected void UploadAttachmentClick(object sender, AjaxEventArgs e)
        {
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

                string file = Server.MapPath("\\Upload\\UploadFile\\Promotion\\" + newFileName);


                //文件上传
                FileUploadField1.PostedFile.SaveAs(file);

                Hashtable obj = new Hashtable();
                obj.Add("GiftId", this.hidAttachmentId.Text);
                obj.Add("Name", fileExtention);
                obj.Add("Url", newFileName);
                obj.Add("UploadUser", _context.User.Id);
                obj.Add("UploadDate", DateTime.Now.ToShortDateString());
                obj.Add("Type", "Gift");
                //维护附件信息
                _businessPolicy.InsertPolicyAttachment(obj);

                Ext.Msg.Show(new MessageBox.Config
                {
                    Buttons = MessageBox.Button.OK,
                    Icon = MessageBox.Icon.INFO,
                    Title = "上传成功",
                    Message = "已成功上传文件！"
                });
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


        #endregion
    }
}