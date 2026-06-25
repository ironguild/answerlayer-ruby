# frozen_string_literal: true

module AnswerLayer
  class ConnectionsResource < Resource
    def list
      request(method: :get, path: "/connections/")
    end

    def test_existing(connection_id:)
      to_api_response(request(method: :post, path: "/connections/#{connection_id}/test_existing"))
    end

    def schema(connection_id:)
      request(method: :get, path: "/connections/#{connection_id}/schema")
    end

    def upload_csv(file:, name: nil, has_header: nil, delimiter: nil)
      request(method: :post, path: "/csv/upload", multipart: compact(file: file, name: name, has_header: has_header, delimiter: delimiter))
    end

    def upload_duckdb(file:, name: nil)
      request(method: :post, path: "/duckdb/upload", multipart: compact(file: file, name: name))
    end
  end
end
