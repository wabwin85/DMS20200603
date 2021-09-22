var DealerMasterDDBsc = {};
DealerMasterDDBsc = function () {
    var that = {};

    that.GetModel = function (method) {
        var model = $.getModel();
        model.Method = method;

        return model;
    }

    that.InitPage = function () {

        $('#ForwardUrl').val($.getUrlParam('ReturnUrl'));

        $('#BtnSave').FrameButton({
            onClick: that.DoSave
        });
        $('#BtnClose').FrameButton({
            onClick: function () {
                window.location.href = $('#ForwardUrl').val();
            }
        });

        $('#ContractID').val($.getUrlParam('formInstanceId'));

        $('#DDReportName').FrameTextBox({
            value: ''
        });

        $('#DDStartDate').FrameDatePicker({
            format: "yyyy-MM-dd",
                value: ''
        });

        $('#DDEndDate').FrameDatePicker({
            format: "yyyy-MM-dd",
                    value: ''
        });

        $('#divReturnHtml').html('');

        showLoading();

        var data = that.GetModel('InitPage');
        submitAjax(Common.AppVirtualPath + "PagesKendo/ContractElectronic/Handlers/DealerMasterDDBscHandler.ashx", data, function (model) {
           
            

            $('#DDReportName').FrameTextBox({
                    value: model.DDReportName
            });

            $('#DDStartDate').FrameDatePicker({
                value: model.DDStartDate
            });

            $('#DDEndDate').FrameDatePicker({
                    value: model.DDEndDate
            });
            createRstAttachmentDetail(model.AttachmentList);
            $('#WinFileUpload').kendoUpload({
                async: {
                    saveUrl: "../../Revolution/Pages/Handler/UploadAttachmentHanler.ashx?Type=DealerMasterDD&InstanceId=" + $("#ContractID").val(),
                    autoUpload: true
                },
                select: function (e) {

                },
                validation: {
                    //allowedExtensions: [".pdf"],
                },
                multiple: false,
                success: function (e) {
                    //刷新附件列表
                    that.refreshAttachment();
                }
            });

            //$('#BtnAddAttachment').FrameButton({
            //        text: '上传附件',
            //    onClick: function () {
            //        that.UploadFile();
            //    }
            //});
            $('#BtnAddAttachment').FrameButton({
                onClick: function () {
                    that.initUploadAttachDiv();
                }
            });
            $("#divReturnHtml").append(model.HtmlString);
            
            checkAuth();

            setLayout();

            hideLoading();
        });
    }

    that.DoSave = function () {
        showLoading();

        var data = that.GetModel('DoSave');
        submitAjax(Common.AppVirtualPath + "PagesKendo/ContractElectronic/Handlers/DealerMasterDDBscHandler.ashx", data, function (model) {
            alert('保存成功！');
            hideLoading();
            window.location.href = $('#ForwardUrl').val();
            


            $('#LastUpdateTime').val(model.LastUpdateTime);
            $("#divReturnHtml").html('');
            $("#divReturnHtml").append(model.HtmlString);
            
            checkAuth();

            setLayout();

            hideLoading();
        });
    }

    var initColumnLayout = function () {
    }

    var setLayout = function () {
        var h = $('.content-main').height();
    }

    var checkAuth = function () {
        //CurrentNodeIds

        clearControlStatus();

        var isCs = true;

        if (isCs)
        {
            $('#DDReportName').FrameTextBox('enable');
            $('#DDStartDate').FrameDatePicker('enable');
            $('#DDEndDate').FrameDatePicker('enable');
            $("#BtnSave").css("display", "");
            $('#BtnAddAttachment').show();
        }

    }

    var clearControlStatus = function () {
        $('#DDReportName').FrameTextBox('disable');
        $('#DDStartDate').FrameDatePicker('disable');
        $('#DDEndDate').FrameDatePicker('disable');
        $("#BtnSave").css("display", "none");
        $('#BtnAddAttachment').hide();
    }
    //****************附件**********
    that.initUploadAttachDiv = function (CName, EName, DealerType) {
        $("#winUploadAttachLayout").kendoWindow({
            title: "Title",
            width: 400,
            height: 200,
            actions: [
        "Close"
            ],
            resizable: false,
            //modal: true,
        }).data("kendoWindow").title("上传附件").center().open();

    }

    //刷新文件
    that.refreshAttachment = function () {
        var data = that.GetModel('AttachmentStore_Refresh');
        submitAjax(Common.AppVirtualPath + "PagesKendo/ContractElectronic/Handlers/DealerMasterDDBscHandler.ashx", data, function (model) {
            var dataSource = $("#RstAttachmentDetail").data("kendoGrid").dataSource.data();
            for (var i = 0; i < model.AttachmentList.length; i++) {
                var exists = false;
                for (var j = 0; j < dataSource.length; j++) {
                    if (dataSource[j].Id == model.AttachmentList[i].Id) {
                        exists = true;
                    }
                }
                if (!exists) {
                    $("#RstAttachmentDetail").data("kendoGrid").dataSource.add(model.AttachmentList[i]);
                }
            }
            $("#RstAttachmentDetail").data("kendoGrid").setOptions({
                dataSource: $("#RstAttachmentDetail").data("kendoGrid").dataSource
            });
        });
    }
    //删除附件
    that.AttachmentDelete = function (dataItem, Id, AttachmentName) {
        if(confirm('是否要删除该附件文件?')) {
            var data = that.GetModel('DeleteAttachment');
            data.DeleteAttachmentID = Id;
            data.DeleteAttachmentName = AttachmentName;
            showLoading();
            submitAjax(Common.AppVirtualPath + "PagesKendo/ContractElectronic/Handlers/DealerMasterDDBscHandler.ashx", data, function (model) {
                alert("删除附件成功!");
                $("#RstAttachmentDetail").data("kendoGrid").dataSource.remove(dataItem);
                hideLoading();
                    
            });
        }
    };
    function downloadfile(url) {
        var iframe = document.createElement("iframe");
        iframe.src = url;
        iframe.style.display = "none";
        document.body.appendChild(iframe);
    }

    var createRstAttachmentDetail = function (dataSource) {
        $("#RstAttachmentDetail").kendoGrid({
            dataSource: {
                data: dataSource,
            },
            resizable: true,
            sortable: true,
            scrollable: true,
            //height: 300,
            columns: [
            {
                field: "Name", title: "附件名称", width: 'auto', 
                headerAttributes: {
                    "class": "text-center text-bold", "title": "附件名称"
                }
            },
            {
                field: "Identity_Name", title: "上传人", width: '150px', 
                headerAttributes: {
                    "class": "text-center text-bold", "title": "上传人"
                }
            },
            {
                field: "UploadDate", title: "上传时间", width: '150px', 
                headerAttributes: {
                    "class": "text-center text-bold", "title": "上传时间"
                }
            },
            {
                field: "Url", title: "Url", width: '150px',  hidden: true,
                headerAttributes: {
                    "class": "text-center text-bold", "title": "Url"
                }
            },
             {
                 title: "下载", width: '80px',
                 headerAttributes: {
                     "class": "text-center text-bold", "title": "下载", "style": "vertical-align: middle;"
                 },
                 template: "<i class='fa fa-download' style='font-size: 14px; cursor: pointer;'></i>",
                 attributes: {
                     "class": "text-center text-bold"
                 },
             },
             {
                 field: "Delete", title: "删除", width: '80px', 
                 headerAttributes: {
                     "class": "text-center text-bold", "title": "删除", "style": "vertical-align: middle;"
                 },
                 template: "<i class='fa fa-close item-delete' style='font-size: 14px; cursor: pointer;'></i>",
                 attributes: {
                     "class": "text-center text-bold"
                 },
             }
            ],
            pageable: {
                refresh: false,
                pageSizes: false,
                pageSize: 10,
                input: true,
                numeric: false
            },
            noRecords: true,
            messages: {
                noRecords: "没有符合条件的记录"
            },
            dataBound: function (e) {
                var grid = e.sender;
                var rows = this.items();
                $(rows).each(function () {
                    var index = $(this).index() + 1;
                    var rowLabel = $(this).find(".Row-Number");
                    $(rowLabel).html(index);
                });

                $("#RstAttachmentDetail").find(".item-delete").bind('click', function () {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);
                    that.AttachmentDelete(data, data.Id, data.Url);
                });
                $("#RstAttachmentDetail").find(".fa-download").bind('click', function () {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);
                    var url = '../../Revolution/Pages/Download.aspx?downloadname=' + escape(data.Name) + '&filename=' + escape(data.Url) + '&downtype=DealerMasterDDAttachment';
                    downloadfile(url);
                });

            }
        });
    }
    //****************附件**********
    return that;
}();
