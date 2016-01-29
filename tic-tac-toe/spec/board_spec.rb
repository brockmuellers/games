require_relative '../lib/tic_tac_toe/board'

describe 'Board' do
  subject(:board) { Board.new(3) }
  before { board.state = ['X', 'X', nil, nil, 'O', nil, 'O', nil, 'O'] }

  describe '#initialize' do
    it 'creates state array of correct size' do
      expect(Board.new(3).state).to eq(Array.new(9, nil))
    end
  end

  describe '#display' do
    it 'should be a readable board with current state' do
      expect(subject.display).to match(/|-3- OOO -5-|/)
    end
  end

  describe '#empty_positions' do
    it 'should be list of nil indices in state' do
      expect(subject.empty_positions).to eq([2, 3, 5, 7])
    end
  end

  describe '#player_positions' do
    context 'for player x' do
      it "should be list of positions with player's symbol" do
        expect(subject.player_positions('X')).to eq([0, 1])
      end
    end

    context 'for player o' do
      it "should be list of positions with player's symbol" do
        expect(subject.player_positions('O')).to eq([4, 6, 8])
      end
    end
  end

  describe '#player_wins?' do
    before { board.state[2] = 'X' }

    context 'when player has not won' do
      it 'should be false' do
        expect(subject.player_wins?('O')).to be false
      end
    end

    context 'when player has won' do
      it 'should be true' do
        expect(subject.player_wins?('X')).to be true
      end
    end
  end

  describe '#winning_positions' do
    it 'should be list of sets of winning indices' do
      expected = [[0, 1, 2], [0, 3, 6],
        [0, 4, 8], [1, 4, 7], [2, 4, 6],
        [2, 5, 8], [3, 4, 5], [6, 7, 8]]

      expect(subject.winning_positions).to match_array(expected)
    end
  end
end
