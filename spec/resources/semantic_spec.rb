# frozen_string_literal: true

require_relative "../spec_helper"

RSpec.describe AnswerLayer::SemanticResource do
  it "routes semantic requests and returns ApiResponse objects for flexible responses" do
    client = resource_client_with({ "jobs" => [], "total" => 0, "has_more" => false })

    expect(client.semantic.components(component: "entities", connection_id: "conn_1")).to be_a(AnswerLayer::ApiResponse)
    expect(client.semantic.jobs).to be_a(AnswerLayer::ApiResponse)
    client.semantic.create_component(component: "entities", attributes: { name: "Customer" })
    client.semantic.get_component(component: "entities", id: "entity_1")
    client.semantic.update_component(component: "entities", id: "entity_1", attributes: { name: "Account" })
    client.semantic.delete_component(component: "entities", id: "entity_1")
    client.semantic.generate_stream(component: "entities", connection_id: "conn_1")
    client.semantic.create_job(connection_id: "conn_1", component_type: "entities")
    client.semantic.job_stream(job_id: "job_1")
    client.semantic.job_questions(job_id: "job_1")
    client.semantic.submit_guidance(job_id: "job_1", responses: [])
    client.semantic.job_status(job_id: "job_1")
    client.semantic.cancel_job(job_id: "job_1")

    expect_routes(
      { method: :get, path: "/semantic/entities" },
      { method: :get, path: "/semantic/jobs" },
      { method: :post, path: "/semantic/entities" },
      { method: :get, path: "/semantic/entities/entity_1" },
      { method: :put, path: "/semantic/entities/entity_1" },
      { method: :delete, path: "/semantic/entities/entity_1" },
      { method: :post, path: "/semantic/entities/generate/stream" },
      { method: :post, path: "/semantic/jobs" },
      { method: :get, path: "/semantic/jobs/job_1/stream" },
      { method: :get, path: "/semantic/jobs/job_1/questions" },
      { method: :post, path: "/semantic/jobs/job_1/guidance" },
      { method: :get, path: "/semantic/jobs/job_1/status" },
      { method: :post, path: "/semantic/jobs/job_1/cancel" }
    )
  end

  it "returns an ApiResponse for the captured semantic components list response" do
    client = resource_client_with(fixture("semantic/components-list"))

    response = client.semantic.components(component: "entities", connection_id: "conn_1")

    expect(response).to be_a(AnswerLayer::ApiResponse)
    expect(response.to_h).to be_a(Hash)
  end

  it "returns an ApiResponse for the captured semantic jobs list response" do
    client = resource_client_with(fixture("semantic/jobs-list"))

    response = client.semantic.jobs

    expect(response).to be_a(AnswerLayer::ApiResponse)
    expect(response["jobs"]).to be_an(Array)
    expect(response["jobs"]).not_to be_empty
    expect(response["jobs"]).to all(be_a(Hash))

    job = response["jobs"].first
    expect(job).to include("id", "connection_id", "component_type", "status")
    expect(job["id"]).to be_a(String)
    expect(job["id"]).not_to be_empty
  end

  it "returns an ApiResponse for a captured semantic component create response" do
    skip "client.semantic.create_component -> POST /semantic/:component is blocked until a live API response fixture is created; fixture capture currently lacks a safe semantic create fixture."
  end

  it "returns an ApiResponse for a captured semantic component read response" do
    skip "client.semantic.get_component -> GET /semantic/:component/:id is blocked until a live API response fixture is created; fixture capture currently lacks a semantic component ID."
  end

  it "returns an ApiResponse for a captured semantic component update response" do
    skip "client.semantic.update_component -> PUT /semantic/:component/:id is blocked until a live API response fixture is created; fixture capture currently lacks a safe semantic update fixture."
  end

  it "returns nil for the captured semantic component delete response" do
    skip "client.semantic.delete_component -> DELETE /semantic/:component/:id is blocked until a live API response fixture is created; fixture capture currently lacks a guarded semantic delete component ID."
  end

  it "returns stream events for captured semantic generation" do
    skip "client.semantic.generate_stream -> POST /semantic/:component/generate/stream is blocked until a live API response fixture is created; fixture capture may create costly or mutating AI work and requires approval."
  end

  it "returns an ApiResponse for a captured semantic job create response" do
    skip "client.semantic.create_job -> POST /semantic/jobs is blocked until a live API response fixture is created; fixture capture may create costly or mutating AI work and requires approval."
  end

  it "returns stream events for a captured semantic job stream" do
    skip "client.semantic.job_stream -> GET /semantic/jobs/:job_id/stream is blocked until a live API response fixture is created; fixture capture currently lacks a semantic job ID."
  end

  it "returns an ApiResponse for captured semantic job questions" do
    skip "client.semantic.job_questions -> GET /semantic/jobs/:job_id/questions is blocked until a live API response fixture is created; fixture capture currently lacks a semantic job ID."
  end

  it "returns an ApiResponse for a captured semantic job guidance response" do
    skip "client.semantic.submit_guidance -> POST /semantic/jobs/:job_id/guidance is blocked until a live API response fixture is created; fixture capture currently lacks a semantic job ID and guidance fixture."
  end

  it "returns an ApiResponse for a captured semantic job status response" do
    skip "client.semantic.job_status -> GET /semantic/jobs/:job_id/status is blocked until a live API response fixture is created; fixture capture currently lacks a semantic job ID."
  end

  it "returns an ApiResponse for a captured semantic job cancel response" do
    skip "client.semantic.cancel_job -> POST /semantic/jobs/:job_id/cancel is blocked until a live API response fixture is created; fixture capture currently lacks a semantic job ID."
  end
end
