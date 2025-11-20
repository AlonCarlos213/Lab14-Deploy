FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
# Puertos para Render
ENV ASPNETCORE_URLS=http://+:8080
WORKDIR /app
EXPOSE 8080

FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /app_build

# 1. Copiamos el .csproj y los archivos de la solución
# Usamos un nombre de archivo simple para evitar errores de sintaxis
COPY Lab 14 - Carlos Alonso Mamani/Lab 14 - Carlos Alonso Mamani.csproj .
COPY Lab 14 - Carlos Alonso Mamani/Lab 14 - Carlos Alonso Mamani.sln .
COPY . .

# 2. Restaurar, Compilar y Publicar usando el nombre del proyecto
# Nota: Los comandos dotnet son inteligentes y usan la ruta del WORKDIR
RUN dotnet restore
RUN dotnet publish Lab\ 14\ -\ Carlos\ Alonso\ Mamani.csproj -c Release -o /app/out /p:UseAppHost=false


FROM base AS final
WORKDIR /app
# Copiamos la salida final (la carpeta 'out')
COPY --from=build /app/out .
# El nombre de la DLL DEBE ser el nombre del proyecto original
ENTRYPOINT ["dotnet", "Lab 14 - Carlos Alonso Mamani.dll"]