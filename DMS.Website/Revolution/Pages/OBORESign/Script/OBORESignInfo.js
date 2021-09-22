var OBORESignInfo = {};

OBORESignInfo = function () {
    var that = {};

    var business = 'OBORESign.OBORESignInfo';
    var CustomerFaceNbr = [];

    that.GetModel = function () {
        var model = FrameUtil.GetModel();

        return model;
    }

    that.Init = function () {
        var data = {};
        data.ES_ID = Common.GetUrlParam('ES_ID');

        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                

                createRstOutFlowList(model.RstDetailList)


                $('#PnlDealerImport').DmsDataImport({
                    template: false,
                    delegateBusiness: business,
                    successMessage: '水印加载成功，请点击下方文件下载',
                    cookie: 'OBORESign.OBORESignInfo',
                    appendUploadParam: function (url) {
                        url = Common.UpdateUrlParams(url, 'ESID', model.ES_ID);
                        return url;
                    },
                    onSuccess: function (model)
                    {
                        data.ES_ID = Common.GetUrlParam('ES_ID');

                        FrameWindow.ShowLoading();
                        FrameUtil.SubmitAjax({
                            business: business,
                            method: 'Query',
                            url: Common.AppHandler,
                            data: data,
                            callback: function (model) {
                                $("#RstDetailList").data("kendoGrid").setOptions({
                                    dataSource: model.RstDetailList
                                });

                                $("#BtnDownload").show();
                                FrameWindow.HideLoading();
                            }
                        });
                    }

                   
                });

               

                $('#IptAgreementNo').FrameLabel({
                    value: model.IptAgreementNo,
                    readonly: true,
                });


                $('#IptBu').FrameDropdownList({
                    dataSource: model.LstBu,
                    dataKey: 'ProductLineID',
                    dataValue: 'ProductLineName',
                    selectType: 'select',
                    value: model.IptBu,
                    onChange: that.BuChange,
                   
                });


                //$('#IptSubBu').FrameMultiDropdownList({
                //    dataSource: model.LstSubBu,
                //    dataKey: 'Key',
                //    dataValue: 'Value',
                //    selectType: 'select',
                //    value: model.IptSubBu,
                  
                //});

                $('#IptSubBu').FrameMultiDropdownList({
                    dataSource: model.LstSubBu,
                    value: model.IptSubBu,
                    selectType: 'select',
                });


                $('#IptSignA').FrameLabel({
                    value: model.IptSignA,
                    readonly: true,
                });

                $('#IptSignB').FrameDropdownList({
                    dataSource: model.LstSignB,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'select',
                    filter: 'contains',
                    value: model.IptSignB,
                   
                });

                $('#IptCreateDate').FrameLabel({
                    value: model.IptCreateDate,
                    readonly: true,
                });

                $('#IptCreateUser').FrameLabel({
                    value: model.IptCreateUser,
                    readonly: true,
                });

                $('#BtnSign').FrameButton({
                    text: '签章',
                    icon: 'send',
                    onClick: function () {
                        that.Sign();
                    }
                });

                if (!model.SignReadonly) {

                   
                    $('#BtnSign').show();
                }
                else {

                    $('#BtnSign').hide();
                }

                $('#BtnSave').FrameButton({
                    text: '保存',
                    icon: 'save',
                    onClick: function () {
                        that.Save();
                    }
                });

                $('#BtnSubmit').FrameButton({
                    text: '提交',
                    icon: 'send',
                    onClick: function () {
                        that.Submit();
                    }
                });
                if (!model.SubmitReadonly) {
                    
                    $('#Upload').show();
                    $('#BtnSave').show();
                    $('#BtnSubmit').show();
                }
                else {
                    $('#Upload').hide();
                    $('#BtnSave').hide();
                    $('#BtnSubmit').hide();
                }
                $('#BtnDelete').FrameButton({
                    text: '删除',
                    icon: 'save',
                    onClick: function () {
                        that.Delete();
                    }
                });
                if (!model.DeleteReadonly) {
                    
                    $('#BtnDelete').show();
                }
                else {
                    $('#BtnDelete').hide();
                }
                $('#BtnRevoke').FrameButton({
                    text: '撤销',
                    icon: 'save',
                    onClick: function () {
                        that.Revoke();
                    }
                });
                if (!model.RevokeReadonly) {
                    
                    $('#BtnRevoke').show();
                }
                else {
                    $('#BtnRevoke').hide();
                }

                $('#BtnDownload').FrameButton({
                    text: '下载PDF',
                    icon: 'download',
                    onClick: function () {
                        that.DownloadPDF();
                    }
                });
                if (!model.UploadReadonly) {
                    $("#BtnDownload").show();
                }
                else {
                    $("#BtnDownload").hide();
                }
                
             
                //$('#BtnReturn').FrameButton({
                //    text: '返回',
                //    icon: 'save',
                //    onClick: function () {
                //        that.Return();
                //    }
                //});

                $("#RstDetailList").data("kendoGrid").setOptions({
                    dataSource: model.RstDetailList
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
        if (data.IptBu.Key == "") {

            $('#IptSubBu').FrameMultiDropdownList({
                dataSource:[],
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

                    $('#IptSubBu').FrameMultiDropdownList({
                        dataSource: model.LstSubBu,
                        value: model.IptSubBu,
                        selectType: 'select',
                    });

                    FrameWindow.HideLoading();
                }
            });
        }
    }


    var createRstOutFlowList = function (dataSource) {
        $("#RstDetailList").kendoGrid({
            dataSource: {
                data: dataSource,
            },
            resizable: true,
            sortable: true,
            scrollable: true,
            columns: [
             //{
             //    title: "签章", width: "50px",
             //    headerAttributes: {
             //        "class": "text-center text-bold"
             //    },
             //    template: "#if ($('\\#CST_NO').val() != '') {#<i class='fa fa-edit' style='font-size: 14px; cursor: pointer;' name='Sign'></i>#}#",
             //    attributes: {
             //        "class": "text-center text-bold"
             //    }
             //},
            {
                field: "Status", title: "状态", width: '90px',
                headerAttributes: { "class": "text-center text-bold", "title": "状态" }
            },
            {
                field: "AgreementType", title: "协议类型", width: '80px',
                headerAttributes: { "class": "text-center text-bold", "title": "协议类型" },

            },
            {
                field: "ES_FileName", title: "文件名", width: '250px',
                headerAttributes: { "class": "text-center text-bold", "title": "文件名" }
            },
            {
                field: "ES_DealerSignDate", title: "经销商签章日期", width: '150px',
                headerAttributes: { "class": "text-center text-bold", "title": "经销商签章日期" }
            }
            ,
            {
                field: "DealerSignUser", title: "经销商签章人", width: '180px',
                headerAttributes: { "class": "text-center text-bold", "title": "经销商签章人" }
            },
             {
                 field: "ES_LPSignDate", title: "物流平台签章日期", width: '150px',
                 headerAttributes: { "class": "text-center text-bold", "title": "物流平台签章日期" }
             }
            ,
            {
                field: "LPSignUser", title: "物流平台签章人", width: '180px',
                headerAttributes: { "class": "text-center text-bold", "title": "物流平台签章人" }
            }
            ],
            
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
                
            }
        });
    }

    that.Save = function () {
        var data = that.GetModel();
        data.ES_ID = Common.GetUrlParam('ES_ID');

        //var message = that.CheckForm(data);
        //if (message.length > 0) {
        //    FrameWindow.ShowAlert({
        //        target: 'top',
        //        alertType: 'warning',
        //        message: message,
        //    });
        //}
        //else {

            
            

        //}
        //FrameWindow.ShowLoading();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'Save',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {

                FrameWindow.ShowAlert({
                    target: 'top',
                    alertType: 'info',
                    message: '保存成功',
                    callback: function () {

                        //that.Init();
                        var url = Common.AppVirtualPath + 'Revolution/Pages/OBORESign/OBORESignInfo.aspx';
                        url += '?ES_ID=' + model.ES_ID;
                        window.location = url;

                    }
                });

                FrameWindow.HideLoading();
            }
        });
    }

    that.Submit = function () {
        var data = that.GetModel();
        data.ES_ID = Common.GetUrlParam('ES_ID');

        var message = that.CheckForm(data);
        if (message.length > 0) {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'warning',
                message: message,
            });
        }
        else {
           
            FrameWindow.ShowLoading();
            FrameUtil.SubmitAjax({
                business: business,
                method: 'Submit',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {

                    FrameWindow.ShowAlert({
                        target: 'top',
                        alertType: 'info',
                        message: '提交成功',
                        callback: function () {

                            //that.Init()
                            var url = Common.AppVirtualPath + 'Revolution/Pages/OBORESign/OBORESignInfo.aspx';
                            url += '?ES_ID=' + model.ES_ID;
                            window.location = url;

                        }
                    });

                    FrameWindow.HideLoading();
                }
            });



        }
    }

    that.Delete = function () {
        var data = that.GetModel();

            FrameWindow.ShowConfirm({
                target: 'top',
                message: '确定删除草稿吗？',
                confirmCallback: function () {
                    var data = FrameUtil.GetModel();
                    data.ES_ID = Common.GetUrlParam('ES_ID');
                   
                    //FrameWindow.ShowLoading();
                    FrameUtil.SubmitAjax({
                        business: business,
                        method: 'Delete',
                        url: Common.AppHandler,
                        data: data,
                        callback: function (model) {
                            FrameWindow.ShowAlert({
                                target: 'top',
                                alertType: 'info',
                                message: '删除成功',
                                callback: function () {
                                    top.deleteTabsCurrent();
                                }
                            });
                            FrameWindow.HideLoading();
                        }
                    });
                }
            });
    }

    that.Revoke = function () {
        var data = that.GetModel();

        FrameWindow.ShowConfirm({
            target: 'top',
            message: '确定撤销合同吗？',
            confirmCallback: function () {
                var data = FrameUtil.GetModel();
                data.ES_ID = Common.GetUrlParam('ES_ID');

                FrameWindow.ShowLoading();
                FrameUtil.SubmitAjax({
                    business: business,
                    method: 'Revoke',
                    url: Common.AppHandler,
                    data: data,
                    callback: function (model) {
                        FrameWindow.ShowAlert({
                            target: 'top',
                            alertType: 'info',
                            message: '撤销成功',
                            callback: function () {
                                //top.deleteTabsCurrent();
                                var url = Common.AppVirtualPath + 'Revolution/Pages/OBORESign/OBORESignInfo.aspx';
                                url += '?ES_ID=' + model.ES_ID;
                                window.location = url;
                                
                            }
                        });
                        FrameWindow.HideLoading();
                    }
                });
            }
        });
    }


    that.DownloadPDF = function () {
        var data = that.GetModel();
        data.ES_ID = Common.GetUrlParam('ES_ID');
        FrameWindow.ShowLoading();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'Download',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {

                
                var Url = Common.AppVirtualPath + "PagesKendo/Download.aspx?FilePath=" + model.Src + "" + "&FileName=" + model.FileName + "";
                window.open(Url, "Download");

                FrameWindow.HideLoading();
            }
        });

       
    }


    that.Sign = function () {
        
        url = Common.AppVirtualPath + 'Revolution/Pages/OBORESign/OBORContractWindow.aspx?' + 'ES_ID=' + Common.GetUrlParam('ES_ID');

        FrameWindow.OpenWindow({
            target: 'top',
            title: '合同预览',
            url: url,
            width: $(window).width() * 0.5,
            height: $(window).height() * 0.6,
            actions: ["Close"],
            callback: function (flowList) {
                var data = {};
                data.ES_ID = Common.GetUrlParam('ES_ID');

                FrameWindow.ShowLoading();
                FrameUtil.SubmitAjax({
                    business: business,
                    method: 'Query',
                    url: Common.AppHandler,
                    data: data,
                    callback: function (model) {
                        $("#RstDetailList").data("kendoGrid").setOptions({
                            dataSource: model.RstDetailList
                        });
                        that.Init();
                        FrameWindow.HideLoading();
                    }
                });

            }
        });

    }

    that.CheckForm = function (data) {
        var message = [];
       
       if ($.trim(data.IptBu.Key) == "") {
            message.push('请选择Bu');
       }
       else if ($.trim(data.IptSubBu) == "") {
           message.push('请选择SubBu');
       }
       else if ($.trim(data.IptSignB.Key) == "") {
            message.push('请选择经销商');
       }
       else if ($("#RstDetailList").data("kendoGrid").dataSource._data.length==0) {
           message.push('请上传附件');
       }
       else if ($("#RstDetailList").data("kendoGrid").dataSource._data.length>0) {
       
           if ($("#RstDetailList").data("kendoGrid").dataSource._data[0].ES_FileName == null)
           {
               message.push('请上传附件');
           }
       }

       
       
        return message;
    }

   


    var setLayout = function () {
    }

    return that;
}();
