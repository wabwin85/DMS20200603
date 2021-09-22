var OBORESignList = {};

OBORESignList = function () {
    var that = {};

    var business = 'OBORESign.OBORESignList';

    that.GetModel = function () {
        var model = FrameUtil.GetModel();

        return model;
    }

    that.Init = function () {
        var data = {};
        createResultList();

        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {

                $('#QryAgreementNo').FrameTextBox({

                    value: model.QryAgreementNo
                });

                $('#QryProductLineID').FrameDropdownList({
                    dataSource: model.LstProductLineID,
                    dataKey: 'ProductLineID',
                    dataValue: 'ProductLineName',
                    selectType: 'all',
                    value: model.QryProductLineID,
                    onChange: that.BuChange,
                });
                
                $('#QrySubBu').FrameDropdownList({
                    dataSource: model.LstSubBu,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'select',
                    value: model.QrySubBu,

                });

                $('#QrySignA').FrameDropdownList({
                    dataSource: model.LstSignA,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'all',
                    value: model.QrySignA
                });

                $('#QrySignB').FrameDropdownList({
                    dataSource: model.LstSignB,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'all',
                    filter: 'contains',
                    value: model.QrySignB
                });

                $('#QryStatus').FrameDropdownList({
                    dataSource: model.LstStatus,
                    dataKey: 'DICT_KEY',
                    dataValue: 'VALUE1',
                    selectType: 'all',
                    value: model.QryStatus
                });

                $('#QryAgreementType').FrameDropdownList({
                    dataSource: model.LstAgreementType,
                    dataKey: 'DICT_KEY',
                    dataValue: 'VALUE1',
                    selectType: 'all',
                    value: model.QryAgreementType
                });

               
                $('#QryCreateDate').FrameDatePickerRange({
                    value: model.QryCreateDate
                });


                if (!model.ButtomReadonly) {
                    $('#BtnNew').FrameButton({
                        text: '新增',
                        icon: 'file',
                        onClick: function () {
                            NewopenInfo();
                        }
                    });
                }
               
                

                $('#BtnQuery').FrameButton({
                    text: '查询',
                    icon: 'search',
                    onClick: function () {
                        that.Query();
                    }
                });

                $("#RstResultList").data("kendoGrid").setOptions({
                    dataSource: model.RstResultList
                });

                $(window).resize(function () {
                    setLayout();
                })
                setLayout();

                FrameWindow.HideLoading();
            }
        });
    }


    that.BuChange = function () {

        var data = that.GetModel();
        if (data.QryProductLineID.Key == "") {

            $('#QrySubBu').FrameDropdownList({
                dataSource: [],
                dataKey: 'Key',
                dataValue: 'Value',
                selectType: 'select',


            });
        }
        else {

            FrameUtil.SubmitAjax({
                business: business,
                method: 'BuChange',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {

                    $('#QrySubBu').FrameDropdownList({
                        dataSource: model.LstSubBu,
                        dataKey: 'Key',
                        dataValue: 'Value',
                        selectType: 'select',
                        value: model.QrySubBu,

                    });

                    FrameWindow.HideLoading();
                }
            });
        }
    }

    that.Query = function () {
        var data = FrameUtil.GetModel();
        //console.log(data);

        FrameWindow.ShowLoading();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'Query',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $("#RstResultList").data("kendoGrid").setOptions({
                    dataSource: model.RstResultList
                });

                FrameWindow.HideLoading();
            }
        });
    }

    var createResultList = function () {
        $("#RstResultList").kendoGrid({
            dataSource: [],
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 500,
            columns: [
                {
                    title: "查看", width: "50px",
                    headerAttributes: {
                        "class": "text-center text-bold"
                    },
                    template: "#if ($('\\#CST_NO').val() != '') {#<i class='fa fa-edit' style='font-size: 14px; cursor: pointer;' name='edit'></i>#}#",
                    attributes: {
                        "class": "text-center text-bold"
                    }
                },
                //{
                //    title: "签章", width: "50px",
                //    headerAttributes: {
                //        "class": "text-center text-bold"
                //    },
                //    template: "#if ($('\\#CST_NO').val() != '') {#<i class='fa fa-edit' style='font-size: 14px; cursor: pointer;' name='Sign'></i>#}#",
                //    attributes: {
                //        "class": "text-center text-bold"
                //    }
                //}
                //,
                {
                    field: "AgreementNo", title: "协议编号", width: '140px',
                    headerAttributes: { "class": "text-center text-bold", "title": "协议编号" }
                },
                {
                    field: "SignA", title: "物流平台", width: '200px',
                    headerAttributes: { "class": "text-center text-bold", "title": "物流平台" }
                },
                {
                    field: "SignB", title: "经销商", width: '200px',
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商" }
                },
                {
                    field: "CC_NameCN", title: "Sub-Bu", width: '110px',
                    headerAttributes: { "class": "text-center text-bold", "title": "Sub-Bu" }
                },
                {
                    field: "Status", title: "状态", width: '90px',
                    headerAttributes: { "class": "text-center text-bold", "title": "状态" }
                },
                {
                    field: "CreateDate", title: "申请日期", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "申请日期" }
                },
                {
                    field: "CreateUser", title: "申请人", width: 'auto',
                    headerAttributes: { "class": "text-center text-bold", "title": "申请人" }
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
            },
            dataBound: function (e) {
                var grid = e.sender;

                $("#RstResultList").find("i[name='edit']").bind('click', function (e) {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);

                    openInfo(data.ES_ID, data.AgreementNo);
                });
            }
        });
    }

    var openInfo = function (ID, AgreementNo) {
        

        top.createTab({
            id: 'M_' + AgreementNo,
            title: '合同-' + AgreementNo,
            url: 'Revolution/Pages/OBORESign/OBORESignInfo.aspx?ES_ID=' + ID
        });

    }


    var NewopenInfo = function () {


        var data = {};
        FrameWindow.ShowLoading();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'NewID',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                
                top.createTab({
                    id: 'BOBR_ESign_EContract_OBRSignFilePage',
                    title: '新建申请',
                    url: 'Revolution/Pages/OBORESign/OBORESignInfo.aspx?ES_ID=' + model.NewID
                });
                FrameWindow.HideLoading();
            }
        });

    }


    var setLayout = function () {
    }

    return that;
}();
