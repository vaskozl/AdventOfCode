#!/usr/bin/raku

my %PAIR = (
    '(' => ')',
    '{' => '}',
    '<' => '>',
    '[' => ']',
);

my %POINTS = (
    ')' => 3,
    ']' => 57,
    '}' => 1197,
    '>' => 25137,
);

sub verbose(:$l = 1, |c) { say(|c) if $*verbose >= $l }
sub MAIN(
  Str   $file where *.IO.f = 'inputs/example.txt', #= Puzzle input file
  Int :v(:$*verbose) = 0,                          #= Print more things to STDOUT 
) {
    my @scores;
    my $line=0;
    for $file.IO.lines {
        $line++;
        my @stack;
        for .split('',:skip-empty) {
            given $_ {
                when /<[{[(<]>/ { @stack.push: $_ }
                default {
                    my $exp = %PAIR{@stack.pop};
                    unless $exp eq $_ {
                        verbose "$line: Expected $exp got $_ instead.";
                        @scores.push: %POINTS{$_};
                        verbose @scores.raku;
                        last;
                    }
                }
            }
        }
    }
    say @scores.sum;
}
