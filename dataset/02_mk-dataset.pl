#!/usr/bin/perl

##  Copyright 2019 Eryk Wdowiak
##  
##  Licensed under the Apache License, Version 2.0 (the "License");
##  you may not use this file except in compliance with the License.
##  You may obtain a copy of the License at
##  
##      http://www.apache.org/licenses/LICENSE-2.0
##  
##  Unless required by applicable law or agreed to in writing, software
##  distributed under the License is distributed on an "AS IS" BASIS,
##  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
##  See the License for the specific language governing permissions and
##  limitations under the License.

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  

use strict;
use warnings;

##  input files
my $inscfile = "dataset/as40-fables-proverbs_sc_v1-tkn.txt";
my $inenfile = "dataset/as40-fables-proverbs_en_v1-tkn.txt";

##  output files
my $sctrain = "sicilian_raw/train.sc"; 
my $entrain = "sicilian_raw/train.en";

my $scvalid = "sicilian_raw/valid.sc"; 
my $envalid = "sicilian_raw/valid.en";

my $sctestd = "sicilian_raw/test.sc"; 
my $entestd = "sicilian_raw/test.en";

##  number of lines
my @nutrain = (0..3100);
my @nuvalid = (3101..3200);
my @nutest  = (3201..3247);

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  

my @sclines ;
open( my $infhsc , "<$inscfile" ) || die "could not open $inscfile";
while (my $line = <$infhsc>) {
    push( @sclines , $line );
}
close $infhsc;

my @enlines ;
open( my $infhen , "<$inenfile" ) || die "could not open $inenfile";
while (my $line = <$infhen>) {
    push( @enlines , $line );
}
close $infhen;

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  randomize the lines
my @rands = map { rand } @sclines;
my @sidxs = sort { $rands[$a] <=> $rands[$b] } 0..$#sclines ;

##  reorder them
@sclines = @sclines[ @sidxs ];
@enlines = @enlines[ @sidxs ];

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  print out trains
open( my $scfhtrain , ">$sctrain" ) || die "could not overwrite $sctrain";
foreach my $line (@sclines[@nutrain]) {
    print $scfhtrain $line ;
}
close $scfhtrain ;

open( my $enfhtrain , ">$entrain" ) || die "could not overwrite $entrain";
foreach my $line (@enlines[@nutrain]) {
    print $enfhtrain $line ;
}
close $enfhtrain ;

##  print out valids
open( my $scfhvalid , ">$scvalid" ) || die "could not overwrite $scvalid";
foreach my $line (@sclines[@nuvalid]) {
    print $scfhvalid $line ;
}
close $scfhvalid ;

open( my $enfhvalid , ">$envalid" ) || die "could not overwrite $envalid";
foreach my $line (@enlines[@nuvalid]) {
    print $enfhvalid $line ;
}
close $enfhvalid ;

##  print out tests
open( my $scfhtestd , ">$sctestd" ) || die "could not overwrite $sctestd";
foreach my $line (@sclines[@nutest]) {
    print $scfhtestd $line ;
}
close $scfhtestd ;

open( my $enfhtestd , ">$entestd" ) || die "could not overwrite $entestd";
foreach my $line (@enlines[@nutest]) {
    print $enfhtestd $line ;
}
close $enfhtestd ; 
