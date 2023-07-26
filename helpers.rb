# Helper method to check if user is logged in
def logged_in?
    !session[:user_id].nil?
  end