#!/usr/bin/env perl

##  Copyright 2021 Eryk Wdowiak
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
use Napizia::Italian;

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  word limit (no limit)
my $word_limit = 100000;

##  raw and output directories
my $raw_dir = "se31_multi/data-raw";
my $out_dir = "se31_multi/data-tkn";

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  sicilian

my $e2m_backt_scen_sc = $raw_dir .'/'. "e2m_backt_v0-raw_sc-en.sc";
my $e2m_train_scen_sc = $raw_dir .'/'. "e2m_train_v0-raw_sc-en.sc";
my $e2m_valid_scen_sc = $raw_dir .'/'. "e2m_valid_v0-raw_sc-en.sc";
                     
my $m2e_train_scen_sc = $raw_dir .'/'. "m2e_train_v0-raw_sc-en.sc";
my $m2e_valid_scen_sc = $raw_dir .'/'. "m2e_valid_v0-raw_sc-en.sc";

my $e2m_dieli_scen_sc = $raw_dir .'/'. "e2m_trbck-dieli_v0-raw_sc-en.sc";

my @sc_files = ( $e2m_backt_scen_sc ,
		 $e2m_train_scen_sc , $e2m_valid_scen_sc ,
		 $m2e_train_scen_sc , $m2e_valid_scen_sc , $e2m_dieli_scen_sc );

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  english

my $e2m_backt_scen_en = $raw_dir .'/'. "e2m_backt_v0-raw_sc-en.en";
my $e2m_train_scen_en = $raw_dir .'/'. "e2m_train_v0-raw_sc-en.en";
my $e2m_valid_scen_en = $raw_dir .'/'. "e2m_valid_v0-raw_sc-en.en";
                     
my $m2e_train_scen_en = $raw_dir .'/'. "m2e_train_v0-raw_sc-en.en";
my $m2e_valid_scen_en = $raw_dir .'/'. "m2e_valid_v0-raw_sc-en.en";

my $e2m_train_iten_en = $raw_dir .'/'. "e2m_train_v0-raw_it-en.en";
my $e2m_valid_iten_en = $raw_dir .'/'. "e2m_valid_v0-raw_it-en.en";
                      
my $m2e_train_iten_en = $raw_dir .'/'. "m2e_train_v0-raw_it-en.en";
my $m2e_valid_iten_en = $raw_dir .'/'. "m2e_valid_v0-raw_it-en.en";

my @en_files = ( $e2m_backt_scen_en ,
		 $e2m_train_scen_en , $e2m_valid_scen_en ,
		 $m2e_train_scen_en , $m2e_valid_scen_en ,
		 
		 $e2m_train_iten_en , $e2m_valid_iten_en ,
		 $m2e_train_iten_en , $m2e_valid_iten_en );

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  italian

my $e2m_train_iten_it = $raw_dir .'/'. "e2m_train_v0-raw_it-en.it";
my $e2m_valid_iten_it = $raw_dir .'/'. "e2m_valid_v0-raw_it-en.it";

my $m2e_train_iten_it = $raw_dir .'/'. "m2e_train_v0-raw_it-en.it";
my $m2e_valid_iten_it = $raw_dir .'/'. "m2e_valid_v0-raw_it-en.it";

my @it_files = ( $e2m_train_iten_it , $e2m_valid_iten_it , 
		 $m2e_train_iten_it , $m2e_valid_iten_it );

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  SICILIAN
##  ========

foreach my $sc_file (@sc_files) {
    my $sc_infile = $sc_file;
    my $sc_otfile = $sc_file;
    $sc_otfile =~ s/v0-raw/v1-tkn/;
    $sc_otfile =~ s/^$raw_dir\///;
    $sc_otfile =  $out_dir .'/'. $sc_otfile;

    open( INFILE ,   $sc_infile  ) || die "could not open $sc_infile";
    open( OTFILE , ">$sc_otfile" ) || die "could not overwrite $sc_otfile";
    while (<INFILE>) {
	chomp;
	my $line = $_;

	##  tokenize the line
	$line = rm_malice( $line );
	$line =~ s/~~~/ /g;
	$line = sc_tokenizer( $line );
	$line = rm_morejunk( $line );
	
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
    my $en_infile = $en_file;
    my $en_otfile = $en_file;
    $en_otfile =~ s/v0-raw/v1-tkn/;
    $en_otfile =~ s/^$raw_dir\///;
    $en_otfile =  $out_dir .'/'. $en_otfile;
    
    open( INFILE ,   $en_infile  ) || die "could not open $en_infile";
    open( OTFILE , ">$en_otfile" ) || die "could not overwrite $en_otfile";
    while (<INFILE>) {
	chomp;
	my $line = $_;

	##  tokenize the line
	$line = rm_malice( $line );
	$line =~ s/~~~/ /g;
	$line = en_tokenizer( $line );
	$line = rm_morejunk( $line );
	
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

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  ITALIAN
##  =======

foreach my $it_file (@it_files) {
    my $it_infile = $it_file;
    my $it_otfile = $it_file;
    $it_otfile =~ s/v0-raw/v1-tkn/;
    $it_otfile =~ s/^$raw_dir\///;
    $it_otfile =  $out_dir .'/'. $it_otfile;

    open( INFILE ,   $it_infile  ) || die "could not open $it_infile";
    open( OTFILE , ">$it_otfile" ) || die "could not overwrite $it_otfile";
    while (<INFILE>) {
	chomp;
	my $line = $_;

	##  tokenize the line
	$line = rm_malice( $line );
	$line =~ s/~~~/ /g;
	$line = it_tokenizer( $line );
	$line = rm_morejunk( $line );
	
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
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  SUBROUTINES
##  ===========

sub rm_morejunk {
    
    my $line = $_[0];

    $line =~ s/—/-/g;
    $line =~ s/–/-/g;
    $line =~ s/―/-/g;
    $line =~ s/š/s/g;
    $line =~ s/Š/s/g; ## lowercasing (from "S" to "s")
    $line =~ s/…/ . . . /g;
    $line =~ s/œ/oe/g;
    $line =~ s/æ/ae/g;
    $line =~ s/Œg/oe/g;
    $line =~ s/£/ lb /g;
    $line =~ s/¼/ 1\/4 /g;
    $line =~ s/½/ 1\/2 /g;
    $line =~ s/°/o/g;
    $line =~ s/ '/ ' /g;
    $line =~ s/^'/ ' /g;
    
    return $line;
}
