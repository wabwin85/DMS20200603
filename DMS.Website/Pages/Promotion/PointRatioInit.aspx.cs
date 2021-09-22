using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DMS.Website.Pages.Promotion
{
    using DMS.Model;
    using DMS.Business;
    using DMS.Business.Cache;
    using DMS.Common;
    using DMS.Website.Common;
    using Coolite.Ext.Web;
    using Lafite.RoleModel.Security;
    using System.Data;
    using System.Collections;
    public partial class PointRatioInit : BasePage
    {
        #region 公用
        private IPromotionPolicyBLL _business = new PromotionPolicyBLL();
     
        private IRoleModelContext _context = RoleModelContext.Current;
        private IConsignmentApplyHeaderBLL bll = new ConsignmentApplyHeaderBLL();
    
        public string InstanceId
        {
            get
            {
                return this.hidInstanceId.Text;
            }
            set
            {
                this.hidInstanceId.Text = value.ToString();
            }
        }
        #endregion
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                this.Bind_ProductLine(this.ProductLineStore);
            }
        }

        public override void Store_DealerList(object sender, StoreRefreshDataEventArgs e)
        {
            IRoleModelContext context = RoleModelContext.Current;


            IList<DealerMaster> dataSource = DealerCacheHelper.GetDealers();


            //过滤掉T1经销商
           

                var query = from p in dataSource
                            where p.ActiveFlag == true &&  p.DealerType!="T1"
                            select p;

                dataSource = query.ToList<DealerMaster>();

            

            if (sender is Store)
            {
                Store store1 = (sender as Store);

                store1.DataSource = dataSource;
                store1.DataBind();
            }
        }
        public  void PointRatiostore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            Hashtable ht=new Hashtable();
            if(!string.IsNullOrEmpty(cbDealer.SelectedItem.Value))
            {
            ht.Add("PlatFormId",cbDealer.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(cbProductline.SelectedItem.Value))
            {
                ht.Add("BU", cbProductline.SelectedItem.Value);
            }
            DataSet ds = _business.Query_ProPointRatio(ht, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);
            PointRatiostore.DataSource = ds;
            PointRatiostore.DataBind();
        }
        protected void UpLoadPointRatioStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            Hashtable obj = new Hashtable();
            obj.Add("UserId", _context.User.Id);
            DataSet ds = _business.QueryPro_BU_PointRatio_UIByUserId(obj, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolPointRatio.PageSize : e.Limit), out totalCount);
            e.TotalCount = totalCount;
            UpLoadPointRatioStore.DataSource = ds;
            UpLoadPointRatioStore.DataBind();

        }
      
        protected void UploadDealerClick(object sender, AjaxEventArgs e) 
        {
            //先删除上传人之前的数据
            _business.DeletePointRatioUIByCurrUser(_context.User.Id);

            if (this.FileUploadFieldPointRatio.HasFile)
            {
             
                System.Diagnostics.Debug.WriteLine("Upload Start : " + DateTime.Now.ToString());
                bool error = false;

                string fileName = FileUploadFieldPointRatio.PostedFile.FileName;
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

                string file = Server.MapPath("\\Upload\\PROPointRatio\\" + newFileName);


                //文件上传
                FileUploadFieldPointRatio.PostedFile.SaveAs(file);

                System.Diagnostics.Debug.WriteLine("Upload Finish : " + DateTime.Now.ToString());
              
               
                //导入到中间表
                DataTable dt = ExcelHelper.GetDataTable(file, "sheet1");

                //根据列数量判断文件模板是否正确
                if (dt.Columns.Count < 4)
                {
                    Ext.Msg.Alert("错误", "请使用正确的模板!").Show();

                }
                else
                {
                    if (dt.Rows.Count > 1)
                    {
                         string Messinge = string.Empty;
                        if (_business.PointRatioImpor(dt))
                        {
                            string IsValid = string.Empty;
                            if (_business.VerifyRatioUiInit(_context.User.Id,1,out IsValid))
                            {
                                if (IsValid == "Error")
                                {
                                    Ext.Msg.Alert("错误", "数据包含错误或警告信息，请确认后导入！").Show();
                                    this.ButtonWd7Submint.Hidden = true;
                                }
                                else
                                {
                                    Ext.Msg.Alert("提示", "导入成功!").Show();
                                    this.ButtonWd7Submint.Hidden = false;
                                    
                                }
                            }
                            UpLoadPointRatioStore.DataBind();
                        }
                        else
                        {
                            Ext.Msg.Alert("错误", "Excel数据格式错误!").Show();
                        }
                    }
                    else
                    {
                        Ext.Msg.Alert("错误", "没有数据可导入!").Show();
                    }

              

                }
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

        
      
      
        [AjaxMethod]
        public void Show(string id)
        {
            CbRatioproductline.Disabled = false;
            cbChoiceDelare.Disabled = false;
            ClearWindow();
         
            hidInstanceId.Text = id;
            if (id!="-1")
            {
               
                ProBuPointRatio PointRatio = _business.GetProBuPointRatioObj(int.Parse(hidInstanceId.Text));
                CbRatioproductline.SelectedItem.Value = PointRatio.Bu;
              
                txtRatio.Text = PointRatio.Ratio.ToString();
                DataSet ds = bll.GetProductLineVsDivisionCode(CbRatioproductline.SelectedItem.Value);

                string code = string.Empty;
                if (ds.Tables[0].Rows.Count > 0)
                {

                    code = ds.Tables[0].Rows[0]["DivisionCode"].ToString();

                }

                DataSet Dealerds = _business.SelectDealerByproductline(code);
                PointRatioDealerStore.DataSource = Dealerds;
                PointRatioDealerStore.DataBind();
                cbChoiceDelare.SelectedItem.Value = PointRatio.PlatFormId.ToString();
                CbRatioproductline.Disabled = true;
                cbChoiceDelare.Disabled = true;
            }

           
            ContractsEditorWindow.Show();

        }
        [AjaxMethod]
        public void CbRatioproductlineChange()
        {
            DataSet ds = bll.GetProductLineVsDivisionCode(CbRatioproductline.SelectedItem.Value);
            cbChoiceDelare.SelectedItem.Value = "";
            cbChoiceDelare.SelectedItem.Text = "";
            string code = string.Empty;
            if (ds.Tables[0].Rows.Count > 0)
            {

                code = ds.Tables[0].Rows[0]["DivisionCode"].ToString();
               
            }
           
            DataSet Dealerds = _business.SelectDealerByproductline(code);
            PointRatioDealerStore.DataSource = Dealerds;
            PointRatioDealerStore.DataBind();
           
        }
        [AjaxMethod]
        public void Sumbit()
        {
            hidrtnVal.Text = "Susses";
            hidrtnMesg.Text=string.Empty;
            ProBuPointRatio Ratio = new ProBuPointRatio();
            Hashtable ht = new Hashtable();
            ht.Add("BU", CbRatioproductline.SelectedItem.Value);
            ht.Add("PlatFormId", cbChoiceDelare.SelectedItem.Value);
            if (hidInstanceId.Text != "-1")
            {
                Ratio.ModifyBy = _context.User.Id;
                Ratio.ModifyDate = DateTime.Now;
                Ratio = _business.GetProBuPointRatioObj(int.Parse(hidInstanceId.Text));

            }
            else {
                Ratio.Bu = CbRatioproductline.SelectedItem.Value;
                Ratio.PlatFormId = new Guid(cbChoiceDelare.SelectedItem.Value);

                Ratio.CreateBy = _context.User.Id;
                Ratio.CreateTime = DateTime.Now;
            }
           
            Ratio.Ratio = decimal.Parse(txtRatio.Text);
           
            bool bl = false;
            if (hidInstanceId.Text != "-1")
            {
                bl = _business.UpdateProPointRatio(Ratio);
              
            }
            else {
                //判断产品线的经销商加价率是否已经存在
                DataSet ds=_business.ExistsByBuDmaId(ht);
                if (ds.Tables[0].Rows.Count>0)
                {
                  Ratio=_business.GetProBuPointRatioObj(int.Parse (ds.Tables[0].Rows[0]["ID"].ToString()));
                  Ratio.Ratio = decimal.Parse(txtRatio.Text);
                  Ratio.ModifyBy = _context.User.Id;
                  Ratio.ModifyDate = DateTime.Now;
                  bl = _business.UpdateProPointRatio(Ratio);
                }
                else
                {
                    bl = _business.AddProPointRatio(Ratio);
                }
            
            }
            if (!bl)
            {

                hidrtnVal.Text = "Error";
                hidrtnMesg.Text = "提交出错，请重新提交";
            }

        }
        [AjaxMethod]
        public void Delete(string Id)
        {
          
            bool bl = false;
           bl= _business.DeleteProPointRatio(int.Parse(Id));
           if (bl)
           {
               PointRatiostore.DataBind();
              
           }
           else {
               Ext.Msg.Alert("Error", "删除出错").Show();
           }

        }
        [AjaxMethod]
        public void wd7PointRatioUploadShow()
        {
            this.ButtonWd7Submint.Hidden = true;
            FileUploadFieldPointRatio.Reset();
            GridPanel1.Reload();
            wd7PointRatioUpload.Show();
        }
        [AjaxMethod]

        public void PointRatioSubmint()
        {
            string IsValid = string.Empty;
            _business.VerifyRatioUiInit(_context.User.Id, 0, out IsValid);
            if (IsValid == "Success")
            {
                Ext.Msg.Alert("提示", "提交成功!").Show();
            }
        }
        public void ClearWindow()
        {
            CbRatioproductline.SelectedItem.Value = string.Empty;
            cbChoiceDelare.SelectedItem.Value = string.Empty;
            txtRatio.Clear();
            hidProducdId.Clear();
            hidrtnVal.Clear();
            hidrtnMesg.Clear();
            hidInstanceId.Clear();
            hidAuthorizationStatus.Text = string.Empty;
           
        }
    }
}
            