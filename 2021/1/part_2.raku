#!/usr/bin/raku

my $lines = $*IN.lines;

my $cnt = 0;
my $prev;

for 2 .. $lines.elems-1 {
  my $floating_sum = $lines[$_-2..$_].sum;
  $cnt++ if defined $prev and $floating_sum > $prev;
  $prev = $floating_sum;
}

say $cnt;
