var TerminationCreate = {};
var QryPolicyNo = "";
TerminationCreate = function () {
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
       
       
        if ($.getUrlParam('Type') == "View")
        {
            $('#BtnSubmit').hide();
            $('#BtnSave').hide();
        }
        var model = $.getModel();
        model.TermainationId = $.getUrlParam('TermainationId');
        model.View=$.getUrlParam('Type');
        model.Method = 'InitPage';
        var data = model;
        submitAjax(Common.AppVirtualPath + "PagesKendo/Promotion/Handler/TerminationHanler.ashx", data, function (model) {
           
            QryPolicyNo = model.QryPolicyNo;


            //$('#QryPolicyNo').FrameDropdownList({
            //    dataSource: model.LstPolicyNo,
            //    dataKey: 'Id',
            //    dataValue: 'No',
            //    selectType: 'select',
            //    filter: "contains",
            //    value: model.QryPolicyNo,
            //    onChange: that.ChangeProductLine
            //});

            //$('#QryPolicyNo').FrameDropdownList({
            //    dataSource: model.LstPolicyNo,
            //    dataKey: 'Id',
            //    dataValue: 'No',
            //    selectType: 'select',
            //    value: model.QryPolicyNo
            //});
            //政策编号
            $("#QryPolicyNo").kendoDropDownList({
                optionLabel: '请选择',
                noDataTemplate: '',
                dataTextField: "No",
                dataValueField: "Id",
                clearButton: true,
                minLength: 1,
                filter: "contains",
                dataSource: model.LstPolicyNo,
                value: model.QryPolicyNo,
                //text: model.QryPolicy,
                filtering: function (e) {
                    //var requestData = {};
                    ////requestData.QryPolicy = e.filter.value;
                    ////requestData.GetModel='InitPage';
                    
                    //var model = $.getModel();
                    //model.QryPolicy = e.filter.value;
                    //model.Method = 'InitPage';
                    //var data = model;
                    //submitAjax(Common.AppVirtualPath + "PagesKendo/Promotion/Handler/TerminationHanler.ashx", data, function (model) {

                     
                    //    //$('#QryPolicyNo').data("kendoDropDownList").setDataSource(model.LstPolicyNo);

                    //    hideLoading();
                    //});
                },
                change: function (e) {


                    var model = $.getModel();
                    model.QryPolicyNo = e.sender._old;
                    model.Method = 'Change';
                    var data = model;
                    submitAjax(Common.AppVirtualPath + "PagesKendo/Promotion/Handler/TerminationHanler.ashx", data, function (model) {

                        QryPolicyNo = e.sender._old;
                        if (model.QryPolicyNo == "") {

                            $('#QryPolicyName_Control').val("");
                            $('#QryProductLine_Control').val("");
                            $('#QryStartDate_Control').val("");
                            $('#QryEndDate_Control').val("");
                            $('#QrySubBu_Control').val("");
                        }
                        else {

                            $('#QryPolicyName_Control').val(model.QryPolicyName);
                            $('#QryProductLine_Control').val(model.QryProductLine);
                            $('#QryStartDate_Control').val(model.QryStartDate);
                            $('#QryEndDate_Control').val(model.QryEndDate);
                            $('#QrySubBu_Control').val(model.QrySubBu);
                        }
                     
                    });
                }
            });

           
            //政策名称
            $('#QryPolicyName').FrameTextBox({
                value: model.QryPolicyName
            });

            //归类名称
            $('#QryPolicyGroupName').FrameTextBox({
                value: model.QryPolicyGroupName
            });
            //产品线
            $('#QryProductLine').FrameTextBox({
                value: model.QryProductLine
            });
            //开始时间
            $('#QryStartDate').FrameTextBox({
                value: model.QryStartDate
            });
            //结束时间
            $('#QryEndDate').FrameTextBox({
                value: model.QryEndDate
            });
            //SuBu
            $('#QrySubBu').FrameTextBox({
                value: model.QrySubBu
            });
            //终止生效时间
           
            $('#QryTemainationSDate').FrameDatePicker({
                depth: "year",
                start: "year",
                format: "yyyy-MM",
                value: model.QryTemainationSDate,
                onChange: that.DateChange
               
            });
            //终止类型
            $('#QryTemainationType').FrameDropdownList({
                dataSource: [{ Key: '政策撤销', Value: '政策撤销' }, { Key: '提前终止', Value: '提前终止' }],
                dataKey: 'Key',
                dataValue: 'Value',
                selectType: 'all',
                value: model.QryTemainationType,
                onChange: that.TemainationType
            });

            //备注
            $('#QryRemark').FrameTextBox({
                value: model.QryRemark
            });
           
            $('#QryPolicyName_Control').attr("disabled", true);
            $('#QryPolicyName_Control').css("background", "#CCC")
            $('#QryClassName_Control').attr("disabled", true);
            $('#QryClassName_Control').css("background", "#CCC")
            $('#QryProductLine_Control').attr("disabled", true);
            $('#QryProductLine_Control').css("background", "#CCC")
            $('#QryStartDate_Control').attr("disabled", true);
            $('#QryStartDate_Control').css("background", "#CCC")
            $('#QryEndDate_Control').attr("disabled", true);
            $('#QryEndDate_Control').css("background", "#CCC")
            $('#QrySubBu_Control').attr("disabled", true);
            $('#QrySubBu_Control').css("background", "#CCC")
            $('#QryPolicyGroupName_Control').attr("disabled", true);
            $('#QryPolicyGroupName_Control').css("background", "#CCC")
            if ($.getUrlParam('TermainationId') == '' ) {
                $('#QryTemainationSDate_Control').attr("disabled", true);
                $('#QryTemainationSDate_Control').css("background", "#CCC")
                $("#QryTemainationSDate").FrameDatePicker("disable");
            }
            else if(model.QryTemainationType == '政策撤销'){
                $('#QryTemainationSDate_Control').attr("disabled", true);
                $('#QryTemainationSDate_Control').css("background", "#CCC")
                $("#QryTemainationSDate").FrameDatePicker("disable");
            }
            

        
            
            $('#BtnSubmit').FrameButton({
                onClick: function () {
                    Vala('Submit')
                   
                }
            });
            $('#BtnSave').FrameButton({
                onClick: function () {
                    Vala('Save')
                  
                }

            });
           
            $('#BtnClose').FrameButton({
                onClick: function () {
                    closeWindow({
                        target: 'top'
                    });
                }
            });

            hideLoading();
        });
    }

    that.TemainationType = function () {

        $('#QryTemainationSDate_Control').val("");
        if ($('#QryTemainationType_Control').val() == "提前终止") {
            $('#QryTemainationSDate_Control').removeAttr("disabled");
            $('#QryTemainationSDate_Control').css("background", "")
            $("#QryTemainationSDate").FrameDatePicker("enable");
        }
        else {
            $('#QryTemainationSDate_Control').attr("disabled", true);
            $('#QryTemainationSDate_Control').css("background", "#CCC")
            $("#QryTemainationSDate").FrameDatePicker("disable");
        }
    }

    that.DateChange = function () {

        if ($('#QryTemainationSDate_Control').val() != "")
        {
            if ($('#QryTemainationSDate_Control').val() >= $('#QryStartDate_Control').val() && $('#QryTemainationSDate_Control').val() <= $('#QryEndDate_Control').val()) {

                return true;
            }
            else {
                showAlert({
                    target: 'top',
                    alertType: 'warning',
                    message: '请选择有效日期'
                });
                $('#QryTemainationSDate_Control').val("")
                return false;
            }
        }

    }

    that.ChangeProductLine = function () {

        var data = that.GetModel('PolicyNo');
        submitAjax(Common.AppVirtualPath + "PagesKendo/Promotion/Handler/TerminationHanler.ashx", data, function (model) {

            if (model.QryPolicyNo == "") {

                $('#QryPolicyName_Control').val("");
                $('#QryProductLine_Control').val("");
                $('#QryStartDate_Control').val("");
                $('#QryEndDate_Control').val("");
                $('#QrySubBu_Control').val("");
            }
            else {

                $('#QryPolicyName_Control').val(model.QryPolicyName);
                $('#QryProductLine_Control').val(model.QryProductLine);
                $('#QryStartDate_Control').val(model.QryStartDate);
                $('#QryEndDate_Control').val(model.QryEndDate);
                $('#QrySubBu_Control').val(model.QrySubBu);
            }
        });
        


    }

    var Vala = function (Status) {
        if ($('#QryPolicyNo').val() == "") {
            showAlert({
                target: 'top',
                alertType: 'warning',
                message: '请选择促销编号'
            });

            return
        }
        else if ($('#QryTemainationType_Control').val() == "") {
            showAlert({
                target: 'top',
                alertType: 'warning',
                message: '请选择终止类型'
            });

            return

        }
      
        else if ($('#QryTemainationSDate_Control').val() == "" && $('#QryTemainationType_Control').val() != "政策撤销")
        {
            showAlert({
                target: 'top',
                alertType: 'warning',
                message: '请选择终止生效时间'
            });

            return
        }
        else {

            //var data = that.GetModel(Status);
            var message = "";
            if (Status == "Submit"){
                message="提交成功";
            }
            else {
                message="保存成功";
            }
            var model = $.getModel();
            if (QryPolicyNo != "")
            {
                
                model.QryPolicyNo = QryPolicyNo;
                model.TermainationId = $.getUrlParam('TermainationId');
                model.Method = Status;
                var data = model;
                //showLoading();

                submitAjax(Common.AppVirtualPath + "PagesKendo/Promotion/Handler/TerminationHanler.ashx", data, function (model) {
                    showAlert({
                        target: 'top',
                        alertType: 'info',
                        message: message,
                        callback: function () {
                            closeWindow({
                                target: 'top'
                            });
                        }

                    });

                })

                
                hideLoading();
                
                
            }
            
        }

    }

  


    var setLayout = function () {
        var h = $('.content-main').height();

        $("#RstTemainationList").data("kendoGrid").setOptions({
            height: h - 220
        });
    }

    return that;
}();
