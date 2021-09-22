var Common = function () {

    this.PackageTime = function (values) {
        var result;
        if (5 == values.length) {
            result = "{0}-{1}-{2} {3}:{4}".format(values[0], values[1], values[2], values[3], values[4]);
        }
        else if (4 == values.length) {
            result = "{0}-{1}-{2} {3}".format(values[0], values[1], values[2], values[3]);
        }
        return result;
    };

    this.GetDefaultDate = function (dateValue) {
        var now = new Date();
        if (null != dateValue && '' != dateValue && undefined != dateValue) {
            now = common.ConvertToDateTime(dateValue);
        }
        var year = now.getFullYear();
        var month = now.getMonth() + 1;
        var day = now.getDate();
        if (month < 10)
            month = "0" + month;
        if (day < 10)
            day = "0" + day;
        return "{0}-{1}-{2}".format(year, month, day);
    };

    this.GetDefaultTime = function (dateValue) {
        var now = new Date();
        if (null != dateValue && '' != dateValue && undefined != dateValue) {
            now = common.ConvertToDateTime(dateValue);
        }
        return "{0}:{1}".format(now.getHours(), now.getMinutes());
    };

    this.CompareDateTime = function (value1, value2) {
        var isBigger = false;
        if ('' != value1 && undefined != value1 && null != value1 && '' != value2 && undefined != value2 && null != value2) {
            var starttime = common.ConvertToDateTime(value1);
            var endtime = common.ConvertToDateTime(value2);
            if (starttime >= endtime) {
                isBigger = true;
            }
        }
        return isBigger;
    };

    this.ConvertToDateTime = function (value) {
        try {
            var arr = value.split(/[- :]/);
            if (6 == arr.length) {
                return new Date(arr[0], arr[1] - 1, arr[2], arr[3], arr[4], arr[5]);
            }
            else if (3 == arr.length) {
                return new Date(arr[0], arr[1] - 1, arr[2], '00', '00', '00');
            }
            else {
                return new Date(arr[0], arr[1] - 1, arr[2], arr[3], arr[4], '00');
            }
        } catch (e) {
            return value;
        }
    };

    this.CalcWeekdayName = function (weekday) {
        var a = new Array("日", "一", "二", "三", "四", "五", "六");
        var i = common.ConvertToDateTime(weekday.trim()).getDay();
        return "星期" + a[i];
    };

    this.HideTopTips = function () { $(".weui_toptips").hide() };

    this.scrollers = [];
    this.scrollers_extends = [];

    // 辅助函数: 绑定Scroller
    this.attachScroller = function (scrollerID, checkLoadComplete) {

        if (!scrollerID) {
            return;
        }

        var matchedScroller = null;

        for (var index = 0; index < this.scrollers.length; index++) {
            if (this.scrollers[index].ID == scrollerID) {
                matchedScroller = this.scrollers[index];
                break;
            }
        }

        if (matchedScroller == null) {

            setTimeout(function () {

                var newScroll = new iScroll(scrollerID, {
                    desktopCompatibility: true, vScrollbar: true, hideScrollbar: true,
                    useTransition: true
                });
                //var newScroll = new iScroll(scrollerID, {
                //    desktopCompatibility: true, vScrollbar: false
                //});
                common.scrollers.push({ ID: scrollerID, Scroll: newScroll });

                if (checkLoadComplete) {
                    newScroll.refreshOnLoadComplete();
                }

                if (common.scrollers.length <= 1) {
                    //document.addEventListener('touchmove', function (e) { e.preventDefault(); }, false);
                    common.DisableTouchMove();
                }

            }, 500);
        }
        else {
            setTimeout(function () {

                if (checkLoadComplete) {
                    matchedScroller.Scroll.refreshOnLoadComplete();
                }
                else {
                    matchedScroller.Scroll.refresh();
                }

                matchedScroller.Scroll.scrollTo(0, 0, 0, false);

            }, 500);
        }
    };

    //辅助函数：绑定Scroller
    this.attachScrollerRefresh = function (scrollerID, pullDownElementId, pullDownAction, pullUpElementId, pullUpAction, checkLoadComplete) {

        var extendobject = new Object();
        var hasDown = false;
        var hasUp = false;

        if (!scrollerID) {
            return;
        }

        if (pullDownElementId != undefined && pullDownElementId != null) {
            hasDown = true;
        }
        if (pullUpElementId != undefined && pullUpElementId != null) {
            hasUp = true;
        }

        var matchedScroller = null;

        for (var index = 0; index < this.scrollers.length; index++) {
            if (this.scrollers[index].ID == scrollerID) {
                matchedScroller = this.scrollers[index];
                break;
            }
        }


        if (matchedScroller == null) {

            setTimeout(function () {

                extendobject.hasDown = hasDown;
                extendobject.hasUp = hasUp;

                if (hasDown == true) {
                    pullDownEl = $("#" + pullDownElementId)[0]; // document.getElementById(pullDownElementId);
                    pullDownOffset = pullDownEl.offsetHeight;//pullDownEl.offsetHeight;

                    extendobject.pullDownEl = pullDownEl;
                    extendobject.pullDownOffset = pullDownOffset;
                    extendobject.pullDownAction = pullDownAction;
                }
                else {
                    pullDownOffset = 0;
                }
                if (hasUp == true) {
                    pullUpEl = $("#" + pullUpElementId)[0]; // document.getElementById(pullUpElementId);
                    pullUpOffset = pullUpEl.offsetHeight; //pullUpEl.offsetHeight;

                    extendobject.pullUpEl = pullUpEl;
                    extendobject.pullUpAction = pullUpAction;
                }
                common.scrollers_extends.push({ ID: scrollerID, ExtendOject: extendobject });

                var newScroll = new iScroll(scrollerID,
                    {
                        desktopCompatibility: true, vScrollbar: true, hideScrollbar: true,
                        useTransition: true, topOffset: pullDownOffset
                        ,
                        onRefresh: function () {
                            var matchedScroller = common.getScrollerExtendObject(scrollerID);

                            if (matchedScroller.hasDown == true && matchedScroller.pullDownEl.className.match('loading')) {
                                matchedScroller.pullDownEl.className = 'pullDown';
                                matchedScroller.pullDownEl.querySelector('.pullDownLabel').innerHTML = '下拉刷新...'; //'Pull down to refresh...';
                            }
                            if (matchedScroller.hasUp == true && matchedScroller.pullUpEl.className.match('loading')) {
                                matchedScroller.pullUpEl.className = 'pullUp';
                                matchedScroller.pullUpEl.querySelector('.pullUpLabel').innerHTML = '加载更多...'; //'Pull up to load more...';
                            }
                        },
                        onScrollMove: function () {
                            var matchedScroller = common.getScrollerExtendObject(scrollerID);

                            if (matchedScroller.hasDown == true && this.y > 5 && !matchedScroller.pullDownEl.className.match('flip')) {
                                matchedScroller.pullDownEl.className = 'pullDown flip';
                                matchedScroller.pullDownEl.querySelector('.pullDownLabel').innerHTML = '释放更新...'; //'Release to refresh...';
                                this.minScrollY = 0;
                            } else if (matchedScroller.hasDown == true && this.y < 5 && matchedScroller.pullDownEl.className.match('flip')) {
                                matchedScroller.pullDownEl.className = 'pullDown';
                                matchedScroller.pullDownEl.querySelector('.pullDownLabel').innerHTML = '下拉刷新...'; //'Pull down to refresh...';
                                this.minScrollY = -pullDownOffset;
                            }
                            if (matchedScroller.hasUp == true && this.y < (this.maxScrollY - 5) && !matchedScroller.pullUpEl.className.match('flip')) {
                                matchedScroller.pullUpEl.className = 'pullUp flip';
                                matchedScroller.pullUpEl.querySelector('.pullUpLabel').innerHTML = '释放更新...'; //'Release to refresh...';
                                this.maxScrollY = this.maxScrollY;
                            } else if (matchedScroller.hasUp == true && this.y > (this.maxScrollY + 5) && matchedScroller.pullUpEl.className.match('flip')) {
                                matchedScroller.pullUpEl.className = 'pullUp';
                                matchedScroller.pullUpEl.querySelector('.pullUpLabel').innerHTML = '加载更多...'; //'Pull up to load more...';
                                this.maxScrollY = pullUpOffset;
                            }
                        },
                        onScrollEnd: function () {
                            var matchedScroller = common.getScrollerExtendObject(scrollerID);

                            if (matchedScroller.hasDown == true && matchedScroller.pullDownEl.className.match('flip') && $(extendobject.pullDownEl).is(":visible")) {
                                matchedScroller.pullDownEl.className = 'pullDown loading';
                                matchedScroller.pullDownEl.querySelector('.pullDownLabel').innerHTML = '加载中...'; //'Loading...';
                                if (matchedScroller.pullDownAction != undefined && matchedScroller.pullDownAction != null) {
                                    matchedScroller.pullDownAction();
                                }
                                //pullDownAction();	// Execute custom function (ajax call?)
                            }
                            if (matchedScroller.hasUp == true && matchedScroller.pullUpEl.className.match('flip')) {
                                matchedScroller.pullUpEl.className = 'pullUp loading';
                                matchedScroller.pullUpEl.querySelector('.pullUpLabel').innerHTML = '加载中...'; //'Loading...';
                                if (matchedScroller.pullUpAction != matchedScroller.undefined && pullUpAction != null && $(extendobject.pullUpEl).is(":visible")) {
                                    matchedScroller.pullUpAction();
                                }
                            }
                        }
                    });

                common.scrollers.push({ ID: scrollerID, Scroll: newScroll });

                if (checkLoadComplete) {
                    newScroll.refreshOnLoadComplete();
                }

                if (common.scrollers.length <= 1) {
                    //document.addEventListener('touchmove', function (e) { e.preventDefault(); }, false);
                    common.DisableTouchMove();
                }

            }, 500);
        }
        else {
            setTimeout(function () {


                if (checkLoadComplete) {
                    matchedScroller.Scroll.refreshOnLoadComplete();
                }
                else {
                    matchedScroller.Scroll.refresh();
                }

                var ScrollerExtend = common.getScrollerExtendObject(scrollerID);
                // matchedScroller.Scroll.scrollTo(0, -ScrollerExtend.pullDownOffset, 0, false);

            }, 500);
        }


    };

    this.getScrollerExtendObject = function (scrollerID) {
        var matchedScroller = null;

        for (var index = 0; index < this.scrollers_extends.length; index++) {
            if (this.scrollers_extends[index].ID == scrollerID) {
                matchedScroller = this.scrollers_extends[index];
                break;
            }
        }

        return matchedScroller.ExtendOject;
    };

    this.DisableTouchMove = function () {
        document.addEventListener('touchmove', function (evt) {
            //if (0 == $(evt.srcElement).closest(".scroller").length) {
            if (0 == $(evt.srcElement).closest("#divLeftMenu").length && 0 == $(evt.srcElement).closest(".weui_cells_checkbox").length && 0 == $(evt.srcElement).closest(".scroll_able").length) {
                evt.preventDefault();
            }
        });
    };

    this.BindQuickItem = function () {
        $("[data-type='QuickItem']").unbind(config.EventName.click).bind(config.EventName.click, function () {
            var dataurl = $(this).attr("data-url");
            if (undefined != dataurl) {
                window.location.href = dataurl;
            }
        });
    };

    this.RefreshLeftNavCorner = function () {
    };

    //检查用户信息是否存在，如果不存在则跳转到主页面
    this.CheckUserInfo = function () {
        if (!(localStorage.getItem(config.LocalStrogeName.OpenId) &&
                localStorage.getItem(config.LocalStrogeName.DealerId) &&
                localStorage.getItem(config.LocalStrogeName.UserId))
        ) {
            window.location.href = config.Variables.DefaultUrl;
        }
    };

    //复制内容到粘贴板
    this.CopyToClipboard = function (value) {
        var textarea = document.createElement("textarea");
        var currentFocus = document.activeElement;
        document.body.appendChild(textarea);
        textarea.value = value;
        textarea.focus();
        if (textarea.setSelectionRange)
            textarea.setSelectionRange(0, textarea.value.length);
        else
            textarea.select();
        try {
            var flag = document.execCommand("copy");
        } catch (eo) {
            var flag = false;
        }
        document.body.removeChild(textarea);
        currentFocus.focus();
        return flag;
    }
};

var common = new Common();
