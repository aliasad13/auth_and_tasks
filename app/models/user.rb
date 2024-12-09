class User < ApplicationRecord
  has_secured_password

  has_many :tasks
end
