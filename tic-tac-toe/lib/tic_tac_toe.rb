# A game of tic-tac-toe, with a square board of any size and the option for AI players
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
    request_new_game
  end

  private

  def create_game
    # @cli.choose do |menu|
    #   menu.layout = :one_line
    #   menu.prompt = 'What size would you like your board to be? '
    #   menu.choices('3', '5', '7', '9')
    # end

    # Game.new(answer.to_i)

    # This line is for testing
    Game.new(3)
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
        menu.header = 'Here are the available AIs:'
        menu.prompt = 'Which AI will play this game?'
        menu.choices(:stupid)
      end
    end

    Player.new symbol, name, type
  end

  def next_player
    @current_player == @player_x ? @player_o : @player_x
  end

  def get_player_move
    if @current_player.type == :human
      @cli.ask("#{@current_player.name}: What position would you like to claim?", Integer)
    else
      @current_player.ai_move(@current_player.name, @game.board)
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
        "You've chosen well. #{next_player.name}'s turn."
      else
        "#{@current_player.name} has played. #{next_player.name}'s turn."
      end
    when :win
      @game_over = true
      if @current_player.type == :human
        "Game over. #{@current_player.name} wins. High fives all around. Final board:"
      else
        "Game over. #{@current_player.name} wins. Bow to your robot overlords. Final board:"
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
