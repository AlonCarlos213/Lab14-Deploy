FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
# Puertos para Render
ENV ASPNETCORE_URLS=http://+:8080
WORKDIR /app
EXPOSE 8080

FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
# Usamos un nombre temporal simple (project.csproj) para evitar problemas de espacios
COPY "Lab 14 - Carlos Alonso Mamani/Lab 14 - Carlos Alonso Mamani.csproj" project.csproj
COPY "Lab 14 - Carlos Alonso Mamani/" "Lab 14 - Carlos Alonso Mamani/"

# La restauración y compilación usan la ruta simple del proyecto
RUN dotnet restore project.csproj
COPY . .
WORKDIR "/src"
RUN dotnet build project.csproj -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish
WORKDIR "/src"
RUN dotnet publish project.csproj -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
# El nombre de la DLL DEBE ser el nombre del proyecto original
ENTRYPOINT ["dotnet", "Lab 14 - Carlos Alonso Mamani.dll"]