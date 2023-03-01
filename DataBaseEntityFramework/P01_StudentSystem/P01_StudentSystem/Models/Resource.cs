
namespace P01_StudentSystem.Models;


using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;


using P01_StudentSystem.Models.Enum;
using P01_StudentSystem.Common;

public class Resource
{
    [Key]
    public int ResourceId { get; set; }

    [Required]
    [MaxLength(StudentSystemCommons.ResourceNameLength)]
    public string Name { get; set; }

    [Required]
    [MaxLength(StudentSystemCommons.ResourceUrlLength)]
    public string Url { get; set; }

    public ResourceType ResourceType { get; set; }


    //Relations
    [ForeignKey(nameof(Course))]
    public int CourseId { get; set; }
    public virtual Course Course { get; set; }
}
