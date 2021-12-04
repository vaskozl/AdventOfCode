#!/usr/bin/raku

my $depth      = 0;
my $horizontal = 0;

for $*IN.lines -> $line {
  my ($instruction, $val) = $line.split(' ');
  given $instruction {
    when 'forward' { $horizontal += $val }
    when 'down' { $depth += $val }
    when 'up'   { $depth -= $val }
  }
}

say $depth*$horizontal;
