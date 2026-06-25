# frozen_string_literal: true

module AnswerLayer
  class ResultEnvelope < ApiResponse
    def columns
      self["columns"] || []
    end

    def rows
      self["rows"] || []
    end

    def next_cursor
      self["next_cursor"]
    end

    def result_handle
      self["result_handle"]
    end

    def has_next_page?
      !next_cursor.nil? && !next_cursor.to_s.empty?
    end
  end
end
