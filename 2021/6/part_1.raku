#!/usr/bin/raku
use Test;

class LanternFish {
  has Int $.timer is rw = 8;

  method pass_day (-->Bool) {
    given $.timer {
      when 0 { $.timer = 6; True }
      default { $.timer -= 1; False }
    }
  }
}

sub verbose(:$l = 1, |c) { say(|c) if $*verbose >= $l }
sub MAIN(
  Str   $file where *.IO.f = 'inputs/example.txt', #= Puzzle input file
  Int :v(:$*verbose) = 0,                          #= Print more things to STDOUT 
  Int :d(:$days)     = 18,                         #= Number of days to pass
) {

  my @lantern_fish;
  for $file.IO.lines.split(',') {
    @lantern_fish.push: LanternFish.new(timer => .Int)
  }
  for (1..$days) {
    verbose :l(2), "Day $_:" ~ @lantern_fish.map(*.timer).join(',');
    my @tmp;
    for @lantern_fish {
      if .pass_day {
        @tmp.push: LanternFish.new;
      }
    }
    @lantern_fish.append: @tmp;
    verbose "$_/$days: " ~ @lantern_fish.elems;
  }

  say "After $days days there are " ~ @lantern_fish.elems ~ " lantern fish";
}
