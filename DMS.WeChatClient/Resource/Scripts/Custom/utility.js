Date.prototype.format = function (fmt) {
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
};

String.prototype.format = function () {
    if (arguments.length == 0)
        return this;

    var str = this;

    for (var i = 0; i < arguments.length; i++) {
        var re = new RegExp('\\{' + i + '\\}', 'gm');
        str = str.replace(re, arguments[i]);
    }
    return str;
};

var Class_Utility = function () {

    this.showOverlay = function (message) {
        $.showLoading(message);
    };

    this.hideOverlay = function () {
        $.hideLoading();
    };

    this.AESencrypt = function (key, iv, word) {
        var key = CryptoJS.enc.Utf8.parse(key); //16位
        var iv = CryptoJS.enc.Utf8.parse(iv);
        var encrypted = '';
        var data = word;
        if (typeof (word) == 'object') {
            data = JSON.stringify(word);
        }
        var srcs = CryptoJS.enc.Utf8.parse(data);
        encrypted = CryptoJS.AES.encrypt(srcs, key, {
            iv: iv,
            mode: CryptoJS.mode.CBC,
            padding: CryptoJS.pad.Pkcs7
        });
        //return encrypted.ciphertext.toString();
        if (undefined != encrypted.ciphertext) {
            var encryptedHexStr = CryptoJS.enc.Hex.parse(encrypted.ciphertext.toString());
            return CryptoJS.enc.Base64.stringify(encryptedHexStr);
        } else {
            return "";
        }
    }

    this.AESdecrypt = function (key, iv, word) {
        var words = CryptoJS.enc.Base64.parse(word);
        word = CryptoJS.enc.Hex.stringify(words);
        var key = CryptoJS.enc.Utf8.parse(key);
        var iv = CryptoJS.enc.Utf8.parse(iv);
        var encryptedHexStr = CryptoJS.enc.Hex.parse(word);
        var srcs = CryptoJS.enc.Base64.stringify(encryptedHexStr);
        var decrypt = CryptoJS.AES.decrypt(srcs, key, {
            iv: iv,
            mode: CryptoJS.mode.CBC,
            padding: CryptoJS.pad.Pkcs7
        });
        var decryptedStr = decrypt.toString(CryptoJS.enc.Utf8);
        return decryptedStr.toString();
    }

    this.isFunction = function (fun) {
        if (fun != undefined && fun != null && typeof (fun) == "function") {
            return true;
        } else {
            return false;
        }
    };

    // 辅助函数: 调用远程service上的服务.
    this.CallService = function (action, method, params, success, error, tipMessage, asyncType, autoShowOverlay) {
        var postData = new Object();
        if (!tipMessage) {
            tipMessage = "正在加载中";
        }

        if (asyncType == null || asyncType == "undefined") {
            asyncType = true;
        }
        if (autoShowOverlay == null || autoShowOverlay == "undefined") {
            autoShowOverlay = true;
        }

        if (autoShowOverlay == true) {
            utility.showOverlay(tipMessage);
        }
        if (!params) {
            params = {};
        }
        postData.Parameters = params;
        postData.UserToken = config.Variables.UserToken;
        postData.ActionName = action;
        postData.MethodName = method;
        if (config.Variables.key == "") {
            config.Variables.key = $("#hidKey").val();
        }
        if (config.Variables.iv == "") {
            config.Variables.iv = $("#hidIV").val();
        }
        if (config.Variables.ApiUrl == "") {
            config.Variables.ApiUrl = $("#hidApiUrl").val();
        }

        var postDataString = utility.AESencrypt(config.Variables.key, config.Variables.iv, JSON.stringify(postData));

        $.ajax({
            async: asyncType,
            type: "POST",
            url: config.Variables.ApiUrl,
            cache: false,
            data: { WeChatParams: postDataString },
            dataType: 'json',
            success: function (data) {
                if (utility.isFunction(success)) {
                    success(data);
                }
                if (autoShowOverlay) {
                    utility.hideOverlay();
                }
            },
            error: function (xhr, text, status) {
                if (utility.isFunction(error)) {
                    error(xhr, text, status);
                }
                if (autoShowOverlay) {
                    utility.hideOverlay();
                    $.toptip(config.CommonErrorMsg, 'error');
                }
            }
        });
    };
};
var utility = new Class_Utility();