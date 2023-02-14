


using Microsoft.Data.SqlClient;

SqlConnection connection = new SqlConnection("Server=DESKTOP-T72EM4Q\\SQLEXPRESS01;Database=Softuni;Integrated Security=True;TrustServerCertificate=True;");

connection.Open();


using (connection)
{
    SqlCommand command = new SqlCommand("SELECT * FROM Employees WHERE FirstName = 'David'", connection);
    SqlDataReader reader = command.ExecuteReader();

    using (reader)
    {
        while (reader.Read())
        {
            string firstName = (string)reader["FirstName"];
            string lastName = (string)reader["LastName"];
            decimal salary = (decimal)reader["Salary"];
            Console.WriteLine($"FullName: {firstName} {lastName} Salary: {salary:f2}");
        }
    }
}