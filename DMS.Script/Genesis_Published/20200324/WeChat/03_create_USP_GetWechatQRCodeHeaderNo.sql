SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
/*
获取微信上传产品二维码的表头单据号（处于未提交、未删除状态的单据）
如果当前没有可用的表头单据信息，则自动创建一个
*/

CREATE PROCEDURE [dbo].[USP_GetWechatQRCodeHeaderNo]
    @DealerId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @HeaderNo NVARCHAR(50) OUTPUT
AS
SET NOCOUNT ON;
BEGIN
    SET @HeaderNo = '';
    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.WechatQRCodeHeader (NOLOCK)
        WHERE WQH_Status = 1
              AND WQH_UploadStatus = 0
              AND WQH_DealerID = @DealerId
    )
    BEGIN
        SELECT 1;
        DECLARE @NoPre NVARCHAR(50) = CONVERT(VARCHAR(100), GETDATE(), 112);
        DECLARE @No NVARCHAR(50);
        SET @No
            = ISNULL(
              (
                  SELECT TOP 1
                         CAST(SUBSTRING(WQH_No, CHARINDEX('-', WQH_No, 0) + 1, (LEN(WQH_No) - CHARINDEX('-', WQH_No, 0))) AS INT)
                  FROM dbo.WechatQRCodeHeader (NOLOCK)
                  WHERE WQH_No LIKE '' + @NoPre + '-%'
                  ORDER BY CAST(SUBSTRING(
                                             WQH_No,
                                             CHARINDEX('-', WQH_No, 0) + 1,
                                             (LEN(WQH_No) - CHARINDEX('-', WQH_No, 0))
                                         ) AS INT) DESC
              ),
              0
                    ) + 1;
        SET @No = @NoPre + '-' + RIGHT('00000000' + CAST(@No AS VARCHAR(10)), 5);

        INSERT INTO dbo.WechatQRCodeHeader
        (
            WQH_ID,
            WQH_No,
            WQH_DealerID,
            WQH_UploadStatus,
            WQH_Remark,
            WQH_UploadDate,
            WQH_UploadResult,
            WQH_Status,
            WQH_CreateDate,
            WQH_CreateUser,
            WQH_UpdateDate,
            WQH_UpdateUser
        )
        VALUES
        (   NEWID(),   -- WQH_ID - uniqueidentifier
            @No,       -- WQH_No - nvarchar(50)
            @DealerId, -- WQH_DealerID - uniqueidentifier
            0,         -- WQH_UploadStatus - bit
            N'',       -- WQH_Remark - nvarchar(500)
            NULL,      -- WQH_UploadDate - datetime
            NULL,      -- WQH_UploadResult - nvarchar(max)
            1,         -- WQH_Status - bit
            GETDATE(), -- WQH_CreateDate - datetime
            @UserId,   -- WQH_CreateUser - nvarchar(50)
            GETDATE(), -- WQH_UpdateDate - datetime
            @UserId    -- WQH_UpdateUser - nvarchar(50)
            );

    END;


    SET @HeaderNo =
    (
        SELECT TOP 1
               T_WechatQRCodeHeader.WQH_No
        FROM dbo.WechatQRCodeHeader T_WechatQRCodeHeader (NOLOCK)
        WHERE WQH_Status = 1
              AND WQH_UploadStatus = 0
              AND WQH_DealerID = @DealerId
        ORDER BY WQH_CreateDate DESC
    );

END;
