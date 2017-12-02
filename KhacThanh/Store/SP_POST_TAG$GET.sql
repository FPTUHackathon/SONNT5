USE [DEGOI]
GO

/****** Object:  StoredProcedure [dbo].[SP_MESSAGE_ROOM$GET]    Script Date: 12/1/2017 9:16:11 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SP_POST_TAG$GET]
	@TagId int
AS
BEGIN
	Set NoCount ON
	Declare @SQLQuery AS NVarchar(4000)
    Declare @ParamDefinition AS NVarchar(2000) 
	SET @SQLQuery  = 'SELECT '
	SET @SQLQuery  = @SQLQuery + '	Post.PostId																'
	SET @SQLQuery  = @SQLQuery + '	,Post.PostContent                                                       '
	SET @SQLQuery  = @SQLQuery + '	,TagTbl.TagList                                                         '
	SET @SQLQuery  = @SQLQuery + '  FROM Post                                                               '
	SET @SQLQuery  = @SQLQuery + '  LEFT JOIN                                                               '
	SET @SQLQuery  = @SQLQuery + '  (SELECT post.PostId,                                                    '
	SET @SQLQuery  = @SQLQuery + '		TagList =		STUFF((                                             '
	SET @SQLQuery  = @SQLQuery + '          SELECT '','' + CAST(Tag.TagName AS VARCHAR(30))                 '
	SET @SQLQuery  = @SQLQuery + '          FROM PostTag postTag                                            '
	SET @SQLQuery  = @SQLQuery + '		  JOIN Tag ON postTag.TagId = Tag.TagId                             '
	SET @SQLQuery  = @SQLQuery + '		  WHERE postTag.PostId = post.PostId                                '
	SET @SQLQuery  = @SQLQuery + '          FOR XML PATH(''''), TYPE).value(''.'', ''NVARCHAR(MAX)''), 1, 1, '''')  '
	SET @SQLQuery  = @SQLQuery + '   FROM PostTag post                                                      '
	SET @SQLQuery  = @SQLQuery + '   GROUP BY post.PostId ) TagTbl ON Post.PostId = TagTbl.PostId           '
	SET @SQLQuery  = @SQLQuery + '  WHERE Post.PostId IN (SELECT Post.PostId                                '
	SET @SQLQuery  = @SQLQuery + '		   FROM                                                             '
	SET @SQLQuery  = @SQLQuery + '		  Post                                                              '
	SET @SQLQuery  = @SQLQuery + '		   JOIN PostTag ON Post.PostId = PostTag.PostId                     '
	SET @SQLQuery  = @SQLQuery + '		  LEFT JOIN Tag ON Tag.TagId = PostTag.TagId                        '
	SET @SQLQuery  = @SQLQuery + '		  WHERE PostTag.TagId = ' + CAST(@TagId AS Nvarchar(10)) +')        '
	EXEC sp_Executesql @SQLQuery
	If @@ERROR <> 0 GoTo ErrorHandler
    Set NoCount OFF
    Return(0)
  
	ErrorHandler:
    Return(@@ERROR)
END

GO


