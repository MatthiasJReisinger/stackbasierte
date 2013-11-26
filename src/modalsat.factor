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

: is-atom? ( x -- ? ) first string? ;

: prepare-formula ( x y z -- x y z ) -rot 2array dup dup 3array swap >array 2dup first swap first 2array -rot 2dup second swap first 2array -rot third swap first 2array swap rot -rot swap rot ;

: get-atoms-in-world ( x y -- x ) at dup "|" swap index 1 + tail ;
: atom-value-at-world ( x y z -- ? ) first -rot get-atoms-in-world member? ;

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

: propositional-connective ( x y z -- x ) 
    rot split-up is-satisfied-at-world? 
    rot split-up is-satisfied-at-world? 
    rot call( x y -- ? ) inline ;

: make-connective-quotation ( x -- x ) 
    { { limpl [ [ [ bimpl ] propositional-connective ] ] }
      { lnot [ [ [ bnot ] propositional-connective ] ] }
      { lor [ [ [ bor ] propositional-connective ] ] }
      { land  [ [ [ band  ] propositional-connective ] ] } } case ;



! : modal-connective ( x y z -- ? ) inline ;

: is-satisfied-at-world? ( x y z -- x ) 
    dup is-atom? 
        [ atom-value-at-world ] 
        [ prepare-formula first make-connective-quotation call( x y -- x ) ] 
    if 
  inline recursive ;

: testformula ( -- x ) [ limpl [ "p1" ] [ "p2" ] ] ;
: testmodel ( -- x )  H{ { 1 { 1 2 "|" "p1" "p3" "p4" } } { 2 { 1 "|" "p2" "p3" } } } ;

: init ( -- x x x ) 1 testmodel testformula prepare-formula first make-connective-quotation first ;

! : modalsat ( -- ) ;
