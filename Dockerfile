FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
ENV ASPNETCORE_URLS=http://+:8080
WORKDIR /app
EXPOSE 8080

FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src

# Copiar solución y proyecto
COPY "Lab 14 - Carlos Alonso Mamani.sln" .
COPY "Lab 14 - Carlos Alonso Mamani/Lab 14 - Carlos Alonso Mamani.csproj" "Lab 14 - Carlos Alonso Mamani/"

# Copiar el resto del código
COPY . .

# Restaurar y publicar
RUN dotnet restore
RUN dotnet publish "Lab 14 - Carlos Alonso Mamani/Lab 14 - Carlos Alonso Mamani.csproj" -c Release -o /app/out /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=build /app/out .

ENTRYPOINT ["dotnet", "Lab 14 - Carlos Alonso Mamani.dll"]
