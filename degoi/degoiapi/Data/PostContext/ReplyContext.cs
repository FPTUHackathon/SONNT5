using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using degoiapi.Models.QAModels;
using System.Data.SqlClient;
using System.Data;

namespace degoiapi.Data.PostContext
{
    public class ReplyContext : DBContext<Reply>
    {
        public List<Reply> getAllReplyOfComment(int CommentID)
        {
            List<Reply> Replys = new List<Reply>();
            using (SqlCommand cmd = new SqlCommand("[SP_REP_BY_COMMENT$GET2]", connection))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add("@CommentId", SqlDbType.Int).Value = CommentID;

                connection.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    int ID = Convert.ToInt32(reader[0]);
                    string Author = reader[2].ToString();
                    string AuthorName = reader[3].ToString();
                    string Content = reader[4].ToString();
                    string CrtTime = reader[5].ToString();
                    Replys.Add(new Reply()
                    {
                        id = ID,
                        comment_id = CommentID,
                        author = Author,
                        authorName = AuthorName,
                        content = Content,
                        crt_date = CrtTime,
                    });
                }
                connection.Close();
            }
            return Replys;
        }
        public int addReply(string userID, int commentID, string content)
        {
            var Replyid = -1;
            using (SqlCommand cmd = new SqlCommand("SP_REPlY$POST", connection))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@UserId", userID));
                cmd.Parameters.Add(new SqlParameter("@CmtContent", content));
                cmd.Parameters.Add(new SqlParameter("@CmtId", commentID));

                var returnParameter = cmd.Parameters.Add("@ReturnVal", SqlDbType.Int);
                returnParameter.Direction = ParameterDirection.ReturnValue;

                connection.Open();
                cmd.ExecuteNonQuery();
                Replyid = (int)returnParameter.Value;
                connection.Close();
            }
            return Replyid;
        }
    }

}