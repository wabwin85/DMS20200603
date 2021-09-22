//除法函数，用来得到精确的除法结果
//说明：javascript的除法结果会有误差，在两个浮点数相除的时候会比较明显。这个函数返回较为精确的除法结果。
//调用：accDiv(arg1,arg2)
//返回值：arg1除以arg2的精确结果
function accDiv(arg1, arg2) {
    var t1 = 0, t2 = 0, r1, r2;
    try { t1 = arg1.toString().split(".")[1].length } catch (e) { }
    try { t2 = arg2.toString().split(".")[1].length } catch (e) { }
    with (Math) {
        r1 = Number(arg1.toString().replace(".", ""))
        r2 = Number(arg2.toString().replace(".", ""))
        if (r2 == 0)
            return 0;
        else
            return (r1 / r2) * pow(10, t2 - t1);
    }
}

//给Number类型增加一个div方法，调用起来更加方便。
Number.prototype.div = function (arg) {
    return accDiv(this, arg);
}

//乘法函数，用来得到精确的乘法结果
//说明：javascript的乘法结果会有误差，在两个浮点数相乘的时候会比较明显。这个函数返回较为精确的乘法结果。
//调用：accMul(arg1,arg2)
//返回值：arg1乘以arg2的精确结果
function accMul(arg1, arg2) {
    arg1 = String(arg1); var i = arg1.length - arg1.indexOf(".") - 1; i = (i >= arg1.length) ? 0 : i
    arg2 = String(arg2); var j = arg2.length - arg2.indexOf(".") - 1; j = (j >= arg2.length) ? 0 : j
    return arg1.replace(".", "") * arg2.replace(".", "") / Math.pow(10, i + j)
}

//给Number类型增加一个mul方法，调用起来更加方便。
Number.prototype.mul = function (arg) {
    return accMul(arg, this);
}

//加法函数，用来得到精确的加法结果
//说明：javascript的加法结果会有误差，在两个浮点数相加的时候会比较明显。这个函数返回较为精确的加法结果。
//调用：accAdd(arg1,arg2)
//返回值：arg1加上arg2的精确结果
function accAdd(arg1, arg2) {
    var r1, r2, m;
    try { r1 = arg1.toString().split(".")[1].length } catch (e) { r1 = 0 }
    try { r2 = arg2.toString().split(".")[1].length } catch (e) { r2 = 0 }
    m = Math.pow(10, Math.max(r1, r2))
    return (arg1 * m + arg2 * m) / m
}

//给Number类型增加一个add方法，调用起来更加方便。
Number.prototype.add = function (arg) {
    return accAdd(arg, this);
}

//减法函数，用来得到精确的减法结果
//说明：javascript的减法结果会有误差，在两个浮点数相减的时候会比较明显。这个函数返回较为精确的减法结果。
//调用：accMin(arg1,arg2)
//返回值：arg1减去arg2的精确结果
function accMin(arg1, arg2) {
    var r1, r2, m;
    try { r1 = arg1.toString().split(".")[1].length } catch (e) { r1 = 0 }
    try { r2 = arg2.toString().split(".")[1].length } catch (e) { r2 = 0 }
    m = Math.pow(10, Math.max(r1, r2))
    return (arg1 * m - arg2 * m) / m
}

//给Number类型增加一个min方法，调用起来更加方便。
Number.prototype.min = function (arg) {
    return accMin(this, arg);
}

//四舍五入函数
//说明：ie5.5以下不能使用toFixed函数
//调用：Fixed(arg1,arg2)
//返回值：arg1四舍五入arg2位的结果
//function Fixed(arg1, arg2) {
//    arg1 = Math.round(arg1 * Math.pow(10, arg2)) / Math.pow(10, arg2);

//    return arg1;
//}

////给Number类型增加一个toFixed方法，调用起来更加方便。
//Number.prototype.toFixed = function (arg) {
//    return Fixed(this, arg);
//}

//给控件默认值
//说明：确保某些控件有值
//调用：defaultValue(arg1,arg2)
//返回值：arg1为空时默认赋值arg2
function setDefaultValue(arg1, arg2) {
    if (arg1.value.trim() == '')
        arg1.value = arg2;
}


function formatNumber(num, pattern) {
    if (!IsFloat(num)) {
        return num;
    }

    var strarr = num ? num.toString().split('.') : ['0'];
    var fmtarr = pattern ? pattern.split('.') : [''];
    var retstr = '';

    // 整数部分   
    var str = strarr[0];
    var fmt = fmtarr[0];
    var i = str.length - 1;
    var comma = false;
    for (var f = fmt.length - 1; f >= 0; f--) {
        switch (fmt.substr(f, 1)) {
            case '#':
                if (i >= 0) retstr = str.substr(i--, 1) + retstr;
                break;
            case '0':
                if (i >= 0) retstr = str.substr(i--, 1) + retstr;
                else retstr = '0' + retstr;
                break;
            case ',':
                comma = true;
                retstr = ',' + retstr;
                break;
        }
    }
    if (i >= 0) {
        if (comma) {
            var l = str.length;
            for (; i >= 0; i--) {
                retstr = str.substr(i, 1) + retstr;
                if (i > 0 && ((l - i) % 3) == 0) retstr = ',' + retstr;
            }
        }
        else retstr = str.substr(0, i + 1) + retstr;
    }

    retstr = retstr + '.';
    // 处理小数部分   
    str = strarr.length > 1 ? strarr[1] : '';
    fmt = fmtarr.length > 1 ? fmtarr[1] : '';
    i = 0;
    for (var f = 0; f < fmt.length; f++) {
        switch (fmt.substr(f, 1)) {
            case '#':
                if (i < str.length) retstr += str.substr(i++, 1);
                break;
            case '0':
                if (i < str.length) retstr += str.substr(i++, 1);
                else retstr += '0';
                break;
        }
    }
    return retstr.replace(/^,+/, '').replace(/\.$/, '');
}

Number.prototype.formatNumber = function (arg) {
    return formatNumber(this, arg);
}

String.prototype.formatNumber = function (arg) {
    return formatNumber(this, arg);
}

function unformatNumber(arg1) {
    var s = arg1.replace(/,/g, '');
    if (IsFloat(s)) {
        return s;
    }
    return arg1;
}

String.prototype.unformatNumber = function (arg) {
    return unformatNumber(this, arg);
}

function IsFloat(arg) {
    re = /^(-?|\+?)(\d+)(\.\d+)?$/;
    if (re.test(arg)) {
        return true;
    } else {
        return false;
    }
}

function formartControl(arg1, arg2) {
    arg1.value = formatNumber(arg1.value, arg2);
}

function formartControlWithUnformat(arg1, arg2) {
    arg1.value = formatNumber(arg1.value.unformatNumber(), arg2);
}

function IsFloatWithWarning(arg1, arg2) {
    var re = IsFloat(arg1);
    if (!re) {
        alert(arg2);
    }
    return re;
}

function IsPercent(arg) {
    re = /^((100(\.00)?)|((\d|[1-9]\d)(\.\d{2})?))$/;
    if (re.test(arg)) {
        return true;
    } else {
        return false;
    }
}

function IsPercentWithWarning(arg1, arg2) {
    var re = IsPercent(arg1);
    if (!re) {
        alert(arg2);
    }
    return re;
}

function IsInteger(str) {
    var regu = /^[-]{0,1}[0-9]{1,}$/;
    return regu.test(str);
}