<%@ Page Language="C#" MasterPageFile="~/MasterPageKendo/Site.Master"  AutoEventWireup="true" CodeBehind="EnterpriseSealList.aspx.cs" Inherits="DMS.Website.PagesKendo.ESign.EnterpriseSealList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="StyleContent" runat="server">
    <style>
        .k-textbox {
            width: 100%;
        }
        .square-radio {
            height: 97px;
        }
        .square {
            width: 97px;
        }

        .customer-photo {
            display: inline-block;
            width: 50px;
            /*height: 50px;*/
            border-radius: 50%;
            background-size: 50px 50px;
            background-position: center center;
            vertical-align: middle;
            line-height: 50px;
            box-shadow: inset 0 0 1px #999, inset 0 0 10px rgba(0,0,0,.2);
            margin-left: 20px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="content-main">
        <input type="hidden" id="hiddenDealerId" />
        <input type="hidden" id="hiddenSubDealerId" />
        <input type="hidden" id="hiddenDealerName" />
        <input type="hidden" id="hiddenAccountUId" />
        <input type="hidden" id="hiddenLastUpdateDate" />
        <div class="content-row" style="padding: 10px 10px 0px 10px;">
            <div class="panel panel-primary">
                <div class="panel-heading">
                    <h3 class="panel-title"><i class='fa fa-navicon' style="padding-left: 15px;"></i>&nbsp;企业用户制章</h3>
                </div>
            </div>
        </div>
        <div class="panel-body" id="PnlInfo">
            <table style="width: 100%" class="KendoTable">
                <tr style="line-height:1px;">
                    <td style="width: 100px;height:1px;">&nbsp;</td>
                    <td style="width: 80%;height:1px;">&nbsp;</td>
                </tr>
                <tr>
                    <td class="lableControl">
                        <label class="lableControl"><span class="required">*</span>&nbsp; 机构名称：</label></td>
                    <td>
                        <input type="text" class="k-textbox" id="txtOrganName" disabled="disabled" />
                </tr>
                <tr>
                    <td>
                        <label class="lableControl"><span class="required">*</span>&nbsp; 模板类型：</label></td>
                    <td>
                        <label class="radio-inline">
                            <input type="radio" class="square-radio" name="templateTypeRadios" id="modelType1" value="STAR" checked>
                            <img src="../../resources/images/ESign/ent-1.png" class="square">
                        </label>
                        <label class="radio-inline">
                            <input type="radio" class="square-radio" style="height: 65px;" name="templateTypeRadios" id="modelType2" value="OVAL" >
                            <img src="../../resources/images/ESign/ent-2.png" class="square">
                        </label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <label class="lableControl"><span class="required" style="color:#ffffff;">*</span>&nbsp; 横向文：</label></td>
                    <td>
                        <input type="text" class="k-textbox" id="txtHText" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <label class="lableControl"><span class="required" style="color:#ffffff;">*</span>&nbsp; 下弦文：</label></td>
                    <td>
                        <input type="text" class="k-textbox" id="txtQText" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <label class="lableControl"><span class="required">*</span>&nbsp; 印章类型：</label></td>
                    <td>
                        <label class="radio-inline">
                            <input type="radio" name="colorRadios" id="sealType1" value="RED" checked>红
                        </label>
                        <label class="radio-inline">
                            <input type="radio" name="colorRadios" id="sealType2" value="BLUE" >蓝
                        </label>
                        <label class="radio-inline">
                            <input type="radio" name="colorRadios" id="sealType3" value="BLACK" >黑
                        </label>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <div style="text-align: right; height: 40px;">
                            <button id="BtnSubmit" class="size-14"><i class="fa fa-hand-pointer-o"></i>&nbsp;&nbsp;提交&nbsp;</button>
                        </div>
                    </td>
                </tr>
            </table>
        </div>

        <div class="content-row" style="padding: 10px 10px 0px 10px;">
            <div class="panel panel-primary">
                <div class="panel-heading">
                    <h3 class="panel-title"><i class='fa fa-navicon' style="padding-left: 15px;"></i>&nbsp;企业印章列表</h3>
                </div>
            </div>
        </div>
        <div class="panel-body" >
            <div id="SealList" style="margin: 10px 7px 0 7px;">
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptContent" runat="server">
    <script type="text/javascript">
        var handlerPath = Common.AppVirtualPath + "PagesKendo/ESign/handler/ESignHandler.ashx";

        function GetModel(methodName) {
            var reqData = {
                DealerId: $("#hiddenDealerId").val(),
                SubDealerId: $("#hiddenSubDealerId").val(),
                DealerName: $("#hiddenDealerName").val(),
                OrganName: $("#txtOrganName").val(),
                EmId: $("#hiddenEmId").val(),
                AccountUid: $("#hiddenAccountUId").val(),
                HText: $("#txtHText").val(),
                QText: $("#txtQText").val(),
                TemplateType: $('input[name="templateTypeRadios"]:checked').val(),
                Color: $('input[name="colorRadios"]:checked').val(),
                Seal: ""
            }
            var data = {
                Function: "EnterpriseSeal",
                Method: methodName,
                LastUpdateDate: $("#hiddenLastUpdateDate").val(),
                ReqData: JSON.stringify(reqData)
            }
            return data;
        }

        $(document).ready(function () {
            $("#BtnSubmit").FrameButton({
                onClick: function () {
                    SubmitSeal();
                }
            });

            hideLoading();

            InitPage();
        });

        function InitPage() {
            showLoading();
            var data = GetModel('Init');
            submitAjax(handlerPath, data, function (model) {

                var d = JSON.parse(model.ResData).data[0];
                var list = JSON.parse(model.ResData).historyList;

                if (d != undefined && d != null) {
                    $("#txtOrganName").val(d.OrganName);
                    $("#hiddenDealerId").val(d.DmaId);
                    $("#hiddenSubDealerId").val(d.ParentDmaId);
                    $("#hiddenDealerName").val(d.DealerName);
                    $("#hiddenAccountUId").val(d.AccountUid);
                }
                bindGrid(list);

                hideLoading();
            });
        }

        function SubmitSeal() {
            showLoading();
            var data = GetModel('Create');
            submitAjax(handlerPath, data, function (model) {
                showAlert({
                    target: 'top',
                    alertType: 'info',
                    message: '提交成功',
                    callback: function () { InitPage(); }
                });
                hideLoading();
            });
        }

        function bindGrid(dataSource) {
            $("#SealList").kendoGrid({
                dataSource: dataSource,
                resizable: true,
                scrollable: false,
                editable: false,
                columns: [
                    {
                        template: "<img class='customer-photo'" +
                                       "src='data:image/png;base64,#:data.Seal#'/>",
                        field: "Seal",
                        title: "企业印章",
                        headerAttributes: { "class": "center bold", "title": "企业印章" },
                        width: 100
                    },
                    { field: "OrganName", title: "机构名称", headerAttributes: { "class": "center bold", "title": "经销商名称" } },
                    { field: "IsActive", title: "状态", headerAttributes: { "class": "center bold", "title": "状态" }, width: 100 },
                    { field: "CreateDate", title: "创建时间", headerAttributes: { "class": "center bold", "title": "创建时间" }, width: 200 },
                    {
                        title: "下载",
                        field: "download",
                        template: "<a id=\"downloadImage\" ><span style=\"font-size:20px;\" class=\"fa fa-download\"></span></a>",
                        width: 50,
                        headerAttributes: { "class": "center bold", "title": "下载" },
                        attributes: { "class": "center", "data-name": "download" }
                    }
                ], dataBound: function () {

                    $("a[id=downloadImage]").bind("click", function (e) {
                        var row = $(this).closest("tr"),
                            grid = $("#SealList").data("kendoGrid"),
                            dataItem = grid.dataItem(row);

                        var data = GetModel('DownloadSeal');

                        var obj = JSON.parse(data.ReqData);

                        obj.Seal = dataItem.Seal;

                        data.ReqData = JSON.stringify(obj);

                        showLoading();
                        submitAjax(handlerPath, data, function (model) {

                            $("#divContractContent").text("");
                            var content = "";
                            var jsonData = JSON.parse(model.ResData);
                            
                            downloadFile(jsonData.imageUrl, '印章.png', 'temp');

                            hideLoading();
                        });

                    });
                }
            });
        }


        downloadFile = function (Name, Url, FileType) {
            var url = '../Download.aspx?filename=' + escape(Name) + '&downloadname=' + escape(Url) + '&foldername=' + escape(FileType);
            open(url, 'Download');
        }
    </script>
</asp:Content>