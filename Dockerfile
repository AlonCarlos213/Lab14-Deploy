FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
# Configuración del puerto 8080 para Render
ENV ASPNETCORE_URLS=http://+:8080
WORKDIR /app
EXPOSE 8080

FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src

# 1. Copiamos TODO el contenido del repositorio a la carpeta /src del contenedor
COPY . .

# 2. Entramos explícitamente a la carpeta anidada donde está el .csproj
# Las comillas son vitales aquí para manejar los espacios en el nombre
WORKDIR "/src/Lab 14 - Carlos Alonso Mamani/Lab 14 - Carlos Alonso Mamani"

# 3. Restaurar, Compilar y Publicar
# Como ya estamos dentro de la carpeta correcta, no necesitamos poner rutas largas aquí
RUN dotnet restore
RUN dotnet publish -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=build /app/publish .
# El punto de entrada con el nombre exacto de tu DLL
ENTRYPOINT ["dotnet", "Lab 14 - Carlos Alonso Mamani.dll"]