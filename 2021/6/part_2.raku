#!/usr/bin/raku
sub offspring (Int $days, Int $state) {
  state %offspring;
  return %offspring{$days-$state} if %offspring{$days-$state}:exists; 

  if $days ==  0 { 
    return 1; 
  } elsif $state == 0 {
    %offspring{$days-$state} = offspring($days-1, 6) + offspring($days-1 , 8);
  } else {
    %offspring{$days-$state} = offspring($days-1, $state-1);
  }
  return %offspring{$days-$state};
}

sub verbose(:$l = 1, |c) { say(|c) if $*verbose >= $l }
sub MAIN(
  Str   $file where *.IO.f = 'inputs/example.txt', #= Puzzle input file
  Int :v(:$*verbose) = 0,                          #= Print more things to STDOUT 
  Int :d(:$days)     = 18,                         #= Number of days to pass
) {
  say $file.IO.lines.split(',').map({offspring($days, $_.Int)}).sum;
}
