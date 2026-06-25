# AnswerLayer Ruby SDK

The AnswerLayer Ruby SDK is a lightweight client for calling the AnswerLayer API from Ruby applications. It exposes one `AnswerLayer::Client` with resources for connections, query execution, inquiry sessions, saved queries, dashboards, query results, semantic-layer APIs, and identity broker APIs.

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

Pass credentials and client options directly:

```ruby
client = AnswerLayer::Client.new(
  api_key: "your-api-key",
  open_timeout: 10,
  read_timeout: 30
)
```

## Resources

Resources group related API methods under the client, such as connections, queries, dashboards, saved queries, semantic-layer APIs, and identity broker APIs.

See [docs/resources.md](docs/resources.md) for method-level documentation.

## Responses

The SDK returns plain Ruby hashes/arrays for simple flexible responses and lightweight wrappers for common shapes:

- `AnswerLayer::ApiResponse`
- `AnswerLayer::ResultEnvelope`
- `AnswerLayer::DownloadResponse`
- `AnswerLayer::StreamEvent`

See [docs/responses.md](docs/responses.md).

## Errors

All SDK errors inherit from `AnswerLayer::Error`.

Status-aware errors include bad-request, unauthorized, forbidden, not-found, conflict, gone, unprocessable-entity, rate-limit, server, OAuth, and stream errors.

```ruby
begin
  client.query.validate(connection_id: "connection-id", query: "SELECT * FROM table")
rescue AnswerLayer::Error => error
  warn error.message
end
```

See [docs/errors.md](docs/errors.md).

## Examples

Examples under `examples/` show common SDK usage:

- `examples/basic_usage.rb`
