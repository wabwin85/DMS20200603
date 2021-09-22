<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageKendo/Site.Master" AutoEventWireup="true" CodeBehind="MaintainSecondRate.aspx.cs" Inherits="DMS.Website.PagesKendo.MaintainSecondRate" %>

<asp:Content ID="ContentStyle" ContentPlaceHolderID="StyleContent" runat="server">
</asp:Content>
<asp:Content ID="ContentMain" ContentPlaceHolderID="MainContent" runat="server">
    <div class="content-main" style="margin: 15px;">
        <div class="panel panel-primary">
            <!-- Default panel contents -->
            <div class="panel-heading">
                <h3 class="panel-title"><i class='fa fa-navicon' style="padding-left: 15px;"></i>&nbsp;请选择要上传的文件</h3>
            </div>
            <div class="panel-body" style="padding: 0px;">
                <div id="UpLoadTemplate">
                    <div style="margin: 10px 15px 0px 15px; height: 110px;">

                        <input name="files" id="files" style="" type="file" />

                    </div>
                    <div style="text-align: center; position: relative; margin: 10px 20px 10px 0px;">
                        <button id="btnParse" class="KendoButton size-14"><i class="fa fa-hand-lizard-o" aria-hidden="true"></i>&nbsp;&nbsp;校验文件</button>
                        <button id="btnDownloadTemplate" class="KendoButton size-14"><i class="fa fa-cloud-download" aria-hidden="true"></i>&nbsp;&nbsp;下载模板</button>
                        <button id="BtnClose" class="KendoButton size-14"><i class='fa fa-window-close-o'></i>&nbsp;&nbsp;关闭</button>
                    </div>
                </div>
            </div>
        </div>
        <div class="panel panel-primary">
            <!-- Default panel contents -->
            <div class="panel-heading">
                <h3 class="panel-title"><i class='fa fa-navicon' style="padding-left: 15px;"></i>&nbsp;加价率</h3>
            </div>
            <div class="panel-body" style="padding: 0px;">
                <div id="topValueList" style="border-width: 0px;">
                </div>

            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="ContentScript" ContentPlaceHolderID="ScriptContent" runat="server">

    <script type="text/javascript">

        var filePath = "";
        var uid = "";
        var UpLoadUrl = "";
        $(document).ready(function () {

            showLoading();

            $.ajax({
                type: "Post",
                url: location.href.substring(0, location.href.lastIndexOf('/')) + "/Handler/UpLoad.ashx",
                timeout: 60000,
                data: { "ActionType": "Load", "MaintainType": "SecondRate", "PolicyID": $.getUrlParam('PolicyId') },
                //添上之后后端接收不到data
                //contentType: "application/json; charset=utf-8",
                async: true,
                dataType: "json",
                success: function (data) {
                    console.log(data.success);
                    console.log($.getUrlParam('PolicyId'));
                    if (data.Status == "success") {
                        console.log(data);
                        $('#topValueList').data("kendoGrid").setOptions({
                            dataSource: data.Data
                        });

                    }

                },

            });
            hideLoading();
            $('#btnParse').FrameButton({
                onClick: function () {
                    var upload = $("#files").data("kendoUpload"),
                     files = upload.getFiles();

                    //var filesExten = files[0].extension;
                    //var filesName = files[0].name;
                    //var filesRaw = files[0].rawFile;
                    //var filesSize = files[0].size;
                    //uid = files[0].uid;
                    console.log(UpLoadUrl);
                    if (UpLoadUrl == "") {
                        showAlert({
                            target: 'this',
                            alertType: 'error',
                            message: "未导入文件或导入文件格式错误，请导入正确的文件！"
                        });
                        return;
                    }

                    $.ajax({
                        type: "Post",
                        url: location.href.substring(0, location.href.lastIndexOf('/')) + "/Handler/UpLoad.ashx",
                        timeout: 60000,
                        data: { "MaintainType": "SecondRate", "ActionType": "ParseRate", "UpLoadUrl": UpLoadUrl, "SheetName": "sheet1", "FiledCount": "4" },
                        //添上之后后端接收不到data
                        //contentType: "application/json; charset=utf-8",
                        async: true,
                        dataType: "json",
                        success: function (data) {

                            var dataArr = data.Data;
                            if (data.Status == "success") {         
                                var count = 0;

                                $.each(dataArr, function (index, n) {
                                    //console.log(index + "==" + n);
                                    if (n.ISErr == '1') {
                                        count++;
                                        //errArr.push(n.)
                                    }
                                });
                                //console.log(dataArr);
                                //dataArr.sort(function (a, b) {
                                //    return b.ISErr - a.ISErr;
                                //});
                                //console.log(dataArr);
                                //console.log(count);
                                if (count == 0) {
                                    $('#topValueList').data("kendoGrid").setOptions({
                                        dataSource: dataArr
                                    });
                                    showAlert({
                                        target: 'this',
                                        alertType: '',
                                        message: '上传文件校验成功。'
                                    })
                                }
                                else {
                                    $('#topValueList').data("kendoGrid").setOptions({
                                        dataSource: dataArr
                                    });
                                    showAlert({
                                        target: 'this',
                                        alertType: '',
                                        message: '上传文件校验完成。但存在错误信息，请根据错误提示信息更正源数据后，再上传！'
                                    })
                                }
                            }

                            else {
                                showAlert({
                                    target: 'this',
                                    alertType: 'error',
                                    message: data.Error
                                });
                                hideLoading();
                            }

                        },

                    });
                    //submitAjaxUpLoad(location.href.substring(0, location.href.lastIndexOf('/')) + "/Handler/UpLoad.ashx", { "ActionType": "ParseRate", "UpLoadUrl": UpLoadUrl });
                }
            });
            $('#btnDownloadTemplate').FrameButton({
                onClick: function () {
                    //console.log(removeurl);
                    $.ajax({
                        type: "Post",
                        url: location.href.substring(0, location.href.lastIndexOf('/')) + "/Handler/UpLoad.ashx",
                        timeout: 60000,
                        data: { "MaintainType": "SecondRate", "ActionType": "DownLoad", "ForeignType": "ExcelTemplate", "DownLoadFileName": "Template_PromotionPointRatio.xls" },
                        //添上之后后端接收不到data
                        //contentType: "application/json; charset=utf-8",
                        async: true,
                        dataType: "json",
                        success: function (data) {
                            console.log(data.success);
                            if (data.Status == "success") {

                                //var url = location.href.substring(0, location.href.lastIndexOf('/')) + "../../../UpLoad/ExcelTemplate/Template_PromotionPointRatio.xls";

                                window.location = (location.href.substring(0, location.href.lastIndexOf('/')) + "../../../UpLoad/ExcelTemplate/Template_PromotionPointRatio.xls");

                            }
                            else {
                                showAlert({
                                    target: 'this',
                                    alertType: 'error',
                                    message: data.Error
                                });
                                hideLoading();
                            }

                        },

                    });
                }
            });
            //removeUrl: location.href.substring(0, location.href.lastIndexOf('/')) + "/Handler/UpLoad.ashx?FilePath=" + filePath,


            $('#files').kendoUpload({
                async: {//$.getUrlParam('PolicyId')
                    saveUrl: location.href.substring(0, location.href.lastIndexOf('/')) + "/Handler/UpLoad.ashx?ForeignType=PROOther&ActionType=SecondRate&SheetName=sheet1&FieldCount=4&MaintainType=SecondRate&PolicyID=" + $.getUrlParam('PolicyId'),
                    // removeUrl: location.href.substring(0, location.href.lastIndexOf('/')) + "/Handler/UpLoad.ashx?ForeignType=PromotionKendoUpLoad&ActionType=Remove&FilePath=" + UpLoadUrl,
                    autoUpload: true
                },
                localization: {
                    select: "选择文件",
                    remove: "Remove"
                },
                multiple: false,
                success: onSuccess,
                select: onSelect,
                //remove: onRemove

            });
            $('#BtnClose').FrameButton({
                onClick: function () {
                    closeWindow({
                        target: 'parent'
                    });
                }
            });

            $("#topValueList").kendoGrid({
                dataSource: [],
                sortable: true,
                resizable: true,
                scrollable: true,
                columns: [
                    {
                        field: "SAPCode", title: "经销商代码", width: '15%',
                        headerAttributes: { "class": "center bold", "title": "经销商名称" }
                    },
                {
                    field: "DealerName", title: "经销商名称", width: '30%',
                    headerAttributes: { "class": "center bold", "title": "经销商名称" }
                },
                 {
                     field: "DealerType", title: "经销商类型", width: '15%',
                     headerAttributes: { "class": "center bold", "title": "经销商类型" }
                 },
                    {
                        field: "AccountMonth", title: "账期", width: '15%',
                        headerAttributes: { "class": "center bold", "title": "账期" }
                    },
                     {
                         field: "Ratio", title: "加价率", width: '15%',
                         headerAttributes: { "class": "center bold", "title": "加价率" }
                     },
                    {
                        field: "ErrMsg", title: "错误信息", width: '20%',
                        headerAttributes: { "class": "center bold", "title": "错误信息" },
                        template: "#if(data.ISErr=='1'){#<span style='color:red;' >#:ErrMsg#</span>#}else{#<span></span>#}#"
                    },


                ], pageable: {
                    refresh: false,
                    pageSizes: false,
                    pageSize: 20,
                    input: true,
                    numeric: false
                }


            });
            $(window).resize(function () {
                setLayout();
            })
            setLayout();
            hideLoading();
        });
        var onRemove = function (e) {
            e.preventDefault();
            var upload = $("#files").data("kendoUpload");
            upload.destroy();
        }
        var onSelect = function (e) {
            //e.preventDefault();

            //var upload = $("#files").data("kendoUpload");
            //upload.removeFile(function(file){
            //    console.log("onselect");
            //})


        }
        var onSuccess = function (e) {
            console.log("onSuccess");
            var data = JSON.parse(e.XMLHttpRequest.response);
            console.log(data);
            if (e.operation == "upload") {
                if (data.FilePath != "") {
                    //filePath = data.FilePath;
                    UpLoadUrl = data.FilePath;
                    console.log(UpLoadUrl);
                }

            }

        }

        var setLayout = function () {

            var h = $('.content-main').height();
            $('#topValueList').data("kendoGrid").setOptions({
                height: h - 270
            });

        }
        //    return that;
        //}()
    </script>

</asp:Content>
