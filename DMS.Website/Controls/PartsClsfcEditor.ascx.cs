using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DMS.Website.Controls
{
    using Coolite.Ext.Web;
    using DMS.Model;
    using DMS.Business;
    using DMS.Common;

    [AjaxMethodProxyID(IDMode = AjaxMethodProxyIDMode.Alias, Alias = "PartsClsfcEditor")]
    public partial class PartsClsfcEditor : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        #region Ajax Method
        [AjaxMethod]
        public void PartsInit(string id,string lindID,string parent)
        {
            PartsClassification part = null;
            IProductClassifications bll = new ProductClassifications();

            if(!string.IsNullOrEmpty(id))
                part = bll.GetObject(new Guid(id));
            else
                part = bll.GetObject(new Guid());

            this.txtNodeId.Text = part.Id.HasValue ? part.Id.Value.ToString() : "";
            this.txtNodeName.Text = !string.IsNullOrEmpty(part.Name) ? part.Name : "";
            this.txtNodeEngName.Text = !string.IsNullOrEmpty(part.EnglishName) ? part.EnglishName : "";
            this.txtNodeDesc.Text = !string.IsNullOrEmpty(part.Description) ? part.Description : "";
            this.txtNodeParentId.Text = part.ParentId.HasValue ? part.ParentId.Value.ToString() : "";
            this.txtNodeParent.Text = !string.IsNullOrEmpty(parent) ? parent : "";
            this.txtNodeLineId.Text = !string.IsNullOrEmpty(lindID) ? lindID : "";

            this.PartsDetailsWindow.Show();
        }
        #endregion

        private string SaveNodeData()
        {
            string result = string.Empty;

            PartsClassification part = null;
            IProductClassifications bll = new ProductClassifications();
            Guid? newGuid = null;

            string id = this.txtNodeId.Text.Trim();

            if (id.Length == 36)
            {
                try
                {

                    newGuid = new Guid(id);
                    part = bll.GetObject(newGuid.Value);

                    if (part != null)
                    {
                        part.Name = this.txtNodeName.Text;
                        part.EnglishName = this.txtNodeEngName.Text;
                        part.Description = this.txtNodeDesc.Text;
                        bll.Update(part);

                        result = "ok";
                    }
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
                    Guid? parentGuid = null;
                    string parentId = this.txtNodeParentId.Text.Trim();
                    if (!string.IsNullOrEmpty(parentId))
                        parentGuid = new Guid(parentId);


                    part = new PartsClassification();

                    part.Id = DMS.Common.DMSUtility.GetGuid();
                    part.Name = this.txtNodeName.Text;
                    part.EnglishName = this.txtNodeEngName.Text;
                    part.Description = this.txtNodeDesc.Text;

                    string lineId = this.txtNodeLineId.Text.Trim();
                    if (!string.IsNullOrEmpty(lineId))
                        part.ProductLineId = new Guid(lineId);

                    if (parentGuid != null && parentGuid != part.ProductLineId)
                        part.ParentId = parentGuid;

                    bll.Insert(part);
                    this.txtNodeId.Text = part.Id.Value.ToString();

                }
                catch (Exception ex)
                {
                    throw ex;
                }
            }


            return result;
            
        }

        protected void SaveNode_Click(object sender, AjaxEventArgs e)
        {
            try
            {
                this.SaveNodeData();
                e.Success = true;

                return;
            }
            catch
            {
                e.ErrorMessage =
GetLocalResourceObject("SaveNode_Click.ErrorMessage").ToString();
                e.Success = false;

            }


        }
    }
}