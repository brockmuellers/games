# A game of tic-tac-toe, with a square board of any size and the option for AI players
# TODO: more idiomatic to move most logic into Game class
#   (can any HighLine interactions be moved? maybe a good use of metaprogramming)
require 'highline'
require_relative './tic_tac_toe/board'
require_relative './tic_tac_toe/game'
require_relative './tic_tac_toe/player'

class TicTacToe
  def initialize
    @cli = HighLine.new
  end

  def play_game
    @game = create_game
    @game_over = false

    @player_x = create_player('X')
    @player_o = create_player('O')
    @current_player = @player_x

    game_start = Time.now
    print_board

    while !@game_over
      move = get_player_move.to_i
      response = @game.move(move, @current_player)

      puts provide_response(response)

      if response == :success
        @current_player = next_player
        print_board
      end
    end

    print_board
    puts "Your game lasted #{Time.now - game_start} seconds."

    request_new_game
  end

  private

  def create_game
    answer = @cli.choose do |menu|
      menu.layout = :one_line
      menu.select_by = :index
      menu.prompt = 'What size would you like your board to be? (1 to 31)  '
      choices = (1..31).to_a.map { |e| "#{ e}" } # obnoxiously, highline doesn't like plain ints as choices
      menu.choices(*choices)
    end

    Game.new(answer.to_i)
  end

  def create_player(symbol)
    type = @cli.choose do |menu|
      menu.layout = :one_line
      menu.prompt = "What sort of entity is player #{symbol}? "
      menu.choices(:human, :ai)
    end

    if type == :human
      name = @cli.ask("What is the human's name?")
    else
      name = @cli.choose do |menu|
        menu.header = 'Here are the available AIs'
        menu.prompt = 'Which AI will play this game?'
        menu.choices(*Player::AI_NAMES)
      end
    end

    Player.new symbol, name, type
  end

  def next_player
    @current_player == @player_x ? @player_o : @player_x
  end

  def get_player_move
    if @current_player.type == :human
      @cli.ask("#{@current_player.capitalized_name}: What position would you like to claim?", Integer)
    else
      @current_player.ai_move(@game.board)
    end
  end

  def print_board
    puts @game.board.display
  end

  def provide_response(response)
    case response
    when :invalid_position
      'That position is not available. Please select another.'
    when :success
      if @current_player.type == :human
        "You've chosen well. #{next_player.capitalized_name}'s turn."
      else
        "#{@current_player.capitalized_name} has played. #{next_player.capitalized_name}'s turn."
      end
    when :win
      @game_over = true
      if @current_player.type == :human
        "Game over. #{@current_player.capitalized_name} wins. High fives all around. Final board:"
      else
        "Game over. #{@current_player.capitalized_name} wins. Bow to your robot overlords. Final board:"
      end
    when :draw
      @game_over = true
      'No winners today. Game over. Final board:'
    end
  end

  def request_new_game
    if @cli.ask("Play another game? [y n]") == 'y'
      play_game
    end
  end
end

TicTacToe.new.play_game
