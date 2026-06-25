# Changelog

## 0.1.0

- Initial AnswerLayer Ruby SDK release.
- Added `AnswerLayer::Client` with resources for connections, query execution, inquiry sessions, saved queries, dashboards, query results, semantic layer, and identity broker.
- Added API-key configuration, default AnswerLayer API base URL, request timeouts, subject header support, and OAuth token exchange support.
- Added JSON request/response handling, downloads, server-sent event parsing, and lightweight response objects: `ApiResponse`, `ResultEnvelope`, `DownloadResponse`, and `StreamEvent`.
- Added status-aware SDK errors under `AnswerLayer::Error`, including `ApiError` subclasses with `status`, `body`, and `headers`.
- Added RSpec coverage using captured response fixtures for documented resource shapes.
- Added public README, resource, response, authentication, configuration, and error documentation.
