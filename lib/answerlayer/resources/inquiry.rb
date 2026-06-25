# frozen_string_literal: true

module AnswerLayer
  class InquiryResource < Resource
    def create_session(connection_id:, model: nil)
      to_api_response(request(method: :post, path: "/inquiry/sessions", body: compact(connection_id: connection_id, model: model)))
    end

    def list_sessions
      request(method: :get, path: "/inquiry/sessions")
    end

    def session(session_id:)
      request(method: :get, path: "/inquiry/sessions/#{session_id}")
    end

    def turn_stream(session_id:, user_input:)
      request(method: :post, path: "/inquiry/sessions/#{session_id}", body: { user_input: user_input })
    end

    def turn_sync(session_id:, user_input:)
      to_api_response(request(method: :post, path: "/inquiry/sessions/#{session_id}/sync", body: { user_input: user_input }))
    end
  end
end
