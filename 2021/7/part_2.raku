#!/usr/bin/raku
use Test;

sub verbose(:$l = 1, |c) { say(|c) if $*verbose >= $l }
sub MAIN(
  Str   $file where *.IO.f = 'inputs/example.txt', #= Puzzle input file
  Int :v(:$*verbose) = 0,                          #= Print more things to STDOUT 
) {

  my @crabs = $file.IO.lines.split(',');
  my @sums;
  for @crabs.min .. @crabs.max {
    my $sum = (@crabs >>->> $_)>>.abs.map({($_*($_+1))/2}).sum;
    verbose "($_): $sum";
    push @sums, $sum;
  }
  say @sums.min;
}
