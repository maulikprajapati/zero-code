using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using Ocelot.DependencyInjection;
using Ocelot.Middleware;
using System.Text;
using System.Diagnostics;

var builder = WebApplication.CreateBuilder(args);

// Add Ocelot configuration
builder.Configuration.AddJsonFile("ocelot.json", optional: false, reloadOnChange: true);

// JWT Configuration
var jwtKey = "MySecretKeyForJWTTokenGeneration123456789";
var key = Encoding.ASCII.GetBytes(jwtKey);

builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer("Bearer", options =>
    {
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuerSigningKey = true,
            IssuerSigningKey = new SymmetricSecurityKey(key),
            ValidateIssuer = false,
            ValidateAudience = false,
            ClockSkew = TimeSpan.Zero
        };
    });

builder.Services.AddOcelot();

var app = builder.Build();

// Handle health check before Ocelot
app.Use(async (context, next) =>
{
    if (context.Request.Path == "/health")
    {
        context.Response.ContentType = "application/json";
        await context.Response.WriteAsync("{\"status\":\"healthy\",\"service\":\"apigateway\"}");
        return;
    }
    await next();
});

app.Use(async (context, next) =>
{
    var activity = Activity.Current;
    if (activity != null && context.Request.Path.HasValue)
    {
        activity.SetTag("http.route", context.Request.Path.Value);
        activity.DisplayName = $"{context.Request.Method} {context.Request.Path.Value}";
    }
    await next();
});

app.UseAuthentication();

await app.UseOcelot();

app.Run();