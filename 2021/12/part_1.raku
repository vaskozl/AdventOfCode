#!/usr/bin/raku

class Cave {
  has Bool $.small is required;
  has Str $.name is required;
  has @.neighbours is rw;

  method visited(@already_visited --> Bool) {
    return so $.name eq @already_visited.any;
  }

  method can_visit(@already_visited --> Bool) {
    !$.small or !$.visited(@already_visited);
  }
}

my %caves;

sub create_and_connect(Str $name, Str $neighbour) {
    unless %caves{$name} {
        %caves{$name} = Cave.new(
            name       => $name,
            small      => ($name ~~ m/<[a..z]>+/) ?? True !! False,
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
    verbose %caves.raku;

    my @paths = [
        ['start',],
    ];

    for @paths -> @path {
        next if @path[*-1] eq 'end';
        for %caves{@path[*-1]}.neighbours.grep: {%caves{$_}.can_visit(@path)} {
            my @tmp = @path;
            @paths.push: @tmp.append($_);
        }
    };
    my @routes = @paths.grep(*.tail eq 'end');
    verbose($_) for @routes.map(*.raku);
    say @routes.elems;
}
