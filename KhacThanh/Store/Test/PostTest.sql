-- Get post by tag
EXEC SP_POST_TAG$GET 1000
EXEC SP_POST_TAG$GET 1001
EXEC SP_POST_TAG$GET 1003
SELECT SCOPE_IDENTITY();

-- 

EXEC SP_POST_TAG$POST2 '1459aaa0-4763-4f3e-99e2-1521e2e00bae', 'Em thich mau trang 1', '1001,1002,1004', '2017-12-01 23:59:59.999'

EXEC SP_POST_TAG$POST '1459aaa0-4763-4f3e-99e2-1521e2e00bae','Title1' ,'Em thich mau trang 1', '1001,1002,1004'

EXEC SP_MESSAGE$POST2 '1000','1459aaa0-4763-4f3e-99e2-1521e2e00bae','Dem tu 1 den 10 : 2','0','2017-12-02 00:05:00.000'

EXEC SP_MESSAGE$POST '1000','1459aaa0-4763-4f3e-99e2-1521e2e00bae','Dem tu 1 den 10 : 3','0'