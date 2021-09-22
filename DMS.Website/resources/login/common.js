/* 
QKSort.Solutions Common Script 
Version 1.0.2008.08
Copyright (c) 2004-2008, QKSort Co., Ltd.(http://www.qksort.net)
*/
//通用属性
this.thisForm           =(document.forms.length>0)?document.forms[0]:null;
this.AgentName			=navigator.userAgent.toLowerCase();
this.MajorVersionNumber =parseInt(navigator.appVersion);
this.IsDom				=(document.getElementById)?true:false;
this.IsNetscape         =this.AgentName.indexOf("netscape6")>=0;
this.IsNetscape6		=(this.IsDom&&navigator.appName=="Netscape");
this.IsNetscape62       =this.AgentName.indexOf("netscape6")>=0;
this.Netscape7          =(this.AgentName.indexOf("netscape/7.")>0)?this.AgentName.charCodeAt(i+11)-48:-1;
this.IsOpera			=this.AgentName.indexOf('opera')!=-1;
this.IsMac				=(this.AgentName.indexOf("mac")!=-1);
this.IsIE				=(document.all?true:false);
this.IsIE4				=(document.all&&!this.IsDom)?true:false;
this.IsIE4Plus			=(this.IsIE && this.MajorVersionNumber >= 4)?true:false;
this.IsIE5				=(document.all&&this.IsDom)?true:false;
this.IsIE50				=this.IsIE5&&(this.AgentName.indexOf("msie 5.0")!=-1);
this.IsWin				=((this.AgentName.indexOf("win")!=-1) || (this.AgentName.indexOf("16bit")!=-1));
this.IsIE55				=((navigator.userAgent.indexOf("MSIE 5.5") != -1) && (navigator.userAgent.indexOf("Windows") != -1)); 
this.IsIEWin			=(this.IsIE && this.IsWin); 
this.IsIE6				=((navigator.userAgent.indexOf("MSIE 6.0") != -1) && (navigator.userAgent.indexOf("Windows") != -1)); 
this.IsIE7				=((navigator.userAgent.indexOf("MSIE 7.0") != -1) && (navigator.userAgent.indexOf("Windows") != -1)); 
this.IsIE55Plus			=(this.IsIE55 || this.IsIE6 || this.IsIE7); 
this.IsSafari			=this.AgentName.indexOf('safari')!=-1;
this.IsChanged          = false;

//alert(thisForm);
//屏蔽回退键,F5,F11,ALT+方向键,Ctrl+n,Ctrl+r等热键
this.RestrictHotkey = function()
{
	if(event.keyCode==116) 	//F5
		{event.keyCode=0;event.returnValue=false;return false;}
	if(window.event.keyCode==8&&window.event.srcElement.tagName!="INPUT"&&window.event.srcElement.tagName!="TEXTAREA")			//backspace
		{event.keyCode=0;event.returnValue=false;return false;}
	if(event.ctrlKey&&event.keyCode==78)	//ctrl+n
		{event.keyCode=0;event.returnValue=false;return false;}
	if(event.ctrlKey&&event.keyCode==82)	//ctrl+r
		{event.keyCode=0;event.returnValue=false;return false;}
	if(event.altKey&&(event.keyCode==37||event.keyCode==38))	//alt+<-/->
		{event.keyCode=0;event.returnValue=false;return false;}
	if(event.keyCode==122)	//F11
		{event.keyCode=0;event.returnValue=false;return false;}
	
	return true;
}

this.Close = function()
{
    window.returnValue = "";
    window.close();
}




//显示模式对话框
this.showModal = function(url,width,height,params)
{
    //"dialogTop:" + top +"px;dialogLeft:" + left + "px;
    if(!this.IsIE7) height += 50;
    var sFeatures = "dialogWidth:" + width + "px;dialogHeight:" + height + "px;center:yes;resizable:no;status:no;scroll:no;";
    return window.showModalDialog(url,params,sFeatures)
}
//显示非模式对话框
this.showModeless = function(url,width,height)
{
    window.open(url,"","toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=0,width=" + width + ",height=" + height + ",top=0,left=0")
}

this.Trim = function(s) 
{
    return s.replace(/(^\s+)|(\s+$)/g, "");
}

//函数用于处理querystring, 将制定的值对增加到原来的querystring中
//传入第一个参数是需要处理的url.后面的参数必须为querystring值对.
//应用举例：AddinQueryString(window.location,"abc","2","abcd","3")
this.AddinQueryString = function()
{

    var url = arguments[0].toString();
    var qs = "";
    var ipos = url.indexOf("?");

    if(ipos>=0) 
    {   
        qs = url.substr(ipos+1);
        url = url.substr(0,ipos);
    }

    var arrQS = qs.split("&");
    for(var i=1;i<arguments.length;i=i+2)   //处理传入的值对
    {
        var j = 0;
        for(j=0;j<arrQS.length;j++)
        {
            if(arrQS[j].toLowerCase().indexOf(arguments[i].toString().toLowerCase() + "=")==0)     //存在关键字值
            {
                arrQS[j] = arguments[i].toString() + "=" + arguments[i+1].toString();
                break;
            }
        }
        if(J=arrQS.length)
        {
            arrQS[j] = arguments[i].toString() + "=" + arguments[i+1].toString();
        }
    }
    return url + "?" + arrQS.join("&");
    
}

//警告修改发生
this.AlertChanged =function()
{
    try{
        if(this.IsChanged)
        {
            window.event.returnValue = "您已经对该页面进行了修改且尚未保存。如果选择确定离开该页将丢失这些修改内容。";
        }
    }
    catch(e){}
}
