#!/usr/bin/raku
use Test;

#  TTTT
# L    R
# L    R
#  MMMM
# X    Y
# X    Y
#  BBBB

my %SEGMENTS = (
  0 => 6,
  1 => 2,
  2 => 5,
  3 => 5,
  4 => 4,
  5 => 5,
  6 => 6,
  7 => 3,
  8 => 7,
  9 => 6,
);


sub verbose(:$l = 1, |c) { say(|c) if $*verbose >= $l }
sub MAIN(
  Str   $file where *.IO.f = 'inputs/example.txt', #= Puzzle input file
  Int :v(:$*verbose) = 0,                          #= Print more things to STDOUT 
) {

  my $total = 0;
  for $file.IO.lines {
    my ($input, $output) = $_.split('|');
    $total += $output
      .split(' ', :skip-empty)
      .map(*.chars)
      .grep({ %SEGMENTS{1,4,7,8}.grep($_) })
  }
  say $total;
}
