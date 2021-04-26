package Napizia::Italian;

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
no warnings qw(uninitialized numeric void);

use Napizia::Translator;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT = ("it_detokenizer","it_tokenizer","it_capitalize");

##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  DETOKENIZATION
##  ==============

sub it_detokenizer {

    my $line = $_[0];
    $line = '<BOS> ' . $line . ' <EOS>';

    ##  reinsert spaces before and after punctuation
    #$line =~ s/([\,\.\?\!\:\;\%\}\]\)])/ $1 /g;
    
    ##  remove excess space
    $line =~ s/\s+/ /g;
    $line =~ s/^ //;
    $line =~ s/ $//;
    
    ##  capitalize and accent
    my $newline = it_capitalize( $line );
    $newline = fix_punctuation( $newline );
    
    ##  remaining punctuation
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

##  CAPITALIZATION
##  ==============

sub it_capitalize {

    my $line = $_[0];
    
    ##  split at spaces
    my @words = split( / / , $line );
    my @new_words ;
    for my $i (1..$#words-1) {
	my $prev = $words[$i-1];
	my $word = $words[$i];
	my $nxtw = $words[$i+1];

	##  convert to "è" and "sì"
	$word = ( $word eq "e'" ) ? "è" : $word ;
	$word = ( $word eq "si'" ) ? "sì" : $word ;

	##  male and female names
	my $female_names = '^maria$|^maddalena$|^lucia$';
	my $male_names = '^antonio$|^agostino$|^nicola$|^calogero$|^francesco$|^giuseppe$|^luca$';
	$male_names .= '|^martino$|^marco$|^arthur$|^gaetano$|^paolo$|^giovanni$|^filippo$|^pasquale$|^matteo$';
	$male_names .= '|^gesu$|^cristu$';
	
	##  saints and names
	$word = ( ( $word eq "santu" || $word eq "san" ) && $nxtw =~ /$male_names/ ) ? ucfirst($word) : $word ;
	$word = ( $word eq "santa" && $nxtw =~ /$female_names/  ) ? ucfirst($word) : $word ;
	$word = ( $word =~ /$male_names/ || $word =~ /$female_names/ ) ? ucfirst($word) : $word ;
	
	##  The Lord and Saint Francis of Paola
	$word = ( $prev eq "lu" && $word eq "signuri" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "diu" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "Gesu" || $word eq "gesu" ) ? "Gesù" : $word ;
	$word = ( $word eq "paola" ) ? ucfirst($word) : $word ;
	
	##  Roman numerals
	#$word = ( $word eq "i" ) ? uc($word) : $word ;
	$word = ( $word eq "ii" ) ? uc($word) : $word ;
	$word = ( $word eq "iii" ) ? uc($word) : $word ;
	$word = ( $word eq "iv" ) ? uc($word) : $word ;
	$word = ( $word eq "v" ) ? uc($word) : $word ;
	#$word = ( $word eq "vi" ) ? uc($word) : $word ;
	$word = ( $word eq "vii" ) ? uc($word) : $word ;
	$word = ( $word eq "viii" ) ? uc($word) : $word ;
	$word = ( $word eq "ix" ) ? uc($word) : $word ;
	$word = ( $word eq "x" ) ? uc($word) : $word ;
	$word = ( $word eq "xi" ) ? uc($word) : $word ;
	$word = ( $word eq "xii" ) ? uc($word) : $word ;
	$word = ( $word eq "xiii" ) ? uc($word) : $word ;
	$word = ( $word eq "xiv" ) ? uc($word) : $word ;
	$word = ( $word eq "xv" ) ? uc($word) : $word ;
	$word = ( $word eq "xvi" ) ? uc($word) : $word ;
	$word = ( $word eq "xvii" ) ? uc($word) : $word ;
	$word = ( $word eq "xviii" ) ? uc($word) : $word ;
	$word = ( $word eq "xix" ) ? uc($word) : $word ;
	$word = ( $word eq "xx" ) ? uc($word) : $word ;
	$word = ( $word eq "xxi" ) ? uc($word) : $word ;

	##  Sicily, Calabria and Puglia
	$word = ( $word eq "sicilia" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "calabria" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "calabbria" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "puglia" ) ? ucfirst($word) : $word ;

	##  Sicilian cities
	$word = ( $word eq "castellammare" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "trapani" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "castelvetrano" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "palermo" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "carini" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "partinico" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "messina" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "patti" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "girgenti" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "agrigento" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "caltanissetta" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "enna" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "catania" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "caltagirone" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "rausa" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "sarausa" ) ? ucfirst($word) : $word ;

	##  United States and American cities	
	$word = ( $prev eq "nord" && $word eq "america" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "nord" && $nxtw eq "america" ) ? ucfirst($word) : $word ;

	$word = ( $prev eq "sud" && $word eq "america" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "sud" && $nxtw eq "america" ) ? ucfirst($word) : $word ;

	$word = ( $word eq "america" ) ? ucfirst($word) : $word ;

	$word = ( $word eq "brucculino" ) ? ucfirst($word) : $word ;
	$word = ( $prev eq "new" && $word eq "york" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "new" && $nxtw eq "york" ) ? ucfirst($word) : $word ;

	$word = ( $prev eq "nova" && $word eq "york" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "nova" && $nxtw eq "york" ) ? ucfirst($word) : $word ;
	
	$word = ( $prev eq "new" && $word eq "jersey" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "new" && $nxtw eq "jersey" ) ? ucfirst($word) : $word ;

	$word = ( $word eq "california" ) ? ucfirst($word) : $word ;
	$word = ( $prev eq "los" && $word eq "angeles" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "los" && $nxtw eq "angeles" ) ? ucfirst($word) : $word ;

	$word = ( $prev eq "san" && $word eq "francisco" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "san" && $nxtw eq "francisco" ) ? ucfirst($word) : $word ;

	$word = ( $prev eq "san" && $word eq "diego" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "san" && $nxtw eq "diego" ) ? ucfirst($word) : $word ;

	$word = ( $word eq "louisiana" ) ? ucfirst($word) : $word ;
	$word = ( $prev eq "new" && $word eq "orleans" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "new" && $nxtw eq "orleans" ) ? ucfirst($word) : $word ;

	$word = ( $prev eq "stati" && $word eq "uniti" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "stati" && $nxtw eq "uniti" ) ? ucfirst($word) : $word ;
	
	##  Arba Sicula
	$word = ( $prev eq "arba" && $word eq "sicula" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "arba" && $nxtw eq "sicula" ) ? ucfirst($word) : $word ;
	$word = ( $prev eq "gaetano" && $word eq "cipolla" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "gaetano" && $nxtw eq "cipolla" ) ? ucfirst($word) : $word ;
	$word = ( $prev eq "arthur" && $word eq "dieli" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "arthur" && $nxtw eq "dieli" ) ? ucfirst($word) : $word ;
	$word = ( ( $prev eq "antonino" || $prev eq "nino" ) && $word eq "provenzano" ) ? ucfirst($word) : $word ;
	$word = ( ( $word eq "antonino" || $word eq "nino" ) && $nxtw eq "provenzano" ) ? ucfirst($word) : $word ;

	##  Sicilian Poets
	$word = ( $prev eq "giovanni" && $word eq "meli" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "giovanni" && $nxtw eq "meli" ) ? ucfirst($word) : $word ;	
	$word = ( ( $prev eq "carlo" || $prev eq "carlu" ) && $word eq "puleo" ) ? ucfirst($word) : $word ;
	$word = ( ( $word eq "carlo" || $word eq "carlu" ) && $nxtw eq "puleo" ) ? ucfirst($word) : $word ;
	$word = ( ( $prev eq "ignatius" || $prev eq "ignazio" ) && $word eq "buttitta" ) ? ucfirst($word) : $word ;
	$word = ( ( $word eq "ignatius" || $word eq "ignazio" ) && $nxtw eq "buttitta" ) ? ucfirst($word) : $word ; 
	
	##  which words to accent?
	$word = ( $word eq "perche" ) ? "perchè" : $word ;
	$word = ( $word eq "piu" ) ? "più" : $word ;
	$word = ( $word eq "verita" ) ? "verità" : $word ;
	$word = ( $word eq "citta" ) ? "città" : $word ;

	##  more fixes
	#$word = ( $word eq "in" ) ? "n" : $word ;

	##  capitalize beginning of sentences
	$word = ( $prev eq '<BOS>' && $word eq "è") ? "È" : $word ;
	$word = ( $prev eq '<BOS>' ) ? ucfirst($word) : $word ;
	$word = ( $prev eq '.' ) ? ucfirst($word) : $word ;
	$word = ( $prev eq '?' ) ? ucfirst($word) : $word ;
	$word = ( $prev eq '!' ) ? ucfirst($word) : $word ;
	
	##  push it out to the new word array
	push( @new_words , $word );
    }

    ##  join the words together
    my $newline = join( ' ' , @new_words );

    ##  return new line
    return $newline;
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  TOKENIZATION
##  ============

sub it_tokenizer {

    my $line = $_[0];

    ##  make it all lower case
    $line = lc( $line );
    $line =~ s/È/è/g;
    $line =~ s/É/è/g;
    $line =~ s/Ì/ì/g;
    $line =~ s/Í/ì/g;
    
    ##  separate punctuation, except apostrophe
    $line =~ s/([\-"\.,:;\!\?\(\)])/ $1 /g;
    
    ##  remove excess space
    $line =~ s/\s+/ /g;
    $line =~ s/^ //;
    $line =~ s/ $//;

    ##  add single space to beginning and end of line
    $line = " " . $line . " ";

    ##  replace "<<" and ">>" with single quote
    $line =~ s/«/ " /g;
    $line =~ s/»/ " /g;
    
    ##  make sure there are no double double quotes
    $line =~ s/"\s+"/ " /g;
    
    ##  remove excess space
    $line =~ s/\s+/ /g;

    ##  remove spaces after an apostrophe, except "è"
    $line =~ s/' /'/g;
    $line =~ s/'è /' e' /g;
    $line =~ s/'e'/' e' /g;
    $line =~ s/ c' e' / c'e' /g;
    
    ##  remove excess space, again
    $line =~ s/\s+/ /g;
    $line =~ s/^ //;
    $line =~ s/ $//;

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

1;
