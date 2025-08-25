using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();

builder.Services.AddDbContext<OrderContext>(options =>
    options.UseNpgsql("Host=postgres;Database=orderdb;Username=postgres;Password=password"));

var app = builder.Build();
var logger = app.Logger;

app.MapControllers();

app.MapGet("/health", () => new { status = "healthy", service = "orderservice" });

app.MapGet("/orders/user/{userId}", async (int userId, OrderContext context) =>
{
    logger.LogInformation("Fetching orders for user: {UserId}", userId);
    
    try
    {
        var orders = await context.Orders
            .Where(o => o.UserId == userId)
            .Select(o => new { o.Id, o.UserId, o.Product, o.Amount })
            .ToListAsync();
        
        logger.LogInformation("Found {OrderCount} orders for user: {UserId}", orders.Count, userId);
        return orders;
    }
    catch (Exception ex)
    {
        logger.LogError(ex, "Error fetching orders for user: {UserId}", userId);
        throw;
    }
});

app.Run();

public class OrderContext : DbContext
{
    public OrderContext(DbContextOptions<OrderContext> options) : base(options) { }
    public DbSet<Order> Orders { get; set; }
    
    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Order>(entity =>
        {
            entity.ToTable("orders");
            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.UserId).HasColumnName("user_id");
            entity.Property(e => e.Product).HasColumnName("product");
            entity.Property(e => e.Amount).HasColumnName("amount");
            entity.Property(e => e.CreatedAt).HasColumnName("created_at");
        });
    }
}

public class Order
{
    public int Id { get; set; }
    public int UserId { get; set; }
    public string Product { get; set; } = string.Empty;
    public decimal Amount { get; set; }
    public DateTime CreatedAt { get; set; }
}