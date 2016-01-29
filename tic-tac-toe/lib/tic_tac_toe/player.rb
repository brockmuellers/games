# Stores player info and AI move logic

class Player
  AI_NAMES = %w(stupid)

  attr_reader :type, :symbol, :name

  def initialize(symbol, name, type)
    @symbol = symbol
    @type = type.to_sym
    @name = name
  end

  def ai_move(board)
    send "#{@name}_move", board
  end

  private

  # AI player 'stupid' randomly choose an available position
  def stupid_move(board)
    board.empty_positions.sample
  end
end
