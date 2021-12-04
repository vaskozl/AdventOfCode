#!/usr/bin/raku

class BingoNumber {
  has Bool $.drawn is rw = False;
  has Int $.number;
  
}

class Board {
  has BingoNumber @.squares[5,5] is rw;
  
  method mark_draw(Int $num) {
    for @.squares {
      .drawn = True if .number == $num;
    }
  }

  method has_won(-->Bool) {
    my $board_size = @.squares.elems;

    my @rows = True xx $board_size;
    my @cols = True xx $board_size;

    for 0 .. @.squares.elems - 1 -> $i {
      for 0 .. @.squares.elems - 1 -> $j {
        unless @.squares[$i;$j].drawn {
          @rows[$i] = False;
          @cols[$j] = False;
        }
      }
    }
    return (@rows.first(* == True) or @cols.first(* == True)).Bool
  }

  method score(Int $last_drawn --> Int) {
    @.squares.grep({! $_.drawn}).map(*.number).sum * $last_drawn
  }
}

sub MAIN(
  Str   $file where *.IO.f = 'example.txt',
  Bool :v($verbose)
) {
  my @lines = $file.IO.lines;

  my @draws = (shift @lines).split(',');

  my $k = 0;
  my @boards;
  my @tmp;
  for @lines -> $line {
    next unless $line;

    @tmp[$k] = $line.split(/\s+/, :skip-empty).map: { BingoNumber.new(:number($_.Int)) };

    given $k {
      when 4 { $k = 0, push @boards, Board.new(:squares(@tmp)) }
      default { $k++ }
    }
  }

  for @draws.map: *.Int -> $num {
    my $i = 0;
    for @boards {
      .mark_draw($num);

      if .has_won {
        say "$i is the first winning board";
        say .score($num);
        return;
      }
      $i++;
    }
  }
}

