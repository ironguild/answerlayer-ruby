# Configuration

`AnswerLayer::Client` accepts configuration directly.

## Defaults

```ruby
client = AnswerLayer::Client.new
```

Pass credentials directly when constructing the client.

The default API base URL is:

```text
https://app.answerlayer.io/api/v1
```

## Constructor Options

```ruby
client = AnswerLayer::Client.new(
  api_key: api_key,
  base_url: "https://app.answerlayer.io/api/v1",
  subject_org_id: "customer-org",
  subject_user_id: "user-123",
  open_timeout: 10,
  read_timeout: 30
)
```

## Global Configuration

```ruby
AnswerLayer.configure do |config|
  config.api_key = ENV["ANSWERLAYER_API_KEY"]
  config.base_url = "https://app.answerlayer.io/api/v1"
end

client = AnswerLayer.client
```

## Environment Loading

If your application uses environment variables, dotenv, or another secret loader, read those values before constructing the client.

Do not commit local env files, API keys, JWTs, or credential-equivalent values.
