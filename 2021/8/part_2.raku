#!/usr/bin/raku
use Test;

my %SEG_PER_DIGIT = (
  0 => 6,
  1 => 2,
  2 => 5,
  3 => 5,
  4 => 4,
  5 => 5,
  6 => 6,
  7 => 3,
  8 => 7,
  9 => 6,
);


sub verbose(:$l = 1, |c) { say(|c) if $*verbose >= $l }
sub MAIN(
  Str   $file where *.IO.f = 'inputs/example.txt', #= Puzzle input file
  Int :v(:$*verbose) = 0,                          #= Print more things to STDOUT 
) {

  my $total = 0;
  for $file.IO.lines {
    my @words = .split(/\W+/, :skip-empty).map(*.split('').sort.join(''));
    my ($input, $output) = .split('|') ;
    my %digits;

    for (1,4,7,8) {
      %digits{$_} = (@words.grep(*.chars == %SEG_PER_DIGIT{$_})[0]).split('', :skip-empty);
    }

    %digits{690} = (@words.grep(*.chars == %SEG_PER_DIGIT{6}).unique[0..2]).map: *.split('', :skip-empty);
    %digits{235} = (@words.grep(*.chars == %SEG_PER_DIGIT{5}).unique[0..2]).map: *.split('', :skip-empty);

    for %digits.keys.sort  { verbose "Digit ($_)\t " ~ %digits{$_}.raku }
    
    #  TTTT
    # L    R
    # L    R
    #  MMMM
    # X    Y
    # X    Y
    #  BBBB

    my %segment;

    # Top (T) is easy to get
    %segment<T> = %digits{7} ∖ %digits{1};

    # The bottom left two segments
    %segment<XB> = %digits{8} ∖ (%digits{7} ∪ %digits{4});
    %segment<LM> = %digits{4} ∖ %digits{1};

    %segment<BYTL> = ([(&)] %digits{690});
    %segment<B> =  %segment<BYTL> ∖ (%digits{7} ∪ %digits{4});
    %segment<YTL> =  %segment<BYTL> ∖ %segment<B>;
    %segment<Y> = %segment<YTL> (&) %digits{1};
    %segment<LT> = %segment<YTL> ∖ %segment<Y>;
    %segment<L> = %segment<LT> ∖ %segment<T>;
    
    %segment<X> = %segment<XB> ∖ %segment<B>;
    %segment<M> = ([(&)] %digits{235})  ∖ ([(|)] %segment<YTL B>);

    %digits{2} = %digits{235}.grep(%segment<X> ⊂ *)[0];

    %segment<R> = %digits{2} ∖ %segment<T> ∖ %segment<B> ∖ %segment<M> ∖ %segment<X>;
    %segment<Y> = %digits{1} ∖ %segment<R>;

    for %segment.keys.sort { verbose "Segment ($_)\t " ~ %segment{$_}.raku }


    verbose "Solution:";
    verbose "    " ~ %segment<T>.pick x 4;
    verbose "   " ~%segment<L>.pick ~ "    " ~ %segment<R>.pick;
    verbose "   " ~%segment<L>.pick ~ "    " ~ %segment<R>.pick;
    verbose "    " ~ %segment<M>.pick x 4;
    verbose "   " ~%segment<X>.pick ~ "    " ~ %segment<Y>.pick;
    verbose "   " ~%segment<X>.pick ~ "    " ~ %segment<Y>.pick;
    verbose "    " ~ %segment<B>.pick x 4;

    %digits{0} = %digits{690}.grep(%segment<M>   ⊄ *)[0];
    %digits{6} = %digits{690}.grep(([(|)] %segment<M X>) ⊂ *)[0];
    %digits{9} = %digits{690}.grep(([(|)] %segment<M R>) ⊂ *)[0];

    %digits{2} = %digits{235}.grep(%segment<X>   ⊂ *)[0];
    %digits{5} = %digits{235}.grep(%segment<L>   ⊂ *)[0];
    %digits{3} = %digits{235}.grep(([(|)] %segment<R Y>) ⊂ *)[0];

    #say %digits.raku;
    my %trans;
    for %digits.keys.sort {
      %trans{%digits{$_}.sort.join('')} = $_;
    }

    verbose;
    verbose %trans.raku;


    my $cur = $output.split(/\W+/, :skip-empty).map(*.split('').sort.join('')).map({%trans{$_}}).join('').Int;
    say $cur;
    $total += $cur;
  }

  say "Total: $total";
}
