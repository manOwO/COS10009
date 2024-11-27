require 'rubygems'
require 'gosu'

BACGROUND_COLOR = Gosu::Color.argb(0xff_808080)
BOX_DIM = 50
WIDTH_WINDOW = 800
HEIGHT_WINDOW = 600



class Box 
    attr_accessor :box, :clicked, :mark

    def initialize(box, clicked, mark)
        @box = box
        @clicked = clicked
        @mark = mark 
    end
end

class User 
    attr_accessor :username, :bomb_left, :time 

    def initialize(username, bomb_left, time)
        @username = username
        @bomb_left = bomb_left
        @time = time
    end
end

module Mark
    NOTBOMB, BOMB = 0, 1
end

module Button 
    GAME, PLAY, PAUSE, RESET, SOUND = *1..5
end

module ZOrder
    BACKGROUND, MAINGAME, SCOREBOARD, START = *0..3
end

class MinesweeperMain < Gosu::Window
    def initialize
        super WIDTH_WINDOW, HEIGHT_WINDOW, false
        self.caption = "Minesweeper" 

        @board = []
        @bombnum = 10
        create_board(@bombnum)
        
        for r in (0..8)
            for c in (0..8)
                print @board[r][c].box.to_s + " "
            end
            print "\n"
        end
        puts ""
        for r in (0..8)
            for c in (0..8)
                print @board[r][c].mark.to_s + " "
            end
            print "\n"
        end
    end

    def create_board(bombnum)
        # random bomb
        bomb_exist = 0

        random_bomb = []
        i = 0
        while i < 9*9 
            if bomb_exist < @bombnum
                random_bomb << 1
                bomb_exist += 1
            else
                random_bomb << 0
            end
            i += 1
        end
        random_bomb.shuffle! 
        
        i =  0
        while i <= 81
            for r in (0..8)
                row = []
                for c in (0..8)
                    if random_bomb[i] == 1 
                        bomb = Box.new(0, false, Mark::BOMB)
                        row << bomb
                        bomb_exist += 1
                    elsif random_bomb[i] == 0
                        notbomb = Box.new(0, false, Mark::NOTBOMB)
                        row << notbomb 
                    end
                    i += 1
                end
                @board << row
            end
        end

        # count adjacent bomb
        for r in (0..8)
            for c in (0..8)
                
                # puts @board[r][c]
                if @board[r][c].mark == Mark::BOMB 
                    @board[r][c].box = 0
                    if r > 0
                        if c > 0
                            @board[r-1][c-1].box += 1
                        end
                        @board[r-1][c].box += 1
                        if c < 8
                            @board[r-1][c+1].box += 1
                        end
                    end
                    if c > 0
                        @board[r][c-1].box += 1
                    end
                    if c < 8
                        @board[r][c+1].box += 1
                    end
                    if r < 8
                        if c > 0
                            @board[r+1][c-1].box += 1
                        end
                        @board[r+1][c].box += 1
                        if c < 8
                            @board[r+1][c+1].box += 1
                        end 
                    end
                end 
            end
        end
    end
    
    def update
	end

    def needs_cursor?
        true
    end

    def draw_bg
        draw_quad(0, 0, BACGROUND_COLOR, WIDTH_WINDOW, 0, BACGROUND_COLOR, 0, HEIGHT_WINDOW, BACGROUND_COLOR, WIDTH_WINDOW, HEIGHT_WINDOW, BACGROUND_COLOR, ZOrder::BACKGROUND)
    end

    def draw
       draw_bg
    end
end

MinesweeperMain.new.show if __FILE__ == $0