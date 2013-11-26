USING: kernel sequences math arrays generic strings io ;
IN: modalsat

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

formula-children ( x -- x x ) dup second swap third ;
formula-root ( x -- x ) first ;

: is-atom? ( x -- ? ) first string? ;

: create-interpretation ( x -- x ) [ ] [ inc-at ] sequence>hashtable [ "|" = not ] trim-head 1 tail ;

: bimpl ( x x -- ? ) swap not or ;
: band ( x x -- ? ) and ;
: bor ( x x -- ? ) or ;
: bneg ( x -- ? ) neg ;

: impl ( x -- ? ) is-atom? [ f ] [ t ] if ;

: testformula ( -- x ) [ impl [ "p1" ] [ "p1" ] ] ;

is-satisfiedAtWorld? ( -- ? ) true ;