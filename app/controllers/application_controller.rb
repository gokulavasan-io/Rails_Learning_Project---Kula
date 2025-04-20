class ApplicationController < ActionController::API
  before_action :authorize_request

  private

  def authorize_request
    header = request.headers['Authorization']
    if !header
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
    token = header.split.last if header
    decoded = JsonWebToken.decode(token)
    @current_user = User.find(decoded[:user_id]) if decoded
  rescue ActiveRecord::RecordNotFound, JWT::DecodeError
    render json: { error: 'Unauthorized' }, status: :unauthorized
  end
end
