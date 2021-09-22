
// 时间格式化
// Author : Donson
var formatDate = function(v) {

    return Ext.util.Format.date(v, 'm/d/Y ');

}

// 根据Key 取得 Value的值
// 数据源为json序列化得来的数组
// Author : Donson
var getValueFromArray = function(jsonData, key) {
    var value = "";

    if (jsonData == null || key == null) return "";

    if (jsonData != "") {
        var array = eval('(' + jsonData + ')');

        if (array != null) {
            var len = array.length;

            if (len > 0) {
                var m = len / 2;
                for (var i = 0; i < len; i++) {
                    if (array[i][0].toString().toUpperCase() == key.toString().toUpperCase()) {
                        value = array[i][1];
                        return value;
                    }

                    if (array[len - i - 1][0].toString().toUpperCase() == key.toString().toUpperCase()) {
                        value = array[len - i - 1][1];
                        return value;
                    }

                    if (i > m) break;

                } //for
            } //len>0
        }// array != null
    }

    return value;
}

// 根据Key 取得 Value的值
// 数据源为json序列化得来的List对象，具有key , value属性
// Author : Donson
var getValueFromList = function(jsonData, key) {
    var value = "";

    if (jsonData == null || key == null) return "";

    if (jsonData != "") {
        var array = eval('(' + jsonData + ')');

        if (array != null) {
            var len = array.length;

            if (len > 0) {
                var m = len / 2;
                for (var i = 0; i < len; i++) {
                    if (array[i].key == key) {
                        value = array[i].value;
                        return value;
                    }

                    if (array[len - i - 1].key == key) {
                        value = array[len - i - 1].value;
                        return value;
                    }

                    if (i > m) break;

                } //for
            } //len>0
        } // array != null
    }

    return value;
}

//added by Bozhenfei on 20090724
//modified by Bozhenfei on 20100511
//通过已有的store取得ID对应的值
//举例map={Key:'Id',Value:'ChineseName'}
function getNameFromStoreById(store, map, id) {
    var key = map.Key;
    var value = map.Value;
    var index = store.find(key, id);
    if (index >= 0) {
        return store.getAt(index).get(value);
    }
    return id;
}

//added by Bozhenfei on 20090728
//显示extjs消息框
var ShowError = function(msg) {
    Ext.example.msg('Error', msg);
}

var IsStoreDirty = function(store) {
    for (var i = 0; i < store.getCount(); i++) {
        var record = store.getAt(i);
        if (record.dirty) {
            //alert('Record is dirty');
            return true;
        }
    }
    return false;
}

