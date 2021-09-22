<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageKendo/Site.Master" AutoEventWireup="true" CodeBehind="MaintainUploadFixedChange.aspx.cs" Inherits="DMS.Website.PagesKendo.Promotion.MaintainUploadFixedChange" %>
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
                <h3 class="panel-title"><i class='fa fa-navicon' style="padding-left: 15px;"></i>&nbsp;转换率</h3>
            </div>
            <div class="panel-body" style="padding: 0px;">
                <div>
                    <div id="ChangeRateList" style="border-width: 0px;">
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="ContentScript" ContentPlaceHolderID="ScriptContent" runat="server">
    <script src="Script/xlsx.core.min.js"></script>
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
                data: { "ActionType": "Load", "MaintainType": "Fiexd", "PolicyID": $.getUrlParam('PolicyId') },
                //添上之后后端接收不到data
                //contentType: "application/json; charset=utf-8",
                async: true,
                dataType: "json",
                success: function (data) {
                    console.log(data.success);
                    console.log($.getUrlParam('PolicyId'));
                    if (data.Status == "success") {
                        console.log(data);
                        $('#ChangeRateList').data("kendoGrid").setOptions({
                            dataSource: data.Data
                        });

                    }
                    hideLoading();
                },

            });

            $('#btnParse').FrameButton({
                onClick: function () {
                    if (UpLoadUrl == "") {
                        showAlert({
                            target: 'this',
                            alertType: 'error',
                            message: "未导入文件或导入文件格式错误，请导入正确的文件！"
                        });
                        return;

                    }
                    console.log(UpLoadUrl);
                    $.ajax({
                        type: "Post",
                        url: location.href.substring(0, location.href.lastIndexOf('/')) + "/Handler/UpLoad.ashx",
                        timeout: 60000,
                        data: { "MaintainType": "Fiexd", "ActionType": "ParseRate", "UpLoadUrl": UpLoadUrl, "SheetName": "sheet1", "FieldCount": "2" ,"PolicyID": $.getUrlParam('PolicyId')},
                        //添上之后后端接收不到data
                        //contentType: "application/json; charset=utf-8",
                        async: true,
                        dataType: "json",
                        success: function (data) {
                            var dataArr = data.Data;
                            if (data.Status == "success") {

                                //$.each(LstPolicyGeneralDesc, function (i, n) {
                                //    if (n.Level2 == pointFor && n.Level3 == '') {
                                //        $('#IptDesc' + group).html(n.DescContent);
                                //    }
                                //});
                                var count = 0;

                                $.each(dataArr, function (index, n) {
                                    console.log(index + "==" + n);
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
                                    $('#ChangeRateList').data("kendoGrid").setOptions({
                                        dataSource: dataArr
                                    });
                                    showAlert({
                                        target: 'this',
                                        alertType: '',
                                        message: '上传文件校验成功。'
                                    })
                                }
                                else {
                                    $('#ChangeRateList').data("kendoGrid").setOptions({
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
                }
            });
            $('#btnDownloadTemplate').FrameButton({
                onClick: function () {
                    $.ajax({
                        type: "Post",
                        url: location.href.substring(0, location.href.lastIndexOf('/')) + "/Handler/UpLoad.ashx",
                        timeout: 60000,
                        data: { "MaintainType": "Fiexd", "ActionType": "DownLoad", "ForeignType": "ExcelTemplate", "DownLoadFileName": "Template_PromotionProductStandardPrice.xls" },
                        //添上之后后端接收不到data
                        //contentType: "application/json; charset=utf-8",
                        async: true,
                        dataType: "json",
                        success: function (data) {
                            if (data.Status == "success") {
                                //var url = location.href.substring(0, location.href.lastIndexOf('/')) + "../../../UpLoad/ExcelTemplate/Template_PromotionProductStandardPrice.xls"
                                window.location=(location.href.substring(0, location.href.lastIndexOf('/'))+"../../../UpLoad/ExcelTemplate/Template_PromotionProductStandardPrice.xls");

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
            $('#files').kendoUpload({
                async: {
                
                    saveUrl: location.href.substring(0, location.href.lastIndexOf('/')) + "/Handler/UpLoad.ashx?ForeignType=PROOther&ActionType=SecondRate&SheetName=sheet1&FiledCount=2&MaintainType=Fiexd&PolicyID=" + $.getUrlParam('PolicyId'),
                    autoUpload: true,
                    
                },
                localization: {
                    select: "选择文件",
                    remove: "Remove"
                },
                multiple: false,
                success: onSuccess,
             
            });
            $('#BtnClose').FrameButton({
                onClick: function () {
                    closeWindow({
                        target: 'parent'
                    });
                }
            });
            $("#ChangeRateList").kendoGrid({
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
                         field: "Points", title: "加价率", width: '15%',
                         headerAttributes: { "class": "center bold", "title": "加价率" }
                     },
                    {
                        field: "ErrMsg", title: "错误信息", width: '20%',
                        headerAttributes: { "class": "center bold", "title": "错误信息" },
                        template: "#if(data.ISErr=='1'){#<span style='color:red;' >#:ErrMsg#</span>#}else{#<span></span>#}#"
                    },


                ],
                pageable: {
                    refresh: false,
                    pageSizes: false,
                    pageSize: 20,
                    input: true,
                    numeric: false
                },

              
            });
            $(window).resize(function () {
                setLayout();
            })
            setLayout();
            hideLoading();
        });
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
            $('#ChangeRateList').data("kendoGrid").setOptions({
                height: h - 280
            });

        }
    </script>

</asp:Content>
