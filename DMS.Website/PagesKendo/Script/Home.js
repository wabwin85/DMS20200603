$(document).ready(function () {
    console.log(window.location.search.substr(1));
    doInitPage();
});

var RstMenuList;

var getModel = function () {
    var model = new Object();

    return model;
}

var doInitPage = function () {
    var data = getModel();
    data.Method = 'InitPage';

    showLoading();
    submitAjax(Common.AppVirtualPath + "PagesKendo/Handler/HomeHanler.ashx", data, function (model) {
        $('#IptUserName').FrameLabel({
            value: model.IptUserName
        });
        InitSubCompany(model);
        RstMenuList = model.RstMenuList;
        createMenu();

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

        //createTab('M_Home', '首页', model.IptHomeUrl, false);

        var powerkey = $.getUrlParam('PowerKey');
        clickByPowerkey(powerkey);

        window.name = 'window1';

        hideLoading();
    });
}

var createMenuDataSource = function (Parent) {
    var datasource = new Array();
    $.each(RstMenuList, function (i, n) {
        if (n.ParentMenu == Parent) {
            var cell = createMenuCell(n);

            if (n.IsLeaf == false) {
                cell.items = createMenuDataSource(n.MenuId);
            }

            datasource.push(cell);
        }
    });
    return datasource;
}

var createMenuCell = function (menu) {
    var cell = new Object();
    cell.id = menu.MenuId;
    //if ($.trim(menu.MenuIcon) == '') {
    //    cell.text = '<span class=\'fa fa-fw fa-empty\'></span>&nbsp;' + menu.MenuName;
    //} else {
    //    cell.text = '<span class=\'fa fa-fw fa-' + menu.MenuIcon + '\'></span>&nbsp;' + menu.MenuName;
    //}
    cell.text = menu.MenuName;
    if ($.trim(menu.MenuUrl) == '') {
        cell.url = '';
    } else {
        cell.url = 'javascript:createTab("' + menu.MenuId + '","' + menu.MenuName + '","' + menu.MenuUrl + '")';
    }
    cell.cssClass = '';
    cell.encoded = false;
    cell.attr = {};
    cell.attr.powerkey = menu.PowerKey;

    return cell;
}

var createMenu = function () {
    var datasource = createMenuDataSource('0');

    $("#RstMenuList").kendoMenu({
        scrollable: true,
        dataSource: datasource
    });
}

var getMenuPane = function (id, url) {
    return "<div role=\"tabpane\" class=\"tab-pane\" id=\"" + id + "\" ><iframe id=\"frame_" + id + "\" src=\"" + Common.AppVirtualPath + url + "\" style=\"height:100%;width:100%;border:0;margin:0;padding:0;\" frameborder=\"no\" scrolling=\"no\" allowtransparency=\"yes\"></iframe></div>";
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

    $("#RstMenuList").data("kendoMenu").close();
}

var DeleteTabs = function (ImgObj) {
    $("#PnlTabs").data("kendoTabStrip").select($(ImgObj).closest("li").index() - 1);
    $("#PnlTabs").data("kendoTabStrip").remove($(ImgObj).closest("li").index());
}

var DeleteTabsContext = function (id) {
    if ($("#PnlTabs").find("#" + id + "").length > 0) {
        var index = $("#PnlTabs").find("#" + id + "").parents("div.k-content").index();
        $("#PnlTabs").data("kendoTabStrip").remove(index - 1);
        $("#PnlTabs").data("kendoTabStrip").select(index - 2);
    }
}

var clickByPowerkey = function (powerkey) {
    $.each(RstMenuList, function (i, n) {
        if (n.PowerKey == powerkey) {
            console.log(n);
            createTab(n.MenuId.toString(), n.MenuName, n.MenuUrl);
        }
    });
}

var InitSubCompany = function (model) {

    $('#IptSubCompanyId').val(model.IptSubCompanyId);
    $('#IptSubCompanyName').html(model.IptSubCompanyName);
    $("#LstSubCompanyList").html("");

    if (null != model.LstSubCompany && model.LstSubCompany.length >= 1) {
        $.each(model.LstSubCompany, function(i, n) {
            var span = document.createElement("span");
            span.className = 'pull-left';
            span.innerHTML = n.ATTRIBUTE_NAME;

            var div = document.createElement("div");
            div.className = 'clearfix';
            $(div).append(span);

            var a = document.createElement("a");
            a.href = '#';
            $(a).on('click', function() {
                changeSubCompany(n);
            });
            $(a).append(div);

            var li = document.createElement("li");
            $(li).append(a);

            $('#LstSubCompanyList').append(li);
        });
    } else {
        $('#PnlSubCompany').remove();
    }
    InitBrand(model);
};
var InitBrand = function (model) {
    $('#IptBrandId').val(model.IptBrandId);
    $('#IptBrandName').html(model.IptBrandName);
    $("#LstBrandList").html("");
    if (null != model.LstBrand && model.LstBrand.length >= 1) {
        $.each(model.LstBrand, function(i, n) {
            var span = document.createElement("span");
            span.className = 'pull-left';
            span.innerHTML = n.ATTRIBUTE_NAME;

            var div = document.createElement("div");
            div.className = 'clearfix';
            $(div).append(span);

            var a = document.createElement("a");
            a.href = '#';
            $(a).on('click', function() {
                changeBrand(n);
            });
            $(a).append(div);

            var li = document.createElement("li");
            $(li).append(a);

            $('#LstBrandList').append(li);
        });
    } else {
        $('#PnlBrand').remove();
    }
    hideLoading();
};
var changeSubCompany = function (subCompany) {
    if (subCompany.Id != $('#IptSubCompanyId').val()) {
        var data = {};
        data.IptSubCompanyId = subCompany.Id;
        data.IptSubCompanyName = subCompany.ATTRIBUTE_NAME;
        data.Method = 'ChangeSubCompany';

        showLoading();
        submitAjax(Common.AppVirtualPath + "PagesKendo/Handler/HomeHanler.ashx", data, function (model) {
            window.location.reload();
        });
    }
};

var changeBrand = function (brand) {
    if (brand.Id != $('#IptBrandId').val()) {
        var data = {};
        data.IptBrandId = brand.Id;
        data.IptBrandName = brand.ATTRIBUTE_NAME;
        data.Method = 'ChangeBrand';

        showLoading();
        submitAjax(Common.AppVirtualPath + "PagesKendo/Handler/HomeHanler.ashx", data, function (model) {
            window.location.reload();
        });

    }
};