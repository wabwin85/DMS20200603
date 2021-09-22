<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="DealerMasterEditor.ascx.cs" Inherits="DMS.Website.Controls.DealerMasterEditor" %>
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<style type="text/css">
    .list-item
    {
        font: normal 11px tahoma, arial, helvetica, sans-serif;
        padding: 3px 10px 3px 10px;
        border: 1px solid #fff;
        border-bottom: 1px solid #eeeeee;
        white-space: normal;
        color: #555;
    }
    .list-item h3
    {
        display: block;
        font: inherit;
        font-weight: bold;
        color: #222;
    }
</style>

<script type="text/javascript">
    var storeRecord;
    var grid =null ;

    var createDealerMasterDetails = function (record, mygrid, animTrg, flag) {
    
        Ext.getCmp('<%= DealerType.ClientID %>').setDisabled(false);
        Ext.getCmp('<%= SNDealer.ClientID %>').hide();
        Ext.getCmp('<%= ExportButton.ClientID %>').hide();
          
        <%= flag.ClientID %>.setValue(flag);
        
        storeRecord = record;
        grid = mygrid;
        
        var window = <%= DealerMasterDetailsWindow.ClientID %>;
        window.setTitle(String.format('<%=GetLocalResourceObject("window.Title").ToString()%>','<%=GetLocalResourceObject("window.Title.DealerName").ToString()%>'));
     
        <%= Id1.ClientID %>.setValue(record.data['Id']);
        
        <%= ChineseName.ClientID %>.setValue("");
        <%= ChineseShortName.ClientID %>.setValue("");
        <%= EnglishName.ClientID %>.setValue("");
        <%= EnglishShortName.ClientID %>.setValue("");
        
        <%= DealerNbr.ClientID %>.setValue("");
        <%= SapCode.ClientID %>.setValue("");
        <%= Province.ClientID %>.setValue("");
        <%= City.ClientID %>.setValue("");
        <%= District.ClientID %>.setValue("");
        
        <%= DealerType.ClientID %>.setValue("");
        <%= CompanyType.ClientID %>.setValue("有限责任公司");
        
        <%= RadioTrue.ClientID %>.setValue(true);
        <%= RadioFalse.ClientID %>.setValue(false);
        <%= SalesModeTrue.ClientID %>.setValue(true);
        <%= SalesModeFalse.ClientID %>.setValue(false);
        <%= FirstContractDate.ClientID %>.setValue(null);
        <%= Taxpayer.ClientID %>.setValue("");
        <%= DealerAuthentication.ClientID %>.setValue("");
        <%= Certification.ClientID %>.setValue("");
        <%= South.ClientID %>.setValue(false);
        <%= North.ClientID %>.setValue(false);
        
        <%= GeneralManager.ClientID %>.setValue("");
        <%= RegisteredAddress.ClientID %>.setValue("");
        <%= Address.ClientID %>.setValue("");
        <%= ShipToAddress.ClientID %>.setValue("");
        <%= PostalCode.ClientID %>.setValue("");
        <%= Phone.ClientID %>.setValue("");
        <%= Fax.ClientID %>.setValue("");
        <%= ContactPerson.ClientID %>.setValue("");
        <%= Email.ClientID %>.setValue("");
        
        <%= LegalRep.ClientID %>.setValue("");
        <%= RegisteredCapital.ClientID %>.setValue("");
        <%= BankAccount.ClientID %>.setValue("");
        <%= Bank.ClientID %>.setValue("");
        <%= TaxNo.ClientID %>.setValue("");
        <%= License.ClientID %>.setValue("");
        <%= LicenseLimit.ClientID %>.setValue("");
        <%= EstablishDate.ClientID %>.setValue(null);
        <%= SystemStartDate.ClientID %>.setValue(null);
        <%= Finance.ClientID %>.setValue("");
        <%= FinancePhone.ClientID %>.setValue("");
        <%= FinanceEmail.ClientID %>.setValue("");
        <%= Payment.ClientID %>.setValue("");
        Ext.getCmp('<%=this.gpAttachment.ClientID%>').reload();     
        window.show(animTrg);
    }

    var openDealerDetails = function (record, animTrg, flag) {
    
    
         if(<%= DealerType.ClientID %>.getValue()=="T2")
         { 
            Ext.getCmp('<%= SNDealer.ClientID %>').show();
         }
         //Ext.getCmp('<%= DealerType.ClientID %>').setDisabled(true);
        var tabpan = <%= TabPanel1.ClientID %>;
        tabpan.setActiveTab(0); 
        
        <%= flag.ClientID %>.setValue(flag);
        
        storeRecord = record;
        var window = <%= DealerMasterDetailsWindow.ClientID %>;
        window.setTitle(String.format('<%=GetLocalResourceObject("window.Title").ToString()%>',record.data['ChineseName']));
        <%= Id1.ClientID %>.setValue(record.data['Id']);
        <%= hidDma_id.ClientID %>.setValue(record.data['Id']);
        <%= hidDma_Type.ClientID %>.setValue(record.data['DealerType']);

        <%= ChineseName.ClientID %>.setValue(record.data['ChineseName']);
        <%= ChineseShortName.ClientID %>.setValue(record.data['ChineseShortName']);
        <%= EnglishName.ClientID %>.setValue(record.data['EnglishName']);
        <%= EnglishShortName.ClientID %>.setValue(record.data['EnglishShortName']);
        
        <%= DealerNbr.ClientID %>.setValue(record.data['Nbr']);
        <%= SapCode.ClientID %>.setValue(record.data['SapCode']);
        <%= Province.ClientID %>.setValue(record.data['Province']);
        <%= City.ClientID %>.setValue(record.data['City']);
        <%= District.ClientID %>.setValue(record.data['District']);
        
        <%= DealerType.ClientID %>.setValue(record.data['DealerType']);
        <%= CompanyType.ClientID %>.setValue(record.data['CompanyType']);
        <%= DealerAuthentication.ClientID %>.setValue(record.data['DealerAuthentication']);
        <%= Certification.ClientID %>.setValue(record.data['Certification']);
        
        if (record.data['ActiveFlag']==true)
        {
            <%= RadioTrue.ClientID %>.setValue(true);
            <%= RadioFalse.ClientID %>.setValue(false);
        }
        else
        {
            <%= RadioTrue.ClientID %>.setValue(false);
            <%= RadioFalse.ClientID %>.setValue(true);
        }
        if (record.data['SalesMode']==true)
        {
            <%= SalesModeTrue.ClientID %>.setValue(true);
            <%= SalesModeFalse.ClientID %>.setValue(false);
        }
        else
        {
            <%= SalesModeTrue.ClientID %>.setValue(false);
            <%= SalesModeFalse.ClientID %>.setValue(true);
        }
        
        if (record.data['FirstContractDate'] != null){
            var firstDate = (record.data['FirstContractDate']).substring(0,10);
            <%= FirstContractDate.ClientID %>.setValue(firstDate);
        }else
        {
           <%= FirstContractDate.ClientID %>.setValue(null);
        }
        
        <%= Taxpayer.ClientID %>.setValue(record.data['Taxpayer']);
        
        <%= GeneralManager.ClientID %>.setValue(record.data['GeneralManager']);
        <%= RegisteredAddress.ClientID %>.setValue(record.data['RegisteredAddress']);
        <%= Address.ClientID %>.setValue(record.data['Address']);
        <%= ShipToAddress.ClientID %>.setValue(record.data['ShipToAddress']);
        <%= PostalCode.ClientID %>.setValue(record.data['PostalCode']);
        <%= Phone.ClientID %>.setValue(record.data['Phone']);
        <%= Fax.ClientID %>.setValue(record.data['Fax']);
        <%= ContactPerson.ClientID %>.setValue(record.data['ContactPerson']);
        <%= Email.ClientID %>.setValue(record.data['Email']);
        
        <%= LegalRep.ClientID %>.setValue(record.data['LegalRep']);
        //增加币种格式
        <%= RegisteredCapital.ClientID %>.setValue(Ext.util.Format.number(record.data['RegisteredCapital'],'￥0,000.00'));
        <%= BankAccount.ClientID %>.setValue(record.data['BankAccount']);
        <%= Bank.ClientID %>.setValue(record.data['Bank']);
        <%= TaxNo.ClientID %>.setValue(record.data['TaxNo']);
        <%= License.ClientID %>.setValue(record.data['License']);
        <%= LicenseLimit.ClientID %>.setValue(record.data['LicenseLimit']);
        if (record.data['EstablishDate'] != null){
            var strDate = (record.data['EstablishDate']).substring(0,10);
            <%= EstablishDate.ClientID %>.setValue(strDate);
            }else
            {
               <%= EstablishDate.ClientID %>.setValue(null);
            }
        if (record.data['SystemStartDate'] != null){
            var strDate = (record.data['SystemStartDate']).substring(0,10);
            <%= SystemStartDate.ClientID %>.setValue(strDate);
            }else
            {
               <%= SystemStartDate.ClientID %>.setValue(null);
            }

        <%= Finance.ClientID %>.setValue(record.data['Finance']);
        <%= FinancePhone.ClientID %>.setValue(record.data['FinancePhone']);
        <%= FinanceEmail.ClientID %>.setValue(record.data['FinanceEmail']);
        <%= Payment.ClientID %>.setValue(record.data['Payment']);
        
        Ext.getCmp('<%=this.gpAttachment.ClientID%>').reload();     
       window.show(animTrg);    
     
    }
    
        var saveDealer = function () {
        
        if (<%= ChineseName.ClientID %>.getValue() =="" || <%= FirstContractDate.ClientID %>.getValue()=="" || <%= SapCode.ClientID %>.getValue()=="" || <%= Province.ClientID %>.getValue()=="" || <%= City.ClientID %>.getValue()=="" || <%= District.ClientID %>.getValue()==""||<%=DealerType.ClientID %>.getValue()=="")
        {
            
            alert('<%=GetLocalResourceObject("saveDealer.alert").ToString()%>');
            return;
        }
        
              if(<%=DealerType.ClientID %>.getValue()=="T2"&&<%=North.ClientID %>.getValue()==""
              &&<%=South.ClientID %>.getValue()=="")
              {
                     alert("请选择所属平台");
                     return;
              }   

        storeRecord.set('Id',<%= Id1.ClientID %>.getValue());
        if(<%= DealerType.ClientID %>.getValue()=="T1"||<%= DealerType.ClientID %>.getValue()=="LP"){
           storeRecord.set('ParentDmaId',"FB62D945-C9D7-4B0F-8D26-4672D2C728B7"); 
        } 

           if(<%= DealerType.ClientID %>.getValue()=="T2"&&<%=South.ClientID %>.getValue()==true){
           storeRecord.set('ParentDmaId',"a00fcd75-951d-4d91-8f24-a29900da5e85"); 
        } 
        
           if(<%= DealerType.ClientID %>.getValue()=="T2"&&<%=North.ClientID %>.getValue()==true){
           storeRecord.set('ParentDmaId',"84C83F71-93B4-4EFD-AB51-12354AFABAC3"); 
        } 

        //storeRecord.set('LastUpdateUser',<%= LastUpdateUser.ClientID %>.getValue());
        //storeRecord.set('LastUpdateDate', Ext.util.Format.date(new Date(), "Y-m-d\\TH:i:s"));
        storeRecord.set('LastUpdateUser',null);
        storeRecord.set('LastUpdateDate',null);
        
        storeRecord.set('ChineseName',<%= ChineseName.ClientID %>.getValue());
        storeRecord.set('ChineseShortName',<%= ChineseShortName.ClientID %>.getValue());
        storeRecord.set('EnglishName',<%= EnglishName.ClientID %>.getValue());
        storeRecord.set('EnglishShortName',<%= EnglishShortName.ClientID %>.getValue());
        
        storeRecord.set('Nbr',<%= DealerNbr.ClientID %>.getValue());
        storeRecord.set('SapCode',<%= SapCode.ClientID %>.getValue());
        storeRecord.set('Province',<%= Province.ClientID %>.getValue());
        storeRecord.set('City',<%= City.ClientID %>.getValue());
        storeRecord.set('District',<%= District.ClientID %>.getValue());
        storeRecord.set('DealerAuthentication',<%= DealerAuthentication.ClientID %>.getValue());
        storeRecord.set('Certification',<%= Certification.ClientID %>.getValue());
        
        var selText = <%= Province.ClientID %>.getText();
         if(selText !='<%=GetLocalResourceObject("Province.storeRecord.selText").ToString()%>')
            storeRecord.set('Province',selText);
         
         selText = <%= City.ClientID %>.getText();
        if(selText !='<%=GetLocalResourceObject("City.storeRecord.selText").ToString()%> ') 
            storeRecord.set('City',selText);
            
          selText = <%= District.ClientID %>.getText();
          if(selText !='<%=GetLocalResourceObject("District.storeRecord.selText").ToString()%>') 
            storeRecord.set('District',selText);
        
        
        storeRecord.set('DealerType',<%= DealerType.ClientID %>.getValue());
        storeRecord.set('CompanyType',<%= CompanyType.ClientID %>.getValue());
        if (<%= FirstContractDate.ClientID %>.getValue()=="")
            storeRecord.set('FirstContractDate',null);
        else
        {
            dt =  <%= FirstContractDate.ClientID %>.getValue();
            storeRecord.set('FirstContractDate', Ext.util.Format.date(dt, "Y-m-d\\TH:i:s"));
        }
        
        if (<%= RadioTrue.ClientID %>.getValue() == true)
         {
            storeRecord.set('ActiveFlag',true);
         }else
         {
            storeRecord.set('ActiveFlag',false);
         }
         
         if (<%= SalesModeTrue.ClientID %>.getValue() == true)
         {
            storeRecord.set('SalesMode',true);
         }else
         {
            storeRecord.set('SalesMode',false);
         }
         storeRecord.set('Taxpayer',<%= Taxpayer.ClientID %>.getValue());
        
        storeRecord.set('GeneralManager',<%= GeneralManager.ClientID %>.getValue());
        storeRecord.set('RegisteredAddress',<%= RegisteredAddress.ClientID %>.getValue());
        storeRecord.set('Address',<%= Address.ClientID %>.getValue());
        storeRecord.set('ShipToAddress',<%= ShipToAddress.ClientID %>.getValue());
        storeRecord.set('PostalCode',<%= PostalCode.ClientID %>.getValue());
        storeRecord.set('Phone',<%= Phone.ClientID %>.getValue());
        storeRecord.set('Fax',<%= Fax.ClientID %>.getValue());
        storeRecord.set('ContactPerson',<%= ContactPerson.ClientID %>.getValue());
        storeRecord.set('Email',<%= Email.ClientID %>.getValue());
        
        
        storeRecord.set('LegalRep',<%= LegalRep.ClientID %>.getValue());
        

        //取消币种格式后再作保存        
        var vRegisteredCapital = <%= RegisteredCapital.ClientID %>.getValue().replace(/[￥,]/g, '');
        if (vRegisteredCapital == "")
        {
            vRegisteredCapital = 0;
        }
        storeRecord.set('RegisteredCapital',vRegisteredCapital);
        
        storeRecord.set('BankAccount',<%= BankAccount.ClientID %>.getValue());
        storeRecord.set('Bank',<%= Bank.ClientID %>.getValue());
        storeRecord.set('TaxNo',<%= TaxNo.ClientID %>.getValue());
        storeRecord.set('License',<%= License.ClientID %>.getValue());
        storeRecord.set('LicenseLimit',<%= LicenseLimit.ClientID %>.getValue());
        storeRecord.set('BankAccount',<%= BankAccount.ClientID %>.getValue());
        if (<%= EstablishDate.ClientID %>.getValue()=="")
            storeRecord.set('EstablishDate',null);
        else
        {
            dt =  <%= EstablishDate.ClientID %>.getValue();
            storeRecord.set('EstablishDate', Ext.util.Format.date(dt, "Y-m-d\\TH:i:s"));
        }
         if (<%= SystemStartDate.ClientID %>.getValue()=="")
            storeRecord.set('SystemStartDate',null);

        else
        {
            dt =  <%= SystemStartDate.ClientID %>.getValue();
            storeRecord.set('SystemStartDate', Ext.util.Format.date(dt, "Y-m-d\\TH:i:s"));
        }

        storeRecord.set('HostCompanyFlag',null);
        
        storeRecord.set('Finance',<%= Finance.ClientID %>.getValue());
        storeRecord.set('FinancePhone',<%= FinancePhone.ClientID %>.getValue());
        storeRecord.set('FinanceEmail',<%= FinanceEmail.ClientID %>.getValue());
        
        var payment = <%= Payment.ClientID %>.getValue();
        if(<%= Payment.ClientID %>.getValue()=="")
            storeRecord.set('Payment',null);
        else
            storeRecord.set('Payment',<%= Payment.ClientID %>.getValue());
        
        storeRecord.set('DeletedFlag',false);     
        
         
        <%= DealerMasterDetailsWindow.ClientID %>.hide(null);
        
    }
    
    var cancelDetailEdit =function()
    {
        if(grid != null )
        {
           var gd = Ext.getCmp(grid) ;
           if(gd != null && <%= flag.ClientID %>.value != "1")
              gd.deleteRecord(storeRecord)
        }   
        <%= DealerMasterDetailsWindow.ClientID %>.hide(null);
    }

        Ext.apply(Ext.util.Format, {            number: function(v, format) {                if(!format){                    return v;                }                                                v *= 1;                if(typeof v != 'number' || isNaN(v)){                    return '';                }                var comma = ',';                var dec = '.';                var i18n = false;                                if(format.substr(format.length - 2) == '/i'){                    format = format.substr(0, format.length-2);                    i18n = true;                    comma = '.';                    dec = ',';                }                var hasComma = format.indexOf(comma) != -1,                    psplit = (i18n ? format.replace(/[^\d\,]/g,'') : format.replace(/[^\d\.]/g,'')).split(dec);                if (1 < psplit.length) {                    v = v.toFixed(psplit[1].length);                }                else if (2 < psplit.length) {                    throw('NumberFormatException: invalid format, formats should have no more than 1 period: ' + format);                }                else {                    v = v.toFixed(0);                }                var fnum = v.toString();                if (hasComma) {                    psplit = fnum.split('.');                    var cnum = psplit[0],                        parr = [],                        j = cnum.length,                        m = Math.floor(j / 3),                        n = cnum.length % 3 || 3;                    for (var i = 0; i < j; i += n) {                        if (i != 0) {n = 3;}                        parr[parr.length] = cnum.substr(i, n);                        m -= 1;                    }                    fnum = parr.join(comma);                    if (psplit[1]) {                        fnum += dec + psplit[1];                    }                }                return format.replace(/[\d,?\.?]+/, fnum);            },            numberRenderer : function(format){                return function(v){                    return Ext.util.Format.number(v, format);                };            }        });
    
    var ctrlGetFocus=function()
    {
        <%= RegisteredCapital.ClientID %>.setValue(<%= RegisteredCapital.ClientID %>.value.replace(/[￥,]/g, ''));
    }
    
    var formatMoneyString=function()
    {
        <%= RegisteredCapital.ClientID %>.setValue(Ext.util.Format.number(<%= RegisteredCapital.ClientID %>.getValue(),'￥0,000.00'));
    }
    
  var  ChangeDealerType=function()
  {
     if(<%= DealerType.ClientID %>.getValue()=="T2")
     {
       Ext.getCmp('<%= SNDealer.ClientID %>').show();
     }
     else{
         Ext.getCmp('<%= SNDealer.ClientID %>').hide();
     }
     
  }
  
  function ChangeData() {
  
     var ExportType = Ext.getCmp('<%=this.cbExportType.ClientID%>');
     
     if (ExportType != null && ExportType.getValue()!='') {
       if( ExportType.getValue()=="1")
       {
            Ext.getCmp('<%= cbYear.ClientID %>').hide();
            Ext.getCmp('<%= cbProductLine.ClientID %>').show();
            Ext.getCmp('<%= cbAllProduct.ClientID %>').hide();
            
            Ext.getCmp('<%= ExportButtonAuthorization.ClientID %>').show();
            Ext.getCmp('<%= ButtonAOPD.ClientID %>').hide();
            Ext.getCmp('<%= ButtonAOPH.ClientID %>').hide();
            Ext.getCmp('<%= ButtonAOPP.ClientID %>').hide();
       }
       else if(ExportType.getValue()=="2")
       {
            Ext.getCmp('<%= cbYear.ClientID %>').show();
             Ext.getCmp('<%= cbProductLine.ClientID %>').show();
            Ext.getCmp('<%= cbAllProduct.ClientID %>').hide();
            
            Ext.getCmp('<%= ExportButtonAuthorization.ClientID %>').hide();
            Ext.getCmp('<%= ButtonAOPD.ClientID %>').show();
            Ext.getCmp('<%= ButtonAOPH.ClientID %>').show();
            Ext.getCmp('<%= ButtonAOPP.ClientID %>').show();
       }
       else if(ExportType.getValue()=="3")
       {
            Ext.getCmp('<%= cbYear.ClientID %>').hide();
            Ext.getCmp('<%= cbProductLine.ClientID %>').hide();
            Ext.getCmp('<%= cbAllProduct.ClientID %>').show();
            
            Ext.getCmp('<%= ExportButtonAuthorization.ClientID %>').show();
            Ext.getCmp('<%= ButtonAOPD.ClientID %>').hide();
            Ext.getCmp('<%= ButtonAOPH.ClientID %>').hide();
            Ext.getCmp('<%= ButtonAOPP.ClientID %>').hide();
       }
         else if(ExportType.getValue()=="4")
       {
            Ext.getCmp('<%= cbYear.ClientID %>').show();
            Ext.getCmp('<%= cbProductLine.ClientID %>').hide();
            Ext.getCmp('<%= cbAllProduct.ClientID %>').show();
            
            Ext.getCmp('<%= ExportButtonAuthorization.ClientID %>').hide();
            Ext.getCmp('<%= ButtonAOPD.ClientID %>').show();
            Ext.getCmp('<%= ButtonAOPH.ClientID %>').show();
            Ext.getCmp('<%= ButtonAOPP.ClientID %>').show();
       }
     } 
   }
   
</script>

<asp:PlaceHolder ID="storeHolder" runat="server">
    <ext:Store ID="ProvincesStore" runat="server" UseIdConfirmation="true" OnRefreshData="Store_RefreshProvinces">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="TerId">
                <Fields>
                    <ext:RecordField Name="TerId" />
                    <ext:RecordField Name="Description" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <Listeners>
        </Listeners>
    </ext:Store>
    <ext:Store ID="CitiesStore" runat="server" UseIdConfirmation="true" OnRefreshData="Store_RefreshCities">
        <AutoLoadParams>
            <ext:Parameter Name="parentId" Value="={0}" />
        </AutoLoadParams>
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="TerId">
                <Fields>
                    <ext:RecordField Name="TerId" />
                    <ext:RecordField Name="Description" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <Listeners>
        </Listeners>
    </ext:Store>
    <ext:Store ID="DistrictStore" runat="server" UseIdConfirmation="true" OnRefreshData="Store_RefreshDistricts">
        <AutoLoadParams>
            <ext:Parameter Name="parentId" Value="={0}" />
        </AutoLoadParams>
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="TerId">
                <Fields>
                    <ext:RecordField Name="TerId" />
                    <ext:RecordField Name="Description" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <Listeners>
        </Listeners>
    </ext:Store>
    <ext:Store ID="DealerTypeStore" runat="server" UseIdConfirmation="false" OnRefreshData="DealerTypeStore_RefreshData">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="Key">
                <Fields>
                    <ext:RecordField Name="Key" />
                    <ext:RecordField Name="Value" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <SortInfo Field="Key" Direction="ASC" />
        <Listeners>
        </Listeners>
    </ext:Store>
    <ext:Store ID="TaxpayerTypeStore" runat="server" UseIdConfirmation="true" AutoLoad="true" OnRefreshData="Store_RefreshDictionary">
        <BaseParams>
            <ext:Parameter Name="Type" Value="CONST_Taxpayer_Type" Mode="Value">
            </ext:Parameter>
        </BaseParams>
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="Key">
                <Fields>
                    <ext:RecordField Name="Key" />
                    <ext:RecordField Name="Value" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <SortInfo Field="Key" Direction="ASC" />
    </ext:Store>
    <ext:Store ID="DealerAuthenticationStore" runat="server" UseIdConfirmation="true" AutoLoad="true" OnRefreshData="Store_RefreshDictionary">
        <BaseParams>
            <ext:Parameter Name="Type" Value="CONST_Dealer_Authentication" Mode="Value">
            </ext:Parameter>
        </BaseParams>
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="Key">
                <Fields>
                    <ext:RecordField Name="Key" />
                    <ext:RecordField Name="Value" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <SortInfo Field="Key" Direction="ASC" />
    </ext:Store>
    <ext:Store ID="PaymentStore" runat="server" UseIdConfirmation="true" OnRefreshData="Payment_RefershData" AutoLoad="true">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="Name">
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="Name" />
                    <ext:RecordField Name="Description" />
                    <ext:RecordField Name="Parameter1" />
                    <ext:RecordField Name="Parameter2" />
                    <ext:RecordField Name="Parameter3" />
                    <ext:RecordField Name="Parameter4" />
                    <ext:RecordField Name="Parameter5" />
                    <ext:RecordField Name="Parameter6" />
                    <ext:RecordField Name="Parameter7" />
                    <ext:RecordField Name="Parameter8" />
                    <ext:RecordField Name="ActiveFlag" />
                    <ext:RecordField Name="DeleteFlag" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <Listeners>
        </Listeners>
    </ext:Store>
    <ext:Store ID="AttachmentType" runat="server" UseIdConfirmation="true" AutoLoad="false" OnRefreshData="Store_RefreshAttachmentType">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="Key">
                <Fields>
                    <ext:RecordField Name="Key" />
                    <ext:RecordField Name="Value" />
                </Fields>
            </ext:JsonReader>
        </Reader>
    </ext:Store>
    <ext:Store ID="AttachmentStore" runat="server" UseIdConfirmation="true" AutoLoad="false" OnRefreshData="Store_RefreshAttachment">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="Id">
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="Attachment" />
                    <ext:RecordField Name="Name" />
                    <ext:RecordField Name="Url" />
                    <ext:RecordField Name="Type" />
                    <ext:RecordField Name="UploadUser" />
                    <ext:RecordField Name="Identity_Name" />
                    <ext:RecordField Name="UploadDate" />
                    <ext:RecordField Name="TypeName" />
                </Fields>
            </ext:JsonReader>
        </Reader>
    </ext:Store>
    <ext:Store ID="ProductLineStore" runat="server" UseIdConfirmation="true" AutoLoad="false" OnRefreshData="Store_ProductLine">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="ProductLineId">
                <Fields>
                    <ext:RecordField Name="ProductLineId" />
                    <ext:RecordField Name="ProductLineName" />
                </Fields>
            </ext:JsonReader>
        </Reader>
    </ext:Store>
    <ext:Store ID="YearStore" runat="server" UseIdConfirmation="true" AutoLoad="false" OnRefreshData="Store_YearStore">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="COP_Period">
                <Fields>
                    <ext:RecordField Name="COP_Period" />
                    <ext:RecordField Name="COP_Period" />
                </Fields>
            </ext:JsonReader>
        </Reader>
    </ext:Store>
    <ext:Store ID="ExportTypeStore" runat="server" UseIdConfirmation="true" AutoLoad="true" OnRefreshData="Store_ExportType">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="Value">
                <Fields>
                    <ext:RecordField Name="Value" />
                    <ext:RecordField Name="Name" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <Listeners>
            <Load Handler="#{cbExportType}.setValue(#{cbExportType}.store.getTotalCount()>0?#{cbExportType}.store.getAt(0).get('Value'):'');" />
        </Listeners>
    </ext:Store>
    <ext:Store ID="AllProductLineStore" runat="server" UseIdConfirmation="true" AutoLoad="false" OnRefreshData="Store_AllProductLine">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="Id">
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="AttributeName" />
                </Fields>
            </ext:JsonReader>
        </Reader>
    </ext:Store>
</asp:PlaceHolder>
<ext:Window ID="DealerMasterDetailsWindow" runat="server" Icon="Group" Title="Dealer Details" Width="630" Height="450" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;" Closable="false">
    <Body>
        <ext:FitLayout ID="FitLayout1" runat="server">
            <ext:TabPanel ID="TabPanel1" runat="server" ActiveTabIndex="0" Border="false">
                <Tabs>
                    <ext:Tab ID="CompanyInfoTab" runat="server" Title="<%$ Resources: CompanyInfoTab.Title %>" Icon="ChartOrganisation" BodyStyle="padding:5px;">
                        <Body>
                            <ext:FormLayout ID="FormLayoutHeader" runat="server">
                                <ext:Anchor>
                                    <ext:Hidden ID="hidDma_id" runat="server">
                                    </ext:Hidden>
                                </ext:Anchor>
                                <ext:Anchor>
                                    <ext:Hidden ID="hidDma_Type" runat="server">
                                    </ext:Hidden>
                                </ext:Anchor>
                                <ext:Anchor>
                                    <ext:TextField ID="Id1" Hidden="true" runat="server" FieldLabel="<%$ Resources: CompanyInfoTab.Id1.FieldLabel %>" Width="250" Disabled="true" />
                                </ext:Anchor>
                                <ext:Anchor>
                                    <ext:TextField ID="flag" Hidden="true" runat="server" />
                                </ext:Anchor>
                                <ext:Anchor>
                                    <ext:TextField ID="LastUpdateUser" Hidden="true" runat="server" />
                                </ext:Anchor>
                                <ext:Anchor>
                                    <ext:DateField ID="LastUpdateDate" runat="server" Hidden="true" />
                                </ext:Anchor>
                                <ext:Anchor>
                                    <ext:Panel ID="PanelBody" runat="server" FormGroup="true" AutoHeight="true">
                                        <Body>
                                            <ext:ColumnLayout ID="LeftColumn" runat="server">
                                                <ext:LayoutColumn ColumnWidth="0.5">
                                                    <ext:Panel ID="Panel2" runat="server" BodyBorder="false" Header="false">
                                                        <Body>
                                                            <ext:FormLayout ID="FormLayout11" runat="server">
                                                                <ext:Anchor>
                                                                    <ext:TextField ID="ChineseName" runat="server" FieldLabel="<%$ Resources: CompanyInfoTab.ChineseName.FieldLabel %>" Width="150" AllowBlank="false" />
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:TextField ID="EnglishName" runat="server" FieldLabel="<%$ Resources: CompanyInfoTab.EnglishName.FieldLabel %>" Width="150" />
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:TextField ID="DealerNbr" runat="server" FieldLabel="<%$ Resources: CompanyInfoTab.DealerNbr.FieldLabel %>" Width="150">
                                                                    </ext:TextField>
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:ComboBox ID="Province" runat="server" FieldLabel="<%$ Resources: CompanyInfoTab.Province.FieldLabel %>" StoreID="ProvincesStore" Editable="false" DisplayField="Description" ValueField="TerId" TypeAhead="true" Mode="Local" ForceSelection="true" TriggerAction="All"
                                                                        EmptyText="<%$ Resources: Province.storeRecord.selText %>" SelectOnFocus="true" Width="150" AllowBlank="false">
                                                                        <Listeners>
                                                                            <Select Handler="#{City}.clearValue(); #{CitiesStore}.reload();" />
                                                                        </Listeners>
                                                                    </ext:ComboBox>
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:ComboBox ID="District" runat="server" FieldLabel="<%$ Resources: CompanyInfoTab.District.FieldLabel %>" StoreID="DistrictStore" Editable="false" DisplayField="Description" ValueField="TerId" TypeAhead="true" Mode="Local" ForceSelection="true" TriggerAction="All"
                                                                        EmptyText="<%$ Resources: District.storeRecord.selText %>" Width="150" SelectOnFocus="true" AllowBlank="false">
                                                                    </ext:ComboBox>
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:ComboBox ID="DealerType" runat="server" FieldLabel="<%$ Resources: CompanyInfoTab.DealerType.FieldLabel %>" StoreID="DealerTypeStore" Editable="false" TypeAhead="true" Mode="Local" DisplayField="Value" ValueField="Key" Width="150" ForceSelection="true"
                                                                        TriggerAction="All" EmptyText="<%$ Resources: CompanyInfoTab.DealerType.EmptyText %>" ItemSelector="div.list-item" SelectOnFocus="true" AllowBlank="false">
                                                                        <Template ID="Template2" runat="server">
                                                                            <tpl for=".">
                                                                                <div class="list-item">
                                                                                     {Value}
                                                                                </div>
                                                                            </tpl>
                                                                        </Template>
                                                                        <Listeners>
                                                                            <Select Handler="ChangeDealerType()" />
                                                                        </Listeners>
                                                                    </ext:ComboBox>
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:RadioGroup ID="SNDealer" runat="server" FieldLabel="所属平台" ColumnsNumber="2" AllowBlank="false">
                                                                        <Items>
                                                                            <ext:Radio ID="South" runat="server" BoxLabel="南方" Checked="false" />
                                                                            <ext:Radio ID="North" runat="server" BoxLabel="北方" Checked="false" />
                                                                        </Items>
                                                                    </ext:RadioGroup>
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:TextField ID="ParentDmaId" runat="server" FieldLabel="ParentDmaId" Hidden="true">
                                                                    </ext:TextField>
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:DateField ID="FirstContractDate" runat="server" FieldLabel="<%$ Resources: CompanyInfoTab.FirstContractDate.FieldLabel %>" Width="150" AllowBlank="false" />
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:DateField ID="SystemStartDate" runat="server" FieldLabel="<%$ Resources: CompanyInfoTab.SystemStartDate.FieldLabel %>" Width="150" AllowBlank="true" />
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:RadioGroup ID="ActiveFlag" runat="server" FieldLabel="<%$ Resources: CompanyInfoTab.ActiveFlag.FieldLabel %>" ColumnsNumber="2">
                                                                        <Items>
                                                                            <ext:Radio ID="RadioTrue" runat="server" BoxLabel="<%$ Resources: CompanyInfoTab.ActiveFlag.RadioTrue.BoxLabel %>" Checked="true" />
                                                                            <ext:Radio ID="RadioFalse" runat="server" BoxLabel="<%$ Resources: CompanyInfoTab.ActiveFlag.RadioFalse.BoxLabel %>" Checked="false" />
                                                                        </Items>
                                                                    </ext:RadioGroup>
                                                                </ext:Anchor>
                                                            </ext:FormLayout>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:LayoutColumn>
                                                <ext:LayoutColumn ColumnWidth="0.5">
                                                    <ext:Panel ID="Panel1" runat="server" BodyBorder="false" Header="false">
                                                        <Body>
                                                            <ext:FormLayout ID="FormLayout3" runat="server">
                                                                <ext:Anchor>
                                                                    <ext:TextField ID="ChineseShortName" runat="server" FieldLabel="<%$ Resources: CompanyInfoTab.ChineseShortName.FieldLabel %>" Width="150" />
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:TextField ID="EnglishShortName" runat="server" FieldLabel="<%$ Resources: CompanyInfoTab.EnglishShortName.FieldLabel %>" Width="150" />
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:TextField ID="SapCode" runat="server" AllowBlank="false" FieldLabel="<%$ Resources: CompanyInfoTab.SapCode.FieldLabel %>" Width="150">
                                                                    </ext:TextField>
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:ComboBox ID="City" runat="server" FieldLabel="<%$ Resources: CompanyInfoTab.City.FieldLabel %>" StoreID="CitiesStore" Editable="false" DisplayField="Description" ValueField="TerId" TypeAhead="true" Mode="Local" ForceSelection="true" TriggerAction="All"
                                                                        EmptyText="<%$ Resources: City.storeRecord.selText %>" SelectOnFocus="true" Width="150" AllowBlank="false">
                                                                        <Listeners>
                                                                            <Select Handler="#{District}.clearValue(); #{DistrictStore}.reload();" />
                                                                        </Listeners>
                                                                    </ext:ComboBox>
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:TextField ID="CompanyType" runat="server" FieldLabel="<%$ Resources: CompanyInfoTab.CompanyType.FieldLabel %>" Width="150" />
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:ComboBox ID="Taxpayer" runat="server" FieldLabel="<%$ Resources: CompanyInfoTab.Taxpayer.FieldLabel %>" Editable="false" TypeAhead="true" Mode="Local" Width="150" StoreID="TaxpayerTypeStore" ValueField="Key" DisplayField="Value" ForceSelection="true"
                                                                        TriggerAction="All" EmptyText="<%$ Resources: CompanyInfoTab.Taxpayer.EmptyText %>" ItemSelector="div.list-item" SelectOnFocus="true">
                                                                        <Template ID="Template4" runat="server">
                                                                            <tpl for=".">
                                                                                <div class="list-item">
                                                                                     {Value}
                                                                                </div>
                                                                            </tpl>
                                                                        </Template>
                                                                    </ext:ComboBox>
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:RadioGroup ID="SalesMode" runat="server" FieldLabel="<%$ Resources: CompanyInfoTab.SalesMode.FieldLabel %>" ColumnsNumber="2">
                                                                        <Items>
                                                                            <ext:Radio ID="SalesModeTrue" runat="server" BoxLabel="<%$ Resources: CompanyInfoTab.SalesMode.SalesModeTrue.BoxLabel %>" Checked="true" />
                                                                            <ext:Radio ID="SalesModeFalse" runat="server" BoxLabel="<%$ Resources: CompanyInfoTab.SalesMode.SalesModeFalse.BoxLabel %>" Checked="false" />
                                                                        </Items>
                                                                    </ext:RadioGroup>
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:ComboBox ID="DealerAuthentication" runat="server" FieldLabel="<%$ Resources: CompanyInfoTab.DealerAuthentication.FieldLabel %>" Editable="false" TypeAhead="true" Mode="Local" Width="150" StoreID="DealerAuthenticationStore" ValueField="Key" DisplayField="Value"
                                                                        ForceSelection="true" TriggerAction="All" EmptyText="<%$ Resources: CompanyInfoTab.DealerAuthentication.EmptyText %>" ItemSelector="div.list-item" SelectOnFocus="true">
                                                                        <Template ID="Template1" runat="server">
                                                                            <tpl for=".">
                                                                                <div class="list-item">
                                                                                     {Value}
                                                                                </div>
                                                                            </tpl>
                                                                        </Template>
                                                                    </ext:ComboBox>
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:TextField ID="Certification" runat="server" FieldLabel="<%$ Resources: CompanyInfoTab.Certification.FieldLabel %>" Width="150" />
                                                                </ext:Anchor>
                                                            </ext:FormLayout>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:LayoutColumn>
                                            </ext:ColumnLayout>
                                        </Body>
                                    </ext:Panel>
                                </ext:Anchor>
                            </ext:FormLayout>
                        </Body>
                    </ext:Tab>
                    <ext:Tab ID="CompanyInfoTab2" runat="server" Title="<%$ Resources: CompanyInfoTab2.Title %>" Icon="ChartOrganisation" BodyStyle="padding:5px;">
                        <Body>
                            <ext:FormLayout ID="FormLayout2" runat="server">
                                <ext:Anchor>
                                    <ext:TextField ID="RegisteredAddress" runat="server" FieldLabel="<%$ Resources: CompanyInfoTab2.RegisteredAddress.FieldLabel %>" Width="250" />
                                </ext:Anchor>
                                <ext:Anchor>
                                    <ext:TextField ID="Address" runat="server" FieldLabel="<%$ Resources: CompanyInfoTab2.Address.FieldLabel %>" Width="250" />
                                </ext:Anchor>
                                <ext:Anchor>
                                    <ext:TextField ID="ShipToAddress" runat="server" FieldLabel="<%$ Resources: CompanyInfoTab2.ShipToAddress.FieldLabel %>" Width="250" />
                                </ext:Anchor>
                                <ext:Anchor>
                                    <ext:TextField ID="PostalCode" runat="server" FieldLabel="<%$ Resources: CompanyInfoTab2.PostalCode.FieldLabel %>" Width="250" />
                                </ext:Anchor>
                                <ext:Anchor>
                                    <ext:TextField ID="Phone" runat="server" FieldLabel="<%$ Resources: CompanyInfoTab2.Phone.FieldLabel %>" Width="250" />
                                </ext:Anchor>
                                <ext:Anchor>
                                    <ext:TextField ID="Fax" runat="server" FieldLabel="<%$ Resources: CompanyInfoTab2.Fax.FieldLabel %>" Width="250" />
                                </ext:Anchor>
                                <ext:Anchor>
                                    <ext:TextField ID="ContactPerson" runat="server" FieldLabel="<%$ Resources: CompanyInfoTab2.ContactPerson.FieldLabel %>" Width="250" />
                                </ext:Anchor>
                                <ext:Anchor>
                                    <ext:TextField ID="Email" runat="server" FieldLabel="<%$ Resources: CompanyInfoTab2.Email.FieldLabel %>" Width="250" />
                                </ext:Anchor>
                            </ext:FormLayout>
                        </Body>
                    </ext:Tab>
                    <ext:Tab ID="RegisteredInfo" runat="server" Title="<%$ Resources: RegisteredInfo.Title %>" Icon="ChartOrganisation" BodyStyle="padding:5px;">
                        <Body>
                            <ext:FormLayout ID="FormLayout1" runat="server">
                                <ext:Anchor>
                                    <ext:TextField ID="GeneralManager" runat="server" FieldLabel="<%$ Resources: RegisteredInfo.GeneralManager.FieldLabel %>" Width="250" />
                                </ext:Anchor>
                                <ext:Anchor>
                                    <ext:TextField ID="LegalRep" runat="server" FieldLabel="<%$ Resources: RegisteredInfo.LegalRep.FieldLabel %>" Width="250" />
                                </ext:Anchor>
                                <ext:Anchor>
                                    <ext:TextField ID="RegisteredCapital" runat="server" FieldLabel="<%$ Resources: RegisteredInfo.RegisteredCapital.FieldLabel %>" Width="250" MaskRe="/[0-9￥\.,]/" SelectOnFocus="false">
                                        <Listeners>
                                            <Focus Handler="{ctrlGetFocus();}" />
                                            <Blur Handler="{formatMoneyString();}" />
                                        </Listeners>
                                    </ext:TextField>
                                </ext:Anchor>
                                <ext:Anchor>
                                    <ext:TextField ID="BankAccount" runat="server" FieldLabel="<%$ Resources: RegisteredInfo.BankAccount.FieldLabel %>" Width="250" />
                                </ext:Anchor>
                                <ext:Anchor>
                                    <ext:TextField ID="Bank" runat="server" FieldLabel="<%$ Resources: RegisteredInfo.Bank.FieldLabel %>" Width="250" />
                                </ext:Anchor>
                                <ext:Anchor>
                                    <ext:TextField ID="TaxNo" runat="server" FieldLabel="<%$ Resources: RegisteredInfo.TaxNo.FieldLabel %>" Width="250" />
                                </ext:Anchor>
                                <ext:Anchor>
                                    <ext:TextField ID="License" runat="server" FieldLabel="<%$ Resources: RegisteredInfo.License.FieldLabel %>" Width="250" />
                                </ext:Anchor>
                                <ext:Anchor>
                                    <ext:TextField ID="LicenseLimit" runat="server" FieldLabel="<%$ Resources: RegisteredInfo.LicenseLimit.FieldLabel %>" Width="250" />
                                </ext:Anchor>
                                <ext:Anchor>
                                    <ext:DateField ID="EstablishDate" runat="server" FieldLabel="<%$ Resources: RegisteredInfo.EstablishDate.FieldLabel %>" Width="250" Format="Y-m-d" />
                                </ext:Anchor>
                            </ext:FormLayout>
                        </Body>
                    </ext:Tab>
                    <ext:Tab ID="FinanceInfo" runat="server" Title="<%$ Resources: FinanceInfo.Title %>" Icon="ChartOrganisation" BodyStyle="padding:5px;">
                        <Body>
                            <ext:FormLayout ID="FormLayout4" runat="server">
                                <ext:Anchor>
                                    <ext:TextField ID="Finance" runat="server" FieldLabel="<%$ Resources: FinanceInfo.Finance.FieldLabel %>" Width="250" />
                                </ext:Anchor>
                                <ext:Anchor>
                                    <ext:TextField ID="FinancePhone" runat="server" FieldLabel="<%$ Resources: FinanceInfo.FinancePhone.FieldLabel %>" Width="250" />
                                </ext:Anchor>
                                <ext:Anchor>
                                    <ext:TextField ID="FinanceEmail" runat="server" FieldLabel="<%$ Resources: FinanceInfo.FinanceEmail.FieldLabel %>" Width="250" />
                                </ext:Anchor>
                                <ext:Anchor>
                                    <ext:ComboBox ID="Payment" runat="server" FieldLabel="<%$ Resources: FinanceInfo.Payment.FieldLabel %>" StoreID="PaymentStore" Width="150" Editable="false" TypeAhead="true" Mode="Local" DisplayField="Name" ValueField="Id" ListWidth="300" Resizable="true"
                                        ForceSelection="true" TriggerAction="All" EmptyText="<%$ Resources: FinanceInfo.Payment.EmptyText %>">
                                        <Triggers>
                                            <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: FinanceInfo.Payment.FieldTrigger.Qtip %>" />
                                        </Triggers>
                                        <Listeners>
                                            <TriggerClick Handler="this.clearValue();" />
                                        </Listeners>
                                    </ext:ComboBox>
                                </ext:Anchor>
                            </ext:FormLayout>
                        </Body>
                    </ext:Tab>
                    <ext:Tab ID="Annex" runat="server" Title="经销商附件" Icon="ChartOrganisation" BodyStyle="padding:5px;">
                        <Body>
                            <ext:BorderLayout ID="BorderLayout1" runat="server">
                                <North Collapsible="True" Split="True">
                                    <ext:Panel ID="plSearch" runat="server" Header="true" Title="查询条件" Frame="true" AutoHeight="true" Icon="Find">
                                        <Body>
                                            <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                                <ext:LayoutColumn ColumnWidth=".45">
                                                    <ext:Panel ID="Panel3" runat="server" Border="false">
                                                        <Body>
                                                            <ext:FormLayout ID="FormLayout5" runat="server">
                                                                <ext:Anchor>
                                                                    <ext:TextField ID="tfAnnexName" runat="server" FieldLabel="附件名称">
                                                                    </ext:TextField>
                                                                </ext:Anchor>
                                                            </ext:FormLayout>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:LayoutColumn>
                                                <ext:LayoutColumn ColumnWidth=".45">
                                                    <ext:Panel ID="Panel4" runat="server" Border="false" >
                                                        <Body>
                                                            <ext:FormLayout ID="FormLayout6" runat="server">
                                                                <ext:Anchor>
                                                                    <ext:ComboBox ID="cbAttachmentType" runat="server" EmptyText="请选择附件类型" Editable="true" TypeAhead="true" Resizable="true" StoreID="AttachmentType" ValueField="Key" DisplayField="Value" FieldLabel="附件类型">
                                                                        <Triggers>
                                                                            <ext:FieldTrigger Icon="Clear" Qtip="清除" />
                                                                        </Triggers>
                                                                        <Listeners>
                                                                            <TriggerClick Handler="this.clearValue();" />
                                                                        </Listeners>
                                                                    </ext:ComboBox>
                                                                </ext:Anchor>
                                                            </ext:FormLayout>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:LayoutColumn>
                                            </ext:ColumnLayout>
                                        </Body>
                                        <Buttons>
                                            <ext:Button ID="btnSearch" Text="查询" runat="server" Icon="ArrowRefresh" IDMode="Legacy">
                                                <Listeners>
                                                    <Click Handler="#{PagingToolBar1}.changePage(1);" />
                                                </Listeners>
                                            </ext:Button>
                                        </Buttons>
                                    </ext:Panel>
                                </North>
                                <Center>
                                    <ext:Panel runat="server" ID="ctl46" Border="false" Frame="true">
                                        <Body>
                                            <ext:FitLayout ID="FitLayout2" runat="server">
                                                <ext:GridPanel ID="gpAttachment" runat="server" Title="查询结果" StoreID="AttachmentStore" Border="false" Icon="Lorry" StripeRows="true">
                                                    <ColumnModel ID="ColumnModel1" runat="server">
                                                        <Columns>
                                                            <ext:Column ColumnID="Name" DataIndex="Name" Width="200" Header="附件名称">
                                                            </ext:Column>
                                                            <ext:Column ColumnID="TypeName" DataIndex="TypeName" Header="附件类型" Width="125">
                                                            </ext:Column>
                                                            <ext:Column ColumnID="Identity_Name" DataIndex="Identity_Name" Width="90" Header="上传人">
                                                            </ext:Column>
                                                            <ext:Column ColumnID="UploadDate" DataIndex="UploadDate" Width="90" Header="上传时间">
                                                            </ext:Column>
                                                            <ext:CommandColumn Width="50" Header="下载" Align="Center">
                                                                <Commands>
                                                                    <ext:GridCommand Icon="DiskDownload" CommandName="DownLoad">
                                                                        <ToolTip Text="下载" />
                                                                    </ext:GridCommand>
                                                                </Commands>
                                                            </ext:CommandColumn>
                                                        </Columns>
                                                    </ColumnModel>
                                                    <SelectionModel>
                                                        <ext:RowSelectionModel ID="RowSelectionModel1" runat="server">
                                                        </ext:RowSelectionModel>
                                                    </SelectionModel>
                                                    <BottomBar>
                                                        <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="30" StoreID="AttachmentStore" DisplayInfo="true" EmptyMsg="没有数据显示" />
                                                    </BottomBar>
                                                    <Listeners>
                                                        <Command Handler="if (command == 'DownLoad')
                                                                    {
                                                                        var url = '../Download.aspx?downloadname=' + escape(record.data.Name) + '&filename=' + escape(record.data.Url) + '&downtype=dcms';
                                                                        open(url, 'Download');
                                                                    }" />
                                                    </Listeners>
                                                    <LoadMask ShowMask="true" Msg="处理中..." />
                                                </ext:GridPanel>
                                            </ext:FitLayout>
                                        </Body>
                                    </ext:Panel>
                                </Center>
                            </ext:BorderLayout>
                        </Body>
                        <Listeners>
                            <Activate Handler="#{cbAttachmentType}.clearValue(); #{AttachmentType}.reload();" />
                        </Listeners>
                    </ext:Tab>
                    <ext:Tab ID="TabExport" runat="server" Title="授权-指标导出" Icon="ChartOrganisation" BodyStyle="padding:5px;">
                        <Body>
                            <ext:FormLayout ID="FormLayout7" runat="server">
                                <ext:Anchor>
                                    <ext:ComboBox ID="cbExportType" runat="server" EmptyText="请选择导出类型" Editable="true" TypeAhead="true" Resizable="true" StoreID="ExportTypeStore" ValueField="Value" DisplayField="Name" FieldLabel="导出类型">
                                        <Listeners>
                                            <Select Handler="#{cbProductLine}.clearValue();#{cbAllProduct}.clearValue(); #{cbYear}.clearValue();ChangeData();" />
                                        </Listeners>
                                    </ext:ComboBox>
                                </ext:Anchor>
                                <ext:Anchor>
                                    <ext:ComboBox ID="cbAllProduct" runat="server" EmptyText="请选择产品线" Editable="true" TypeAhead="true" Hidden="true" Resizable="true" StoreID="AllProductLineStore" ValueField="Id" DisplayField="AttributeName" FieldLabel="产品线">
                                        <Triggers>
                                            <ext:FieldTrigger Icon="Clear" Qtip="清除" />
                                        </Triggers>
                                        <Listeners>
                                            <TriggerClick Handler="this.clearValue();" />
                                        </Listeners>
                                    </ext:ComboBox>
                                </ext:Anchor>
                                <ext:Anchor>
                                    <ext:ComboBox ID="cbProductLine" runat="server" EmptyText="请选择产品线" Editable="true" TypeAhead="true" Resizable="true" StoreID="ProductLineStore" ValueField="ProductLineId" DisplayField="ProductLineName" FieldLabel="产品线">
                                        <Triggers>
                                            <ext:FieldTrigger Icon="Clear" Qtip="清除" />
                                        </Triggers>
                                        <Listeners>
                                            <TriggerClick Handler="this.clearValue();" />
                                        </Listeners>
                                    </ext:ComboBox>
                                </ext:Anchor>
                                <ext:Anchor>
                                    <ext:ComboBox ID="cbYear" runat="server" EmptyText="请选择指标年度" Editable="true" TypeAhead="true" Hidden="true" Resizable="true" StoreID="YearStore" ValueField="COP_Period" DisplayField="COP_Period" FieldLabel="指标年度">
                                        <Triggers>
                                            <ext:FieldTrigger Icon="Clear" Qtip="清除" />
                                        </Triggers>
                                        <Listeners>
                                            <TriggerClick Handler="this.clearValue();" />
                                        </Listeners>
                                    </ext:ComboBox>
                                </ext:Anchor>
                            </ext:FormLayout>
                        </Body>
                        <Buttons>
                            <ext:Button ID="ExportButtonAuthorization" runat="server" Text="导出授权" Icon="PageExcel" AutoPostBack="true" OnClick="ExportAuthorizationExcel">
                            </ext:Button>
                            <ext:Button ID="ButtonAOPD" runat="server" Text="导出经销商指标" Icon="PageExcel" AutoPostBack="true" Hidden="true" OnClick="ExportAOPExcel">
                            </ext:Button>
                            <ext:Button ID="ButtonAOPH" runat="server" Text="导出医院指标" Icon="PageExcel" AutoPostBack="true" Hidden="true" OnClick="ExportHospitalAOPExcel">
                            </ext:Button>
                            <ext:Button ID="ButtonAOPP" runat="server" Text="导出产品分类指标" Icon="PageExcel" AutoPostBack="true" Hidden="true" OnClick="ExportProductAOPExcel">
                            </ext:Button>
                        </Buttons>
                        <Listeners>
                            <Activate Handler="#{cbProductLine}.clearValue(); #{ProductLineStore}.reload();#{cbYear}.clearValue();#{YearStore}.reload();" />
                        </Listeners>
                    </ext:Tab>
                </Tabs>
            </ext:TabPanel>
        </ext:FitLayout>
    </Body>
    <Buttons>
        <ext:Button ID="ExportButton" runat="server" Text="<%$ Resources: ExporButton.Text %>" Icon="PageExcel" AutoPostBack="true" OnClick="ExportExcel">
        </ext:Button>
        <ext:Button ID="SaveButton" runat="server" Text="<%$ Resources: SaveButton.Text %>" Icon="Disk">
            <Listeners>
                <Click Handler="saveDealer();" />
            </Listeners>
        </ext:Button>        
        <ext:Button ID="CancelButton" runat="server" Text="<%$ Resources: CancelButton.Text %>" Icon="Cancel">
            <Listeners>
                <Click Handler="cancelDetailEdit();" />
            </Listeners>
        </ext:Button>
    </Buttons>
</ext:Window>
