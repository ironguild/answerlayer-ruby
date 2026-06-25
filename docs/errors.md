# Errors

All SDK errors inherit from:

```ruby
AnswerLayer::Error
```

## Configuration And Request Errors

- `AnswerLayer::ConfigurationError` - missing or inconsistent local SDK configuration.
- `AnswerLayer::RequestError` - unsupported request behavior or transport-level failures.
- `AnswerLayer::ResponseError` - response bodies that cannot be parsed as JSON.

## Status-Aware API Errors

HTTP response errors inherit from:

```ruby
AnswerLayer::ApiError
```

`ApiError` exposes:

- `status`
- `body`
- `headers`

Specific API error classes map to standard HTTP status names:

- `AnswerLayer::BadRequestError` - HTTP 400.
- `AnswerLayer::UnauthorizedError` - HTTP 401.
- `AnswerLayer::ForbiddenError` - HTTP 403.
- `AnswerLayer::NotFoundError` - HTTP 404.
- `AnswerLayer::ConflictError` - HTTP 409.
- `AnswerLayer::GoneError` - HTTP 410.
- `AnswerLayer::UnprocessableEntityError` - HTTP 422.
- `AnswerLayer::RateLimitError` - HTTP 429.
- `AnswerLayer::ServerError` - HTTP 5xx.

API-specific meanings, such as an expired result handle for HTTP 410, are documented at the endpoint level rather than encoded in custom exception class names.

Standard JSON API errors read the `detail` field when present.

## OAuth Errors

OAuth-shaped responses with `error` and `error_description` raise:

```ruby
AnswerLayer::OAuthError
```

`OAuthError` inherits from `ApiError` and also exposes:

- `error`
- `error_description`

## Stream Errors

SSE `error` events raise:

```ruby
AnswerLayer::StreamError
```

Stream errors are separate from HTTP status errors.

## Rescue Pattern

```ruby
begin
  client.query.validate(connection_id: connection_id, query: sql)
rescue AnswerLayer::Error => error
  warn error.message
end
```
