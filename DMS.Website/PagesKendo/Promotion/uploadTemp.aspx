<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageKendo/Site.Master" AutoEventWireup="true" CodeBehind="uploadTemp.aspx.cs" Inherits="DMS.Website.PagesKendo.Promotion.uploadTemp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="StyleContent" runat="server">

    <style>
        li.k-file div.file-wrapper {
            position: relative;
            height: 20px;
        }

        .a-content {
            color: #444;
            background-color: #fff;
            border-color: #e6e6e6;
            outline: 0;
            -webkit-tap-highlight-color: rgba(0,0,0,0);
            font-size: 14px;
            font-weight: 500;
            font-family: Arial, Helvetica, sans-serif;
            padding: 5px;
            margin: 10px;
        }

        .a-div {
            line-height: normal;
            border-style: solid;
            background-color: #fff;
            border-width: 1px;
            border-color: #e6e6e6;
            border-radius: 2px;
            -webkit-appearance: none;
            position: relative;
            box-shadow: none;
            background-position: 50% 50%;
            display: block;
            padding: 4px;
            line-height: 16px;
            padding: 6px 10px;
            min-width: 30px;
            margin-right: 16px;
            vertical-align: middle;
            text-align: center;
        }

        .a-dropzone {
            position: relative;
            border-width: 0;
            background-color: transparent;
        }

        .a-button {
            font-weight: 500;
            border-radius: 2px;
            color: #444;
            border:solid 1px #000000;
            border-color: #fafafa;
            background-color: #fafafa;
            line-height: 16px;
            padding: 6px 10px;
            min-width: 30px;
            margin-right: 16px;
            position: relative;
            overflow: hidden;
            vertical-align: middle;
            display: inline-block;
            margin: 0;
            font-family: inherit;
            text-align: center;
            cursor: pointer;
            text-decoration: none;
        }

        .a-input {
            position: absolute;
            bottom: 0;
            right: 0;
            z-index: 1;
            font: 170px monospace !important;
            opacity: 0;
            margin: 0;
            padding: 0;
            cursor: pointer;
            background-color: initial;
            user-select: text;
            text-rendering: auto;
            letter-spacing: 0;
            word-spacing: normal;
            text-transform: none;
            text-indent: 0px;
            text-shadow: none;
            display: inline-block;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="panel panel-primary">
        <!-- Default panel contents -->
        <div class="panel-heading">
            <h3 class="panel-title"><i class='fa fa-navicon' style="padding-left: 15px;"></i>&nbsp;请选择要上传的文件</h3>
        </div>
        <div class="panel-body" style="padding: 0px;">
            <div id="UpLoadTemplate">
                <div style="margin: 10px 15px 0px 15px; padding:0px; height: auto;display:none;">

                    <input name="files" id="files" style="margin:0px;padding:0px;" type="file" />
  

                </div>
              <button id="btnDown" class="KendoButton size-14">下载</button>
                <div style="text-align: center; position: relative; margin: 10px 20px 10px 0px;">
                    <button id="btnParse" class="KendoButton size-14">解析上传的文件</button>
                    <button id="btnDownloadTemplate" class="KendoButton size-14">下载模板</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ScriptContent" runat="server">

    <script type="text/javascript">


        $(document).ready(function () {

            $('#btnDown').FrameButton({
                onClick: function () {
                    document.getElementById('files').click();
                }
            });
            $('#files').kendoUpload({
                async: {
                    saveUrl: "save",
                    //saveUrl: location.href.substring(0, location.href.lastIndexOf('/')) + "/Handler/UpLoad.ashx?ForeignType=PromotionKendoUpLoad&ActionType=SecondRate&SheetName=sheet1&FiledCount=5&MaintainType=TopVal&TopvalType=123&PolicyID=1",
                    autoUpload: true
                },
                localization: {
                    select: "上传文件",
                    remove: "Remove"
                },
                multiple: false,
                success: onSuccess,
                select: onSelect,
              
            });

            hideLoading();
        });
        var onSelect = function (e) {
            //if (e.operation == "upload") {
            //    var upload = $("#files").data("kendoUpload");
            //    upload.removeAllFiles();
            //}
            //console.log("onselect");
            alert("success");

        }
        var onSuccess = function (e) {
            console.log("onSuccess");
            var data = JSON.parse(e.XMLHttpRequest.response);
            console.log(data);
            if (e.operation == "upload") {
                if (data.Status == "success") {
                    if (data.FilePath != "") {
                        //filePath = data.FilePath;
                        UpLoadUrl = data.FilePath;
                        console.log(UpLoadUrl);
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
            }

        }
    </script>
</asp:Content>
