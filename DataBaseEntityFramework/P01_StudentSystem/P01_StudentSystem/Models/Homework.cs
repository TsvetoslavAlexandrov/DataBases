
namespace P01_StudentSystem.Models;

using Microsoft.EntityFrameworkCore;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;


using P01_StudentSystem.Models.Enum;

public class Homework
{
    [Key]
    public int HomeworkId { get; set; }

    [Required]
    [Unicode]
    public string Content { get; set; }

    public ContentType ContentType { get; set; }

    [Required]
    public DateTime SubmissionTime { get; set; }


    [ForeignKey(nameof(Student))]
    public int StudentId { get; set; }
    public virtual Student Student { get; set; }


    [ForeignKey(nameof(Course))]
    public int CourseId { get; set; }
    public virtual Course Course { get; set; }
}
