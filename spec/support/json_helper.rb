# frozen_string_literal: true

module JsonHelper
  def json_response_body
    JSON.parse(response.body)
  end
end
