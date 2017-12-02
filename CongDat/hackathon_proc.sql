CREATE PROCEDURE [dbo].[SP_COMMENT_BY_POST$GET]
	@PostId int
AS
BEGIN
	Set NoCount ON
	Declare @SQLQuery AS NVarchar(4000)
    Declare @ParamDefinition AS NVarchar(2000) 
	SET @SQLQuery  = 'SELECT '
	SET @SQLQuery  = @SQLQuery + '	PostComment.CmtId															'
	SET @SQLQuery  = @SQLQuery + '	,PostId                                                         '
	SET @SQLQuery  = @SQLQuery + '	,UserId                                                      '
	SET @SQLQuery  = @SQLQuery + '	,CmtContent                                                         '
	SET @SQLQuery  = @SQLQuery + '	,LikeCount                                                          '
	SET @SQLQuery  = @SQLQuery + '	,CrtTime															'
	SET @SQLQuery  = @SQLQuery + '	,UpdTime															'
	SET @SQLQuery  = @SQLQuery + '  FROM PostComment                                                    '	
	SET @SQLQuery  = @SQLQuery + '  WHERE PostId = '+CAST(@PostId AS Nvarchar(10)) 
	SET @SQLQuery  = @SQLQuery + '  ORDER BY CrtTime DESC ';
	EXEC sp_Executesql @SQLQuery
	If @@ERROR <> 0 GoTo ErrorHandler   
	Set NoCount OFF
    Return(0)
	ErrorHandler:
    Return(@@ERROR)
END

CREATE PROCEDURE [dbo].[SP_REP_BY_COMMENT$GET]
	@CommentId int
AS
BEGIN
	Set NoCount ON
	Declare @SQLQuery AS NVarchar(4000)
    Declare @ParamDefinition AS NVarchar(2000) 
	SET @SQLQuery  = 'SELECT '
	SET @SQLQuery  = @SQLQuery + '	ReplyId															'
	SET @SQLQuery  = @SQLQuery + '	,CmtId                                                         '
	SET @SQLQuery  = @SQLQuery + '	,UserId                                                      '	
	SET @SQLQuery  = @SQLQuery + '	,ReplyContent                                                      '
	SET @SQLQuery  = @SQLQuery + '	,CrtTime															'	
	SET @SQLQuery  = @SQLQuery + '  FROM PostReply                                                    '	
	SET @SQLQuery  = @SQLQuery + '  WHERE cmtId = '+CAST(@CommentId AS Nvarchar(10)) 
	SET @SQLQuery  = @SQLQuery + '  ORDER BY CrtTime DESC ';
	EXEC sp_Executesql @SQLQuery
	If @@ERROR <> 0 GoTo ErrorHandler   
	Set NoCount OFF
    Return(0)
	ErrorHandler:
    Return(@@ERROR)
END

CREATE PROCEDURE [dbo].[SP_COMMENT$POST]
	@UserId Nvarchar(128),
	@CmtContent Text,
	@PostId int
AS
BEGIN
	DECLARE @NEW_CMT_ID AS Nvarchar(20)
	Set NoCount ON
	INSERT INTO PostComment(
			UserId
		   ,CmtContent
		   ,PostId
		   ,LikeCount
           ,CrtTime
           ,UpdTime)
     VALUES
           (@UserId
           ,@CmtContent
		   ,@PostId
		   ,0
           ,GETDATE()
           ,GETDATE())
	SET @NEW_CMT_ID = SCOPE_IDENTITY();		
	 
	If @@ERROR <> 0 GoTo ErrorHandler
    Set NoCount OFF
	BEGIN
		SELECT @NEW_CMT_ID AS POST;
		Return(@NEW_CMT_ID)
	END
	ErrorHandler:
    BEGIN
		SELECT '-1';
		Return(0)
	END
END

CREATE PROCEDURE [dbo].[SP_REPLY$POST]
	@UserId Nvarchar(128),
	@CmtContent Text,
	@CmtId int
AS
BEGIN
	DECLARE @NEW_CMT_ID AS Nvarchar(20)
	Set NoCount ON
	INSERT INTO PostReply(
			UserId
		   ,ReplyContent
		   ,CmtId
           ,CrtTime)
     VALUES
           (@UserId
           ,@CmtContent
		   ,@CmtId
           ,GETDATE())
	SET @NEW_CMT_ID = SCOPE_IDENTITY();		
	 
	If @@ERROR <> 0 GoTo ErrorHandler
    Set NoCount OFF
	BEGIN
		SELECT @NEW_CMT_ID AS POST;
		Return(@NEW_CMT_ID)
	END
	ErrorHandler:
    BEGIN
		SELECT '-1';
		Return(0)
	END
END