# Stores player info and AI move logic
class Player
  AI_NAMES = %w(edgar minnie speedy)

  attr_reader :type, :symbol, :name

  def initialize(symbol, name, type)
    @symbol = symbol
    @type = type.to_sym
    @name = name
  end

  def ai_move(board)
    send "#{@name}_move", board
  end

  def capitalized_name
    @name.capitalize
  end

  private

  # AI player 'edgar' uses the negamax algorithm
  # build tree with current state of game, then state after my move, after opponents, etc to final state
  def edgar_move(board)
  end

  # AI player 'minnie' uses the minimax algorithm
  def minnie_move(board)
  end

  # AI player 'speedy' randomly choose an available position
  def speedy_move(board)
    board.empty_positions.sample
  end

  ### Helper Methods ###

  def edgar_build_tree
  end
end

class Node
  def initialize(state, parent, children)
    @state = state
    @parent = parent
    @children = children #necessary?
  end
end
