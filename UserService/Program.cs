using System.Text.Json;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using NLog.Web;
using Newtonsoft.Json;
using JsonSerializer = System.Text.Json.JsonSerializer;

var builder = WebApplication.CreateBuilder(args);

builder.Logging.ClearProviders();
builder.Configuration.AddJsonFile("nlog.json", optional: false, reloadOnChange: true);
builder.Host.UseNLog();

builder.Services.AddHttpClient();
builder.Services.AddControllers();

var app = builder.Build();
var logger = NLog.LogManager.GetCurrentClassLogger();

app.MapControllers();

app.MapGet("/health", () => new { status = "healthy", service = "userservice" });
app.MapGet("/something/health", () => new { status = "healthy", service = "userservice" });
app.MapGet("/maulik/health", () => new { status = "healthy", service = "userservice" });

// Auth endpoint
app.MapPost("/auth/login", (LoginRequest request) =>
{
    logger.Info("Login attempt for user: {Username}", request.Username);
    var obj = new { Id = 1, Name = "Maulik", Email = "mprajapati@gsmorg.com" };
    logger.Info("abc" + JsonConvert.SerializeObject(obj).Replace("\"", "\\\""));
    
    // Simple validation (in real app, check against database)
    if (request.Username == "admin" && request.Password == "password")
    {
        var jwtKey = "MySecretKeyForJWTTokenGeneration123456789";
        var key = Encoding.ASCII.GetBytes(jwtKey);

        var tokenHandler = new JwtSecurityTokenHandler();
        var tokenDescriptor = new SecurityTokenDescriptor
        {
            Subject = new ClaimsIdentity(new[] { new Claim("username", request.Username) }),
            Expires = DateTime.UtcNow.AddHours(1),
            SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256Signature)
        };

        var token = tokenHandler.CreateToken(tokenDescriptor);
        var tokenString = tokenHandler.WriteToken(token);

        logger.Info("Login successful for user: {Username}", request.Username);
        return Results.Ok(new { Token = tokenString, Username = request.Username });
    }
    
    logger.Warn("Login failed for user: {Username}", request.Username);
    return Results.Unauthorized();
});

app.MapGet("/users/{id}", async (int id, HttpClient httpClient) =>
{
    logger.Info("Fetching user with ID: {UserId}", id);
    
    var user = new { Id = id, Name = $"User{id}", Email = $"user{id}@example.com" };
    
    try
    {
        logger.Info("Calling OrderService for user: {UserId}", id);
        var ordersResponse = await httpClient.GetStringAsync($"http://orderservice:9901/orders/user/{id}");
        var orders = JsonSerializer.Deserialize<object[]>(ordersResponse);
        
        logger.Info("Successfully retrieved {OrderCount} orders for user: {UserId}", orders?.Length ?? 0, id);
        return new { User = user, Orders = orders };
    }
    catch (Exception ex)
    {
        logger.Error(ex, "Error fetching orders for user: {UserId}", id);
        return new { User = user, Orders = Array.Empty<object>() };
    }
});

app.Run();

public record LoginRequest(string Username, string Password);