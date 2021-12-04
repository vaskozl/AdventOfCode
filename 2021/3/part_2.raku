#!/usr/bin/raku

sub find_line (@lines, Str $type, Int $i, Str $start is copy = '' ) {
  return @lines[0] if @lines.elems <= 1;

  my %cnt;
  for @lines -> $line {
    my @chars = $line.split('', :skip-empty);
    %cnt{@chars[$i]}++;
  }

  my $target;
  given $type {
    when 'oxygen' { $target = %cnt.values.max; } 
    when 'co2'    { $target = %cnt.values.min; }
  }

  die "Rating type $type unknown!" unless $target;

  my @matches = %cnt.keys.grep: { %cnt{$_} == $target}

  my $first_char;
  if @matches.elems == 1 {
    $first_char ~= @matches[0];
  } else {
    given $type {
      when 'oxygen' { $first_char = 1 }
      when 'co2'    { $first_char = 0 }
    }
  }

  $start ~= $first_char;
  my @new_lines = @lines.grep: /^$start/;
  find_line(@new_lines, $type, $i+1, $start)
}


sub MAIN(
  Str  :f($file) where *.IO.f = 'input.txt',
  Bool :v($verbose)
) {
  my @lines = $file.IO.lines;

  my $oxygen = find_line(@lines, 'oxygen', 0);
  my $co2 = find_line(@lines, 'co2', 0);

  say "0b$oxygen".Int * "0b$co2".Int;
}
