class User < ApplicationRecord
  has_secure_password

  has_many :tasks, dependent: :destroy

  validates :email, presence:true, uniqueness: {case_sensitivity: false}, format: {with: URI::MailTo::EMAIL_REGEXP}
end
