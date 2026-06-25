# Responses

The SDK uses plain Ruby hashes/arrays where the API shape is flexible and lightweight wrappers where shared behavior is useful.

## ApiResponse

`AnswerLayer::ApiResponse` wraps flexible JSON objects.

```ruby
response = client.query.validate(connection_id: connection_id, query: sql)
response["is_valid"]
response.to_h
```

It preserves:

- parsed data
- optional HTTP status
- optional headers

## ResultEnvelope

`AnswerLayer::ResultEnvelope` wraps paginated tabular results.

```ruby
result = client.saved_queries.execute(saved_query_id: saved_query_id)
result.columns
result.rows
result.next_cursor
result.result_handle
result.has_next_page?
```

Handles and cursors are opaque and nullable. Callers must not assume a result handle exists.

## DownloadResponse

`AnswerLayer::DownloadResponse` represents successful file/download responses.

```ruby
download = client.query.export(connection_id: connection_id, query: sql, format: :csv)
download.body
download.content_type
download.filename
download.status
download.headers
```

The SDK does not write downloads to disk automatically.

Download endpoints can still return JSON errors. Those errors raise status-aware SDK exceptions.

## StreamEvent

`AnswerLayer::StreamEvent` represents SSE events.

```ruby
events = AnswerLayer::SSEParser.parse(stream_body)
events.each do |event|
  event.type
  event.data
  event.raw
end
```

Known and unknown event types are preserved. SSE `error` events raise `AnswerLayer::StreamError`.

## Flexible Responses

Endpoints with partially documented or deployment-specific response bodies intentionally remain flexible.
