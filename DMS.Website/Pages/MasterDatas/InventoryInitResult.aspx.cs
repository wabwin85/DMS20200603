using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DMS.Business;

namespace DMS.Website.Pages.MasterDatas
{
    public partial class InventoryInitResult : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindGrid(1, AspNetPager1.PageSize);
            }
        }

        #region 事件
        protected void gvDetail_RowCommand(object sender, GridViewCommandEventArgs e)
        {

        }

        protected void gvDetail_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gvDetail.EditIndex = e.NewEditIndex;
            BindGrid(AspNetPager1.CurrentPageIndex, AspNetPager1.PageSize);
        }

        protected void gvDetail_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gvDetail.EditIndex = -1;
            BindGrid(AspNetPager1.CurrentPageIndex, AspNetPager1.PageSize);
        }

        protected void gvDetail_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {

        }

        protected void gvDetail_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {

        }

        protected void gvDetail_RowUpdated(object sender, GridViewUpdatedEventArgs e)
        {
            BindGrid(AspNetPager1.CurrentPageIndex, AspNetPager1.PageSize);
        }

        protected void gvDetail_RowDeleted(object sender, GridViewDeletedEventArgs e)
        {
            BindGrid(AspNetPager1.CurrentPageIndex, AspNetPager1.PageSize);
        }

        protected void AspNetPager1_PageChanged(object src, EventArgs e)
        {
            BindGrid(AspNetPager1.CurrentPageIndex, AspNetPager1.PageSize);
        }

        #endregion

        #region 数据绑定

        private void BindGrid(int currentPage, int pageSize)
        {
            IInventoryInitBLL business = new InventoryInitBLL();

            int totalCount = 0;

            gvDetail.DataSource = business.QueryErrorData((currentPage - 1) * this.AspNetPager1.PageSize, this.AspNetPager1.PageSize, out totalCount);
            gvDetail.DataBind();
            AspNetPager1.RecordCount = totalCount;
        }

        #endregion
    }
}
