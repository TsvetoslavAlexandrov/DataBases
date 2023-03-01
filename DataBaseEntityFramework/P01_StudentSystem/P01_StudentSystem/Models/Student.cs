
namespace P01_StudentSystem.Models;


using System.ComponentModel.DataAnnotations;
using Microsoft.EntityFrameworkCore;

using P01_StudentSystem.Common;


public class Student
{
    public Student()
    {
        Courses = new HashSet<Course>();
        HomeWorks = new HashSet<Homework>();
    }
    [Key]
    public int StudentId { get; set; }

    [Required]
    [MaxLength(StudentSystemCommons.StudentNameLength)]
    [Unicode]
    public string Name { get; set; }

    [MaxLength(StudentSystemCommons.StudentPhoneNumberLength)]
    public string PhoneNumber { get; set; }

    [Required]
    public DateTime RegisteredOn { get; set; }

    public DateTime? Birthday { get; set; }


    public virtual ICollection<Course> Courses { get; set; }
    public virtual ICollection<Homework> HomeWorks { get; set; }



}
