#!/usr/bin/raku

sub MAIN(
  Str   $file where *.IO.f = 'input.txt',
  Bool :v($verbose)
) {
  my @lines = $file.IO.lines;

  my $gamma;
  my $epsilon;

  for 0 .. @lines[0].chars - 1 -> $i {
    my %cnt;
    for @lines -> $line {
      my @chars = $line.split('', :skip-empty);
      %cnt{@chars[$i]}++;
    }
    $gamma ~= %cnt.keys.grep: { %cnt{$_} == %cnt.values.max };
    $epsilon ~= %cnt.keys.grep: { %cnt{$_} == %cnt.values.min };
  }
  $gamma   = "0b$gamma".Int;
  $epsilon = "0b$epsilon".Int;
  say $gamma * $epsilon;
}

