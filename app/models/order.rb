class Order < ApplicationRecord
  belongs_to :user

  def user_name
      user.name
  end
  
  def date
    created_at.strftime('%Y-%m-%d')
  end

end
