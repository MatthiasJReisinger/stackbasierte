
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

: is-atom? ( seq -- ? )
    first string? ;

! takes as input the world's index (n) together with
! the model (assoc). outputs an array (seq) containing the atoms
! within the according world.
: get-atoms-in-world ( n assoc -- seq )
    at
    dup "|" swap index 1 +
    tail ;

! takes as input the wold's index (n) together with
! the model (assoc) and a forumla (seq) which simply consists
! of an atom. outputs a bool that indicates whether
! the given atom is true at the given world within the
! given model.
: atom-value-at-world ( n assoc seq -- ? )
    first -rot get-atoms-in-world member? ;

! takes as input the wold's index (n) together with the model (assoc) and a
! forumla (seq1) which has the form { conn op1 op2 } where conn is a connective,
! and op1 and op2 are themselves formulas. this input is transformed so that it
! can be used to evaluate the given formula (seq1). therefore it ouputs two
! arrays (seq2 and seq3) which will be used to evaluate the operands. the
! topmost output element on the stack (symb) is a symbol which defines the
! type of connective which has to be applied to the operands.
: prepare-formula ( n assoc seq1 -- seq2 seq3 symb )
    -rot 2array over 2dup
    second
    swap 2array -rot
    third
    swap 2array rot
    first ;

: bimpl ( ? ? -- ? ) 
    swap not or ;

: band ( ? ? -- ? ) 
    and ;

: bor ( ? ? -- ? ) 
    or ;

: bnot ( ? ? -- ? ) 
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

: is-satisfied-at-world? ( n assoc seq -- ? ) 
    dup is-atom? 
        [ atom-value-at-world ] 
        [ prepare-formula make-connective-quotation call( x y -- x ) ] 
    if ;

: testformula ( -- x ) { limpl { "p1" } { "p2" } } ;
: testmodel ( -- x )  H{ { 1 { 1 2 "|" "p1" "p3" "p4" } } { 2 { 1 "|" "p2" "p3" } } } ;
: testinput ( -- x x x ) 1 testmodel testformula ;

! : modalsat ( -- ) ;
