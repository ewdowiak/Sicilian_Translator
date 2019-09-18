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
no warnings qw(uninitialized numeric void);
use CGI qw(:standard);

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  INPUT AND CONFIG
##  ===== === ======

my $topnav = '../config/topnav.html';
my $footnv = '../config/navbar-footer.html';

my $lgparm = ( ! defined param('langs')  ) ? "scen" : lc( param('langs'));
$lgparm = ( $lgparm ne "scen" && $lgparm ne "ensc" ) ? "scen" : $lgparm;

my $intext = ( ! defined param('intext') ) ? "" : param('intext');
$intext = rm_malice( $intext );
$intext = ( $intext !~ /[0-9A-Za-zÀàÂâÁáÇçÈèÊêÉéÌìÎîÍíÏïÒòÔôÓóÙùÛûÚú]/ ) ? "" : $intext;
$intext =~ s/\n/ /g;
$intext =~ s/\s+/ /g;
$intext =~ s/^ //g;
$intext =~ s/ $//g;

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  TRANSLATE and DETOKENIZE
##  ========= === ==========

my $subwdnmt = "/home/eryk/.local/bin/subword-nmt";
my $subwords = ( $lgparm eq "scen" ) ? "subwords/subwords.sc" : "subwords/subwords.en";
my $transltr = ( $lgparm eq "scen" ) ? "nmt_sc-en.py" : "nmt_en-sc.py";

my $ottrans = "";
if ( $intext ne "" ) {
    my $tokenized = ( $lgparm eq "scen" ) ? sc_tokenizer($intext) : en_tokenizer($intext);
    my $subsplit  = `/bin/echo "$tokenized" | $subwdnmt apply-bpe -c $subwords`;
    chomp( $subsplit );
    my $output    = `/usr/bin/python3 $transltr "$subsplit"`;
    chomp( $output );
    $ottrans  = ( $lgparm eq "scen" ) ? en_detokenizer($output) : sc_detokenizer($output);
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  PRINT HTML
##  ===== ====

print mk_header( $topnav );
print mk_form( $lgparm , $intext );
print mk_ottrans( $ottrans );
print mk_footer( $footnv );

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  

##  SUBROUTINES
##  ===========

##  remove efforts to run Perl code with this script ... and fix quotes
sub rm_malice {
    my $str = $_[0] ;
    $str =~ s/\@/ /g;
    $str =~ s/([\$\%\&])/$1 /g;
    $str =~ s/\`/'/g ;
    $str =~ s/‘/'/g ;
    $str =~ s/’/'/g ;
    $str =~ s/“/"/g ;
    $str =~ s/”/"/g ;
    $str =~ s/«/"/g ;
    $str =~ s/»/"/g ;
    return $str ;
}

##  DETOKENIZATION SUBROUTINES
##  ============== ===========

sub sc_detokenizer {

    my $line = $_[0];
    $line = '<BOS> ' . $line . ' <EOS>';

    ##  reinsert spaces before and after punctuation
    $line =~ s/([\,\.\?\!\:\;\%\}\]\)])/ $1 /g;
    
    ##  remove excess space
    $line =~ s/\s+/ /g;
    $line =~ s/^ //;
    $line =~ s/ $//;
    
    ##  split at spaces
    my @words = split( / / , $line );
    my @new_words ;
    for my $i (1..$#words-1) {
	my $prev = $words[$i-1];
	my $word = $words[$i];
	my $nxtw = $words[$i+1];

	##  which words to capitalize?
	$word = ( $prev eq '<BOS>' ) ? ucfirst($word) : $word ;
	$word = ( $prev eq '.' ) ? ucfirst($word) : $word ;
	$word = ( $prev eq '?' ) ? ucfirst($word) : $word ;
	$word = ( $prev eq '!' ) ? ucfirst($word) : $word ;
	
	##  male and female names
	my $female_names = '^maria$|^maddalena$|^lucia$|^andria$';
	my $male_names = '^antoni$|^agustinu$|^nicola$|^calogiru$|^caloiru$|^franciscu$|^giuseppi$|^luca$|';
	$male_names .= '^jachinu$|^gaitanu$|^binidittu$|^martinu$|^tumasi$|^marcu$';

	##  saints and names
	$word = ( ( $word eq "santu" || $word eq "san" ) && $nxtw =~ /$male_names/ ) ? ucfirst($word) : $word ;
	$word = ( $word eq "santa" && $nxtw =~ /$female_names/  ) ? ucfirst($word) : $word ;
	$word = ( $word =~ /$male_names/ || $word =~ /$female_names/ ) ? ucfirst($word) : $word ;
	
	##  The Lord and Saint Francis of Paola
	$word = ( $prev eq "lu" && $word eq "signuri" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "diu" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "paula" ) ? ucfirst($word) : $word ;

	##  Sicily, Calabria and Puglia
	$word = ( $word eq "sicilia" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "calabbria" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "pugghia" ) ? ucfirst($word) : $word ;

	##  Sicilian cities
	$word = ( $word eq "casteddammari" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "trapani" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "castedduvitranu" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "palermu" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "carini" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "partinicu" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "missina" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "patti" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "girgenti" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "agrigentu" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "nissa" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "enna" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "catania" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "cartagiruni" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "rausa" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "sarausa" ) ? ucfirst($word) : $word ;

	##  American cities
	$word = ( $word eq "brucculinu" ) ? ucfirst($word) : $word ;
	$word = ( $prev eq "new" && $word eq "york" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "new" && $nxtw eq "york" ) ? ucfirst($word) : $word ;
	$word = ( $prev eq "new" && $word eq "orleans" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "new" && $nxtw eq "orleans" ) ? ucfirst($word) : $word ;
	
	##  which words to accent?
	$word = ( $word eq "e'" ) ? "è" : $word ;
	$word = ( $word eq "si'" ) ? "sì" : $word ;
	$word = ( $word eq "pirchi" ) ? "pirchì" : $word ;
	$word = ( $word eq "chiu" ) ? "chiù" : $word ;
	$word = ( $word eq "autru" ) ? "àutru" : $word ;
	$word = ( $word eq "autra" ) ? "àutra" : $word ;
	$word = ( $word eq "autri" ) ? "àutri" : $word ;
	$word = ( $word eq "me" ) ? "mè" : $word ;
	$word = ( $word eq "to" ) ? "tò" : $word ;
	$word = ( $word eq "so" ) ? "sò" : $word ;
	$word = ( $word eq "po" ) ? "pò" : $word ;

	##  push it out to the new word array
	push( @new_words , $word );
    }
    
    ##  join the words together
    my $newline = join( ' ' , @new_words );

    ##  fix punctuation
    $newline =~ s/ \././g;
    $newline =~ s/ \?/?/g;
    $newline =~ s/ \!/!/g;
    $newline =~ s/ ,/,/g;
    $newline =~ s/ ;/;/g;
    $newline =~ s/ :/:/g;
    
    $newline =~ s/ \%/\%/g;
    $newline =~ s/\{ /\{/g;
    $newline =~ s/ \}/\}/g;
    $newline =~ s/\[ /\[/g;
    $newline =~ s/ \]/\]/g;
    $newline =~ s/\( /\(/g;
    $newline =~ s/ \)/\)/g;

    $newline =~ s/' /'/g;
    $newline =~ s/ '/'/g;
    
    ##  remove excess space
    $newline =~ s/\s+/ /g;
    $newline =~ s/^ //;
    $newline =~ s/ $//;

    ##  return the detokenized line
    return $newline;
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##

sub en_detokenizer {

    my $line = $_[0];
    $line = '<BOS> ' . $line . ' <EOS>';

    ##  reinsert spaces before and after punctuation
    $line =~ s/([\,\.\?\!\:\;\%\}\]\)])/ $1 /g;
    
    ##  remove excess space
    $line =~ s/\s+/ /g;
    $line =~ s/^ //;
    $line =~ s/ $//;
    
    ##  split at spaces
    my @words = split( / / , $line );
    my @new_words ;
    for my $i (1..$#words-1) {
	my $prev = $words[$i-1];
	my $word = $words[$i];
	my $nxtw = $words[$i+1];

	##  which words to capitalize?
	$word = ( $prev eq '<BOS>' ) ? ucfirst($word) : $word ;
	$word = ( $prev eq '.' ) ? ucfirst($word) : $word ;
	$word = ( $prev eq '?' ) ? ucfirst($word) : $word ;
	$word = ( $prev eq '!' ) ? ucfirst($word) : $word ;
	
	##  male and female names
	my $first_names = '^andrea$|^andrew$|^anthony$|^augustine$|^benedict$|^calogero$|^crispin$|';
	$first_names .= '^francis$|^gaetano$|^joachim$|^joseph$|^lucy$|^magdalene$|^mark$|^martin$|';
	$first_names .= '^mary$|^michael$|^nicholas$|^simeon$|^simon$|^thomas$|^vito$';
	
	##  saints and names
	$word = ( $word eq "saint" && $nxtw =~ /$first_names/ ) ? ucfirst($word) : $word ;
	$word = ( $word =~ /$first_names/ ) ? ucfirst($word) : $word ;
	
	##  The Lord and Saint Francis of Paola
	$word = ( $prev eq "the" && $word eq "lord" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "god" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "paola" ) ? ucfirst($word) : $word ;

	##  Sicily, Calabria and Puglia
	$word = ( $word eq "sicily" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "calabria" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "puglia" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "apulia" ) ? ucfirst($word) : $word ;

	##  Sicilian cities
	$word = ( $word eq "castellammare" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "trapani" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "castelvetrano" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "palermo" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "carini" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "partinico" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "messina" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "patti" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "agrigento" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "caltanissetta" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "enna" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "catania" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "caltagirone" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "ragusa" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "syracuse" ) ? ucfirst($word) : $word ;
	
	##  American cities
	$word = ( $word eq "brooklyn" ) ? ucfirst($word) : $word ;
	$word = ( $prev eq "new" && $word eq "york" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "new" && $nxtw eq "york" ) ? ucfirst($word) : $word ;
	$word = ( $prev eq "new" && $word eq "orleans" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "new" && $nxtw eq "orleans" ) ? ucfirst($word) : $word ;
	
	##  push it out to the new word array
	push( @new_words , $word );
    }
    
    ##  join the words together
    my $newline = join( ' ' , @new_words );

    ##  fix punctuation
    $newline =~ s/ \././g;
    $newline =~ s/ \?/?/g;
    $newline =~ s/ \!/!/g;
    $newline =~ s/ ,/,/g;
    $newline =~ s/ ;/;/g;
    $newline =~ s/ :/:/g;
    
    $newline =~ s/ \%/\%/g;
    $newline =~ s/\{ /\{/g;
    $newline =~ s/ \}/\}/g;
    $newline =~ s/\[ /\[/g;
    $newline =~ s/ \]/\]/g;
    $newline =~ s/\( /\(/g;
    $newline =~ s/ \)/\)/g;

    $newline =~ s/ '/'/g;
    $newline =~ s/([a-rt-y])' /$1'/g;
    
    ##  remove excess space
    $newline =~ s/\s+/ /g;
    $newline =~ s/^ //;
    $newline =~ s/ $//;

    ##  return the detokenized line
    return $newline;
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  TOKENIZATION SUBROUTINES
##  ============ ===========

##  Sicilian tokenizer
sub sc_tokenizer {

    my $line = $_[0];

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

    return $newline;
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  English tokenizer 
sub en_tokenizer {

    my $line = $_[0];

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

    return $line;
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

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

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  HTML SUBROUTINES
##  ==== ===========

##  make HTML header
sub mk_header {

    ##  top navigation panel
    my $topnav = $_[0] ;

    ##  prepare output HTML
    my $ottxt ;
    $ottxt .= "Content-type: text/html\n\n";
    $ottxt .= '<!DOCTYPE html>' . "\n" ;
    $ottxt .= '<html>' . "\n" ;
    $ottxt .= '  <head>' . "\n" ;
    $ottxt .= '    <title>Tradutturi Sicilianu :: Napizia</title>' ."\n";
    $ottxt .= '    <meta name="DESCRIPTION" content="Traduci fra Ngrisi e Sicilianu. '."\n";
    $ottxt .= '          Translates between English and Sicilian.">' ."\n";
    $ottxt .= '    <meta name="KEYWORDS" content="translator, Sicilian, English, natural language, NLP">' ."\n";
    $ottxt .= '    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">' . "\n" ;
    $ottxt .= '    <meta name="Author" content="Eryk Wdowiak">' . "\n" ;
    $ottxt .= '    <link rel="stylesheet" type="text/css" href="/css/eryk.css">' . "\n" ;
    $ottxt .= '    <link rel="stylesheet" type="text/css" href="/css/eryk_theme-blue.css">' . "\n" ;
    $ottxt .= '    <link rel="stylesheet" type="text/css" href="/css/eryk_widenme.css">' . "\n" ;
    $ottxt .= '    <link rel="stylesheet" type="text/css" href="/css/dieli_forms.css">' . "\n" ;
    $ottxt .= '    <link rel="icon" type="image/png" href="/config/napizia-icon.png">' . "\n" ;
    $ottxt .= "\n";
    ##  $ottxt .= '    <link rel="search" type="application/opensearchdescription+xml"'."\n";
    ##  $ottxt .= '          title="SC-EN Dieli Dict"'."\n";
    ##  $ottxt .= '          href="https://www.napizia.com/pages/sicilian/search/dieli_sc-en.xml">'."\n";
    ##  $ottxt .= '    <link rel="search" type="application/opensearchdescription+xml"'."\n";
    ##  $ottxt .= '          title="SC-IT Dieli Dict"'."\n";
    ##  $ottxt .= '          href="https://www.napizia.com/pages/sicilian/search/dieli_sc-it.xml">'."\n";
    ##  $ottxt .= '    <link rel="search" type="application/opensearchdescription+xml"'."\n";
    ##  $ottxt .= '          title="EN-SC Dieli Dict"'."\n";
    ##  $ottxt .= '          href="https://www.napizia.com/pages/sicilian/search/dieli_en-sc.xml">'."\n";
    ##  $ottxt .= '    <link rel="search" type="application/opensearchdescription+xml"'."\n";
    ##  $ottxt .= '          title="IT-SC Dieli Dict"'."\n";
    ##  $ottxt .= '          href="https://www.napizia.com/pages/sicilian/search/dieli_it-sc.xml">'."\n";
    ##  $ottxt .= '    <link rel="search" type="application/opensearchdescription+xml"'."\n";
    ##  $ottxt .= '          title="Trova na Palora"'."\n";
    ##  $ottxt .= '          href="https://www.napizia.com/pages/sicilian/search/trova-palora.xml">'."\n";
    ##  $ottxt .= '    <link rel="search" type="application/opensearchdescription+xml"'."\n";
    ##  $ottxt .= '          title="Cosine Sim Skipgram"'."\n";
    ##  $ottxt .= '          href="https://www.napizia.com/pages/sicilian/search/cosine-sim_skip.xml">'."\n";
    ##  $ottxt .= '    <link rel="search" type="application/opensearchdescription+xml"'."\n";
    ##  $ottxt .= '          title="Cosine Sim CBOW"'."\n";
    ##  $ottxt .= '          href="https://www.napizia.com/pages/sicilian/search/cosine-sim_cbow.xml">'."\n";
    ##  $ottxt .= "\n";
    $ottxt .= '    <meta name="viewport" content="width=device-width, initial-scale=1">' . "\n" ;
    $ottxt .= '    <style>' . "\n" ;
    $ottxt .= '    p.zero { margin-top: 0em; margin-bottom: 0em; }' . "\n" ;
    $ottxt .= '    div.transconj { position: relative; margin: auto; width: 50%;}' . "\n" ;
    $ottxt .= '    @media only screen and (max-width: 835px) { ' . "\n" ;
    $ottxt .= '        div.transconj { position: relative; margin: auto; width: 90%;}' . "\n" ;
    $ottxt .= '    }' . "\n" ;

    ## ##  spacing for second column of Dieli collections
    ## ##  now handled by "eryk_widenme.css"
    ## $ottxt .= '    ul.ddcoltwo { margin-top: 0em; }' . "\n" ;
    ## $ottxt .= '    @media only screen and (min-width: 600px) { ' . "\n" ;
    ## $ottxt .= '        ul.ddcoltwo { margin-top: 2.25em; }' . "\n" ;
    ## $ottxt .= '    }' . "\n" ;
    
    $ottxt .= '    </style>' . "\n" ;
    $ottxt .= '  </head>' . "\n" ;

    open( TOPNAV , $topnav ) || die "could not read:  $topnav";
    while(<TOPNAV>){ chomp;  $ottxt .= $_ . "\n" ; };
    close TOPNAV ;

    $ottxt .= '  <!-- begin row div -->' . "\n" ;
    $ottxt .= '  <div class="row">' . "\n" ;
    $ottxt .= '    <div class="col-m-12 col-12">' . "\n" ;
    $ottxt .= '      <h1>Tradutturi Sicilianu</h1>'."\n";
    $ottxt .= '    </div>' . "\n" ;
    $ottxt .= '  </div>' . "\n" ;
    $ottxt .= '  <!-- end row div -->' . "\n" ;
    $ottxt .= '  ' . "\n" ;
    
    return $ottxt ;
}

##  make footer
sub mk_footer {

    ##  footer navigation
    my $footnv = $_[0] ; 

    ##  prepare output
    my $othtml ;
    
    ##  open instruction div
    $othtml .= '<div class="row" style="margin: 15px 0px 5px 0px; border: 1px solid black; background-color: rgb(255,255,204);">'."\n";

    $othtml .= '<div class="col-m-12 col-6" style="padding: 0px 10px;">'."\n";
    $othtml .= '<p style="margin-top: 0.5em; margin-bottom: 0.25em; padding-left: 0px;">'."\n";
    $othtml .= '<b>Stu tradutturi traduci malamenti!</b>  È na prova pi aiutarinni a criari '."\n";
    $othtml .= 'un bon tradutturi pi la lingua siciliana. Si prega di leggiri la '."\n";
    $othtml .= '<a href="https://www.napizia.com/pages/sicilian/translator.shtml">spiegazioni</a>.</p>'."\n";
    $othtml .= '  </div>'."\n";

    $othtml .= '<div class="col-m-12 col-6" style="padding: 0px 10px;">'."\n";
    $othtml .= '<p style="margin-top: 0.5em; margin-bottom: 0.25em; padding-left: 0px;">'."\n";
    $othtml .= '<b>This translator translates badly!</b>  It is an experiment to help us '."\n";
    $othtml .= 'create a good translator for the Sicilian language.  Please read the '."\n";
    $othtml .= '<a href="https://www.napizia.com/pages/sicilian/translator.shtml">explanation</a>.</p>'."\n";
    $othtml .= '</div>'."\n";

    ##  close instruction div
    $othtml .= '</div>'."\n";

    open( FOOTNAV , $footnv ) || die "could not read:  $footnv";
    while(<FOOTNAV>){ chomp;  $othtml .= $_ ."\n"; };
    close FOOTNAV ;
    
    return $othtml ;
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  make form
sub mk_form {

    ##  embedding and search
    my $lgparm  = $_[0]; 
    my $intext = $_[1];
    
    my $ottxt ;
    $ottxt .= '<!-- begin row div -->' . "\n";
    $ottxt .= '<div class="row">' ."\n";
    $ottxt .= '<!-- begin box div -->' . "\n";
    $ottxt .= '<div class="col-m-12 col-6"">' ."\n";

    $ottxt .= '<form enctype="multipart/form-data" action="/cgi-bin/index.pl" method="post">'."\n";
    $ottxt .= '<table style="max-width:500px;"><tbody>'."\n";

    $ottxt .= '<tr>' ;
    $ottxt .= '<td colspan="2">' ;
    $ottxt .= '<textarea name="intext" style="width: 100%; height:100px; font-size: 14px;" maxlength="500">'."\n";
    $ottxt .= $intext ;
    $ottxt .= '</textarea>'."\n";
    $ottxt .= '</td></tr>'."\n";
    $ottxt .= '<tr>'."\n"; 
    $ottxt .= '<td>'."\n"; 
    $ottxt .= '<select name="langs">'."\n";
    if ( $lgparm ne "scen" ) {
	$ottxt .= '<option value="ensc">Ngrisi-Sicilianu' ."\n";
	$ottxt .= '<option value="scen">Sicilianu-Ngrisi' ."\n";
    } else {
	$ottxt .= '<option value="scen">Sicilianu-Ngrisi' ."\n";
	$ottxt .= '<option value="ensc">Ngrisi-Sicilianu' ."\n";
    }
    $ottxt .= '</select>'."\n";
    $ottxt .= '</td>'."\n";
    $ottxt .= '<td align="right">' . '<input type="submit" value="Traduci">'."\n";
    ## $ottxt .= '<input type=reset value="Clear Form">'."\n"; 
    $ottxt .= '</td>'."\n";
    $ottxt .= '</tr>'."\n";
    $ottxt .= '</tbody></table>'."\n";
    $ottxt .= '</form>'."\n";
        
    $ottxt .= '</div>' . "\n" ;
    $ottxt .= '<!-- end box div -->' ."\n";

    return $ottxt ;
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

sub mk_ottrans {

    ##  embedding and search
    my $ottrans = $_[0];
    
    my $ottxt ;
    $ottxt .= '<!-- begin ottrans div -->' . "\n";
    $ottxt .= '<div class="col-m-12 col-6">'."\n";
    $ottxt .= '<div style="min-height: 100px; '."\n";
    $ottxt .= ' padding: 0px 7px; margin: 4px auto; border: 1px solid rgb(2, 78, 168);">'."\n";

    $ottxt .= '<p style="margin-top: 0.5em; margin-bottom: 0.5em;">' . $ottrans . '</p>'."\n";
    
    $ottxt .= '</div>' . "\n" ;
    $ottxt .= '</div>' . "\n" ;
    $ottxt .= '<!-- end ottrans div -->' ."\n";
    $ottxt .= '</div>' . "\n" ;
    $ottxt .= '<!-- end row div -->' ."\n";

    return $ottxt ;
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

