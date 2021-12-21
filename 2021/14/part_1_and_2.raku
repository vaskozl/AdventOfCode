#!/usr/bin/raku
sub verbose(:$l = 1, |c) { say(|c) if $*verbose >= $l }
sub MAIN(
  Str   $file where *.IO.f = 'inputs/example.txt', #= Puzzle input file
  Int :v(:$*verbose) = 0,                          #= Print more things to STDOUT
  Int :s(:$steps) = 10,                             #= How many steps to run
) {
    my @lines = $file.IO.lines;

    my $polymer = @lines.shift;
    @lines.shift;

    my %pairs;
    for 0 .. $polymer.chars-2 {
        my $pair = $polymer.substr($_,2);
        %pairs{$pair}++;
    }

    my %pair_insertion;
    for @lines {
        my ($pair, $middle) = .split(' -> ');
        %pair_insertion{$pair} = $middle;
    };

    my %chars = step($steps, %pairs, %pair_insertion);
    my %cc;
    for %chars.kv -> $k, $v {
        for $k.split('',:skip-empty) {
            %cc{$_} += $v;
        }
    }
    my %cn = %cc.invert;
    say (%cn.keys>>.Int.max - %cn.keys>>.Int.min + 1)/2;
}

sub step(Int $cnt, %pairs, %pair_insertion) {
    my %new_pairs;
    for %pairs.keys -> $p {
        my ($a,$b) = $p.split('',:skip-empty);
        my $ins = %pair_insertion{$p};
        %new_pairs{$ins ~ $b} += %pairs{$p};
        %new_pairs{$a ~ $ins} += %pairs{$p};
        verbose "$p :  " ~ $a ~ $ins ~ " and " ~ $ins ~ $b;
    }
    $cnt == 1
        ?? %new_pairs
        !! step($cnt-1, %new_pairs, %pair_insertion);
}
