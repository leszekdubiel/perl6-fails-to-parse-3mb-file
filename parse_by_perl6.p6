#! /usr/bin/env perl6
use v6.c;
# use Grammar::Tracer;


grammar lists-and-trees {
  token TOP { ^ [<number> |<name> | <text> | <parameters>] $ }

  proto token number {*}

  token number:sym<0.0> { <sym> }
  token number:sym<0.x> {
    <[+-]>
    '0.'
    <[0..9]> ** 1..14

    <!after '0'> # last digit can't be a "0"
  }
  token number:sym<x.x> {
    <[+-]>

    <[1..9]>
    <[0..9]>*

    '.'

    [
    ||
        <[0..9]>+
        <!after '0'> # no trailing '0'
    ||
        '0'
        # make sure to fail if there are trailing digits
        [ $ | <!before <[0..9]>> ]
    ]

    # at most 15 digits
    <?{ $/.to - $/.from <= 15 + 2 }>
  }

  token name {
    <?before <:L>> # must start with an alpha

    [
      <:L + :N>+ # letters or numbers
    ]+ % '_'     # separated by "_" (no trailing)

    # fail if there is more but it is invalid
    # (shouldn't be necessary)
    [ $ | <!before \w> ]
  }

  token backslashed {
    | ｢\\｣ { make ｢\｣ }
    | ｢\"｣ { make ｢"｣ }
    | ｢\t｣ { make "\t" }
    | ｢\n｣ { make "\n" }
  }
  proto token text-part {*}
  token text-part:sym<bs> {
    <backslashed>
  }
  token text-part:sym<regular> {
    <- ["\\] - :C - :Zl - :Zp >+
  }
  token text {
    ｢"｣ ~ ｢"｣    <text-part>+
  }

  proto token value {*}
  token value:sym<number> { <number> }
  token value:sym<name> { <name> }
  token value:sym<text> { <text> }
  token value:sym<parameters> { <parameters> }

  rule parameter {
    <name> <value>
  }
  token parameters {
    <.ws>
    '('
    <.ws>
      <parameter>* % <.ws>
    <.ws>
    ')'
    <.ws>
  }
  rule list-part {
    <name> <parameters>
  }
  token list {
    <.ws>
    '('
    <.ws>
      <list-part>* % <.ws>
    <.ws>
    ')'
    <.ws>
  }
  rule tree-part {
    <name> <parameters> <tree>
  }
  token tree {
    <.ws>
    '('
    <.ws>
      <tree-part>* % <.ws>
    <.ws>
    ')'
    <.ws>
  }
  token ws {
    [
    | <|wb> \s*
    | \s* '#' \N+ \n \s*
    | \s+
    ]
  }
}



say lists-and-trees.parse( slurp, :rule<tree> );

