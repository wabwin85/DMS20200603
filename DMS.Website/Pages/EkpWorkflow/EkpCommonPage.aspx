<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EkpCommonPage.aspx.cs" Inherits="DMS.Website.Pages.EKPWorkflow.EkpCommonPage" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width,initial-scale=1.0,user-scalable=no">
    <title>蓝威 DMS</title>
    <link rel="stylesheet" href="<%=Page.ResolveUrl("~/Resources/bootstrap-3.3.5/css/bootstrap.min.css") %>" />
    <link rel="stylesheet" href="<%=Page.ResolveUrl("~/Resources/css/common_bootstrap.css") %>" />
    <link rel="stylesheet" href="<%=Page.ResolveUrl("~/Resources/css/common_kendo.css") %>" />
    <link rel="stylesheet" href="<%=Page.ResolveUrl("~/Resources/css/weui.css") %>" />
    <link rel="stylesheet" href="<%=Page.ResolveUrl("~/Resources/Font-Awesome-4.7.0/css/font-awesome.min.css") %>" />

    <script type="text/javascript" src="<%=Page.ResolveUrl("~/Resources/kendo-2017.2.504/js/jquery.min.js") %>"></script>
    <script type="text/javascript" src="<%=Page.ResolveUrl("~/Resources/bootstrap-3.3.5/js/bootstrap.min.js") %>"></script>
    <script type="text/javascript" src="<%=Page.ResolveUrl("~/Resources/js/bootbox.min.js") %>"></script>
    <script type="text/javascript" src="<%=Page.ResolveUrl("~/Resources/FrameJs/common.js") %>"></script>
    <script type="text/javascript" src="<%=Page.ResolveUrl("~/Resources/FrameJs/Kendo/util.js") %>"></script>
    <script type="text/javascript" src="<%=Page.ResolveUrl("~/Resources/FrameJs/Kendo/control.js") %>"></script>
    <script type="text/javascript" src="<%=Page.ResolveUrl("~/Resources/FrameJs/Kendo/window.js") %>"></script>
    <style type="text/css">
        .FormBtn {
            height: 25px;
            width: 60px;
            text-align: center;
            color: white;
            background-color: #1f4e81;
            float: left;
            line-height: 25px;
            font-size: 12px;
            font-weight: normal;
            cursor: pointer;
            margin: 0 5px;
        }

        .panel-main
        {
            width: 100%;
            overflow-y: auto;
        }
        
        .jump-box {
			width: 40px;
			height: 170px;
			position: fixed;
			z-index: 999;
		}

        .jump-box .jump-top {
            height: 36px;
            margin-bottom: 10px;
            display: block;
            position: relative;
            z-index: 1;
        }

		.jump-box .jump-top a:before {
			display: block;
			font-size: 16px;
			line-height: 36px;
			text-align: center;
		}
		
		.jump-box .jump-top a {
			padding: 0;
			width: 40px;
			height: 36px;
			font-size: 0;
			-webkit-font-smoothing: antialiased;
			-moz-osx-font-smoothing: grayscale;
			speak: none;
			font-style: normal;
			font-variant: normal;
			text-transform: none;
			outline: 0;
			zoom: expression(this.runtimeStyle['zoom'] = '1', this.innerHTML = '&#xe6b6;' );
			background: #c8d0d5;
			text-align: center;
			text-indent: 0;
			color: #fff;
			text-decoration: none;
			line-height: 14px;
			position: absolute;
			z-index: 2;
			left: 0;
			top: 0;
			overflow: hidden;
			border-radius: 2px;
			cursor: auto;
		}

        .jump-box .jump-bottom {
            height: 36px;
            margin-bottom: 5px;
            display: block;
            position: relative;
            z-index: 1;
        }

        .jump-box .jump-bottom a:before {
			display: block;
			font-size: 16px;
			line-height: 36px;
			text-align: center;
		}
		
		.jump-box .jump-bottom a {
			padding: 0;
			width: 40px;
			height: 36px;
			font-size: 0;
			-webkit-font-smoothing: antialiased;
			-moz-osx-font-smoothing: grayscale;
			speak: none;
			font-style: normal;
			font-variant: normal;
			text-transform: none;
			outline: 0;
			zoom: expression(this.runtimeStyle['zoom'] = '1', this.innerHTML = '&#xe6b6;' );
			background: #c8d0d5;
			text-align: center;
			text-indent: 0;
			color: #fff;
			text-decoration: none;
			line-height: 20px;
			position: absolute;
			z-index: 2;
			left: 0;
			top: 0;
			overflow: hidden;
			border-radius: 2px;
			cursor: auto;
		}
    </style>
    <script type="text/javascript">
        $(document).ready(function() {
            bootbox.setLocale({
                locale: 'zh_CN'
            });
        })

        Common.AppVirtualPath = "<%=HttpRuntime.AppDomainAppVirtualPath %>";
        if (Common.AppVirtualPath == "/") {
            Common.AppVirtualPath = "";
        }
    </script>
</head>
<body style="margin: 0px; height: 100%; padding: 0px;">
	<%--<div class="jump-box" style="right:5px;top:227px;">
		<div class="jump-top" style="visibility: visible;"><a class="fa fa-chevron-up" href="#top" target="_self">去顶部</a></div>
		<div class="jump-bottom" style="visibility: visible;"><a class="fa fa-chevron-down" href="#bottom" target="_self">去底部</a></div>
	</div>--%>
    <div class="panel-main" >
	<a name="top" >　</a>
    <div class="container" id="mainDiv" >
        
    </div>

    <div class="container" id="ekpApprovelLog" style="padding-top:9px;display:none;">
        <div style="border-top-style: solid;border-top-color: #eee;border-top-width: 1px;padding-top:9px;">
            <span style="color:#1f4e81;font-weight:700;font-size:12px;font-size: 15px;">审批日志：</span>
            <iframe id="historyIrfame" width="100%" scrolling="auto" frameborder="0" ></iframe>
        </div>
    </div>
    <div class="container" id="buttonDiv">
        <div style="width:100%;height:auto;display: none;" id="divApproveRemark">
            <div style="border-top-style: solid;border-top-color: #eee;border-top-width: 1px;padding-top:9px;">
                <span style="color:#1f4e81;font-weight:700;font-size:12px;font-size: 15px;">处理意见：</span>
            </div>
            <textarea id="approveRemark" style="width:50%;height:60px;"></textarea>
        </div>
        <div style="width: 100%; text-align: center; margin: 40px 0 20px 0;">
            <div style="overflow: hidden; display: inline-block">
                <div class="FormBtn" id="btnEdit" style="display: none;" onclick="doEdit();" >修改</div>
                <div class="FormBtn" id="btnApprove" style="display: none;" onclick="showConfirm({
                            target: 'top',
                            message: '确定执行通过吗？',
                            confirmCallback: function () {
                                doApprove();
                            }
                        });" >通过</div>
                <div class="FormBtn" id="btnRefuse" style="display: none;" onclick="showConfirm({
                            target: 'top',
                            message: '确定执行驳回吗？',
                            confirmCallback: function () {
                                doRefuse();
                            }
                        });" >驳回</div>
                <div class="FormBtn" id="btnAbandonByHandler" style="display: none;" onclick="showConfirm({
                            target: 'top',
                            message: '确定执行废弃吗？',
                            confirmCallback: function () {
                                doAbandonByHandler();
                            }
                        });" >废弃</div>
                <div class="FormBtn" id="btnPress" style="display: none;" onclick="showConfirm({
                            target: 'top',
                            message: '确定执行催办吗？',
                            confirmCallback: function () {
                                doPress();
                            }
                        });" >催办</div>
                <div class="FormBtn" id="btnAbandon" style="display: none;" onclick="showConfirm({
                            target: 'top',
                            message: '确定执行撤销吗？',
                            confirmCallback: function () {
                                doAbandon();
                            }
                        });" >撤销</div>
                <div class="FormBtn" id="btnAdditionSignYhu" style="display: none;" onclick="showConfirm({
                            target: 'top',
                            message: '确定执行加签给胡勇吗？',
                            confirmCallback: function () {
                                doAdditionSignYhu();
                            }
                        });" >yhu</div>
                <div class="FormBtn" id="btnAdditionSignYsong" style="display: none;" onclick="showConfirm({
                            target: 'top',
                            message: '确定执行加签给宋宇麒吗？',
                            confirmCallback: function () {
                                doAdditionSignYsong();
                            }
                        });" >ysong</div>
            </div>
        </div>
    </div>
	<a name="bottom" >　</a>
    </div>
    <%--实现整个页面的遮罩--%>
    <div id="loadingToast" class="weui_loading_toast">
        <div class="weui_mask_transparent">
        </div>
        <div class="weui_toast">
            <div class="weui_loading">
                <div class="weui_loading_leaf weui_loading_leaf_0">
                </div>
                <div class="weui_loading_leaf weui_loading_leaf_1">
                </div>
                <div class="weui_loading_leaf weui_loading_leaf_2">
                </div>
                <div class="weui_loading_leaf weui_loading_leaf_3">
                </div>
                <div class="weui_loading_leaf weui_loading_leaf_4">
                </div>
                <div class="weui_loading_leaf weui_loading_leaf_5">
                </div>
                <div class="weui_loading_leaf weui_loading_leaf_6">
                </div>
                <div class="weui_loading_leaf weui_loading_leaf_7">
                </div>
                <div class="weui_loading_leaf weui_loading_leaf_8">
                </div>
                <div class="weui_loading_leaf weui_loading_leaf_9">
                </div>
                <div class="weui_loading_leaf weui_loading_leaf_10">
                </div>
                <div class="weui_loading_leaf weui_loading_leaf_11">
                </div>
            </div>
            <p id="mscont" class="weui_toast_content">
                数据加载中
            </p>
        </div>
    </div>
    <script type="text/javascript">
        var isPC = '<%=!DMS.Common.Common.HtmlHelper.IsMobile() && !DMS.Common.Common.HtmlHelper.IsWeChat() %>';
        var instanceId = '<%=(HttpContext.Current.Items["EkpFormInstance"] as DMS.Model.EKPWorkflow.FormInstanceMaster).ApplyId%>';
        var modelId = '<%=(HttpContext.Current.Items["EkpFormInstance"] as DMS.Model.EKPWorkflow.FormInstanceMaster).modelId%>';
        var templateFormId = '<%=(HttpContext.Current.Items["EkpFormInstance"] as DMS.Model.EKPWorkflow.FormInstanceMaster).templateFormId%>';
        var editNode = {
            "ContractAppointment": "商务审批_平台新建,供应链审批_平台新建,合规审批_平台新建,商务审批_T1新建,供应链审批_T1新建,合规审批_T1新建,商务审批_T2新建,平台培训T2_T2新建",
            "ContractAmendment": "商务审批_平台变更,商务审批_T1变更,商务审批_T2变更",
            "ContractRenewal": "商务审批_平台续签,商务审批_T2续签,商务审批_T1续签,申请_平台续签,申请_T2续签,申请_T1续签,合规审批_平台续签,合规审批_T1续签,平台培训T2_T2续签",
            "ContractTermination": "审批商务_平台终止,商务审批_T1终止,商务审批_T2终止",
            "DealerReturn": "N14,N15",
            "DealerComplain": "N15,N16,N17,N24"
        };
        var canEditApproveModel = new Array("ContractAppointment", "ContractAmendment", "ContractRenewal", "ContractTermination", "DealerReturn", "DealerComplain");
        var doNotAbandonModel = new Array("DealerReturn");
        
        var initLayout = function() {
            $('.panel-main').height($(window).height());
        }

        $(document).ready(function() {
            showLoading();
            $("#mainDiv").html("");
            var data = {};
            data.Id = instanceId;
            data.modelId = modelId;
            data.templateFormId = templateFormId;
            data.MethodName = "GetHtml";
            data.User = '<%=this.userLoginId%>';
            console.log("data.User:" + data.User);

            submitAjax(Common.AppVirtualPath + "/Pages/EKPWorkflow/DmsHtmlHander.ashx", data, function (model) {
                //$("#btnApprove").css("display", "block");
                $("#ekpApprovelLog").css("display", "block");
                $("#mainDiv").append(model.HtmlString);
                var optionList = model.OptionList;
                var editNodeList = null;

                if (editNode[modelId] != null) {
                    editNodeList = editNode[modelId].split(',');
                }

                var canAbandon = true;
                var canApprove = false;
                var canShow = false;
                var isEdit = false;
                var drafterBtnCount = 0;
                var handlerBtnCount = 0
                console.log("isPC:" + isPC);


                console.log(optionList[0]);
                console.log("editNodeList:" + editNodeList);

                if (optionList != null) {
                    if (editNodeList != null) {
                        for (var i = 0; i < optionList.length; i++) {
                            if ($.inArray(optionList[i].nodeId, editNodeList) >= 0) {
                                console.log("nodeId:" + optionList[i].nodeId);
                                isEdit = true;
                                break;
                            }
                        }
                    }
                    console.log("isEdit:" + isEdit);

                    if ($.inArray(model.modelId, canEditApproveModel) >= 0) {
                        canApprove = true;
                    }

                    //当前流程是否可撤销
                    if ($.inArray(model.modelId, doNotAbandonModel) >= 0) {
                        canAbandon = false;
                    }
                    console.log("canApprove:" + canApprove);

                    console.log("model.modelId:" + model.modelId);
                    console.log("canEditApproveModel:" + canEditApproveModel);

                    if (isPC.toUpperCase() == 'FALSE' && isEdit) {
                        showAlert({
                            target: 'top',
                            alertType: 'info',
                            message: "当前节点请到PC端进行审批!"
                        });
                    } else {
                        $.each(optionList, function(index, item) {
                            $.each(item.operations, function(i, j) {
                                if (j.operationType == "drafter_press") {
                                    $("#btnPress").css("display", "block");
                                    canShow = true;
                                    drafterBtnCount++;
                                }
                                if (canAbandon && j.operationType == "drafter_abandon") {
                                    $("#btnAbandon").css("display", "block");
                                    canShow = true;
                                    drafterBtnCount++;
                                }
                                if (j.operationType == "handler_pass") {
                                    if (canApprove || !isEdit) {
                                        $("#btnApprove").css("display", "block");
                                    }
                                    canShow = true;
                                    handlerBtnCount++;
                                }
                                if (j.operationType == "handler_refuse") {
                                    if (canApprove || !isEdit) {
                                        $("#btnRefuse").css("display", "block");
                                    }
                                    canShow = true;
                                    handlerBtnCount++;
                                }
                                if (j.operationType == "handler_abandon") {
                                    //if (canApprove || !isEdit) {
                                    //    $("#btnAbandonByHandler").css("display", "block");
                                    //}
                                    //canShow = true;
                                    //handlerBtnCount++;
                                }
                                if (j.operationType == "handler_additionSign") {
                                    //$("#btnAdditionSignYhu").css("display", "block");
                                    //$("#btnAdditionSignYsong").css("display", "block");
                                    canShow = true;
                                }
                            });
                        });
                    }
                }

                if (canShow) {
                    $("#divApproveRemark").css("display", "block");
                }

                console.log($.inArray(model.modelId, canEditApproveModel));
                console.log("handlerBtnCount:" + handlerBtnCount);
                if ($.inArray(model.modelId, canEditApproveModel) >= 0) {
                    if (handlerBtnCount > 0 && isEdit) {
                        $("#btnEdit").css("display", "block");
                    }
                }

                if (model.EkpIframeUrl != null && model.EkpIframeUrl != "") {
                    $("#historyIrfame").attr('src', model.EkpIframeUrl);
                    $("#historyIrfame").height(300);
                } else {
                    $("#historyIrfame").removeAttr('src');
                    $("#historyIrfame").height(0);
                }

                hideLoading();


            });

            if (top != self) {
                initLayout();
                $(window).resize(function() {
                    initLayout();
                })

                setTimeout('initLayout()', 1000);
            }
        });

        var iframe = document.getElementById("historyIrfame");
        if (iframe != null && typeof (iframe) != "undefined") {
            window.onmessage = function(e) {
                e = e || event;
                iframe.style.cssText = e.data + 'px';
            }
        }

        var doEkpFun = function(id, methodName, remark, message) {
            showLoading();
            var data = {};
            data.Id = id;
            data.MethodName = methodName;
            data.modelId = modelId;
            data.templateFormId = templateFormId;
            data.Remark = remark;
            data.User = '<%=this.userLoginId%>';

            submitAjax(Common.AppVirtualPath + "/Pages/EKPWorkflow/DmsHtmlHander.ashx", data, function(model) {

                if (model.MethodName == "DoEdit") {
                    url = model.RedirectUrl;
                    if (url.match("[\?]")) {
                        url += "&ReturnUrl=" + escape(window.location.href);
                    } else {
                        url += "?ReturnUrl=" + escape(window.location.href);
                    }
                    window.location.href = url;
                } else {
                    showAlert({
                        target: 'top',
                        alertType: 'info',
                        message: message,
                        callback: function() {
                            window.location.href = $.updateUrlParams(window.location.href, "v", Math.round(Math.random() * 100));
                        }
                    });

                    hideLoading();
                }
            });
        }

        var doApprove = function() {
            doEkpFun(instanceId, "DoApprove", $("#approveRemark").val(), "通过成功!");
        }

        var doRefuse = function() {
            if ($("#approveRemark").val() == "") {
                showAlert({
                    target: 'top',
                    alertType: 'error',
                    message: '请填写处理意见！'
                });
            } else {
                doEkpFun(instanceId, "DoRefuse", $("#approveRemark").val(), "驳回成功!");
            }
        }

        var doPress = function() {
            doEkpFun(instanceId, "DoPress", $("#approveRemark").val(), "催办成功!");
        }

        var doAbandon = function() {
            doEkpFun(instanceId, "DoAbandon", $("#approveRemark").val(), "撤销成功!");
        }

        var doAbandonByHandler = function() {
            doEkpFun(instanceId, "DoAbandonByHandler", $("#approveRemark").val(), "废弃成功!");
        }

        var doAdditionSignYhu = function() {
            doEkpFun(instanceId, "DoAdditionSignYHU", $("#approveRemark").val(), "加签成功!");
        }

        var doAdditionSignYsong = function() {
            doEkpFun(instanceId, "DoAdditionSignYSONG", $("#approveRemark").val(), "加签成功!");
        }

        var doEdit = function() {
            doEkpFun(instanceId, "DoEdit", $("#approveRemark").val(), "");
        }
    </script>
</body>
</html>
