class User < ActiveRecord::Base
  # has_secure_password does the following:
  # 1) it adds attribute accessors: password and password_confirmation
  # 2) it adds validation: password must be present on creation
  # 3) if password confirmation is present, it will make sure it's equal to pw
  # 4) password length should be less than or equal to 72 characters
  # 5) it will hash the password using BCrypt and stores the hash digest in the password_digest field
  has_secure_password

  has_many :questions, dependent: :nullify
  has_many :answers,   dependent: :nullify

  # attr_accessor :abc

  validates :first_name, presence: true
  validates :last_name, presence: true

  VALID_EMAIL_REGEX = /\A([\w+\-]\.?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  validates :email, uniqueness: true, presence: true, format: VALID_EMAIL_REGEX

  def full_name
    "#{first_name} #{last_name}"
  end

end
