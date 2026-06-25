# frozen_string_literal: true

module AnswerLayer
  class SemanticResource < Resource
    def components(component:, connection_id:)
      to_api_response(request(method: :get, path: "/semantic/#{component}", params: { connection_id: connection_id }))
    end

    def jobs
      to_api_response(request(method: :get, path: "/semantic/jobs"))
    end

    def create_component(component:, attributes:)
      to_api_response(request(method: :post, path: "/semantic/#{component}", body: attributes))
    end

    def get_component(component:, id:)
      to_api_response(request(method: :get, path: "/semantic/#{component}/#{id}"))
    end

    def update_component(component:, id:, attributes:)
      to_api_response(request(method: :put, path: "/semantic/#{component}/#{id}", body: attributes))
    end

    def delete_component(component:, id:)
      request(method: :delete, path: "/semantic/#{component}/#{id}")
    end

    def generate_stream(component:, connection_id:, prompt: nil)
      request(method: :post, path: "/semantic/#{component}/generate/stream", body: compact(connection_id: connection_id, prompt: prompt))
    end

    def create_job(connection_id:, component_type:, prompt: nil)
      to_api_response(request(method: :post, path: "/semantic/jobs", body: compact(connection_id: connection_id, component_type: component_type, prompt: prompt)))
    end

    def job_stream(job_id:)
      request(method: :get, path: "/semantic/jobs/#{job_id}/stream")
    end

    def job_questions(job_id:)
      to_api_response(request(method: :get, path: "/semantic/jobs/#{job_id}/questions"))
    end

    def submit_guidance(job_id:, responses:)
      to_api_response(request(method: :post, path: "/semantic/jobs/#{job_id}/guidance", body: { responses: responses }))
    end

    def job_status(job_id:)
      to_api_response(request(method: :get, path: "/semantic/jobs/#{job_id}/status"))
    end

    def cancel_job(job_id:)
      to_api_response(request(method: :post, path: "/semantic/jobs/#{job_id}/cancel"))
    end
  end
end
