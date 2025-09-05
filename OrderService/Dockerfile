FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 9901

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["OrderService.csproj", "."]
RUN dotnet restore "OrderService.csproj"
COPY . .
RUN dotnet build "OrderService.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "OrderService.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app

# Install .NET auto-instrumentation
RUN apt-get update && apt-get install -y curl unzip
RUN curl -sSfL https://github.com/open-telemetry/opentelemetry-dotnet-instrumentation/releases/latest/download/otel-dotnet-auto-install.sh -O
RUN chmod +x otel-dotnet-auto-install.sh
ENV OTEL_DOTNET_AUTO_HOME=/opt/otel
RUN ./otel-dotnet-auto-install.sh
RUN chmod -R 755 /opt/otel

COPY --from=publish /app/publish .

ENV ASPNETCORE_URLS=http://+:9901
ENV OTEL_SERVICE_NAME=orderservice
# ENV OTEL_EXPORTER_OTLP_ENDPOINT=http://tempo:4318
ENV OTEL_EXPORTER_OTLP_ENDPOINT=http://alloy:4318
ENV OTEL_EXPORTER_OTLP_PROTOCOL=http/protobuf
ENV OTEL_LOG_LEVEL=debug
ENV OTEL_DOTNET_AUTO_TRACES_ENABLED=true
ENV Logging__Console__FormatterName=json
ENV CORECLR_ENABLE_PROFILING=1
ENV OTEL_DOTNET_AUTO_HTTP_SERVER_EXCLUDED_URLS=/debug/pprof.*
ENV CORECLR_PROFILER={918728DD-259F-4A6A-AC2B-B85E1B658318}
ENV CORECLR_PROFILER_PATH=/opt/otel/linux-x64/OpenTelemetry.AutoInstrumentation.Native.so
ENV DOTNET_STARTUP_HOOKS=/opt/otel/net/OpenTelemetry.AutoInstrumentation.StartupHook.dll
ENV DOTNET_ADDITIONAL_DEPS=/opt/otel/AdditionalDeps
ENV DOTNET_SHARED_STORE=/opt/otel/store


RUN addgroup --system appgroup && adduser --system --ingroup appgroup --uid 1000 appuser
USER appuser

ENTRYPOINT ["/opt/otel/instrument.sh", "dotnet", "OrderService.dll"]
