#!/usr/bin/raku

my %PAIR = (
    '(' => ')',
    '{' => '}',
    '<' => '>',
    '[' => ']',
);

my %POINTS = (
    ')' => 1,
    ']' => 2,
    '}' => 3,
    '>' => 4,
);

sub verbose(:$l = 1, |c) { say(|c) if $*verbose >= $l }
sub MAIN(
  Str   $file where *.IO.f = 'inputs/example.txt', #= Puzzle input file
  Int :v(:$*verbose) = 0,                          #= Print more things to STDOUT 
) {
    my @scores;
    my $ln=0;
    for $file.IO.lines -> $line {
        $ln++;
        my $valid = True;
        my @stack;
        for $line.split('',:skip-empty) {
            given $_ {
                when /<[{[(<]>/ { @stack.push: $_ }
                default {
                    my $exp = %PAIR{@stack.pop};
                    unless $exp eq $_ {
                        verbose "$ln: Expected $exp got $_ instead.";
                        $valid = False;
                        last;
                    }
                }
            }
        }
        if $valid {
            my $score = 0;
            for @stack.map({%POINTS{%PAIR{$_}}}).reverse -> $p {
                $score *= 5;
                $score += $p;
            }
            verbose "$ln: $line - $score";
            @scores.push: $score;
        }
    }
    say @scores.sort[(@scores.elems/2).Int];
}
