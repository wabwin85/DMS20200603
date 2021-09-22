var UserList = {};

UserList = function () {
    var that = {};

    var business = 'MasterDatas.UserList';
    var deleteHosp = [];

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
                $('#QryLoginId').FrameTextBox({
                    value: model.QryLoginId
                });
                $('#QryFullName').FrameTextBox({
                    value: model.QryFullName
                });
                $('#QryEmail').FrameTextBox({
                    value: model.QryEmail
                });
                $('#BtnQuery').FrameButton({
                    text: '查询',
                    icon: 'search',
                    onClick: function () {
                        that.Query();
                    }
                });

                $('#BtnImport').FrameButton({
                    text: '导入',
                    icon: 'upload',
                    onClick: function () {
                        that.UploadUserInfo();
                    }
                });

                $("#BtnImportUserInfo").FrameButton({
                    text: '导入数据库',
                    onClick: function () {                        
                        that.ImportUserInfo();
                    }
                });
                $("#BtnDownTmpUserInfo").FrameButton({
                    text: '下载模板',
                    onClick: function () {
                        window.open('/Upload/ExcelTemplate/Template_UserInfoImport.xls');
                    }
                });
                $('#fileUserInfo').kendoUpload({
                    async: {
                        saveUrl: "../Handler/UploadFile.ashx?Type=UserInfoInit&SheetName=Sheet1",
                        autoUpload: true
                    },
                    localization: {
                        headerStatusUploading: "上传处理中,请稍等..."
                    },
                    multiple: false,
                    error: function onError(e) {
                        if (e.XMLHttpRequest.responseText != "") {
                            FrameWindow.ShowAlert({
                                target: 'center',
                                alertType: 'info',
                                message: e.XMLHttpRequest.responseText,
                                callback: function () {
                                }
                            });
                        }
                        FrameWindow.HideLoading();
                        var upload = $("#fileUserInfo").data("kendoUpload");
                        upload.enable();
                    },
                    success: function onSuccess(e) {
                        if (e.XMLHttpRequest.responseText != "") {
                            var obj = $.parseJSON(e.XMLHttpRequest.responseText);
                            FrameWindow.ShowAlert({
                                target: 'center',
                                alertType: 'info',
                                message: obj.msg,
                                callback: function () {
                                }
                            });
                            that.QueryUploadUserInfo();
                        }
                        FrameWindow.HideLoading();
                        var upload = $("#fileUserInfo").data("kendoUpload");
                        upload.enable();
                    },
                    upload: function onUpload(e) {
                        var files = e.files;
                        // Check the extension of the file and abort the upload if it is not .xls or .xlsx
                        $.each(files, function () {
                            if (this.extension.toLowerCase() != ".xls" && this.extension.toLowerCase() != ".xlsx") {
                                FrameWindow.ShowAlert({
                                    target: 'center',
                                    alertType: 'info',
                                    message: '只能导入Excel文件！',
                                    callback: function () {
                                        e.preventDefault();
                                        var dataSource = $("#RstUploadUserInfo").data("kendoGrid").dataSource;
                                        dataSource.data([]);
                                        FrameWindow.HideLoading();
                                    }
                                });
                            }
                            else {
                                FrameWindow.ShowLoading();
                                var upload = $("#fileUserInfo").data("kendoUpload");
                                upload.disable();
                            }
                        });
                    }
                });
                //$('#BtnSave').FrameButton({
                //    text: '保存',
                //    icon: 'save',
                //    onClick: function () {
                //        that.SaveChange();
                //    }
                //});                              

                //$("#RstResultList").data("kendoGrid").setOptions({
                //    dataSource: model.RstResultList
                //});

                $(window).resize(function () {
                    setLayout();
                })
                setLayout();

                FrameWindow.HideLoading();
            }
        });
    }

    that.Query = function () {        
        var grid = $("#RstResultList").data("kendoGrid");
        if (grid) {
            grid.dataSource.page(0);
            return;
        }
    }
    var fields = {
        JoinDate: { type: "date", format: "{0: yyyy-MM-dd}" },
        AccountingDate: { type: "date", format: "{0: yyyy-MM-dd}" }
    }
    var kendoDataSource = GetKendoDataSource(business, 'Query', fields, 20);
    var createResultList = function () {
        $("#RstResultList").kendoGrid({
            dataSource: kendoDataSource,
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 500,
            columns: [
                //{
                //    title: "选择", width: 50, encoded: false,
                //    headerTemplate: '<input id="CheckAll" type="checkbox" class="k-checkbox Check-All" /><label class="k-checkbox-label" for="CheckAll"></label>',
                //    template: '<input type="checkbox" id="Check_#=HosId#" class="k-checkbox Check-Item" /><label class="k-checkbox-label" for="Check_#=HosId#"></label>',
                //    headerAttributes: { "class": "text-center bold", "title": "选择", "style": "vertical-align: middle;" },
                //    attributes: { "class": "text-center" }
                //},
                  {
                      field: "LoginId", title: "登录ID", width: 180,
                      headerAttributes: { "class": "text-center text-bold", "title": "登录ID" }
                  },
                {
                    field: "FullName", title: "姓名", width: 180,
                    headerAttributes: { "class": "text-center text-bold", "title": "姓名" }
                },
                {
                    field: "Email", title: "Email", width: 180,
                    headerAttributes: { "class": "text-center text-bold", "title": "Email" }
                },
               {
                   field: "JoinDate", title: "入职时间", width: 180, format: "{0:yyyy-MM-dd}",
                   headerAttributes: { "class": "text-center text-bold", "title": "入职时间" }
               },
                 {
                     field: "AccountingDate", title: "核算指标时间", width: 180, format: "{0:yyyy-MM-dd}",
                     headerAttributes: { "class": "text-center text-bold", "title": "核算指标时间" }
                 }
                //{
                //    field: "HosLastModifiedDate", title: "修改日期", width: 150, format: "{0:yyyy-MM-dd HH:mm:ss}",
                //    headerAttributes: { "class": "text-center text-bold", "title": "修改日期" }
                //},
                //{
                //    field: "LastUpdateUserName", title: "修改人", width: 100,
                //    headerAttributes: { "class": "text-center text-bold", "title": "修改人" }
                //},
                //{
                //    title: "明细", width: 50,
                //    headerAttributes: {
                //        "class": "text-center text-bold"
                //    },
                //    template: "#if ($('\\#Id').val() != '') {#<i class='fa fa-edit' style='font-size: 14px; cursor: pointer;' name='edit'></i>#}#",
                //    attributes: {
                //        "class": "text-center text-bold"
                //    }
                //}

            ],
            pageable: {
                refresh: false,
                pageSizes: false,
                //pageSize: 20,
                //input: true,
                //numeric: false
            },
            noRecords: true,
            messages: {
                noRecords: "没有符合条件的记录"
            },
            dataBound: function (e) {
                var grid = e.sender;
            },
            page: function (e) {

            }
        });
    }


    that.QueryUploadUserInfo = function () {        
        var grid = $("#RstUploadUserInfo").data("kendoGrid");
        if (grid) {
            grid.dataSource.page(0);
            return;
        }
    }
    var dsUploadUserInfo = GetKendoDataSource(business, 'QueryUploadUserInfo', null, 20);
    that.UploadUserInfo = function () {
        $("#RstUploadUserInfo").kendoGrid({
            dataSource: dsUploadUserInfo,
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 230,
            columns: [
                {
                    field: "LineNbr", title: "行号",
                    headerAttributes: { "class": "text-center text-bold", "title": "行号" }
                },
               {
                   field: "LoginId", title: "登录ID",
                   headerAttributes: { "class": "text-center text-bold", "title": "登录ID" }
               },
               {
                   field: "JoinDate", title: "入职时间",
                   headerAttributes: { "class": "text-center text-bold", "title": "入职时间" }
               },
                 {
                     field: "AccountingDate", title: "核算指标时间",
                     headerAttributes: { "class": "text-center text-bold", "title": "核算指标时间" }
                 },
                {
                    field: "ErrorMsg", title: "错误信息",
                    headerAttributes: { "class": "text-center text-bold", "title": "错误信息" }
                }

            ],
            pageable: {
                refresh: false,
                pageSizes: false,
                //pageSize: 20,
                //input: true,
                //numeric: false
            }
        });
        $("#winUserOtherInfo").kendoWindow({
            title: "Title",
            width: 750,
            height: 400,
            actions: [
                "Maximize",
                "Close"
            ],
            resizable: false,
            //modal: true,
        }).data("kendoWindow").title("用户入职时间和核算指标时间上传").center().open();
    }
    that.ImportUserInfo = function () {
        var data = {};
        FrameUtil.SubmitAjax({
            business: business,
            method: 'ImportUserInfo',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                FrameWindow.ShowAlert({
                    target: 'center',
                    alertType: 'info',
                    message: model.ExecuteMessage,
                    callback: function () {
                    }
                });
                that.QueryUploadUserInfo();

                FrameWindow.HideLoading();
            }
        });
    }




    var setLayout = function () {
    }

    return that;
}();