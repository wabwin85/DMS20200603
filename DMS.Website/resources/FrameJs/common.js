(function ($) {
    $.getUrlParam = function (name) {
        var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)");
        var r = window.location.search.substr(1).match(reg);
        if (r != null) return unescape(r[2]);
        return '';
    }

    $.updateUrlParams = function (url, name, value) {
        var r = url;
        if (r != null && r != 'undefined' && r != "") {
            value = encodeURIComponent(value);
            var reg = new RegExp("(^|)" + name + "=([^&]*)(|$)");
            var tmp = name + "=" + value;
            if (url.match(reg) != null) {
                r = url.replace(eval(reg), tmp);
            }
            else {
                if (url.match("[\?]")) {
                    r = url + "&" + tmp;
                } else {
                    r = url + "?" + tmp;
                }
            }
        }
        return r;
    }

    $.stringContains = function (source, words, split) {
        var s = source.split(split);
        for (i = 0; i < s.length; i++) {
            if (s[i] == words) {
                return true;
            }
        }
        return false;
    }

    $.replaceAll = function (str, oldStr, newStr) {
        return str.toString().replace(new RegExp(oldStr, "gm"), newStr);
    }

    $.getTimestamp = function () {
        var timestamp = Date.parse(new Date());
        return timestamp / 1000;
    }

    $.fn.extend({
        //表格合并单元格，colIdx要合并的列序号，从0开始  
        "rowspan": function (colIdx) {
            return this.each(function () {
                var that;
                $('tr', this).each(function (row) {
                    $('td:eq(' + colIdx + ')', this).filter(':visible').each(function (col) {
                        if (that != null && $(this).html() == $(that).html()) {
                            rowspan = $(that).attr("rowSpan");
                            if (rowspan == undefined) {
                                $(that).attr("rowSpan", 1);
                                rowspan = $(that).attr("rowSpan");
                            }
                            rowspan = Number(rowspan) + 1;
                            $(that).attr("rowSpan", rowspan);
                            $(this).hide();
                        } else {
                            that = this;
                        }
                    });
                });
            });
        }
    });
})(jQuery);

Date.prototype.Format = function (fmt) { //author: meizz 
    var o = {
        "M+": this.getMonth() + 1, //月份 
        "d+": this.getDate(), //日 
        "h+": this.getHours(), //小时 
        "m+": this.getMinutes(), //分 
        "s+": this.getSeconds(), //秒 
        "q+": Math.floor((this.getMonth() + 3) / 3), //季度 
        "S": this.getMilliseconds() //毫秒 
    };
    if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
    for (var k in o)
        if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
    return fmt;
}

var Common = {};

Common = function () {
    var that = {};

    that.AppVirtualPath = '';

    return that;
}();
