using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;

using System.Collections.Specialized;


namespace Lafite.Web
{
    using Lafite.SiteMap;
    using Lafite.SiteMap.Provider;
    /// <summary>
    /// 
    /// </summary>
    public partial class SiteMapSetting : Page
    {
        private const string MenuImage = @"~/resources/images/icons/page.png";
        private const string TaskImage = @"~/resources/images/icons/folder.png";
        private const string RootImage = @"~/resources/images/icons/house.png";
        bool insertChild = false;

        #region ---- Bind Tree     ----

        protected void Page_Load(object sender, EventArgs e)
        {
                if (!IsPostBack)
                {
                    BindSiteTree();
                }

        }

        private void BindSiteMapType(DropDownList dpItemType)
        {
                Hashtable dicts = new Hashtable();
                dicts.Add("Menu", "Menu");
                dicts.Add("Task", "Task");
           
                dpItemType.DataTextField = "Value";
                dpItemType.DataValueField = "Key";
                dpItemType.DataSource = dicts;
                dpItemType.DataBind();
         
        }

        private void BindSiteTree()
        {
            DbSiteProvider provider = new DbSiteProvider();
            SiteNode siteNode = provider.GetSiteNode();

            if (siteNode != null)
            {
                TreeNode treeRoot = new TreeNode();
                treeRoot.Text = siteNode.Title;
                treeRoot.Value = siteNode.ItemId.ToString();
                treeRoot.Expanded = true;
                treeRoot.ImageUrl = RootImage;
                treeRoot.ToolTip = siteNode.ItemType;
                AddSiteTree(treeRoot, siteNode);
                treeRoot.Select();
                
                this.treeView1.Nodes.Clear();

                this.treeView1.Nodes.Add(treeRoot);
            }            
        }

        private void AddSiteTree(TreeNode parent, SiteNode siteNode)
        {

            foreach (SiteNode childNode in siteNode.Nodes)
            {
                TreeNode child = new TreeNode();
                child.Text = childNode.Title;
                child.Value = childNode.ItemId.ToString();
                child.ToolTip = childNode.ItemType;

                if(childNode.ItemType == "Menu")
                    child.ImageUrl = MenuImage;
                else 
                    child.ImageUrl = TaskImage;
                
                parent.ChildNodes.Add(child);


                
                AddSiteTree(child, childNode);
            }
        }

        protected void treeView_SelectedNodeChanged(object sender, EventArgs e)
        {
            //LafiteSiteProvider.DbSiteProvider provider = new LafiteSiteProvider.DbSiteProvider();
            //string selectNode = treeView1.SelectedValue;

            //LafiteSite.SiteItem item =  provider.GetSiteItem(Convert.ToInt32(selectNode));
            //this.detailsView1.DataSource = item;
            //this.detailsView1.DataBind();

            this.detailsView1.ChangeMode(DetailsViewMode.ReadOnly);

            this.SiteDataSource1.DataBind();

        }

#endregion

        #region Detail view
        protected void DetailsView_ModeChanging(object sender, DetailsViewModeEventArgs e)
        {
            if (e.NewMode == DetailsViewMode.Insert)
            {
                TreeNode newNode = new TreeNode("NewNode", string.Empty);
                //newNode.PopulateOnDemand = true;
                if (this.treeView1.SelectedNode != null)
                {
                    if (this.insertChild)
                    {
                        this.treeView1.SelectedNode.ChildNodes.Add(newNode);
                    }
                    else if (this.treeView1.SelectedNode.Parent != null)
                    {
                        this.treeView1.SelectedNode.Parent.ChildNodes.Add(newNode);
                    }
                    else
                    {
                        this.treeView1.Nodes.Add(newNode);
                    }
                }
                else
                {
                    this.treeView1.Nodes.Add(newNode);
                }
                newNode.Selected = true;
                //
                this.treeView1.Target = newNode.ValuePath;

               
            }
            else if (this.treeView1.SelectedNode != null && this.treeView1.SelectedNode.Value == string.Empty)
            {
                this.DeleteSelectedNode();
            }
        }

        protected void DetailsView_ItemInserting(object sender, DetailsViewInsertEventArgs e)
        {
            this.InsertingNode(sender, e.Values);
        }

        protected void DetailsView_ItemInserted(object sender, DetailsViewInsertedEventArgs e)
        {
             this.treeView1.SelectedNode.Text = Convert.ToString(e.Values["Title"]);

             string itemType = Convert.ToString(e.Values["ItemType"]);

             this.treeView1.SelectedNode.ToolTip = itemType;

             if (itemType == "Menu")
                 this.treeView1.SelectedNode.ImageUrl = MenuImage;
             else           
                 this.treeView1.SelectedNode.ImageUrl = TaskImage;
          
           
        }
        
        protected void DetailsView_ItemUpdating(object sender, DetailsViewUpdateEventArgs e)
        {
            this.UpdatingNode(sender, e.NewValues);
        }

        protected void DetailsView_ItemUpdated(object sender, DetailsViewUpdatedEventArgs e)
        {
            string itemType = Convert.ToString(e.NewValues["ItemType"]);
           this.treeView1.SelectedNode.ToolTip = itemType;
           this.treeView1.SelectedNode.Text = e.NewValues["Title"].ToString();

           if (itemType == "Menu")
               this.treeView1.SelectedNode.ImageUrl = MenuImage;
           else
               this.treeView1.SelectedNode.ImageUrl = TaskImage;
        }

        protected void DetailsView_ItemDeleted(object sender, DetailsViewDeletedEventArgs e)
        {
           
            this.DeleteSelectedNode();
           
        }

         protected void btnNewChildButton_Click(object sender, EventArgs e)
        {
            insertChild = true;
            if (this.treeView1.SelectedNode != null)
            {
                this.treeView1.SelectedNode.Expand();
            }
            this.detailsView1.ChangeMode(DetailsViewMode.Insert);
            DetailsView_ModeChanging(sender, new DetailsViewModeEventArgs(DetailsViewMode.Insert, false));
        }

        private void UpdatingNode(object sender , IOrderedDictionary values)
        {
            if (this.treeView1.SelectedNode != null && this.treeView1.SelectedNode.Parent != null)
            {
                TreeNode selNode = this.treeView1.SelectedNode;
                
                values["ItemId"] = selNode.Value;
                //values["OrderBy"] = selNode.Parent.ChildNodes.IndexOf(selNode);

                SetNodeType(sender, values);
            }
        }


        private void InsertingNode(object sender, IOrderedDictionary values)
        {
            if (this.treeView1.SelectedNode != null && this.treeView1.SelectedNode.Parent != null)
            {
                TreeNode selNode = this.treeView1.SelectedNode;

                values["ParentId"] = selNode.Parent.Value;
                values["Level"] = selNode.Depth;

                if(values["OrderBy"] == null)
                    values["OrderBy"] = selNode.Parent.ChildNodes.IndexOf(selNode);

                SetNodeType(sender, values);
            }
        }

        private void SetNodeType(object sender, IOrderedDictionary values)
        {
            if (sender is DetailsView)
            {
                DetailsView detailsView = sender as DetailsView;
                DropDownList dpItemType = (DropDownList)detailsView.FindControl("dpItemType");

                if (dpItemType != null)
                {
                    values["ItemType"] = dpItemType.SelectedValue;
                }               
            }
        }

        /// <summary>
        /// 删除当前选择的节点
        /// </summary>
        private void DeleteSelectedNode()
        {
            TreeNode deletedNode = this.treeView1.SelectedNode;
              
            if (deletedNode != null)
            {
                TreeNodeCollection nodes = this.SelectAnotherNode(deletedNode);
                nodes.Remove(deletedNode);
            }
        }
        
        /// <summary>
        /// 删除节点时, 转移当前选择节点
        /// </summary>
        /// <param name="deletedNode"></param>
        /// <returns></returns>
        private TreeNodeCollection SelectAnotherNode(TreeNode deletedNode)
        {
            TreeNodeCollection nodes = deletedNode.Parent != null ? deletedNode.Parent.ChildNodes : this.treeView1.Nodes;
            int index = nodes.IndexOf(deletedNode);
            if (index < nodes.Count - 1)
            {
                nodes[index + 1].Select();
            }
            else if (index != 0)
            {
                nodes[index - 1].Select();
            }
            else if (deletedNode.Parent != null)
            {
                deletedNode.Parent.Select();
            }
            //
            
            return nodes;
        }        
        

        protected void detailsView1_ItemCreated(object sender, EventArgs e)
        {

            if (sender is DetailsView)
            {
                DetailsView detailsView = (DetailsView)sender;
                if (detailsView.CurrentMode == DetailsViewMode.Edit || detailsView.CurrentMode == DetailsViewMode.Insert)
                {
                    DropDownList dpItemType = (DropDownList)detailsView.FindControl("dpItemType");

                    if(dpItemType !=null)
                        BindSiteMapType(dpItemType);


                    if (detailsView.CurrentMode == DetailsViewMode.Edit)
                    {
                        if ((this.treeView1.SelectedNode != null) && (dpItemType != null))
                        {
                            if (this.treeView1.SelectedNode.ToolTip != null)
                                dpItemType.SelectedValue = this.treeView1.SelectedNode.ToolTip;
                        }
                    }
                    else
                    {
                        CheckBox checkbox = (CheckBox)detailsView.FindControl("ckIsEnabled");
                        checkbox.Checked = true;

                        if (dpItemType != null)
                            if ((this.treeView1.SelectedNode != null) && (this.treeView1.SelectedNode.Parent != null))
                                 dpItemType.SelectedValue = this.treeView1.SelectedNode.Parent.ImageUrl == MenuImage ? "Menu" : "Task";
                    }
                }
            }
            
        }
        #endregion
        protected void SiteDataSource1_Inserting(object sender, ObjectDataSourceMethodEventArgs e)
        {
            e.InputParameters.Remove("ItemId");
            e.InputParameters.Remove("LastUpdate");
            e.InputParameters.Remove("LastUpdateDate");
        }
        protected void SiteDataSource1_Inserted(object sender, ObjectDataSourceStatusEventArgs e)
        {
            this.treeView1.SelectedNode.Value = Convert.ToString(e.ReturnValue);
        }
        protected void SiteDataSource1_Updating(object sender, ObjectDataSourceMethodEventArgs e)
        {
            e.InputParameters.Remove("ParentId");
            e.InputParameters.Remove("Level");
            e.InputParameters.Remove("LastUpdate");
            e.InputParameters.Remove("LastUpdateDate");
        }

        protected void btnExport_Click(object sender, EventArgs e)
        {
            DbSiteProvider dbprovider = new DbSiteProvider();
            Lafite.SiteMap.SiteNode sitemap = dbprovider.GetSiteNode();

            string filename = "menuConfig.xml";
            Response.ClearContent();
            Response.AddHeader("content-disposition", "attachment; filename=" + filename);
            Response.ContentType = "text/xml";
            Response.ContentEncoding = System.Text.Encoding.UTF8;
            Response.Charset = "utf-8";

            System.IO.StringWriter writer = new System.IO.StringWriter();

            XmlSiteProvider xmlprovider = new XmlSiteProvider();
            xmlprovider.Save(sitemap, writer);

            string xml = writer.ToString();

            xml = xml.Replace("utf-16", "utf-8");

            System.Web.HttpContext.Current.Response.Write(xml);
            System.Web.HttpContext.Current.Response.End();

        }
        protected void SiteDataSource1_Deleting(object sender, ObjectDataSourceMethodEventArgs e)
        {
            
        }
        protected void detailsView1_ItemDeleting(object sender, DetailsViewDeleteEventArgs e)
        {
            TreeNode deletedNode = this.treeView1.SelectedNode;

            if (deletedNode != null && deletedNode.ChildNodes.Count > 0)
            {
                e.Cancel = true;
                string msg = "有子节点,不能删除!";
                string msgFormat = @"<script>javascript:alert('有子节点,不能删除!');</script>";
                Response.Write(string.Format(msgFormat, msg));                
            }
            
        }
}
}