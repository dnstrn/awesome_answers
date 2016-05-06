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

  has_many :votes, dependent: :destroy
  has_many :voted_questions, through: :votes, source: :question

  has_many :likes, dependent: :destroy
  # We're using 'source' option in here because we used 'liked_questions' instead of 'questions' (convention) because we used 'has_many :questions' earlier.
  # Inside the 'like' model there is no association called 'liked_question' so we have to specify the source for Rails to know how to match it.
  has_many :liked_questions, through: :likes, source: :question

  # attr_accessor :abc

  validates :first_name, presence: true
  validates :last_name, presence: true

  VALID_EMAIL_REGEX = /\A([\w+\-]\.?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  validates :email, uniqueness: true, presence: true, format: VALID_EMAIL_REGEX

  def full_name
    "#{first_name} #{last_name}"
  end

  def generate_password_reset_data
    generate_password_reset_token
    self.password_reset_requested_at = Time.now
    save
  end

  def password_reset_expired?
    password_reset_requested_at <= 60.minutes.ago
  end

  private

  def generate_password_reset_token
    begin
      self.password_reset_token = SecureRandom.hex(32)
    end while User.exists?(password_reset_token: self.password_reset_token)
  end
end
