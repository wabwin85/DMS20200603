var OBORContractWindow = {};

OBORContractWindow = function () {
    var that = {};

    var business = 'OBORESign.OBORContractWindow';
    var pickedList = [];

    that.GetModel = function () {
        var model = FrameUtil.GetModel();

        return model;
    }

    that.Init = function () {


        var data = {};
        data.ES_ID = Common.GetUrlParam('ES_ID');
        $('#ES_ID').val(Common.GetUrlParam('ES_ID'));
        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {

                $('#Src').val(model.Src);
                $('#FileName').val(model.FileName);


                function TemplateImageHtml(srcUrl) {
                    return "<img src='" + srcUrl + "' style='width:100%;'> <br/>";
                }

                var content = "";
                var jsonData = JSON.parse(model.ResData);
                $.each(jsonData, function (index, item) {
                    content = content + TemplateImageHtml(item.imgSrc);
                });
                $('#RstResultList').append(content);


                




                $('#BtnClose').FrameButton({
                    text: '关闭',
                    icon: 'close',
                    onClick: function () {
                        FrameWindow.CloseWindow({
                            target: 'top'
                        });
                    }
                });

                $('#BtnDownload').FrameButton({
                    text: '下载PDF',
                    icon: 'download',
                    onClick: function () {
                        that.DownloadPDF();
                    }
                });

                if (!model.DealerSignReadonly) {
                
                    $('#BtnDealerSign').FrameButton({
                        text: '经销商签章',
                        icon: 'send',
                        onClick: function () {
                            that.DealerSign();
                        }
                    });
                }
                if (!model.LPSignReadonly) {
                    $('#BtnLPSign').FrameButton({
                        text: '平台签章',
                        icon: 'send',
                        onClick: function () {
                            that.LPSign();
                        }
                    });
                }

              


                $(window).resize(function () {
                    setLayout();
                })
                setLayout();

                FrameWindow.HideLoading();
            }
        });
    }

    //经销商签章
    that.DealerSign = function () {
        var data = FrameUtil.GetModel();


        FrameWindow.ShowConfirm({
            target: 'top',
            message: '确定签章吗？',
            confirmCallback: function () {
               
                //data.ES_ID = Common.GetUrlParam('ES_ID');
                //FrameWindow.ShowLoading();

                //FrameUtil.SubmitAjax({
                //    business: business,
                //    method: 'DealerSign',
                //    url: Common.AppHandler,
                //    data: data,
                //    callback: function (model) {

                //        if (model.IsSuccess) {
                //            FrameWindow.ShowAlert({
                //                target: 'top',
                //                alertType: 'info',
                //                message: '签章成功',
                //                callback: function () {

                //                    //top.deleteTabsCurrent();

                //                }
                //            });
                //        }
                //        FrameWindow.HideLoading();
                //    }
                //});

                url = Common.AppVirtualPath + 'Revolution/Pages/OBORESign/OBORVerificationCode.aspx?' + 'ES_ID=' + Common.GetUrlParam('ES_ID')+'&SignType=DealerSign';

                FrameWindow.OpenWindow({
                    target: 'top',
                    title: '验证码',
                    url: url,
                    width: $(window).width() * 0.8,
                    height: $(window).height() * 0.8,
                    actions: ["Close"],
                    callback: function (flowList) {
                        
                        FrameWindow.CloseWindow({
                            target: 'top'
                        });
                    }
                });

            }
        });

    }

    //平台签章
    that.LPSign = function () {
        var data = FrameUtil.GetModel();


        FrameWindow.ShowConfirm({
            target: 'top',
            message: '确定签章吗？',
            confirmCallback: function () {

                //data.ES_ID = Common.GetUrlParam('ES_ID');
                //FrameWindow.ShowLoading();

                //FrameUtil.SubmitAjax({
                //    business: business,
                //    method: 'LPSign',
                //    url: Common.AppHandler,
                //    data: data,
                //    callback: function (model) {

                //        if (model.IsSuccess) {
                //            FrameWindow.ShowAlert({
                //                target: 'top',
                //                alertType: 'info',
                //                message: '签章成功',
                //                callback: function () {

                //                    //top.deleteTabsCurrent();

                //                }
                //            });
                //        }
                //        FrameWindow.HideLoading();
                //    }
                //});

                url = Common.AppVirtualPath + 'Revolution/Pages/OBORESign/OBORVerificationCode.aspx?' + 'ES_ID=' + Common.GetUrlParam('ES_ID') + '&SignType=LPSign';

                FrameWindow.OpenWindow({
                    target: 'top',
                    title: '验证码',
                    url: url,
                    width: $(window).width() * 0.8,
                    height: $(window).height() * 0.8,
                    actions: ["Close"],
                    callback: function (flowList) {

                        FrameWindow.CloseWindow({
                            target: 'top'
                        });
                    }
                });

            }
        });
    }



    that.DownloadPDF = function () {
        var Url = Common.AppVirtualPath + "PagesKendo/Download.aspx?FilePath=" + $('#Src').val() + "" + "&FileName=" + $('#FileName').val() + "";
        window.open(Url, "Download");
    }



    var setLayout = function () {
    }

    return that;
}();
