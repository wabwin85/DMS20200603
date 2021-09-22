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
using DMS.Business.ScoreCard;

namespace DMS.Website.Pages.ScoreCard
{
    
    public partial class EndoScoreCard : BasePage
    {
        #region 公用
        IRoleModelContext _context = RoleModelContext.Current;
        private IPurchaseOrderBLL _logbll = new PurchaseOrderBLL();
        private IEndoScoreCardBLL _endoScoreCard = new EndoScoreCardBLL();
        private IInventoryAdjustBLL _business = null;
        [Dependency]
        public IInventoryAdjustBLL business
        {
            get { return _business; }
            set { _business = value; }
        }
        
        #endregion
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                this.Bind_Status(this.StatusStore);
                this.Bind_ProductLine(this.ProductLineStore);
                GridPanel1.ColumnModel.SetHidden(6, true);
                if (IsDealer)
                {
                    if (RoleModelContext.Current.User.CorpType.Equals(DealerType.T2.ToString()) || RoleModelContext.Current.User.CorpType.Equals(DealerType.T1.ToString()))
                    {
                        this.Bind_DealerList(this.DealerStore);
                        this.cbDealer.Disabled = true;
                        this.cbDealer.SelectedItem.Value = RoleModelContext.Current.User.CorpId.Value.ToString();
                        //this.hidInitDealerId.Value = RoleModelContext.Current.User.CorpId.Value.ToString();                       
                    }
                    else if (RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()))
                    {
                        this.Bind_DealerListByFilter(this.DealerStore, true);
                        this.cbDealer.Disabled = false;
                        this.cbDealer.SelectedItem.Value = RoleModelContext.Current.User.CorpId.Value.ToString();
                        //this.hidInitDealerId.Value = RoleModelContext.Current.User.CorpId.Value.ToString();
                        GridPanel1.ColumnModel.SetHidden(6, false);

                    }
                    else
                    {
                        this.Bind_DealerList(this.DealerStore);
                        this.cbDealer.Disabled = false;
                        this.cbDealer.SelectedItem.Value = RoleModelContext.Current.User.CorpId.Value.ToString();
                    }
                }
                else
                {
                    this.Bind_DealerList(this.DealerStore);
                    this.cbDealer.Disabled = false;
                    this.btnImport.Hidden = false;
                }

                //控制查询按钮
                Permissions pers = this._context.User.GetPermissions();
                this.btnSearch.Visible = pers.IsPermissible(Business.InventoryAdjustBLL.Action_InventoryAdjust, PermissionType.Read);

            }
        }

       

        protected void Bind_Status(Store store1)
        {
            IDictionary<string, string> dicts = DictionaryHelper.GetDictionary(SR.CONST_ESC_Status);
           
            store1.DataSource = dicts;
            store1.DataBind();

        }

        protected void Bind_Type(Store store1)
        {
            IDictionary<string, string> dicts = DictionaryHelper.GetDictionary(SR.Consts_AdjustQty_Type);
            var list = from d in dicts where d.Key.Equals(AdjustType.StockIn.ToString()) || d.Key.Equals(AdjustType.StockOut.ToString()) select d;

            store1.DataSource = list;
            store1.DataBind();

        }

        protected void OrderLogStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            Hashtable table = new Hashtable();
            table.Add("EscId", this.hiddenESCId.Text);
            DataSet ds = _endoScoreCard.QueryScoreCardLogByFilter(table, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar3.PageSize : e.Limit), out totalCount);
            e.TotalCount = totalCount;

            this.OrderLogStore.DataSource = ds;
            this.OrderLogStore.DataBind();
        }

        protected void FileUploadStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            Guid tid = new Guid(this.hiddenESCId.Text);
            int totalCount = 0;
            DataSet ds = _endoScoreCard.GetESCAttachment(tid, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar4.PageSize : e.Limit), out totalCount);
            e.TotalCount = totalCount;

            this.FileUploadStore.DataSource = ds;
            this.FileUploadStore.DataBind();
        }

        protected void ResultStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            //IInventoryAdjustBLL business = new InventoryAdjustBLL();

            int totalCount = 0;

            Hashtable param = new Hashtable();

           
            if (!string.IsNullOrEmpty(this.cbDealer.SelectedItem.Value))
            {
                param.Add("DmaId", this.cbDealer.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.txtScoreCardNumber.Text))
            {
                param.Add("No", this.txtScoreCardNumber.Text);
            }
            if (!string.IsNullOrEmpty(this.cbStatus.SelectedItem.Value))
            {
                param.Add("Status", this.cbStatus.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.txtYear.Text))
            {
                param.Add("Year", this.txtYear.Text);
            }
            if (!string.IsNullOrEmpty(this.txtQuarter.Text))
            {
                param.Add("Quarter", this.txtQuarter.Text);
            }
            if (_context.User.CorpType == DealerType.LP.ToString())
            {
                param.Add("LPId", _context.User.CorpId);
            }
            if (!string.IsNullOrEmpty(this.cbBU.SelectedItem.Value))
            {
                param.Add("BUMId", this.cbBU.SelectedItem.Value);
            }
            DataSet ds = _endoScoreCard.QueryEndoScoreCardHeaderByCondition(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);

            e.TotalCount = totalCount;

            this.ResultStore.DataSource = ds;
            this.ResultStore.DataBind();
        }

        protected void DetailStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            Guid tid = new Guid(this.hiddenESCId.Text);
            int totalCount = 0;
            DataSet ds = _endoScoreCard.QueryEndoScoreCardDetailById(tid, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar2.PageSize : e.Limit), out totalCount);
            e.TotalCount = totalCount;
            this.DetailStore.DataSource = ds;
            this.DetailStore.DataBind();
        }

        protected void ShowWindow(object sender, AjaxEventArgs e)
        {
            DMS.Model.EndoScoreCardHeader mainData = _endoScoreCard.QueryEndoScoreCardHeaderByID(new Guid(this.hiddenESCId.Text));
            if (IsDealer)
            {
                if ((_context.User.CorpType == DealerType.T1.ToString() || _context.User.CorpType == DealerType.T2.ToString()) && (mainData.Status == ScoreCardStatus.Submit.ToString() ||mainData.Status == ScoreCardStatus.Submitted.ToString()))
                {
                    this.AttachmentWindow.Show();
                }
            }
            else
            {
                if(mainData.Status == ScoreCardStatus.Confirming.ToString())
                {
                    this.AttachmentWindow.Show();
                }
            }
            
        }

        protected void ShowDetails(object sender, AjaxEventArgs e)
        {
            //初始化detail窗口,因为只有dealer才可以新增，因此打开页面默认选中session中的经销商
            //this.gpLog.Reload();

            this.hiddenESCId.Text = string.Empty;
            this.hiddenDealerId.Text = string.Empty;
            this.hiddenProductLineId.Text = string.Empty;
            this.hiddenStatus.Text = string.Empty;

            this.cbDealerWin.Enabled = false;
            this.cbProductLineWin.Enabled = false;
            this.txtYearWin.Enabled = false;
            this.txtQuarterWin.Enabled = false;
            this.cbStatusWin.Enabled = false;
            this.txtScoreCardNumberWin.Enabled = false;
            this.DealerConfirmButton.Enabled = false;
            this.LPConfirmButton.Enabled = false;
            this.txtEditScore.Hidden = true;
            this.btnScoreEdit.Disabled = true;
            DealerConfirmButton.Hidden = true;

            gpFile.ColumnModel.SetHidden(7, true);

            this.Bind_ProductLine(this.ProductLineStore);

            Guid id = new Guid(e.ExtraParams["ESCHId"].ToString());

            //IInventoryAdjustBLL business = new InventoryAdjustBLL();
            DMS.Model.EndoScoreCardHeader mainData = null;

            //根据ID查询主表数据，并初始化页面

            mainData = _endoScoreCard.QueryEndoScoreCardHeaderByID(id);
            this.hiddenESCId.Text = id.ToString();
            this.hiddenDealerId.Text = mainData.DmaId.ToString();
            this.txtScoreCardNumberWin.Text = mainData.No;
            this.txtYearWin.Text = mainData.Year;
            this.txtQuarterWin.Text = mainData.Quarter;


            if (mainData.BumId != null)
            {
                this.hiddenProductLineId.Text = mainData.BumId.ToString();
            }
            if (mainData.Status != null)
            {
                this.hiddenStatus.Text = mainData.Status.ToString();
            }
            if (IsDealer)
            {
                if (_context.User.CorpType == DealerType.T1.ToString() || _context.User.CorpType == DealerType.T2.ToString())
                {
                    this.LPConfirmButton.Enabled = false;
                    //this.btnAddAttach.Disabled = false;
                    //按钮控制
                    if (mainData.Status == ScoreCardStatus.Confirming.ToString() && mainData.Field1 != "1")
                    {
                        this.DealerConfirmButton.Enabled = true;
                    }
                    else if (mainData.Status == ScoreCardStatus.Submit.ToString())
                    {
                       gpFile.ColumnModel.SetHidden(7, false);
                    }
                    else
                    {
                        this.DealerConfirmButton.Enabled = false;
                    }
                }
                else if (_context.User.CorpType == DealerType.LP.ToString() && mainData.Field2 != "1" && mainData.Status != ScoreCardStatus.Completed.ToString())
                {
                    this.LPConfirmButton.Enabled = true;
                }
            }
            else
            {
                if (mainData.Status == ScoreCardStatus.Confirming.ToString())
                {
                    this.txtEditScore.Hidden = false;
                    this.btnScoreEdit.Disabled = false;
                    gpFile.ColumnModel.SetHidden(7, false);
                }
            }

            //显示窗口
            this.DetailWindow.Show();
        }

        protected void UploadClick(object sender, AjaxEventArgs e)
        {
            if (this.FileUploadField1.HasFile)
            {

                bool error = false;

                string fileName = FileUploadField1.PostedFile.FileName;
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

                string newFileName = fileExtention.Substring(0, fileExtention.LastIndexOf(".")) + DateTime.Now.ToFileTime() + "." + fileExt;

                //上传文件在Upload文件夹

                string file = Server.MapPath("\\Upload\\UploadFile\\" + newFileName);


                //文件上传
                FileUploadField1.PostedFile.SaveAs(file);

                this.hiddenFileName.Text = fileName;

                ScAttachment attach = new ScAttachment();
                attach.Id = Guid.NewGuid();
                attach.MainId = new Guid(this.hiddenESCId.Text);
                attach.Name = fileExtention;
                attach.Url = newFileName;//AppSettings.HostUrl + "/Upload/UploadFile/" + newFileName;
                attach.Type = IsDealer? "Dealer" : "Administrator";
                attach.Remark = "";
                attach.UploadDate = DateTime.Now;
                attach.UploadUser = new Guid(_context.User.Id);

                _endoScoreCard.AddScAttachment(attach);

                ScoreCardLog scl = new ScoreCardLog();
                scl.Id = Guid.NewGuid();
                scl.EscId = new Guid(this.hiddenESCId.Text);
                scl.OperUser = _context.User.UserName;
                scl.OperDate = DateTime.Now;
                scl.OperNote = "";
                scl.OperType = "提交附件";
                _endoScoreCard.Insert(scl);

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


        [AjaxMethod]
        public void DealerConfirm(string id)
        {
            Hashtable hash = new Hashtable();
            hash.Add("Id", id);
            hash.Add("DmaType", _context.User.CorpType);
            _endoScoreCard.UpdateDealerConfirm(hash);
            ScoreCardLog scl = new ScoreCardLog();
            scl.Id = Guid.NewGuid();
            scl.EscId = new Guid(id);
            scl.OperUser = _context.User.UserName;
            scl.OperDate = DateTime.Now;
            scl.OperNote = "";
            scl.OperType = "确认";
            _endoScoreCard.Insert(scl);
        }

        [AjaxMethod]
        public void LPConfirm(string id)
        {
            _endoScoreCard.UpdateLPConfirm(id);
            ScoreCardLog scl = new ScoreCardLog();
            scl.Id = Guid.NewGuid();
            scl.EscId = new Guid(id);
            scl.OperUser = _context.User.UserName;
            scl.OperDate = DateTime.Now;
            scl.OperNote = "";
            scl.OperType = "确认";
            _endoScoreCard.Insert(scl);
        }

        [AjaxMethod]
        public void Delete(string id,string typename)
        {
            if (IsDealer)
            {
                if (typename != "经销商")
                {
                    Ext.Msg.Show(new MessageBox.Config
                    {
                        Buttons = MessageBox.Button.OK,
                        Icon = MessageBox.Icon.ERROR,
                        Title = "删除失败",
                        Message = "您不能删除其他人上传的附件！"
                    });
                }
                else
                {
                    _endoScoreCard.Delete(new Guid(id));
                }
            }
            else
            {
                if (typename != "系统管理员")
                {
                    Ext.Msg.Show(new MessageBox.Config
                    {
                        Buttons = MessageBox.Button.OK,
                        Icon = MessageBox.Icon.ERROR,
                        Title = "删除失败",
                        Message = "您不能删除其他人上传的附件！"
                    });
                }
                else
                {
                    _endoScoreCard.Delete(new Guid(id));
                }
            }
        }

        [AjaxMethod]
        public void Download(string eschid)
        {
            DataTable dt = _endoScoreCard.ExportEndoScoreCardDetailForLP(new Guid(eschid)).Tables[0];//dt是从后台生成的要导出的datatable
            this.Response.Clear();
            this.Response.Buffer = true;
            this.Response.AppendHeader("Content-Disposition", "attachment;filename=result.xls");
            this.Response.ContentEncoding = System.Text.Encoding.UTF8;
            this.Response.ContentType = "application/vnd.ms-excel";
            this.EnableViewState = false;
            this.Response.Write(ExportHelp.AddExcelHead());//显示excel的网格线
            this.Response.Write(ExportHelp.ExportTable(dt));//导出
            this.Response.Write(ExportHelp.AddExcelbottom());//显示excel的网格线
            this.Response.Flush();
            this.Response.End();
        }


        protected void SaveScore(object sender, AjaxEventArgs e)
        {
            Hashtable ht = new Hashtable();
            ht.Add("Id", this.hiddenESCId.Text);
            ht.Add("Score", this.txtEditScore.Text);
            //校验是否上传过附件
            int cnt = _endoScoreCard.GetFileCount(new Guid(this.hiddenESCId.Text));
            if (cnt == 0)
            {
                Ext.Msg.Show(new MessageBox.Config
                {
                    Buttons = MessageBox.Button.OK,
                    Icon = MessageBox.Icon.ERROR,
                    Title = "校验未通过",
                    Message = "请先上传相关附件！"
                });
            }
            else
            {
                DataSet  ds = _endoScoreCard.GetEditTotalScoreById(ht);
                int totalscore = Convert.ToInt32(ds.Tables[0].Rows[0]["TotalScore"]);
                //string GradeValue = ds.Tables[0].Rows[0]["GradeValue"].ToString();
                //string DIOHScore = ds.Tables[0].Rows[0]["DIOHScore"].ToString();
                if (totalscore > 100 || totalscore < 0)
                {
                    Ext.Msg.Show(new MessageBox.Config
                    {
                        Buttons = MessageBox.Button.OK,
                        Icon = MessageBox.Icon.ERROR,
                        Title = "调整失败",
                        Message = "调整后的总计分数必须大于0，小于100！"
                    });
                }
                //else if (string.IsNullOrEmpty(GradeValue) || string.IsNullOrEmpty(DIOHScore))
                //{
                //    Ext.Msg.Show(new MessageBox.Config
                //    {
                //        Buttons = MessageBox.Button.OK,
                //        Icon = MessageBox.Icon.ERROR,
                //        Title = "调整失败",
                //        Message = "没有数据上传和安全库存天数的分数，不能调整！"
                //    });
                //}
                else
                {
                    _endoScoreCard.UpdateAdminScore(ht);
                    ScoreCardLog scl = new ScoreCardLog();
                    scl.Id = Guid.NewGuid();
                    scl.EscId = new Guid(this.hiddenESCId.Text);
                    scl.OperUser = _context.User.UserName;
                    scl.OperDate = DateTime.Now;
                    scl.OperNote = "";
                    scl.OperType = "分数调整";
                    _endoScoreCard.Insert(scl);

                    Ext.Msg.Show(new MessageBox.Config
                    {
                        Buttons = MessageBox.Button.OK,
                        Icon = MessageBox.Icon.INFO,
                        Title = "调整成功",
                        Message = "分数调整成功！"
                    });
                }

            }



            
        }

    }
}
