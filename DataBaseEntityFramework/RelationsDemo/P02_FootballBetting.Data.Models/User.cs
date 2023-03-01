using P02.FootballBetting.Data.Common;
using System.ComponentModel.DataAnnotations;

namespace P02_FootballBetting.Data.Models;

public class User
{
    public User()
    {
        this.Bets = new HashSet<Bet>();
    }
    [Key]
    public int UserId { get; set; }

    [Required]
    [MaxLength(ValidationConstants.UserUsernameMaxLenght)]
    public string Username { get; set; }

    [MaxLength(ValidationConstants.UserPasswordMaxLenght)]
    public int Password { get; set; }

    [Required]
    [MaxLength(ValidationConstants.UserEmailMaxLenght)]
    public string Email { get; set; }

    [Required]
    [MaxLength(ValidationConstants.UserNameMaxLenght)]
    public string Name { get; set; }

    public decimal Balance { get; set; }

    public virtual ICollection<Bet> Bets { get; set; }

}
