namespace P03_FootballBetting.Data.Models
{
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    using P02.FootballBetting.Data.Common;
    using P02_FootballBetting.Data.Models;

    public class Player
    {
        public Player()
        {
            this.PlayersStatistics = new HashSet<PlayerStatistic>();
        }

        [Key]
        public int PlayerId { get; set; }

        [Required]
        [MaxLength(ValidationConstants.PlayerNameMaxLenght)]
        public string Name { get; set; } = null!;

        //Required by default
        public byte SquadNumber { get; set; }

        public bool IsInjured { get; set; }

        [ForeignKey(nameof(Team))]
        public int TeamId { get; set; }
        public virtual Team Team { get; set; } = null!;

        [ForeignKey(nameof(Position))]
        public int PositionId { get; set; }
        public virtual Position Position { get; set; } = null!;

        //BIT -> 0, 1 (True, False)

        public virtual ICollection<PlayerStatistic> PlayersStatistics { get; set; } 
    }
}