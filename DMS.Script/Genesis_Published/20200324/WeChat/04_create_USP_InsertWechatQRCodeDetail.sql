SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO
/*
插入微信扫描的二维码信息
*/

CREATE PROCEDURE [dbo].[USP_InsertWechatQRCodeDetail]
    @QRCode NVARCHAR(50),
    @HeaderId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @DetailId UNIQUEIDENTIFIER OUTPUT,
    @IsSuccess BIT OUTPUT,
    @Message NVARCHAR(100) OUTPUT
AS
SET NOCOUNT ON;
BEGIN
    SET @IsSuccess = 0;
    SET @Message = '';
    SET @DetailId = NULL;
    IF EXISTS
    (
        SELECT 1
        FROM dbo.WechatQRCodeDetail (NOLOCK)
        WHERE WQD_QRCode = @QRCode
              AND WQD_WQH_ID = @HeaderId
              AND WQD_Status = 1
    )
    BEGIN
        SET @Message = '该二维码已经存在于扫描记录中。';
    END;
    ELSE IF NOT EXISTS
         (
             SELECT 1
             FROM dbo.LotMaster T_LotMaster (NOLOCK)
             WHERE T_LotMaster.LTM_QRCode = @QRCode
         )
    BEGIN
        SET @Message = '该二维码信息在系统中不存在。';
    END;
    ELSE
    BEGIN
        SET @DetailId = NEWID();
        INSERT INTO dbo.WechatQRCodeDetail
        (
            WQD_ID,
            WQD_WQH_ID,
            WQD_QRCode,
            WQD_UPN,
            WQD_Lot,
            WQD_WeChatStatus,
            WQD_DMSStatus,
            WQD_Status,
            WQD_CreateDate,
            WQD_CreateUser,
            WQD_UpdateDate,
            WQD_UpdateUser
        )
        SELECT TOP 1
               @DetailId,           -- WQD_ID - uniqueidentifier
               @HeaderId,           -- WQD_WQH_ID - uniqueidentifier
               @QRCode,             -- WQD_QRCode - nvarchar(50)
               T_Product.PMA_UPN,   -- WQD_UPN - nvarchar(50)
               T_LotMaster.LTM_Lot, -- WQD_Lot - nvarchar(50)
               0,                   -- WQD_WeChatStatus - bit
               0,                   -- WQD_DMSStatus - bit
               1,                   -- WQD_Status - bit
               GETDATE(),           -- WQD_CreateDate - datetime
               @UserId,             -- WQD_CreateUser - nvarchar(50)
               GETDATE(),           -- WQD_UpdateDate - datetime
               @UserId              -- WQD_UpdateUser - nvarchar(50)
        FROM dbo.LotMaster T_LotMaster (NOLOCK)
            INNER JOIN dbo.Product T_Product (NOLOCK)
                ON T_LotMaster.LTM_Product_PMA_ID = T_Product.PMA_ID
        WHERE T_LotMaster.LTM_QRCode = @QRCode
        ORDER BY T_LotMaster.LTM_CreatedDate DESC;
        SET @IsSuccess = 1;
    END;

END;

GO

