using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web.Script.Serialization;
using System.Web.Services;

namespace Learning_Management_System.authUser.Admin
{
    public partial class User
    {
        [WebMethod]
        public static string GetAllUsersWithIds(string userType = "")
        {
            try
            {
                List<object> users = new List<object>();
                
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    
                    string query = @"
                        SELECT 
                            u.UserID, u.FullName, u.Email, u.Phone, u.UserType, 
                            u.DepartmentID, d.DepartmentName AS Department, 
                            u.LevelID, l.LevelName AS Level, 
                            u.ProgrammeID, p.ProgrammeName AS Programme, 
                            u.ProfilePicture, 
                            u.EmployeeID, u.CreatedDate, u.IsActive,
                            STRING_AGG(COALESCE(c.CourseCode, ''), ', ') as AssignedCourses
                        FROM Users u
                        LEFT JOIN Department d ON u.DepartmentID = d.DepartmentID
                        LEFT JOIN Level l ON u.LevelID = l.LevelID
                        LEFT JOIN Programme p ON u.ProgrammeID = p.ProgrammeID
                        LEFT JOIN UserCourses uc ON u.UserID = uc.UserID
                        LEFT JOIN Courses c ON uc.CourseID = c.CourseID
                        WHERE u.IsActive = 1 " + 
                        (string.IsNullOrEmpty(userType) ? "" : "AND u.UserType = @UserType") + @"
                        GROUP BY u.UserID, u.FullName, u.Email, u.Phone, u.UserType, 
                                u.DepartmentID, d.DepartmentName, 
                                u.LevelID, l.LevelName, 
                                u.ProgrammeID, p.ProgrammeName, 
                                u.ProfilePicture, u.EmployeeID, u.CreatedDate, u.IsActive
                        ORDER BY u.FullName";
                    
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        if (!string.IsNullOrEmpty(userType))
                        {
                            cmd.Parameters.AddWithValue("@UserType", userType);
                        }
                        
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                users.Add(new
                                {
                                    id = Convert.ToInt32(reader["UserID"]),
                                    fullName = reader["FullName"].ToString(),
                                    email = reader["Email"].ToString(),
                                    phone = reader["Phone"].ToString(),
                                    userType = reader["UserType"].ToString().ToLower(),
                                    departmentId = reader["DepartmentID"] != DBNull.Value ? Convert.ToInt32(reader["DepartmentID"]) : 0,
                                    department = reader["Department"].ToString(),
                                    levelId = reader["LevelID"] != DBNull.Value ? Convert.ToInt32(reader["LevelID"]) : 0,
                                    level = reader["Level"]?.ToString() ?? "",
                                    programmeId = reader["ProgrammeID"] != DBNull.Value ? Convert.ToInt32(reader["ProgrammeID"]) : 0,
                                    programme = reader["Programme"].ToString(),
                                    profilePic = reader["ProfilePicture"] != DBNull.Value ? "data:image/jpeg;base64," + Convert.ToBase64String((byte[])reader["ProfilePicture"]) : "../../../Assest/Images/user.png",
                                    employeeId = reader["EmployeeID"]?.ToString() ?? "",
                                    courses = reader["AssignedCourses"]?.ToString()?.Split(',').Where(c => !string.IsNullOrEmpty(c.Trim())).ToArray() ?? new string[0],
                                    createdDate = Convert.ToDateTime(reader["CreatedDate"]).ToString("yyyy-MM-dd"),
                                    isActive = Convert.ToBoolean(reader["IsActive"])
                                });
                            }
                        }
                    }
                }
                
                return new JavaScriptSerializer().Serialize(new { success = true, data = users });
            }
            catch (Exception ex)
            {
                LogError("GetAllUsersWithIds Error", ex);
                return new JavaScriptSerializer().Serialize(new { success = false, message = "Error retrieving users: " + ex.Message });
            }
        }
    }
}
