#!/usr/bin/raku
sub verbose(:$l = 1, |c) { say(|c) if $*verbose >= $l }
sub MAIN(
  Str   $file where *.IO.f = 'inputs/example.txt', #= Puzzle input file
  Int :v(:$*verbose) = 0,                          #= Print more things to STDOUT
) {
    my @lines = $file.IO.lines;
    my @map;

    my @folds;
    while @lines.pop ~~ /^fold\salong\s(.*)/ {
        @folds.push: $0;
    }

    my $max_x = 1310;
    my $max_y = 894;

    say "$max_x X $max_y";

    # Init the paper to zero
    for 0..$max_x -> $x {
        for 0..$max_y -> $y {
            @map[$x;$y] = 0;
        }
    }

    for @lines {
        my ($x, $y) = .split(',')>>.Int;
        @map[$x;$y] = '1';
    }

    for @folds.reverse {
        say "$_ produces: ";
        my ($axis, $line) = .split('=');
        if $axis eq 'x' {
            @map = fold_x(@map, $line);
        } elsif $axis eq 'y' {
            @map = fold_y(@map, $line);
        }
        draw(@map);
    }
}

sub fold_y(@map, $fold_val) {
    my @nm;
    for @map {
        my @y_row = $_;
        my @a = @y_row[0][0..($fold_val-1)];
        my @b = (@y_row[0][$fold_val+1..@y_row[0].end]).reverse;
        for 0..@a.end {
            if $_ <= @b.end and @b[$_] {
                @a[$_] += @b[$_] ;
            }
        }
        @nm.push: @a;
    }
    return @nm;
}

sub fold_x(@map, $fold_val) {
    my @a = (@map[(0..$fold_val-1)]);
    my @b = (@map[$fold_val+1..@map.end]).reverse;
    for 0..@a.end {
        if $_ <= @b.end and @b[$_] {
            @a[$_] =  @a[$_] >>+<< @b[$_];
        }
    }
    return @a;
}

sub draw(@map) {
    my $dots=0;
    for 0 .. @map[0].end -> $y {
        for 0..@map.end -> $x {
            if @map[$x;$y] {
                $dots++;
                print '#';
            } else { print '.'; }
        }
        print "\n";
    }
    say "Number of dots: $dots";
}
