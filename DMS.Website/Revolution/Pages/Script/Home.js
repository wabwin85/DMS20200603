$(document).ready(function () {
    doInitPage();
});

$(function () {
    time = setInterval("showShipmentInitCheck()", 600000);
});
function showShipmentInitCheck() {
    doCheckShipmentInit();
}

var business = 'Home';

var account;

var menuIcon = {
    'M1_PurchaseOrder': 'fa-shopping-cart',
    'M1_POReceipt': 'fa-cubes',
    'M1_Consignment': 'fa-money',
    'M1_InventoryManagement': 'fa-bank',
    'M1_ShipmentManagement': 'fa-truck',
    'M1_DealerProfile': 'fa-area-chart',
    'M1_SampleManage': 'fa-cube',
    'M1_Contract': 'fa-newspaper-o',
    'M1_Promotion_New': 'fa-gift',
    'M1_InformationSearch': 'fa-search',
    'M1_MasterData': 'fa-cogs',
    'M1_Distributor_Report': 'fa-line-chart',
    'M1_BSC_MGM_Report': 'fa-bar-chart',
    'M1_PersonalInfo': 'fa-id-card-o',
    'M1_Consign': 'fa-code-fork'
}
var defaultIcon = 'fa-list';

var subsite = ["M2_Contract", "M2_DealerProfile"];

var kendoWindow = null;

var doInitPage = function () {
    GetModel = function () {
        var model = FrameUtil.GetModel();

        return model;
    }

    $("#PnlTabs").kendoTabStrip({
        animation: {
            open:
            {
                duration: 0
            },
            close: {
                duration: 0
            }
        },
        select: function () {
            setLayout();
        }
    })

    var data = {};

    FrameUtil.SubmitAjax({
        business: business,
        method: 'Init',
        url: Common.AppHandler,
        data: data,
        callback: function (model) {
            $('#BtnUserProfile').on('click', function () {
                createTab({
                    id: 'M_M2_PersonalData',
                    title: '个人信息',
                    url: 'Revolution/Pages/MyInfo.aspx'
                });
            });
            $('#BtnLogout').on('click', function () {
                window.location = Common.AppVirtualPath + "Revolution/Pages/logout.aspx";
            });

            $('#IptUserName').html(model.IptUserName);
            $('#IptUserInfo').html(model.IptUserName);
            $('.panel-username').attr('title', model.IptUserName);

            if (model.IsDealer || (null != model.LstDealerList && model.LstDealerList.length > 1)) {
                $('#IptUserMobile').html(model.IptUserMobile);

                account = model.IptAccount;
                $('#IptDealerName').html(model.IptDealerName);
                $.each(model.LstDealerList, function (i, n) {
                    var span = document.createElement("span");
                    span.className = 'pull-left';
                    span.innerHTML = n.DealerName;

                    var div = document.createElement("div");
                    div.className = 'clearfix';
                    $(div).append(span);

                    var a = document.createElement("a");
                    a.href = '#';
                    $(a).on('click', function () {
                        changeDealer(n);
                    });
                    $(a).append(div);

                    var li = document.createElement("li");
                    $(li).append(a);

                    $('#LstDealerList').append(li);
                });
            } else {
                $('#PnlDealer').remove();
            }
            InitSubCompany(model);

            $('#LstMenuList').empty();
            $.each(model.LstMenuList, function (i, n) {
                var icon = menuIcon[n.PowerKey];
                icon = (typeof (icon) == "undefined" || icon == null || icon == '') ? defaultIcon : icon;

                var html = '<li>';
                html += '<a href="#" class="dropdown-toggle">';
                html += '<i class="fa fa-fw ' + icon + '"></i>';
                html += '<span class="menu-text">' + n.Menu + '</span>';
                html += '<b class="arrow fa fa-angle-down"></b>';
                html += '</a>';
                html += '<ul class="submenu" style="overflow-y: auto;">';
                $.each(n.Pages, function (j, m) {
                    html += '<li>';
                    html += '<a href="#" class="menu-page" data-page-id="' + m.PIDX + '" data-page="' + m.Page + '" data-power-key="' + m.PowerKey + '" data-resource-key="' + m.ResourceKey + '" data-url="' + m.PageUrl + '">';
                    html += '<i class="fa fa-angle-double-right"></i>';
                    html += m.Page;
                    html += '</a>';
                    html += '</li>';
                });
                html += '</ul>';
                html += '</li>';

                $('#LstMenuList').append(html);
            });

            $('.menu-page').on('click', function () {
                var url = $(this).data('url');
                if ($.inArray($(this).data('powerKey'), subsite) >= 0) {
                    window.open(Common.AppVirtualPath + url);
                } else if ($(this).data('resourceKey') == 'KendoSite') {
                    if (kendoWindow == null || kendoWindow.closed) {
                        kendoWindow = window.open(Common.AppVirtualPath + url, 'window1');
                    } else {
                        kendoWindow.clickByPowerkey(Common.GetStringParam(url.substr(url.indexOf('?') + 1), 'PowerKey'));
                        kendoWindow.focus();
                    }
                } else {
                    createTab({
                        id: 'M_' + $(this).data('powerKey'),
                        title: $(this).data('page'),
                        url: url
                    });
                }
            })

            $('#sidebar-collapse').on('click', function () {
                sidebarCollapse();
            });

            if (model.IsDealer) {
                createTab({
                    id: 'M_Home',
                    title: '首页',
                    url: 'Revolution/Pages/Dashboard/DealerPage.aspx',
                    enableClose: false
                });
            } else {
                createTab({
                    id: 'M_Home',
                    title: '首页',
                    url: 'Revolution/Pages/Dashboard/AdminPage.aspx',
                    enableClose: false
                });
            }

            if (model.IsAdmin) {
                $('#BtnAdmin').on('click', function () {
                    window.open(Common.AppVirtualPath + 'admin');
                });
            } else {
                $('#BtnAdmin').remove();
            }

            /*if (!model.IsWechat) {
                FrameWindow.ShowAlert({
                    target: 'top',
                    alertType: 'warning',
                    message: '您没有维护微信用户信息，无法绑定蓝威服务入微微信平台，请尽快维护。服务入微功能简述：采购达成查询、渠道二维码上报、授权书二维码查询等',
                    callback: function () {
                        var url = Common.AppVirtualPath + 'Pages/WeChat/WeChatUserList.aspx?pt=1';
                        window.location = url;
                    }
                });
            }*/

            if (!model.IsDisclosure) {
                FrameWindow.ShowAlert({
                    target: 'top',
                    alertType: 'warning',
                    message: '用户您好，请检查是否还有未披露的第三方公司或已披露但未上传所需文件。如有，请立即披露或补传文件。<br />谢谢！'
                });
            }

            if (!model.IsNearEffect) {
                $("#RstNearEffect").kendoGrid({
                    dataSource: model.RstNearEffect,
                    sortable: true,
                    scrollable: true,
                    height: 435,
                    columns: [
                        {
                            field: "Material", title: "产品编号", width: '120px',
                            headerAttributes: { "class": "text-center text-bold", "title": "产品编号" }
                        },
                        {
                            field: "Batch", title: "批号", width: '120px',
                            headerAttributes: { "class": "text-center text-bold", "title": "批号" }
                        },
                        {
                            field: "Quantity", title: "数量", width: '80px',
                            headerAttributes: { "class": "text-center text-bold", "title": "数量" },
                            attributes: { "class": "text-right" }
                        },
                        {
                            field: "ExpirationDate", title: "有效期", width: 'auto',
                            headerAttributes: { "class": "text-center text-bold", "title": "有效期" }
                        },
                        {
                            field: "LeftDays", title: "剩余可用天数", width: '100px',
                            headerAttributes: { "class": "text-center text-bold", "title": "剩余可用天数" },
                            attributes: { "class": "text-right" }
                        },
                        {
                            field: "DiscountRate", title: "折扣率", width: '80px',
                            headerAttributes: { "class": "text-center text-bold", "title": "折扣率" },
                            attributes: { "class": "text-right" }
                        }
                    ],
                    pageable: {
                        refresh: false,
                        pageSizes: false,
                        pageSize: 20,
                        input: true,
                        numeric: false
                    },
                    noRecords: true,
                    messages: {
                        noRecords: "没有符合条件的记录"
                    }
                });

                $('#PnlNearEffect').kendoWindow({
                    width: 700,
                    height: 500,
                    title: "心脏节律管理-近效期折扣产品列表",
                    visible: false,
                    modal: true,
                    resizable: false,
                    actions: [
                        "Close"
                    ],
                    close: function () {
                        model.RstNearEffect = null;
                        $("#RstNearEffect").data("kendoGrid").destroy();
                    }
                });
                $('#PnlNearEffect').data("kendoWindow").center().open();
                $("#RstNearEffect").data("kendoGrid").refresh();

                $('#BtnCloseNearEffect').FrameButton({
                    text: '关闭',
                    icon: 'times',
                    onClick: function () {
                        $('#PnlNearEffect').data("kendoWindow").close();
                    }
                });
            }

            //if (model.IsDealer) {

            //    $('#IptPhone').FrameTextBox({
            //        value: model.IptPhone,
            //    });

            //    $('#IptEmail').FrameTextBox({
            //        value: model.IptEmail,
            //    });
            //    $('#PnlAccount').kendoWindow({
            //        width: 400,
            //        height: 250,
            //        title: "账号维护",
            //        visible: false,
            //        modal: true,
            //        resizable: false,
            //        actions: [
            //            "Close"
            //        ],
            //        close: function () {

            //        }
            //    });
            //    $('#PnlAccount').data("kendoWindow").center().open();
            //    $('#BtnCloseAccount').FrameButton({
            //        text: '关闭',
            //        icon: 'times',
            //        onClick: function () {
            //            $('#PnlAccount').data("kendoWindow").close();
            //        }
            //    });
            //    $('#BtnSave').FrameButton({
            //        text: '保存',
            //        icon: 'save',
            //        onClick: function () {
            //            Save();
            //        }
            //    });
            //}



            $(window).resize(function () {
                setLayout();
            })
            setLayout();

            FrameWindow.HideLoading();
        }
    });
}

var InitSubCompany = function (model) {
    $('#IptSubCompanyId').val(model.IptSubCompanyId);
    $('#IptSubCompanyName').html(model.IptSubCompanyName);
    $("#LstSubCompanyList").html("");
    if (null != model.LstSubCompany && model.LstSubCompany.length >= 1) {
        $.each(model.LstSubCompany, function (i, n) {
            var span = document.createElement("span");
            span.className = 'pull-left';
            span.innerHTML = n.ATTRIBUTE_NAME;

            var div = document.createElement("div");
            div.className = 'clearfix';
            $(div).append(span);

            var a = document.createElement("a");
            a.href = '#';
            $(a).on('click', function () {
                changeSubCompany(n);
            });
            $(a).append(div);

            var li = document.createElement("li");
            $(li).append(a);

            $('#LstSubCompanyList').append(li);
        });
    }
    else {
        $('#PnlSubCompany').remove();
    }

    InitBrand(model);
};

var InitBrand = function (model) {
    $('#IptBrandId').val(model.IptBrandId);
    $('#IptBrandName').html(model.IptBrandName);
    $("#LstBrandList").html("");
    if (null != model.LstBrand && model.LstBrand.length >= 1) {
        $.each(model.LstBrand, function (i, n) {
            var span = document.createElement("span");
            span.className = 'pull-left';
            span.innerHTML = n.ATTRIBUTE_NAME;

            var div = document.createElement("div");
            div.className = 'clearfix';
            $(div).append(span);

            var a = document.createElement("a");
            a.href = '#';
            $(a).on('click', function () {
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
    FrameWindow.HideLoading();
};

var Save = function () {

    var data = GetModel();
    var message = CheckForm(data);
    if (message.length > 0) {
        FrameWindow.ShowAlert({
            target: 'top',
            alertType: 'warning',
            message: message,
        });
    }
    else {
        FrameUtil.SubmitAjax({
            business: business,
            method: 'Save',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $('#BtnCloseAccount').click();
                FrameWindow.HideLoading();
            }
        });
    }

}


var CheckForm = function (data) {
    var message = [];
    var phone = /^1[34578]\d{9}$/;
    var mail = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
    if ($.trim(data.IptPhone) == "") {
        message.push('请填写手机号');
    }
    if ($.trim(data.IptEmail) == "") {
        message.push('请邮箱地址');
    }
    if ($.trim(data.IptPhone) != "") {
        if (data.IptPhone.match(phone) == null) {
            message.push('手机格式不正确');
        }
    }
    if ($.trim(data.IptEmail) != "") {
        if (data.IptEmail.match(mail) == null) {
            message.push('邮箱格式不正确');
        }
    }
    return message;
}

var doCheckShipmentInit = function () {
    var data = {};
    FrameUtil.SubmitAjax({
        business: business,
        method: 'ShipmentInitCheck',
        url: Common.AppHandler,
        data: data,
        callback: function (model) {
            if (!model.IsShipment) {
                FrameWindow.ShowAlert({
                    target: 'top',
                    alertType: 'warning',
                    message: model.IptShipmentMessage,
                    callback: function () {
                        CheckShipment(model.IptShipmentNo);
                    }
                });
            }
        }
    });
}

var CheckShipment = function (ShipmentNo) {
    var data = {};
    data.IptShipmentNo = ShipmentNo;

    FrameUtil.SubmitAjax({
        business: business,
        method: 'CheckShipment',
        url: Common.AppHandler,
        data: data,
        callback: function (model) {
        }
    });
}

var createTab = function (option) {
    var setting = $.extend({}, {
        id: '',
        title: '',
        url: '',
        enableClose: true,
        refresh: false
    }, option);

    setting.id = setting.id.toUpperCase();
    if (setting.title == '') {
        setting.title = "Overview";
    }
    if (setting.url == '') {
        setting.url = "Pages/FileNotFound.htm";
    }
    var tabsText = '';
    var ParentId = '';
    if (setting.refresh)
        ParentId = $("#PnlTabs-" + ($("#PnlTabs").find(".k-state-active").index() + 1)).find('iframe').attr('id');
    if (setting.enableClose) {
        tabsText = "<span>" + setting.title + "<span parentid='" + ParentId + "' class=\"fa fa-remove\" style=\"text-indent: .5em; z-index: 1111; cursor: pointer;\" onclick='deleteTabs(this);'></span></span>";
    } else {
        tabsText = "<span>" + setting.title + "</span>";
    }

    var tabstrip = $("#PnlTabs").data("kendoTabStrip");

    if ($("#PnlTabs").find("#" + setting.id + "").length > 0) {
        $("#PnlTabs").data("kendoTabStrip").select($("#PnlTabs").find("#" + setting.id).parents("div.k-content").index() - 1);
        if (setting.refresh) {
            //$('#frame_' + setting.id).attr('src', setting.url);
        }
    } else {
        tabstrip.append(
            [{
                text: tabsText,
                content: getMenuPane(setting.id, setting.url),
                encoded: false
            }]
        );

        var i = $("#PnlTabs").find("#" + setting.id + "").parents("div.k-content").index() - 1;

        $("#PnlTabs").data("kendoTabStrip").select("li:last");
    }
}

var getMenuPane = function (id, url) {
    return "<div role=\"tabpane\" class=\"tab-pane\" id=\"" + id + "\" ><iframe id=\"frame_" + id + "\" src=\"" + Common.AppVirtualPath + url + "\" style=\"height:100%;width:100%;border:0;margin:0;padding:0;\" frameborder=\"no\" scrolling=\"no\" allowtransparency=\"yes\"></iframe></div>";
}

var deleteTabs = function (ImgObj) {
    var pageIndex = $(ImgObj).attr('parentid');
    if (pageIndex != "" && pageIndex != 'undefined') {
        //判断草稿？,删除草稿，刷新主页列表
        var res = DeleteDraftOrder($("#PnlTabs").find(".k-state-active").attr('aria-controls'));
        if (res)
            refreshMainPage(pageIndex);
        var index = $('#' + pageIndex).parent().parent().index() - 1;
        $("#PnlTabs").data("kendoTabStrip").select(index);
    }
    else
        $("#PnlTabs").data("kendoTabStrip").select($(ImgObj).closest("li").index() - 1);
    $("#PnlTabs").data("kendoTabStrip").remove($(ImgObj).closest("li").index());
}

var deleteTabsCurrent = function () {
    var closeIndex = 0;
    var index = $("#PnlTabs").find(".k-state-active").index();
    var pageIndex = $("#PnlTabs").find(".k-state-active .fa-remove").attr('parentid');
    closeIndex = index;
    if (pageIndex != "" && pageIndex != 'undefined') {
        index = $('#' + pageIndex).parent().parent().index();
        refreshMainPage(pageIndex);
    }
    $("#PnlTabs").data("kendoTabStrip").select(index - 1);
    $("#PnlTabs").data("kendoTabStrip").remove(closeIndex);
    //document.getElementById('frame_M_M2_ORDERAPPLYFORT2').contentWindow.location.reload(true);
}

///删除草稿单据，DeleteDraftOrder
var DeleteDraftOrder = function (Id) {
    var fnName = "";
    var pageUrl = $('#' + Id).find('iframe').attr("src");
    var PageNameStart = pageUrl.lastIndexOf('/');
    var PageNameEnd = pageUrl.indexOf('.');
    if (PageNameStart != -1 && PageNameEnd != -1) {
        fnName = pageUrl.substring(PageNameStart + 1, PageNameEnd);
    }
    if ($('#' + Id).find('iframe')[0].contentWindow[fnName]) {
        if ($('#' + Id).find('iframe')[0].contentWindow[fnName]["DeleteDraftOrder"]) {
            if (fnName != "" && typeof (eval($('#' + Id).find('iframe')[0].contentWindow[fnName].DeleteDraftOrder)) == 'function') {
                $('#' + Id).find('iframe')[0].contentWindow[fnName].DeleteDraftOrder();
                var Ismodify = $('#' + Id).find('iframe')[0].contentWindow.document.getElementById("hiddIsModifyStatus").value;
                if ('true' === Ismodify) return true; else return false;
            }
        }
    }
};
var refreshMainPage = function (pageIndex) {
    var fnName = "";
    var pageUrl = $('#' + pageIndex).attr("src");
    var PageNameStart = pageUrl.lastIndexOf('/');
    var PageNameEnd = pageUrl.indexOf('.');
    if (PageNameStart != -1 && PageNameEnd != -1) {
        fnName = pageUrl.substring(PageNameStart + 1, PageNameEnd);
    }
    if ($('#' + pageIndex)[0].contentWindow[fnName]) {
        if ($('#' + pageIndex)[0].contentWindow[fnName]["Query"]) {
            if (fnName != "" && typeof (eval($('#' + pageIndex)[0].contentWindow[fnName].Query)) == 'function')
                $('#' + pageIndex)[0].contentWindow[fnName].Query();
        }
    }
};

var changeTabsName = function (oldframeId, newId, name) {
    var newFrameId = 'frame_M_' + newId.toUpperCase();
    var oldTabPaneId = oldframeId.substring(6);
    var newTabPaneId = 'M_' + newId.toUpperCase();
    console.log($('#' + oldTabPaneId).parents().attr('id'));
    console.log($('.li[aria-controls=\'' + $('#' + oldTabPaneId).parents().attr('id') + '\']'));
    $('.li[aria-controls=\'' + $('#' + oldTabPaneId).parents().attr('id') + '\']').html("<span>" + name + "<span class=\"fa fa-remove\" style=\"text-indent: .5em; z-index: 1111; cursor: pointer;\" onclick='deleteTabs(this);'></span></span>");
    $('#' + oldframeId).attr("id", newFrameId);
    $('#' + oldTabPaneId).attr("id", newTabPaneId);
    //$('.k-state-active').find('.k-link').html("<span>" + name + "<span class=\"fa fa-remove\" style=\"text-indent: .5em; z-index: 1111; cursor: pointer;\" onclick='deleteTabs(this);'></span></span>");
}

var sidebarCollapse = function () {
    if ($('#sidebar-collapse').find('i').hasClass('fa-angle-double-left')) {
        var hWindow = $(window).height();
        var hNav = $('#PnlNav').outerHeight(true);

        $('#LstMenuList').slimScroll({
            height: (hWindow - hNav - 33) + 'px'
        });
    } else {
        $('#LstMenuList').slimScroll({ destroy: true });
        $('#LstMenuList').css('overflow', '');
        $('#LstMenuList').css('height', '');
    }
}

var setLayout = function () {
    var hWindow = $(window).height();
    var hNav = $('#PnlNav').outerHeight(true);
    var hTabItems = $('.k-tabstrip-items').outerHeight(true);

    $('#PnlTab').height(hWindow - hNav);
    $('#PnlTabs').find('.k-content').height(hWindow - hNav - hTabItems);

    if ($('#sidebar-collapse').find('i').hasClass('fa-angle-double-left')) {
        if ($(window).width() < 768) {
            $('#sidebar-collapse').click();
        } else {
            $('#LstMenuList').slimScroll({
                height: (hWindow - hNav - 33) + 'px'
            });
        }
    }
}

var changeDealer = function (dealer) {
    if (dealer.Account != account) {
        var data = {};
        data.IptAccount = dealer.Account;

        FrameWindow.ShowLoading();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'ChangeDealer',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                window.location.reload();
            }
        });
    }
};

var changeSubCompany = function (subCompany) {
    if (subCompany.Id != $('#IptSubCompanyId').val()) {
        var data = {};
        data.IptSubCompanyId = subCompany.Id;
        data.IptSubCompanyName = subCompany.ATTRIBUTE_NAME;
        FrameWindow.ShowLoading();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'ChangeSubCompany',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                //$('#IptSubCompanyId').val(subCompany.Id);
                //$('#IptSubCompanyName').html(subCompany.ATTRIBUTE_NAME);
                //InitBrand(model, true);
                window.location.reload();
            }
        });
    }
};

var changeBrand = function (brand) {
    if (brand.Id != $('#IptBrandId').val()) {
        var data = {};
        data.IptBrandId = brand.Id;
        data.IptBrandName = brand.ATTRIBUTE_NAME;
        FrameWindow.ShowLoading();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'ChangeBrand',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                //$('#IptBrandId').val(brand.Id);
                //$('#IptBrandName').html(brand.ATTRIBUTE_NAME);
                //FrameWindow.HideLoading();
                window.location.reload();
            }
        });
    }
};