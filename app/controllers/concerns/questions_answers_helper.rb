module QuestionsAnswersHelper
  # or "Concern" instead of "Helper" to avoid confusion
  extend ActiveSupport::Concern

  def user_like
    @user_like ||= @question.like_for(current_user)
  end

end

# might have been better to use helper method in this case but this is just an example
