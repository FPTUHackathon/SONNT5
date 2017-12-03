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

        public static List<dynamic> GetLanguages() {
            SqlConnection connection = GetConnection();
            connection.Open();
            SqlCommand command = new SqlCommand("SELECT * FROM Language", connection);
            SqlDataReader reader = command.ExecuteReader();
            List<dynamic> list = new List<dynamic>();
            while (reader.Read()) list.Add(new {
                LanguageId = reader[0].ToString(),
                LanguageName = reader[1].ToString()
            });
            reader.Close();
            connection.Close();
            return list;
        }

        public static List<dynamic> GetCountries() {
            SqlConnection connection = GetConnection();
            connection.Open();
            SqlCommand command = new SqlCommand("SELECT * FROM Country", connection);
            SqlDataReader reader = command.ExecuteReader();
            List<dynamic> list = new List<dynamic>();
            while (reader.Read()) list.Add(new {
                CountryId = reader[0].ToString(),
                CountryName = reader[1].ToString()
            });
            reader.Close();
            connection.Close();
            return list;
        }

        public static dynamic GetUserMiniDetails(string userId) {
            SqlConnection connection = GetConnection();
            connection.Open();
            SqlCommand command = new SqlCommand("EXEC SP_USER_INFO_MINI_DISPLAY$GET @userId", connection);
            command.Parameters.AddWithValue("@userId", userId);
            SqlDataReader reader = command.ExecuteReader();
            dynamic result = null;
            if (reader.Read()) result = new {
                UserId = reader[0].ToString(),
                FlgUpdate = Convert.ToBoolean(reader[1]),
                FullName = reader[2].ToString(),
                Gender = Convert.ToBoolean(reader[3]),
                Country = reader[4].ToString(),
            };
            reader.Close();
            connection.Close();
            return result;
        }

        public static dynamic GetUserDetails(string userId) {
            SqlConnection connection = GetConnection();
            connection.Open();
            SqlCommand command = new SqlCommand("EXEC SP_USER_INFO_FULL_EDIT$GET @userId", connection);
            command.Parameters.AddWithValue("@userId", userId);
            SqlDataReader reader = command.ExecuteReader();
            dynamic result = null;
            if (reader.Read()) result = new {
                UserId = reader[0].ToString(),
                FlgUpdate = Convert.ToBoolean(reader[1]),
                FirstName = reader[2].ToString(),
                LastName = reader[3].ToString(),
                ImagePath = reader[4].ToString(),
                CountryId = reader[5].ToString(),
                DOB = Convert.ToDateTime(reader[6]),
                Gender = Convert.ToBoolean(reader[7]),
                LanguageIds = reader[8].ToString(),
                About = reader[9].ToString()
            };
            reader.Close();
            connection.Close();
            return result;
        }

        public static void UpdateUserInfo(string userId, string firstName, string lastName, string imagePath, bool gender, DateTime dob, string about, string countryId, string languageIds) {
            SqlConnection connection = GetConnection();
            connection.Open();
            SqlCommand command = new SqlCommand("EXEC SP_USER_INFO_FULL_EDIT$POST @userId, @firstName, @lastName, @imagePath, @gender, @dob, @about, @countryId, @languageIds", connection);
            command.Parameters.AddWithValue("@userId", userId);
            command.Parameters.AddWithValue("@firstName", firstName);
            command.Parameters.AddWithValue("@lastName", lastName);
            command.Parameters.AddWithValue("@imagePath", imagePath);
            command.Parameters.AddWithValue("@gender", gender);
            command.Parameters.AddWithValue("@dob", dob);
            command.Parameters.AddWithValue("@about", about);
            command.Parameters.AddWithValue("@countryId", countryId);
            command.Parameters.AddWithValue("@languageIds", languageIds);
            command.ExecuteNonQuery();
            connection.Close();
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

        public static List<dynamic> MessageRoomSearch(string UserId, string RoomId, string Text)
        {
            SqlConnection connection = GetConnection();
            connection.Open();
            SqlCommand command = new SqlCommand("EXEC SP_MESSAGE_ROOM_SEARCH$GET @UserId, @RoomId, @Text", connection);
            command.Parameters.AddWithValue("@UserId", UserId);
            command.Parameters.AddWithValue("@RoomId", RoomId);
            command.Parameters.AddWithValue("@Text", Text);
            SqlDataReader reader = command.ExecuteReader();
            List<dynamic> list = new List<dynamic>();
            while (reader.Read()) list.Add(new
            {
                MessageId = reader[0].ToString(),
                Row = Convert.ToInt32(reader[1]),
                Total = Convert.ToInt32(reader[2]),
            });
            reader.Close();
            connection.Close();
            return list;
        }

        public static List<dynamic> MessageRoomSearchUp(string UserId, string RoomId, string MessId)
        {
            SqlConnection connection = GetConnection();
            connection.Open();
            SqlCommand command = new SqlCommand("EXEC SP_MESSAGE_GET_UP$GET @UserId, @RoomId, @MessId", connection);
            command.Parameters.AddWithValue("@UserId", UserId);
            command.Parameters.AddWithValue("@RoomId", RoomId);
            command.Parameters.AddWithValue("@MessId", MessId);
            SqlDataReader reader = command.ExecuteReader();
            List<dynamic> list = new List<dynamic>();
            while (reader.Read()) list.Add(new
            {
                MessageId = reader[0].ToString(),
                RoomName = reader[1].ToString(),
                RoomId = reader[2].ToString(),
                Id = reader[3].ToString(),
                FullName = reader[4].ToString(),
                MessContent = reader[5].ToString(),
                Status = Convert.ToInt32(reader[6]),
                CreatedTime = Convert.ToDateTime(reader[7]),
            });
            reader.Close();
            connection.Close();
            return list;
        }

        public static List<dynamic> MessageRoomSearchDown(string UserId, string RoomId, string MessId)
        {
            SqlConnection connection = GetConnection();
            connection.Open();
            SqlCommand command = new SqlCommand("EXEC SP_MESSAGE_GET_DOWN$GET @UserId, @RoomId, @MessId", connection);
            command.Parameters.AddWithValue("@UserId", UserId);
            command.Parameters.AddWithValue("@RoomId", RoomId);
            command.Parameters.AddWithValue("@MessId", MessId);
            SqlDataReader reader = command.ExecuteReader();
            List<dynamic> list = new List<dynamic>();
            while (reader.Read()) list.Add(new
            {
                MessageId = reader[0].ToString(),
                RoomName = reader[1].ToString(),
                RoomId = reader[2].ToString(),
                Id = reader[3].ToString(),
                FullName = reader[4].ToString(),
                MessContent = reader[5].ToString(),
                Status = Convert.ToInt32(reader[6]),
                CreatedTime = Convert.ToDateTime(reader[7]),
            });
            reader.Close();
            connection.Close();
            return list;
        }

        public static List<dynamic> MessageRoomSearchMid(string UserId, string RoomId, string MessId)
        {
            SqlConnection connection = GetConnection();
            connection.Open();
            SqlCommand command = new SqlCommand("EXEC SP_MESSAGE_GET_MID$GET @UserId, @RoomId, @MessId", connection);
            command.Parameters.AddWithValue("@UserId", UserId);
            command.Parameters.AddWithValue("@RoomId", RoomId);
            command.Parameters.AddWithValue("@MessId", MessId);
            SqlDataReader reader = command.ExecuteReader();
            List<dynamic> list = new List<dynamic>();
            while (reader.Read()) list.Add(new
            {
                MessageId = reader[0].ToString(),
                RoomName = reader[1].ToString(),
                RoomId = reader[2].ToString(),
                Id = reader[3].ToString(),
                FullName = reader[4].ToString(),
                MessContent = reader[5].ToString(),
                Status = Convert.ToInt32(reader[6]),
                CreatedTime = Convert.ToDateTime(reader[7]),
            });
            reader.Close();
            connection.Close();
            return list;
        }

        public static List<dynamic> GetUsers() {
            SqlConnection connection = GetConnection();
            connection.Open();
            SqlCommand command = new SqlCommand("SELECT * FROM AspNetUsers INNER JOIN UserInfor ON UserInfor.UserId = AspNetUsers.Id", connection);
            SqlDataReader reader = command.ExecuteReader();
            List<dynamic> list = new List<dynamic>();
            while (reader.Read()) list.Add(new {
                UserId = reader[0].ToString(),
                Name = reader[1].ToString()
            });
            reader.Close();
            connection.Close();
            return list;
        }

        public static List<dynamic> SearchUserByName(string name) {
            SqlConnection connection = GetConnection();
            connection.Open();
            SqlCommand command = new SqlCommand("SELECT TOP 5 Id, UserName, CONCAT(ISNULL(UserInfor.FirstName,''),' ',ISNULL(UserInfor.LastName,'')) AS FullName FROM AspNetUsers INNER JOIN UserInfor ON UserInfor.UserId = AspNetUsers.Id WHERE CONCAT(ISNULL(UserInfor.FirstName,''),' ',ISNULL(UserInfor.LastName,'')) LIKE @name", connection);
            command.Parameters.AddWithValue("@name", $"%{name}%");
            SqlDataReader reader = command.ExecuteReader();
            List<dynamic> list = new List<dynamic>();
            while (reader.Read()) list.Add(new {
                UserId = reader[0].ToString(),
                Name = reader["UserName"].ToString(),
                FullName = reader["FullName"].ToString()
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

        public static List<string> GetRoomByUserId(string userId) {
            SqlConnection connection = GetConnection();
            connection.Open();
            SqlCommand command = new SqlCommand("SELECT * FROM RoomUsers WHERE UserId = @userId", connection);
            command.Parameters.AddWithValue("@userId", userId);
            SqlDataReader reader = command.ExecuteReader();
            List<string> list = new List<string>();
            while (reader.Read()) list.Add(reader[0].ToString());
            reader.Close();
            connection.Close();
            return list;
        }

        public static string GetRoomByUserIds(string userId, string userIds, string roomName) {
            SqlConnection connection = GetConnection();
            connection.Open();
            SqlCommand command = new SqlCommand("EXEC SP_ROOM$POST2 @userId, @userIds, @roomName", connection);
            command.Parameters.AddWithValue("@userId", userId);
            command.Parameters.AddWithValue("@userIds", userIds);
            command.Parameters.AddWithValue("@roomName", roomName ?? "New Room");
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
                FullName = reader[3].ToString(),
                MessContent = reader[4].ToString(),
                Status = Convert.ToInt32(reader[5]),
                CreatedDate = Convert.ToDateTime(reader[6])
            });
            reader.Close();
            connection.Close();
            return result;
        }
        public static void LogVideo(string userId1, string userId2, DateTime startTime, DateTime endTime) {
            var roomId = DbContext.GetRoomByUserIds(userId1, $"{userId1},{userId2}", "");
            SqlConnection connection = GetConnection();
            connection.Open();
            SqlCommand command = new SqlCommand("EXEC SP_LOG_VIDEO$POST @userId1, @userId2, @roomId, @startTime, @endTime", connection);
            command.Parameters.AddWithValue("@userId1", userId1);
            command.Parameters.AddWithValue("@userId2", userId2);
            command.Parameters.AddWithValue("@roomId", roomId);
            command.Parameters.AddWithValue("@startTime", startTime);
            command.Parameters.AddWithValue("@endTime", endTime);
            command.ExecuteNonQuery();
            connection.Close();
        }
    }
}