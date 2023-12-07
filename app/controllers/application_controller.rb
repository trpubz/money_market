class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response

  def not_found_response(exception)
    render json: ErrorSerializer.new(exception).serialize_json,
           status: 404
  end
end
