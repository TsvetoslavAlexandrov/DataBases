using P02.FootballBetting.Data.Common;
using P03_FootballBetting.Data.Models;
using System.ComponentModel.DataAnnotations;

namespace P02_FootballBetting.Data.Models;

public class Position
{
    public Position()
    {
        this.Players = new HashSet<Player>();
    }
    [Key]
    public int PositionId { get; set; }

    [Required]
    [MaxLength(ValidationConstants.PositionNameMaxLenght)]
    public string Name { get; set; } = null!;

    public virtual ICollection<Player> Players { get; set; }
}
