
var HomePage = {};
HomePage = function () {
    var that = {};
    that.InitPage = function () {
        var menuData = [

            { MenuId: "M_10", text: "平台和一级经销商", ParentMenu: "", type: "0", Url: "PagesKendo/ContractElectronic/LPTOne/HomeQuery.aspx" },
            { MenuId: "M_20", text: "二级经销商", ParentMenu: "", type: "0", Url: "PagesKendo/ContractElectronic/TTwo/T2Query.aspx" },
             { MenuId: "M_21", text: "电子签章", ParentMenu: "", type: "0", Url: "PagesKendo/ESign/EnterpriseSignList.aspx" },
             { MenuId: "M_22", text: "用户注册", ParentMenu: "", type: "0", Url: "PagesKendo/ESign/EnterpriseUserList.aspx" },
             { MenuId: "M_23", text: "用户制章", ParentMenu: "", type: "0", Url: "PagesKendo/ESign/EnterpriseSealList.aspx" },
             { MenuId: "M_24", text: "企业实名认证", ParentMenu: "", type: "0", Url: "PagesKendo/ESign/EnterpriseAuthList.aspx" },
        ]
       
        createMenu(menuData);

        var tabs = $("#PnlTabs").kendoTabStrip({
            animation: {
                open:
                {
                    duration: 0
                },
                close: {
                    duration: 0
                }
            }
        }).data("kendoTabStrip");

        hideLoading();
    }

    return that;
}();

var createMenu = function (menuData) {
   
    var datasource = createMenuDataSource(menuData, '0');
   
    $("#menu").kendoMenu({
        scrollable: true,
        dataSource: datasource
    });
}
var createMenuDataSource = function (menuData, Parent) {
    var dataSource = new Array();
    $.each(menuData, function (i, n) {
            var cell = createMenuCell(n);
            dataSource.push(cell);    
    });
    return dataSource;
}

var createMenuCell = function (menu) {
    var cell = new Object();
    cell.id = menu.MenuId;
    cell.text = menu.text;
    if ($.trim(menu.Url) == '') {
        cell.url = '';
    } else {
            cell.url = 'javascript:createTab("' + menu.MenuId + '","' + menu.text + '","' + menu.Url + '")';
    }
    cell.cssClass = '';
    cell.encoded = false;

    return cell;
}
var createTab = function (id, title, url, enableClose, refresh) {

    id = id.toUpperCase();
    if (title == null) title = "Overview";
    if (url == null) {
        url = "/Pages/FileNotFound.htm";
    }
    var tabsText = '';
    if (typeof (enableClose) == 'undefined' || enableClose == true) {
        tabsText = "<span style=\"margin-left: 10px;margin-right: 10px;\">" + title + "<span class=\"fa fa-remove\" style=\"padding-left: 10px; z-index: 1111\" onclick='DeleteTabs(this);'></span></span>";
    } else {
        tabsText = "<span style=\"margin-left: 10px;margin-right: 10px;\">" + title + "</span>";
    }

    var tabstrip = $("#PnlTabs").data("kendoTabStrip");

    if ($("#PnlTabs").find("#" + id + "").length > 0) {
        $("#PnlTabs").data("kendoTabStrip").select($("#PnlTabs").find("#" + id + "").parents("div.k-content").index() - 1);
        if (typeof (refresh) != 'undefined' && refresh == true) {
            $('#frame_' + id).attr('src', url);
        }
    } else {
       
        tabstrip.append(
            [{
                text: tabsText,
                content: getMenuPane(id, url),
                encoded: false
            }]
        );

        var i = $("#PnlTabs").find("#" + id + "").parents("div.k-content").index() - 1;

        $("#PnlTabs").data("kendoTabStrip").select("li:last");
    }

}
var createHomeTab = function (id, title,url) {
    id = id.toUpperCase();
    if (title == null) title = "Overview";
    var tabstrip = $("#PnlTabs").kendoTabStrip().data("kendoTabStrip");
    var tabsText  = "<span style=\"margin-left: 10px;margin-right: 10px;\">" + title + "</span>";
        tabstrip.append(
            [{
                text: tabsText,
                content: getMenuPane(id, url),
                encoded: false
            }]
        );
    $("#PnlTabs").data("kendoTabStrip").select("li:first");   
}
var DeleteTabs = function (ImgObj) {
    $("#PnlTabs").data("kendoTabStrip").select($(ImgObj).closest("li").index() - 1);
    $("#PnlTabs").data("kendoTabStrip").remove($(ImgObj).closest("li").index());
}
var getMenuPane = function (id, url) {
    return "<div role=\"tabpane\" class=\"tab-pane\" id=\"" + id + "\" ><iframe id=\"frame_" + id + "\" src=\"" + Common.AppVirtualPath + url + "\" style=\"height:100%;width:100%;border:0;margin:0;padding:0;\" frameborder=\"no\" scrolling=\"no\" allowtransparency=\"yes\"></iframe></div>";
}