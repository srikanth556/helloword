FROM mcr.microsoft.com/dotnet/core/aspnet:2.1 AS base
WORKDIR /app
EXPOSE 8080
EXPOSE 443

FROM mcr.microsoft.com/dotnet/core/sdk:2.1 AS build
WORKDIR /src
COPY ["JenkiTest.csproj", "./"]
RUN dotnet restore "./JenkiTest.csproj"
COPY . .
WORKDIR /app/JenkiTest
RUN dotnet build "JenkiTest.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "JenkiTest.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "JenkiTest.dll"]
