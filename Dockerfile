FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
# Puertos para Render
ENV ASPNETCORE_URLS=http://+:8080
WORKDIR /app
EXPOSE 8080

FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src

# Copia solo el archivo del proyecto .csproj al directorio actual (/src)
# Render/Docker LO TIENE QUE VER, por lo que usamos la ruta relativa del repositorio.
# El nombre del archivo es la clave: Lab 14 - Carlos Alonso Mamani.csproj
COPY "Lab 14 - Carlos Alonso Mamani/Lab 14 - Carlos Alonso Mamani.csproj" "./Lab 14 - Carlos Alonso Mamani/"

# Entramos en la carpeta donde está el proyecto, ya que ahí está el .csproj
# Esta ruta debe ser la carpeta que contiene el archivo .csproj
WORKDIR "/src/Lab 14 - Carlos Alonso Mamani"

# 1. Restaura (Ya estamos en el directorio correcto)
RUN dotnet restore

# 2. Compila
COPY . .
RUN dotnet build -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish
WORKDIR "/src/Lab 14 - Carlos Alonso Mamani"
RUN dotnet publish -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Lab 14 - Carlos Alonso Mamani.dll"]