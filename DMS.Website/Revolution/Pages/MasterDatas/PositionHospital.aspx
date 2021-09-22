<%@ Page Title="" Language="C#" MasterPageFile="~/Revolution/MasterPage/Site.Master" AutoEventWireup="true" CodeBehind="PositionHospital.aspx.cs" Inherits="DMS.Website.Revolution.Pages.MasterDatas.PositionHospital" %>
<asp:Content ID="Content1" ContentPlaceHolderID="StyleContent" runat="server"> 
    <style>
        .k-split-button {
            margin-top: 5px!important;
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

        .selectAll {
            margin: 17px 0;
        }

        #result {
            color: #9ca3a6;
            float: right;
        }

        #treeview {
            margin: 10px 0 0 0;
            height: 410px;
            overflow-y: auto;
            border: 1px solid #428bca;
        }

        #openWindow {
            min-width: 180px;
        }

        /*节点图片*/
        /*#treeview-sprites .k-sprite {
            background-image: url("../content/web/treeview/coloricons-sprite.png");
        }*/

        .position {
            color: darkgreen;
            font-size: 16px;
        }

        .position-notsr {
            color: darkred;
            font-size: 16px;
        }

        #grid a.k-button {
            min-width: 0;
        }
    </style>
</asp:Content>
<asp:Content ID="ContentHead" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <span id="cornerNotification" style="display: none;"></span>

    <div class="k-content">
        <div id="Splitter" style="height: 490px;">
            <div id="left-pane" title="">
                <div id="dialog">
                    <div class="dialogContent">
                        <input id="filterText" type="text" placeholder="搜索关键字" />
                        <div id="treeview"></div>
                        <div>
                            <span class="k-sprite fa fa-street-view position"></span>岗位已配置用户
                            <span class="k-sprite fa fa-street-view position-notsr"></span>岗位未配置用户或效期已过
                        </div>
                    </div>
                </div>
            </div>
            <div id="center-pane" title="">
                <div id="grid"></div>
                
                <script type="text/x-kendo-template" id="template_toolbar">
                    <div id="toolbar" style="border: none;">
                        <a id="btnAdd" class="btn btn-primary fa fa-plus-circle" disabled="disabled" onclick="PositionHospital.openAddHospitalDialog(this)">&nbsp;&nbsp;新增</a>
                        
                        <div class="btn-group pull-right">
                          <button type="button" class="btn btn-default" style="margin-right:0 !important;">批量操作</button>
                          <button type="button" class="btn btn-default dropdown-toggle" id="btnBatch" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                            <span class="caret"></span>
                          </button>
                          <ul class="dropdown-menu" aria-labelledby="btnBatch">
                            <li><a class="fa fa-close" onclick="PositionHospital.deleteSelected()">删除选中</a></li>
                            <li><a class="fa fa-close" onclick="PositionHospital.deleteAll()">删除全部</a></li>
                            <li><a class="fa fa-download" onclick="PositionHospital.showWindow()">Excel导入</a></li>
                            <li><a class="fa fa-upload" onclick="PositionHospital.doExportExcel()">Excel导出</a></li>
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
      

         <div id="dlgImport" style="display:none;height:380px;">
        <style>
            #dlgImport .row {
                margin: 0px;
            }
        </style>
        <div class="row">
            <div class="box box-primary">
                <div class="box-body">
                    <div class="row">
                        <div class="col-xs-12 col-group">
                            <div class="col-xs-1 col-label">
                                <i class="fa fa-fw fa-require"></i>文件：
                            </div>
                            <div class="col-xs-10 col-field">
                                <input name="files" id="filePositionHospital" type="file" aria-label="files" />
                            </div>
                        </div>                                     
                    </div>
                    <div class="row">
                        <div class="col-buttom" style="text-align:center;">                           
                            <a id="BtnImport"></a>
                            <a id="BtnDownTmp"></a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="box box-primary">
                <div class="box-header with-border">
                    <h3 class="box-title"><i class='fa fa-fw fa-exclamation-triangle' style="color:orangered"></i>&nbsp;导入信息</h3>
                </div>
                <div class="box-body" style="padding: 0px;">
                    <div class="row">
                        <div id="RstUploadInfo" class="k-grid-page-20"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
        <input id="selectedNodePositionID" type="hidden" />
        <input id="selectedNodeProductLineID" type="hidden" />
        <input id="selectedNodeProductLineName" type="hidden" />
        <input id="page" type="hidden" />
        <input id="pageSize" type="hidden" />
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="FootContent" runat="server">
    <div class="foot-bar">
        <a id="btnSave" class="form-btn btn btn-primary fa fa-save pull-right" onclick="PositionHospital.saveChanges();">保存</a>
    </div>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="ScriptContent" runat="server">
<script type="text/javascript" src="Script/PositionHospital.js?v=<%=DMS.Common.SR.CONST_JAVA_SCRIPT_VERSION %>"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            PositionHospital.Init();
        });
    </script>
</asp:Content>
