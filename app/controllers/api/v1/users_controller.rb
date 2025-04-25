class Api::V1::UsersController < ApplicationController
  skip_before_action :authorize_request, only: [ :create ]
  before_action :set_user, only: [ :show ]

  def index
    users = User.all
    render json: serialize_user(users)
  end

  def create
    user = User.new(user_params)
    user.save!
    token = JsonWebToken.encode(user_id: user.id)
    render json: { user: user, token: token }, status: :created
  end

  def show
    render json: serialize_user(@user), status: :ok
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end

  def serialize_user(user)
    user.as_json(only: [ :id, :name, :email ])
  end
end
