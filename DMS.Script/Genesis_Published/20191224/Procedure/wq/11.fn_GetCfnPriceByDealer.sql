USE [GenesisDMS_PRD]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetCfnPriceByDealer]    Script Date: 2019/12/19 14:50:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*根据经销商，产品，子公司，及品牌获取价格*/
/*按照从高到低优先级逐层搜索符合条件价格，直到找到价格返回，若同一优先级找到多个符合条件价格数据，则以更新实际最新为准*/
/*目前价格体系为5层优先级由高到低依次是*/
/* Level5：一次性使用特殊价格                        */
/* Level4：试用时间范围内的特殊价格                  */
/* Level3：指定经销商指定UPN价格                     */
/* Level2：省份城市对应经销商UPN价格                 */
/* Level1：UPN统一价格                               */

 
ALTER Function [dbo].[fn_GetCfnPriceByDealer] 
	(@DealerId NVARCHAR(50),                          --经销商
	@CFNId UNIQUEIDENTIFIER,                              --产品
	@SubCompanyId UNIQUEIDENTIFIER,                       --分子公司
	@BrandId UNIQUEIDENTIFIER,                            --品牌
	@PriceType NVARCHAR(50),                              --价格类型
	@IsGetSpecialPrice bit                                --是否获取特殊价格
	) 
	   
		returns  decimal(18,6)
as

Begin
    DECLARE @RtnVal decimal(18,6)                        --返回价格
	DECLARE @RtnMsg NVARCHAR(100)                        --标识价格是否维护
	DECLARE @DealerType NVARCHAR(50)                     --经销商类型
	SET @RtnVal = NULL
	SET @RtnMsg = 'Failure'
	IF(@DealerId='')
	SET @DealerId=NULL
	SELECT @DealerType=DMA_DealerType FROM DealerMaster WHERE DMA_ID=@DealerId
	BEGIN
		DECLARE @level nvarchar(50)
		DECLARE @nowtime datetime
		SET @level=''
		SET @nowtime=GetDate()
		--获取特殊价格
		IF(@IsGetSpecialPrice=1)
		BEGIN
		--获取特殊价格逻辑  保留待确定后修改 level4-5
			SET @RtnVal=0.00
			SET @RtnMsg='Success'
		END
		---取产品精确到经销商价格   level3
		IF(@RtnMsg='Failure')
		BEGIN
			SELECT TOP 1 @RtnVal = CFNP_Price, @RtnMsg='Success'
			FROM CFNPrice cfnp
			LEFT JOIN DealerMaster dm ON cfnp.CFNP_Group_ID=dm.DMA_ID
			WHERE ISNULL(CFNP_DeletedFlag,0)=0
				--AND CFNP_CanOrder=1
				--AND CFNP_SubCompanyId = @SubCompanyId
				--AND CFNP_BrandId = @BrandId						
				AND CFNP_CFN_ID = @CFNId
				AND CFNP_PriceType = @PriceType
				AND (CFNP_Group_ID = @DealerId)
				AND (CFNP_ValidDateFrom IS NULL OR CFNP_ValidDateFrom <= @nowtime)
				AND (CFNP_ValidDateTo IS NULL OR CFNP_ValidDateTo > @nowtime)
			ORDER BY CFNP_CreateDate DESC
		END
		--若未取得，继续取产品，到经销商所在区域价格 level2
		IF(@RtnMsg='Failure')
		BEGIN
			SELECT TOP 1 @RtnVal = CFNP_Price, @RtnMsg='Success'
			FROM CFNPrice cfnp
			LEFT JOIN DealerMaster dm ON cfnp.CFNP_Group_ID=dm.DMA_ID
			WHERE ISNULL(CFNP_DeletedFlag,0)=0
				--AND CFNP_CanOrder=1
				--AND CFNP_SubCompanyId = @SubCompanyId
				--AND CFNP_BrandId = @BrandId						
				AND CFNP_CFN_ID = @CFNId
				AND CFNP_PriceType = @PriceType
				AND exists(SELECT 1 FROM Territory WHERE TER_Type='Province' AND TER_Description=dm.DMA_Province AND TER_ID=CFNP_Province)
				AND (CFNP_City IS NULL OR exists(SELECT 1 FROM Territory WHERE TER_Type='City' AND TER_Description=dm.DMA_City AND TER_ID=CFNP_City AND TER_ParentID=CFNP_Province))
				AND (CFNP_ValidDateFrom IS NULL OR CFNP_ValidDateFrom <= @nowtime)
				AND (CFNP_ValidDateTo IS NULL OR CFNP_ValidDateTo > @nowtime)
				AND (CFNP_Group_ID IS NULL)
				AND CFNP_DealerType = @DealerType
			ORDER BY CFNP_CreateDate DESC
		END

		--若未取到，取产品通用价格 level1
		IF(@RtnMsg='Failure')
		BEGIN
			SELECT TOP 1 @RtnVal = CFNP_Price, @RtnMsg='Success'
			FROM CFNPrice cfnp
			LEFT JOIN DealerMaster dm ON cfnp.CFNP_Group_ID=dm.DMA_ID
			WHERE ISNULL(CFNP_DeletedFlag,0)=0
				--AND CFNP_CanOrder=1
				--AND CFNP_SubCompanyId = @SubCompanyId
				--AND CFNP_BrandId = @BrandId						
				AND CFNP_CFN_ID = @CFNId
				AND CFNP_PriceType = @PriceType
				AND CFNP_Province IS NULL 
				AND (CFNP_City IS NULL)
				AND (CFNP_ValidDateFrom IS NULL OR CFNP_ValidDateFrom <= @nowtime)
				AND (CFNP_ValidDateTo IS NULL OR CFNP_ValidDateTo > @nowtime)
				AND (CFNP_Group_ID IS NULL)
				AND CFNP_DealerType = @DealerType
			ORDER BY CFNP_CreateDate DESC
		END

		/*
		DECLARE cursor_level CURSOR FOR --定义游标
			SELECT DICT_KEY 
			FROM Lafite_DICT 
			WHERE DICT_TYPE='CONST_CFNPrice_Level' 
			ORDER BY SORT_COL DESC
		OPEN cursor_level --打开游标
		FETCH NEXT FROM cursor_level INTO  @level  --抓取下一行游标数据
		WHILE @@FETCH_STATUS = 0 --AND @RtnMsg = 'Failure'
			BEGIN
				SELECT TOP 1 @RtnVal = CFNP_Price, @RtnMsg='Success'
				FROM CFNPrice cfnp
				LEFT JOIN DealerMaster dm ON cfnp.CFNP_Group_ID=dm.DMA_ID
				WHERE ISNULL(CFNP_DeletedFlag,0)=0
					--AND CFNP_CanOrder=1
					AND CFNP_SubCompanyId = @SubCompanyId
					AND CFNP_BrandId = @BrandId						
					AND CFNP_CFN_ID = @CFNId
					AND CFNP_LevelKey = @level
					AND (CFNP_Group_ID IS NULL OR CFNP_Group_ID = @DealerId)
					AND (CFNP_Province IS NULL OR exists(SELECT * FROM Territory WHERE TER_Type='Province' AND TER_Description=dm.DMA_Province AND TER_ID=CFNP_Province))
					AND (CFNP_City IS NULL OR exists(SELECT * FROM Territory WHERE TER_Type='Province' AND TER_Description=dm.DMA_Province AND TER_ID=CFNP_Province))
					AND (CFNP_ValidDateFrom IS NULL OR CFNP_ValidDateFrom >= @nowtime)
					AND (CFNP_ValidDateTo IS NULL OR CFNP_ValidDateTo < @nowtime)
				ORDER BY CFNP_CreateDate DESC

				FETCH NEXT FROM cursor_level INTO @level
			END
		CLOSE cursor_level --关闭游标
		DEALLOCATE cursor_level --释放游标	
		*/
	END
	RETURN @RtnVal
End








