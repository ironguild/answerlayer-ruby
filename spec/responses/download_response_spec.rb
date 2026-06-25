# frozen_string_literal: true

require_relative "../spec_helper"

RSpec.describe AnswerLayer::DownloadResponse do
  it "stores download body and metadata" do
    response = described_class.new(
      body: "id,name\n1,Ada\n",
      content_type: "text/csv",
      filename: "export.csv",
      status: 200,
      headers: { "content-disposition" => [ 'attachment; filename="export.csv"' ] }
    )

    expect(response.body).to eq("id,name\n1,Ada\n")
    expect(response.content_type).to eq("text/csv")
    expect(response.filename).to eq("export.csv")
    expect(response.status).to eq(200)
    expect(response.headers).to eq("content-disposition" => [ 'attachment; filename="export.csv"' ])
  end
end
