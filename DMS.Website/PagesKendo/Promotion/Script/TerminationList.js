var TerminationList = {};

TerminationList = function () {
    var that = {};
    var LstPolicyTypeDesc = [];
    var policyMode = '';
    var templateId = '';

    that.GetModel = function (method) {
        var model = $.getModel();
        model.Method = method;

        return model;
    }

    that.InitPage = function () {
        /*data的值
        
        Method:"InitPage"
        QryPolicyName: null
        QryPolicyNo:null
        QryPolicyStatus:null
        QryProductLine:null
        QryPromotionType:null
        QryTimeStatus:null
        QryYear:null

        */
        var data = that.GetModel('InitPage');

        submitAjax(Common.AppVirtualPath + "PagesKendo/Promotion/Handler/TerminationHanler.ashx", data, function (model) {
            $('#IptUserId').val(model.IptUserId)
            //促销编号
            $('#QryPromotionNo').FrameTextBox({});
           
            //状态
            $('#QryStatus').FrameDropdownList({
                dataSource: [{ Key: '审批中', Value: '审批中' }, { Key: '审批拒绝', Value: '审批拒绝' }, { Key: '审批通过', Value: '审批通过' }, { Key: '草稿', Value: '草稿' }],
                dataKey: 'Key',
                dataValue: 'Value',
                selectType: 'all'
            });
            //申请编号
            $('#QryTermainationNo').FrameTextBox({});
            //促销类型
            $('#QryPromotionType').FrameDropdownList({
                dataSource: [{ Key: '赠品', Value: '赠品类（按时间段结算）' }, { Key: '积分', Value: '积分类（按时间段结算）' }, { Key: '即买即赠', Value: '即买即赠（按单张订单计算）' }],
                dataKey: 'Key',
                dataValue: 'Value',
                selectType: 'all'
            });
            $('#QryZZ').FrameDropdownList({
                dataSource: [{ Key: '政策撤销', Value: '政策撤销' }, { Key: '提前终止', Value: '提前终止' }],
                dataKey: 'Key',
                dataValue: 'Value',
                selectType: 'all'
            });
            $('#QryCP').FrameDropdownList({
                dataSource: model.ProductLineList,
                dataKey: 'Id',
                dataValue: 'Name',
                selectType: 'all'
            });

            createPolicyList(model);

           

            $('#BtnQuery').FrameButton({
                onClick: function () {
                    that.Query();
                }
            });
            //新增促销政策
            $('#BtnNew').FrameButton({
                onClick: function () {
                    $('.in').removeClass('in');
                    $(".ClassItem").removeClass('SelectItem');
                    //window.location.replace = "PolicyList.aspx";
                    openWindow({
                        target: 'top',
                        title: '新增终止',
                        url: Common.AppVirtualPath + 'PagesKendo/Promotion/TerminationCreate.aspx',
                        width: 1000,
                        height: 450,
                        maxed: false,

                        callback: function () {
                            that.Query();
                        }
                        
                    });
                }
            });
           
            $(window).resize(function () {
                setLayout();
            })
            setLayout();

            hideLoading();
        });
    }

    that.Query = function () {
        var data = this.GetModel('Query');

        showLoading();
        submitAjax(Common.AppVirtualPath + "PagesKendo/Promotion/Handler/TerminationHanler.ashx", data, function (model) {
            $("#RstTemainationList").data("kendoGrid").setOptions({
                dataSource: model.RstTemainationList
            });

            hideLoading();
        });
    }

   


    that.ChangeProductLine = function () {
        var data = that.GetModel('ChangeProductLine');

        showLoading();
        submitAjax(Common.AppVirtualPath + "PagesKendo/Promotion/Handler/PolicyListHanler.ashx", data, function (model) {
            templateId = '';
            $('#IptTemplateDesc').html('');

            $('#RstTemplateList').empty();

            $.each(model.RstTemplateList, function (i, n) {
                var e = document.createElement("li");
                e.style.cssText = 'list-style: none;';
                e.className = 'ClassTemplateItem';
                e.textContent = n.PolicyName;
                e.dataset.policyId = n.PolicyId;
                e.dataset.description = n.Description;

                $('#RstTemplateList').append(e);
            });

            $(".ClassTemplateItem").on('click', function () {
                $(".ClassTemplateItem").removeClass('SelectItem');
                $(this).addClass('SelectItem');

                templateId = $(this).data('policyId');
                $('#IptTemplateDesc').html($.replaceAll($(this).data('description'), '\n', '<br />'));
            });

            hideLoading();
        });
    }

    var createPolicyList = function (model) {
        $("#RstTemainationList").kendoGrid({
            dataSource: model.RstTemainationList,
            sortable: true,
            resizable: true,
            scrollable: true,
            columns: [
                {
                    field: "TermainationNo", title: "申请编号", width: '140px',
                    headerAttributes: { "class": "center bold", "title": "申请编号" }
                },
                {
                    field: "PolicyNo", title: "促销编号", width: '150px',
                    headerAttributes: { "class": "center bold", "title": "促销编号" }
                },
                {
                    field: "PolicyName", title: "促销名称",
                    headerAttributes: { "class": "center bold", "title": "促销名称" }
                },
                {
                    field: "ProductLineName", title: "产品线", width: '100px',
                    headerAttributes: { "class": "center bold", "title": "产品线" }
                },
                {
                    field: "PolicyStyle", title: "促销类型", width: '100px',
                    headerAttributes: { "class": "center bold", "title": "促销类型" }
                },
                {
                    field: "TemainationType", title: "终止类型", width: '100px',
                    headerAttributes: { "class": "center bold", "title": "终止类型" }
                },
                {
                    field: "StartDate", title: "开始时间", width: '100px',
                    headerAttributes: { "class": "center bold", "title": "开始时间" }
                },
                {
                    field: "EndDate", title: "结束时间", width: '100px',
                    headerAttributes: { "class": "center bold", "title": "结束时间" }
                },
                {
                    field: "Status", title: "状态", width: '80px',
                    headerAttributes: { "class": "center bold", "title": "状态" }
                },
                {
                    title: "编辑", width: "50px",
                    headerAttributes: {
                        "class": "center bold"
                    },
                    template: "#if ($('\\#IptUserId').val() != '') {#<i class='fa fa-edit' style='font-size: 14px; cursor: pointer;' name='edit'></i>#}#",
                    attributes: {
                        "class": "center"
                    }
                }
            ],
            pageable: {
                refresh: false,
                pageSizes: false,
                pageSize: 20,
                input: true,
                numeric: false
            },
            dataBound: function (e) {
                var grid = e.sender;
                $("#RstTemainationList").find("i[name='edit']").bind('click', function (e) {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);
                    if (data.Status == "草稿") {
                        OpenPolicy(data.id, '修改','Edite');
                    }
                    else {
                        OpenPolicy(data.id, '查看','View');
                    }
                    //else {
                    //    showAlert({
                    //        target: 'top',
                    //        alertType: 'warning',
                    //        message: '已提交申请不可修改'
                    //    });
                    //}
                   
                });
            }
        });
    }

    var OpenPolicy = function (id,title,Type) {
        openWindow({
            target: 'top',
            title: title,
            url: Common.AppVirtualPath + 'PagesKendo/Promotion/TerminationCreate.aspx?TermainationId=' + id + '&&Type='+Type+'',
            width: 1000,
            height: 450,
            maxed: false,
            callback: function () {
                that.Query();
            }
        });
    }

    var OpenPolicyTemplateInit = function (templateId, pageType, title, showPreview) {
        openWindow({
            target: 'top',
            title: title,
            url: Common.AppVirtualPath + 'PagesKendo/Promotion/PolicyTemplateInit.aspx?TemplateId=' + templateId + '&PageType=' + pageType + '&ShowPreview=' + escape(showPreview),
            width: 1300,
            height: 600,
            maxed: true,
            callback: function () {
                that.Query();
            }
        });
    }

    var OpenPolicyTemplate = function (policyId, pageType, title, showPreview) {
        openWindow({
            target: 'top',
            title: title,
            url: Common.AppVirtualPath + 'PagesKendo/Promotion/PolicyTemplate.aspx?PolicyId=' + policyId + '&PageType=' + pageType + '&ShowPreview=' + escape(showPreview),
            width: 1300,
            height: 600,
            maxed: true,
            callback: function () {
                that.Query();
            }
        });
    }

    var setLayout = function () {
        var h = $('.content-main').height();

        $("#RstTemainationList").data("kendoGrid").setOptions({
            height: h - 220
        });
    }

    return that;
}();
