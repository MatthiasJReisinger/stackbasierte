! Copyright (C) 2013 <names>.
! See http://factorcode.org/license.txt for BSD license.
USING: kernel sequences math arrays strings io assocs quotations
       prettyprint combinators ;
IN: modalchecker

! Model representation:
!
!      world    neighbours  "@"    Atoms
! H{
!   {   1    {   2          "@"   "p" "q" } }
!   {   2    {   2 3 4      "@"   "p"     } }
!   {   3    {   4          "@"   "q"     } }
!   {   4    {   4          "@"   "p"     } }
! }
! 
! i.e., H{ { 1 { 2 "@" "p" "q" } } { 2 { 2 3 4 "@" "p" } } { 3 { 4 "@" "q" } } { 4 { 4 "@" "p" } } }
!
! Example formula:
!
! {
!   box
!   {
!       land
!       { "p" }
!       { dia { "q" } { "" } }
!   }
!   { "" }
! }
!
! i.e., { box { land { "p" } { dia { "q" } { "" } } } { "" } }

SYMBOL: limpl
SYMBOL: land
SYMBOL: lor
SYMBOL: lnot
SYMBOL: box
SYMBOL: dia

: is-atom? ( seq -- ? )
    first string? ;

! Takes as input the world's index (n) together with
! the model (assoc). Outputs an array (seq) containing the atoms
! within the according world.
: get-atoms-in-world ( n assoc -- seq )
    at
    dup "@" swap index 1 +
    tail ;

! Takes as input the wold's index (n) together with
! the model (assoc) and a forumla (seq) which simply consists
! of an atom. Outputs a bool that indicates whether
! the given atom is true at the given world within the
! given model.
: atom-value-at-world ( n assoc seq -- ? )
    first -rot get-atoms-in-world member? ;

! Takes as input the wold's index (n) together with the model (assoc) and a
! forumla (seq1) which has the form { conn op1 op2 } where conn is a connective,
! and op1 and op2 are themselves formulas. This input is transformed so that it
! can be used to evaluate the given formula (seq1). Therefore it ouputs two
! arrays (seq2 and seq3) which will be used to evaluate the operands. The
! topmost output element on the stack (symb) is a symbol which defines the
! type of connective which has to be applied to the operands.
: prepare-formula ( n assoc seq1 -- seq2 seq3 symb )
    -rot 2array over 2dup
    second suffix -rot
    third suffix rot
    first ;

: bimpl ( ? ? -- ? ) 
    swap not or ;

: band ( ? ? -- ? ) 
    and ;

: bor ( ? ? -- ? ) 
    or ;

: bnot ( ? ? -- ? ) 
    drop not ;

: mbox ( seq -- ? )
    [ t? ] all? ;

: mdia ( seq -- ? )
    [ t? ] any? ;

: split-up ( seq -- elt1 elt2 elt3 ) 
    >quotation call( --  elt1 elt2 elt3 ) ;

DEFER: is-satisfied-at-world?

: evaluate-operand ( seq -- ? )
    split-up is-satisfied-at-world? ;

: propositional-connective ( seq1 seq2 -- ? ? ) 
    swap evaluate-operand
    swap evaluate-operand ;

: get-reachable-worlds ( n assoc -- seq )
    at
    dup "@" swap index
    head ;

! Takes an array (seq1) with three elements: the index of a world, a model and
! a formula. Outputs an array (seq2) of boolean values.
: evaluate-reachable ( seq1 -- seq2 )
    split-up dupd 2array -rot
    get-reachable-worlds
    swap
    [ swap prefix ]
    curry
    map
    [ evaluate-operand ]
    map ;

: modal-connective ( seq1 seq2 -- seq3 )
    drop evaluate-reachable ;

! Takes a connective (symb) as input. Outputs a quotation whose
! first element is either the word 'propositional-connective' or
! 'modal-connective' depending on the type of connective (symb)
! supplied as input. The second word in the quotation is a word
! which contains the evalutation logic of the connective.
: make-connective-quotation ( symb -- quot ) 
    { { limpl [ [ propositional-connective bimpl ] ] }
      { lnot [ [ propositional-connective  bnot ] ] }
      { lor [ [ propositional-connective bor ] ] }
      { land  [ [ propositional-connective band ] ] }
      { box [ [ modal-connective mbox ] ] } 
      { dia [ [ modal-connective mdia ] ] } } case ;

: is-satisfied-at-world? ( n assoc seq -- ? ) 
    dup is-atom? 
        [ atom-value-at-world ] 
        [ prepare-formula make-connective-quotation call( x y -- x ) ] 
    if ;


