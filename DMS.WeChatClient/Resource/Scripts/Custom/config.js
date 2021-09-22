var Config = function () {

    this.Variables = {
        UserToken: "",
        UserAvatar: "",
        ApiUrl: "",
        DefaultUrl: "",
        BaseUrl_ServerFilePath: "",
        BaseUrl: "",
        key: "",
        iv: ""
    };

    this.LocalStrogeName = {
        OpenId: "OpenId",
        UserId: "UserId",
        UserName: "UserName",
        DealerId: "DealerId",
        DealerName: "DealerName",
        QRHeaderNo: "QRHeaderNo"
    };

    this.ActionMethod = {
        ScanQRCode: {
            Action: "ScanQRCode",
            Method: {
                InitQRHeaderInfo: "InitQRHeaderInfo",
                SubmitQRHeaderInfo: "SubmitQRHeaderInfo",
                ExportQRHeaderInfo: "ExportQRHeaderInfo",
                InsertWechatQRCodeDetail: "InsertWechatQRCodeDetail",
                DeleteWechatQRCodeDetail: "DeleteWechatQRCodeDetail",
                SearchHeaderInfo: "SearchHeaderInfo",
                DeleteHeaderInfo: "DeleteHeaderInfo"
            }
        },
        Navigation: {
            Action: "Navigation",
            Method: {
                Init: "Init"
            }
        },
        Account: {
            Action: "Account",
            Method: {
                LoginIn: "LoginIn",
                LoginOut: "LoginOut"
            }
        }
    };

    this.CommonErrorMsg = "请求失败,请稍候再试";
    this.CommonSuccessMsg = "操作成功";
    //this.EventName = { click_general: "click", click: "fastclick", change: "change" };
    this.EventName = { click_general: "click", click: "click", change: "change" };
};

var config = new Config();

$(function () {
    FastClick.attach(document.body);
});