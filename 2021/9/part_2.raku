#!/usr/bin/raku

sub lowpoints(@heightmap) {
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
           @lowpoints.push: ($h, $w);
         }
    }
  }
  return @lowpoints;
}

sub verbose(:$l = 1, |c) { say(|c) if $*verbose >= $l }
sub MAIN(
  Str   $file where *.IO.f = 'inputs/example.txt', #= Puzzle input file
  Int :v(:$*verbose) = 0,                          #= Print more things to STDOUT 
) {
  my @heightmap;
  for $file.IO.lines {
    @heightmap.push: .split('', :skip-empty)
  }

  my $height = @heightmap.elems;
  my $width = @heightmap[0].elems;



  my @lowpoints = lowpoints(@heightmap);

  my %done;
  sub basin_size($h, $w) {
    %done{"$h:$w"} = 1;
    if $h < 0 or 
       $h > $height-1 or 
       $w < 0 or 
       $w > $width-1 or
       @heightmap[$h;$w] == 9 {
       return 0;
     } else {
       my $res = 1;
       $res += basin_size($h-1,$w) unless %done{$h-1~':'~$w};
       $res += basin_size($h+1,$w) unless %done{$h+1~':'~$w};
       $res += basin_size($h,$w-1) unless %done{$h~':'~$w-1};
       $res += basin_size($h,$w+1) unless %done{$h~':'~$w+1};
       return $res;
     }
  }

  my @bsizes;
  for @lowpoints -> ($h, $w) {
    @bsizes.push: basin_size($h,$w);
  }

  say [*] @bsizes.sort.reverse[0..2]
}

