package Napizia::Italian;

##  Copyright 2021-2026 Eryk Wdowiak
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

# use Napizia::Translator;
sub finish_accent { Napizia::Translator::finish_accent($_[0]); }
sub fix_punctuation { Napizia::Translator::fix_punctuation($_[0]); }
sub swap_accents { Napizia::Translator::swap_accents( $_[0] ); }
sub finish_tilde { Napizia::Translator::finish_tilde( $_[0] ); }
sub rid_accents { Napizia::Translator::rid_accents( $_[0] ); }
sub uncontract { Napizia::Translator::uncontract( $_[0] , $_[1] ); }
sub rid_circum { Napizia::Translator::rid_circum(  $_[0] ); }

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
    
    # ##  capitalize, accent and fix punctuation
    my $newline = it_capitalize( $line );
    $newline = fix_punctuation( $newline );
    
    ##  remaining punctuation
    # $newline =~ s/' /'/g;
    # $newline =~ s/ '/'/g;
    $newline =~ s/c' /c'/g;
    $newline =~ s/C' /C'/g;
    $newline =~ s/d' /d'/g;
    $newline =~ s/D' /D'/g;
    $newline =~ s/l' /l'/g;
    $newline =~ s/L' /L'/g;
    $newline =~ s/m' /m'/g;
    $newline =~ s/M' /M'/g;
    $newline =~ s/n' /n'/g;
    $newline =~ s/N' /N'/g;
    # $newline =~ s/p' /p'/g;
    # $newline =~ s/P' /P'/g;
    $newline =~ s/s' /s'/g;
    $newline =~ s/S' /S'/g;
    $newline =~ s/t' /t'/g;
    $newline =~ s/T' /T'/g;
    $newline =~ s/v' /v'/g;
    $newline =~ s/V' /V'/g;

    ##  remove excess space
    $newline =~ s/\s+/ /g;
    $newline =~ s/^ //;
    $newline =~ s/ $//;

    ##  return the detokenized line
    return $newline;
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  CAPITALIZATION AND ACCENTS
##  ==========================

sub it_capitalize {

    my $line = $_[0];

    ##  retrieve caps hash
    my %itcaps  = mk_it_capshash();
    
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
	
	##  world leaders in translation technology
	$word = ( $word eq "napizia" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "facebook" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "google" ) ? ucfirst($word) : $word ;

	##  run through the capitalization list
	$word = ( ! defined $itcaps{$word} ) ? $word : $itcaps{$word} ;
	
	##  which words to accent?
	$word = ( $word eq "perche" ) ? "perchè" : $word ;
	$word = ( $word eq "piu" ) ? "più" : $word ;
	$word = ( $word eq "verita" ) ? "verità" : $word ;
	$word = ( $word eq "citta" ) ? "città" : $word ;
	
	##  capitalize beginning of sentences
	$word = ( $prev eq '<BOS>' && $word eq "è") ? "È" : $word ;
	$word = ( $prev eq '<BOS>' ) ? ucfirst($word) : $word ;
	$word = ( $i == 2 && $prev eq '"' ) ? ucfirst($word) : $word ;
	$word = ( $i == 2 && $prev eq "'" ) ? ucfirst($word) : $word ;	
	$word = ( $prev eq '.' ) ? ucfirst($word) : $word ;
	$word = ( $prev eq '?' ) ? ucfirst($word) : $word ;
	$word = ( $prev eq '!' ) ? ucfirst($word) : $word ;

	##  add accents to last letter (if appropriate)
	$word = finish_accent( $word );
	
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
    
    ##  replace acute accents with grave accents
    $line = swap_accents( $line );
    
    ##  separate punctuation, except apostrophe
    $line =~ s/([\-"\.,:;\!\?\(\)])/ $1 /g;
    
    ##  remove excess space
    $line =~ s/\s+/ /g;
    $line =~ s/^ //;
    $line =~ s/ $//;

    ##  add single space to beginning and end of line
    $line = " " . $line . " ";
    
    ##  convert:  c'e' -- n'e' -- e' -- si'
    $line =~ s/ c'e' / c'e~ /g;
    $line =~ s/ c'è / c'e~ /g;
    $line =~ s/ n'e' / n'e~ /g;
    $line =~ s/ n'è / n'e~ /g;
    $line =~ s/ e' / e~ /g;
    $line =~ s/ è / e~ /g;
    $line =~ s/ si' / si~ /g;
    $line =~ s/ sì / si~ /g;
    
    ##  replace "<<" and ">>" with single quote
    $line =~ s/«/ " /g;
    $line =~ s/»/ " /g;
    
    ##  make sure there are no double double quotes
    $line =~ s/"\s+"/ " /g;
    
    ##  remove excess space
    $line =~ s/\s+/ /g;
    $line =~ s/^ //;
    $line =~ s/ $//;
    
    ##  remove accents from each word
    ##  except ("è" = "is") and ("sì" = "you are")
    ##  and uncontract circumflex accents words
    my @words = split( / / , $line );
    my @no_accents ; 
    for my $i (0..$#words) {

	##  which word
	my $word = $words[$i];
	# my $next_word = ( $i != $#words ) ? $words[$i+1] : "";
	
	##  remove accents
	my $new_word = finish_tilde( $word ) ;
	$new_word = rid_accents( $new_word );
	
	##  replacements
	$new_word = ( $new_word eq "ne~" ) ? "ne" : $new_word;
	$new_word = ( $new_word eq "piu~"  ) ? "piu" : $new_word;
	$new_word = ( $new_word eq "perche~" ) ? "perche" : $new_word;
	$new_word = ( $new_word eq "percio~" ) ? "percio" : $new_word;
	
	##  push it out
	push( @no_accents , $new_word );	
    }

    ##  join it all together
    my $newline = join( ' ' , @no_accents );

    ##  remove any remaining accents
    $newline = rid_accents( $newline );
    $newline = rid_circum(  $newline );
    $newline = lc(  $newline );
    
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

##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  MAKE CAPS LIST
##  ==============

sub mk_it_capshash {

    my %itcaps  = (
	"abimelech" => "Abimelech",  ##  Abimelech -- 134
	"abner" => "Abner",  ##  Abner -- 128
	"abraham" => "Abraham",  ##  Abraham -- 135
	"abram" => "Abram",  ##  Abram -- 126
	"abramo" => "Abramo",  ##  Abramo -- 553
	"abu" => "Abu",  ##  Abu -- 127
	"acab" => "Acab",  ##  Acab -- 181
	# "academy" => "Academy",  ##  Academy -- 226
	# "act" => "Act",  ##  Act -- 313 :: act -- 5
	"adam" => "Adam",  ##  Adam -- 248 :: adam -- 2
	"adams" => "Adams",  ##  Adams -- 180 :: adams -- 1
	"adelaide" => "Adelaide",  ##  Adelaide -- 111
	"adele" => "Adele",  ##  Adele -- 137
	"afghanistan" => "Afghanistan",  ##  Afghanistan -- 168
	"africa" => "Africa",  ##  Africa -- 534 :: africa -- 1
	# "ah" => "Ah",  ##  Ah -- 331 :: ah -- 33
	# "air" => "Air",  ##  Air -- 548 :: air -- 11
	# "aires" => "Aires",  ##  Aires -- 154
	"alan" => "Alan",  ##  Alan -- 134
	"albania" => "Albania",  ##  Albania -- 162
	"albert" => "Albert",  ##  Albert -- 243
	"alberto" => "Alberto",  ##  Alberto -- 111
	"aleksandrovic" => "Aleksandrovic",  ##  Aleksandrovic -- 559
	"aleksandrovna" => "Aleksandrovna",  ##  Aleksandrovna -- 218
	"aleksej" => "Aleksej",  ##  Aleksej -- 621
	"alessandro" => "Alessandro",  ##  Alessandro -- 282
	"alex" => "Alex",  ##  Alex -- 154
	"alexander" => "Alexander",  ##  Alexander -- 328
	"alfonso" => "Alfonso",  ##  Alfonso -- 115 :: alfonso -- 1
	"alfred" => "Alfred",  ##  Alfred -- 157
	"alice" => "Alice",  ##  Alice -- 535 :: alice -- 1
	# "all" => "All",  ##  All -- 218 :: all -- 41
	"allen" => "Allen",  ##  Allen -- 211
	"aman" => "Aman",  ##  Aman -- 109
	"america" => "America",  ##  America -- 1243 :: america -- 3
	# "american" => "American",  ##  American -- 475
	"americhe" => "Americhe",  ##  Americhe -- 115
	# "ammoniti" => "Ammoniti",  ##  Ammoniti -- 210 :: ammoniti -- 2
	# "amorrei" => "Amorrei",  ##  Amorrei -- 135 :: amorrei -- 6
	"amsterdam" => "Amsterdam",  ##  Amsterdam -- 217
	"anderson" => "Anderson",  ##  Anderson -- 172
	"andrea" => "Andrea",  ##  Andrea -- 142 :: andrea -- 2
	"andrew" => "Andrew",  ##  Andrew -- 194
	"android" => "Android",  ##  Android -- 129
	# "angeles" => "Angeles",  ##  Angeles -- 546 :: angeles -- 1
	"anna" => "Anna",  ##  Anna -- 1224 :: anna -- 1
	"anne" => "Anne",  ##  Anne -- 136
	"antonio" => "Antonio",  ##  Antonio -- 400
	"apollo" => "Apollo",  ##  Apollo -- 115 :: apollo -- 6
	"arabia" => "Arabia",  ##  Arabia -- 169
	"aram" => "Aram",  ##  Aram -- 160
	"aramei" => "Aramei",  ##  Aramei -- 135 :: aramei -- 3
	"argentina" => "Argentina",  ##  Argentina -- 172 :: argentina -- 34
	"armenia" => "Armenia",  ##  Armenia -- 138
	# "army" => "Army",  ##  Army -- 154
	"arnold" => "Arnold",  ##  Arnold -- 120
	"aronne" => "Aronne",  ##  Aronne -- 689
	# "art" => "Art",  ##  Art -- 241 :: art -- 64
	"arthur" => "Arthur",  ##  Arthur -- 254
	# "arts" => "Arts",  ##  Arts -- 266 :: arts -- 14
	"asa" => "Asa",  ##  Asa -- 119 :: asa -- 1
	"asia" => "Asia",  ##  Asia -- 370 :: asia -- 4
	"assalonne" => "Assalonne",  ##  Assalonne -- 221
	"assiria" => "Assiria",  ##  Assiria -- 123
	# "association" => "Association",  ##  Association -- 380 :: association -- 3
	"atene" => "Atene",  ##  Atene -- 265
	"atlanta" => "Atlanta",  ##  Atlanta -- 109
	"austin" => "Austin",  ##  Austin -- 108
	"australia" => "Australia",  ##  Australia -- 525 :: australia -- 2
	"austria" => "Austria",  ##  Austria -- 308
	# "avenue" => "Avenue",  ##  Avenue -- 117 :: avenue -- 4
	# "award" => "Award",  ##  Award -- 274 :: award -- 5
	# "awards" => "Awards",  ##  Awards -- 119 :: awards -- 5
	"azerbaigian" => "Azerbaigian",  ##  Azerbaigian -- 144
	"baal" => "Baal",  ##  Baal -- 379 :: baal -- 3
	"babilonia" => "Babilonia",  ##  Babilonia -- 651 :: babilonia -- 2
	"bach" => "Bach",  ##  Bach -- 126
	"baghdad" => "Baghdad",  ##  Baghdad -- 107
	"baker" => "Baker",  ##  Baker -- 156
	"balaam" => "Balaam",  ##  Balaam -- 143
	# "ballet" => "Ballet",  ##  Ballet -- 499 :: ballet -- 4
	# "bank" => "Bank",  ##  Bank -- 240 :: bank -- 8
	"barbara" => "Barbara",  ##  Barbara -- 135 :: barbara -- 21
	"barcellona" => "Barcellona",  ##  Barcellona -- 152 :: barcellona -- 1
	"basan" => "Basan",  ##  Basan -- 121
	"bassi" => "Bassi",  ##  Bassi -- 443 :: bassi -- 137
	"batman" => "Batman",  ##  Batman -- 212
	"baviera" => "Baviera",  ##  Baviera -- 115
	# "bay" => "Bay",  ##  Bay -- 211 :: bay -- 4
	# "be" => "Be",  ##  Be -- 124 :: be -- 8
	# "beach" => "Beach",  ##  Beach -- 130 :: beach -- 9
	"belgio" => "Belgio",  ##  Belgio -- 354 :: belgio -- 1
	# "bell" => "Bell",  ##  Bell -- 149 :: bell -- 3
	"beniamino" => "Beniamino",  ##  Beniamino -- 317 :: beniamino -- 2
	"benjamin" => "Benjamin",  ##  Benjamin -- 154
	"berlino" => "Berlino",  ##  Berlino -- 657
	"bernard" => "Bernard",  ##  Bernard -- 107
	"bessie" => "Bessie",  ##  Bessie -- 136
	# "bet" => "Bet",  ##  Bet -- 239 :: bet -- 6
	"betel" => "Betel",  ##  Betel -- 144 :: betel -- 3
	"betlemme" => "Betlemme",  ##  Betlemme -- 122
	"betsy" => "Betsy",  ##  Betsy -- 107
	"bibbia" => "Bibbia",  ##  Bibbia -- 310 :: bibbia -- 13
	# "big" => "Big",  ##  Big -- 161 :: big -- 10
	"bill" => "Bill",  ##  Bill -- 230 :: bill -- 3
	"billy" => "Billy",  ##  Billy -- 143
	"birmingham" => "Birmingham",  ##  Birmingham -- 126
	# "black" => "Black",  ##  Black -- 438 :: black -- 15
	# "blue" => "Blue",  ##  Blue -- 213 :: blue -- 9
	# "board" => "Board",  ##  Board -- 112 :: board -- 4
	"bob" => "Bob",  ##  Bob -- 174 :: bob -- 2
	"boeing" => "Boeing",  ##  Boeing -- 123
	"bologna" => "Bologna",  ##  Bologna -- 116 :: bologna -- 4
	"bosnia" => "Bosnia",  ##  Bosnia -- 150
	"boston" => "Boston",  ##  Boston -- 337
	# "bowl" => "Bowl",  ##  Bowl -- 123 :: bowl -- 3
	# "boy" => "Boy",  ##  Boy -- 163 :: boy -- 9
	"brasile" => "Brasile",  ##  Brasile -- 444
	"bretagna" => "Bretagna",  ##  Bretagna -- 723
	"brian" => "Brian",  ##  Brian -- 164 :: brian -- 1
	"british" => "British",  ##  British -- 349
	"broadway" => "Broadway",  ##  Broadway -- 132
	"brooklyn" => "Brooklyn",  ##  Brooklyn -- 117
	# "brown" => "Brown",  ##  Brown -- 398 :: brown -- 2
	"bruce" => "Bruce",  ##  Bruce -- 190
	"bruxelles" => "Bruxelles",  ##  Bruxelles -- 237
	# "buenos" => "Buenos",  ##  Buenos -- 157
	"bulgaria" => "Bulgaria",  ##  Bulgaria -- 249
	# "bush" => "Bush",  ##  Bush -- 120 :: bush -- 2
	"cairo" => "Cairo",  ##  Cairo -- 116 :: cairo -- 2
	"caldei" => "Caldei",  ##  Caldei -- 144 :: caldei -- 21
	"california" => "California",  ##  California -- 693
	"cambridge" => "Cambridge",  ##  Cambridge -- 179 :: cambridge -- 2
	"cameron" => "Cameron",  ##  Cameron -- 143
	"campbell" => "Campbell",  ##  Campbell -- 107 :: campbell -- 1
	"canaan" => "Canaan",  ##  Canaan -- 205
	"canada" => "Canada",  ##  Canada -- 847 :: canada -- 3
	"cananei" => "Cananei",  ##  Cananei -- 106 :: cananei -- 4
	"capitan" => "Capitan",  ##  Capitan -- 122 :: capitan -- 1
	"carl" => "Carl",  ##  Carl -- 255
	"carlo" => "Carlo",  ##  Carlo -- 519 :: carlo -- 7
	"carlos" => "Carlos",  ##  Carlos -- 163 :: carlos -- 1
	"carolina" => "Carolina",  ##  Carolina -- 296
	"carter" => "Carter",  ##  Carter -- 166
	"castro" => "Castro",  ##  Castro -- 161
	"catania" => "Catania",  ##  Catania -- 123
	"cecoslovacchia" => "Cecoslovacchia",  ##  Cecoslovacchia -- 128
	# "center" => "Center",  ##  Center -- 566 :: center -- 10
	# "central" => "Central",  ##  Central -- 179 :: central -- 3
	"cesare" => "Cesare",  ##  Cesare -- 188 :: cesare -- 2
	# "championship" => "Championship",  ##  Championship -- 116
	# "channel" => "Channel",  ##  Channel -- 109 :: channel -- 2
	"charles" => "Charles",  ##  Charles -- 785 :: charles -- 1
	"charlie" => "Charlie",  ##  Charlie -- 128
	"charlotte" => "Charlotte",  ##  Charlotte -- 131
	"chiang" => "Chiang",  ##  Chiang -- 111
	"chicago" => "Chicago",  ##  Chicago -- 426 :: chicago -- 2
	"chris" => "Chris",  ##  Chris -- 142
	"christian" => "Christian",  ##  Christian -- 144
	"christopher" => "Christopher",  ##  Christopher -- 133
	"churchill" => "Churchill",  ##  Churchill -- 259
	"cile" => "Cile",  ##  Cile -- 214
	"cina" => "Cina",  ##  Cina -- 1338 :: cina -- 1
	"cipro" => "Cipro",  ##  Cipro -- 205 :: cipro -- 7
	# "city" => "City",  ##  City -- 920 :: city -- 11
	"clark" => "Clark",  ##  Clark -- 184
	"clinton" => "Clinton",  ##  Clinton -- 142
	"colombia" => "Colombia",  ##  Colombia -- 139
	"colorado" => "Colorado",  ##  Colorado -- 135
	"columbia" => "Columbia",  ##  Columbia -- 272
	# "commonwealth" => "Commonwealth",  ##  Commonwealth -- 128 :: commonwealth -- 2
	# "company" => "Company",  ##  Company -- 606 :: company -- 10
	"congo" => "Congo",  ##  Congo -- 107
	# "congresso" => "Congresso",  ##  Congresso -- 669 :: congresso -- 186
	# "conservatorio" => "Conservatorio",  ##  Conservatorio -- 115 :: conservatorio -- 32
	# "cook" => "Cook",  ##  Cook -- 126 :: cook -- 1
	"corea" => "Corea",  ##  Corea -- 552 :: corea -- 1
	"cornell" => "Cornell",  ##  Cornell -- 134 :: cornell -- 1
	# "corporation" => "Corporation",  ##  Corporation -- 285 :: corporation -- 6
	"corps" => "Corps",  ##  Corps -- 123 :: corps -- 6
	"costantinopoli" => "Costantinopoli",  ##  Costantinopoli -- 225
	# "council" => "Council",  ##  Council -- 178 :: council -- 2
	# "county" => "County",  ##  County -- 148
	# "creek" => "Creek",  ##  Creek -- 163 :: creek -- 2
	"crimea" => "Crimea",  ##  Crimea -- 178 :: crimea -- 1
	"cristo" => "Cristo",  ##  Cristo -- 1403 :: cristo -- 2
	"croazia" => "Croazia",  ##  Croazia -- 141
	"cuba" => "Cuba",  ##  Cuba -- 254 :: cuba -- 3
	# "daily" => "Daily",  ##  Daily -- 139
	"dallas" => "Dallas",  ##  Dallas -- 119 :: dallas -- 1
	"damasco" => "Damasco",  ##  Damasco -- 223 :: damasco -- 3
	"dan" => "Dan",  ##  Dan -- 274 :: dan -- 9
	# "dance" => "Dance",  ##  Dance -- 219 :: dance -- 30
	"daniel" => "Daniel",  ##  Daniel -- 270
	"daniele" => "Daniele",  ##  Daniele -- 172
	"danimarca" => "Danimarca",  ##  Danimarca -- 364
	"david" => "David",  ##  David -- 895
	"davide" => "Davide",  ##  Davide -- 2269
	"davis" => "Davis",  ##  Davis -- 191
	# "day" => "Day",  ##  Day -- 174 :: day -- 10
	"detroit" => "Detroit",  ##  Detroit -- 146
	"diana" => "Diana",  ##  Diana -- 263
	"diego" => "Diego",  ##  Diego -- 197 :: diego -- 1
	"dio" => "Dio",  ##  Dio -- 10255 :: dio -- 429
	"dion" => "Dion",  ##  Dion -- 106
	"disney" => "Disney",  ##  Disney -- 282
	"division" => "Division",  ##  Division -- 109 :: division -- 29
	"dolly" => "Dolly",  ##  Dolly -- 311
	# "don" => "Don",  ##  Don -- 256 :: don -- 44
	"donald" => "Donald",  ##  Donald -- 128
	"douglas" => "Douglas",  ##  Douglas -- 187
	"dr" => "Dr",  ##  Dr -- 244
	"dublino" => "Dublino",  ##  Dublino -- 157
	# "east" => "East",  ##  East -- 202 :: east -- 2
	# "ebbene" => "Ebbene",  ##  Ebbene -- 258 :: ebbene -- 49
	"ebron" => "Ebron",  ##  Ebron -- 150
	"edimburgo" => "Edimburgo",  ##  Edimburgo -- 110 :: edimburgo -- 2
	"edoardo" => "Edoardo",  ##  Edoardo -- 138
	"edom" => "Edom",  ##  Edom -- 220
	"edward" => "Edward",  ##  Edward -- 326
	"efraim" => "Efraim",  ##  Efraim -- 363
	"egitto" => "Egitto",  ##  Egitto -- 849 :: egitto -- 4
	"eleazaro" => "Eleazaro",  ##  Eleazaro -- 147
	"elena" => "Elena",  ##  Elena -- 177 :: elena -- 1
	"elia" => "Elia",  ##  Elia -- 234
	"elisabetta" => "Elisabetta",  ##  Elisabetta -- 215
	"eliseo" => "Eliseo",  ##  Eliseo -- 154
	"elizabeth" => "Elizabeth",  ##  Elizabeth -- 290
	"enrico" => "Enrico",  ##  Enrico -- 306
	# "entertainment" => "Entertainment",  ##  Entertainment -- 125 :: entertainment -- 5
	"eric" => "Eric",  ##  Eric -- 171
	"erik" => "Erik",  ##  
	"eryk" => "Eryk",  ##  
	"erode" => "Erode",  ##  Erode -- 109 :: erode -- 2
	"esau~" => "Esau~",  ##  Esau~ -- 204
	"ester" => "Ester",  ##  Ester -- 116
	"etiopia" => "Etiopia",  ##  Etiopia -- 129
	"europa" => "Europa",  ##  Europa -- 1533 :: europa -- 2
	"european" => "European",  ##  European -- 110
	"ezechia" => "Ezechia",  ##  Ezechia -- 270
	"facebook" => "Facebook",  ##  Facebook -- 124 :: facebook -- 1
	"fairfax" => "Fairfax",  ##  Fairfax -- 127
	"federico" => "Federico",  ##  Federico -- 159 :: federico -- 2
	"ferdinando" => "Ferdinando",  ##  Ferdinando -- 136 :: ferdinando -- 1
	# "field" => "Field",  ##  Field -- 124 :: field -- 8
	"filadelfia" => "Filadelfia",  ##  Filadelfia -- 136
	"filippine" => "Filippine",  ##  Filippine -- 185 :: filippine -- 12
	"filippo" => "Filippo",  ##  Filippo -- 518
	"filistei" => "Filistei",  ##  Filistei -- 486 :: filistei -- 2
	"finlandia" => "Finlandia",  ##  Finlandia -- 224
	"firenze" => "Firenze",  ##  Firenze -- 204 :: firenze -- 4
	"florida" => "Florida",  ##  Florida -- 345 :: florida -- 3
	# "force" => "Force",  ##  Force -- 453 :: force -- 35
	# "ford" => "Ford",  ##  Ford -- 173
	# "fort" => "Fort",  ##  Fort -- 469 :: fort -- 4
	# "foundation" => "Foundation",  ##  Foundation -- 253 :: foundation -- 1
	# "fox" => "Fox",  ##  Fox -- 161 :: fox -- 1
	"france" => "France",  ##  France -- 147 :: france -- 1
	"francesco" => "Francesco",  ##  Francesco -- 310
	"francia" => "Francia",  ##  Francia -- 2203 :: francia -- 9
	"francis" => "Francis",  ##  Francis -- 148
	"francisco" => "Francisco",  ##  Francisco -- 578 :: francisco -- 1
	"francois" => "Francois",  ##  Francois -- 161
	"frank" => "Frank",  ##  Frank -- 351
	"franklin" => "Franklin",  ##  Franklin -- 152
	"franz" => "Franz",  ##  Franz -- 118
	"frederick" => "Frederick",  ##  Frederick -- 107
	"friedrich" => "Friedrich",  ##  Friedrich -- 153 :: friedrich -- 1
	"gad" => "Gad",  ##  Gad -- 162
	"galaad" => "Galaad",  ##  Galaad -- 266
	"galilea" => "Galilea",  ##  Galilea -- 186 :: galilea -- 5
	"galles" => "Galles",  ##  Galles -- 237
	# "garden" => "Garden",  ##  Garden -- 115 :: garden -- 1
	"gaza" => "Gaza",  ##  Gaza -- 107 :: gaza -- 2
	"genova" => "Genova",  ##  Genova -- 109 :: genova -- 3
	"george" => "George",  ##  George -- 954
	"georgia" => "Georgia",  ##  Georgia -- 409
	"geremia" => "Geremia",  ##  Geremia -- 320
	"gerico" => "Gerico",  ##  Gerico -- 152
	"germania" => "Germania",  ##  Germania -- 1889 :: germania -- 2
	"geroboamo" => "Geroboamo",  ##  Geroboamo -- 202
	"gerusalemme" => "Gerusalemme",  ##  Gerusalemme -- 2025 :: gerusalemme -- 3
	"gesu~" => "Gesu~",  ##  Gesu~ -- 2609
	"giacobbe" => "Giacobbe",  ##  Giacobbe -- 762
	"giacomo" => "Giacomo",  ##  Giacomo -- 197 :: giacomo -- 1
	"giappone" => "Giappone",  ##  Giappone -- 1293 :: giappone -- 3
	"ginevra" => "Ginevra",  ##  Ginevra -- 159
	"giobbe" => "Giobbe",  ##  Giobbe -- 127
	"gionata" => "Gionata",  ##  Gionata -- 242
	"giordania" => "Giordania",  ##  Giordania -- 106
	"giordano" => "Giordano",  ##  Giordano -- 467 :: giordano -- 28
	"giorgio" => "Giorgio",  ##  Giorgio -- 592 :: giorgio -- 3
	"giosafat" => "Giosafat",  ##  Giosafat -- 184
	"giosia" => "Giosia",  ##  Giosia -- 123
	"giosue~" => "Giosue~",  ##  Giosue~ -- 513
	"giovanni" => "Giovanni",  ##  Giovanni -- 1029
	# "girl" => "Girl",  ##  Girl -- 214 :: girl -- 9
	"giuda" => "Giuda",  ##  Giuda -- 1733 :: giuda -- 1
	"giudea" => "Giudea",  ##  Giudea -- 169 :: giudea -- 7
	"giudei" => "Giudei",  ##  Giudei -- 527 :: giudei -- 10
	"giuseppe" => "Giuseppe",  ##  Giuseppe -- 762
	# "golden" => "Golden",  ##  Golden -- 109 :: golden -- 1
	"google" => "Google",  ##  Google -- 295 :: google -- 1
	"gordon" => "Gordon",  ##  Gordon -- 192
	"graham" => "Graham",  ##  Graham -- 202
	# "grand" => "Grand",  ##  Grand -- 308 :: grand -- 33
	"grant" => "Grant",  ##  Grant -- 189 :: grant -- 5
	# "great" => "Great",  ##  Great -- 143 :: great -- 1
	"grecia" => "Grecia",  ##  Grecia -- 550 :: grecia -- 2
	# "green" => "Green",  ##  Green -- 274 :: green -- 15
	# "group" => "Group",  ##  Group -- 306 :: group -- 15
	"guglielmo" => "Guglielmo",  ##  Guglielmo -- 110 :: guglielmo -- 1
	"guinea" => "Guinea",  ##  Guinea -- 113 :: guinea -- 1
	"hadad" => "Hadad",  ##  Hadad -- 115
	# "hall" => "Hall",  ##  Hall -- 676 :: hall -- 13
	"hamilton" => "Hamilton",  ##  Hamilton -- 169
	"handel" => "Handel",  ##  Handel -- 203
	"hans" => "Hans",  ##  Hans -- 185
	"harris" => "Harris",  ##  Harris -- 417
	"harry" => "Harry",  ##  Harry -- 201
	"henri" => "Henri",  ##  Henri -- 115
	"henry" => "Henry",  ##  Henry -- 539
	# "high" => "High",  ##  High -- 276 :: high -- 24
	# "hill" => "Hill",  ##  Hill -- 321 :: hill -- 1
	# "history" => "History",  ##  History -- 140 :: history -- 20
	"hitler" => "Hitler",  ##  Hitler -- 392
	"hollywood" => "Hollywood",  ##  Hollywood -- 218 :: hollywood -- 1
	"holmes" => "Holmes",  ##  Holmes -- 126
	"hong" => "Hong",  ##  Hong -- 262
	# "hospital" => "Hospital",  ##  Hospital -- 119 :: hospital -- 3
	# "house" => "House",  ##  House -- 530 :: house -- 50
	"houston" => "Houston",  ##  Houston -- 129
	"howard" => "Howard",  ##  Howard -- 217
	"hudson" => "Hudson",  ##  Hudson -- 107
	"ieu" => "Ieu",  ##  Ieu -- 136 :: ieu -- 1
	"inc" => "Inc",  ##  Inc -- 183 :: inc -- 1
	"india" => "India",  ##  India -- 657 :: india -- 5
	"indie" => "Indie",  ##  Indie -- 198 :: indie -- 12
	"inghilterra" => "Inghilterra",  ##  Inghilterra -- 937 :: inghilterra -- 2
	# "institute" => "Institute",  ##  Institute -- 355 :: institute -- 1
	# "international" => "International",  ##  International -- 512 :: international -- 12
	# "internet" => "Internet",  ##  Internet -- 382 :: internet -- 120
	"ioab" => "Ioab",  ##  Ioab -- 294
	"ioas" => "Ioas",  ##  Ioas -- 138
	"iran" => "Iran",  ##  Iran -- 281
	"iraq" => "Iraq",  ##  Iraq -- 276
	"irlanda" => "Irlanda",  ##  Irlanda -- 362
	"isaac" => "Isaac",  ##  Isaac -- 106
	"isabella" => "Isabella",  ##  Isabella -- 151
	"isacco" => "Isacco",  ##  Isacco -- 292
	"isaia" => "Isaia",  ##  Isaia -- 175
	"islam" => "Islam",  ##  Islam -- 121 :: islam -- 11
	"island" => "Island",  ##  Island -- 255 :: island -- 1
	"israele" => "Israele",  ##  Israele -- 3572
	"israeliti" => "Israeliti",  ##  Israeliti -- 1520 :: israeliti -- 17
	"istanbul" => "Istanbul",  ##  Istanbul -- 142
	"italia" => "Italia",  ##  Italia -- 1253 :: italia -- 5
	"ivan" => "Ivan",  ##  Ivan -- 164
	"ivanovic" => "Ivanovic",  ##  Ivanovic -- 278
	"ivanovna" => "Ivanovna",  ##  Ivanovna -- 107
	"jack" => "Jack",  ##  Jack -- 388 :: jack -- 2
	"jackson" => "Jackson",  ##  Jackson -- 338
	"jacob" => "Jacob",  ##  Jacob -- 123
	"jacques" => "Jacques",  ##  Jacques -- 200
	"james" => "James",  ##  James -- 762 :: james -- 1
	"jan" => "Jan",  ##  Jan -- 142 :: jan -- 1
	"jane" => "Jane",  ##  Jane -- 480
	"jean" => "Jean",  ##  Jean -- 469 :: jean -- 1
	"jerry" => "Jerry",  ##  Jerry -- 119
	"jersey" => "Jersey",  ##  Jersey -- 214
	"jim" => "Jim",  ##  Jim -- 206
	"jimmy" => "Jimmy",  ##  Jimmy -- 139
	"joe" => "Joe",  ##  Joe -- 187
	"johann" => "Johann",  ##  Johann -- 158
	"john" => "John",  ##  John -- 2137 :: john -- 2
	"johnny" => "Johnny",  ##  Johnny -- 118
	"johnson" => "Johnson",  ##  Johnson -- 503
	"jones" => "Jones",  ##  Jones -- 286
	"jordan" => "Jordan",  ##  Jordan -- 158
	"jose" => "Jose",  ##  Jose -- 261
	"joseph" => "Joseph",  ##  Joseph -- 504
	# "journal" => "Journal",  ##  Journal -- 161 :: journal -- 3
	"jr" => "Jr",  ##  Jr -- 164 :: jr -- 2
	"juan" => "Juan",  ##  Juan -- 284 :: juan -- 1
	"jugoslavia" => "Jugoslavia",  ##  Jugoslavia -- 213
	# "justice" => "Justice",  ##  Justice -- 345 :: justice -- 3
	"kansas" => "Kansas",  ##  Kansas -- 185
	"karl" => "Karl",  ##  Karl -- 176
	"kennedy" => "Kennedy",  ##  Kennedy -- 196
	"kent" => "Kent",  ##  Kent -- 113
	"khan" => "Khan",  ##  Khan -- 281 :: khan -- 27
	# "kid" => "Kid",  ##  Kid -- 135
	"kiev" => "Kiev",  ##  Kiev -- 116 :: kiev -- 1
	"kim" => "Kim",  ##  Kim -- 226
	# "king" => "King",  ##  King -- 356 :: king -- 2
	"kitty" => "Kitty",  ##  Kitty -- 673
	"kong" => "Kong",  ##  Kong -- 258 :: kong -- 1
	"konstantin" => "Konstantin",  ##  Konstantin -- 123
	"kosovo" => "Kosovo",  ##  Kosovo -- 228
	"labano" => "Labano",  ##  Labano -- 110
	# "lady" => "Lady",  ##  Lady -- 324 :: lady -- 59
	# "lake" => "Lake",  ##  Lake -- 146
	# "lane" => "Lane",  ##  Lane -- 125 :: lane -- 1
	# "lanterne" => "Lanterne",  ##  Lanterne -- 122 :: lanterne -- 16
	# "las" => "Las",  ##  Las -- 172 :: las -- 35
	"lawrence" => "Lawrence",  ##  Lawrence -- 125
	# "league" => "League",  ##  League -- 500 :: league -- 12
	"lee" => "Lee",  ##  Lee -- 427
	# "legione" => "Legione",  ##  Legione -- 336 :: legione -- 44
	"leo" => "Leo",  ##  Leo -- 121
	"leon" => "Leon",  ##  Leon -- 136
	"levi" => "Levi",  ##  Levi -- 192 :: levi -- 6
	"levin" => "Levin",  ##  Levin -- 1622
	"lewis" => "Lewis",  ##  Lewis -- 179
	"libano" => "Libano",  ##  Libano -- 335 :: libano -- 1
	# "library" => "Library",  ##  Library -- 119 :: library -- 2
	"lidija" => "Lidija",  ##  Lidija -- 109
	# "life" => "Life",  ##  Life -- 135 :: life -- 24
	"lincoln" => "Lincoln",  ##  Lincoln -- 300
	"linux" => "Linux",  ##  Linux -- 153 :: linux -- 3
	"lisbona" => "Lisbona",  ##  Lisbona -- 150
	# "little" => "Little",  ##  Little -- 222 :: little -- 2
	"lituania" => "Lituania",  ##  Lituania -- 182
	"liverpool" => "Liverpool",  ##  Liverpool -- 131
	"lloyd" => "Lloyd",  ##  Lloyd -- 122
	"london" => "London",  ##  London -- 278
	"londra" => "Londra",  ##  Londra -- 1530 :: londra -- 4
	# "long" => "Long",  ##  Long -- 163 :: long -- 8
	# "lord" => "Lord",  ##  Lord -- 681 :: lord -- 121
	# "los" => "Los",  ##  Los -- 657 :: los -- 55
	"louis" => "Louis",  ##  Louis -- 408 :: louis -- 1
	"louisiana" => "Louisiana",  ##  Louisiana -- 117
	# "love" => "Love",  ##  Love -- 191 :: love -- 13
	"ltd" => "Ltd",  ##  Ltd -- 115
	"luigi" => "Luigi",  ##  Luigi -- 494 :: luigi -- 1
	"luisa" => "Luisa",  ##  Luisa -- 140
	"lussemburgo" => "Lussemburgo",  ##  Lussemburgo -- 115
	"macedonia" => "Macedonia",  ##  Macedonia -- 277 :: macedonia -- 1
	# "madame" => "Madame",  ##  Madame -- 125 :: madame -- 7
	"madrid" => "Madrid",  ##  Madrid -- 226 :: madrid -- 1
	# "magazine" => "Magazine",  ##  Magazine -- 140 :: magazine -- 25
	# "major" => "Major",  ##  Major -- 115 :: major -- 18
	"malta" => "Malta",  ##  Malta -- 170 :: malta -- 2
	# "man" => "Man",  ##  Man -- 316 :: man -- 56
	"manasse" => "Manasse",  ##  Manasse -- 303
	"manchester" => "Manchester",  ##  Manchester -- 123
	"manhattan" => "Manhattan",  ##  Manhattan -- 114
	"manuel" => "Manuel",  ##  Manuel -- 121
	# "mar" => "Mar",  ##  Mar -- 335 :: mar -- 76
	"marco" => "Marco",  ##  Marco -- 212 :: marco -- 7
	"mardocheo" => "Mardocheo",  ##  Mardocheo -- 117
	"margaret" => "Margaret",  ##  Margaret -- 169
	"maria" => "Maria",  ##  Maria -- 1242
	"marie" => "Marie",  ##  Marie -- 184 :: marie -- 1
	"mario" => "Mario",  ##  Mario -- 158 :: mario -- 1
	"mark" => "Mark",  ##  Mark -- 261 :: mark -- 5
	"marocco" => "Marocco",  ##  Marocco -- 155
	"marte" => "Marte",  ##  Marte -- 122 :: marte -- 2
	"martha" => "Martha",  ##  Martha -- 122
	"martin" => "Martin",  ##  Martin -- 499 :: martin -- 2
	"marvel" => "Marvel",  ##  Marvel -- 111
	"mary" => "Mary",  ##  Mary -- 449 :: mary -- 1
	"mason" => "Mason",  ##  Mason -- 120 :: mason -- 2
	"massachusetts" => "Massachusetts",  ##  Massachusetts -- 196
	# "master" => "Master",  ##  Master -- 111 :: master -- 28
	"max" => "Max",  ##  Max -- 194 :: max -- 4
	# "medioevo" => "Medioevo",  ##  Medioevo -- 173 :: medioevo -- 47
	"mediterraneo" => "Mediterraneo",  ##  Mediterraneo -- 251 :: mediterraneo -- 29
	# "memorial" => "Memorial",  ##  Memorial -- 108 :: memorial -- 2
	"mercury" => "Mercury",  ##  Mercury -- 115
	"messico" => "Messico",  ##  Messico -- 714 :: messico -- 4
	"miami" => "Miami",  ##  Miami -- 115
	"michael" => "Michael",  ##  Michael -- 530
	"michele" => "Michele",  ##  Michele -- 162 :: michele -- 2
	"michigan" => "Michigan",  ##  Michigan -- 138 :: michigan -- 1
	"microsoft" => "Microsoft",  ##  Microsoft -- 179 :: microsoft -- 4
	"miguel" => "Miguel",  ##  Miguel -- 118
	"mike" => "Mike",  ##  Mike -- 156 :: mike -- 1
	"milano" => "Milano",  ##  Milano -- 309 :: milano -- 5
	"miller" => "Miller",  ##  Miller -- 211
	"ming" => "Ming",  ##  Ming -- 136 :: ming -- 2
	"minnesota" => "Minnesota",  ##  Minnesota -- 113
	# "miss" => "Miss",  ##  Miss -- 188 :: miss -- 13
	"mississippi" => "Mississippi",  ##  Mississippi -- 131 :: mississippi -- 1
	"missouri" => "Missouri",  ##  Missouri -- 140
	"mitchell" => "Mitchell",  ##  Mitchell -- 127
	"moab" => "Moab",  ##  Moab -- 328
	"moldavia" => "Moldavia",  ##  Moldavia -- 157
	"montreal" => "Montreal",  ##  Montreal -- 119
	"moore" => "Moore",  ##  Moore -- 127
	"morgan" => "Morgan",  ##  Morgan -- 156
	"morris" => "Morris",  ##  Morris -- 120
	"mosca" => "Mosca",  ##  Mosca -- 590 :: mosca -- 44
	"mose~" => "Mose~",  ##  Mose~ -- 1747
	"mr" => "Mr",  ##  Mr -- 201 :: mr -- 1
	"muhammad" => "Muhammad",  ##  Muhammad -- 120
	# "museum" => "Museum",  ##  Museum -- 323 :: museum -- 2
	# "music" => "Music",  ##  Music -- 557 :: music -- 47
	# "my" => "My",  ##  My -- 158 :: my -- 15
	"nabucodonosor" => "Nabucodonosor",  ##  Nabucodonosor -- 175
	"nancy" => "Nancy",  ##  Nancy -- 107
	"napoleone" => "Napoleone",  ##  Napoleone -- 315
	"napoli" => "Napoli",  ##  Napoli -- 288 :: napoli -- 4
	# "national" => "National",  ##  National -- 868 :: national -- 17
	# "navy" => "Navy",  ##  Navy -- 175 :: navy -- 3
	"nelson" => "Nelson",  ##  Nelson -- 118
	# "new" => "New",  ##  New -- 3094 :: new -- 22
	# "news" => "News",  ##  News -- 234 :: news -- 13
	"newton" => "Newton",  ##  Newton -- 127 :: newton -- 4
	"nick" => "Nick",  ##  Nick -- 107
	"nikolaj" => "Nikolaj",  ##  Nikolaj -- 115
	"nilo" => "Nilo",  ##  Nilo -- 140 :: nilo -- 1
	"nobel" => "Nobel",  ##  Nobel -- 146 :: nobel -- 4
	"noe~" => "Noe~",  ##  Noe~ -- 123
	"norman" => "Norman",  ##  Norman -- 110 :: norman -- 1
	# "north" => "North",  ##  North -- 282 :: north -- 1
	"norvegia" => "Norvegia",  ##  Norvegia -- 341
	"obama" => "Obama",  ##  Obama -- 197
	"oblonskij" => "Oblonskij",  ##  Oblonskij -- 130
	# "office" => "Office",  ##  Office -- 108 :: office -- 10
	# "oh" => "Oh",  ##  Oh -- 339 :: oh -- 66
	# "old" => "Old",  ##  Old -- 110 :: old -- 5
	"oliver" => "Oliver",  ##  Oliver -- 116
	# "one" => "One",  ##  One -- 130 :: one -- 22
	"orleans" => "Orleans",  ##  Orleans -- 186
	"oxford" => "Oxford",  ##  Oxford -- 189
	"pacific" => "Pacific",  ##  Pacific -- 132
	"pacifico" => "Pacifico",  ##  Pacifico -- 291 :: pacifico -- 45
	"pakistan" => "Pakistan",  ##  Pakistan -- 213 :: pakistan -- 1
	"palermo" => "Palermo",  ##  Palermo -- 219
	"palestina" => "Palestina",  ##  Palestina -- 228
	"paolo" => "Paolo",  ##  Paolo -- 607 :: paolo -- 1
	"parigi" => "Parigi",  ##  Parigi -- 1256 :: parigi -- 7
	# "park" => "Park",  ##  Park -- 562 :: park -- 1
	"parker" => "Parker",  ##  Parker -- 120
	"paul" => "Paul",  ##  Paul -- 601
	"pechino" => "Pechino",  ##  Pechino -- 228
	"pedro" => "Pedro",  ##  Pedro -- 137
	"pennsylvania" => "Pennsylvania",  ##  Pennsylvania -- 187
	"persia" => "Persia",  ##  Persia -- 213
	"peru~" => "Peru~",  ##  Peru~ -- 178
	"peter" => "Peter",  ##  Peter -- 534
	"philadelphia" => "Philadelphia",  ##  Philadelphia -- 106
	# "philharmonic" => "Philharmonic",  ##  Philharmonic -- 144
	"philip" => "Philip",  ##  Philip -- 134
	"pierre" => "Pierre",  ##  Pierre -- 259 :: pierre -- 1
	"pietro" => "Pietro",  ##  Pietro -- 640 :: pietro -- 1
	"pietroburgo" => "Pietroburgo",  ##  Pietroburgo -- 308
	"pilato" => "Pilato",  ##  Pilato -- 157
	"pittsburgh" => "Pittsburgh",  ##  Pittsburgh -- 128
	"polonia" => "Polonia",  ##  Polonia -- 717 :: polonia -- 3
	# "port" => "Port",  ##  Port -- 146 :: port -- 18
	"portogallo" => "Portogallo",  ##  Portogallo -- 326 :: portogallo -- 2
	# "power" => "Power",  ##  Power -- 201 :: power -- 13
	"praga" => "Praga",  ##  Praga -- 172
	# "press" => "Press",  ##  Press -- 158 :: press -- 8
	# "project" => "Project",  ##  Project -- 156 :: project -- 20
	"prussia" => "Prussia",  ##  Prussia -- 209
	"qing" => "Qing",  ##  Qing -- 120
	"quebec" => "Quebec",  ##  Quebec -- 171
	# "queen" => "Queen",  ##  Queen -- 212 :: queen -- 12
	# "rabbi" => "Rabbi",  ##  Rabbi -- 173 :: rabbi -- 9
	"rama" => "Rama",  ##  Rama -- 111
	"ray" => "Ray",  ##  Ray -- 139 :: ray -- 16
	# "real" => "Real",  ##  Real -- 120 :: real -- 35
	# "records" => "Records",  ##  Records -- 304 :: records -- 4
	# "red" => "Red",  ##  Red -- 252 :: red -- 4
	"reed" => "Reed",  ##  Reed -- 159
	"reich" => "Reich",  ##  Reich -- 128 :: reich -- 2
	# "repubblica" => "Repubblica",  ##  Repubblica -- 1279 :: repubblica -- 235
	# "research" => "Research",  ##  Research -- 224
	"richard" => "Richard",  ##  Richard -- 595 :: richard -- 1
	"rinascimento" => "Rinascimento",  ##  Rinascimento -- 135 :: rinascimento -- 21
	# "rio" => "Rio",  ##  Rio -- 220 :: rio -- 2
	# "river" => "River",  ##  River -- 152 :: river -- 1
	# "road" => "Road",  ##  Road -- 200 :: road -- 11
	"robert" => "Robert",  ##  Robert -- 842
	"roberto" => "Roberto",  ##  Roberto -- 134 :: roberto -- 1
	"robin" => "Robin",  ##  Robin -- 136 :: robin -- 1
	"robinson" => "Robinson",  ##  Robinson -- 126
	"rochester" => "Rochester",  ##  Rochester -- 443
	"roger" => "Roger",  ##  Roger -- 156
	"roma" => "Roma",  ##  Roma -- 1182 :: roma -- 22
	"romania" => "Romania",  ##  Romania -- 323
	"roosevelt" => "Roosevelt",  ##  Roosevelt -- 176
	"ross" => "Ross",  ##  Ross -- 135
	"roy" => "Roy",  ##  Roy -- 132 :: roy -- 4
	# "royal" => "Royal",  ##  Royal -- 890 :: royal -- 13
	"ruben" => "Ruben",  ##  Ruben -- 154
	"russell" => "Russell",  ##  Russell -- 135
	"russia" => "Russia",  ##  Russia -- 1274 :: russia -- 3
	"ryan" => "Ryan",  ##  Ryan -- 115
	"saint" => "Saint",  ##  Saint -- 526 :: saint -- 1
	"salmo" => "Salmo",  ##  Salmo -- 135 :: salmo -- 13
	"salomone" => "Salomone",  ##  Salomone -- 650
	"sam" => "Sam",  ##  Sam -- 207 :: sam -- 1
	"samaria" => "Samaria",  ##  Samaria -- 249
	"samuel" => "Samuel",  ##  Samuel -- 214
	"samuele" => "Samuele",  ##  Samuele -- 314
	"san" => "San",  ##  San -- 1814 :: san -- 57
	"santa" => "Santa",  ##  Santa -- 620 :: santa -- 200
	"santiago" => "Santiago",  ##  Santiago -- 132
	"sara" => "Sara",  ##  Sara -- 144 :: sara -- 11
	"sarah" => "Sarah",  ##  Sarah -- 128
	"saul" => "Saul",  ##  Saul -- 830
	# "school" => "School",  ##  School -- 661 :: school -- 22
	# "science" => "Science",  ##  Science -- 144 :: science -- 4
	"scott" => "Scott",  ##  Scott -- 337
	"scozia" => "Scozia",  ##  Scozia -- 501
	"seattle" => "Seattle",  ##  Seattle -- 149
	"sedecia" => "Sedecia",  ##  Sedecia -- 126
	# "senato" => "Senato",  ##  Senato -- 330 :: senato -- 48
	"serbia" => "Serbia",  ##  Serbia -- 203
	"sereza" => "Sereza",  ##  Sereza -- 122
	"sergej" => "Sergej",  ##  Sergej -- 333
	# "service" => "Service",  ##  Service -- 185 :: service -- 13
	"shah" => "Shah",  ##  Shah -- 218
	"shakespeare" => "Shakespeare",  ##  Shakespeare -- 133
	"shanghai" => "Shanghai",  ##  Shanghai -- 168
	"sichem" => "Sichem",  ##  Sichem -- 134
	"sicilia" => "Sicilia",  ##  Sicilia -- 378
	"sidone" => "Sidone",  ##  Sidone -- 108
	"signore" => "Signore",  ##  Signore -- 14879 :: signore -- 1069
	"simeone" => "Simeone",  ##  Simeone -- 146
	"simon" => "Simon",  ##  Simon -- 267
	"simone" => "Simone",  ##  Simone -- 174 :: simone -- 1
	"sinai" => "Sinai",  ##  Sinai -- 132
	"singapore" => "Singapore",  ##  Singapore -- 128
	"sion" => "Sion",  ##  Sion -- 317
	# "sir" => "Sir",  ##  Sir -- 611 :: sir -- 84
	"siria" => "Siria",  ##  Siria -- 276
	"smith" => "Smith",  ##  Smith -- 573
	# "society" => "Society",  ##  Society -- 749 :: society -- 4
	"sofia" => "Sofia",  ##  Sofia -- 139
	# "song" => "Song",  ##  Song -- 148 :: song -- 3
	# "south" => "South",  ##  South -- 262
	# "space" => "Space",  ##  Space -- 167 :: space -- 9
	"spagna" => "Spagna",  ##  Spagna -- 1089 :: spagna -- 6
	"spencer" => "Spencer",  ##  Spencer -- 116
	# "square" => "Square",  ##  Square -- 115
	"st" => "St",  ##  St -- 513 :: st -- 2
	"stalin" => "Stalin",  ##  Stalin -- 176
	# "states" => "States",  ##  States -- 208 :: states -- 2
	"stepan" => "Stepan",  ##  Stepan -- 545
	"stephen" => "Stephen",  ##  Stephen -- 177
	"steve" => "Steve",  ##  Steve -- 168
	"stewart" => "Stewart",  ##  Stewart -- 119
	"stoccolma" => "Stoccolma",  ##  Stoccolma -- 134 :: stoccolma -- 1
	"stone" => "Stone",  ##  Stone -- 117 :: stone -- 5
	"strasburgo" => "Strasburgo",  ##  Strasburgo -- 119
	"street" => "Street",  ##  Street -- 520 :: street -- 8
	"stuart" => "Stuart",  ##  Stuart -- 144
	# "studios" => "Studios",  ##  Studios -- 138 :: studios -- 7
	"sudafrica" => "Sudafrica",  ##  Sudafrica -- 157
	"sudan" => "Sudan",  ##  Sudan -- 123
	# "sun" => "Sun",  ##  Sun -- 125 :: sun -- 2
	# "superboy" => "Superboy",  ##  Superboy -- 146
	"superman" => "Superman",  ##  Superman -- 275
	"svezia" => "Svezia",  ##  Svezia -- 493
	"svijazskij" => "Svijazskij",  ##  Svijazskij -- 137
	"svizzera" => "Svizzera",  ##  Svizzera -- 390 :: svizzera -- 64
	"sydney" => "Sydney",  ##  Sydney -- 207 :: sydney -- 1
	# "symphony" => "Symphony",  ##  Symphony -- 413 :: symphony -- 1
	# "system" => "System",  ##  System -- 134 :: system -- 35
	"taiwan" => "Taiwan",  ##  Taiwan -- 462
	"talmud" => "Talmud",  ##  Talmud -- 245
	"tang" => "Tang",  ##  Tang -- 130
	"taylor" => "Taylor",  ##  Taylor -- 308
	"tennessee" => "Tennessee",  ##  Tennessee -- 126 :: tennessee -- 1
	"teresa" => "Teresa",  ##  Teresa -- 106
	"texas" => "Texas",  ##  Texas -- 590 :: texas -- 1
	# "theatre" => "Theatre",  ##  Theatre -- 387 :: theatre -- 4
	"thomas" => "Thomas",  ##  Thomas -- 812 :: thomas -- 3
	"thompson" => "Thompson",  ##  Thompson -- 120
	"tibet" => "Tibet",  ##  Tibet -- 143
	"tim" => "Tim",  ##  Tim -- 110 :: tim -- 4
	# "times" => "Times",  ##  Times -- 464 :: times -- 1
	# "titans" => "Titans",  ##  Titans -- 163 :: titans -- 2
	"tokyo" => "Tokyo",  ##  Tokyo -- 328 :: tokyo -- 1
	"tom" => "Tom",  ##  Tom -- 252
	"tommaso" => "Tommaso",  ##  Tommaso -- 116
	"tommy" => "Tommy",  ##  Tommy -- 138
	"tony" => "Tony",  ##  Tony -- 142 :: tony -- 1
	"torah" => "Torah",  ##  Torah -- 301
	"torino" => "Torino",  ##  Torino -- 128 :: torino -- 2
	"toronto" => "Toronto",  ##  Toronto -- 126 :: toronto -- 1
	# "trump" => "Trump",  ##  Trump -- 108
	"turchia" => "Turchia",  ##  Turchia -- 390
	"ucraina" => "Ucraina",  ##  Ucraina -- 256 :: ucraina -- 59
	"ungheria" => "Ungheria",  ##  Ungheria -- 246
	# "union" => "Union",  ##  Union -- 219 :: union -- 3
	# "unite" => "Unite",  ##  Unite -- 615 :: unite -- 70
	# "united" => "United",  ##  United -- 298
	# "uniti" => "Uniti",  ##  Uniti -- 4235 :: uniti -- 128
	# "unito" => "Unito",  ##  Unito -- 993 :: unito -- 189
	# "university" => "University",  ##  University -- 671 :: university -- 3
	# "valley" => "Valley",  ##  Valley -- 157 :: valley -- 1
	"varsavia" => "Varsavia",  ##  Varsavia -- 185
	"vaticano" => "Vaticano",  ##  Vaticano -- 108 :: vaticano -- 3
	# "vegas" => "Vegas",  ##  Vegas -- 119
	"venezia" => "Venezia",  ##  Venezia -- 336 :: venezia -- 4
	"venezuela" => "Venezuela",  ##  Venezuela -- 205
	"versailles" => "Versailles",  ##  Versailles -- 121 :: versailles -- 1
	"victor" => "Victor",  ##  Victor -- 190
	"victoria" => "Victoria",  ##  Victoria -- 144 :: victoria -- 1
	"vienna" => "Vienna",  ##  Vienna -- 449 :: vienna -- 2
	"vietnam" => "Vietnam",  ##  Vietnam -- 248
	"virginia" => "Virginia",  ##  Virginia -- 273
	"vladimir" => "Vladimir",  ##  Vladimir -- 164
	"vronskij" => "Vronskij",  ##  Vronskij -- 850
	"wagner" => "Wagner",  ##  Wagner -- 114
	"walker" => "Walker",  ##  Walker -- 157 :: walker -- 2
	"wallace" => "Wallace",  ##  Wallace -- 107
	"walter" => "Walter",  ##  Walter -- 255
	"washington" => "Washington",  ##  Washington -- 898 :: washington -- 1
	"watson" => "Watson",  ##  Watson -- 109
	"wayne" => "Wayne",  ##  Wayne -- 123
	# "west" => "West",  ##  West -- 430 :: west -- 15
	# "western" => "Western",  ##  Western -- 125 :: western -- 23
	# "white" => "White",  ##  White -- 389 :: white -- 6
	"wilhelm" => "Wilhelm",  ##  Wilhelm -- 109
	"william" => "William",  ##  William -- 988 :: william -- 2
	"williams" => "Williams",  ##  Williams -- 249 :: williams -- 2
	"wilson" => "Wilson",  ##  Wilson -- 236
	# "windows" => "Windows",  ##  Windows -- 174 :: windows -- 1
	"wisconsin" => "Wisconsin",  ##  Wisconsin -- 135
	# "woman" => "Woman",  ##  Woman -- 169 :: woman -- 4
	# "wonder" => "Wonder",  ##  Wonder -- 209 :: wonder -- 2
	# "world" => "World",  ##  World -- 610 :: world -- 20
	# "wrestling" => "Wrestling",  ##  Wrestling -- 153 :: wrestling -- 42
	"wright" => "Wright",  ##  Wright -- 154
	"york" => "York",  ##  York -- 2213
	# "you" => "You",  ##  You -- 123 :: you -- 12
	"youtube" => "YouTube",  ##  
	# "young" => "Young",  ##  Young -- 254 :: young -- 3
	# "yuan" => "Yuan",  ##  Yuan -- 172 :: yuan -- 13
	"zaccaria" => "Zaccaria",  ##  Zaccaria -- 121
	"zelanda" => "Zelanda",  ##  Zelanda -- 176
	"zhang" => "Zhang",  ##  Zhang -- 133
	);
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

1;
