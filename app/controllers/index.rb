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
      @login_error = "Incorrect password for this user: so are you co-opting these wings?"
      erb :login_form
    end
  else
    @login_error = "User does not exist: Hankaconda strikes again!"
    erb :login_form
  end
end

post '/signup' do
  @user = User.create(username: params[:username], password: params[:password])
  if @user.valid?
    if @user.username == "henry" || @user.username == "Henry"
      session[:user_id] = @user.id
      erb :rickroll
    else
      session[:user_id] = @user.id
      redirect ('/')
    end
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
    @message = "You're stupid! The answer was, #{@answer}. Idiot. Try this new question:"
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
  @cards = @deck.cards.all
  erb :game
end

get '/createdeck' do
  @user = User.find(session[:user_id])
  erb :createdeck
end  

post '/createdeck' do
  @deck = Deck.find_or_create_by_deckname(params[:deckname])
  if @deck.valid?
    @card = Card.create(question: params[:question], answer: params[:answer], deck_id: @deck.id)
    if @card.valid?
      if params[:deck_action] == "Create another"
        erb :createdeck
      else
        redirect '/'
      end
    else
      @deck_error = "Invalid card: Vanilla Thrilla"
      erb :createdeck
    end
  else
    @deck_error = "Invalid deck: Reagan administration"
    erb :createdeck
  end
end

get '/deletedeck/:id' do
  Deck.destroy(params[:id])    
  redirect to '/'
end

get '/editdeck/:id' do
  @deck = Deck.find(params[:id])
  erb :editdeck
end

post '/editdeck/:id' do
  puts params
  @deck = Deck.find(params[:id])
  @deck.update_attributes(deckname: params[:deckname])
  @cards = @deck.cards.all
  @count = 1
  @cards.each do |card|
    # puts "QUESTION: question#{(@count)}"
    # puts "ANSWER: answer#{(@count)}"
    # puts "--------------------------------"
    card.update_attributes(:question => params["question#{(@count)}"], :answer => params["answer#{(@count)}"])
    @count += 1
  end
  redirect '/'
end





