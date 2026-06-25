# Resource Methods

The SDK exposes one `AnswerLayer::Client` with resource namespaces.

```ruby
client = AnswerLayer::Client.new
```

## Connections

```ruby
client.connections.list
client.connections.test_existing(connection_id: connection_id)
client.connections.schema(connection_id: connection_id)
client.connections.upload_csv(file: path_or_io, name: "Dataset", has_header: true, delimiter: ",")
client.connections.upload_duckdb(file: path_or_io, name: "Warehouse")
```

Notes:

- `list` returns a flexible array of connection objects.
- `test_existing` returns an `ApiResponse`.
- `schema` returns a flexible hash keyed by table name.
- Upload response shapes are returned as decoded JSON.

## Query

```ruby
client.query.execute(connection_id: connection_id, query: "SELECT 1 AS ok")
client.query.validate(connection_id: connection_id, query: "SELECT 1 AS ok")
client.query.export(connection_id: connection_id, query: "SELECT 1 AS ok", format: :csv)
```

Notes:

- `execute` returns the direct query result shape.
- `validate` returns an `ApiResponse`; invalid SQL can be represented in the HTTP 200 body rather than as an SDK exception.
- `export` returns `DownloadResponse` on successful file responses.

## Inquiry

```ruby
client.inquiry.create_session(connection_id: connection_id)
client.inquiry.list_sessions
client.inquiry.session(session_id: session_id)
client.inquiry.turn_stream(session_id: session_id, user_input: "Show one row")
client.inquiry.turn_sync(session_id: session_id, user_input: "Show one row")
```

Notes:

- Session creation returns an `ApiResponse`.
- List/detail responses remain flexible around nested turn/result fields.
- Turn stream/sync calls can be long-running depending on the query and model response.

## Saved Queries

```ruby
client.saved_queries.list
client.saved_queries.create(name: "Example", sql: "SELECT 1 AS ok", connection_id: connection_id)
client.saved_queries.get(saved_query_id: saved_query_id)
client.saved_queries.execute(saved_query_id: saved_query_id)
client.saved_queries.update(saved_query_id: saved_query_id, description: "Updated")
client.saved_queries.delete(saved_query_id: saved_query_id)
client.saved_queries.create_from_inquiry_turn(inquiry_turn_id: turn_id, name: "From inquiry")
```

Notes:

- `list`, `create`, `get`, and `update` return `ApiResponse`.
- `execute` returns `ResultEnvelope`.
- `delete` accepts empty success responses.
- `create_from_inquiry_turn` returns decoded JSON.

## Dashboards

```ruby
client.dashboards.manifest(dashboard_id: dashboard_id)
client.dashboards.tile_data(dashboard_id: dashboard_id, tile_id: tile_id)
client.dashboards.parameters(dashboard_id: dashboard_id, tile_id: tile_id)
client.dashboards.update_parameters(dashboard_id: dashboard_id, tile_id: tile_id, values: {}, subject_org_id: subject_org_id)
```

Notes:

- Manifest and parameter contracts remain flexible around tile, visualization, and parameter internals.
- `tile_data` returns `ResultEnvelope`.
- Parameter update mutates subject-scoped dashboard settings.

## Query Results

```ruby
client.query_results.get(handle: result_handle, cursor: cursor, limit: 10)
client.query_results.release(handle: delete_safe_result_handle)
```

Notes:

- `get` returns `ResultEnvelope`.
- Handles and cursors are opaque and nullable.
- `release` frees a result handle and returns `nil` for empty success responses.

## Semantic

```ruby
component = "entities"

client.semantic.components(component: component, connection_id: connection_id)
client.semantic.jobs
client.semantic.create_component(component: component, attributes: attributes)
client.semantic.get_component(component: component, id: component_id)
client.semantic.update_component(component: component, id: component_id, attributes: attributes)
client.semantic.delete_component(component: component, id: component_id)
client.semantic.generate_stream(component: component, connection_id: connection_id, prompt: prompt)
client.semantic.create_job(connection_id: connection_id, component_type: component, prompt: prompt)
client.semantic.job_stream(job_id: job_id)
client.semantic.job_questions(job_id: job_id)
client.semantic.submit_guidance(job_id: job_id, responses: responses)
client.semantic.job_status(job_id: job_id)
client.semantic.cancel_job(job_id: job_id)
```

Notes:

- Component payloads remain flexible until each type is sampled.
- Mutating, generation, and job lifecycle calls return decoded JSON or stream events depending on the method.

## Identity Broker

```ruby
client.identity_broker.exchange_token(subject_token: idp_jwt)
client.identity_broker.jwks
```

Notes:

- `exchange_token` requires an IdP JWT and uses OAuth form encoding.
- `jwks` calls host-root `/.well-known/jwks.json`.
