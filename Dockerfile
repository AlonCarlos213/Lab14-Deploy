FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
ENV ASPNETCORE_URLS=http://+:8080
WORKDIR /app
EXPOSE 8080

FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# 1. Copiamos TODO el repositorio
COPY . .

# 2. BUSCAR Y RESTAURAR AUTOMÁTICAMENTE
# Este comando busca cualquier archivo .csproj y lo usa, sin importar la carpeta
RUN dotnet restore "$(find . -name "*.csproj" | head -n 1)"

# 3. COMPILAR AUTOMÁTICAMENTE
RUN dotnet build "$(find . -name "*.csproj" | head -n 1)" -c Release -o /app/build

# 4. PUBLICAR AUTOMÁTICAMENTE
RUN dotnet publish "$(find . -name "*.csproj" | head -n 1)" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=build /app/publish .
# Asegúrate de que este nombre sea EXACTO al de tu proyecto
ENTRYPOINT ["dotnet", "Lab 14 - Carlos Alonso Mamani.dll"]