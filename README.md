# AnswerLayer Ruby SDK

The AnswerLayer Ruby SDK is a lightweight client for calling the AnswerLayer API from Ruby applications. It exposes one `AnswerLayer::Client` with resources for connections, query execution, inquiry sessions, saved queries, dashboards, query results, semantic layer, and identity broker.

## Requirements

- Ruby 3.1 or newer

## Installation

With Bundler:

```ruby
gem "answerlayer"
```

Then install:

```sh
bundle install
```

Or install the gem directly:

```sh
gem install answerlayer
```

## Quick Start

Pass your API key directly:

```ruby
require "answerlayer"

client = AnswerLayer::Client.new(api_key: "your-api-key")

connections = client.connections.list

result = client.query.execute(
  connection_id: "connection-id",
  query: "SELECT 1 AS ok"
)
```

## Configuration

Pass your API key directly:

```ruby
client = AnswerLayer::Client.new(api_key: "your-api-key")
```

See [docs/configuration.md](docs/configuration.md) for timeout, subject header, and advanced configuration options.

## Resources

Resources group related API methods under the client:

```ruby
client.connections
client.query
client.inquiry
client.saved_queries
client.dashboards
client.query_results
client.semantic
client.identity_broker
```

See [docs/resources.md](docs/resources.md) for method-level documentation.

## Responses

The SDK returns plain Ruby hashes/arrays for simple flexible responses and lightweight wrappers for common shapes:

- `AnswerLayer::ApiResponse`
- `AnswerLayer::ResultEnvelope`
- `AnswerLayer::DownloadResponse`
- `AnswerLayer::StreamEvent`

See [docs/responses.md](docs/responses.md).

## Errors

All SDK errors inherit from `AnswerLayer::Error`, so applications can rescue one base class for AnswerLayer failures:

```ruby
begin
  client.query.validate(connection_id: "connection-id", query: "SELECT * FROM table")
rescue AnswerLayer::Error => error
  warn error.message
end
```

HTTP response errors inherit from `AnswerLayer::ApiError` and expose `status`, `body`, and `headers`. Status-specific classes are available for common responses such as bad request, unauthorized, not found, rate limit, and server errors.

See [docs/errors.md](docs/errors.md).

## Examples

Examples under `examples/` show common SDK usage:

- `examples/basic_usage.rb`
