using MiniORM.APP;
using MiniORM.APP.Data;
using MiniORM.APP.Data.Entities;

internal class StartUp
{
    private static void Main(string[] args)
    {
        SoftuniDbContext dbContext = new SoftuniDbContext(Config.ConnectionString);

        Employee newEmployee = new Employee()
        {
            FirstName = "Test",
            LastName = "Testov",
            DepartmentId = dbContext.Departments.First().Id,
            IsEmployed = true
        };
        dbContext.Employees.Add(newEmployee);

        dbContext.SaveChanges();
    }
}