FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

WORKDIR /app

COPY src/*.csproj ./src/
RUN dotnet restore ./src/TodoApi.csproj

COPY src/. ./src/

RUN dotnet publish ./src/TodoApi.csproj -c Release -o out

FROM mcr.microsoft.com/dotnet/aspnet:8.0

WORKDIR /app

COPY --from=build /app/out .

EXPOSE 8080

ENTRYPOINT ["dotnet", "TodoApi.dll"]

