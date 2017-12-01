USE [DEGOI]
GO

/****** Object:  StoredProcedure [dbo].[SP_POST_TAG$POST]    Script Date: 12/1/2017 11:55:29 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[SP_POST_TAG$POST]
	@UserId Nvarchar(128),
	@PostContent Text,
	@TagId Text
AS
BEGIN
	DECLARE @NEW_POST_ID AS Nvarchar(20)
	DECLARE @ABCD AS Nvarchar(100)
	Set NoCount ON
	INSERT INTO Post(
			UserId
		   ,PostContent
           ,CrtTime
           ,UpdTime)
     VALUES
           (@UserId
           ,@PostContent
           ,GETDATE()
           ,GETDATE())
	SET @NEW_POST_ID = SCOPE_IDENTITY();
	
	INSERT INTO PostTag
			   (PostId
			   ,TagId
			   ,CrtTime)
	SELECT @NEW_POST_ID AS PostID ,
	NAME AS TagID,
	GETDATE() AS CrtDate
	FROM splitstring(@TagId);
	 
	If @@ERROR <> 0 GoTo ErrorHandler
    Set NoCount OFF
    Return(0)
  
	ErrorHandler:
    Return(@@ERROR)
END



GO


