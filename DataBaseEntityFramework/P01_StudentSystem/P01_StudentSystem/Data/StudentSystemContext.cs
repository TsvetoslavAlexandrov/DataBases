
namespace P01_StudentSystem.Data;

using Microsoft.EntityFrameworkCore;

using P01_StudentSystem.Common;
using P01_StudentSystem.Models;

public class StudentSystemContext : DbContext
{
	public StudentSystemContext()
	{

	}

	public StudentSystemContext(DbContextOptions options)
		:base(options)
	{

	}

	public DbSet<Student> Students { get; set; }
	public DbSet<StudentCourse> StudentCourses { get; set; }
	public DbSet<Course> Courses { get; set; }
	public DbSet<Homework> HomeWorks { get; set; }
	public DbSet<Resource> Resources { get; set; }
    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    {
		if (!optionsBuilder.IsConfigured)
		{
		  optionsBuilder.UseSqlServer(DbConfig.ConnectionString);

		}
    }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity <StudentCourse>(pk =>
		{
			pk.HasKey(e => new { e.StudentId, e.CourseId });
		});
    }
}
