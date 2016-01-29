require_relative '../lib/tic_tac_toe/game'

describe 'Game' do
  describe '#initialize' do
    subject(:board_state) { Game.new(3).board.state }

    it 'creates a board of the correct size' do
      expect(subject).to eq(Array.new(9, nil))
    end
  end

  describe '#move' do
    let(:game) { Game.new(3) }
    let(:player) { Player.new('X', 'Sara', 'human') }
    before { game.board.state = ['X', 'X', nil, nil, 'O', nil, 'O', nil, 'O']}

    context 'when an available position is provided' do
      context 'when it results in the game ending' do
        context 'and the game is won' do
          before do
            @result = game.move(2, player)
          end

          it "sets the position on the board to the player's symbol" do
            expect(game.board.state[2]).to eq('X')
          end

          it 'returns win' do
            expect(@result).to eq(:win)
          end
        end

        context 'and the game is a draw' do
          before do
            game.board.state = ['X', 'X', 'O', 'O', 'X', 'X', nil, 'O', 'O']
            @result = game.move(6, player)
          end

          it "sets the position on the board to the player's symbol" do
            expect(game.board.state[6]).to eq('X')
          end

          it 'returns draw' do
            expect(@result).to eq(:draw)
          end
        end
      end

      context 'when it does not result in a win' do
        before do
          @result = game.move(3, player)
        end

        it "sets the position on the board to the player's symbol" do
          expect(game.board.state[3]).to eq('X')
        end

        it 'returns success' do
          expect(@result).to eq(:success)
        end
      end
    end

    context 'when an unavailable position is provided' do
      before do
        @result = game.move(0, player)
      end

      it 'returns invalid_position' do
        expect(@result).to eq(:invalid_position)
      end
    end

    context 'when an position that is not on the board is provided' do
      before do
        @result = game.move(9, player)
      end

      it 'returns invalid_position' do
        expect(@result).to eq(:invalid_position)
      end
    end
  end
end
