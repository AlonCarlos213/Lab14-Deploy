FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
# Puertos para Render
ENV ASPNETCORE_URLS=http://+:8080
WORKDIR /app
EXPOSE 8080

FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src

# 1. Copiamos la carpeta completa del proyecto (la subcarpeta anidada)
# El primer argumento es la carpeta *dentro* de la raíz del repositorio.
# El segundo argumento es dónde ponerla.
# NOTA: La barra inclinada final (/) es crucial.
COPY Lab 14 - Carlos Alonso Mamani/Lab 14 - Carlos Alonso Mamani/ Lab 14 - Carlos Alonso Mamani/

# 2. Entramos en la carpeta que contiene el archivo .csproj
WORKDIR "/src/Lab 14 - Carlos Alonso Mamani/Lab 14 - Carlos Alonso Mamani"

# 3. Restaura (Ahora estamos en el directorio correcto, no necesita ruta)
RUN dotnet restore

# 4. Compila
COPY . .
RUN dotnet build -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish
WORKDIR "/src/Lab 14 - Carlos Alonso Mamani/Lab 14 - Carlos Alonso Mamani"
RUN dotnet publish -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Lab 14 - Carlos Alonso Mamani.dll"]