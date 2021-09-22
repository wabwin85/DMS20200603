using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Coolite.Ext.Web;
using DMS.Model;
using DMS.Business;
using DMS.Common;
using DMS.Website.Common;
using Microsoft.Practices.Unity;
using System.Data;
namespace DMS.Website.Controls
{
    [AjaxMethodProxyID(IDMode = AjaxMethodProxyIDMode.Alias, Alias = "TerritoryEditor")]
    public partial class TerritoryEditor : BaseUserControl
    {
        ITerritoryBLL business = new TerritoryBLL();
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        #region Store
        protected void ProductLineStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            DataSet ds = business.GetProductLineList(this.HiddenNodeId.Text);
            if (sender is Store)
            {
                Store store1 = (sender as Store);
                store1.DataSource = ds;
                store1.DataBind();
            }
        }
        #endregion

        #region Ajax Method
        [AjaxMethod]
        public void UpdateFormValue(string id)
        {
            PartsClassification part = null;
            IProductClassifications bll = new ProductClassifications();
            if (!string.IsNullOrEmpty(id))
                part = bll.GetObject(new Guid(id));
            else
                part = bll.GetObject(new Guid());

            DataSet ds = business.GetTerritoryHierarchyByThid(id);
            if (ds.Tables[0].Rows[0]["BumId"] != DBNull.Value)
            {
                if (ds.Tables[0].Rows.Count > 0)
                {

                    this.txtCode.Text = ds.Tables[0].Rows[0]["Code"].ToString();
                    this.txtName.Text = ds.Tables[0].Rows[0]["Name"].ToString();
                    this.txtDescription.Text = ds.Tables[0].Rows[0]["Description"].ToString();
                    this.cbLevel.SelectedItem.Value = ds.Tables[0].Rows[0]["Level"].ToString();
                    this.HiddenNodeParentId.Text = ds.Tables[0].Rows[0]["ParentId"].ToString();
                    DataSet dsBU = business.GetProductLineById(ds.Tables[0].Rows[0]["BumId"].ToString());
                    this.txtProductLine.Text = dsBU.Tables[0].Rows[0]["ATTRIBUTE_NAME"].ToString();
                    this.HiddenProductLineId.Text = dsBU.Tables[0].Rows[0]["Id"].ToString();
                    //this.HiddenCode.Text = ds.Tables[0].Rows[0]["Code"].ToString();
                }
                this.cbLevel.Disabled = true;
                this.txtProductLine.Disabled = true;
                this.PartsDetailsWindow.Show();
            }
        }

      

        [AjaxMethod]
        public void Show(string isAdd, string Id, string parentId)
        {
            ClearFormValue(); //清空页面
            if (parentId == "0") //跟节点不能添加
            {
                return;
            }
            this.HiddenNodeId.Text = Id;
            this.HiddenNodeParentId.Text = parentId;
            this.HiddenIsPageNew.Text = isAdd;

            if (isAdd == "0")
            {
                //新增,初始话页面

                SetLevel(); //层级赋值
                SetProductLine(); //产品线
                if (this.HiddenLevel.Text.Trim() == "Province") //Territory层不能添加
                {
                    return;
                }
                this.PartsDetailsWindow.Show();
            }
            else if (isAdd == "1")
            {
                //修改,初始话页面

                SetLevel(); //层级赋值
                SetProductLine(); //产品线
                UpdateFormValue(Id);
            }
           
        }
        [AjaxMethod]
        public string DeleteTerritoryHierarchy(string Id)
        {
            string result = "0";
            if (Id == "Synthes") //根节点不能删除
            {
                return "3";
            }
            if (business.GetLevel(Id, 0) == "BU")  //BU不能删除
            {
                return "5";
            }
            //如果当前层级是Province 判断Territory层是否有数据 如果有则不能删除
            if (business.GetLevel(Id, 0) == "Province")  //
            {
                bool bl = business.GetTerritoryByProvinceId(Id);
                if (bl)
                {
                    return "4";
                }
            }
            DataSet ds = business.GetChildNode(Id);
            if (ds.Tables[0].Rows.Count > 0)
            {
                result = "1";   //有子节点不能删除
            }
            else
            {
                if (Id != "")
                {
                    try
                    {
                        business.DeleteTerritoryHierarchy(new Guid(Id));
                    }
                    catch
                    {
                        result = "2"; //删除出错
                    }
                }
            }
            return result;
        }

        [AjaxMethod]
        public string SaveNodeData()
        {
            string result = "0";

            TerritoryHierarchy th = new TerritoryHierarchy();
            if (this.HiddenIsPageNew.Text != "0")
            {
                try
                {
                    //if (this.HiddenCode.Text.Trim() != this.txtCode.Text.Trim()) //判断修改后的编码和修改前的编码是否相同
                    //{
                    //    if (!business.validateCodeIdentical(this.txtCode.Text.Trim())) //判断编号是否有重复
                    //    {
                    //        return "1";
                    //    }
                    //}
                    Guid Thid = new Guid(this.HiddenNodeId.Text.Trim());      //ID
                    th.Id = Thid;
                    th.Code = this.txtCode.Text; //区域编码
                    th.Name = this.txtName.Text; //区域名称
                    th.Level = this.cbLevel.SelectedItem.Value; //区域等级
                    th.Description = this.txtDescription.Text; //区域描述
                    th.ParentId = new Guid(this.HiddenNodeParentId.Text); //上级ID
                    string ProductLine = this.HiddenProductLineId.Text;
                    th.BumId = new Guid(ProductLine); //产品线
                    business.UpdateTerritoryHierarchy(th);


                }
                catch (Exception ex)
                {
                    throw ex;
                }
            }
            else
            {
                try
                {
                    //if (!business.validateCodeIdentical(this.txtCode.Text.Trim())) //判断编号是否有重复
                    //{
                    //    return "1";
                    //}
                    Guid? parentGuid = null;
                    string parentId = this.HiddenNodeId.Text.Trim();
                    if (!string.IsNullOrEmpty(parentId))
                        parentGuid = new Guid(parentId);      //上级ID

                    th.Id = DMS.Common.DMSUtility.GetGuid();  //主键

                    th.Code = this.txtCode.Text; //区域编码
                    th.Name = this.txtName.Text; //区域名称
                    th.Level = this.cbLevel.SelectedItem.Value; //区域等级
                    th.Description = this.txtDescription.Text; //区域描述
                    string ProductLine = "";
                    if (this.HiddenLevel.Text.Trim() == "BU") //如果是BU从下拉框取值,否则从隐藏框取值
                    {
                        ProductLine = this.cbProductLine.SelectedItem.Value;
                    }
                    else
                    {
                        ProductLine = this.HiddenProductLineId.Text;
                    }
                    th.BumId = new Guid(ProductLine); //产品线
                    th.ParentId = parentGuid; //上级区域ID
                    business.InsertTerritoryHierarchy(th);
                    HiddenNewAddId.Text = th.Id.ToString(); //把新生成的ID赋给隐藏框,以便更新左边的树
                }
                catch (Exception ex)
                {
                    throw ex;
                }
            }
            return result;
        }

        [AjaxMethod]
        public void SetProductLine()
        {
            string level = this.HiddenLevel.Text;
            string Id = this.HiddenNodeId.Text;

            if (this.HiddenIsPageNew.Text == "0") //新增
            {
                if (level == "BU")
                {
                    this.cbProductLine.Hidden = false;
                    this.txtProductLine.Hidden = true;
                }
                else
                {
                    //下拉框隐藏 文本框显示
                    this.cbProductLine.Hidden = true;
                    this.txtProductLine.Hidden = false;
                    DataSet ds = business.GetProductLineByParentId(Id);
                    if (ds.Tables[0].Rows.Count > 0)
                    {
                        this.txtProductLine.Text = ds.Tables[0].Rows[0]["ATTRIBUTE_NAME"].ToString();
                        HiddenProductLineId.Text = ds.Tables[0].Rows[0]["Id"].ToString();
                    }
                    this.txtProductLine.Disabled = true;
                }
            }
            else  //修改
            {
                this.cbProductLine.Hidden = true;
                this.txtProductLine.Hidden = false;

            }

        }
    
   
        #endregion

        #region 页面私有方法
        private void SetLevel()
        {
            string level = business.GetLevel(this.HiddenNodeId.Text, 1);
            this.cbLevel.SelectedItem.Value = level; //得到下一层级 给区域层级赋值    
            this.cbLevel.Disabled = true;
            this.HiddenLevel.Text = business.GetLevel(this.HiddenNodeId.Text, 0); //得到当前层级赋给隐藏框
        }

        /// <summary>
        /// 清除页面控件状态
        /// </summary>
        private void ClearFormValue()
        {
            this.txtCode.Text = "";
            this.txtName.Text = "";
            this.txtDescription.Text = "";
            this.cbLevel.Items.Clear();
            this.cbProductLine.Items.Clear();
            this.txtProductLine.Text = "";

            HiddenProductLineId.Text = "";
            HiddenNodeId.Text = "";
            HiddenNodeParentId.Text = "";
            HiddenLevel.Text = "";
            HiddenIsPageNew.Text = "";
        }

        #endregion

      

        
      
    }
}