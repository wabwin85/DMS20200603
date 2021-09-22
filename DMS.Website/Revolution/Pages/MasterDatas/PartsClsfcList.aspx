<%@ Page Title="" Language="C#" MasterPageFile="~/Revolution/MasterPage/Site.Master" AutoEventWireup="true" CodeBehind="PartsClsfcList.aspx.cs" Inherits="DMS.Website.Revolution.Pages.MasterDatas.PartsClsfcList" %>

<asp:Content ID="ContentStyle" ContentPlaceHolderID="StyleContent" runat="server">
    <style>
        .k-split-button {
            margin-top: 5px !important;
        }

        .dialogContent {
            padding: 10px 10px 0 10px;
        }

        #filterText {
            width: 100%;
            box-sizing: border-box;
            padding: 6px;
            border-radius: 3px;
            border: 1px solid #428bca;
        }

        #treeview {
            margin: 5px 0 0 0;
            height: 450px;
            overflow-y: auto;
            border: 1px solid #428bca;
        }

        .bottom {
            float: left;
            width: 100%;
            text-align: right;
            margin-top: 30px;
            margin-bottom: 5px;
        }

        .k-state-border-down {
            background: none !important;
            color: red;
        }

        .col-group .col-label {
            width: 30%;
            display: inline-block;
        }

        .col-group .col-field {
            width: 60%;
            display: inline-block;
        }
    </style>
</asp:Content>
<asp:Content ID="ContentHead" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="ContentMain" ContentPlaceHolderID="MainContent" runat="server">
    <span id="cornerNotification" style="display: none;"></span>
    <div class="k-content">
        <div id="divSplit" style="height: 502px;">
            <div id="left-pane" title="">
                <div id="dialog">
                    <div class="dialogContent">
                        <div>
                            <span>产品线：</span><div id="QryProductLine" class="FrameControl" style="display: inline-flex; min-width: 60%;"></div>
                        </div>
                        <input id="filterText" type="text" placeholder="搜索关键字" style="display: none;" />
                        <div id="treeview"></div>
                    </div>
                </div>
            </div>
            <div id="center-pane" title="" class="panel panel-default panel-result" style="border: 0; width: 940px;">
                <div class="content"><div id="RstContainProduct"></div></div>

                <script type="text/x-kendo-template" id="template_toolbar">
                    <div id="toolbar" style="border: none;">
                        <a id="btnAdd" class="btn btn-primary fa fa-plus-circle" disabled="disabled" onclick="PartsClsfcList.openAddCFNDialog(this)">&nbsp;&nbsp;新增</a>
                        
                        <div class="btn-group pull-right">
                          <button type="button" class="btn btn-default" style="margin-right:0 !important;">批量操作</button>
                          <button type="button" class="btn btn-default dropdown-toggle" id="btnBatch" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                            <span class="caret"></span>
                          </button>
                          <ul class="dropdown-menu" aria-labelledby="btnBatch">
                            <li><a class="fa fa-close" onclick="PartsClsfcList.deleteSelected()">删除选中</a></li>
                            <li><a class="fa fa-close" onclick="PartsClsfcList.deleteAll()">删除全部</a></li>
                          </ul>
                        </div>
                    </div>
                </script>
                <script type="text/x-kendo-template" id="template_operation">
                    <ul class="ul-toolbar">
                        <li class="li-toolbar" style="width: 30px;">
                            <a class="k-grid-delete" href="\#">删除</a>
                        </li>
                    </ul>
                </script>

            </div>
        </div>
        <div class="slide-panel" id="RightEditShow" style="display:none;height:560px;">
           
            <div class="slide-panel-body">
                <div class="slide-panel-form">
                    <div class="slide-panel-form-body">
                        <div id="hidecon" class="panel panel-default">
                            <div class="panel-body">
                                <div class="col-xs-12 col-sm-12 col-md-8 col-group">
                                    <div class="col-label">
                                        <label class="lableControl">产品线：</label>
                                    </div>
                                    <div class="col-field">
                                        <div id="WinProductLine" class="FrameControl" style="display: inline-flex; min-width: 60%;"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-12 col-md-8 col-group">
                                    <div class="col-label">
                                        <label class="lableControl">产品型号：</label>
                                    </div>
                                    <div class="col-field">
                                        <input id="cfn" class="k-textbox" style="display: inline-flex; min-width: 60%;"/>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-12 col-md-8 col-group">
                                    <div class="col-label">
                                        <label class="lableControl">是否已包含分类：</label>
                                    </div>
                                    <div class="col-field">
                                        <div id="WinIsContain" class="FrameControl" style="display: inline-flex; min-width: 60%;"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="panel panel-default panel-result">
                            <div class="content">
                                <div id="RstProductInfo">
                                    <script type="text/x-kendo-template" id="template"> 
                                    <a id="btnAddCfn" class="btn btn-primary pull-right fa fa-plus" href="javascript:void(0);" onclick="PartsClsfcList.AddCfn();">添加</a>                                             
                                    <a id="btnSearch" class="btn btn-primary pull-right fa fa-search" href="javascript:void(0);" onclick="PartsClsfcList.reloadProductInfo();">查询</a>                           
                                    </script>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="slide-panel-foot">
                    <a id="btnCancel" class="btn btn-default fa fa-times-circle">关闭</a>
                </div>
            </div>
        </div>
        <ul id="contentMenu">
            <li id="liMenuAdd">
                <span class="k-icon k-i-plus "></span>新增分类
            </li>
            <li class="k-separator"></li>
            <li>
                <span class="k-icon k-i-edit "></span>编辑分类
            </li>
            <li class="k-separator"></li>
            <li>
                <span class="k-icon k-i-delete k-i-trash"></span>删除分类
            </li>
        </ul>
        <div class="modal" id="popoverModal" aria-hidden="true" style="background-color: black; opacity: 0.5; display: none;">
        </div>
        <script type="text" id="template_popover">
            <div>
                <div class="row">
                    <div class="col-xs-12 col-group">
                        <div class="col-label">
                            <label class="lableControl" id="lblPartName">分类名称：</label>
                        </div>
                        <div class="col-field">
                            <input id="txtPartName" type="text" class="k-textbox form-control" data-bind="value: ProductLineName" />
                        </div>
                    </div>
                    <div class="col-xs-12 col-group">
                        <div class="col-label">
                            <label class="lableControl">分类英文名称：</label>
                        </div>
                        <div class="col-field">
                            <input id="txtPartENName" type="text" class="k-textbox form-control" data-bind="value: ProductLineName" />
                        </div>
                    </div>
                    <div class="col-xs-12 col-group">
                        <div class="col-label">
                            <label class="lableControl">Code：</label>
                        </div>
                        <div class="col-field">
                            <input id="txtPartCode" type="text" class="k-textbox form-control" data-bind="value: ProductLineName" />
                        </div>
                    </div>
                    <div class="col-xs-12 col-group">
                        <div class="col-label">
                            <label class="lableControl">描述：</label>
                        </div>
                        <div class="col-field">
                            <input id="txtPartDes" type="text" class="k-textbox form-control" data-bind="value: ProductLineName" />
                        </div>
                    </div>
                    <div class="col-xs-12 col-group">
                        <div class="col-label">                                                         
                            <label class="lableControl">父类Code：</label>
                        </div>
                        <div class="col-field">
                            <label id="lblParentCode" />
                        </div>
                    </div>
                    <div class="col-xs-12 col-group">
                        <div class="col-label">                                                         
                            <label class="lableControl">父类节点：</label>
                        </div>
                        <div class="col-field">
                            <label id="lblParentName" />
                        </div>
                    </div>
                </div>
                <div class="bottom">
                    <a id="cancel" class="btn btn-default pull-right fa fa-close" href="javascript:void(0);" onclick="PartsClsfcList.CloseLimWin();">取消</a>
                    <a id="save" class="btn btn-default pull-right fa fa-save" href="javascript:void(0);" onclick="PartsClsfcList.savePartsCls();">保存</a>
                </div>
            </div>
        </script>
        <input id="hidRootId" type="hidden" value="00000000-0000-0000-0000-000000000000" />
        <input id="hidSelectNodeId" type="hidden" value="" />
        <input id="ClsNode" type="hidden" class="FrameControl" />
        <input id="hidSelectIsLeafNode" type="hidden" />
        <input id="hidSelectProductLineId" type="hidden" value="00000000-0000-0000-0000-000000000000" />
        <input id="hidOperatePartType" type="hidden" />
        <input id="hidHasAddCFNFlag" type="hidden" />
    </div>
</asp:Content>
<asp:Content ID="ContentFoot" ContentPlaceHolderID="FootContent" runat="server">
    <div class="foot-bar">
        <a id="btnSave" class="form-btn btn btn-primary fa fa-save pull-right" onclick="PartsClsfcList.saveChanges();">保存</a>
    </div>
</asp:Content>
<asp:Content ID="ContentScript" ContentPlaceHolderID="ScriptContent" runat="server">
    <script type="text/javascript" src="Script/PartsClsfcList.js?v=<%=DMS.Common.SR.CONST_JAVA_SCRIPT_VERSION %>"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            PartsClsfcList.Init();
        });
        $("#filterText").keyup(function (e) {
            var treeview = $("#treeview").data("kendoTreeView");
            var filterText = $(this).val().trim();

            if (filterText !== "") {
                //treeview.dataSource.filter({
                //    field: "Name",
                //    operator: "contains",
                //    value: filterText
                //});
                $("#treeview .k-group .k-in").closest("li").hide();
                $("#treeview .k-group .k-in:containsCI(" + filterText + ")").each(function () {
                    $(this).parents("ul, li").each(function () {
                        $(this).show();
                    })
                });
            } else {
                //treeview.dataSource.filter({});
                $("#treeview .k-group").find("ul").hide();
                $("#treeview .k-group").find("li").show();
            }
        });
    </script>
</asp:Content>
