FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
ENV ASPNETCORE_URLS=http://+:8080
WORKDIR /app
EXPOSE 8080

FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /app_build

# 1. Copiamos el .csproj y .sln usando rutas con comillas
COPY "Lab 14 - Carlos Alonso Mamani/Lab 14 - Carlos Alonso Mamani/Lab 14 - Carlos Alonso Mamani.csproj" .
COPY "Lab 14 - Carlos Alonso Mamani/Lab 14 - Carlos Alonso Mamani.sln" .

# Copiamos todo el proyecto
COPY . .

# Restauramos y publicamos
RUN dotnet restore
RUN dotnet publish "Lab 14 - Carlos Alonso Mamani/Lab 14 - Carlos Alonso Mamani.csproj" -c Release -o /app/out /p:UseAppHost=false

FROM base AS final
WORKDIR /app

# Copiamos la publicación
COPY --from=build /app/out .

# Ejecutamos la DLL con espacios
ENTRYPOINT ["dotnet", "Lab 14 - Carlos Alonso Mamani.dll"]
