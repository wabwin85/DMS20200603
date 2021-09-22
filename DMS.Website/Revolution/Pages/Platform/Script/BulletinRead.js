var BulletinRead = {};

BulletinRead = function () {
    var that = {};

    var business = 'Platform.BulletinRead';

    that.GetModel = function () {
        var model = FrameUtil.GetModel();

        return model;
    }

    that.Init = function () {
        var data = {};
        data.InstanceId = Common.GetUrlParam('InstanceId');

        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $('#InstanceId').val(model.InstanceId);
                $('#IptTitle').html(model.IptTitle);
                $('#IptPublishedDate').html(model.IptPublishedDate);
                $('#IptBody').html(model.IptBody);

                var AttachmentUrl = Common.AppVirtualPath + 'Revolution/Pages/Util/AttachmentDownload.aspx';
                AttachmentUrl = Common.UpdateUrlParams(AttachmentUrl, 'AttachmentType', '');

                $.each(model.RstAttachment, function (i, n) {
                    var link = $('<li style="list-style: none;"><a href="#" class="attachment-link">' + n.Name + '</a></li>');
                    link.find('.attachment-link').data('AttachmentId', n.Id);

                    link.find('.attachment-link').bind('click', function () {
                        AttachmentUrl = Common.UpdateUrlParams(AttachmentUrl, 'AttachmentId', $(this).data('AttachmentId'));
                        FrameUtil.StartDownload({
                            url: AttachmentUrl,
                            cookie: 'Attachment_' + n.Id
                        });
                    })

                    $('#RstAttachment').append(link);
                })

                if (model.IptConfirmFlag) {
                    $('#BtnConfirm').FrameButton({
                        text: '确认阅读',
                        icon: 'check',
                        onClick: that.Confirm
                    });
                } else {
                    $('#BtnConfirm').remove();
                }
                $('#BtnClose').FrameButton({
                    text: '关闭',
                    icon: 'window-close',
                    onClick: function () {
                        FrameWindow.CloseWindow({
                            target: 'top'
                        });
                    }
                });

                $(window).resize(function () {
                    setLayout();
                })
                setLayout();

                FrameWindow.HideLoading();
            }
        });
    }

    that.Confirm = function () {
        var data = that.GetModel();

        FrameUtil.SubmitAjax({
            business: business,
            method: 'Confirm',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                var url = Common.AppVirtualPath + 'Revolution/Pages/Platform/BulletinRead.aspx';
                url += '?InstanceId=' + model.InstanceId;

                FrameWindow.ReloadWindow({
                    target: 'top',
                    url: url
                });

                FrameWindow.HideLoading();
            }
        });
    }

    var setLayout = function () {
    }

    return that;
}();
