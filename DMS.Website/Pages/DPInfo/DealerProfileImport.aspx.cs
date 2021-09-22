using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DMS.Website.Common;
using Lafite.RoleModel.Security;
using Coolite.Ext.Web;
using System.Data;
using System.Collections;
using DMS.Business.DPInfo;
using DMS.Business;

namespace DMS.Website.Pages.DPInfo
{
    public partial class DealerProfileImport : BasePage
    {
        #region 公用

        private IRoleModelContext _context = RoleModelContext.Current;
        private DPImportBLL dpImportBLL = new DPImportBLL();

        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
            }
        }

        #region 导入

        protected void BtnImportFileClick(object sender, AjaxEventArgs e)
        {
            try
            {
                if (this.IptImportFile.HasFile)
                {
                    #region 上传文件至服务器
                    System.Diagnostics.Debug.WriteLine("Upload Start : " + DateTime.Now.ToString());
                    bool error = false;

                    string fileName = IptImportFile.PostedFile.FileName;
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
                            Message = "请使用正确的模板文件，模板文件为EXCEL文件！"
                        });

                        return;
                    }

                    //构造文件名称

                    string newFileName = Guid.NewGuid().ToString() + "." + fileExtention;

                    //上传文件在Upload文件夹

                    string file = Server.MapPath("\\Upload\\DealerProfile\\" + newFileName);


                    //文件上传
                    IptImportFile.PostedFile.SaveAs(file);

                    this.IptFileName.Text = newFileName;
                    System.Diagnostics.Debug.WriteLine("Upload Finish : " + DateTime.Now.ToString());
                    #endregion

                    if (IptImportType.SelectedItem.Value == "DPPay")
                    {
                        ImportDataPay(file);
                    }
                    else if (IptImportType.SelectedItem.Value == "DPAudit")
                    {
                        ImportDataAudit(file);
                    }
                    else if (IptImportType.SelectedItem.Value == "DPTrain")
                    {
                        ImportDataTrain(file);
                    }
                    else if (IptImportType.SelectedItem.Value == "DPPrize")
                    {
                        ImportDataPrize(file);
                    }
                    else if (IptImportType.SelectedItem.Value == "DPSatisfy")
                    {
                        ImportDataSatisfy(file);
                    }
                    else if (IptImportType.SelectedItem.Value == "DPAuditChannel")
                    {
                        ImportDataAuditChannel(file);
                    }
                    else if (IptImportType.SelectedItem.Value == "DPComp")
                    {
                        ImportDataComp(file);
                    }
                    else if (IptImportType.SelectedItem.Value == "DPBaseComp")
                    {
                        ImportDataBaseComp(file);
                    }
                    else if (IptImportType.SelectedItem.Value == "DPDeepComp")
                    {
                        ImportDataDeepComp(file);
                    }
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
            catch (Exception ex)
            {
                if (ex.Message.IndexOf("不是一个有效名称") > 0)
                {
                    Ext.Msg.Show(new MessageBox.Config
                    {
                        Buttons = MessageBox.Button.OK,
                        Icon = MessageBox.Icon.ERROR,
                        Title = "上传失败",
                        Message = "Sheet(" +ex.Message.Substring(1, ex.Message.IndexOf("$") - 1) + ")不存在"
                    });
                }
                else
                {
                    Ext.Msg.Show(new MessageBox.Config
                    {
                        Buttons = MessageBox.Button.OK,
                        Icon = MessageBox.Icon.ERROR,
                        Title = "上传失败",
                        Message = ex.Message
                    });
                }
            }
        }

        private void ImportDataPay(string file)
        {
            #region 读取文件到中间表
            //导入到中间表
            DataTable dt = ExcelHelper.GetDataTable(file, "付款结算及违约记录");

            //根据列数量判断文件模板是否正确
            if (dt.Columns.Count < 14)
            {
                Ext.Msg.Alert("错误", "请使用正确的模板！").Show();
                return;
            }

            if (dt.Rows.Count > 1)
            {
                if (dpImportBLL.ImportDPPay(dt))
                {
                    string IsValid = string.Empty;

                    if (dpImportBLL.VerifyDPPay(IptPayVersion.Text, out IsValid))
                    {
                        if (IsValid == "Success")
                        {
                            Ext.Msg.Alert("消息", "数据导入成功！").Show();
                        }
                        else if (IsValid == "Error")
                        {
                            Ext.Msg.Alert("消息", "数据包含错误！").Show();
                        }
                        else
                        {
                            Ext.Msg.Alert("消息", "数据导入异常！").Show();
                        }
                    }
                    else
                    {
                        Ext.Msg.Alert("错误", "导入数据过程发生错误！").Show();
                    }
                }
                else
                {
                    Ext.Msg.Alert("错误", "Excel数据格式错误！").Show();
                }
            }
            else
            {
                Ext.Msg.Alert("错误", "没有数据可导入！").Show();
            }

            #endregion
        }

        private void ImportDataAudit(string file)
        {
            #region 读取文件到中间表
            //导入到中间表
            DataTable dt = ExcelHelper.GetDataTable(file, "审计分析评估");

            //根据列数量判断文件模板是否正确
            if (dt.Columns.Count < 17)
            {
                Ext.Msg.Alert("错误", "请使用正确的模板！").Show();
                return;
            }

            if (dt.Rows.Count > 1)
            {
                if (dpImportBLL.ImportDPAudit(dt))
                {
                    string IsValid = string.Empty;

                    if (dpImportBLL.VerifyDPAudit(out IsValid))
                    {
                        if (IsValid == "Success")
                        {
                            Ext.Msg.Alert("消息", "数据导入成功！").Show();
                        }
                        else if (IsValid == "Error")
                        {
                            Ext.Msg.Alert("消息", "数据包含错误！").Show();
                        }
                        else
                        {
                            Ext.Msg.Alert("消息", "数据导入异常！").Show();
                        }
                    }
                    else
                    {
                        Ext.Msg.Alert("错误", "导入数据过程发生错误！").Show();
                    }
                }
                else
                {
                    Ext.Msg.Alert("错误", "Excel数据格式错误！").Show();
                }
            }
            else
            {
                Ext.Msg.Alert("错误", "没有数据可导入！").Show();
            }

            #endregion
        }

        private void ImportDataTrain(string file)
        {
            #region 读取文件到中间表
            //导入到中间表
            DataTable dt = ExcelHelper.GetDataTable(file, "培训记录");

            //根据列数量判断文件模板是否正确
            if (dt.Columns.Count < 16)
            {
                Ext.Msg.Alert("错误", "请使用正确的模板！").Show();
                return;
            }

            if (dt.Rows.Count > 8)
            {
                if (dpImportBLL.ImportDPTrain(dt))
                {
                    string IsValid = string.Empty;

                    if (dpImportBLL.VerifyDPTrain(out IsValid))
                    {
                        if (IsValid == "Success")
                        {
                            Ext.Msg.Alert("消息", "数据导入成功！").Show();
                        }
                        else if (IsValid == "Error")
                        {
                            Ext.Msg.Alert("消息", "数据包含错误！").Show();
                        }
                        else
                        {
                            Ext.Msg.Alert("消息", "数据导入异常！").Show();
                        }
                    }
                    else
                    {
                        Ext.Msg.Alert("错误", "导入数据过程发生错误！").Show();
                    }
                }
                else
                {
                    Ext.Msg.Alert("错误", "Excel数据格式错误！").Show();
                }
            }
            else
            {
                Ext.Msg.Alert("错误", "没有数据可导入！").Show();
            }

            #endregion
        }

        private void ImportDataPrize(string file)
        {
            #region 读取文件到中间表
            //导入到中间表
            DataTable dt = ExcelHelper.GetDataTable(file, "年度奖项名单");

            //根据列数量判断文件模板是否正确
            if (dt.Columns.Count < 6)
            {
                Ext.Msg.Alert("错误", "请使用正确的模板！").Show();
                return;
            }

            if (dt.Rows.Count > 1)
            {
                if (dpImportBLL.ImportDPPrize(dt))
                {
                    string IsValid = string.Empty;

                    if (dpImportBLL.VerifyDPPrize(out IsValid))
                    {
                        if (IsValid == "Success")
                        {
                            Ext.Msg.Alert("消息", "数据导入成功！").Show();
                        }
                        else if (IsValid == "Error")
                        {
                            Ext.Msg.Alert("消息", "数据包含错误！").Show();
                        }
                        else
                        {
                            Ext.Msg.Alert("消息", "数据导入异常！").Show();
                        }
                    }
                    else
                    {
                        Ext.Msg.Alert("错误", "导入数据过程发生错误！").Show();
                    }
                }
                else
                {
                    Ext.Msg.Alert("错误", "Excel数据格式错误！").Show();
                }
            }
            else
            {
                Ext.Msg.Alert("错误", "没有数据可导入！").Show();
            }

            #endregion
        }

        private void ImportDataSatisfy(string file)
        {
            #region 读取文件到中间表
            //导入到中间表
            DataTable dt = ExcelHelper.GetDataTable(file, "Sheet1");

            //根据列数量判断文件模板是否正确
            if (dt.Columns.Count < 57)
            {
                Ext.Msg.Alert("错误", "请使用正确的模板！").Show();
                return;
            }

            if (dt.Rows.Count > 1)
            {
                if (dpImportBLL.ImportDPSatisfy(dt))
                {
                    string IsValid = string.Empty;

                    if (dpImportBLL.VerifyDPSatisfy(IptSatisfyYear.Text + "-" + IptSatisfyQuarter.SelectedItem.Value, out IsValid))
                    {
                        if (IsValid == "Success")
                        {
                            Ext.Msg.Alert("消息", "数据导入成功！").Show();
                        }
                        else if (IsValid == "Error")
                        {
                            Ext.Msg.Alert("消息", "数据包含错误！").Show();
                        }
                        else
                        {
                            Ext.Msg.Alert("消息", "数据导入异常！").Show();
                        }
                    }
                    else
                    {
                        Ext.Msg.Alert("错误", "导入数据过程发生错误！").Show();
                    }
                }
                else
                {
                    Ext.Msg.Alert("错误", "Excel数据格式错误！").Show();
                }
            }
            else
            {
                Ext.Msg.Alert("错误", "没有数据可导入！").Show();
            }

            #endregion
        }

        private void ImportDataAuditChannel(string file)
        {
            #region 读取文件到中间表
            //导入到中间表
            DataTable dt = ExcelHelper.GetDataTable(file, "渠道审计结果");

            //根据列数量判断文件模板是否正确
            if (dt.Columns.Count < 48)
            {
                Ext.Msg.Alert("错误", "请使用正确的模板！").Show();
                return;
            }

            if (dt.Rows.Count > 1)
            {
                if (dpImportBLL.ImportDPAuditChannel(dt))
                {
                    string IsValid = string.Empty;

                    if (dpImportBLL.VerifyDPAuditChannel(out IsValid))
                    {
                        if (IsValid == "Success")
                        {
                            Ext.Msg.Alert("消息", "数据导入成功！").Show();
                        }
                        else if (IsValid == "Error")
                        {
                            Ext.Msg.Alert("消息", "数据包含错误！").Show();
                        }
                        else
                        {
                            Ext.Msg.Alert("消息", "数据导入异常！").Show();
                        }
                    }
                    else
                    {
                        Ext.Msg.Alert("错误", "导入数据过程发生错误！").Show();
                    }
                }
                else
                {
                    Ext.Msg.Alert("错误", "Excel数据格式错误！").Show();
                }
            }
            else
            {
                Ext.Msg.Alert("错误", "没有数据可导入！").Show();
            }

            #endregion
        }

        private void ImportDataComp(string file)
        {
            String newFileName = "";
            string fileName = "";
            if (this.IptDPCompFile.HasFile)
            {
                fileName = IptDPCompFile.PostedFile.FileName;
                string fileExtention = string.Empty;
                fileExtention = fileName.Substring(fileName.LastIndexOf(".") + 1).ToLower();


                //构造文件名称
                newFileName = Guid.NewGuid().ToString() + "." + fileExtention;

                //上传文件在Upload文件夹
                String compFile = Server.MapPath("\\Upload\\UploadFile\\DPComp\\" + newFileName);

                //文件上传
                IptDPCompFile.PostedFile.SaveAs(compFile);
            }

            #region 读取文件到中间表
            //导入到中间表
            DataSet ds = ExcelHelper.GetDataSet(file, new String[] { "报告信息", "注册信息", "股权结构", "关联机构", "人员状况", "运营情况", "公共记录" });

            //根据列数量判断文件模板是否正确
            if (ds.Tables[0].Columns.Count < 11 || ds.Tables[1].Columns.Count < 17
                || ds.Tables[2].Columns.Count < 14 || ds.Tables[3].Columns.Count < 1
                || ds.Tables[4].Columns.Count < 11 || ds.Tables[5].Columns.Count < 18
                || ds.Tables[6].Columns.Count < 7)
            {
                Ext.Msg.Alert("错误", "请使用正确的模板！").Show();
                return;
            }

            if (ds.Tables[0].Rows.Count > 1 && ds.Tables[1].Rows.Count > 1
                && ds.Tables[2].Rows.Count > 1 && ds.Tables[3].Rows.Count > 1
                && ds.Tables[4].Rows.Count > 1 && ds.Tables[5].Rows.Count > 1
                && ds.Tables[6].Rows.Count > 1)
            {
                string IsValid = string.Empty;

                if (dpImportBLL.VerifyDPComp(IptDealerCode.Text, ds, newFileName, fileName))
                {
                    Ext.Msg.Alert("消息", "数据导入成功！").Show();
                }
                else
                {
                    Ext.Msg.Alert("错误", "数据包含错误！").Show();
                }
            }
            else
            {
                Ext.Msg.Alert("错误", "没有数据可导入！").Show();
            }

            #endregion
        }

        private void ImportDataBaseComp(string file)
        {
            #region 读取文件到中间表
            //导入到中间表
            DataTable dt = ExcelHelper.GetDataTable(file, "基础合规审计报告");

            //根据列数量判断文件模板是否正确
            if (dt.Columns.Count < 10)
            {
                Ext.Msg.Alert("错误", "请使用正确的模板！").Show();
                return;
            }

            if (dt.Rows.Count > 1)
            {
                if (dpImportBLL.ImportDPBaseComp(dt))
                {
                    string IsValid = string.Empty;

                    if (dpImportBLL.VerifyDPBaseComp(out IsValid))
                    {
                        if (IsValid == "Success")
                        {
                            Ext.Msg.Alert("消息", "数据导入成功！").Show();
                        }
                        else if (IsValid == "Error")
                        {
                            Ext.Msg.Alert("消息", "数据包含错误！").Show();
                        }
                        else
                        {
                            Ext.Msg.Alert("消息", "数据导入异常！").Show();
                        }
                    }
                    else
                    {
                        Ext.Msg.Alert("错误", "导入数据过程发生错误！").Show();
                    }
                }
                else
                {
                    Ext.Msg.Alert("错误", "Excel数据格式错误！").Show();
                }
            }
            else
            {
                Ext.Msg.Alert("错误", "没有数据可导入！").Show();
            }

            #endregion
        }

        private void ImportDataDeepComp(string file)
        {
            #region 读取文件到中间表
            //导入到中间表
            DataTable dt = ExcelHelper.GetDataTable(file, "深度合规审计报告");

            //根据列数量判断文件模板是否正确
            if (dt.Columns.Count < 2)
            {
                Ext.Msg.Alert("错误", "请使用正确的模板！").Show();
                return;
            }

            if (dt.Rows.Count > 1)
            {
                if (dpImportBLL.ImportDPDeepComp(dt))
                {
                    string IsValid = string.Empty;

                    if (dpImportBLL.VerifyDPDeepComp(out IsValid))
                    {
                        if (IsValid == "Success")
                        {
                            Ext.Msg.Alert("消息", "数据导入成功！").Show();
                        }
                        else if (IsValid == "Error")
                        {
                            Ext.Msg.Alert("消息", "数据包含错误！").Show();
                        }
                        else
                        {
                            Ext.Msg.Alert("消息", "数据导入异常！").Show();
                        }
                    }
                    else
                    {
                        Ext.Msg.Alert("错误", "导入数据过程发生错误！").Show();
                    }
                }
                else
                {
                    Ext.Msg.Alert("错误", "Excel数据格式错误！").Show();
                }
            }
            else
            {
                Ext.Msg.Alert("错误", "没有数据可导入！").Show();
            }

            #endregion
        }

        protected void StoImportList_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            Hashtable param = new Hashtable();

            param.Add("UserId", _context.User.Id);

            DataSet query = null;
            if (IptImportType.SelectedItem.Value == "DPPay")
            {
                this.RstImportList.ColumnModel.SetHidden(0, true);
                query = dpImportBLL.GetImportDPPayByCondition(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagImportList.PageSize : e.Limit), out totalCount);
            }
            else if (IptImportType.SelectedItem.Value == "DPAudit")
            {
                this.RstImportList.ColumnModel.SetHidden(0, true);
                param.Add("ImportType", "DPAudit");
                query = dpImportBLL.GetDPImportHead(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagImportList.PageSize : e.Limit), out totalCount);
            }
            else if (IptImportType.SelectedItem.Value == "DPBaseComp")
            {
                this.RstImportList.ColumnModel.SetHidden(0, true);
                param.Add("ImportType", "DPBaseComp");
                query = dpImportBLL.GetDPImportHead(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagImportList.PageSize : e.Limit), out totalCount);
            }
            else if (IptImportType.SelectedItem.Value == "DPDeepComp")
            {
                this.RstImportList.ColumnModel.SetHidden(0, true);
                param.Add("ImportType", "DPDeepComp");
                query = dpImportBLL.GetDPImportHead(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagImportList.PageSize : e.Limit), out totalCount);
            }
            else if (IptImportType.SelectedItem.Value == "DPTrain")
            {
                this.RstImportList.ColumnModel.SetHidden(0, true);
                query = dpImportBLL.GetImportDPTrainByCondition(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagImportList.PageSize : e.Limit), out totalCount);
            }
            else if (IptImportType.SelectedItem.Value == "DPPrize")
            {
                this.RstImportList.ColumnModel.SetHidden(0, true);
                query = dpImportBLL.GetImportDPPrizeByCondition(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagImportList.PageSize : e.Limit), out totalCount);
            }
            else if (IptImportType.SelectedItem.Value == "DPAuditChannel")
            {
                this.RstImportList.ColumnModel.SetHidden(0, true);
                param.Add("ImportType", "AuditChannel");
                query = dpImportBLL.GetDPImportHead(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagImportList.PageSize : e.Limit), out totalCount);
            }
            else if (IptImportType.SelectedItem.Value == "DPComp")
            {
                this.RstImportList.ColumnModel.SetHidden(0, false);
                query = dpImportBLL.GetImportDPCompByCondition(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagImportList.PageSize : e.Limit), out totalCount);
            }
            else if (IptImportType.SelectedItem.Value == "DPSatisfy")
            {
                this.RstImportList.ColumnModel.SetHidden(0, false);
                query = dpImportBLL.GetImportDPSatisfyByCondition(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagImportList.PageSize : e.Limit), out totalCount);
            }
            else
            {
                return;
            }
            (this.StoImportList.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
            this.StoImportList.DataSource = query;
            this.StoImportList.DataBind();
        }

        #endregion

    }
}
