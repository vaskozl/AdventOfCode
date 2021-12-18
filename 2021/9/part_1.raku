#!/usr/bin/raku

sub verbose(:$l = 1, |c) { say(|c) if $*verbose >= $l }
sub MAIN(
  Str   $file where *.IO.f = 'inputs/example.txt', #= Puzzle input file
  Int :v(:$*verbose) = 0,                          #= Print more things to STDOUT 
) {
  my @heightmap;
  for $file.IO.lines {
    @heightmap.push: .split('', :skip-empty)
  }


  my @lowpoints;
  my $height = @heightmap.elems;
  my $width = @heightmap[0].elems;
  for 0 .. $height-1 -> $h {
    for 0 .. $width-1 -> $w {
      my $val = @heightmap[$h;$w];
      if ($h == 0         or $val < @heightmap[$h-1;$w]) and 
         ($h == $height-1 or $val < @heightmap[$h+1;$w]) and 
         ($w == 0         or $val < @heightmap[$h;$w-1]) and 
         ($w == $width-1  or $val < @heightmap[$h;$w+1]) {
           @lowpoints.push: $val;
         }
    }
  }
  say @lowpoints.map(*+1).sum;
}
