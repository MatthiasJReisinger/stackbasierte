USING: kernel sequences math arrays generic strings io assocs math.statistics quotations prettyprint ;
IN: modalsat

SYMBOL: limpl
SYMBOL: land
SYMBOL: lor
SYMBOL: lnot
SYMBOL: box


! Model representation
!
!      world    neighbours  "|"    Atoms
!
! H{ {   1    { 1 2         "|"    "p1"      } } 
!    {   2    { 1           "|"    "p2" "p3" } } 
!  }
! 
! i.e., H{ { 1 { 1 2 "|" "p1" } } { 2 { 1 "|" "p2" "p3" } } }

! Helpers

: prepare-formula ( x y z -- x y z ) -rot 2array dup dup 3array swap >array 2dup first swap first 2array -rot 2dup second swap first 2array -rot third swap first 2array swap rot ;

! : is-atom? ( x -- ? ) first string? ;

! : create-interpretation ( x -- x ) [ "|" = not ] trim-head 1 tail [ ] [ inc-at ] sequence>hashtable ;

: bimpl ( x y -- ? ) swap not or ;
: band ( x y -- ? ) and ;
: bor ( x y -- ? ) or ;
: bneg ( x y -- ? ) drop not ;

: split-up ( x y z -- v w x y z ) dup second swap first dup first swap second rot ;

: propositional-connective ( x y z -- x y z )  rot split-up is-satisfied-at-world? rot split-up rot call( x x -- ? ) inline ;

: make-connective-quotation ( x -- x ) { { limpl [ [ [ bimpl ] propositional-connective ] ] }
                                         { land  [ [ [ band  ] propositional-connective ] ] } } case ;



! : modal-connective ( x y z -- ? ) inline ;

: is-satisfied-at-world? ( x y z -- x ) prepare-formula first make-connective-quotation call( x y -- x ) inline ;

: testformula ( -- x ) [ limpl [ "p1" ] [ "p2" ] ] ;
: testmodel ( -- x )  H{ { 1 { 1 2 "|" "p1" } } { 2 { 1 "|" "p2" "p3" } } } ;

! : modalsat ( -- ) ;
