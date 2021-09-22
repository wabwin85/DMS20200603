(function ($) {
    $.MySelectedAll = function (param1) {

        if ($('#' + param1).text() == "全选") {
            $('#' + param1).text("取消");
            $('#' + param1).removeClass("btn-primary");
            $('#' + param1).addClass("btn-danger");
            $(".item").each(function () {
                $(this).css({ "background": "#337AB7", "color": "#fff" });
                $(this).data("isclick", true);
               
                if ($(this).attr("data-tmp-Name") == "法人代表授权委托书") {
                    $("#BtnUploadProxy").attr("data-tmpid", $(this).attr("id"));
                }
                else if ($(this).attr("data-tmp-Name") == "提货授权委托书") {
                    $("#BtnUploadGoods").attr("data-tmpid", $(this).attr("id"));
                }
            });
        } else {
            $('#' + param1).text("全选");
            $('#' + param1).removeClass("btn-danger");
            $('#' + param1).addClass("btn-primary");
            $(".item").each(function () {
                $(this).css({ "background": "#fff", "color": "#333" });
                $(this).data("isclick", false);
                if ($(this).attr("data-tmp-Name") == "法人代表授权委托书") {
                    $("#BtnUploadProxy").attr("data-tmpid", "");
                }
                else if ($(this).attr("data-tmp-Name") == "提货授权委托书") {
                    $("#BtnUploadGoods").attr("data-tmpid", "");
                }
            });
        }
    }
    $.CheckdSubmit = function () {
        var Bl = true;

    
        $('.FrameControl.invalid').each(function () {
      
            var controlId = $(this).attr("id");
      
            if ($("#" + controlId).is(":hidden") && Bl) {
                Bl = true;
            }
            else {
                var type = $(this).data('type');
                var contro = "$(this).Frame" + type + "('getValue')";
              
                if (eval(contro) == null || eval(contro).toString()== "") {
              
                    $("#" + controlId).addClass("Checkinvalid");
                    Bl = false;
               
                }
                else if ($("#" + controlId).hasClass("Checkinvalid")) {
                    $("#" + controlId).removeClass("Checkinvalid");
                }
            }
            
        })
   
        return Bl;
    };
    $.fn.FrameSortAble = function (param1, param2) {
        if (typeof param1 == "string") {
            var func = $.fn.FrameSortAble.methods[param1];
            if (param2) {
               
                return func(this, param2);
            } else {
                return func(this);
            }

        } else {
            console.log("param1 is controlId,param2 is a Array");
            return;
        }

    }
    $.fn.FrameCheckBox = function (param1, param2) {
        if (typeof ($(this)) == 'undefined' || $(this).length == 0) {
            return;
        }
        var controlId = $(this).attr("id");

        if (typeof param1 == "string") {
            var func = $.fn.FrameCheckBox.methods[param1];
            if (func) {
                return func(this, param2);
            } else {
                console.log('error: none method');
                return '';
            }
        } else {
            var setting = $.extend({}, $.fn.FrameCheckBox.defaults, param1);
            $('#' + controlId).data({
                mode: setting.mode,
                type: 'CheckBox'
            });

            $('#' + controlId).empty();
            if (setting.mode == 'view') {
                //DOM
                var e = $.fn.FrameSpan(controlId + 'CheckBox');
                $('#' + controlId).append(e);

                //Value
                $('#' + controlId + 'CheckBox').html(setting.value);
            } else {
                //DOM
                var e = document.createElement("input");
                e.id = controlId + '_CheckBox';
                e.type = 'checkbox';
                e.style.cssText = setting.style;
                e.className = 'Fromcheckbox';
                $('#' + controlId).append(e);

                //Value
                $('#' + controlId + '_CheckBox').val(setting.value);
            }
        }
    };
    $.fn.FrameCheckBox.defaults = $.extend({}, {
        style: "",
        className: 'Fromcheckbox',
        mode: 'edit',
        value: ''
    });

    $.fn.FrameCheckBox.methods = {
        setValue: function (my, value) {
            var controlId = $(my).attr("id");
            if (value == "1") {
               
                $('#' + controlId + '_CheckBox').attr("checked", true);
            }
            else {
                $('#' + controlId + '_CheckBox').attr("checked", false);
            }
                
        },
        getValue: function (my) {
            var controlId = $(my).attr("id");
                return $('#' + controlId + '_CheckBox').is(':checked')==true?"1":"0";
        },
        disable: function (my) {
            var controlId = $(my).attr("id");

            if ($(my).data('mode') != 'view') {
                $('#' + controlId + '_CheckBox').attr("disabled", true);
            }
        },
        enable: function (my) {
            var controlId = $(my).attr("id");

            if ($(my).data('mode') != 'view') {
                $('#' + controlId + '_CheckBox').removeAttr("disabled");
            }
        },
        error: function (my) {
            //TODO Focus
        },
        removeError: function (my) {
            //TODO Focus
        },
        purchaseCheck: function (my) {
            var controlId = $(my).attr("Id");
            
            $("#" + controlId).unbind().bind("click", function () {

                //绑定事件
                $("#" + controlId).FrameCheckBox("purchaseControl");
            });
        },
        purchaseControl: function (my) {
            var controlId = $(my).attr("Id");

            var purchaseIsChecked = $("#" + controlId).FrameCheckBox('getValue');

            var listIds = "#f82dbabb-3c47-480a-9973-228ee8a5ba4c,#0d859b70-12b6-40fc-9a6d-31d3e8a32607";

            //未选中则【经销商补充协议_附件二】自动取消勾选
            //选中则【经销商补充协议_附件二】自动勾选
            if (purchaseIsChecked == "0") {
                $(listIds).css({ "background": "#fff", "color": "#333" });
                $(listIds).data("isclick", false);

            }
            else if (purchaseIsChecked == "1") {
                $(listIds).css({ "background": "#337AB7", "color": "#fff" });
                $(listIds).data("isclick", true);
            }
        },
        territoryCheck: function (my) {
            var controlId = $(my).attr("Id");

            $("#" + controlId).unbind().bind("click", function () {

                //绑定事件
                $("#" + controlId).FrameCheckBox("territoryControl");
            });
        },
        territoryControl: function (my) {
            var controlId = $(my).attr("Id");

            var territoryIsChecked = $("#" + controlId).FrameCheckBox('getValue');

            var listIds = "#4c164ff8-dda7-492a-951d-41bb8de4c9bc,#27ed5a86-a41c-4a46-a0af-c504a07501fb";

            //未选中则【经销商补充协议_附件一】自动取消勾选
            //选中则【经销商补充协议_附件一】自动勾选
            if (territoryIsChecked == "0") {
                $(listIds).css({ "background": "#fff", "color": "#333" });
                $(listIds).data("isclick", false);

            }
            else if (territoryIsChecked == "1") {
                $(listIds).css({ "background": "#337AB7", "color": "#fff" });
                $(listIds).data("isclick", true);
            }
        },
        paymentCheck: function (my, paymentValue) {
            var controlId = $(my).attr("Id");

            $("#" + controlId).unbind().bind("click", function () {

                //绑定事件
                $("#" + controlId).FrameCheckBox("paymentControl", paymentValue);
            });
        },
        paymentControl: function (my, paymentValue) {
            var controlId = $(my).attr("Id");

            var paymentIsChecked = $("#" + controlId).FrameCheckBox('getValue');
            
            if (paymentValue == "Credit") {
                //未选中则【经销商补充协议_附件一】自动取消勾选
                //选中则【经销商补充协议_附件一】自动勾选
                if (paymentIsChecked == "0") {
                    $("#hideDivPayType1").hide();
                    $("#hideDivPayType2").hide();
                }
                else if (paymentIsChecked == "1") {
                    $("#hideDivPayType1").show();
                    $("#hideDivPayType2").show();
                }
            }
        }
    };
    $.fn.FrameSortAble.defaults = $.extend({}, {})

    $.fn.FrameSortAble.methods = {

        setDataSource: function (my, value) {
       
            var controlId = $(my).attr("Id");
            var li = '';
         
            $.each(value.Data, function (i, n) {
                var style = '',
                 classItem = '',
                 isRequired = '';
                disabled = '';
              
                if (n.IsRequired) {
                    style = "background:#337AB7;color:#fff;"
                    isRequired = true;
                } else {
                    style = "background:#fff;color:#333;"
                    isRequired = false;
                }
                if (!n.IsRequiredBind) {
                    classItem = "item";
                }
             
                if (value.Status != "草稿") {
                    $("#BtnSelectAll").attr("disabled", "disabled");
                    classItem += " disabled"
                }
                else {
                    $("#BtnSelectAll").attr("disabled", false);
                }
                li += '<div id=' + n.TemplateId + '   class="itemli  ' + classItem + '" style="' + style + '" data-sort-Index="' + n.DisplayOrder + '" data-tmp-Name="' + n.TemplateName + '" data-path="' + n.TemplateFile + '" data-isclick="' + isRequired + '" data-type="' + n.FileType + '">' +
                           '<span class="handler">&nbsp;</span>' +
                           '<span >' + n.TemplateName + '</span>' +
                           '</div>';
                if (n.FileType == "OtherAttachment")
                {
                    if (isRequired == true)
                    {
                        $(".ProxyTemplate").show();
                    }
                else{
                        $(".ProxyTemplate").hide();
                    }
                  
                }
       
            });
         
            $('#' + controlId).append(li);
      
            $('#' + controlId).kendoSortable({
                handler: ".handler",
                hint: function (element) {
                  
                    return element.clone().addClass("hint");
                }
            });
          
            $("#" + controlId).children('.item').bind('click', function () {
                var data = $(this).data('isclick');
                var type = $(this).data("type");
               
                if (data == true) {
                    $(this).css({ "background": "#fff", "color": "#333" });
                    $(this).data("isclick", false);
                   
                    if (type == "OtherAttachment") {
                        $(".ProxyTemplate").hide();
                    }
              
                }
                else {
                    $(this).css({ "background": "#337AB7", "color": "#fff" });
                    $(this).data("isclick", true);
                    if (type == "OtherAttachment") {
                        $(".ProxyTemplate").show();
                    }
                
                }
            });
            $("#" + controlId).children('.disabled').unbind('click');
        },

        getSelectValue: function (my) {
            var controlId = $(my).attr("Id");
            var arr = [];

            $("#" + controlId).children(".itemli").each(function () {
               
                var isCheck = $(this).data("isclick"),
                 selectId = $(this).attr("id"),
                 sortIndex = $(this).data("sortIndex"),
                 tmpname = $(this).data("tmpName"),
                 filePath = $(this).data("path"),
                 TemplateType = $(this).data("type");
                if (isCheck) {
                    arr.push({ "TmpID": selectId, "TmpName": tmpname, "SortIndex": sortIndex, "IsCheck": isCheck, "FilePath": filePath, FileType: TemplateType });
                }
            })
            return arr;
        },
        removeDataSource:function(my){
            var controlId = $(my).attr("Id");
            $("#" + controlId).empty();
        },
        FileaddNewData: function (my,value)
        {
        
            
            var controlId = $(my).attr("Id");
          
            $(my).attr("data-path", value.FilePath);
            $(my).attr("data-fileName", value.FileName);
             var tempid = $(my).attr("data-tmpid");
          
            $("a.UserFile[ data-type='" + value.Type + "']").remove();
            //$("a.UserFile[data-tmpid='" + tempid + "']").remove();
            $("a[PrentId='" + controlId + "']").remove();
            $("div[PrentId='" + controlId + "']").remove();
            //var FilesTemp = "<a class=\"UserFile\" data-fileName=\"" + value.FileName + "\" data-type=\""+value.Type+"\"  data-tmpid=\""+tempid+"\"  data-path=\"" + value.FilePath + "\" onclick=\"$(this).FrameSortAble('DowLoadFile');return false;\"  target=\"_blank\" >" + value.FileName + "&nbsp;&nbsp;</a><a  class='Proxyfile' onclick=\"$(this).FrameSortAble('RemoveFile');return false;\"  PrentId=\"" + controlId + "\">x</a>";

            var FilesTemp ;
            if (value.FilePath != "") {
                FilesTemp = "<a class=\"UserFile\" style=\"cursor:pointer;\" data-fileName=\"" + value.FileName + "\" data-type=\"" + value.Type + "\"  data-tmpid=\"" + tempid + "\"  data-path=\"" + value.FilePath + "\" onclick=\"$(this).FrameSortAble('DowLoadFile');return false;\"  target=\"_blank\" >" + value.FileName + "</a>&nbsp;&nbsp;&nbsp;";

                if (value.status != undefined) {
                    FilesTemp = FilesTemp + "<a class='Proxyfile' style='cursor:pointer;text-decoration:none;text-decoration-color:black;font-size:16px !important;' onclick=\"$(this).FrameSortAble('RemoveFile');return false;\"  PrentId=\"" + controlId + "\">x</a>&nbsp;&nbsp;&nbsp;<div class=\"k-button\" style=\"margin-right: 30px;\" PrentId=\"" + controlId + "\" onclick=\"submitUploadFile();\"><i class=\"fa fa-hand-pointer-o\"></i>&nbsp;&nbsp;提交&nbsp;</div>";
                }
            } else {
                FilesTemp = "<span>未上传附件</span>";
            }
            $(my).after(FilesTemp);
        },
        RemoveFile: function (my)
        {
            $(my).prev("a").remove();
            $(my).remove();
            var PrentId = $(my).attr("PrentId");
            $("#" + PrentId).attr("data-path", "");
            $("#" + PrentId).attr("data-fileName", "");
        },
        DowLoadFile: function (my)
        {
            var FilePath = $(my).attr("data-path");
            var FileName = $(my).attr("data-fileName");
            var Url = Common.AppVirtualPath + "PagesKendo/Download.aspx?FilePath=" + FilePath + "&FileName=" + FileName;
            window.open(Url, "Download");
        },
        gatherFileInfo: function (my)
        {
           
            var Mylist = $(my);
            var data = [];
          
            $.each(Mylist, function (i, item) {
                var Obj = {
                    TmpID: $(item).attr("data-tmpid"),
                    FilePath: $(item).attr("data-path"),
                    TmpName: $(item).attr("data-fileName"),
                    FileType: $(item).attr("data-type")

                };
                data.push(Obj);
            });
        
            return data;
        },
        CheckdSubmit: function () { 
        
        }
     
    }



})(jQuery)
