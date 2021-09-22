<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterPageKendo/Site.Master" CodeBehind="UploadFile.aspx.cs" Inherits="DMS.Website.PagesKendo.ContractElectronic.LPTOne.UploadFile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="StyleContent" runat="server">
    <link href="../style/MyComon.css" rel="stylesheet" />
    <style>
        a {
            color: black;
            cursor:pointer;
        }
        a:hover {
            color: black;
            cursor:pointer;
        }
        .section {
            height: 42px;
            margin: 10px;
            padding: 5px;
            background-color: #D9EDF6;
            border: 1px solid #337ab7;
            border-radius: 4px;
            box-shadow: 0 1px 1px rgba(0,0,0,.05);
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="content-row" id="PnlContractBase" style="padding: 10px 10px 0px 10px;">
        <div class="panel panel-primary">
            <div class="panel-heading">
                <h3 class="panel-title"><i class='fa fa-navicon' style="padding-left: 15px;"></i>&nbsp;经销商合同附件上传</h3>
            </div>
            <div class="panel-body" id="PnlContractContent" style="overflow: auto;">
                <table style="width: 100%;" class="KendoTable">
                    <tr style="height: 36px;" class="ProxyTemplate">
                        <td style="width:200px;"><i class='fa fa-blank'></i>合同其它附件</td>
                        <td>
                            <div style="display: inline-block;">
                                <button id="BtnDownLoadProxyTemplate" class="" style="margin-right: 30px; width: 150px;"><i class='fa fa-cloud-download'></i>&nbsp;&nbsp;下载其他附件模版（波科品牌）</button>
                                <button id="BtnUploadProxy" class="" style="margin-right: 30px;"><i class='fa fa-cloud-upload'></i>&nbsp;&nbsp;上传文件</button>
                            </div>
                            <div style="display: none;">
                                <input type="file" id="UploadProxyfiles" name="files" style="display: none;" />
                            </div>
                            <div style="display: none;" id="DivUploadProxy" class="FrameControl"></div>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ScriptContent" runat="server">
    <script type="text/javascript" src="../script/MyCommon.js?v=6"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#BtnUploadProxy").attr({ "data-tmpid": NewGuid(), "data-file": "OtherAttachment", "data-type": "OtherAttachment" });
            
            $('#UploadProxyfiles').kendoUpload({
                async: {
                    saveUrl: Common.AppVirtualPath + "pageskendo/ContractElectronic/handlers/UploadHandler.ashx?Type=OtherAttachment&NewFileName=" + NewGuid(),
                    autoUpload: true
                },
                select: function (e) {
                    var file = e.files;
                    if (file[0].extension != '.pdf') {
                        showAlert({
                            target: 'top',
                            alertType: 'info',
                            message: '仅支持PDF上传',
                        });
                    }

                },
                validation: {
                    allowedExtensions: [".pdf"],
                },
                multiple: false,
                success: function (e) {
                    $("#BtnUploadProxy").FrameSortAble("FileaddNewData", e.response);
                }
            });

            $('#BtnUploadProxy').FrameButton({
                onClick: function () {
                    document.getElementById('UploadProxyfiles').click();
                }
            });

            $('#BtnDownLoadProxyTemplate').FrameButton();

            initUploadFile();

        })

        function S4() {
            return (((1 + Math.random()) * 0x10000) | 0).toString(16).substring(1);
        }

        var NewGuid = function () {
            return (S4() + S4() + "-" + S4() + "-" + S4() + "-" + S4() + "-" + S4() + S4() + S4());
        };

        function GetModel(method) {
            var model = {};
            model.Method = method;
            return model;
        }

        function initUploadFile() {
            var data = GetModel('InitUploadFile');

            submitAjax(Common.AppVirtualPath + "PagesKendo/ContractElectronic/handlers/LPAndT1Handler.ashx", data, function (model) {
                
                if (model.IsSuccess) {

                    var fileData = model.FileData;
                    if (fileData != undefined && fileData != null && fileData != "") {

                        var value = { FilePath: fileData.UploadFilePath, FileName: fileData.UploadFileName, Type: fileData.FileType };
                        //console.log(value);
                        $("#BtnUploadProxy").FrameSortAble("FileaddNewData", value);
                    }

                    var templateData = model.UploadTemplateFileData;
                    if (templateData != undefined && templateData != null && templateData.length > 0) {

                        var curWwwPath = window.document.location.href;
                        var pos = curWwwPath.indexOf(window.document.location.pathname);
                        $('#BtnDownLoadProxyTemplate').FrameButton({
                            onClick: function () {
                                window.location = curWwwPath.substring(0, pos) + templateData[0].TemplateFile;
                            }
                        });
                    } else {
                        $('#BtnDownLoadProxyTemplate').FrameButton({
                            onClick: function () {
                                showAlert({
                                    target: 'top',
                                    alertType: 'error',
                                    message: '没有该类型的下载模板',
                                });
                            }
                        });
                    }

                    hideLoading();
                }
            });
        }

        function submitUploadFile()
        {
            //console.log($("a.UserFile").FrameSortAble("gatherFileInfo"));
            var fileData = $("a.UserFile").FrameSortAble("gatherFileInfo");
            
            if (fileData.length == 0) {
                showAlert({
                    target: 'top',
                    alertType: 'error',
                    message: '请上传附件',
                });
                return;
            }

            var data = GetModel('SubmitUploadFile');

            data.FilePath = fileData[0].FilePath;
            data.FileName = fileData[0].TmpName;

            submitAjax(Common.AppVirtualPath + "PagesKendo/ContractElectronic/handlers/LPAndT1Handler.ashx", data, function (model) {
                if (model.IsSuccess) {
                    
                    showAlert({
                        target: 'top',
                        alertType: 'info',
                        message: '提交成功',
                    });
                    hideLoading();
                }
            });
            
        }
    </script>
</asp:Content>
