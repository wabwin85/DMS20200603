DROP FUNCTION [dbo].[GC_Fn_CFN_CheckDealerLicenseGatagory_3rdCatagoryDateCheck] 
GO

CREATE FUNCTION [dbo].[GC_Fn_CFN_CheckDealerLicenseGatagory_3rdCatagoryDateCheck] (
   @DealerId    UNIQUEIDENTIFIER,
   @CfnId       UNIQUEIDENTIFIER,
   @GMCatalog   NVARCHAR (200),
   @GMKind   NVARCHAR (200),
   @SecondGatagory   NVARCHAR (2000),
   @ThirdGatagory   NVARCHAR (2000)
   )
   RETURNS TINYINT
AS
   BEGIN
      DECLARE @RtnVal   TINYINT
      
      DECLARE @RowCnt   INT
      
      Set @RtnVal = 0
      --获取产品对应的分类等级及分类代码
      --SELECT @RowCnt = count (*) FROM MD.V_INF_UPN_REG t1, cfn t2 WHERE t1.CurUPN = t2.CFN_CustomerFaceNbr AND t2.CFN_ID = @CfnId
      
      --IF (@RowCnt > 0)
      --如果没有注册证，也允许下订单
      IF (@SecondGatagory is not null OR @ThirdGatagory is not null)
         BEGIN
            --select @GMCatalog = CurGMCatalog, @GMKind = curGMKind from MD.V_INF_UPN_REG t1, cfn t2  where t1.CurUPN=t2.CFN_CustomerFaceNbr and t2.CFN_ID = @CfnId

            IF ((@GMKind != '2' and @GMKind != '3' ) OR @GMKind is null )
               SET @RtnVal = 1
            ELSE
               BEGIN
                  IF (@GMKind = '2')
                     BEGIN
                        --SELECT @SecondGatagory = DML_CurSecondClassCatagory  FROM DealerMasterLicense   WHERE DML_DMA_ID = @DealerId

                        IF @SecondGatagory = NULL
                           SET @RtnVal = 0
                        ELSE
                           BEGIN
                              IF (@GMCatalog IN (SELECT VAL
                                                FROM GC_Fn_SplitStringToTable (
                                                        @SecondGatagory,
                                                        ','))                                 
                                  )
                                 SET @RtnVal = 1
                              ELSE
                                 SET @RtnVal = 0
                           END
                     END

                  IF (@GMKind = '3')
                     BEGIN
                        --SELECT @ThirdGatagory = DML_CurThirdClassCatagory FROM DealerMasterLicense WHERE DML_DMA_ID = @DealerId

                        IF @ThirdGatagory = NULL
                           SET @RtnVal = 0
                        ELSE
                           BEGIN
                              IF (@GMCatalog IN (SELECT VAL
                                                FROM GC_Fn_SplitStringToTable (
                                                        @ThirdGatagory,','))
                                  and exists (select 1 from DealerMasterLicense where DML_DMA_ID = @DealerId and CONVERT(NVARCHAR(10),DML_CurLicenseValidFrom , 112)<=CONVERT(NVARCHAR(10),GETDATE(), 112) AND CONVERT(NVARCHAR(10),DML_CurLicenseValidTo , 112)>=CONVERT(NVARCHAR(10),GETDATE(), 112))
                                                
                                  )
                                 SET @RtnVal = 1
                              ELSE
                                 SET @RtnVal = 0
                           END
                     END
               END
         END
      ELSE
          IF (@GMKind is null OR @GMKind='')
            SET @RtnVal = 1
          ELSE
            SET @RtnVal = 0

      RETURN @RtnVal
   END
GO


