FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
# Puertos para Render
ENV ASPNETCORE_URLS=http://+:8080
WORKDIR /app
EXPOSE 8080

FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src

# PASO CLAVE: Copia el repositorio completo (TODA la carpeta de GitHub) a /src.
# Esta es la forma más segura de manejar rutas con espacios.
COPY . .

# Entramos en la carpeta anidada del proyecto (.csproj) usando comillas
WORKDIR "/src/Lab 14 - Carlos Alonso Mamani/Lab 14 - Carlos Alonso Mamani"

# Restaura (Estamos en el directorio correcto, no necesita ruta)
RUN dotnet restore

# Compila
RUN dotnet build -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish
# WORKDIR de nuevo para la fase de publicación
WORKDIR "/src/Lab 14 - Carlos Alonso Mamani/Lab 14 - Carlos Alonso Mamani"
RUN dotnet publish -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
# Nombre del archivo .dll generado (generalmente sin espacios)
ENTRYPOINT ["dotnet", "Lab 14 - Carlos Alonso Mamani.dll"]