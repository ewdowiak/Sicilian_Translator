#!/usr/bin/env perl

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

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  Sicilian input and output
my $in_sc_ref = "test-data/test-data_AS38-AS39_v3-dtk.sc";
my $in_sc_cnd = "test-data/test-data_AS38-AS39_v3-tns.sc";

my $ot_sc_ref = "test-data/test-data_AS38-AS39_v4-dtk.sc";
my $ot_sc_cnd = "test-data/test-data_AS38-AS39_v4-tns.sc";

##  English input and output
my $in_en_ref = "test-data/test-data_AS38-AS39_v3-dtk.en";
my $in_en_cnd = "test-data/test-data_AS38-AS39_v3-tns.en";

my $ot_en_ref = "test-data/test-data_AS38-AS39_v4-dtk.en";
my $ot_en_cnd = "test-data/test-data_AS38-AS39_v4-tns.en";

##  create array of arrays
my @inot = ( [ $in_sc_ref , $ot_sc_ref ] ,
	     [ $in_sc_cnd , $ot_sc_cnd ] ,
	     [ $in_en_ref , $ot_en_ref ] ,
	     [ $in_en_cnd , $ot_en_cnd ] );

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

for my $pair (@inot) {
    my $in = ${$pair}[0];
    my $ot = ${$pair}[1];

    open( INFILE ,   $in  ) || die "could not open $in";
    open( OTFILE , ">$ot" ) || die "could not overwrite $ot";
    while (<INFILE>) {
	chomp;
	my $line = $_;
	$line = tokenize($line);
	print OTFILE $line ."\n";
    }
    close OTFILE;
    close INFILE;
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  SUBROUTINES
##  ===========

sub tokenize {

    my $line = $_[0];
    
    ##  make it all lower case
    $line = lc( $line );
    
    ##  separate punctuation, except apostrophe
    $line =~ s/([\-"\.,:;\!\?\(\)])/ $1 /g;
    
    ##  remove excess space
    $line =~ s/\s+/ /g;
    $line =~ s/^ //;
    $line =~ s/ $//;

    return $line;
}
