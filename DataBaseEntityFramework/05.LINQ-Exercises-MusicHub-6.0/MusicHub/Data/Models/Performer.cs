﻿namespace MusicHub.Data.Models;

using System.ComponentModel.DataAnnotations;

public class Performer
{
    public Performer()
    {
        this.PerformerSongs = new HashSet<SongPerformer>();
    }

    [Key]
    public int Id { get; set; }

    [MaxLength(ValidationConstants.PerformarNameLength)]
    public string FirstName { get; set; } = null!;

    [MaxLength(ValidationConstants.PerformarNameLength)]
    public string LastName { get; set; } = null!;

    public int Age { get; set; }
    public decimal NetWorth { get; set; }

    public virtual ICollection<SongPerformer> PerformerSongs { get; set; }
}
