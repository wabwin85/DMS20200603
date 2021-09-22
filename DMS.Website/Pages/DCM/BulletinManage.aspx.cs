using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Collections;

namespace DMS.Website.Pages.DCM
{
    using Coolite.Ext.Web;
    using Lafite.RoleModel.Security;
    using Microsoft.Practices.Unity;
    using DMS.Website.Common;
    using DMS.Business;
    using DMS.Model;
    using DMS.Common;
    using DMS.Model.Data;
    using System.IO;
    public partial class BulletinManage : BasePage
    {
        #region 公共

        IRoleModelContext _context = RoleModelContext.Current;
        
        private IBulletinManageBLL _bll = null;
        private IAttachmentBLL _attachBll = null;

        public bool IsPageNew
        {
            get
            {
                return (this.isPageNew.Text == "True" ? true : false);
            }
            set
            {
                this.isPageNew.Text = value.ToString();
            }
        }

        public bool IsModified
        {
            get
            {
                return (this.isModified.Text == "True" ? true : false);
            }
            set
            {
                this.isModified.Text = value.ToString();
            }
        }

        public bool IsSaved
        {
            get
            {
                return (this.isSaved.Text == "True" ? true : false);
            }
            set
            {
                this.isSaved.Text = value.ToString();
            }
        }
        [Dependency]
        public IBulletinManageBLL bll
        {
            get { return _bll; }
            set { _bll = value; }
        }

        [Dependency]
        public IAttachmentBLL attachBll
        {
            get { return _attachBll; }
            set { _attachBll = value; }
        }

        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                this.btnImport.Hidden = IsDealer;

                Permissions pers = this._context.User.GetPermissions();
                this.btnSearch.Visible = pers.IsPermissible(Business.BulletinManageBLL.Action_BulletinManage, PermissionType.Read);
                this.btnImport.Visible = pers.IsPermissible(Business.BulletinManageBLL.Action_BulletinManage, PermissionType.Write);
            }

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

                string newFileName = DateTime.Now.ToFileTime().ToString() + "." + fileExt;

                //上传文件在Upload文件夹

                string file = Server.MapPath("\\Upload\\UploadFile\\" + newFileName);

                
                //文件上传
                FileUploadField1.PostedFile.SaveAs(file);

                this.hiddenFileName.Text = newFileName;

                Attachment attach = new Attachment();
                attach.Id = Guid.NewGuid();
                attach.MainId = new Guid(this.hfMainID.Text);
                attach.Name = fileExtention;
                attach.Url = newFileName;//AppSettings.HostUrl + "/Upload/UploadFile/" + newFileName;
                attach.Type = AttachmentType.Bulletin.ToString();
                attach.UploadDate = DateTime.Now;
                attach.UploadUser = new Guid(_context.User.Id);

                attachBll.AddAttachment(attach);

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

        #region Store
        public override void Store_DealerList(object sender, StoreRefreshDataEventArgs e)
        {
            //Clears the dealer's cache
            DMS.Business.Cache.DealerCacheHelper.FlushCache();

            //Gets all dealers
            IList<DealerMaster> dataSource = DMS.Business.Cache.DealerCacheHelper.GetDealers();
            var query = from p in dataSource
                        where p.HostCompanyFlag != true
                        select p;

            dataSource = query.ToList<DealerMaster>();
            if (sender is Store)
            {
                Store store1 = (sender as Store);

                store1.DataSource = dataSource;
                store1.DataBind();
            }
        }

        public void ResultStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;

            Hashtable table = new Hashtable();

            if (!string.IsNullOrEmpty(this.txtTitle.Text.Trim()))
                table.Add("Title", this.txtTitle.Text.Trim());

            if (this.cbUrgentDegree.SelectedItem.Value != "")
                table.Add("UrgentDegree", this.cbUrgentDegree.SelectedItem.Value);

            if(this.cbStatus.SelectedItem.Value != "")
                table.Add("Status", this.cbStatus.SelectedItem.Value);

            if (!string.IsNullOrEmpty(this.txtPublishedUser.Text.Trim()))
                table.Add("PublishedUser", this.txtPublishedUser.Text.Trim());

            if (!this.dfPublishedBeginDate.IsNull)
                table.Add("PublishedBeginDate", this.dfPublishedBeginDate.SelectedDate.ToString("yyyyMMdd"));

            if (!this.dfPublishedEndDate.IsNull)
                table.Add("PublishedEndDate", this.dfPublishedEndDate.SelectedDate.ToString("yyyyMMdd"));

            if (!this.dfExpirationBeginDate.IsNull)
                table.Add("ExpirationBeginDate", this.dfExpirationBeginDate.SelectedDate.ToString("yyyyMMdd"));

            if (!this.dfExpirationEndDate.IsNull)
                table.Add("ExpirationEndDate", this.dfExpirationEndDate.SelectedDate.ToString("yyyyMMdd"));

            DataSet data = bll.QuerySelectMainByFilter(table, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);
            e.TotalCount = totalCount;

            ResultStore.DataSource = data;
            ResultStore.DataBind();
        }

        public void DetailStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;

            Hashtable table = new Hashtable();

            if(!string.IsNullOrEmpty(this.hfMainID.Text))
                table.Add("BumId", this.hfMainID.Text);

            ////得到经销商主键列表
            //if (this.StoreRecords.Count > 0)
            //{
            //    var list = from dealer in this.StoreRecords select dealer.DealerDmaId.ToString();

            //    table.Add("DealerList", list.ToList());
            //}

            DataSet data = bll.QuerySelectDetailByFilter(table, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar2.PageSize : e.Limit), out totalCount);
            e.TotalCount = totalCount;

            DetailStore.DataSource = data;
            DetailStore.DataBind();
        }

        protected void DealerTypeStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            IDictionary<string, string> dictsCompanyType = DictionaryHelper.GetDictionary(SR.Consts_Dealer_Type);
            if (sender is Store)
            {
                Store DealerTypeStore = (sender as Store);

                DealerTypeStore.DataSource = dictsCompanyType;
                DealerTypeStore.DataBind();
            }

        }

        protected void AttachmentStore_Refresh(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;

            DataSet ds = attachBll.GetAttachmentByMainId(new Guid(this.hfMainID.Text), AttachmentType.Bulletin, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar3.PageSize : e.Limit), out totalCount);
            e.TotalCount = totalCount;

            AttachmentStore.DataSource = ds;
            AttachmentStore.DataBind();
        }
        #endregion

        #region AjaxMethod
        [AjaxMethod]
        public void DeleteItem(string id)
        {
           
            try
            {
               bool deatil=bll.deatil(new Guid(id));
                

            }
            catch
            {
               
            }
        }

        [AjaxMethod]
        public void Show(string id)
        {
            this.IsPageNew = (id == Guid.Empty.ToString());
            this.IsModified = false;
            this.IsSaved = false;
            this.ClearValue();

            //清空session中的记录
            this.StoreRecords.Clear();
            //判断是新增的还是需要查看明细的
            //新增时将状态置为‘草稿’
            //查看时通过Id得到实例
            if (id == Guid.Empty.ToString())
            {

                this.isPageNew.Value = true;
                BulletinMain main = new BulletinMain();
                this.hfMainID.Text = Guid.NewGuid().ToString();

                this.Status.SelectedItem.Value = BulletinStatus.Draft.ToString();
               
                this.SetDisabled("New" ,string.Empty);
                main.PublishedDate = DateTime.Now;
                main.PublishedUser = new Guid(_context.User.Id);
                main.CreateDate = main.PublishedDate;
                main.CreateUser = main.PublishedUser;
                main.UpdateDate = DateTime.Now;
                main.UpdateUser = new Guid(_context.User.Id);
                main.UpdateDate = DateTime.Now;
                main.Status = this.Status.SelectedItem.Value;
                main.Id = new Guid(this.hfMainID.Text);
                BulletinManageBLL b = new BulletinManageBLL();
                    b.InsertBulletinMain(main);


            }
            else
            {
                
                this.hfMainID.Text = id;

                this.SetValue(id);
            }
        }

        [AjaxMethod]
        public void SaveItem(string status)
        {
            //判断是‘草稿’还是‘发布’操作
            if (status == "Draft")
            {
                hfStatus.Text = BulletinStatus.Draft.ToString();
            }
            else if (status == "Published")
            {
                hfStatus.Text = BulletinStatus.Published.ToString();
            }

        }

        [AjaxMethod]
        public void CancelledItem(string id)
        {
            bool result = bll.CancelledItem(new Guid(id));

            this.ShowAlert(result, GetLocalResourceObject("CancelledItem.Body").ToString());
            IsSaved = true;
        }

        [AjaxMethod]
        public void DeleteDraft(string id)
        {
            bool result = bll.DeleteDraft(new Guid(id));
            if (result)
            {
                IsSaved = true;
                this.ShowAlert(result, GetLocalResourceObject("DeleteDraft.Body").ToString());
            }
           
        }

        [AjaxMethod]
        public void SaveBulletin(string id)
        {
            BulletinMain main = new BulletinMain();
            if (!string.IsNullOrEmpty(UrgentDegree.SelectedItem.Value))
                main.UrgentDegree = this.UrgentDegree.SelectedItem.Value;

            if (!string.IsNullOrEmpty(this.hfStatus.Text))
                main.Status = this.hfStatus.Text;

            //Edited By Song Yuqi On 2013-9-2 Begin
            if (!this.ExpirationDate.IsNull)
            {
                main.ExpirationDate = this.ExpirationDate.SelectedDate;
            }
            else
            {
                main.ExpirationDate = DateTime.MaxValue;
            }
            ////Edited By Song Yuqi On 2013-9-2 End

            if (!string.IsNullOrEmpty(this.Title.Text))
                main.Title = this.Title.Text;

            if (!string.IsNullOrEmpty(this.Body.Text))
                main.Body = this.Body.Text;

            main.ReadFlag = this.IsRead.Checked;

            //if (new Guid(this.hfMainID.Text) == Guid.Empty)
            //    main.Id = Guid.NewGuid();
            //else
            //    main.Id = new Guid(this.hfMainID.Text);
            main.Id = new Guid(this.hfMainID.Text);
            main.PublishedDate = DateTime.Now;
            main.PublishedUser = new Guid(_context.User.Id);
            main.CreateDate = main.PublishedDate;
            main.CreateUser = main.PublishedUser;
            main.UpdateDate= DateTime.Now;
           
            try
            {
              
              
                
                bool result = bll.Updatemain(main);
                if (result == true)
                {
                    Ext.Msg.Alert(GetLocalResourceObject("SaveBulletin.Success.Alert.Title").ToString(), GetLocalResourceObject("SaveBulletin.Success.Alert.Body").ToString()).Show();
                    IsSaved = true;
                }
            }
            catch (Exception ex)
            {
                Ext.Msg.Alert(GetLocalResourceObject("SaveBulletin.Failed.Alert.Title").ToString(), GetLocalResourceObject("SaveBulletin.Failed.Alert.Body").ToString()).Show();
                throw new Exception(ex.Message);
            }

        }

        [AjaxMethod]
        public void DeleteAttachment(string id, string fileName)
        {
            try
            {
                attachBll.DelAttachment(new Guid(id));
                string uploadFile = Server.MapPath("..\\..\\Upload\\UploadFile");
                File.Delete(uploadFile + "\\" + fileName);

            }
            catch(Exception ex)
            {
                Ext.Msg.Alert("Error", "删除失败").Show();
            }
        }
        #endregion

        #region 包含产品操作
        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);
            this.DealerSearchDialog1.AfterSelectedHandler += OnAfterSelectedRow;
        }

        /// <summary>
        /// 选择后，添加数据
        /// </summary>
        /// <param name="e"></param>
        protected void OnAfterSelectedRow(SelectedEventArgs e)
        {
            //添加已选择的数据

            IList<DealerMaster> dealerList = e.ToList<DealerMaster>();

            IList<DealerMaster> waitingAdd = dealerList.Where<DealerMaster>(p => !this.IsExistsStoreRecords(p.Id.Value)).ToList<DealerMaster>();

            IList<BulletinDetail> sellist = new List<BulletinDetail>();
            foreach (DealerMaster dealer in waitingAdd)
            {
                BulletinDetail item = new BulletinDetail();
                item.Id = Guid.NewGuid();
                item.BumId = new Guid(this.hfMainID.Text);
                item.DealerDmaId = dealer.Id.Value;

                sellist.Add(item);
            }
           
              bll.InsertDetail(sellist);
            ////更新已有关系的记录集
            //if (this.StoreRecords != null)
            //{
            //    this.StoreRecords = this.StoreRecords.Concat<BulletinDetail>(sellist).ToList<BulletinDetail>();

            //}
            //else
            //{
            //    this.StoreRecords = sellist;
            //}

        }

        public IList<BulletinDetail> StoreRecords
        {
            get
            {
                if (this.Session["DealerOfCatagory_StoreRecords"] == null)
                {
                    this.Session["DealerOfCatagory_StoreRecords"] = new List<BulletinDetail>();
                }
                return (IList<BulletinDetail>)this.Session["DealerOfCatagory_StoreRecords"];
            }
            set
            {
                this.Session["DealerOfCatagory_StoreRecords"] = value;
            }
        }
        #endregion

        #region 私有方法
        private bool IsExistsStoreRecords(Guid DealerId)
        {
            BulletinDetail detail = null;

            if (this.StoreRecords != null)
            {
                detail = this.StoreRecords.FirstOrDefault(p => p.DealerDmaId == DealerId);
            }

            if (detail != null)
                return true;
            else
                return false;
        }

        private void ClearValue()
        {
            //清空Detail数据
            this.UrgentDegree.SelectedItem.Value = "";
            this.Status.SelectedItem.Value = "";
            this.ExpirationDate.Clear();
            this.IsRead.Checked = false;
            this.Title.Clear();
            this.Body.Clear();
            this.IsRead.Checked = false;

            this.hfMainID.Clear();
            this.hfStatus.Clear();

            //按钮设置为不可见
            this.btnCancelled.Hide();
            this.btnDelDraft.Hide();
            this.btnPublished.Hide();
            this.btnSaveDraft.Hide();

            this.DetailPanel.ColumnModel.SetHidden(8, true);
            this.AttachmentPanel.ColumnModel.SetHidden(7, true);

            //添加按钮不可用
            this.btnAddItem.Hide();
            this.btnAddAttach.Hide();
            
            //切换到定义个Tab
            this.TabPanel1.ActiveTabIndex = 0;

            //控件状态控制
            this.UrgentDegree.Disabled = false;
            this.ExpirationDate.Disabled = false;
            this.IsRead.Disabled = false;
            this.Title.Disabled = false;
            this.Body.Disabled = false;
        }

        private void SetValue(string MainId)
        {
            BulletinMain main = bll.GetObjectById(new Guid(MainId));

            this.UrgentDegree.SelectedItem.Value = main.UrgentDegree;
            this.Status.SelectedItem.Value = main.Status;
            this.ExpirationDate.SelectedDate = main.ExpirationDate;
            this.IsRead.Checked = main.ReadFlag;
            this.Title.Text = main.Title;
            this.Body.Text = main.Body;

            this.SetDisabled(main.Status , main.PublishedUser.ToString());
            //将当前通知经销商列表放入session中
            //Hashtable ht = new Hashtable();
            //ht.Add("BumId", this.hfMainID.Text);
            //this.StoreRecords = bll.QuerySelectDetailByFilter(ht);
        }

        private void SetDisabled(string status , string UserID)
        {
            
            //先判断是否是入录人
            if (UserID == _context.User.Id)
            {
                //草稿
                //根据状态显示按钮
                if (status == BulletinStatus.Draft.ToString())
                {
                    this.isPageNew.Value = true;
                    this.btnDelDraft.Show();
                    this.btnPublished.Show();
                    this.btnSaveDraft.Show();
                    this.btnAddItem.Show();
                    this.btnAddAttach.Show();
                    this.DetailPanel.ColumnModel.SetHidden(8, false);
                    this.AttachmentPanel.ColumnModel.SetHidden(7, false);
                  


                }
                else if (status == BulletinStatus.Published.ToString())
                {
                    this.isSaved.Value = string.Empty;
                    this.isSaved.Value = true;
                    this.btnCancel.Hidden = true;
                    this.btnCancelled.Show();
                   
                }
            }
             //新增一个草稿
            else if (UserID == string.Empty)
            { 
                if (status == "New")
                {
                    this.isPageNew.Value = string.Empty;
                    this.isPageNew.Value = true;
                    this.btnPublished.Show();
                    this.btnSaveDraft.Show();
                    this.btnAddItem.Show();
                    this.btnAddAttach.Show();
                    this.DetailPanel.ColumnModel.SetHidden(8, false);
                    this.AttachmentPanel.ColumnModel.SetHidden(7, false);
                    
                   
                    
                }
            }
            //作废 和 已发布
            if (status == BulletinStatus.Published.ToString() || status == BulletinStatus.Cancelled.ToString())
            {
                this.isSaved.Value = string.Empty;
                this.isSaved.Value = true;
                this.UrgentDegree.Disabled = true;
                this.ExpirationDate.Disabled = true;
                this.IsRead.Disabled = true;
                this.Title.Disabled = true;
                this.Body.Disabled = true;
                              
            }
        }

        private void ShowAlert(bool result,string message)
        {
            if (result)
            {
                Ext.Msg.Alert(GetLocalResourceObject("ShowAlert.Success.Alert.Title").ToString(), message + GetLocalResourceObject("ShowAlert.Success.Alert.Body").ToString()).Show();
            }
            else
            {
                Ext.Msg.Alert(GetLocalResourceObject("ShowAlert.Failed.Alert.Title").ToString(), message + GetLocalResourceObject("ShowAlert.Failed.Alert.Body").ToString()).Show();
            }
        }
        #endregion
    }
}
