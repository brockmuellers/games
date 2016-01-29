# Stores methods and logic for tic-tac-toe gameplay
class Game
  attr_reader :board

  def initialize(size)
    @board = Board.new(size)
  end

  def move(position, player)
    if position_available?(position)
      @board.state[position] = player.symbol
      game_over?(player) || :success
    else
      :invalid_position
    end
  end

  private

  def game_over?(player)
    if @board.player_wins?(player.symbol)
      :win
    elsif !@board.state.include?(nil)
      :draw
    end
  end

  # checks if position is on the board and is nil
  def position_available?(position)
    (position < @board.state.length) && @board.state[position].nil?
  end
end
