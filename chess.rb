require 'gosu'
module ZOrder
    BACKGROUND, PLAYER, UI = *0..2
end

## What left has to be done: Checkmate, stalemate function, en passant. 50 move draw. 


def position_on_screen(x,y)
    if x >=0 && y>=0
        screen_x = 200+ 50*x
        screen_y = 100+ 50*y
        return screen_x,screen_y
    end
    return nil
end

def can_block_rook_check(x,y,color_not_played)
    if check_king_moves(@cell_x_check,@cell_y_check,x,y)
        return false
    end

    if @cell_x_check== x && @cell_y_check>y
        i=0
        while @cell_y_check-i> y
            if square_not_safe(@cell_x_check, @cell_y_check-i,color_not_played)
                return true
            end
            i = i+1
        end
    end
    if @cell_x_check== x && @cell_y_check<y
        i=0
        while @cell_y_check+i< y
            if square_not_safe(@cell_x_check, @cell_y_check+i,color_not_played)
                return true
            end
            i = i+1
        end
    end
    if @cell_x_check< x && @cell_y_check==y
        i=0
        while @cell_x_check+i<x
            if square_not_safe(@cell_x_check+i, @cell_y_check,color_not_played)
                return true
            end
            i = i+1
        end
    end
    if @cell_x_check> x && @cell_y_check==y
        i=0
        while @cell_x_check-i> x
            if square_not_safe(@cell_x_check-i, @cell_y_check,color_not_played)
                return true
            end
            i = i+1
        end
    end

    return false
end

def can_block_bishop_check(x,y,color_not_played)
    if check_king_moves(@cell_x_check,@cell_y_check,x,y)
        return false
    end
    if @cell_x_check> x && @cell_y_check>y
        i=0
        while @cell_x_check-i> x
            if square_not_safe(@cell_x_check-i, @cell_y_check-i,color_not_played)
                return true
            end
            i = i+1
        end
    end
    if @cell_x_check> x && @cell_y_check<y
        i=0
        while @cell_x_check-i> x
            if square_not_safe(@cell_x_check-i, @cell_y_check+i,color_not_played)
                return true
            end
            i = i+1
        end
    end
    if @cell_x_check< x && @cell_y_check>y
        i=0
        while @cell_x_check+i<x
            if square_not_safe(@cell_x_check+i, @cell_y_check-i,color_not_played)
                return true
            end
            i = i+1
        end
    end
    if @cell_x_check< x && @cell_y_check<y
        i=0
        while @cell_x_check+i< x
            if square_not_safe(@cell_x_check+i, @cell_y_check+i,color_not_played)
                return true
            end
            i = i+1
        end
    end

    return false
end

def square_not_safe(x,y,color)
    for i in 0..7
        for j in 0..7
            if @board.cells[i][j].has_piece!= nil
                if @board.cells[i][j].has_piece.color !=color
                    if @board.cells[i][j].has_piece.type == "b" &&bishop_can_capture(i,j,x,y)
                        return true
                    end
                    if @board.cells[i][j].has_piece.type == "r" &&rook_can_capture(i,j,x,y)
                        return true
                    end
                    if @board.cells[i][j].has_piece.type == "q" &&queen_can_capture(i,j,x,y)
                        return true
                    end
                    if @board.cells[i][j].has_piece.type == "n" &&knight_can_capture(i,j,x,y)
                        return true
                    end
                    if @board.cells[i][j].has_piece.type == "p" &&check_pawn_moves(i,j,x,y)
                        return true
                    end

                end
            end
        end
    end
    return false

end



def checkmate(color)
    # Color is the color of the size being checked.
    if color == "b"
        color_not_played = "w"
    else
        color_not_played = "b"
    end
    if !king_not_in_check(color)
        x,y = find_king(color)
        if x<=6
            if @board.cells[x+1][y].has_piece == nil || @board.cells[x+1][y].has_piece.color != color
                if !square_not_safe(x+1,y,color)
                    return false
                end
            end
        end
        if x>0
            if @board.cells[x-1][y].has_piece == nil || @board.cells[x-1][y].has_piece.color != color
                if @board.cells[x-1][y] != nil
                    if !square_not_safe(x-1,y,color)
                        return false
                    end
                end
            end
        end
        if y<=6
            if @board.cells[x][y+1].has_piece == nil || @board.cells[x][y+1].has_piece.color != color
                if @board.cells[x][y+1] != nil
                    if !square_not_safe(x,y+1,color)
                        return false
                    end
                end
            end
        end
        if y>0
            if @board.cells[x][y-1].has_piece == nil || @board.cells[x][y-1].has_piece.color != color
                if @board.cells[x][y-1] != nil
                    if !square_not_safe(x,y-1,color)
                        return false

                    end
                end
            end
        end
        if x<=6 && y<=6
            if @board.cells[x+1][y+1].has_piece == nil || @board.cells[x+1][y+1].has_piece.color != color
                if @board.cells[x+1][y+1] != nil
                    if !square_not_safe(x+1,y+1,color)
                        return false

                    end
                end
            end
        end
        if x<=6 && y>0
            if @board.cells[x+1][y-1].has_piece == nil || @board.cells[x+1][y-1].has_piece.color != color
                if @board.cells[x+1][y-1] != nil
                    if !square_not_safe(x+1,y-1,color)
                        return false

                    end
                end
            end
        end
        if x>0 && y<=6
            if @board.cells[x-1][y+1].has_piece == nil || @board.cells[x-1][y+1].has_piece.color != color
                if @board.cells[x-1][y+1] != nil
                    if !square_not_safe(x-1,y+1,color)
                        return false
                    end
                end
            end
        end
        if x>0 && y>0
            if @board.cells[x-1][y-1].has_piece == nil || @board.cells[x-1][y-1].has_piece.color != color
                if @board.cells[x-1][y-1] != nil
                    if !square_not_safe(x-1,y-1,color)
                        return false
                    end
                end
            end
        end
        if (@cell_x_check- x).abs == (@cell_y_check- y).abs
            if can_block_bishop_check(x,y,color_not_played) # block bishop check 
                return false    
            end
        end
        if @cell_x_check == x || @cell_y_check == y
            if can_block_rook_check(x,y,color_not_played)
                return false    
            end
        end
        if ((@cell_x_check-x).abs==2 && (@cell_y_check - y).abs ==1 ) || ((@cell_x_check-x).abs==1 && (@cell_y_check - y).abs ==2 )
            if square_not_safe(@cell_x_check,@cell_y_check,color_not_played) # meaning that you can capture the knight
                return false
            end
        end
    else
        return false
    end

    return true
end

class Cell
    attr_accessor :has_piece

    def initialize()
        @has_piece = nil

    end

    def is_vacant()
        return false
    end
        
end

def find_king(color)
    for i in 0..7
        for j in 0..7
            if @board.cells[i][j].has_piece!=nil
                if @board.cells[i][j].has_piece.type == "k" && @board.cells[i][j].has_piece.color== color
                    return i,j
                end
            end
        end
    end

end

def king_not_in_check(color)
    x,y = find_king(color)
    for i in 0..7
        for j in 0..7
            if @board.cells[i][j].has_piece!= nil
                if @board.cells[i][j].has_piece.color !=color
                    if @board.cells[i][j].has_piece.type == "b" &&check_bishop_moves(i,j,x,y )
                        @cell_x_check,@cell_y_check = i,j
                        return false
                    end
                    if @board.cells[i][j].has_piece.type == "r" &&check_rook_moves(i,j,x,y)
                        @cell_x_check,@cell_y_check = i,j
                        return false
                    end
                    if @board.cells[i][j].has_piece.type == "q" &&check_queen_moves(i,j,x,y)
                        @cell_x_check,@cell_y_check = i,j
                        return false
                    end
                    if @board.cells[i][j].has_piece.type == "n" &&check_knight_moves(i,j,x,y)
                        @cell_x_check,@cell_y_check = i,j
                        return false
                    end
                    if @board.cells[i][j].has_piece.type == "p" &&pawn_can_capture(@board.cells[i][j].has_piece.color, i,j,x,y)
                        @cell_x_check,@cell_y_check = i,j
                        return false
                    end
                    if @board.cells[i][j].has_piece.type == "k" &&check_king_moves(i,j,x,y)
                        return false
                    end

                end
            end
        end
    end
    return true
end

def pawn_can_capture(color, x_first,y_first,x_second,y_second)
    if @board.cells[x_first][y_first].has_piece.color == "w" # Capture other pieces of white pawns
        if x_second == x_first +1 && y_second == y_first-1
            return true
        end
        if x_second == x_first -1 && y_second == y_first-1
            return true
        end
    else 
        if x_second == x_first +1 && y_second == y_first+1
            return true
        end
        if x_second == x_first -1 && y_second == y_first+1
            return true
        end

    end
    return false

end

def bishop_can_capture(x_first,y_first,x_second,y_second)
    if (x_second-x_first).abs == (y_second - y_first).abs
        if x_second > x_first && y_second > y_first
            i = 1
            while  x_first+i<= x_second-1
                if @board.cells[x_first+i][y_first+i].has_piece != nil
                    if @board.cells[x_first+i][y_first+i].has_piece.type != "k" 
                        return false
                    end
                end
                i=i+1
            end
        end
        if x_second < x_first && y_second < y_first
            i = 1
            while  x_first-i >= x_second+1
                if @board.cells[x_first-i][y_first-i].has_piece != nil
                    if @board.cells[x_first-i][y_first-i].has_piece.type != "k" 
                        return false
                    end
                end
                i=i+1
            end
        end
        if x_second > x_first && y_second < y_first
            i = 1
            while  x_first+i<= x_second-1
                if @board.cells[x_first+i][y_first-i].has_piece != nil
                    if @board.cells[x_first+i][y_first-i].has_piece.type != "k"
                        return false
                    end
                end
                i=i+1
            end
        end
        if x_second < x_first && y_second > y_first
            i = 1
            while  x_first-i >= x_second+1
                if @board.cells[x_first-i][y_first+i].has_piece != nil
                    if @board.cells[x_first-i][y_first+i].has_piece.type != "k" 
                        return false
                    end
                end
                i=i+1
            end
        end
        return true
        
    else
        return false
    end
end
def king_can_capture()
    
end
def rook_can_capture(x_first,y_first,x_second,y_second)
    if x_first!= x_second && y_first!= y_second
        return false
    end
    if x_second == x_first && y_second > y_first
        i = 1
        while  y_first+i<= y_second-1
            if @board.cells[x_first][y_first+i].has_piece != nil
                if @board.cells[x_first][y_first+i].has_piece.type != "k" 
                    return false
                end
            end
            i=i+1
        end
    end
    if x_second == x_first && y_second < y_first
        i = 1
        while  y_first-i >= y_second+1
            if @board.cells[x_first][y_first-i].has_piece != nil
                if @board.cells[x_first][y_first-i].has_piece.type != "k"
                    return false
                end
            end
            i=i+1
        end
    end
    if x_second > x_first && y_second == y_first
        i = 1
        while  x_first+i<= x_second-1
            if @board.cells[x_first+i][y_first].has_piece != nil
                if @board.cells[x_first+i][y_first].has_piece.type != "k" 
                    return false
                end
            end
            i=i+1
        end
    end
    if x_second < x_first && y_second == y_first
        i = 1
        while  x_first-i >= x_second+1
            if @board.cells[x_first-i][y_first].has_piece != nil
                if @board.cells[x_first-i][y_first].has_piece.type != "k" 
                    return false
                end
            end
            i=i+1
        end
    end

    return true
end

def queen_can_capture(x_first,y_first,x_second,y_second)
    if bishop_can_capture(x_first,y_first,x_second,y_second)
        return true
    elsif rook_can_capture(x_first,y_first,x_second,y_second)
        return true
    else
        return false
    end
end

def knight_can_capture(x_first,y_first,x_second,y_second)
    if (x_first-x_second).abs ==2
        if (y_first-y_second).abs==1
            return true
        end
    end
    if (x_first-x_second).abs ==1
        if (y_first-y_second).abs==2
            return true
        end
    end
    return false
end

class Pawn
    attr_accessor :color,:img, :possible_moves,:type, :first_move
    def initialize(color)
        @first_move = false
        @color = color
        @type = "p"
        if color == "w"
            @img = Gosu::Image.new("./image/pieces/wp.png")
        else
            @img = Gosu::Image.new("./image/pieces/bp.png")
        end
    end

    def draw(cell_x,cell_y)
        x,y = position_on_screen(cell_x,cell_y)
        @img.draw(x,y,z=ZOrder::UI)
    end
    def is_vacant()
        return true
    end
end

class Bishop
    attr_accessor :color,:img, :possible_moves,:type
    def initialize(color)
        @color = color
        @type = "b"
        if color == "w"
            @img = Gosu::Image.new("./image/pieces/wb.png")
        else
            @img = Gosu::Image.new("./image/pieces/bb.png")
        end
    end

    def draw(cell_x,cell_y)
        x,y = position_on_screen(cell_x,cell_y)
        @img.draw(x,y,z=ZOrder::UI)
    end
end

class Rook
    attr_accessor :color,:img, :possible_moves,:type,:first_move
    def initialize(color)
        @first_move=false
        @color = color
        @type = "r"
        if color == "w"
            @img = Gosu::Image.new("./image/pieces/wr.png")
        else
            @img = Gosu::Image.new("./image/pieces/br.png")
        end
    end

    def draw(cell_x,cell_y)
        x,y = position_on_screen(cell_x,cell_y)
        @img.draw(x,y,z=ZOrder::UI)
    end
end
    
class Queen
    attr_accessor :color,:img, :possible_moves,:type
    def initialize(color)
        @color = color
        @type = "q"
        if color == "w"
            @img = Gosu::Image.new("./image/pieces/wq.png")
        else
            @img = Gosu::Image.new("./image/pieces/bq.png")
        end
    end

    def draw(cell_x,cell_y)
        x,y = position_on_screen(cell_x,cell_y)
        @img.draw(x,y,z=ZOrder::UI)
    end
end

class King
    attr_accessor :color, :img, :possible_moves,:type,:first_move 
    def initialize(color)
        @first_move = false
        @color = color
        @type ="k"
        if color == "w"
            @img = Gosu::Image.new("./image/pieces/wk.png")
        else
            @img = Gosu::Image.new("./image/pieces/bk.png")
        end
    end

    def draw(cell_x,cell_y)
        x,y = position_on_screen(cell_x,cell_y)
        @img.draw(x,y,z=ZOrder::UI)
    end
end

class Knight
    attr_accessor :color, :img, :possible_moves,:type
    def initialize(color)
        @color = color
        @type = "n"
        if color == "w"
            @img = Gosu::Image.new("./image/pieces/wn.png")
        else
            @img = Gosu::Image.new("./image/pieces/bn.png")
        end
    end

    def draw(cell_x,cell_y)
        x,y = position_on_screen(cell_x,cell_y)
        @img.draw(x,y,z=ZOrder::UI)
    end
end

class Board
    attr_accessor :img, :cells
    def initialize ()
        @img = Gosu::Image.new("green.png")
        @cells = Array.new(8)
        column_index =0
        while (column_index < 8)
            row = Array.new(8)
            @cells[column_index] = row
            row_index = 0
            while (row_index < 8)
              cell = Cell.new()
              @cells[column_index][row_index] = cell
              row_index += 1
            end
            column_index += 1
        end
      
    end
    
end
 
class Chess< Gosu::Window

    def initialize
        super 800,600
        @board = Board.new()
        for i in 0..7
            @board.cells[i][6].has_piece = Pawn.new("w")
        end
        for i in 0..7
            @board.cells[i][1].has_piece = Pawn.new("b")
        end
        @board.cells[0][0].has_piece = Rook.new("b")
        @board.cells[7][0].has_piece = Rook.new("b")
        @board.cells[0][7].has_piece = Rook.new("w")
        @board.cells[7][7].has_piece = Rook.new("w")
        @board.cells[1][0].has_piece = Knight.new("b")
        @board.cells[6][0].has_piece = Knight.new("b")
        @board.cells[1][7].has_piece = Knight.new("w")
        @board.cells[6][7].has_piece = Knight.new("w")
        @board.cells[2][0].has_piece = Bishop.new("b")
        @board.cells[5][0].has_piece = Bishop.new("b")
        @board.cells[2][7].has_piece = Bishop.new("w")
        @board.cells[5][7].has_piece = Bishop.new("w")
        @board.cells[3][0].has_piece = Queen.new("b")
        @board.cells[4][0].has_piece = King.new("b")
        @board.cells[3][7].has_piece = Queen.new("w")
        @board.cells[4][7].has_piece = King.new("w")
        @font = Gosu::Font.new(25)
        @end_the_game = false
        @string_to_display = nil
        @replay = false

        @cell_x_first = nil
        @cell_y_first = nil
        @cell_x_second = nil
        @cell_y_second = nil
        @passing_value = nil
        @color_just_played = "b"
        @color_not_played = "w"
        @piece_just_captured = nil
        @cell_x_check = nil
        @cell_y_check= nil
        
    end

    def playagain()
        @board = Board.new()

        for i in 0..7
            @board.cells[i][6].has_piece = Pawn.new("w")
        end
        for i in 0..7
            @board.cells[i][1].has_piece = Pawn.new("b")
        end
        @board.cells[0][0].has_piece = Rook.new("b")
        @board.cells[7][0].has_piece = Rook.new("b")
        @board.cells[0][7].has_piece = Rook.new("w")
        @board.cells[7][7].has_piece = Rook.new("w")
        @board.cells[1][0].has_piece = Knight.new("b")
        @board.cells[6][0].has_piece = Knight.new("b")
        @board.cells[1][7].has_piece = Knight.new("w")
        @board.cells[6][7].has_piece = Knight.new("w")
        @board.cells[2][0].has_piece = Bishop.new("b")
        @board.cells[5][0].has_piece = Bishop.new("b")
        @board.cells[2][7].has_piece = Bishop.new("w")
        @board.cells[5][7].has_piece = Bishop.new("w")
        @board.cells[3][0].has_piece = Queen.new("b")
        @board.cells[4][0].has_piece = King.new("b")
        @board.cells[3][7].has_piece = Queen.new("w")
        @board.cells[4][7].has_piece = King.new("w")

        @cell_x_first = nil
        @cell_y_first = nil
        @cell_x_second = nil
        @cell_y_second = nil
        @passing_value = nil
        @color_just_played = "b"
        @color_not_played = "w"
        @piece_just_captured = nil
        @cell_x_check = nil
        @cell_y_check= nil
        @end_the_game = false
        @replay = false
        @string_to_display = nil

    end

    def cell_clicked()
        if mouse_x>= 200 && mouse_x<= 600 && mouse_y>= 100 && mouse_y<=500
            cell_x = (mouse_x-200)/50
            cell_y = (mouse_y-100)/50
            if cell_x>=0
                cell_x = cell_x.to_i
            else
                cell_x = cell_x.to_i
                cell_x = cell_x -1
            end
            if cell_y>=0
                cell_y = cell_y.to_i
            else
                cell_y = cell_y.to_i 
                cell_y = cell_y-1
            end
            
            return cell_x, cell_y
        end
    end

    def check_legal_moves(color,x_first,y_first,x_second,y_second)
        the_string = "rkp"
        if king_not_in_check(color)==false || color == @color_just_played
            if the_string.include? @board.cells[x_second][y_second].has_piece.type
                @board.cells[x_second][y_second].has_piece.first_move = false
            end
            passing_value = @board.cells[x_second][y_second].has_piece
            @board.cells[x_first][y_first].has_piece = passing_value
            if @piece_just_captured== nil
                @board.cells[x_second][y_second].has_piece = nil
            else
                @board.cells[x_second][y_second].has_piece = @piece_just_captured
            end
        else
            @color_just_played = @board.cells[x_second][y_second].has_piece.color
            if @color_just_played == "w"
                @color_not_played= "b"
            else
                @color_not_played = "w"
            end
            if !king_not_in_check(@color_not_played)
                @song = Gosu::Song.new("/Users/khanhvu/Desktop/chess_program/sound/check.mp3")
                @song.play(false)
            else
                if @piece_just_captured!=nil
                    @song = Gosu::Song.new("/Users/khanhvu/Desktop/chess_program/sound/capture.mp3")
                    @song.play(false)
                else
                    @song = Gosu::Song.new("/Users/khanhvu/Desktop/chess_program/sound/move.mp3")
                    @song.play(false)
                end
            end
        end
        @cell_x_second =nil
        @cell_y_second =nil
        @cell_x_first =nil
        @cell_y_first =nil
    end
    
    def check_legal_promoting(color,x_first,y_first,x_second,y_second)
        if king_not_in_check(color)==false || color == @color_just_played
            @board.cells[x_first][y_first].has_piece = Pawn.new(@board.cells[x_second][y_second].has_piece.color)
            if @piece_just_captured== nil
                @board.cells[x_second][y_second].has_piece = nil
            else
                @board.cells[x_second][y_second].has_piece = @piece_just_captured
            end
            @cell_x_second =nil
            @cell_y_second =nil
            @cell_x_first =nil
            @cell_y_first =nil
        else
            @color_just_played = @board.cells[x_second][y_second].has_piece.color
            if @color_just_played == "w"
                @color_not_played= "b"
            else
                @color_not_played = "w"
            end
            @cell_x_second =nil
            @cell_y_second =nil
            @cell_x_first =nil
            @cell_y_first =nil

        end

    end

    def check_castle_king_side(color,x,y)
        if color == @color_just_played
            @board.cells[x+1][y].has_piece = @board.cells[x-1][y].has_piece
            @board.cells[x-2][y].has_piece = @board.cells[x][y].has_piece
            @board.cells[x-1][y].has_piece = nil
            @board.cells[x][y].has_piece = nil
        else
            @color_just_played = @board.cells[x][y].has_piece.color
            if @color_just_played == "w"
                @color_not_played= "b"
            else
                @color_not_played = "w"
            end
            @song = Gosu::Song.new("/Users/khanhvu/Desktop/chess_program/sound/castle.mp3")
            @song.play(false)
            
        end
    end

    def check_castle_queen_side(color,x,y)
        if color == @color_just_played
            @board.cells[x-2][y].has_piece = @board.cells[x+1][y].has_piece
            @board.cells[x+2][y].has_piece = @board.cells[x][y].has_piece
            @board.cells[x+1][y].has_piece = nil
            @board.cells[x][y].has_piece = nil
        else
            color_just_played = @board.cells[x][y].has_piece.color
            if color_just_played == "w"
                @color_not_played= "b"
            else
                @color_not_played = "w"
            end
            @song = Gosu::Song.new("/Users/khanhvu/Desktop/chess_program/sound/castle.mp3")
            @song.play(false)
    

        end
    end

    def updating_moves
        if @cell_x_first!= nil && @cell_y_first!= nil  && @cell_x_second!= nil && @cell_y_second!= nil# if the left-mouse clicked cell is at a square in the @board.
            if @cell_x_first >=0 && @cell_y_first>=0 && @cell_x_second >=0 && @cell_y_second >=0 # 
                if @cell_x_second !=@cell_x_first || @cell_y_first!= @cell_y_second
                    if @board.cells[@cell_x_first][@cell_y_first].has_piece!=nil
                        @piece_just_captured = @board.cells[@cell_x_second][@cell_y_second].has_piece
                        @passing_value = @board.cells[@cell_x_first][@cell_y_first].has_piece
                        @board.cells[@cell_x_second][@cell_y_second].has_piece = @passing_value
                        @board.cells[@cell_x_first][@cell_y_first].has_piece = nil
                        @cell_x_second =nil
                        @cell_y_second =nil
                        @cell_x_first =nil
                        @cell_y_first =nil
                        @passing_value = nil
                    end
                
                end
                
            end
        end
        return @piece_just_captured

    end

    def castle_king_side(x,y)
        @board.cells[x+2][y].has_piece = @board.cells[x][y].has_piece
        @board.cells[x+1][y].has_piece = @board.cells[x+3][y].has_piece
        @board.cells[x][y].has_piece = nil
        @board.cells[x+3][y].has_piece = nil
        @cell_x_second =nil
        @cell_y_second =nil
        @cell_x_first =nil
        @cell_y_first =nil

    end

    def castle_queen_side(x,y)
        @board.cells[x-2][y].has_piece = @board.cells[x][y].has_piece
        @board.cells[x-1][y].has_piece = @board.cells[x-4][y].has_piece
        @board.cells[x][y].has_piece = nil
        @board.cells[x-4][y].has_piece = nil
        @cell_x_second =nil
        @cell_y_second =nil
        @cell_x_first =nil
        @cell_y_first =nil


    end

    def check_bishop_moves(x_first, y_first, x_second, y_second)
        if @board.cells[x_second][y_second].has_piece != nil
            if @board.cells[x_second][y_second].has_piece.color== @board.cells[x_first][y_first].has_piece.color
                return false
            end
        end
        if (x_second- x_first).abs != (y_second- y_first).abs
            return false
        end
        if x_second > x_first && y_second > y_first
            i = 1
            while  x_first+i<= x_second-1
                if @board.cells[x_first+i][y_first+i].has_piece != nil
                    if @board.cells[x_first+i][y_first+i].has_piece.type != "k" && @board.cells[x_first+i][y_first+i].has_piece.color != @board.cells[x_first][y_first]
                        return false
                    end
                end
                i=i+1
            end
        end
        if x_second < x_first && y_second < y_first
            i = 1
            while  x_first-i >= x_second+1
                if @board.cells[x_first-i][y_first-i].has_piece != nil
                    if @board.cells[x_first-i][y_first-i].has_piece.type != "k" && @board.cells[x_first-i][y_first-i].has_piece.color != @board.cells[x_first][y_first]
                        return false
                    end
                end
                i=i+1
            end
        end
        if x_second > x_first && y_second < y_first
            i = 1
            while  x_first+i<= x_second-1
                if @board.cells[x_first+i][y_first-i].has_piece != nil
                    if @board.cells[x_first+i][y_first-i].has_piece.type != "k" && @board.cells[x_first+i][y_first-i].has_piece.color != @board.cells[x_first][y_first]
                        return false
                    end
                end
                i=i+1
            end
        end
        if x_second < x_first && y_second > y_first
            i = 1
            while  x_first-i >= x_second+1
                if @board.cells[x_first-i][y_first+i].has_piece != nil
                    if @board.cells[x_first-i][y_first+i].has_piece.type != "k" && @board.cells[x_first-i][y_first+i].has_piece.color != @board.cells[x_first][y_first]
                        return false
                    end
                end
                i=i+1
            end
        end

        return true

    end

    def check_rook_moves(x_first,y_first,x_second,y_second)
        if @board.cells[x_second][y_second].has_piece != nil
            if @board.cells[x_second][y_second].has_piece.color== @board.cells[x_first][y_first].has_piece.color
                return false
            end
        end
        if x_first!= x_second && y_first!= y_second
            return false
        end
        if x_second == x_first && y_second > y_first
            i = 1
            while  y_first+i<= y_second-1
                if @board.cells[x_first][y_first+i].has_piece != nil
                    if @board.cells[x_first][y_first+i].has_piece.type != "k" && @board.cells[x_first][y_first+i].has_piece.color != @board.cells[x_first][y_first]
                        return false
                    end
                end
                i=i+1
            end
        end
        if x_second == x_first && y_second < y_first
            i = 1
            while  y_first-i >= y_second+1
                if @board.cells[x_first][y_first-i].has_piece != nil
                    if @board.cells[x_first][y_first-i].has_piece.type != "k" && @board.cells[x_first][y_first-i].has_piece.color != @board.cells[x_first][y_first]
                        return false
                    end
                end
                i=i+1
            end
        end
        if x_second > x_first && y_second == y_first
            i = 1
            while  x_first+i<= x_second-1
                if @board.cells[x_first+i][y_first].has_piece != nil
                    if @board.cells[x_first+i][y_first].has_piece.type != "k" && @board.cells[x_first+i][y_first].has_piece.color != @board.cells[x_first][y_first]
                        return false
                    end
                end
                i=i+1
            end
        end
        if x_second < x_first && y_second == y_first
            i = 1
            while  x_first-i >= x_second+1
                if @board.cells[x_first-i][y_first].has_piece != nil
                    if @board.cells[x_first-i][y_first].has_piece.type != "k" && @board.cells[x_first-i][y_first].has_piece.color != @board.cells[x_first][y_first]
                        return false
                    end
                end
                i=i+1
            end
        end

        return true

    end

    def check_queen_moves(x_first,y_first,x_second,y_second)
        if check_rook_moves(x_first,y_first,x_second,y_second)
            return true
        end
        if check_bishop_moves(x_first,y_first,x_second,y_second)
            return true
        end

        return false
    end

    def check_knight_moves(x_first,y_first,x_second,y_second)
        if @board.cells[x_second][y_second].has_piece != nil
            if @board.cells[x_second][y_second].has_piece.color== @board.cells[x_first][y_first].has_piece.color
                return false
            end
        end

        if ((x_second- x_first).abs + (y_second- y_first).abs) !=3
            return false
        end

        if (x_second- x_first).abs!=1 && (x_second- x_first).abs!=2
            return false
        end

        return true
    end

    def check_pawn_moves(x_first,y_first,x_second,y_second)

        if @board.cells[x_first][y_first].has_piece.color == "w" # Capture other pieces for white pawns
            if x_second == x_first +1 && y_second == y_first-1
                if @board.cells[x_second][y_second].has_piece != nil
                    if @board.cells[x_second][y_second].has_piece.color == "b"
                        return true
                    end
                end
            end
            if x_second == x_first -1 && y_second == y_first-1
                if @board.cells[x_second][y_second].has_piece!= nil
                    if @board.cells[x_second][y_second].has_piece.color == "b"
                        return true
                    end
                end
            end

            # The first 2 ifs is to check whether the pawns can capture opponent's pieces. 
            if x_first != x_second
                return false
            end
            if @board.cells[x_second][y_second].has_piece!= nil
                return false
            end
            # If the square in front of the pawn has piece, return false

            if y_second >= y_first
                return false
            end
            if y_first- y_second==2
                if @board.cells[x_first][y_first].has_piece.first_move == false
                    return true
                else
                    return false
                end
            end

            if y_first- y_second>2
                return false
            end

        else # Capture for the black pawns
            if x_second == x_first +1 && y_second == y_first+1
                if @board.cells[x_second][y_second].has_piece!= nil
                    if @board.cells[x_second][y_second].has_piece.color == "w"
                        return true
                    end
                end
            end
            if x_second == x_first -1 && y_second == y_first+1
                if @board.cells[x_second][y_second].has_piece!= nil
                    if @board.cells[x_second][y_second].has_piece.color == "w"
                        return true
                    end
                end
            end

            if x_first != x_second
                return false
            end
            if @board.cells[x_second][y_second].has_piece!= nil
                return false
            end


            if y_second <= y_first
                return false
            end
            if (y_second- y_first)==2
                if @board.cells[x_first][y_first].has_piece.first_move == false
                    return true
                else
                    return false
                end
            end
            if (y_second- y_first)>2
                return false
            end

        end
        

        return true

    end
    
    def pawn_promoting()
        puts("Enter the piece of your choice(b for bishop, q for queen, r for rook and n for knight): ")
        my_string = "rnbq"
        choice = gets.chomp
        while !my_string.include? choice 
            puts("Type again")
            choice = gets.chomp
        end
        if @board.cells[@cell_x_second][@cell_y_second].has_piece != nil
            @piece_just_captured = @board.cells[@cell_x_second][@cell_y_second].has_piece
        end
        if choice == "q"
            @board.cells[@cell_x_second][@cell_y_second].has_piece = Queen.new(@board.cells[@cell_x_first][@cell_y_first].has_piece.color)
            @board.cells[@cell_x_first][@cell_y_first].has_piece = nil
        end
        if choice == "r"
            @board.cells[@cell_x_second][@cell_y_second].has_piece = Rook.new(@board.cells[@cell_x_first][@cell_y_first].has_piece.color)
            @board.cells[@cell_x_first][@cell_y_first].has_piece = nil
        end
        if choice == "b"
            @board.cells[@cell_x_second][@cell_y_second].has_piece = Bishop.new(@board.cells[@cell_x_first][@cell_y_first].has_piece.color)
            @board.cells[@cell_x_first][@cell_y_first].has_piece = nil
        end
        if choice == "n"
            @board.cells[@cell_x_second][@cell_y_second].has_piece = Knight.new(@board.cells[@cell_x_first][@cell_y_first].has_piece.color)
            @board.cells[@cell_x_first][@cell_y_first].has_piece = nil
        end


    end
    
    def check_king_moves(x_first,y_first,x_second,y_second)
        if @board.cells[x_second][y_second].has_piece != nil
            if @board.cells[x_second][y_second].has_piece.color== @board.cells[x_first][y_first].has_piece.color
                return false
            end
        end

        if (x_second-x_first).abs+ (y_second-y_first).abs==1
            return true
        end

        if (x_second-x_first).abs ==1 && (y_second-y_first).abs==1
            return true
        end

        # Castle king side move
        if y_second == y_first && x_second == x_first+2 && @board.cells[x_first][y_first].has_piece.first_move == false
            if @board.cells[x_first+3][y_first].has_piece!= nil
                if @board.cells[x_first+3][y_first].has_piece.type == "r" 
                    if @board.cells[x_first+3][y_first].has_piece.first_move == false
                        if !square_not_safe(x_first,y_first,@board.cells[x_first][y_first].has_piece.color) && !square_not_safe(x_first+1,y_first,@board.cells[x_first][y_first].has_piece.color) && !square_not_safe(x_first+2,y_first,@board.cells[x_first][y_first].has_piece.color) && @board.cells[x_first+1][y_first].has_piece == nil && @board.cells[x_first+2][y_first].has_piece == nil 
                            return true
                        end
                    end
                end
            end
        end

        # Castle queen side move.
        if y_second == y_first && x_second == x_first-2 && @board.cells[x_first][y_first].has_piece.first_move == false
            if @board.cells[x_first-4][y_first].has_piece!= nil
                if @board.cells[x_first-4][y_first].has_piece.type == "r" 
                    if @board.cells[x_first-4][y_first].has_piece.first_move == false
                        if !square_not_safe(x_first,y_first,@board.cells[x_first][y_first].has_piece.color) && !square_not_safe(x_first-1,y_first,@board.cells[x_first][y_first].has_piece.color) && !square_not_safe(x_first-2,y_first,@board.cells[x_first][y_first].has_piece.color) && @board.cells[x_first-1][y_first].has_piece == nil && @board.cells[x_first-2][y_first].has_piece == nil && @board.cells[x_first-3][y_first].has_piece == nil 
                            return true
                        end
                    end
                end
            end
        end
        return false
    end

    def update
        # Check whether the piece is the bishop
        if @cell_x_first!= nil && @cell_y_first!= nil  && @cell_x_second!= nil && @cell_y_second!= nil &&@board.cells[@cell_x_first][@cell_y_first].has_piece!= nil# if the left-mouse clicked cell is at a square in the @board.
            if @board.cells[@cell_x_first][@cell_y_first].has_piece.type == "b"
                if check_bishop_moves(@cell_x_first,@cell_y_first,@cell_x_second,@cell_y_second)
                    x_first,y_first,x_second,y_second = @cell_x_first,@cell_y_first,@cell_x_second,@cell_y_second
                    @piece_just_captured = updating_moves
                    color_just_played = check_legal_moves(@board.cells[x_second][y_second].has_piece.color, x_first,y_first,x_second,y_second)
                    @piece_just_captured = nil

                else
                    @cell_x_second =nil
                    @cell_y_second =nil
                    @cell_x_first =nil
                    @cell_y_first =nil

                end
            end
        end
        

        if @cell_x_first!= nil && @cell_y_first!= nil  && @cell_x_second!= nil && @cell_y_second!= nil &&@board.cells[@cell_x_first][@cell_y_first].has_piece!= nil# if the left-mouse clicked cell is at a square in the @board.
            if @board.cells[@cell_x_first][@cell_y_first].has_piece.type == "r"
                if check_rook_moves(@cell_x_first,@cell_y_first,@cell_x_second,@cell_y_second)
                    x_first,y_first,x_second,y_second = @cell_x_first,@cell_y_first,@cell_x_second,@cell_y_second
                    @piece_just_captured = updating_moves
                    @board.cells[x_second][y_second].has_piece.first_move = true
                    color_just_played =check_legal_moves(@board.cells[x_second][y_second].has_piece.color, x_first,y_first,x_second,y_second)
                    @piece_just_captured = nil
                    
                else
                    @cell_x_second =nil
                    @cell_y_second =nil
                    @cell_x_first =nil
                    @cell_y_first =nil

                end
            end
        end
        if @cell_x_first!= nil && @cell_y_first!= nil  && @cell_x_second!= nil && @cell_y_second!= nil &&@board.cells[@cell_x_first][@cell_y_first].has_piece!= nil# if the left-mouse clicked cell is at a square in the @board.
            if @board.cells[@cell_x_first][@cell_y_first].has_piece.type == "q"
                if check_queen_moves(@cell_x_first,@cell_y_first,@cell_x_second,@cell_y_second)
                    x_first,y_first,x_second,y_second = @cell_x_first,@cell_y_first,@cell_x_second,@cell_y_second
                    @piece_just_captured = updating_moves
                    color_just_played =check_legal_moves(@board.cells[x_second][y_second].has_piece.color, x_first,y_first,x_second,y_second)
                    @piece_just_captured = nil
                else
                    @cell_x_second =nil
                    @cell_y_second =nil
                    @cell_x_first =nil
                    @cell_y_first =nil

                end
            end
        end
        if @cell_x_first!= nil && @cell_y_first!= nil  && @cell_x_second!= nil && @cell_y_second!= nil && @board.cells[@cell_x_first][@cell_y_first].has_piece!= nil# if the left-mouse clicked cell is at a square in the @board.
            if @board.cells[@cell_x_first][@cell_y_first].has_piece.type == "n"
                if check_knight_moves(@cell_x_first,@cell_y_first,@cell_x_second,@cell_y_second)
                    x_first,y_first,x_second,y_second = @cell_x_first,@cell_y_first,@cell_x_second,@cell_y_second
                    @piece_just_captured = updating_moves
                    color_just_played =check_legal_moves(@board.cells[x_second][y_second].has_piece.color, x_first,y_first,x_second,y_second)
                    @piece_just_captured = nil
                else
                    @cell_x_second =nil
                    @cell_y_second =nil
                    @cell_x_first =nil
                    @cell_y_first =nil

                end
            end
        end


        if @cell_x_first!= nil && @cell_y_first!= nil  && @cell_x_second!= nil && @cell_y_second!= nil &&@board.cells[@cell_x_first][@cell_y_first].has_piece!= nil# if the left-mouse clicked cell is at a square in the @board.
            if @board.cells[@cell_x_first][@cell_y_first].has_piece.type == "p"
                if check_pawn_moves(@cell_x_first,@cell_y_first,@cell_x_second,@cell_y_second)
                    if @board.cells[@cell_x_first][@cell_y_first].has_piece.color == "w" && @cell_y_first == 1
                        pawn_promoting()
                        check_legal_promoting("w",@cell_x_first,@cell_y_first,@cell_x_second,@cell_y_second)
                        @piece_just_captured = nil
                        @song = Gosu::Song.new("/Users/khanhvu/Desktop/chess_program/sound/promote.mp3")
                        @song.play(false)
                    elsif @board.cells[@cell_x_first][@cell_y_first].has_piece.color == "b" && @cell_y_first == 6
                        pawn_promoting()
                        check_legal_promoting("b",@cell_x_first,@cell_y_first,@cell_x_second,@cell_y_second)
                        @piece_just_captured = nil
                        @song = Gosu::Song.new("/Users/khanhvu/Desktop/chess_program/sound/promote.mp3")
                        @song.play(false)
                    else
                        x_first,y_first,x_second,y_second = @cell_x_first,@cell_y_first,@cell_x_second,@cell_y_second
                        @piece_just_captured = updating_moves
                        @board.cells[x_second][y_second].has_piece.first_move = true
                        color_just_played =check_legal_moves(@board.cells[x_second][y_second].has_piece.color, x_first,y_first,x_second,y_second)
                        @piece_just_captured = nil

                    end
                else
                    @cell_x_second =nil
                    @cell_y_second =nil
                    @cell_x_first =nil
                    @cell_y_first =nil

                end
            end
        end

        if @cell_x_first!= nil && @cell_y_first!= nil  && @cell_x_second!= nil && @cell_y_second!= nil &&@board.cells[@cell_x_first][@cell_y_first].has_piece!= nil# if the left-mouse clicked cell is at a square in the @board.
            if @board.cells[@cell_x_first][@cell_y_first].has_piece.type == "k"
                if check_king_moves(@cell_x_first,@cell_y_first,@cell_x_second,@cell_y_second)
                    if @cell_x_first - @cell_x_second == 2
                        x_first,y_first,x_second,y_second = @cell_x_first,@cell_y_first,@cell_x_second,@cell_y_second
                        castle_queen_side(@cell_x_first,@cell_y_first)
                        check_castle_queen_side(@board.cells[x_second][y_second].has_piece.color, x_second,y_second)
                    elsif @cell_x_first - @cell_x_second == -2
                        x_first,y_first,x_second,y_second = @cell_x_first,@cell_y_first,@cell_x_second,@cell_y_second
                        castle_king_side(@cell_x_first,@cell_y_first)
                        check_castle_king_side(@board.cells[x_second][y_second].has_piece.color, x_second,y_second)

                    else
                        x_first,y_first,x_second,y_second = @cell_x_first,@cell_y_first,@cell_x_second,@cell_y_second
                        @piece_just_captured = updating_moves
                        @board.cells[x_second][y_second].has_piece.first_move = true
                        color_just_played =check_legal_moves(@board.cells[x_second][y_second].has_piece.color, x_first,y_first,x_second,y_second)
                        @piece_just_captured = nil    
                    end


                else
                    @cell_x_second =nil
                    @cell_y_second =nil
                    @cell_x_first =nil
                    @cell_y_first =nil

                end 
            end
        end
        if checkmate(@color_not_played)
            @end_the_game = true
            if @color_not_played == "b"
                @string_to_display = "Black got checkmated, click anywhere the board to play another game"
            else
                @string_to_display = "White got checkmated, click anywhere the board to play another game"
            end
        end
    end


    def draw()
        @board.img.draw(200,100,scale_x = 1, scale_y = 1,z = ZOrder::PLAYER)
        for i in 0..7
            for j in 0..7
                if @board.cells[i][j].has_piece!= nil
                    @board.cells[i][j].has_piece.draw(i,j)
                end
            end
        end
        if @end_the_game
            @font.draw(@string_to_display, 50,300, 3, 1.0, 1.0, Gosu::Color::RED)
        end
        if @replay
            playagain()
        end
    end

    def button_down(id)
        case id
        when Gosu::MsLeft
            if @end_the_game && mouse_x>= 200 && mouse_x<= 600 && mouse_y>= 100 && mouse_y<=500
                @replay = true
            end
            @cell_x_first, @cell_y_first = cell_clicked()

        end
        case id
        when Gosu::MsRight
            @cell_x_second,@cell_y_second = cell_clicked()
            if @cell_x_first == nil || @cell_y_first == nil || @board.cells[@cell_x_first][@cell_y_first].has_piece==nil
                @cell_x_second,@cell_y_second = nil,nil
            end
        end
    end
end

Chess.new.show if __FILE__ == $0