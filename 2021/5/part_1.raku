#!/usr/bin/raku
use Test;

sub verbose(:$l = 1, |c) { say(|c) if $*verbose >= $l }
sub MAIN(
  Str   $file where *.IO.f = 'inputs/example.txt', #= Puzzle input file
  Int :v(:$*verbose) = 0,                          #= Print more things to STDOUT 
  Int :a(:$answer)   = 5,                          #= The answer to the example puzzle.
  Int :s(:$*size)    = 10,                         #= Board size
) {

  is solve($file.IO.lines), $answer;
}

sub solve(@lines) {
  my Int @board[$*size;$*size] = 0 xx $*size xx $*size;

  for @lines.map: *.split(/\D+/, :skip-empty).map(*.Int) -> ($x1, $y1, $x2, $y2) {
    verbose :l(3), $x1, $y1, $x2, $y2;
    if ($x1 == $x2) {
      for (min($y1,$y2) .. max($y1,$y2)) -> $y { @board[$y;$x1]++ }
    } elsif ($y1 == $y2) {
      for (min($x1,$x2) .. max($x1,$x2)) -> $x { @board[$y1;$x]++ }
    } else {
      verbose :l(2), "Line is not horizontal $x1, $y1 -> $x2, $y2";
    }
  }
  verbose @board;
  return @board.grep(* > 1).elems;
}
