
namespace P01_StudentSystem.Models;

using Microsoft.EntityFrameworkCore;
using System.ComponentModel.DataAnnotations;


using P01_StudentSystem.Common;

public class Course
{
    public Course()
    {
        Students = new HashSet<Student>();
        Resources = new HashSet<Resource>();
        Homeworks = new HashSet<Homework>();
    }
    [Key]
    public int CourseId { get; set; }

    [Required]
    [StringLength(StudentSystemCommons.CourseNameLength)]
    [Unicode]
    public string Name { get; set; }

    [Unicode]
    [MaxLength(StudentSystemCommons.CourseDescriptionLength)]
    public string Description { get; set; }

    public DateTime StartDate { get; set; }
    public DateTime EndDate { get; set; }

    public decimal Price { get; set; }


    public virtual ICollection<Student> Students { get; set; }
    public virtual ICollection<Resource> Resources { get; set; }
    public virtual ICollection<Homework> Homeworks { get; set; }
}
