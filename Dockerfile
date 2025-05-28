FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 8080

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Kopiere zuerst nur die Projektdatei
COPY ["bewerbung.csproj", "./"]
RUN ls -la
RUN dotnet restore "bewerbung.csproj"

# Dann den Rest der Dateien
COPY . .
RUN dotnet build "bewerbung.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "bewerbung.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENV ASPNETCORE_URLS=http://+:8080
ENTRYPOINT ["dotnet", "bewerbung.dll"]