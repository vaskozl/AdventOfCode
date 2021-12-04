#!/usr/bin/raku

my $depth      = 0;
my $horizontal = 0;
my $aim        = 0 ;

for $*IN.lines -> $line {
  my ($instruction, $val) = $line.split(' ');
  given $instruction {
    when 'forward' { 
      $horizontal += $val;
      $depth += $aim * $val;
    }
    when 'down' { $aim += $val }
    when 'up'   { $aim -= $val }
  }
}

say $depth*$horizontal;
