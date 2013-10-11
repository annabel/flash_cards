enable :sessions


get '/' do
  if session[:user_id]
    @user = User.find(session[:user_id])
    @deck = Deck.all
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
    session[:user_id] = @user.id
    redirect ('/')
  else
    @signup_error = "User name already exists"
    erb :login_form
  end  
end

post '/check_answer' do
  @answer = params[:answer]
  @round_id = params[:round_id]
  @round = Round.find(@round_id)
  @user_answer = params[:user_answer]
  if @answer.to_s == @user_answer 
    Guess.create(round_id: @round_id, correct: 1)
  else
    Guess.create(round_id: @round_id, correct: 0)
  end
  @count = params[:count].to_i
  if @count >= @round.deck.cards.length
    redirect to('/')
  else
  @cards = @round.deck.cards.all
  erb :game
  end
end

get '/game/:deck_id' do
  @count = 0 
  @deck = Deck.find(params[:deck_id])
  @user = User.find(session[:user_id])
  @round = Round.create(deck_id: @deck.id, user_id: 1)
  @cards = @deck.cards
  erb :game
end
