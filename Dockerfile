FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
# Puertos para Render
ENV ASPNETCORE_URLS=http://+:8080
WORKDIR /app
EXPOSE 8080

FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src

# 1. Copiamos todos los archivos del contexto de compilación (Render lo inyecta)
# El contexto de compilación es la carpeta que definimos en Render.
COPY . .

# 2. Restaurar, Compilar y Publicar
# Ahora que el csproj está en la raíz (/src), los comandos son simples:
RUN dotnet restore
RUN dotnet publish -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=build /app/publish .
# El nombre de la DLL DEBE ser el nombre del proyecto original
ENTRYPOINT ["dotnet", "Lab 14 - Carlos Alonso Mamani.dll"]