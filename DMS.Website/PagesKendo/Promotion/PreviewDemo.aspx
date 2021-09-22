<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PreviewDemo.aspx.cs" Inherits="DMS.Website.PagesKendo.Promotion.PreviewDemo" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Promotion View</title>
    <style type="text/css">
        html,
        body {
            margin: 0;
            font-family: 微软雅黑;
        }
    </style>
    <script type="text/javascript" src="<%=Page.ResolveUrl("~/Resources/kendo-2017.2.504/js/jquery.min.js") %>"></script>
    <script type="text/javascript">
        var initLayout = function () {
            $('#div2').height($(window).height());
        }

        $(document).ready(function () {
            if (top != self) {
                initLayout();
                $(window).resize(function () {
                    initLayout();
                })
            }
        });
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div id="div2" style="width: 100%; overflow-y: auto;">
            <div id="div1" runat="server" style="padding: 10px;">
                <style type="text/css">
                    div.des {
                        word-break: break-all;
                        font-size: 11px;
                        line-height: 22px;
                        width: 100%;
                        height: auto;
                        border: solid 1px #337ab7;
                        text-align: left;
                    }

                    table.gridtable {
                        font-size: 11px;
                        color: #333333;
                        border-width: 1px;
                        border-color: #337ab7;
                        border-collapse: collapse;
                        width: 100%;
                    }

                        table.gridtable th {
                            border-width: 1px;
                            padding: 5px;
                            border-style: solid;
                            border-color: #337ab7;
                            background-color: #d9ecf5;
                            text-align: right;
                            width: 30%;
                            min-width: 200px;
                        }

                        table.gridtable td {
                            border-width: 1px;
                            padding: 5px;
                            border-style: solid;
                            border-color: #337ab7;
                            background-color: #ffffff;
                            text-align: left;
                        }

                    h4 {
                        text-align: left;
                    }
                </style>
                <div style="margin: 10px 20px 10px 20px; text-align: center;">
                    <h2 style="text-align: center;"><b>Q4 Cutting Balloon 买10赠1 促销</b></h2>
                    <h4><font color="#FF0000">政策概要</font></h4>
                    <div class="des">
                        <div style="padding: 5px;">
                            <ol style="padding-left: 30px; list-style-type: cjk-ideographic; font-size: 16px; margin: 0px;">
                                <li>适用产品：SENSATION(LEVEL4=4240)
                                </li>
                                <li>适用期限：
                                </li>
                                <li>考核周期：季度
                                </li>
                                <li>适用经销商：3822山西广元春医疗器械有限公司
                                </li>
                                <li>适用区域：经销商名下所有医院
                                </li>
                                <li>政策方案：
                                <ol style="padding-left: 25px;">
                                    <li>政策规则：指定经销商(3822山西广元春医疗器械有限公司)。在每季度完成：指定产品医院植入数量引用目标的前提下， 满 5件 送 SENSATION(LEVEL4=4240) 1件 后转成积分(按照赠品最新采购价转积分)。
                                    </li>
                                    <li>返利情况：用积分订购的产品不算达成不算返利
                                    </li>
                                    <li>平台奖励：平台奖励通过二级经销商传递给出</li>
                                    <li>考核目标：见附录1</li>
                                </ol>
                                </li>
                            </ol>
                        </div>
                    </div>
                    <h4>概述</h4>
                    <table class="gridtable">
                        <tr>
                            <th>政策编号</th>
                            <td>P_Cardio_1603</td>
                        </tr>
                        <tr>
                            <th>促销方式</th>
                            <td>植入赠</td>
                        </tr>
                        <tr>
                            <th>政策分类</th>
                            <td>积分</td>
                        </tr>
                        <tr>
                            <th>政策子类</th>
                            <td>促销赠品转积分</td>
                        </tr>
                        <tr>
                            <th>部门</th>
                            <td>Cardio-Rovus耗材-红海</td>
                        </tr>
                        <tr>
                            <th>封顶值</th>
                            <td>无</td>
                        </tr>
                        <tr>
                            <th>政策名称</th>
                            <td>Q4 Cutting Balloon 买10赠1 促销</td>
                        </tr>
                        <tr>
                            <th>归类名称</th>
                            <td></td>
                        </tr>
                        <tr>
                            <th>考核周期</th>
                            <td>季度</td>
                        </tr>
                        <tr>
                            <th>适用期限</th>
                            <td>2017年10月01日 至 2017年12月31日</td>
                        </tr>
                        <tr>
                            <th>积分说明</th>
                            <td>经销商积分：积分在结算后的3个月内使用，使用范围：包含:Interventional Cardiology(LEVEL1=01)。平台积分：积分在结算后的3个月内使用，使用范围：与经销商积分使用范围一致。</td>
                        </tr>
                        <tr>
                            <th>加价率说明</th>
                            <td>使用平台统一加价率</td>
                        </tr>
                        <tr>
                            <th>政策描述</th>
                            <td>无</td>
                        </tr>
                        <tr>
                            <th>其他说明</th>
                            <td>上期余量不累计计算(保留原值)，赠品不从考核量中扣除，赠送不计入商业采购达成。<br />
                            </td>
                        </tr>
                        <tr>
                            <th>附件上传</th>
                            <td><a target="_blank" href="https://bscdealer.cn/API.aspx?PageId=60&InstanceID=P_Cardio_1603">上传附件</td>
                        </tr>
                    </table>
                    <h4>附件</h4>
                    <table class="gridtable">
                        <tr>
                            <th>附件1</th>
                            <td><a href="https://bscdealer.cn/Pages/Download.aspx?downloadname=2017 IC 切割球囊促销政策-Q4.docx&filename=2017-10-16_f56addf4-cd45-4473-a0f4-372c8c871014.docx&downtype=Promotion">2017 IC 切割球囊促销政策-Q4.docx</td>
                        </tr>
                        <tr>
                            <th>附件2</th>
                            <td><a href="https://bscdealer.cn/Pages/Download.aspx?downloadname=FW  Promotion Assessment-IC CB Q4.msg&filename=2017-10-12_8b97b5de-23c5-4324-a707-b2ebb470bcd2.msg&downtype=Promotion">FW  Promotion Assessment-IC CB Q4.msg</td>
                        </tr>
                        <tr>
                            <th>附件3</th>
                            <td><a href="https://bscdealer.cn/Pages/Download.aspx?downloadname=Promotion Analysis_IC_Cutting Balloon_Q4.xlsx&filename=2017-10-12_11eb68c0-6b0f-4191-a1e5-1f499bc5b6f9.xlsx&downtype=Promotion">Promotion Analysis_IC_Cutting Balloon_Q4.xlsx</td>
                        </tr>
                    </table>
                    <h4>适用范围</h4>
                    <table class="gridtable">
                        <tr>
                            <th>经销商</th>
                            <td></td>
                        </tr>
                    </table>
                    <h4>涉及参数</h4>
                    <table class="gridtable">
                        <tr>
                            <th>产品[编号16738]</th>
                            <td>包含:Interventional Cardiology(LEVEL1=01)</td>
                        </tr>
                        <tr>
                            <th>产品[编号16739]</th>
                            <td>包含:IVUS DISPOSABLES(LEVEL3=0520)</td>
                        </tr>
                        <tr>
                            <th>医院[编号16740]</th>
                            <td>包含:上海市第六人民医院，复旦大学附属中山医院，普陀区中心医院，上海中医药大学附属岳阳中西医结合医院，上海长海医院</td>
                        </tr>
                        <tr>
                            <th>考核指定产品医院植入数量完成[编号16741]</th>
                            <td>产品[编号16739]的[参见:附录1]医院的植入达标率</td>
                        </tr>
                        <tr>
                            <th>指定产品医院植入数量[编号16742]</th>
                            <td>产品[编号16739]的[参见:附录1]医院的植入量</td>
                        </tr>
                    </table>
                    <h4>促销规则</h4>
                    <table class="gridtable">
                        <tr>
                            <th>*考核指定产品医院植入数量完成[编号16741]>=目标1</th>
                            <td>指定产品医院植入数量[编号16742] 满 10件 送 产品[编号16739] 1件 后转成积分(按照赠品最新采购价转积分)(积分可用于包含:Interventional Cardiology(LEVEL1=01)的产品)</br> 描述：Q4 Cutting Balloon 指定医院完成医院指定指标后买10送1</td>
                        </tr>
                    </table>
                    <h4>附录1</h4>
                    <table class="gridtable">
                        <tr>
                            <th rowspan="2" style="text-align: center;">经销商</th>
                            <th rowspan="2" style="text-align: center;">医院</th>
                            <th colspan="5" style="text-align: center;">2017Q4</th>
                        </tr>
                        <tr>
                            <th style="text-align: center;">目标1</th>
                            <th style="text-align: center;">目标1</th>
                            <th style="text-align: center;">目标1</th>
                            <th style="text-align: center;">目标1</th>
                            <th style="text-align: center;">目标1</th>
                        </tr>
                        <tr>
                            <td>上海欣京医疗器械有限公司</td>
                            <td>上海中医药大学附属岳阳中西医结合医院</td>
                            <td style="text-align: right;">13.00</td>
                            <td style="text-align: right;">13.00</td>
                            <td style="text-align: right;">13.00</td>
                            <td style="text-align: right;">13.00</td>
                            <td style="text-align: right;">13.00</td>
                        </tr>
                        <tr>
                            <td>上海隽携贸易商行</td>
                            <td>复旦大学附属中山医院</td>
                            <td style="text-align: right;">31.00</td>
                            <td style="text-align: right;">13.00</td>
                            <td style="text-align: right;">13.00</td>
                            <td style="text-align: right;">13.00</td>
                            <td style="text-align: right;">13.00</td>
                        </tr>
                        <tr>
                            <td>上海隽携贸易商行</td>
                            <td>上海长海医院</td>
                            <td style="text-align: right;">57.00</td>
                            <td style="text-align: right;">13.00</td>
                            <td style="text-align: right;">13.00</td>
                            <td style="text-align: right;">13.00</td>
                            <td style="text-align: right;">13.00</td>
                        </tr>
                        <tr>
                            <td>上海镓铵贸易商行</td>
                            <td>上海市第六人民医院</td>
                            <td style="text-align: right;">3.00</td>
                            <td style="text-align: right;">13.00</td>
                            <td style="text-align: right;">13.00</td>
                            <td style="text-align: right;">13.00</td>
                            <td style="text-align: right;">13.00</td>
                        </tr>
                        <tr>
                            <td>上海镓铵贸易商行</td>
                            <td>普陀区中心医院</td>
                            <td style="text-align: right;">4.00</td>
                            <td style="text-align: right;">13.00</td>
                            <td style="text-align: right;">13.00</td>
                            <td style="text-align: right;">13.00</td>
                            <td style="text-align: right;">13.00</td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
