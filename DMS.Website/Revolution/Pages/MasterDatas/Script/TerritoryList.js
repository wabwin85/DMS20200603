var TerritoryList = {};

TerritoryList = function () {
    var that = {};

    var business = 'MasterDatas.TerritoryList';
    var deleteHosp = [];

    that.GetModel = function () {
        var model = FrameUtil.GetModel();

        return model;
    }

    that.Init = function () {
        var data = {};
        createResultList();

        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $('#QryProvinceName').FrameTextBox({
                    value: model.QryProvinceName
                });
                $('#QryCityName').FrameTextBox({
                    value: model.QryCityName
                });
                $('#QryCountyName').FrameTextBox({
                    value: model.QryCountyName
                });
                $('#BtnQuery').FrameButton({
                    text: '查询',
                    icon: 'search',
                    onClick: function () {
                        that.Query();
                    }
                });

                $('#BtnNew').FrameButton({
                    text: '新增',
                    icon: 'plus',
                    onClick: function () {
                        that.TerritoryEdit('', '区域详细信息');
                    }
                });



                //$('#BtnSave').FrameButton({
                //    text: '保存',
                //    icon: 'save',
                //    onClick: function () {
                //        that.SaveChange();
                //    }
                //});                              

                //$("#RstResultList").data("kendoGrid").setOptions({
                //    dataSource: model.RstResultList
                //});

                $(window).resize(function () {
                    setLayout();
                })
                setLayout();

                FrameWindow.HideLoading();
            }
        });
    }

    that.Query = function () {
        var grid = $("#RstResultList").data("kendoGrid");
        if (grid) {
            grid.dataSource.page(0);
            return;
        }
    }
    var fields = {

    }
    var kendoDataSource = GetKendoDataSource(business, 'Query', fields, 20);
    var createResultList = function () {
        $("#RstResultList").kendoGrid({
            dataSource: kendoDataSource,
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 500,
            columns: [
                //{
                //    title: "选择", width: 50, encoded: false,
                //    headerTemplate: '<input id="CheckAll" type="checkbox" class="k-checkbox Check-All" /><label class="k-checkbox-label" for="CheckAll"></label>',
                //    template: '<input type="checkbox" id="Check_#=HosId#" class="k-checkbox Check-Item" /><label class="k-checkbox-label" for="Check_#=HosId#"></label>',
                //    headerAttributes: { "class": "text-center bold", "title": "选择", "style": "vertical-align: middle;" },
                //    attributes: { "class": "text-center" }
                //},
                  {
                      field: "ProvinceName", title: "省份", width: 180,
                      headerAttributes: { "class": "text-center text-bold", "title": "省份" }
                  },
                {
                    field: "CityName", title: "地区", width: 180,
                    headerAttributes: { "class": "text-center text-bold", "title": "地区" }
                },
                {
                    field: "CountyName", title: "区/县", width: 180,
                    headerAttributes: { "class": "text-center text-bold", "title": "区/县" }
                },
                //{
                //    field: "HosLastModifiedDate", title: "修改日期", width: 150, format: "{0:yyyy-MM-dd HH:mm:ss}",
                //    headerAttributes: { "class": "text-center text-bold", "title": "修改日期" }
                //},
                //{
                //    field: "LastUpdateUserName", title: "修改人", width: 100,
                //    headerAttributes: { "class": "text-center text-bold", "title": "修改人" }
                //},
                {
                    title: "明细", width: 50,
                    headerAttributes: {
                        "class": "text-center text-bold"
                    },
                    template: "<i class='fa fa-edit' style='font-size: 14px; cursor: pointer;' name='edit'></i>",
                    attributes: {
                        "class": "text-center text-bold"
                    }
                }

            ],
            pageable: {
                refresh: false,
                pageSizes: false,
                //pageSize: 20,
                //input: true,
                //numeric: false
            },
            noRecords: true,
            messages: {
                noRecords: "没有符合条件的记录"
            },
            dataBound: function (e) {
                var grid = e.sender;
                $("#RstResultList").find("i[name='edit']").bind('click', function (e) {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);

                    that.TerritoryEdit(data.Ter_Id, '医院详细信息');
                });
            },
            page: function (e) {

            }
        });
    }


    that.TerritoryEdit = function (Id, Name) {
        var url = 'Revolution/Pages/MasterDatas/TerritoryEditor.aspx?';
        url += 'Id=' + escape(Id);
        FrameWindow.OpenWindow({
            target: 'top',
            title: Name,
            url: Common.AppVirtualPath + url,
            width: $(window).width() * 0.4,
            height: $(window).height() * 0.6,
            actions: ["Close"],
            callback: function (result) {
                if (result == "success") {
                    that.Query();
                }
            }
        });
    }
    var setLayout = function () {
    }

    return that;
}();