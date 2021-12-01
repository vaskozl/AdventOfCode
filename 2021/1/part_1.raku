#!/usr/bin/raku

my $prev;
my $cnt = 0;

for $*IN.lines -> $cur {
  if (!defined $prev) {
    say "$cur (N/A - no previous measurement)";
  } elsif ($cur > $prev) {
    say "$cur (increased)";
    $cnt++;
  } elsif ($cur == $prev) {
    say "$cur (no change)";
  } else {
    say "$cur (decreased)";
  }
  $prev = $cur;
}

say "$cnt measurements are larger than the previous measurement";
