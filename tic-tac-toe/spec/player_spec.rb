require_relative '../lib/tic_tac_toe/player'

describe 'Player' do
  describe '#ai_move' do
    before do
      @board = double('Board', empty_positions: [2, 3, 5, 7])
    end


    context 'for AI player stupid' do
      subject(:move) { Player.new('X', 'stupid', 'ai').ai_move(@board) }

      it 'should select a random empty position' do
        expect(@board.empty_positions).to include(subject)
      end
    end
  end
end
