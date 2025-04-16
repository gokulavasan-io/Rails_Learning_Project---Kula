class Api::V1::UsersController < ApplicationController
  def index
    users = User.all
    render json: serialize_user(users)
  end

  def create
    user = User.new(user_params)
    if user.save
      token = JsonWebToken.encode(user_id: user.id)
      render json: { user: user, token: token }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    user = User.find(params[:id])
    render json: serialize_user(user)
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'User not found' }, status: :not_found
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end

  def serialize_user(user)
    user.as_json(only: [:id, :name, :email])
  end

end
