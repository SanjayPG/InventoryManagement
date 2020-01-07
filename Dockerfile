FROM mcr.microsoft.com/dotnet/core/aspnet:2.2-stretch-slim AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/core/sdk:2.2-stretch AS build
WORKDIR /src
COPY ["InventoryManagement/InventoryManagement.csproj", "InventoryManagement/"]
RUN dotnet restore "InventoryManagement/InventoryManagement.csproj"
COPY . .
WORKDIR "/src/InventoryManagement"
RUN dotnet build "InventoryManagement.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "InventoryManagement.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "InventoryManagement.dll"]
