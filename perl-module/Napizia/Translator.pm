package Napizia::Translator;

##  Copyright 2019-2026 Eryk Wdowiak
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
no warnings qw(uninitialized numeric void);

use utf8;

# use Napizia::Sicilian;
use Napizia::SicilianLS2;
use Napizia::English;
use Napizia::Italian;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT = ("tighten_text",
	       "rm_malice","fix_punctuation","swap_accents","finish_tilde","finish_accent",
	       "rid_accents","rid_circum","uncontract","mk_spoken");

##  ##  ##  ##  ##  ##  ##  ##  ##  ##

sub tighten_text {
    my $tight = $_[0];
    $tight =~ s/^" /"/;
    $tight =~ s/^' /'/;
    $tight =~ s/ "$/"/;
    $tight =~ s/ '$/'/;
    $tight =~ s/\$ (\d)/\$$1/g;
    $tight =~ s/(\d), (\d)/$1,$2/g;
    $tight =~ s/(\d)\. (\d)/$1\.$2/g;
    return $tight;
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  remove efforts to run Perl code with this script
##  and fix quotes and braces
sub rm_malice {
    my $str = $_[0] ;

    ##  remove malice
    $str =~ s/\@/ /g;
    $str =~ s/([\$\%\&])/$1 /g;
    $str =~ s/\`/'/g ;
    $str =~ s/ḍ/d/g;
    $str =~ s/Ḍ/D/g;
    
    ##  fix dashes
    $str =~ s/‐/-/g;
    $str =~ s/‑/-/g;
    $str =~ s/‒/-/g;
    $str =~ s/–/-/g;
    $str =~ s/—/-/g;
    $str =~ s/―/-/g;
    
    ##  fix quotes
    $str =~ s/‘/'/g ;
    $str =~ s/’/'/g ;
    $str =~ s/“/"/g ;
    $str =~ s/”/"/g ;
    $str =~ s/«/"/g ;
    $str =~ s/»/"/g ;

    ##  replace braces
    $str =~ s/\{/(/g;
    $str =~ s/\}/)/g;
    $str =~ s/\[/(/g;
    $str =~ s/\]/)/g;

    return $str ;
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  remove spaces before punctuation
sub fix_punctuation {

    my $line = $_[0];
    
    $line =~ s/ \././g;
    $line =~ s/ \?/?/g;
    $line =~ s/ \!/!/g;
    $line =~ s/ ,/,/g;
    $line =~ s/ ;/;/g;
    $line =~ s/ :/:/g;
    
    $line =~ s/ \%/\%/g;
    $line =~ s/\{ /\{/g;
    $line =~ s/ \}/\}/g;
    $line =~ s/\[ /\[/g;
    $line =~ s/ \]/\]/g;
    $line =~ s/\( /\(/g;
    $line =~ s/ \)/\)/g;

    return $line;
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  replace acute accents with lower case grave accents
sub swap_accents {
    my $str = $_[0] ;
    
    # ##  change acute accents to grave accents
    # $str =~ s/\303\241/\303\240/g; # á -> à
    # $str =~ s/\303\251/\303\250/g; # é -> è
    # $str =~ s/\303\255/\303\254/g; # í -> ì
    # $str =~ s/\303\263/\303\262/g; # ó -> ò
    # $str =~ s/\303\272/\303\271/g; # ú -> ù
    
    # $str =~ s/\303\201/\303\200/g; # Á -> À
    # $str =~ s/\303\211/\303\210/g; # É -> È
    # $str =~ s/\303\215/\303\214/g; # Í -> Ì
    # $str =~ s/\303\223/\303\222/g; # Ó -> Ò
    # $str =~ s/\303\232/\303\231/g; # Ú -> Ù 

    ##  change acute accents to grave accents
    $str =~ s/\303\241/à/g; # á -> à
    $str =~ s/\303\251/è/g; # é -> è
    $str =~ s/\303\255/ì/g; # í -> ì
    $str =~ s/\303\263/ò/g; # ó -> ò
    $str =~ s/\303\272/ù/g; # ú -> ù
    		        
    $str =~ s/\303\201/À/g; # Á -> À
    $str =~ s/\303\211/È/g; # É -> È
    $str =~ s/\303\215/Ì/g; # Í -> Ì
    $str =~ s/\303\223/Ò/g; # Ó -> Ò
    $str =~ s/\303\232/Ù/g; # Ú -> Ù 

    ##  change acute accents to grave accents
    $str =~ s/á/à/g; # á -> à
    $str =~ s/é/è/g; # é -> è
    $str =~ s/í/ì/g; # í -> ì
    $str =~ s/ó/ò/g; # ó -> ò
    $str =~ s/ú/ù/g; # ú -> ù
    	       	 
    $str =~ s/Á/À/g; # Á -> À
    $str =~ s/É/È/g; # É -> È
    $str =~ s/Í/Ì/g; # Í -> Ì
    $str =~ s/Ó/Ò/g; # Ó -> Ò
    $str =~ s/Ú/Ù/g; # Ú -> Ù 
    
    return $str ;
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  when word ends in "vowel + grave accent"
##  replace it with:  "vowel + tilde"
sub finish_tilde {
    my $word = $_[0] ;
    
    $word =~ s/\303\240$/a~/; # à -> a~
    $word =~ s/\303\250$/e~/; # è -> e~
    $word =~ s/\303\254$/i~/; # ì -> i~
    $word =~ s/\303\262$/o~/; # ò -> o~
    $word =~ s/\303\271$/u~/; # ù -> u~

    $word =~ s/\303\200$/A~/; # À -> A~
    $word =~ s/\303\210$/E~/; # È -> E~
    $word =~ s/\303\214$/I~/; # Ì -> I~
    $word =~ s/\303\222$/O~/; # Ò -> O~
    $word =~ s/\303\231$/U~/; # Ù -> U~

    $word =~ s/à$/a~/; # à -> a~
    $word =~ s/è$/e~/; # è -> e~
    $word =~ s/ì$/i~/; # ì -> i~
    $word =~ s/ò$/o~/; # ò -> o~
    $word =~ s/ù$/u~/; # ù -> u~
	        		 
    $word =~ s/À$/A~/; # À -> A~
    $word =~ s/È$/E~/; # È -> E~
    $word =~ s/Ì$/I~/; # Ì -> I~
    $word =~ s/Ò$/O~/; # Ò -> O~
    $word =~ s/Ù$/U~/; # Ù -> U~
    
    return $word ;
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  when word ends in "vowel + tilde"
##  replace it with:  "vowel + grave accent"
sub finish_accent {
    my $word = $_[0] ;
    
    # $word =~ s/a~$/\303\240/; # a~ -> à
    # $word =~ s/e~$/\303\250/; # e~ -> è
    # $word =~ s/i~$/\303\254/; # i~ -> ì
    # $word =~ s/o~$/\303\262/; # o~ -> ò
    # $word =~ s/u~$/\303\271/; # u~ -> ù
    
    # $word =~ s/A~$/\303\200/; # A~ -> À
    # $word =~ s/E~$/\303\210/; # E~ -> È
    # $word =~ s/I~$/\303\214/; # I~ -> Ì
    # $word =~ s/O~$/\303\222/; # O~ -> Ò
    # $word =~ s/U~$/\303\231/; # U~ -> Ù

    $word =~ s/a~$/à/; # a~ -> à
    $word =~ s/e~$/è/; # e~ -> è
    $word =~ s/i~$/ì/; # i~ -> ì
    $word =~ s/o~$/ò/; # o~ -> ò
    $word =~ s/u~$/ù/; # u~ -> ù
    
    $word =~ s/A~$/À/; # A~ -> À
    $word =~ s/E~$/È/; # E~ -> È
    $word =~ s/I~$/Ì/; # I~ -> Ì
    $word =~ s/O~$/Ò/; # O~ -> Ò
    $word =~ s/U~$/Ù/; # U~ -> Ù

    return $word ;
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  remove all accents except circumflex accents
##  and make lower case
sub rid_accents {
    my $str = $_[0] ;
    
    ##  rid grave accents
    $str =~ s/\303\240/a/g; # à -> a
    $str =~ s/\303\250/e/g; # è -> e
    $str =~ s/\303\254/i/g; # ì -> i
    $str =~ s/\303\262/o/g; # ò -> o
    $str =~ s/\303\271/u/g; # ù -> u
    
    $str =~ s/\303\200/A/g; # À -> A
    $str =~ s/\303\210/E/g; # È -> E
    $str =~ s/\303\214/I/g; # Ì -> I
    $str =~ s/\303\222/O/g; # Ò -> O
    $str =~ s/\303\231/U/g; # Ù -> U
    
    ##  rid acute accents
    $str =~ s/\303\241/a/g; 
    $str =~ s/\303\251/e/g; 
    $str =~ s/\303\255/i/g; 
    $str =~ s/\303\263/o/g; 
    $str =~ s/\303\272/u/g;
    
    $str =~ s/\303\201/A/g; # A
    $str =~ s/\303\211/E/g; # E
    $str =~ s/\303\215/I/g; # I
    $str =~ s/\303\223/O/g; # O
    $str =~ s/\303\232/U/g; # U
    
    ##  rid diaeresis accents
    $str =~ s/\303\244/a/g;
    $str =~ s/\303\253/e/g;
    $str =~ s/\303\257/i/g;
    $str =~ s/\303\266/o/g;
    $str =~ s/\303\274/u/g;
    
    $str =~ s/\303\204/A/g; # A
    $str =~ s/\303\213/E/g; # E
    $str =~ s/\303\217/I/g; # I
    $str =~ s/\303\226/O/g; # O
    $str =~ s/\303\234/U/g; # U

    ##  Ç = "\303\207"
    ##  ç = "\303\247"
    $str =~ s/\303\207/C/g; # C
    $str =~ s/\303\247/c/g; 

    ##  ##  ##  ##  ##  ##  ##

    ##  rid grave accents
    $str =~ s/à/a/g; # à -> a
    $str =~ s/è/e/g; # è -> e
    $str =~ s/ì/i/g; # ì -> i
    $str =~ s/ò/o/g; # ò -> o
    $str =~ s/ù/u/g; # ù -> u
    	       	       
    $str =~ s/À/A/g; # À -> A
    $str =~ s/È/E/g; # È -> E
    $str =~ s/Ì/I/g; # Ì -> I
    $str =~ s/Ò/O/g; # Ò -> O
    $str =~ s/Ù/U/g; # Ù -> U
    
    ##  rid acute accents
    $str =~ s/á/a/g; 
    $str =~ s/é/e/g; 
    $str =~ s/í/i/g; 
    $str =~ s/ó/o/g; 
    $str =~ s/ú/u/g;
	       
    $str =~ s/Á/A/g; # A
    $str =~ s/É/E/g; # E
    $str =~ s/Í/I/g; # I
    $str =~ s/Ó/O/g; # O
    $str =~ s/Ú/U/g; # U
    
    ##  rid diaeresis accents
    $str =~ s/ä/a/g;
    $str =~ s/ë/e/g;
    $str =~ s/ï/i/g;
    $str =~ s/ö/o/g;
    $str =~ s/ü/u/g;

    $str =~ s/Ä/A/g;
    $str =~ s/Ë/E/g;
    $str =~ s/Ï/I/g;
    $str =~ s/Ö/O/g;
    $str =~ s/Ü/U/g;
    
    ##  Ç = "\303\207"
    ##  ç = "\303\247"
    $str =~ s/Ç/C/g; # C
    $str =~ s/ç/c/g; 

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
    $str =~ s/\303\202/A/g; # A
    $str =~ s/\303\212/E/g; # E
    $str =~ s/\303\216/I/g; # I
    $str =~ s/\303\224/O/g; # O
    $str =~ s/\303\233/U/g; # U

    $str =~ s/â/a/g; 
    $str =~ s/ê/e/g; 
    $str =~ s/î/i/g; 
    $str =~ s/ô/o/g; 
    $str =~ s/û/u/g; 
    $str =~ s/Â/A/g; # A
    $str =~ s/Ê/E/g; # E
    $str =~ s/Î/I/g; # I
    $str =~ s/Ô/O/g; # O
    $str =~ s/Û/U/g; # U
    
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
	
	## $str = ( $str eq "du"   ) ? "di lu"   : $str;
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
	
	## ##  could also include "ata = aviti a"
	## ##  but we'll prefer to only uncontract the proper contraction
	## # $str = ( $str eq "ata"   ) ? "aviti a" : $str;
	
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
	$str = ( $str eq "amâ"   ) ? "avemu a" : $str;
	$str = ( $str eq "atâ"   ) ? "aviti a" : $str;
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

##  contract for "spoken voice"
##  see tables at bottom of this script
sub mk_spoken {
    my $str  = $_[0] ;
    
    ##  make it all lower case
    #$str = lc( $str );

    ##  add markers
    $str = '<BOS> ' . $str . ' <EOS>';
    
    ##  separate punctuation, except apostrophe
    $str =~ s/([\-"\.,:;\!\?\(\)])/ $1 /g;
    
    ##  remove excess space
    $str =~ s/\s+/ /g;
    $str =~ s/^ //;
    $str =~ s/ $//;

    ##  prepositions plus definite article
    $str=~ s/ a lu / ô /gi;
    $str=~ s/ a la / â /gi;
    $str=~ s/ a li / ê /gi;
    		    		             
    $str=~ s/ cu lu / cû /gi;
    #$str=~ s/ cu lu / cô /gi;
    $str=~ s/ cu la / câ /gi;
    $str=~ s/ cu li / chî /gi;
    #$str=~ s/ cu li / chê /gi;
    		    		             
    $str=~ s/ di lu / dû /gi;
    #$str=~ s/ di lu / dô /gi;
    $str=~ s/ di la / dâ /gi;
    $str=~ s/ di li / dî /gi;
    #$str=~ s/ di li / dê /gi;
    		    		             
    $str=~ s/ pi lu / pû /gi;
    #$str=~ s/ pi lu / pô /gi;
    $str=~ s/ pi la / pâ /gi;
    $str=~ s/ pi li / pî /gi;
    #$str=~ s/ pi li / pê /gi;
    		    		             
    #$str=~ s/ nni lu / nnû /gi;
    $str=~ s/ nni lu / nnô /gi;
    $str=~ s/ nni la / nnâ /gi;
    $str=~ s/ nni li / nnî /gi;
    #$str=~ s/ nni li / nnê /gi;
    		    		             
    #$str=~ s/ nta lu / ntû /gi;
    $str=~ s/ nta lu / ntô /gi;
    $str=~ s/ nta la / ntâ /gi;
    $str=~ s/ nta li / ntî /gi;
    #$str=~ s/ nta li / ntê /gi;
    		    		             
    #$str=~ s/ ntra lu / ntrû /gi;
    $str=~ s/ ntra lu / ntrô /gi;
    $str=~ s/ ntra la / ntrâ /gi;
    $str=~ s/ ntra li / ntrî /gi;
    #$str=~ s/ ntra li / ntrê /gi;
    
    ##  prepositions plus indefinite article
    $str =~ s/ a un / ôn /gi;
    $str =~ s/ cu un / c'un /gi;
    $str =~ s/ di un / d'un /gi;
    $str =~ s/ pi un / p'un /gi;
    
    $str =~ s/ nni un / nn'un /gi;
    $str =~ s/ nna un / nn'un /gi;

    #$str =~ s/ nta un / ntûn /gi;
    $str =~ s/ nta un / ntôn /gi;
    
    $str =~ s/ ntra un / ntrôn /gi;
    #$str =~ s/ ntra un / ntrûn /gi;
    
    ##  conjunctive pronoun contractions
    $str =~ s/ mi lu / mû /gi;
    $str =~ s/ mi la / mâ /gi;
    $str =~ s/ mi li / mî /gi;

    $str =~ s/ ti lu / tû /gi;
    $str =~ s/ ti la / tâ /gi;
    $str =~ s/ ti li / tî /gi;

    $str =~ s/ ci lu / ciû /gi;
    $str =~ s/ ci la / ciâ /gi;
    $str =~ s/ ci li / cî /gi;

    $str =~ s/ ni lu / nû /gi;
    $str =~ s/ ni la / nâ /gi;
    $str =~ s/ ni li / nî /gi;

    $str =~ s/ vi lu / vû /gi;
    $str =~ s/ vi la / vâ /gi;
    $str =~ s/ vi li / vî /gi;

    ##  third person reflexive + direct
    ##  difficult because "si" could either be pronoun or "if"
    ##  so we'll use apostrophe to cover both cases -- BAD HACK!
    # $str =~ s/ si lu / s'û /gi;
    # $str =~ s/ si la / s'â /gi;
    # $str =~ s/ si li / s'î /gi;
    
    ##  contractions of "aviri"
    $str =~ s/ haiu a ([a-z]*[ai]ri) / hê $1 /gi;
    $str =~ s/ hai a ([a-z]*[ai]ri) / hâ $1 /gi;
    $str =~ s/ havi a ([a-z]*[ai]ri) / hâ $1 /gi;
    $str =~ s/ avemu a ([a-z]*[ai]ri) / amâ $1 /gi;
    $str =~ s/ aviti a ([a-z]*[ai]ri) / atâ $1 /gi;
    $str =~ s/ hannu a ([a-z]*[ai]ri) / hannâ $1 /gi;

    ##  shorten definite articles
    # $str =~ s/ lu / u /gi;
    # $str =~ s/ la / a /gi;
    # $str =~ s/ li / i /gi;

    ##  more fixes
    # $str =~ s/ in / n /gi;

    ##  capitalize and accent
    my $newline = sc_capitalize( $str );
    $newline = fix_punctuation( $newline );
    
    ##  remaining punctuation
    # $newline =~ s/' /'/g;
    # $newline =~ s/ '/'/g;
    
    ##  remove excess space
    $newline =~ s/\s+/ /g;
    $newline =~ s/^ //;
    $newline =~ s/ $//;   

    ##  return contracted string
    return $newline ;
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

1;
