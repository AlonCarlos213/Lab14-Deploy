// Laboratorio 14 - Prueba de GitHub Actions

var builder = WebApplication.CreateBuilder(args);

// *** AGREGANDO SWAGGER ***
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// Agregar el servicio de Controladores (Necesario para el Web API)
builder.Services.AddControllers(); 
// *** FIN DE LA CORRECCIÓN DE SERVICIOS ***


// Add services to the container.
// Learn more about configuring OpenAPI at https://aka.ms/aspnet/openapi
builder.Services.AddOpenApi();


var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    // *** USAR SWAGGER EN DEV ***
    app.UseSwagger();
    app.UseSwaggerUI();
    
    app.MapOpenApi();
}

// Configuración para permitir HTTPS (aunque Render usa HTTP/8080)
app.UseHttpsRedirection();

// Mapear los Controladores
app.MapControllers();


var summaries = new[]
{
    "Freezing", "Bracing", "Chilly", "Cool", "Mild", "Warm", "Balmy", "Hot", "Sweltering", "Scorching"
};

app.MapGet("/weatherforecast", () =>
    {
        var forecast = Enumerable.Range(1, 5).Select(index =>
                new WeatherForecast
                (
                    DateOnly.FromDateTime(DateTime.Now.AddDays(index)),
                    Random.Shared.Next(-20, 55),
                    summaries[Random.Shared.Next(summaries.Length)]
                ))
            .ToArray();
        return forecast;
    })
    .WithName("GetWeatherForecast");

app.Run();

record WeatherForecast(DateOnly Date, int TemperatureC, string? Summary)
{
    public int TemperatureF => 32 + (int)(TemperatureC / 0.5556);
}