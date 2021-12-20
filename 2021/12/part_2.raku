#!/usr/bin/raku

class Cave {
  has Bool $.small is required;
  has Str $.name is required;
  has @.neighbours is rw;

  method visited(@already_visited, Bool $small_twice --> Bool) {
    my $limit;
    if $small_twice or ($.name eq 'start') or ($.name eq 'end') {
        $limit = 1;
    } else {
        $limit = 2;
    }
    return @already_visited.grep(* eq $.name).elems >= $limit;
  }

  method can_visit(%path --> Bool) {
    !$.small or !$.visited(%path<route>, %path<small_twice>);
  }
}

my %caves;

sub create_and_connect(Str $name, Str $neighbour) {
    unless %caves{$name} {
        %caves{$name} = Cave.new(
            name       => $name,
            small      => ($name ~~ m/<[a..z]>+/).Bool,
        );
    }
    %caves{$name}.neighbours.push: $neighbour;
}

sub verbose(:$l = 1, |c) { say(|c) if $*verbose >= $l }
sub MAIN(
  Str   $file where *.IO.f = 'inputs/example.txt', #= Puzzle input file
  Int :v(:$*verbose) = 0,                          #= Print more things to STDOUT
) {
    for $file.IO.lines {
        my ($one, $two) = .split('-');
        create_and_connect($one,$two);
        create_and_connect($two,$one);
    }
    verbose :l(2), %caves.raku;

    my @paths = [
        { small_twice => False, route => ['start',] },
    ];

    say @paths;

    my $ends = 0;
    while @paths.elems > 0 {
        my %path =  @paths.pop;
        if %path<route>.tail eq 'end' {
            verbose %path.raku;
            $ends++;
            next;
        }
        for %caves{%path<route>.tail}.neighbours.grep: {%caves{$_}.can_visit(%path)} {
            my @nl =  (|%path<route>, $_);
            my $st = (%path<small_twice> or
                (%caves{$_}.small and  (so $_ eq %path<route>.any)));

            @paths.push: {
                small_twice => $st,
                route       => @nl,
            };
        }
    }

    verbose($_) for @paths.map(*.raku);
    say $ends;
}
