! Copyright (C) 2013 <names>.
! See http://factorcode.org/license.txt for BSD license.
USING: kernel sequences math arrays strings io assocs quotations
       prettyprint combinators ;
IN: modalsat

! Model representation
!
!      world    neighbours  "|"    Atoms
!
! H{
!    {   1    { 1 2         "|"    "p1"      } } 
!    {   2    { 1           "|"    "p2" "p3" } } 
!  }
! 
! i.e., H{ { 1 { 1 2 "|" "p1" } } { 2 { 1 "|" "p2" "p3" } } }

SYMBOL: limpl
SYMBOL: land
SYMBOL: lor
SYMBOL: lnot
SYMBOL: box

: is-atom? ( x -- ? )
    first string? ;

: get-atoms-in-world ( x y -- x )
    at
    dup "|" swap index 1 +
    tail ;

: atom-value-at-world ( x y z -- ? )
    first -rot get-atoms-in-world member? ;

: prepare-formula ( x y z -- x y z )
    -rot 2array over 2dup
    second
    swap 2array -rot
    third
    swap 2array rot
    first ;

: bimpl ( x y -- ? ) 
    swap not or ;

: band ( x y -- ? ) 
    and ;

: bor ( x y -- ? ) 
    or ;

: bnot ( x y -- ? ) 
    drop not ;

: split-up ( x y z -- v w x y z ) 
    dup first swap 
    second dup first 
    swap second rot ;

DEFER: is-satisfied-at-world?

: evaluate-operand ( x y z -- x y ? )
    rot split-up is-satisfied-at-world? ;

: propositional-connective ( x y z -- x ) 
    evaluate-operand evaluate-operand
    rot call( x y -- ? ) ;

: make-connective-quotation ( x -- x ) 
    { { limpl [ [ [ bimpl ] propositional-connective ] ] }
      { lnot [ [ [ bnot ] propositional-connective ] ] }
      { lor [ [ [ bor ] propositional-connective ] ] }
      { land  [ [ [ band ] propositional-connective ] ] } } case ;

! : modal-connective ( x y z -- ? ) inline ;

: is-satisfied-at-world? ( x y z -- x ) 
    dup is-atom? 
        [ atom-value-at-world ] 
        [ prepare-formula make-connective-quotation call( x y -- x ) ] 
    if ;

: testformula ( -- x ) { limpl { "p1" } { "p2" } } ;
: testmodel ( -- x )  H{ { 1 { 1 2 "|" "p1" "p3" "p4" } } { 2 { 1 "|" "p2" "p3" } } } ;
: testinput ( -- x x x ) 1 testmodel testformula ;

! : modalsat ( -- ) ;
