class ApplicationController < ActionController::API
  before_action :authorize_request

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_record

  private

  def authorize_request
    header = request.headers["Authorization"]
    unless header
      render json: { error: "Unauthorized" }, status: :unauthorized and return
    end
    token = header.split.last if header
    decoded = JsonWebToken.decode(token)
    unless decoded
      render json: { error: "Unauthorized" }, status: :unauthorized and return
    end
    @current_user = User.find(decoded[:user_id]) if decoded
  rescue ActiveRecord::RecordNotFound, JWT::DecodeError
    render json: { error: "Unauthorized" }, status: :unauthorized and return
  end

  def record_not_found(error)
    render json: { notfounderror: error.message }, status: :not_found
  end

  def unprocessable_record(exception)
    render json: { errors: exception.record.errors.full_messages }, status: :unprocessable_entity
  end

end
