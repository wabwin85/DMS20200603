<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageKendo/Site.Master" AutoEventWireup="true" CodeBehind="MaintainAttachment.aspx.cs" Inherits="DMS.Website.PagesKendo.Promotion.MaintainAttachment" %>

<asp:Content ID="ContentStyle" ContentPlaceHolderID="StyleContent" runat="server">
    <style>
        .k-clear-selected,
        .k-upload-selected {
            display: none !important;
        }
    </style>
</asp:Content>
<asp:Content ID="ContentMain" ContentPlaceHolderID="MainContent" runat="server">
    <div class="content-main" style="margin: 15px;">
        <div class="panel panel-primary">
            <!-- Default panel contents -->
            <div class="panel-heading">
                <h3 class="panel-title"><i class='fa fa-navicon' style="padding-left: 15px;"></i>&nbsp;请选择要上传的附件</h3>
            </div>
            <div class="panel-body" style="padding: 0px;">
                <div id="UpLoadTemplate">
                    <div style="margin: 10px 15px 0px 15px; height: 110px;" >
                        <input name="files" id="files" style="" type="file" />
                    </div>
                    <div style="text-align: center; position: relative; margin: 10px 20px 10px 0px;">
                        <button id="btnParse" class="KendoButton size-14">上传附件</button>
                        <button id="btndel" class="KendoButton size-14">删除</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="ContentScript" ContentPlaceHolderID="ScriptContent" runat="server">
    <script>
        var UpLoadUrl = "";
        $(document).ready(function () {
           
            $('#btnParse').FrameButton( {
                onClick:function(e){
                    e.preventDefault();                  
                    var upload = $("#files").data("kendoUpload");
                    upload.upload();
                }
                
            });
            $('#btndel').FrameButton({

                onClick: function () {
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
                        url: location.href.substring(0, location.href.lastIndexOf('/')) + "/Handler/PolicyAttachment.ashx",
                        timeout: 60000,
                        data: { "DelFullPath": UpLoadUrl, "ActionType": "DelPath"},
                        //添上之后后端接收不到data
                        //contentType: "application/json; charset=utf-8",
                        async: true,
                        dataType: "json",
                        success: function (data) {
                            console.log(data);
                            if (data.Status == "success") {
                                var upload = $("#files").data("kendoUpload");
                                upload.clearAllFiles();
                            }
                            else {

                            }
                           
                        },

                    });
                }
            });
            $('#files').kendoUpload({
                async: {
                    // $.getUrlParam('PolicyId') 
                    saveUrl: location.href.substring(0, location.href.lastIndexOf('/')) + "/Handler/PolicyAttachment.ashx?ForeignType=PromotionKendoUpLoad&ActionType=SecondRate&PolicyId=" + $.getUrlParam('PolicyId'),

                    autoUpload: false
                },
                localization: {
                    select: "上传文件",

                },
                multiple: false,
                success: onSuccess,

            });

            hideLoading();
        })
        var onSuccess = function (e) {
            console.log("onSuccess");
            var data = JSON.parse(e.XMLHttpRequest.response);
            console.log(data);
            if (e.operation == "upload") {
                if (data.FilePath != "") {
                    //获取文件的全路径，删除，解析都用此路径
                    UpLoadUrl = data.FilePath;
                    console.log(UpLoadUrl);
                }

            }
        };
    </script>
</asp:Content>
