﻿using System;
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
using DMS.Business.DataInterface;
using Lafite.RoleModel.Security;

namespace DMS.Website.Pages.Inventory
{
    public partial class InventoryAdjustAuditImport : BasePage
    {
        IRoleModelContext _context = RoleModelContext.Current;
        private IInventoryAdjustBLL _business = null;
        [Dependency]
        public IInventoryAdjustBLL business
        {
            get { return _business; }
            set { _business = value; }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
           
        }
        #region Store
        protected void ResultStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            //if (!string.IsNullOrEmpty(HiddbatchNumber.Text))
            //{
             int totalCount = 0;
             DataSet ds = _business.QueryInterfaceDealerReturnConfirmBybatchNumber(HiddbatchNumber.Text, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);
             this.ResultStore.DataSource = ds;
             this.ResultStore.DataBind();
            //}
        }
        #endregion
        #region 上传ex
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
                        Title = GetLocalResourceObject("fileExtention.Msg.Show.Title").ToString(),
                        Message = GetLocalResourceObject("fileExtention.Msg.Show.Message").ToString()
                    });

                    return;
                }

                //构造文件名称

                string newFileName = Guid.NewGuid().ToString() + "." + fileExtention;

                //上传文件在Upload文件夹

                string file = Server.MapPath("\\Upload\\InterfaceDealerReturnConfirm\\" + newFileName);


                //文件上传 
                FileUploadField1.PostedFile.SaveAs(file);

                this.hidFileName.Text = newFileName;
                System.Diagnostics.Debug.WriteLine("Upload Finish : " + DateTime.Now.ToString());
                #endregion

                #region 读取文件到中间表
                //导入到中间表
                DataTable dt = ExcelHelper.GetDataTable(file, "sheet1");

                //根据列数量判断文件模板是否正确
                if (dt.Columns.Count < 8)
                {
                    Ext.Msg.Alert("错误", "请使用正确的模板!").Show();
                    return;
                }

                if (dt.Rows.Count > 1)
                {
                    IInventoryAdjustBLL Bll = new InventoryAdjustBLL();
                     string batchNumber = string.Empty;
                    string ClientID = string.Empty;
                    string Messinge = string.Empty;
                    if (Bll.InventoryAdjustImport(dt, newFileName, out batchNumber, out ClientID, out  Messinge))
                    {
                        if (_context.User.CorpType == DealerType.LP.ToString())
                        {
                            //如果是平台进行审批，则校验退货单经销商的品台是否为审批的平台

                            DataSet ds = Bll.SelectExistsDMAParent(batchNumber, RoleModelContext.Current.User.CorpId.Value.ToString());
                            if (ds.Tables[0].Rows.Count > 0)
                            {
                                
                                Messinge = ds.Tables[0].Rows[0][0].ToString();
                                Messinge = Messinge.Replace("</Messinge>", "<br/>");
                                Ext.Msg.Alert("Messinge", Messinge).Show();
                                return;
                            }

                        }
                        string RtnMsg = string.Empty;
                        string RtnVal = string.Empty;
                        AdjustBLL business = new AdjustBLL();
                        business.HandleDealerReturnConfirmData(batchNumber, ClientID, out RtnVal, out RtnMsg);
                        if (!RtnVal.Equals("Success"))
                        {
                            throw new Exception(RtnMsg);
                        }
                        else {
                            ////如果调用过程成功，则检查是否存在未通过验证的数据
                            IList<InterfaceDealerReturnConfirm> errList = business.SelectDealerReturnConfirmByBatchNbrErrorOnly(batchNumber);
                            if (errList != null && errList.Count > 0)
                            {
                                HiddbatchNumber.Text = batchNumber;
                                GridPanel3.ColumnModel.SetHidden(1, false);
                                this.ResultStore.DataBind();
                                Ext.Msg.Alert("Messinge", "存在错误信息").Show();
                            }
                            else
                            {
                                HiddbatchNumber.Clear();
                                this.ResultStore.DataBind();
                                Ext.Msg.Alert("Messinge", "上传成功").Show();
                            }
                        
                        }

                    }
                    else {
                        HiddbatchNumber.Clear();
                        GridPanel3.ColumnModel.SetHidden(1, true);
                        this.ResultStore.DataBind();
                        Ext.Msg.Alert("错误", Messinge).Show();
                    }
                  
                }
                else
                {
                    Ext.Msg.Alert("错误", "数据导入异常!").Show();
                }

                #endregion

            }
            else
            {
                Ext.Msg.Show(new MessageBox.Config
                {
                    Buttons = MessageBox.Button.OK,
                    Icon = MessageBox.Icon.ERROR,
                    Title = GetLocalResourceObject("SaveFailure.Title").ToString(),
                    Message = GetLocalResourceObject("SaveFailure.Message").ToString()
                });
            }
        }
        #endregion
    }
}
