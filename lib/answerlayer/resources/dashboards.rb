# frozen_string_literal: true

module AnswerLayer
  class DashboardsResource < Resource
    def manifest(dashboard_id:)
      request(method: :get, path: "/dashboards/#{dashboard_id}/manifest", subject: true)
    end

    def tile_data(dashboard_id:, tile_id:, filters: nil, params: nil, pagination: nil, result_handle: nil)
      to_result_envelope(request(method: :post, path: "/dashboards/#{dashboard_id}/tiles/#{tile_id}/data", body: compact(filters: filters, params: params, pagination: pagination, result_handle: result_handle), subject: true))
    end

    def parameters(dashboard_id:, tile_id:)
      to_api_response(request(method: :get, path: "/dashboards/#{dashboard_id}/tiles/#{tile_id}/parameters", subject: true))
    end

    def update_parameters(dashboard_id:, tile_id:, values:, subject_org_id: nil)
      headers = subject_org_id ? { "X-Subject-Org-ID" => subject_org_id } : {}
      to_api_response(request(method: :put, path: "/dashboards/#{dashboard_id}/tiles/#{tile_id}/parameters", body: { values: values }, headers: headers, subject: true))
    end
  end
end
