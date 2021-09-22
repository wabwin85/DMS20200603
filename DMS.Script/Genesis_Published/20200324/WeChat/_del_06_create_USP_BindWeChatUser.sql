SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO
/*
绑定微信账号和DMS帐号
*/

ALTER PROCEDURE [dbo].[USP_BindWeChatUser]
    @UserName NVARCHAR(100),
    @OpenId NVARCHAR(100)
AS
SET NOCOUNT ON;
BEGIN
    --先根据OpenId将绑定的信息置为无效
    UPDATE dbo.BusinessWechatUser
    SET BWU_Status = 'Deactive'
    WHERE BWU_WeChat = @OpenId
          AND BWU_Status = 'Active';

    INSERT INTO dbo.BusinessWechatUser
    (
        BWU_ID,
        BWU_UserName,
        BWU_WeChat,
        BWU_SignInDate,
        BWU_BindDate,
        BWU_Status
    )
    VALUES
    (   NEWID(),   -- BWU_ID - uniqueidentifier
        @UserName, -- BWU_UserName - nvarchar(50)
        @OpenId,   -- BWU_WeChat - nvarchar(2000)
        GETDATE(), -- BWU_SignInDate - datetime
        GETDATE(), -- BWU_BindDate - datetime
        N'Active'  -- BWU_Status - nvarchar(10)
        );

END;
GO