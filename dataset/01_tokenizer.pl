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

##  input and output
my $sc_infile = "dataset/as40-fables-proverbs_sc_v0-raw.txt";
my $sc_otfile = "dataset/as40-fables-proverbs_sc_v1-tkn.txt";

my $en_infile = "dataset/as40-fables-proverbs_en_v0-raw.txt";
my $en_otfile = "dataset/as40-fables-proverbs_en_v1-tkn.txt";

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  SICILIAN
##  ========

open( INFILE ,   $sc_infile  ) || die "could not open $sc_infile";
open( OTFILE , ">$sc_otfile" ) || die "could not overwrite $sc_otfile";

while (<INFILE>) {
    chomp;
    my $line = $_;

    ##  make it all lower case
    $line = lc( $line );
    
    ##  separate punctuation, except apostrophe
    $line =~ s/([\-"\.,:;\!\?\(\)])/ $1 /g;
    
    ##  remove excess space
    $line =~ s/\s+/ /g;
    $line =~ s/^ //;
    $line =~ s/ $//;

    ##  add single space to beginning and end of line
    $line = " " . $line . " ";

    ##  form contractions, if necessary
    $line =~ s/ cu un / c'un /g;
    $line =~ s/ di un / d'un /g;

    ##  remove unnecessary apostrophes
    $line =~ s/ po' / po /g;
    $line =~ s/ vo' / vo /g;
    $line =~ s/ me' / me /g;
    $line =~ s/ to' / to /g;
    $line =~ s/ so' / so /g;

    ##  replace "<<" and ">>" with single quote
    $line =~ s/«/ " /g;
    $line =~ s/»/ " /g;
    
    ##  remove excess space, again
    $line =~ s/\s+/ /g;
    $line =~ s/^ //;
    $line =~ s/ $//;

    ##  remove spaces after an apostrophe
    $line =~ s/' /'/g;
    
    ##  replace acute accents with grave accents
    $line = swap_accents( $line );
    
    ##  remove accents from each word
    ##  except ("è" = "is") and ("sì" = "you are")
    ##  and uncontract circumflex accents words
    my @words = split( / / , $line );
    my @no_accents ; 
    for my $i (0..$#words) {

	##  which word
	my $word = $words[$i];
	my $next_word = ( $i != $#words ) ? $words[$i+1] : "";
	
	if ( $word ne "sì"   &&  $word ne "si'"  &&
	     $word ne "è"    &&  $word ne "e'"   &&
	     $word ne "n'è"  &&  $word ne "n'e'" &&
	     $word ne "c'è"  &&  $word ne "c'e'" ) {

	    ##  remove accents
	    my $new_word = rid_accents( $word );

	    ##  replace abbreviated article with full form
	    $new_word = ( $new_word eq "'u" ) ? "lu" : $new_word;
	    $new_word = ( $new_word eq "'a" ) ? "la" : $new_word;
	    $new_word = ( $new_word eq "'i" ) ? "li" : $new_word;

	    ##  uncontract circumflex accented words
	    $new_word = uncontract( $new_word , $next_word );
	    
	    ##  push it out
	    push( @no_accents , $new_word );
	    
	} else {
	    my $new_word = $word;

	    ##  replace accent with apostrophe
	    $new_word = ( $new_word eq "sì"  ) ? "si'"  : $new_word;
	    $new_word = ( $new_word eq "è"   ) ? "e'"   : $new_word;
	    $new_word = ( $new_word eq "c'è" ) ? "c'e'" : $new_word;
	    $new_word = ( $new_word eq "n'è" ) ? "n'e'" : $new_word;
	    
	    ##  push it out
	    push( @no_accents , $new_word );
	}
    }

    ##  join it all together
    my $newline = join( ' ' , @no_accents );

    ##  remove any remaining accents
    $newline = rid_accents( $newline );
    $newline = rid_circum(  $newline );
    
    ##  insert space after an apostrophe
    $newline =~ s/'/' /g;
    
    ##  make it all lower case (again)
    $newline = lc( $newline );
    
    ##  remove excess space
    $newline =~ s/\s+/ /g;
    $newline =~ s/^ //;
    $newline =~ s/ $//;
    
    ##  print it out
    print OTFILE $newline ."\n";
}

close OTFILE;
close INFILE;

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  ENGLISH
##  =======

open( INFILE ,   $en_infile  ) || die "could not open $en_infile";
open( OTFILE , ">$en_otfile" ) || die "could not overwrite $en_otfile";

while (<INFILE>) {
    chomp;
    my $line = $_;

    ##  make it all lower case
    $line = lc( $line );
    
    ##  separate punctuation, except apostrophe
    $line =~ s/([\-"\.,:;\!\?\(\)])/ $1 /g;
    
    ##  remove excess space
    $line =~ s/\s+/ /g;
    $line =~ s/^ //;
    $line =~ s/ $//;

    ##  add single space to beginning and end of line
    $line = " " . $line . " ";
    
    ##  remove accents
    $line = rid_accents( $line );
    $line = rid_circum(  $line );

    ##  make it all lower case (again)
    $line = lc( $line );
    
    ##  remove excess space
    $line =~ s/\s+/ /g;
    $line =~ s/^ //;
    $line =~ s/ $//;

    ##  print it out
    print OTFILE $line ."\n";
}

close OTFILE;
close INFILE;

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  SUBROUTINES
##  ===========

##  replace acute accents with lower case grave accents
sub swap_accents {
    my $str = $_[0] ;
    
    ##  change acute accents to grave accents
    $str =~ s/\303\241/\303\240/g; 
    $str =~ s/\303\251/\303\250/g; 
    $str =~ s/\303\255/\303\254/g; 
    $str =~ s/\303\263/\303\262/g; 
    $str =~ s/\303\272/\303\271/g; 
    $str =~ s/\303\201/\303\240/g; # \303\200
    $str =~ s/\303\211/\303\250/g; # \303\210
    $str =~ s/\303\215/\303\254/g; # \303\214
    $str =~ s/\303\223/\303\262/g; # \303\222
    $str =~ s/\303\232/\303\271/g; # \303\231
    
    return $str ;
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  remove all accents except circumflex accents
##  and make lower case
sub rid_accents {
    my $str = $_[0] ;
    
    ##  rid grave accents
    $str =~ s/\303\240/a/g; 
    $str =~ s/\303\250/e/g; 
    $str =~ s/\303\254/i/g; 
    $str =~ s/\303\262/o/g; 
    $str =~ s/\303\271/u/g; 
    $str =~ s/\303\200/a/g; # A
    $str =~ s/\303\210/e/g; # E
    $str =~ s/\303\214/i/g; # I
    $str =~ s/\303\222/o/g; # O
    $str =~ s/\303\231/u/g; # U
    
    ##  rid acute accents
    $str =~ s/\303\241/a/g; 
    $str =~ s/\303\251/e/g; 
    $str =~ s/\303\255/i/g; 
    $str =~ s/\303\263/o/g; 
    $str =~ s/\303\272/u/g; 
    $str =~ s/\303\201/a/g; # A
    $str =~ s/\303\211/e/g; # E
    $str =~ s/\303\215/i/g; # I
    $str =~ s/\303\223/o/g; # O
    $str =~ s/\303\232/u/g; # U
    
    ##  rid diaeresis accents
    $str =~ s/\303\244/a/g;
    $str =~ s/\303\253/e/g;
    $str =~ s/\303\257/i/g;
    $str =~ s/\303\266/o/g;
    $str =~ s/\303\274/u/g;
    $str =~ s/\303\204/a/g; # A
    $str =~ s/\303\213/e/g; # E
    $str =~ s/\303\217/i/g; # I
    $str =~ s/\303\226/o/g; # O
    $str =~ s/\303\234/u/g; # U

    ##  Ç = "\303\207"
    ##  ç = "\303\247"
    $str =~ s/\303\207/c/g; # C
    $str =~ s/\303\247/c/g; 

    return $str ;
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  remove circumflex accents and make lower case
sub rid_circum {
    my $str = $_[0] ;

    $str =~ s/\303\242/a/g; 
    $str =~ s/\303\252/e/g; 
    $str =~ s/\303\256/i/g; 
    $str =~ s/\303\264/o/g; 
    $str =~ s/\303\273/u/g; 
    $str =~ s/\303\202/a/g; # A
    $str =~ s/\303\212/e/g; # E
    $str =~ s/\303\216/i/g; # I
    $str =~ s/\303\224/o/g; # O
    $str =~ s/\303\233/u/g; # U
    
    return $str ;
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  uncontract circumflex accented words
##  see tables at bottom of this script
sub uncontract {
    my $str  = $_[0] ;
    my $next = $_[1];
    
    ##  "â"  could be "a la" or "hai a" or "havi a"
    ##  "ê"  could be "a li" or "haiu a"
    if ( $str ne "â" && $str ne "ê" ) {

	##  FIRST assume that the following are MISTAKEN contractions
   
	##  prepositions plus definite article   
	$str = ( $str eq "co"   ) ? "cu lu"  : $str;
	$str = ( $str eq "che"  ) ? "cu li"  : $str;
	
	$str = ( $str eq "du"   ) ? "di lu"   : $str;
	$str = ( $str eq "do"   ) ? "di lu"   : $str;
	$str = ( $str eq "de"   ) ? "di li"   : $str;
	
	$str = ( $str eq "pu"   ) ? "pi lu"   : $str;
	$str = ( $str eq "pa"   ) ? "pi la"   : $str;
	$str = ( $str eq "pe"   ) ? "pi li"   : $str;
	
	$str = ( $str eq "nno"  ) ? "nni lu"  : $str;
	$str = ( $str eq "nnu"  ) ? "nni lu"  : $str;
	$str = ( $str eq "nne"  ) ? "nni li"  : $str;
	
	$str = ( $str eq "nto"  ) ? "nta lu"  : $str;
	$str = ( $str eq "ntu"  ) ? "nta lu"  : $str;
	$str = ( $str eq "nte"  ) ? "nta li"  : $str;
	
	$str = ( $str eq "ntro" ) ? "ntra lu" : $str;
	$str = ( $str eq "ntre" ) ? "ntra li" : $str;
	
	##  prepositions plus indefinite article
	$str = ( $str eq "on"  ) ? "a un" : $str;
	$str = ( $str eq "cun" ) ? "c'un" : $str;
	$str = ( $str eq "dun" ) ? "d'un" : $str;
	$str = ( $str eq "pun" ) ? "p'un" : $str;
	
	$str = ( $str eq "nnun"  ) ? "nni un" : $str;
	$str = ( $str eq "ntun"  ) ? "nta un" : $str;
	
	$str = ( $str eq "ntrun" ) ? "ntra un" : $str;
	
	##  contractions of "aviri"    
	$str = ( $str eq "he" ) ? "haiu a" : $str;
	$str = ( $str eq "hanna" ) ? "hannu a" : $str;
    
	
	##  SECOND uncontract the PROPER contractions

	##  prepositions plus definite article
	$str = ( $str eq "ô"    ) ? "a lu"  : $str;
	
	$str = ( $str eq "cû"   ) ? "cu lu" : $str;
	$str = ( $str eq "cô"   ) ? "cu lu" : $str;
	$str = ( $str eq "câ"   ) ? "cu la" : $str;
	$str = ( $str eq "chî"  ) ? "cu li" : $str;
	$str = ( $str eq "chê"  ) ? "cu li" : $str;
	
	$str = ( $str eq "dû"   ) ? "di lu" : $str;
	$str = ( $str eq "dô"   ) ? "di lu" : $str;
	$str = ( $str eq "dâ"   ) ? "di la" : $str;
	$str = ( $str eq "dî"   ) ? "di li" : $str;
	$str = ( $str eq "dê"   ) ? "di li" : $str;
	
	$str = ( $str eq "pû"   ) ? "pi lu" : $str;
	$str = ( $str eq "pô"   ) ? "pi lu" : $str;
	$str = ( $str eq "pâ"   ) ? "pi la" : $str;
	$str = ( $str eq "pî"   ) ? "pi li" : $str;
	$str = ( $str eq "pê"   ) ? "pi li" : $str;
	
	$str = ( $str eq "nnû"   ) ? "nni lu" : $str;
	$str = ( $str eq "nnô"   ) ? "nni lu" : $str;
	$str = ( $str eq "nnâ"   ) ? "nni la" : $str;
	$str = ( $str eq "nnî"   ) ? "nni li" : $str;
	$str = ( $str eq "nnê"   ) ? "nni li" : $str;
	
	$str = ( $str eq "ntû"   ) ? "nta lu" : $str;
	$str = ( $str eq "ntô"   ) ? "nta lu" : $str;
	$str = ( $str eq "ntâ"   ) ? "nta la" : $str;
	$str = ( $str eq "ntî"   ) ? "nta li" : $str;
	$str = ( $str eq "ntê"   ) ? "nta li" : $str;
	
	$str = ( $str eq "ntrû"   ) ? "ntra lu" : $str;
	$str = ( $str eq "ntrô"   ) ? "ntra lu" : $str;
	$str = ( $str eq "ntrâ"   ) ? "ntra la" : $str;
	$str = ( $str eq "ntrî"   ) ? "ntra li" : $str;
	$str = ( $str eq "ntrê"   ) ? "ntra li" : $str;
	
	##  prepositions plus indefinite article
	$str = ( $str eq "ôn"  ) ? "a un" : $str;
	$str = ( $str eq "cûn" ) ? "c'un" : $str;
	$str = ( $str eq "dûn" ) ? "d'un" : $str;
	$str = ( $str eq "pûn" ) ? "p'un" : $str;

	$str = ( $str eq "nnûn"  ) ? "nn'un"  : $str;
	$str = ( $str eq "ntûn"  ) ? "nta un" : $str;
	$str = ( $str eq "ntôn"  ) ? "nta un" : $str;
    		               	      
	$str = ( $str eq "ntrôn" ) ? "ntra un" : $str;
	$str = ( $str eq "ntrûn" ) ? "ntra un" : $str;

	##  contractions of "aviri"    
	$str = ( $str eq "hê"    ) ? "haiu a"  : $str;
	$str = ( $str eq "hannâ" ) ? "hannu a" : $str;
	
	##  assume third person singular ... *sigh*
	$str = ( $str eq "hâ" ) ? "havi a" : $str;

    } else {
	##  "â"  could be "a la" or "hai a" or "havi a"
	##  "ê"  could be "a li" or "haiu a"
	if ( $next =~ /ari$/ || $next =~ /iri$/ ) {
	    ##  case where verb follows
	    ##  assume third person singular ... *sigh*
	    $str = ( $str eq "â" ) ? "havi a" : $str;
	    $str = ( $str eq "ê" ) ? "haiu a" : $str;	    
	} else {
	    ##  case where next is not a verb
	    $str = ( $str eq "â" ) ? "a la" : $str;
	    $str = ( $str eq "ê" ) ? "a li" : $str;
	}
    }
    
    return $str ;
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  CONTRACTIONS
##  ============

##  https://scn.wikipedia.org/wiki/Wikipedia:Gramm%C3%A0tica#Pripusizzioni_s%C3%A8mprici

##            |   lu           la       li           un
##   ------------------------------------------------------
##   a        |   ô            â        ê            ôn
##   cu       |   cû/cô        câ       chî/chê      c'un
##   di       |   dû/dô        dâ       dî/dê        d'un
##   pi       |   pû/pô        pâ       pî/pê        p'un
##   nna/nni  |   nnô/nnû      nnâ      nnê/nnî      nn'un
##   nta/nti  |   ntô/ntû      ntâ      ntê/ntî      nt'un
##   ntra     |   ntrô         ntrâ     ntrê         ntr'un 


##  https://www.napizia.com/cgi-bin/cchiu-da-palora.pl?palora=aviri

##   Hê {verb}. = Haiu a {verb}.
##   Hâ {verb}. = Hai a {verb}.
##   Hâ {verb}. = Havi a {verb}.
##   Amâ {verb}. = Avemu a {verb}.
##   Atâ {verb}. = Aviti a {verb}.
##   Hannâ {verb}. = Hannu a {verb}.

##   NB:  the "aviri" forms are usually written without the initial "h"
