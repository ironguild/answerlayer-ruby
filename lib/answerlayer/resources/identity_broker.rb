# frozen_string_literal: true

module AnswerLayer
  class IdentityBrokerResource < Resource
    SUBJECT_TOKEN_TYPE = "urn:ietf:params:oauth:token-type:jwt"

    def exchange_token(subject_token:, subject_token_type: SUBJECT_TOKEN_TYPE)
      to_api_response(request(method: :post, path: "/oauth/token", auth: :oauth, form: {
        grant_type: "urn:ietf:params:oauth:grant-type:token-exchange",
        subject_token: subject_token,
        subject_token_type: subject_token_type
      }))
    end

    def jwks
      to_api_response(request(method: :get, path: "/.well-known/jwks.json", auth: :none))
    end
  end
end
