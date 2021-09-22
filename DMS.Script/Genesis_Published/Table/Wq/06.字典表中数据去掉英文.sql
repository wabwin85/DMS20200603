-----
update Lafite_DICT set VALUE1='F04-退换货.根据某种类型的经销商和蓝威之间的合同，
比如:通常在每月初，一些经销商可以交换前一个季度的销售收入总额的3％。'where
DICT_TYPE = 'CONST_ReturnReason_EKP' AND DICT_KEY='28'

update Lafite_DICT set VALUE1='蓝威授权'where
DICT_TYPE = 'Tender_Authorization' AND DICT_KEY='Tender_AuthorizationBSC'
update Lafite_DICT set VALUE1='蓝威授权'where
DICT_TYPE = 'LP_Authorization' AND DICT_KEY='BSC_Authorization'
update Lafite_DICT set VALUE1='蓝威授权'where
DICT_TYPE = 'Tender_AuthorizationBSC' AND DICT_KEY='Tender_AuthorizationBSC'
update Lafite_DICT set VALUE1='蓝威/销售部 / 蓝威/Sales'where
DICT_TYPE = 'CONST_CONTRACT_Jus6_ZMFS' AND DICT_KEY='10'

update Lafite_DICT set VALUE1='蓝威发货数据接口（DownloadLpShipment）'where
DICT_TYPE = 'CONST_InterfaceDataDataType' AND DICT_KEY='SapDeliveryDownloader'
update Lafite_DICT set VALUE1='蓝威'where
DICT_TYPE = 'CONST_CONTRACT_TakeOverType' AND DICT_KEY='BSC'



--去掉英文
	  update lafite_dict set VALUE1='普通市场' where DICT_TYPE='CONST_CONTRACT_MarketType' and DICT_KEY='0'
	  update lafite_dict set VALUE1='新兴市场' where DICT_TYPE='CONST_CONTRACT_MarketType' and DICT_KEY='1'
	  update lafite_dict set VALUE1='不分红蓝海' where DICT_TYPE='CONST_CONTRACT_MarketType' and DICT_KEY='2'


	  update lafite_dict set VALUE1='否' where DICT_TYPE='CONST_CONTRACT_YesNo' and DICT_KEY='0'
	  update lafite_dict set VALUE1='是' where DICT_TYPE='CONST_CONTRACT_YesNo' and DICT_KEY='1'

	  update lafite_dict set VALUE1='是' where DICT_TYPE='CONST_CONTRACT_Pre7_SFTZ' and DICT_KEY='10'
	  update lafite_dict set VALUE1='否' where DICT_TYPE='CONST_CONTRACT_Pre7_SFTZ' and DICT_KEY='20'
	  update lafite_dict set VALUE1='不适用' where DICT_TYPE='CONST_CONTRACT_Pre7_SFTZ' and DICT_KEY='30'

	  update lafite_dict set VALUE1=DICT_Key where DICT_TYPE='CONST_CONTRACT_Competency'

	  update lafite_dict set VALUE1='蓝威/销售部' where DICT_TYPE='CONST_CONTRACT_Jus6_ZMFS' AND DICT_Key='10'
	  update lafite_dict set VALUE1='来自渠道合作方的自荐电话' where DICT_TYPE='CONST_CONTRACT_Jus6_ZMFS' AND DICT_Key='20'
	  update lafite_dict set VALUE1='竞争对手' where DICT_TYPE='CONST_CONTRACT_Jus6_ZMFS' AND DICT_Key='30'
	  update lafite_dict set VALUE1='政府官员/实体' where DICT_TYPE='CONST_CONTRACT_Jus6_ZMFS' AND DICT_Key='40'
	  update lafite_dict set VALUE1='市场调查' where DICT_TYPE='CONST_CONTRACT_Jus6_ZMFS' AND DICT_Key='50'
	  update lafite_dict set VALUE1='其他第三方' where DICT_TYPE='CONST_CONTRACT_Jus6_ZMFS' AND DICT_Key='60'
	  update lafite_dict set VALUE1='推荐' where DICT_TYPE='CONST_CONTRACT_Jus6_ZMFS' AND DICT_Key='70'
	  update lafite_dict set VALUE1='其他' where DICT_TYPE='CONST_CONTRACT_Jus6_ZMFS' AND DICT_Key='80'

	  update lafite_dict set VALUE1='专业领域' where DICT_TYPE='CONST_CONTRACT_Jus6_YY' AND DICT_Key='10'
	  update lafite_dict set VALUE1='资质' where DICT_TYPE='CONST_CONTRACT_Jus6_YY' AND DICT_Key='20'
	  update lafite_dict set VALUE1='政府官员/实体要求' where DICT_TYPE='CONST_CONTRACT_Jus6_YY' AND DICT_Key='30'
	  update lafite_dict set VALUE1='区域' where DICT_TYPE='CONST_CONTRACT_Jus6_YY' AND DICT_Key='40'
	  update lafite_dict set VALUE1='其他' where DICT_TYPE='CONST_CONTRACT_Jus6_YY' AND DICT_Key='50'

	  update lafite_dict set VALUE1='投标' where DICT_TYPE='CONST_CONTRACT_Jus4_FWFW' AND DICT_Key='10'
	  update lafite_dict set VALUE1='对私人医院/诊所的销售' where DICT_TYPE='CONST_CONTRACT_Jus4_FWFW' AND DICT_Key='20'
	  update lafite_dict set VALUE1='仅限促销活动' where DICT_TYPE='CONST_CONTRACT_Jus4_FWFW' AND DICT_Key='30'
	  update lafite_dict set VALUE1='产品注册' where DICT_TYPE='CONST_CONTRACT_Jus4_FWFW' AND DICT_Key='40'
	  update lafite_dict set VALUE1='清关' where DICT_TYPE='CONST_CONTRACT_Jus4_FWFW' AND DICT_Key='50'
	  update lafite_dict set VALUE1='对其他经销商或代理商的销售' where DICT_TYPE='CONST_CONTRACT_Jus4_FWFW' AND DICT_Key='60'
	  update lafite_dict set VALUE1='其他' where DICT_TYPE='CONST_CONTRACT_Jus4_FWFW' AND DICT_Key='70'

	  update lafite_dict set VALUE1='银行保函' where DICT_TYPE='CONST_CONTRACT_Inform' AND DICT_Key='Bank guarantee'
	  update lafite_dict set VALUE1='现金抵押' where DICT_TYPE='CONST_CONTRACT_Inform' AND DICT_Key='Cash deposit'
	  update lafite_dict set VALUE1='公司保函' where DICT_TYPE='CONST_CONTRACT_Inform' AND DICT_Key='Company guarantee'
	  update lafite_dict set VALUE1='信用证' where DICT_TYPE='CONST_CONTRACT_Inform' AND DICT_Key='Credit Letter'
	  update lafite_dict set VALUE1='其他' where DICT_TYPE='CONST_CONTRACT_Inform' AND DICT_Key='Others'
	  update lafite_dict set VALUE1='房产抵押' where DICT_TYPE='CONST_CONTRACT_Inform' AND DICT_Key='Real estate mortgage'

	  update lafite_dict set VALUE1='不续约' where DICT_TYPE='CONST_CONTRACT_DealerEndTyp' and DICT_KEY='Non-Renewal'
	  update lafite_dict set VALUE1='终止' where DICT_TYPE='CONST_CONTRACT_DealerEndTyp' and DICT_KEY='Termination'

	  update lafite_dict set VALUE1='应收帐款问题' where DICT_TYPE='CONST_CONTRACT_DealerEndReason' and DICT_KEY='Accounts Receivable Issues'
	  update lafite_dict set VALUE1='未完成指标' where DICT_TYPE='CONST_CONTRACT_DealerEndReason' and DICT_KEY='Not Meeting Quota'
	  update lafite_dict set VALUE1='其他' where DICT_TYPE='CONST_CONTRACT_DealerEndReason' and DICT_KEY='Others'
	  update lafite_dict set VALUE1='产品线停产' where DICT_TYPE='CONST_CONTRACT_DealerEndReason' and DICT_KEY='Product Line Discontinued'

	  update lafite_dict set VALUE1='坏账' where DICT_TYPE='CONST_CONTRACT_ReserveType' and DICT_KEY='Bad Debt'
	  update lafite_dict set VALUE1='其他' where DICT_TYPE='CONST_CONTRACT_ReserveType' and DICT_KEY='Other'
	  update lafite_dict set VALUE1='销售返还' where DICT_TYPE='CONST_CONTRACT_ReserveType' and DICT_KEY='Sales Return'
	  update lafite_dict set VALUE1='结算' where DICT_TYPE='CONST_CONTRACT_ReserveType' and DICT_KEY='Settlement'

	  update lafite_dict set VALUE1='换货' where DICT_TYPE='CONST_CONTRACT_RebatePromotionComplaint' and DICT_KEY='Exchange product'
	  update lafite_dict set VALUE1='无' where DICT_TYPE='CONST_CONTRACT_RebatePromotionComplaint' and DICT_KEY='None'
	  update lafite_dict set VALUE1='退款' where DICT_TYPE='CONST_CONTRACT_RebatePromotionComplaint' and DICT_KEY='Refund'


	  
update lafite_dict set Value1='退回蓝威' where DICT_Type='CONST_CONTRACT_InventoryDispose' AND DICT_KEY='BSC'

--
update lafite_dict set VALUE1='授权变更' where DICT_TYPE='CONST_CONTRACT_ChangeQuarter' and DICT_KEY='0'
update lafite_dict set VALUE1='销售方式变更' where DICT_TYPE='CONST_CONTRACT_ChangeQuarter' and DICT_KEY='1'
update lafite_dict set VALUE1='其他' where DICT_TYPE='CONST_CONTRACT_ChangeQuarter' and DICT_KEY='2'

update lafite_dict set VALUE1='法兰克曼' where DICT_TYPE='CONST_CONTRACT_DealerMark' and DICT_KEY='1'

update lafite_dict set VALUE1='外贸公司' where DICT_TYPE='CONST_CONTRACT_DealerType' and DICT_KEY='Trade'

update lafite_dict set VALUE1='标准' where DICT_TYPE='CONST_CONTRACT_EquipmentPrice' and DICT_KEY='标准'
update lafite_dict set VALUE1='非标准' where DICT_TYPE='CONST_CONTRACT_EquipmentPrice' and DICT_KEY='非标准'

update lafite_dict set VALUE1='HCP 培训' where DICT_TYPE='CONST_CONTRACT_Jus4_EWFWFW' and DICT_KEY='10'
update lafite_dict set VALUE1='HCP 教育' where DICT_TYPE='CONST_CONTRACT_Jus4_EWFWFW' and DICT_KEY='20'
update lafite_dict set VALUE1='赞助' where DICT_TYPE='CONST_CONTRACT_Jus4_EWFWFW' and DICT_KEY='30'
update lafite_dict set VALUE1='销售代表培训' where DICT_TYPE='CONST_CONTRACT_Jus4_EWFWFW' and DICT_KEY='40'
update lafite_dict set VALUE1='固定设备/服务维护' where DICT_TYPE='CONST_CONTRACT_Jus4_EWFWFW' and DICT_KEY='50'
update lafite_dict set VALUE1='未列明的其他服务' where DICT_TYPE='CONST_CONTRACT_Jus4_EWFWFW' and DICT_KEY='60'

update lafite_dict set VALUE1='低于 25%' where DICT_TYPE='CONST_CONTRACT_Jus8_YWZB' and DICT_KEY='10'
update lafite_dict set VALUE1='高于 50%' where DICT_TYPE='CONST_CONTRACT_Jus8_YWZB' and DICT_KEY='30'

update lafite_dict set VALUE1='5,000,000美元或更少' where DICT_TYPE='CONST_CONTRACT_Pre6_HTJZ' and DICT_KEY='10'
update lafite_dict set VALUE1='5,000,000-9,999,999美元' where DICT_TYPE='CONST_CONTRACT_Pre6_HTJZ' and DICT_KEY='20'
update lafite_dict set VALUE1='10,000,000美元或更多' where DICT_TYPE='CONST_CONTRACT_Pre6_HTJZ' and DICT_KEY='30'

update lafite_dict set VALUE1='更换经营实体' where DICT_TYPE='CONST_CONTRACT_Reason' and DICT_KEY='3'

update lafite_dict set VALUE1='长效期产品（大于六个月）' where DICT_TYPE='CONST_CONTRACT_ReturnReason' and DICT_KEY='Long Expiry Products (over 6 months)'
update lafite_dict set VALUE1='短效期产品' where DICT_TYPE='CONST_CONTRACT_ReturnReason' and DICT_KEY='Short Expiry Products'
update lafite_dict set VALUE1='过期和损害产品' where DICT_TYPE='CONST_CONTRACT_ReturnReason' and DICT_KEY='Expired & Damaged Products'

update lafite_dict set VALUE1='D07-销售返利预提' where DICT_TYPE='CONST_ReturnReason_EKP' and DICT_KEY='3'