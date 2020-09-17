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

use Napizia::Translator;

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  word limit (no limit)
my $word_limit = 1000;

##  raw directory
my $raw_dir = "sockeye_n30_sw3000/parallels-raw";

##  input and output
my $sc_train_infile = $raw_dir .'/'. "train-mparamu_v0-raw.sc";
my $sc_train_otfile = $raw_dir .'/'. "train-mparamu_v1-tkn.sc";

my $en_train_infile = $raw_dir .'/'. "train-mparamu_v0-raw.en";
my $en_train_otfile = $raw_dir .'/'. "train-mparamu_v1-tkn.en";

my $sc_test_infile = $raw_dir .'/'. "test-data_AS38-AS39_v0-raw.sc";
my $sc_test_otfile = $raw_dir .'/'. "test-data_AS38-AS39_v1-tkn.sc";

my $en_test_infile = $raw_dir .'/'. "test-data_AS38-AS39_v0-raw.en";
my $en_test_otfile = $raw_dir .'/'. "test-data_AS38-AS39_v1-tkn.en";

##  arrays of arrays -- files as file pairs
my @sc_files = ([ $sc_train_infile , $sc_train_otfile ],
		[ $sc_test_infile  , $sc_test_otfile  ]);

my @en_files = ([ $en_train_infile , $en_train_otfile ],
		[ $en_test_infile  , $en_test_otfile  ]);

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  SICILIAN
##  ========

foreach my $sc_file (@sc_files) {
    my $sc_infile = ${$sc_file}[0];
    my $sc_otfile = ${$sc_file}[1];

    open( INFILE ,   $sc_infile  ) || die "could not open $sc_infile";
    open( OTFILE , ">$sc_otfile" ) || die "could not overwrite $sc_otfile";
    while (<INFILE>) {
	chomp;
	my $line = $_;

	##  tokenize the line
	$line = rm_malice( $line );
	$line =~ s/~~~/ /g;
	$line = sc_tokenizer( $line );
	
	##  limit the number of words
	my @newwords = split( / / , $line );
	my $maxlen = ( $#newwords > $word_limit ) ? $word_limit : $#newwords;
	my $otline = join(' ', @newwords[0..$maxlen]);
	$otline =~ s/\s+/ /g;
	$otline =~ s/^ //;
	$otline =~ s/ $//;
	
	##  print it out
	print OTFILE $otline ."\n";
    }
    close OTFILE;
    close INFILE;
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  ENGLISH
##  =======

foreach my $en_file (@en_files) {
    my $en_infile = ${$en_file}[0];
    my $en_otfile = ${$en_file}[1];

    open( INFILE ,   $en_infile  ) || die "could not open $en_infile";
    open( OTFILE , ">$en_otfile" ) || die "could not overwrite $en_otfile";
    while (<INFILE>) {
	chomp;
	my $line = $_;

	##  tokenize the line
	$line = rm_malice( $line );
	$line =~ s/~~~/ /g;
	$line = en_tokenizer( $line );
	$line = en_min_uncontract( $line );
	#$line = en_uncontract( $line );
    
	##  limit words
	my @words = split( / / , $line );
	my $maxlen = ( $#words > $word_limit ) ? $word_limit : $#words;
	my $otline = join(' ', @words[0..$maxlen]);
	$otline =~ s/\s+/ /g;
	$otline =~ s/^ //;
	$otline =~ s/ $//;
	
	##  print it out
	print OTFILE $otline ."\n";
    }
    close OTFILE;
    close INFILE;
}
