namespace BookShop
{
    using BookShop.Models;
    using BookShop.Models.Enums;
    using Data;
    using Initializer;
    using Microsoft.EntityFrameworkCore;
    using Microsoft.EntityFrameworkCore.Infrastructure;
    using Microsoft.EntityFrameworkCore.Metadata.Internal;
    using Microsoft.Extensions.Primitives;
    using System.Reflection;
    using System.Text;

    public class StartUp
    {
        public static void Main()
        {
            using var db = new BookShopContext();
            //DbInitializer.ResetDatabase(db);
            //string command = Console.ReadLine();
            //int year = int.Parse(Console.ReadLine());
            //string categories = Console.ReadLine();
            //string date = Console.ReadLine();
            // int count = int.Parse(Console.ReadLine());
            //int result = CountBooks(db, count);

            //string result = GetMostRecentBooks(db);
            //Console.WriteLine(result);
           int result = RemoveBooks(db);
            Console.WriteLine(result);
        }

        //Problem 2
        public static string GetBooksByAgeRestriction(BookShopContext dbContext, string command)
        {

            AgeRestriction ageRestriction = Enum.Parse<AgeRestriction>(command, true);

            string[] bookTitles = dbContext.Books
                .Where(b => b.AgeRestriction == ageRestriction)
                .OrderBy(b => b.Title)
                .Select(b => b.Title)
                .ToArray();
            return string.Join(Environment.NewLine, bookTitles);

        }
        //Problem 3
        public static string GetGoldenBooks(BookShopContext context)
        {
            string[] goldenBooks = context.Books
                .Where(gb => gb.Copies < 5000 && gb.EditionType == EditionType.Gold)
                .OrderBy(b => b.BookId)
                .Select(b => b.Title)
                .ToArray();

            return string.Join(Environment.NewLine, goldenBooks);
        }
        //Problem 4
        public static string GetBooksByPrice(BookShopContext context)
        {
            var booksByPrice = string.Join($"{Environment.NewLine}", context.Books
                .Where(b => b.Price > 40)
                .OrderByDescending(b => b.Price)
                .Select(b => $"{b.Title} - ${b.Price:F2}")
                .ToList());
            return booksByPrice;

        }
        //Problem 5
        public static string GetBooksNotReleasedIn(BookShopContext context, int year)
        {
            var booksNotReleased = string.Join($"{Environment.NewLine}", context.Books
                .Where(b => b.ReleaseDate.Value.Year != year)
                .OrderBy(b => b.BookId)
                .Select(b => b.Title)
                .ToList());

            return booksNotReleased;
        }
        //Problem 6
        public static string GetBooksByCategory(BookShopContext context, string input)
        {
            string[] categories = input
                .Split(' ', StringSplitOptions.RemoveEmptyEntries)
                .Select(x => x.ToLower())
                .ToArray();


            string[] bookByCategory = context.Books
                .Where(b => b.BookCategories
                .Any(bc => categories.Contains(bc.Category.Name.ToLower())))
                .OrderBy(b => b.Title)
                .Select(b => b.Title)
                .ToArray();


            return string.Join($"{Environment.NewLine}", bookByCategory);
        }
        //Problem 7
        public static string GetBooksReleasedBefore(BookShopContext context, string date)
        {

            DateTime parsedDate = DateTime.ParseExact(date, "dd-MM-yyyy", null);
            var booksReleasedBefore = string.Join($"{Environment.NewLine}", context.Books
                .Where(br => br.ReleaseDate < parsedDate)
                .OrderByDescending(b => b.ReleaseDate)
                .Select(b => $"{b.Title} - {b.EditionType} - ${b.Price:F2}")
                .ToList());

            return booksReleasedBefore;


        }
        //Problem 8
        public static string GetAuthorNamesEndingIn(BookShopContext context, string input)
        {
            string[] authorNamesEndingIn = context.Authors
                .Where(a => a.FirstName.EndsWith(input))
                .OrderBy(a => a.FirstName)
                .ThenBy(a => a.LastName)
                .Select(a => $"{a.FirstName} {a.LastName}")
                .ToArray();

            return string.Join(Environment.NewLine, authorNamesEndingIn);

        }
        //Problem 9
        public static string GetBookTitlesContaining(BookShopContext context, string input)
        {
            string[] bookTitlesContaining = context.Books
                .Where(b => b.Title.ToLower().Contains(input.ToLower()))
                .OrderBy(b => b.Title)
                .Select(b => b.Title)
                .ToArray();

            return string.Join(Environment.NewLine, bookTitlesContaining);
        }
        //Problem 10
        public static string GetBooksByAuthor(BookShopContext context, string input)
        {
            StringBuilder sb = new StringBuilder();
            var booksByAuthor = context.Books
                .Where(b => b.Author.LastName.ToLower().StartsWith(input.ToLower()))
                .OrderBy(b => b.BookId)
                .Select(b => new
                {
                    TitleName = b.Title,
                    AuthorName = $"{b.Author.FirstName} {b.Author.LastName}"
                })
                .ToArray();

            foreach (var b in booksByAuthor)
            {
                sb
                    .AppendLine($"{b.TitleName} ({b.AuthorName})");
            }
            return sb.ToString().TrimEnd();
        }
        //Problem 11
        public static int CountBooks(BookShopContext context, int lengthCheck)
        {
            var countBooks = context.Books
                .Where(b => b.Title.Length > lengthCheck)
                .ToArray();


            return countBooks.Length;
        }
        //Problem 12
        public static string CountCopiesByAuthor(BookShopContext context)
        {
            StringBuilder sb = new StringBuilder();
            var copiesByAuthor = context.Authors
                .Select(a => new
                {
                    AuthorName = $"{a.FirstName} {a.LastName}",
                    TotalCopies = a.Books
                    .Sum(b => b.Copies)
                })
                .ToArray()
                .OrderByDescending(b => b.TotalCopies);

            foreach (var s in copiesByAuthor)
            {
                sb
                    .AppendLine($"{s.AuthorName} - {s.TotalCopies}");
            }
            return sb.ToString().TrimEnd();
        }
        //Problem 13
        public static string GetTotalProfitByCategory(BookShopContext context)
        {
            var totalProfit = context.Categories
                .Select(c => new
                {
                    CategoriesName = c.Name,
                    TotalProfit = c.CategoryBooks
                    .Sum(b => b.Book.Price * b.Book.Copies)
                })
                .ToArray()
                .OrderByDescending(c => c.TotalProfit)
                .ThenBy(c => c.CategoriesName);

            StringBuilder sb = new StringBuilder();

            foreach (var b in totalProfit)
            {
                sb
                    .AppendLine($"{b.CategoriesName} ${b.TotalProfit:f2}");
            }
            return sb.ToString().TrimEnd();
        }
        //Problem 14
        public static string GetMostRecentBooks(BookShopContext context)
        {
            StringBuilder sb = new StringBuilder();

            var categoriesWithMostRecentBooks = context.Categories
                .OrderBy(c => c.Name)
                .Select(c => new
                {
                    CategoryName = c.Name,
                    MostRecentBooks = c.CategoryBooks
                        .OrderByDescending(cb => cb.Book.ReleaseDate)
                        .Take(3)
                        .Select(cb => new
                        {
                            BookTitle = cb.Book.Title,
                            ReleaseYear = cb.Book.ReleaseDate.Value.Year
                        })
                        .ToArray()
                })
                .ToArray();

            foreach (var c in categoriesWithMostRecentBooks)
            {
                sb.AppendLine($"--{c.CategoryName}");

                foreach (var b in c.MostRecentBooks)
                {
                    sb.AppendLine($"{b.BookTitle} ({b.ReleaseYear})");
                }
            }

            return sb.ToString().TrimEnd();


        }
        //Problem 15
        public static void IncreasePrices(BookShopContext context)
        {
            var booksToIncrease = context.Books
                .Where(b => b.ReleaseDate.Value.Year < 2010);
            foreach (var book in booksToIncrease)
            {
                book.Price += 5;
            }
            context.SaveChanges();
        }
        //Problem 16
        public static int RemoveBooks(BookShopContext context)
        {
            var booksToRemove = context.Books
                .Where(b => b.Copies < 4200);
            context.Books
                .RemoveRange(booksToRemove);
            int booksDeleted = context.SaveChanges();
            return booksDeleted;
        }
    }
}


