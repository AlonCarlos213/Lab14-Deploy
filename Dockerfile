FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
# Puertos para Render
ENV ASPNETCORE_URLS=http://+:8080
WORKDIR /app
EXPOSE 8080

FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY "Lab 14 - Carlos Alonso Mamani/Lab 14 - Carlos Alonso Mamani.csproj" "./Lab 14 - Carlos Alonso Mamani/"

RUN dotnet restore "Lab 14 - Carlos Alonso Mamani/Lab 14 - Carlos Alonso Mamani.csproj"

COPY . .
WORKDIR "/src/Lab 14 - Carlos Alonso Mamani"
RUN dotnet build "Lab 14 - Carlos Alonso Mamani.csproj" -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish
WORKDIR "/src/Lab 14 - Carlos Alonso Mamani"
RUN dotnet publish "Lab 14 - Carlos Alonso Mamani.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Lab 14 - Carlos Alonso Mamani.dll"]