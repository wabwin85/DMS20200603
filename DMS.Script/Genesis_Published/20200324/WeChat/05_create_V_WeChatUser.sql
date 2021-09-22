SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO

CREATE VIEW [dbo].[V_WeChatUser]
AS
SELECT T_IDENTITY.IDENTITY_CODE Account,
       T_BusinessWechatUser.BWU_WeChat AS OpenId,
       T_IDENTITY.Id AS UserId,
       T_IDENTITY.IDENTITY_NAME AS UserName,
       T_DealerMaster.DMA_ID AS DealerId,
       (CASE ISNULL(T_DealerMaster.DMA_ChineseShortName, '')
            WHEN '' THEN
                ''
            ELSE
                ISNULL(T_DealerMaster.DMA_ChineseShortName, '') + '-'
        END
       ) + T_IDENTITY.IDENTITY_NAME DealerName
FROM Lafite_IDENTITY T_IDENTITY (NOLOCK)
    INNER JOIN BusinessWechatUser T_BusinessWechatUser (NOLOCK)
        ON (
               T_BusinessWechatUser.BWU_UserName = T_IDENTITY.IDENTITY_CODE
               OR
               (
                   T_IDENTITY.PHONE = T_BusinessWechatUser.BWU_UserName
                   AND ISNULL(T_IDENTITY.PHONE, '') <> ''
               )
               --OR
               --(
               --    T_IDENTITY.PHONE = ISNULL(
               --                       (
               --                           SELECT TOP 1
               --                                  T2.PHONE
               --                           FROM dbo.Lafite_IDENTITY T2 (NOLOCK)
               --                           WHERE T2.IDENTITY_CODE = T_BusinessWechatUser.BWU_UserName
               --                       ),
               --                       ''
               --                             )
               --    AND ISNULL(T_IDENTITY.PHONE, '') <> ''
               --)
           )
    LEFT JOIN dbo.DealerMaster T_DealerMaster (NOLOCK)
        ON T_IDENTITY.Corp_ID = T_DealerMaster.DMA_ID
WHERE T_IDENTITY.BOOLEAN_FLAG = 1
      AND T_IDENTITY.DELETE_FLAG = 0
      AND T_BusinessWechatUser.BWU_Status = 'Active'
      AND ISNULL(T_BusinessWechatUser.BWU_WeChat, '') <> '';

GO


