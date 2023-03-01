﻿using P02.FootballBetting.Data.Common;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace P02_FootballBetting.Data.Models;

public class Town
{
    public Town()
    {
        this.Teams = new HashSet<Team>();
    }
    [Key]
    public int TownId { get; set; }

    [Required]
    [MaxLength(ValidationConstants.TownNameMaxLenght)]
    public string Name { get; set; }


    [ForeignKey(nameof(Country))]
    public int CountryId { get; set; }
    public virtual Country Country { get; set; }

    public virtual ICollection<Team> Teams { get; set; }


}
