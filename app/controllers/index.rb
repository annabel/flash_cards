enable :sessions


get '/' do
  if session[:user_id]
    @user = User.find(session[:user_id])
    @deck = Deck.all
    @results = @user.rounds
    erb :welcome
  else
    erb :login_form
  end
end 

get ('/logout') do
  session.clear
  redirect to('/')
end

post '/login' do
  @user = User.find_by_username(params[:username])
  if @user
    if @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect to ('/')
    else
      @login_error = "Incorrect password for this user"
      erb :login_form
    end
  else
    @login_error = "User does not exist"
    erb :login_form
  end
end

post '/signup' do
  @user = User.create(username: params[:username], password: params[:password])
  if @user.valid?
    # if @user.username == "henry" || "Henry"
    #   erb :rickroll
    # else
      session[:user_id] = @user.id
      redirect ('/')
    # end
  else
    @signup_error = "User name already exists"
    erb :login_form
  end  
end

post '/check_answer' do
  @answer = params[:answer].to_s.downcase
  @round_id = params[:round_id]
  @round = Round.find(@round_id)
  @user_answer = params[:user_answer].to_s.downcase
  if @answer == @user_answer 
    Guess.create(round_id: @round_id, correct: 1)
    @message = "Correct!"
  else
    Guess.create(round_id: @round_id, correct: 0)
    @message = "You're stupid! The answer was #{@answer}. Idiot. Try this new question:"
  end
  @count = params[:count].to_i
  if @count >= @round.deck.cards.length
    redirect to('/')
  else
  @cards = @round.deck.cards.all
  @deck = @round.deck
  erb :game
  end
end

get '/game/:deck_id' do
  @count = 0 
  @deck = Deck.find(params[:deck_id])
  @user = User.find(session[:user_id])
  @round = Round.create(deck_id: @deck.id, user_id: @user.id)
  @cards = @deck.cards
  erb :game
end
