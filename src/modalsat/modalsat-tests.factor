! Copyright (C) 2013 Your name.
! See http://factorcode.org/license.txt for BSD license.
USING: tools.test modalsat ;
IN: modalsat.tests

[ t ] [ 1 H{ { 1 { 1 "@" "p1" "p2" } } } [ land [ "p1" ] [ "p2" ] ] is-satisfied-at-world? ] unit-test
[ f ] [ 1 H{ { 1 { 1 "@" "p1" } } } [ land [ "p1" ] [ "p2" ] ] is-satisfied-at-world? ] unit-test
[ f ] [ 1 H{ { 1 { 1 "@" "p2" } } } [ land [ "p1" ] [ "p2" ] ] is-satisfied-at-world? ] unit-test
[ f ] [ 1 H{ { 1 { 1 "@" } } } [ land [ "p1" ] [ "p2" ] ] is-satisfied-at-world? ] unit-test

[ t ] [ 1 H{ { 1 { 1 "@" "p1" "p2" } } } [ lor [ "p1" ] [ "p2" ] ] is-satisfied-at-world? ] unit-test
[ t ] [ 1 H{ { 1 { 1 "@" "p1" } } } [ lor [ "p1" ] [ "p2" ] ] is-satisfied-at-world? ] unit-test
[ t ] [ 1 H{ { 1 { 1 "@" "p2" } } } [ lor [ "p1" ] [ "p2" ] ] is-satisfied-at-world? ] unit-test
[ f ] [ 1 H{ { 1 { 1 "@" } } } [ lor [ "p1" ] [ "p2" ] ] is-satisfied-at-world? ] unit-test

[ t ] [ 1 H{ { 1 { 1 "@" "p1" "p2" } } } [ limpl [ "p1" ] [ "p2" ] ] is-satisfied-at-world? ] unit-test
[ f ] [ 1 H{ { 1 { 1 "@" "p1" } } } [ limpl [ "p1" ] [ "p2" ] ] is-satisfied-at-world? ] unit-test
[ t ] [ 1 H{ { 1 { 1 "@" "p2" } } } [ limpl [ "p1" ] [ "p2" ] ] is-satisfied-at-world? ] unit-test
[ t ] [ 1 H{ { 1 { 1 "@" } } } [ limpl [ "p1" ] [ "p2" ] ] is-satisfied-at-world? ] unit-test

[ f ] [ 1 H{ { 1 { 1 "@" "p1" } } } [ lnot [ "p1" ] [ " " ] ] is-satisfied-at-world? ] unit-test
[ t ] [ 1 H{ { 1 { 1 "@" } } } [ lnot [ "p1" ] [ " " ] ] is-satisfied-at-world? ] unit-test

[ f ] [ 1 H{ { 1 { 1 2 "@" "p1" } } { 2 { 1 "@" "p2" "p3" } } } { box { "p1" } { " " } } is-satisfied-at-world? ] unit-test
[ t ] [ 2 H{ { 1 { 1 2 "@" "p1" } } { 2 { 1 "@" "p2" "p3" } } } { box { "p1" } { " " } } is-satisfied-at-world? ] unit-test
[ t ] [ 1 H{ { 1 { 1 2 "@" "p1" } } { 2 { 1 "@" "p2" "p3" } } } { dia { "p2" } { " " } } is-satisfied-at-world? ] unit-test
[ t ] [ 1 H{ { 1 { 1 2 "@" "p1" } } { 2 { 1 "@" "p2" "p3" } } } { dia { land { "p2" } { "p3" } } { " " } } is-satisfied-at-world? ] unit-test
[ t ] [ 1 H{ { 1 { 1 2 "@" "p1" } } { 2 { 1 "@" "p2" "p3" } } } { land { dia { "p1" } { " " } } { dia { "p2" } { " " } } } is-satisfied-at-world? ] unit-test
[ f ] [ 1 H{ { 1 { 1 2 "@" "p1" } } { 2 { 1 "@" "p2" "p3" } } } { dia { land { "p1" } { "p2" } } { " " } } is-satisfied-at-world? ] unit-test
[ t ] [ 1 H{ { 1 { 1 2 "@" "p1" } } { 2 { 1 "@" "p2" "p3" } } } { limpl { "p1" } { box { dia { "p1" } { " " } } { " " } } } is-satisfied-at-world? ] unit-test

[ t ] [ 1 H{
            { 1 { 2 "@" "p" "q" } }
            { 2 { 2 3 4 "@" "p" } }
            { 3 { 4 "@" "q" } }
            { 4 { 4 "@" "p" } }
          }
          {
            box
            {
                land
                { "p" }
                { dia { "q" } { " " } }
            }
            { " " }
          } is-satisfied-at-world? ] unit-test
