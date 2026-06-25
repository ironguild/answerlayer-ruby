# Authentication

The SDK supports API-key calls, trusted-passthrough subject headers, and OAuth token exchange.

## API-Key Calls

Most server-side AnswerLayer API calls use API-key authentication.

```ruby
client = AnswerLayer::Client.new(api_key: api_key)
client.connections.list
```

The SDK sends:

```text
X-API-Key: <api key>
```

## Subject Headers

Trusted-passthrough subject headers are optional:

```ruby
client = AnswerLayer::Client.new(
  api_key: api_key,
  subject_org_id: "customer-org",
  subject_user_id: "user-123"
)
```

Eligible API-key requests can send:

```text
X-Subject-Org-ID: customer-org
X-Subject-User-ID: user-123
```

Dashboard parameter updates require subject-org context.

## OAuth Token Exchange

Identity broker token exchange uses API-key auth and `application/x-www-form-urlencoded` request bodies:

```ruby
token = client.identity_broker.exchange_token(subject_token: idp_jwt)
```

The response is returned as an `AnswerLayer::ApiResponse`.

Do not commit API keys or JWTs.
