USE [GenesisDMS_PRD];
GO
/****** Object:  UserDefinedFunction [dbo].[GC_FilterByHospital]    Script Date: 2020/2/28 10:08:34 ******/
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO





-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
ALTER FUNCTION [dbo].[GC_FilterByHospital]
    (
      @UserId UNIQUEIDENTIFIER ,
      @DealerId UNIQUEIDENTIFIER ,
      @HospitalId UNIQUEIDENTIFIER ,
      @BUM_ID UNIQUEIDENTIFIER
    )
RETURNS BIT
AS
    BEGIN
        DECLARE @result BIT;
        DECLARE @UserType VARCHAR(20);
        DECLARE @current_DealerId UNIQUEIDENTIFIER;
        SELECT  @UserType = IDENTITY_TYPE ,
                @current_DealerId = Corp_ID
        FROM    dbo.Lafite_IDENTITY
        WHERE   Id = CONVERT(VARCHAR(36), @UserId);

        SET @result = 0;

        IF ( @UserType IS NULL
             OR @HospitalId IS NULL
             OR @BUM_ID IS NULL
           )
            BEGIN
                SET @result = 0;
                GOTO Cleanup;
            END;


--IF(@UserType='Dealer' )
--BEGIN
--	IF( @current_DealerId IS NULL OR @DealerId IS NULL)
--	BEGIN
--		SET @result = 0
--		GOTO Cleanup
--	END
	
--	IF(@current_DealerId = @DealerId) 
--	BEGIN	
--		SET @result = 1
--		GOTO Cleanup
--	END
--END
--ELSE
--BEGIN	
--  SET @result = 1
--  GOTO Cleanup	
--END

        IF ( @UserType = 'Dealer'
             AND EXISTS ( SELECT    1
                          FROM      dbo.DealerAuthorizationTable A
                                    INNER JOIN dbo.HospitalList B ON A.DAT_ID = B.HLA_DAT_ID
                          WHERE     B.HLA_HOS_ID = @HospitalId
                                    AND A.DAT_DMA_ID = @current_DealerId
                                    AND A.DAT_ProductLine_BUM_ID = @BUM_ID )
           )
            BEGIN
                SET @result = 1;
                GOTO Cleanup;
            END;

--@UserType='User' 

        ELSE
            BEGIN
                IF ( EXISTS ( SELECT    1
                              FROM      dbo.DealerAuthorizationTable A
                                        INNER JOIN dbo.HospitalList B ON A.DAT_ID = B.HLA_DAT_ID
                                        INNER JOIN dbo.Cache_SalesOfDealer C ON A.DAT_DMA_ID = C.DealerID
                              WHERE     A.DAT_ProductLine_BUM_ID = @BUM_ID
                                        AND B.HLA_HOS_ID = @HospitalId
                                        AND C.SalesID = @UserId
                                        AND C.BUM_ID = @BUM_ID ) )
                    BEGIN
                        SET @result = 1;
                        GOTO Cleanup;	
                    END;
            END;

        RETURN 0;
	
        Cleanup: 
        RETURN @result;
    END;





