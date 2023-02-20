namespace MiniORM.APP.Data;

using Entities;
using Microsoft.EntityFrameworkCore;

public class SoftuniDbContext : DbContext
{
	public SoftuniDbContext(string connectionString)
		: base(connectionString)
	{

	}

	public DbSet<Employee> Employees { get; set; }
	public DbSet<Project> Projects { get; set; }
	public DbSet<Department> Departments { get; set; }
	public DbSet<EmployeeProject> EmployeeProjects { get; set; }
}
