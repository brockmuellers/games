# Stores state of the board in a flat array, displays board, and checks for wins.
# For a 3x3 board, the array indices would correspond to these positions:
# =========
# | 0 1 2 |
# | 3 4 5 |
# | 6 7 8 |
# =========
# For example, the board
# =============
# |XXX XXX -2-|
# |           |
# |-3- OOO -5-|
# |           |
# |OOO -7- -8-|
# =============
# would have @state = ['X', 'X', nil, nil, 'O', nil, 'O', nil, 'O']
# TODO: look into other ways of representing and displaying board:
#   current array iterations, conversions to/from multimensional array etc. are unreadable

class Board
  attr_accessor :state

  def initialize(size)
    @size = size
    @state = Array.new(@size**2, nil)
    @winning_positions = winning_positions
  end

  def display
    table = multidimensional_state(printable_state)
    row_length = 4*@size + 1
    border = '=' * row_length

    display = String.new(border)

    table.each do |row|
      display << "\n|" + row.join(' ') + "|\n"
      display << "|#{' '*(row_length - 2)}|"
    end

    display[0..-(row_length+2)] + "\n" + border
  end

  def empty_positions
    @state.map.with_index { |e, i| e.nil? ? i : nil }.compact
  end

  def player_positions(symbol)
    @state.map.with_index { |e, i| (e == symbol) ? i : nil }.compact
  end

  def player_wins?(symbol)
    @winning_positions.any? { |a| (a & player_positions(symbol)).length == @size }
  end

  # Array of winning positions. For a 3 x 3 board, this would return:
  # [[0, 4, 8], [2, 4, 6], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 1, 2], [3, 4, 5], [6, 7, 8]]
  def winning_positions
    range = (0..(@size-1)).to_a

    diagonal_down = [range.map { |i| i*@size + i }]
    diagonal_up = [range.map { |i| (i+1)*(@size-1) }]

    verticals = range.map do |i|
      range.map { |j| i + j*@size }
    end

    horizontals = range.map { |i| Array(i*@size..((i+1)*@size)-1) }

    diagonal_down + diagonal_up + verticals + horizontals
  end

  private

  # Returns state to be displayed (each array element is something like '-1-', '16-', '256', 'XXX')
  def printable_state
    number_length = (@size**2).to_s.length # find max number of digits required (1, 2, or 3)

    @state.map.with_index do |e, i|
      if e
        e*3
      elsif number_length == 1
        "-#{i}-"
      elsif number_length == 2
        sprintf('%02d-', i) # add leading zeros
      else
        sprintf('%03d', i) # add leading zeros
      end
    end
  end

  def multidimensional_state(ary)
    (0..(@size-1)).map do |y|
      start = 0 + @size*y
      finish = (@size-1) + @size*y
      ary[start..finish]
    end
  end
end
