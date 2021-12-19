#!/usr/bin/raku

class Octopus {
  has Int $.energy_level is required is rw;
  has Bool $.already_flashed is rw = False;

  method inc {
      $.energy_level++;
      if $.energy_level > 9 {
          return True unless $.already_flashed;
      }
      return False;
  }

  method clear {
      if $.energy_level > 9 {
        $.already_flashed = False;
        $.energy_level = 0
    }
  }

}

class Grid {
  has Octopus @.octopodes[10,10] is rw;
  has Int $.flashes is rw = 0;

  method inc_into_flash($m,$n) {
      return unless ($m >= 0) and ($m <= 9);
      return unless ($n >= 0) and ($n <= 9);
      if @.octopodes[$m;$n].inc {
          verbose :l(2), "$m, $n flashed!";
          $.flash($m,$n);
      }
  }

  method flash($x,$y) {
      @.octopodes[$x;$y].already_flashed = True;
      $.flashes++;
      $.inc_into_flash($x-1,$y-1);
      $.inc_into_flash($x-1,$y);
      $.inc_into_flash($x-1,$y+1);

      $.inc_into_flash($x,$y-1);
      $.inc_into_flash($x,$y+1);

      $.inc_into_flash($x+1,$y-1);
      $.inc_into_flash($x+1,$y);
      $.inc_into_flash($x+1,$y+1);
  }

  method step {
    for 0..9 -> $x {
        for 0..9 -> $y {
            $.inc_into_flash($x,$y);
        }
    }
    @.octopodes.map: *.clear;
  }

}

sub verbose(:$l = 1, |c) { say(|c) if $*verbose >= $l }
sub MAIN(
  Str   $file where *.IO.f = 'inputs/example.txt', #= Puzzle input file
  Int :v(:$*verbose) = 0,                          #= Print more things to STDOUT
) {
    my $grid = Grid.new(
        octopodes => $file.IO.lines.map(*.split('',:skip-empty).map({
            Octopus.new(:energy_level($_.Int))
        })
    ));

    for 1 .. 10e3 {
        $grid.step;
        my $cnt = $grid.octopodes.grep(*.energy_level == 0).elems;
        if $cnt == 100 {
            say $_;
            last;
        }
    };
}
