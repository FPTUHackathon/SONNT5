using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace degoiapi.Data {
    public class DbContext {
        private static SqlConnection GetConnection() {
            return new SqlConnection(ConfigurationManager.ConnectionStrings["db"].ConnectionString);
        }

        public static List<dynamic> GetUserIdsByRoomId(string roomId) {
            SqlConnection connection = GetConnection();
            connection.Open();
            SqlCommand command = new SqlCommand("SELECT * FROM RoomUsers WHERE RoomId = @roomId", connection);
            command.Parameters.AddWithValue("@roomId", roomId);
            SqlDataReader reader = command.ExecuteReader();
            List<dynamic> list = new List<dynamic>();
            while (reader.Read()) list.Add(new {
                RoomId = reader[0].ToString(),
                UserId = reader[1].ToString(),
                NickName = reader[2].ToString(),
                Status = Convert.ToInt32(reader[3]),
                CreatedDate = Convert.ToDateTime(reader[4]),
                UpdatedDate = Convert.ToDateTime(reader[5])
            });
            reader.Close();
            connection.Close();
            return list;
        }

        public static dynamic GetNumUserByRoomId(string roomId) {
            SqlConnection connection = GetConnection();
            connection.Open();
            SqlCommand command = new SqlCommand("SELECT COUNT(UserId) as 'Count' from RoomUsers where RoomId = @roomId", connection);
            command.Parameters.AddWithValue("@roomId", roomId);
            SqlDataReader reader = command.ExecuteReader();
            dynamic result = null;
            if (reader.Read()) result = new {
                Count = reader[0].ToString(),
            };
            reader.Close();
            connection.Close();
            return result;
        }

        public static dynamic GetMessage(int messageId) {
            SqlConnection connection = GetConnection();
            connection.Open();
            SqlCommand command = new SqlCommand("SELECT * FROM Message WHERE MessageId = @messageId", connection);
            command.Parameters.AddWithValue("@messageId", messageId);
            SqlDataReader reader = command.ExecuteReader();
            dynamic result = null;
            if (reader.Read()) result = new {
                MessageId = reader[0].ToString(),
                RoomId = reader[1].ToString(),
                UserId = reader[2].ToString(),
                MessContent = reader[3].ToString(),
                Status = Convert.ToInt32(reader[4]),
                CreatedDate = Convert.ToDateTime(reader[5])
            };
            reader.Close();
            connection.Close();
            return result;
        }

        public static int PostMessage(string roomId, string userId, string message, int type) {
            SqlConnection connection = GetConnection();
            connection.Open();
            SqlCommand command = new SqlCommand("EXEC SP_MESSAGE$POST @roomId, @userId, @message, @type", connection);
            command.Parameters.AddWithValue("@roomId", roomId);
            command.Parameters.AddWithValue("@userId", userId);
            command.Parameters.AddWithValue("@message", message);
            command.Parameters.AddWithValue("@type", type);
            SqlDataReader reader = command.ExecuteReader();
            int result = 0;
            if (reader.Read()) result = Convert.ToInt32(reader[0]);
            reader.Close();
            connection.Close();
            return result;
        }

        public static string GetRoomByUserIds(string userId, string userIds) {
            SqlConnection connection = GetConnection();
            connection.Open();
            SqlCommand command = new SqlCommand("EXEC SP_ROOM$POST @userId, @userIds", connection);
            command.Parameters.AddWithValue("@userId", userId);
            command.Parameters.AddWithValue("@userIds", userIds);
            SqlDataReader reader = command.ExecuteReader();
            string result = "";
            if (reader.Read()) result = reader[0].ToString();
            reader.Close();
            connection.Close();
            return result;
        }

        public static dynamic GetRoomById(string roomId) {
            SqlConnection connection = GetConnection();
            connection.Open();
            SqlCommand command = new SqlCommand("EXEC SP_ROOM_INFO$GET @roomId", connection);
            command.Parameters.AddWithValue("@roomId", roomId);
            SqlDataReader reader = command.ExecuteReader();
            dynamic result = null;
            if (reader.Read()) result = new {
                RoomId = reader[0].ToString(),
                Name = reader[1].ToString(),
                UserIds = reader[2].ToString(),
                Total = Convert.ToInt32(reader[3]),
            };
            reader.Close();
            connection.Close();
            return result;
        }

        public static List<dynamic> GetMessageHistory(string userId, string roomId, DateTime startTime, int maxCount) {
            SqlConnection connection = GetConnection();
            connection.Open();
            SqlCommand command = new SqlCommand("EXEC SP_MESSAGE_ROOM$GET @userId, @roomId, @startTime, @maxCount", connection);
            command.Parameters.AddWithValue("@userId", userId);
            command.Parameters.AddWithValue("@roomId", roomId);
            command.Parameters.AddWithValue("@startTime", startTime);
            command.Parameters.AddWithValue("@maxCount", maxCount);
            SqlDataReader reader = command.ExecuteReader();
            List<dynamic> result = new List<dynamic> ();
            while (reader.Read()) result.Add(new {
                RoomName = reader[0].ToString(),
                RoomId = reader[1].ToString(),
                UserId = reader[2].ToString(),
                MessContent = reader[3].ToString(),
                Status = Convert.ToUInt32(reader[4]),
                CreatedDate = Convert.ToDateTime(reader[5])
            });
            reader.Close();
            connection.Close();
            return result;
        }
    }
}