
function createExampleTab(id, url, tabTitle) {
    var win, tab, hostName, exampleName, node;

//    if (id == "-") {
//        id = Ext.id();
//        url = "/Pages" + url;
//    }


    var tabslength = ExampleTabs.items.length;

    if (tabslength > 10) {

        Ext.Msg.alert(Messages.CREATE_TAB_ALERT_TITLE, Messages.CREATE_TAB_ALERT_MESSAGE);
        return;
    }
    
    hostName = window.location.protocol + "//" + window.location.host;
   
    tab = ExampleTabs.add(new Ext.Panel({
            id: id,
            /**
            tbar: [
            '->',
            {
                text: 'Reload',
                handler: function() {
                    Ext.getCmp(id).reload(true)
                },
                iconCls: 'icon-arrow-refresh'
            }],
            */
            title: tabTitle,
            autoLoad: {
                showMask: true,
                scripts: true,
                mode: "iframe",
                url: hostName + url
            },
            listeners: {
                deactivate: {
                    fn: function(el) {
                        if (this.sWin && this.sWin.isVisible()) {
                            this.sWin.hide();
                        }
                    }
                }
            },
            closable: true,
            iconCls: "icon-vcard"
            
        }));

        //tab.sWin = win;
        ExampleTabs.setActiveTab(tab);

 
    }