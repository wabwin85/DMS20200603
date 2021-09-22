INSERT INTO dbo.Lafite_DICTTYPE
(
    DICT_TYPE,
    DICT_TYPE_NAME,
    DESCRIPTION,
    SORT_COL,
    APP_ID,
    SYS_FLAG
)
VALUES
(   'TrainType',  -- DICT_TYPE - varchar(50)
    N'TrainType', -- DICT_TYPE_NAME - nvarchar(100)
    N'培训类型', -- DESCRIPTION - nvarchar(500)
    0,   -- SORT_COL - int
    '4028931b0f0fc135010f0fc1356a0001',  -- APP_ID - varchar(36)
    1    -- SYS_FLAG - smallint
    )