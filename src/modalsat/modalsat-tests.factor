! Copyright (C) 2013 Your name.
! See http://factorcode.org/license.txt for BSD license.
USING: tools.test modalsat ;
IN: modalsat.tests

[ t ] [ 1 H{ { 1 { 1 2 "@" "p1" "p2" } } } [ land [ "p1" ] [ "p2" ] ] is-satisfied-at-world? ] unit-test
[ f ] [ 1 H{ { 1 { 1 2 "@" "p1" } } } [ land [ "p1" ] [ "p2" ] ] is-satisfied-at-world? ] unit-test
[ f ] [ 1 H{ { 1 { 1 2 "@" "p2" } } } [ land [ "p1" ] [ "p2" ] ] is-satisfied-at-world? ] unit-test
[ f ] [ 1 H{ { 1 { 1 2 "@" } } } [ land [ "p1" ] [ "p2" ] ] is-satisfied-at-world? ] unit-test

[ t ] [ 1 H{ { 1 { 1 2 "@" "p1" "p2" } } } [ lor [ "p1" ] [ "p2" ] ] is-satisfied-at-world? ] unit-test
[ t ] [ 1 H{ { 1 { 1 2 "@" "p1" } } } [ lor [ "p1" ] [ "p2" ] ] is-satisfied-at-world? ] unit-test
[ t ] [ 1 H{ { 1 { 1 2 "@" "p2" } } } [ lor [ "p1" ] [ "p2" ] ] is-satisfied-at-world? ] unit-test
[ f ] [ 1 H{ { 1 { 1 2 "@" } } } [ lor [ "p1" ] [ "p2" ] ] is-satisfied-at-world? ] unit-test

[ t ] [ 1 H{ { 1 { 1 2 "@" "p1" "p2" } } } [ limpl [ "p1" ] [ "p2" ] ] is-satisfied-at-world? ] unit-test
[ f ] [ 1 H{ { 1 { 1 2 "@" "p1" } } } [ limpl [ "p1" ] [ "p2" ] ] is-satisfied-at-world? ] unit-test
[ t ] [ 1 H{ { 1 { 1 2 "@" "p2" } } } [ limpl [ "p1" ] [ "p2" ] ] is-satisfied-at-world? ] unit-test
[ t ] [ 1 H{ { 1 { 1 2 "@" } } } [ limpl [ "p1" ] [ "p2" ] ] is-satisfied-at-world? ] unit-test

[ f ] [ 1 H{ { 1 { 1 2 "@" "p1" } } } [ lnot [ "p1" ] [ " " ] ] is-satisfied-at-world? ] unit-test
[ t ] [ 1 H{ { 1 { 1 2 "@" } } } [ lnot [ "p1" ] [ " " ] ] is-satisfied-at-world? ] unit-test

