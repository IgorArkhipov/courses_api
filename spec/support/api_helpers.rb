# frozen_string_literal: true

module ApiHelpers
  def json_parsed
    JSON.parse(response.body, symbolize_names: true)
  end
end
