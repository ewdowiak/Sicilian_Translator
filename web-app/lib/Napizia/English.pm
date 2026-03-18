package Napizia::English;

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
sub rid_accents { Napizia::Translator::rid_accents( $_[0] ); }
sub rid_circum {  Napizia::Translator::rid_circum(  $_[0] ); }
sub fix_punctuation { Napizia::Translator::fix_punctuation($_[0]); }

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT = ("en_detokenizer","en_tokenizer","en_capitalize");

##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  DETOKENIZATION
##  ==============

sub en_detokenizer {

    my $line = $_[0];
    $line = '<BOS> ' . $line . ' <EOS>';

    ##  reinsert spaces before and after punctuation
    #$line =~ s/([\,\.\?\!\:\;\%\}\]\)])/ $1 /g;
    
    ##  remove excess space
    $line =~ s/\s+/ /g;
    $line =~ s/^ //;
    $line =~ s/ $//;

    ##  capitalize and accent
    my $newline = en_capitalize( $line );
    $newline = fix_punctuation( $newline );

    ##  rejoin "apostrophe S"
    $newline =~ s/ ~~'s /'s /g;
    
    ##  remaining punctuation
    $newline =~ s/ '/'/g;
    $newline =~ s/([a-rt-y])' /$1'/g;
    
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

sub en_capitalize {
    
    my $line = $_[0];

    ##  retrieve caps hash
    my %encaps  = mk_en_capshash();
    
    ##  split at spaces
    my @words = split( / / , $line );
    my @new_words ;
    for my $i (1..$#words-1) {
	my $prev = $words[$i-1];
	my $word = $words[$i];
	my $nxtw = $words[$i+1];

	##  male and female names
	my $first_names = '^andrea$|^andrew$|^anthony$|^augustine$|^benedict$|^calogero$|^crispin$|';
	$first_names .= '^francis$|^gaetano$|^joachim$|^joseph$|^lucy$|^magdalene$|^mark$|^martin$|';
	$first_names .= '^mary$|^michael$|^nicholas$|^simeon$|^simon$|^thomas$|^vito$|^arthur$';
	$first_names .= '^jesus$|^christ$';
	
	##  saints and names
	$word = ( $word eq "saint" && $nxtw =~ /$first_names/ ) ? ucfirst($word) : $word ;
	$word = ( $word =~ /$first_names/ ) ? ucfirst($word) : $word ;
	
	##  The Lord and Saint Francis of Paola
	$word = ( $prev eq "the" && $word eq "lord" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "god" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "paola" ) ? ucfirst($word) : $word ;

	##  the word "I" and Roman numerals
	$word = ( $word eq "i" ) ? uc($word) : $word ;
	$word = ( $word eq "ii" ) ? uc($word) : $word ;
	$word = ( $word eq "iii" ) ? uc($word) : $word ;
	$word = ( $word eq "iv" ) ? uc($word) : $word ;
	$word = ( $word eq "v" ) ? uc($word) : $word ;
	$word = ( $word eq "vi" ) ? uc($word) : $word ;
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
	$word = ( $word eq "sicily" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "calabria" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "puglia" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "apulia" ) ? ucfirst($word) : $word ;

	##  "Sicilian," "English" and "American"
	$word = ( $word eq "sicilian" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "calabrese" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "calabrian" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "pugliese" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "english" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "american" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "italian" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "neapolitan" ) ? ucfirst($word) : $word ;
		
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
	
	##  United States and American cities
	$word = ( $prev eq "north" && $word eq "america" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "north" && $nxtw eq "america" ) ? ucfirst($word) : $word ;
	$word = ( $prev eq "south" && $word eq "america" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "south" && $nxtw eq "america" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "america" ) ? ucfirst($word) : $word ;
	
	$word = ( $word eq "brooklyn" ) ? ucfirst($word) : $word ;
	$word = ( $prev eq "new" && $word eq "york" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "new" && $nxtw eq "york" ) ? ucfirst($word) : $word ;
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

	$word = ( $prev eq "united" && $word eq "states" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "united" && $nxtw eq "states" ) ? ucfirst($word) : $word ;
	
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
	$word = ( ( $prev eq "gnazziu" || $prev eq "gnaziu" ) && $word eq "buttitta" ) ? ucfirst($word) : $word ;
	$word = ( ( $word eq "gnazziu" || $word eq "gnaziu" ) && $nxtw eq "buttitta" ) ? ucfirst($word) : $word ; 
	
	##  world leaders in translation technology
	$word = ( $word eq "napizia" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "facebook" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "google" ) ? ucfirst($word) : $word ;

	##  run through the capitalization list
	$word = ( ! defined $encaps{$word} ) ? $word : $encaps{$word} ;
	
	##  capitalize beginning of sentences
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
    $line = lc( $line );

    ##  make it all lower case (again)
    $line = lc( $line );
    
    ##  separate "apostrophe S"
    $line =~ s/([a-z])'s /$1 ~~'s /g;
    
    ##  remove excess space
    $line =~ s/\s+/ /g;
    $line =~ s/^ //;
    $line =~ s/ $//;

    return $line;
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  MAKE CAPS LIST
##  ==============

sub mk_en_capshash {

    my %encaps  = (
	"aaron" => "Aaron",  ##  Aaron -- 705
	"abe" => "Abe",  ##  Abe -- 76
	"abel" => "Abel",  ##  Abel -- 90
	"abimelech" => "Abimelech",  ##  Abimelech -- 131
	"abner" => "Abner",  ##  Abner -- 128
	"abraham" => "Abraham",  ##  Abraham -- 646
	"abram" => "Abram",  ##  Abram -- 117
	"absalom" => "Absalom",  ##  Absalom -- 206
	"abu" => "Abu",  ##  Abu -- 145
	# "academie" => "Academie",  ##  Academie -- 75
	# "academy" => "Academy",  ##  Academy -- 679 :: academy -- 124
	"adam" => "Adam",  ##  Adam -- 348 :: adam -- 3
	"adams" => "Adams",  ##  Adams -- 179
	# "additionally" => "Additionally",  ##  Additionally -- 238 :: additionally -- 32
	"adelaide" => "Adelaide",  ##  Adelaide -- 107
	"adele" => "Adele",  ##  Adele -- 137
	"adolf" => "Adolf",  ##  Adolf -- 117
	"afghan" => "Afghan",  ##  Afghan -- 72
	"afghanistan" => "Afghanistan",  ##  Afghanistan -- 261
	"africa" => "Africa",  ##  Africa -- 1060 :: africa -- 1
	"african" => "African",  ##  African -- 968 :: african -- 5
	"agatha" => "Agatha",  ##  Agatha -- 105
	# "ah" => "Ah",  ##  Ah -- 213 :: ah -- 12
	"ahab" => "Ahab",  ##  Ahab -- 187
	"ahaz" => "Ahaz",  ##  Ahaz -- 91
	"ahaziah" => "Ahaziah",  ##  Ahaziah -- 74
	# "ai" => "Ai",  ##  Ai -- 87 :: ai -- 18
	# "aires" => "Aires",  ##  Aires -- 165
	"alabama" => "Alabama",  ##  Alabama -- 160
	"alan" => "Alan",  ##  Alan -- 140
	"alaska" => "Alaska",  ##  Alaska -- 155
	"albania" => "Albania",  ##  Albania -- 229
	"albanian" => "Albanian",  ##  Albanian -- 250
	"albert" => "Albert",  ##  Albert -- 326
	"alex" => "Alex",  ##  Alex -- 159
	"alexander" => "Alexander",  ##  Alexander -- 576
	"alexandria" => "Alexandria",  ##  Alexandria -- 103
	"alexis" => "Alexis",  ##  Alexis -- 126
	"alfonso" => "Alfonso",  ##  Alfonso -- 109
	"alfred" => "Alfred",  ##  Alfred -- 183
	"algeria" => "Algeria",  ##  Algeria -- 106
	"ali" => "Ali",  ##  Ali -- 206 :: ali -- 1
	"alice" => "Alice",  ##  Alice -- 519
	"aliyev" => "Aliyev",  ##  Aliyev -- 84
	"allen" => "Allen",  ##  Allen -- 189
	# "almighty" => "Almighty",  ##  Almighty -- 128
	"amaziah" => "Amaziah",  ##  Amaziah -- 81
	"amazon" => "Amazon",  ##  Amazon -- 95 :: amazon -- 1
	# "amen" => "Amen",  ##  Amen -- 173 :: amen -- 18
	"america" => "America",  ##  America -- 1678 :: america -- 4
	"american" => "American",  ##  American -- 3570 :: american -- 3
	"americans" => "Americans",  ##  Americans -- 593
	"americas" => "Americas",  ##  Americas -- 135
	"ammon" => "Ammon",  ##  Ammon -- 192
	"amorites" => "Amorites",  ##  Amorites -- 136
	"amsterdam" => "Amsterdam",  ##  Amsterdam -- 219
	"anderson" => "Anderson",  ##  Anderson -- 167
	"andre" => "Andre",  ##  Andre -- 102
	"andrea" => "Andrea",  ##  Andrea -- 91
	"andrew" => "Andrew",  ##  Andrew -- 267
	"andrews" => "Andrews",  ##  Andrews -- 83 :: andrews -- 1
	# "android" => "Android",  ##  Android -- 131 :: android -- 36
	# "angeles" => "Angeles",  ##  Angeles -- 558 :: angeles -- 1
	"anglican" => "Anglican",  ##  Anglican -- 102
	"anglo" => "Anglo",  ##  Anglo -- 204 :: anglo -- 1
	"ann" => "Ann",  ##  Ann -- 93
	"anna" => "Anna",  ##  Anna -- 1007
	"anne" => "Anne",  ##  Anne -- 201
	"anthony" => "Anthony",  ##  Anthony -- 118
	"antioch" => "Antioch",  ##  Antioch -- 97
	"anton" => "Anton",  ##  Anton -- 98
	"antonio" => "Antonio",  ##  Antonio -- 383
	"apollo" => "Apollo",  ##  Apollo -- 107 :: apollo -- 1
	"april" => "April",  ##  April -- 2590 :: april -- 5
	"arab" => "Arab",  ##  Arab -- 622 :: arab -- 1
	"arabia" => "Arabia",  ##  Arabia -- 255
	"arabian" => "Arabian",  ##  Arabian -- 78
	"arabic" => "Arabic",  ##  Arabic -- 298 :: arabic -- 2
	"arabs" => "Arabs",  ##  Arabs -- 193
	"aragon" => "Aragon",  ##  Aragon -- 83
	# "arba" => "Arba",  ##  Arba -- 131 :: arba -- 5
	"archimedes" => "Archimedes",  ##  Archimedes -- 76
	"arctic" => "Arctic",  ##  Arctic -- 95 :: arctic -- 4
	"argentina" => "Argentina",  ##  Argentina -- 210
	"argentine" => "Argentine",  ##  Argentine -- 101
	"aristotle" => "Aristotle",  ##  Aristotle -- 90
	"arizona" => "Arizona",  ##  Arizona -- 130
	"arkansas" => "Arkansas",  ##  Arkansas -- 132
	"armenia" => "Armenia",  ##  Armenia -- 215
	"armenian" => "Armenian",  ##  Armenian -- 237 :: armenian -- 1
	"armstrong" => "Armstrong",  ##  Armstrong -- 95
	"arnold" => "Arnold",  ##  Arnold -- 118
	"arthur" => "Arthur",  ##  Arthur -- 326 :: arthur -- 1
	"asa" => "Asa",  ##  Asa -- 124 :: asa -- 1
	"asaph" => "Asaph",  ##  Asaph -- 81
	"asher" => "Asher",  ##  Asher -- 102
	"asia" => "Asia",  ##  Asia -- 717 :: asia -- 3
	"asian" => "Asian",  ##  Asian -- 272 :: asian -- 2
	"assyria" => "Assyria",  ##  Assyria -- 267
	"athenian" => "Athenian",  ##  Athenian -- 80
	"athens" => "Athens",  ##  Athens -- 298
	"atlanta" => "Atlanta",  ##  Atlanta -- 120
	"atlantic" => "Atlantic",  ##  Atlantic -- 339 :: atlantic -- 5
	"atlas" => "Atlas",  ##  Atlas -- 78 :: atlas -- 15
	"august" => "August",  ##  August -- 2468 :: august -- 5
	"augustus" => "Augustus",  ##  Augustus -- 90
	"austin" => "Austin",  ##  Austin -- 118
	"australia" => "Australia",  ##  Australia -- 742 :: australia -- 1
	"australian" => "Australian",  ##  Australian -- 459 :: australian -- 1
	"austria" => "Austria",  ##  Austria -- 455 :: austria -- 1
	"austrian" => "Austrian",  ##  Austrian -- 409 :: austrian -- 1
	"austro" => "Austro",  ##  Austro -- 83
	# "aviv" => "Aviv",  ##  Aviv -- 83
	"azariah" => "Azariah",  ##  Azariah -- 99
	"azerbaijan" => "Azerbaijan",  ##  Azerbaijan -- 286
	"baal" => "Baal",  ##  Baal -- 240 :: baal -- 14
	"babylon" => "Babylon",  ##  Babylon -- 617
	"bach" => "Bach",  ##  Bach -- 103
	"baden" => "Baden",  ##  Baden -- 85
	"baghdad" => "Baghdad",  ##  Baghdad -- 116
	# "baker" => "Baker",  ##  Baker -- 148 :: baker -- 20
	"baku" => "Baku",  ##  Baku -- 90
	"balaam" => "Balaam",  ##  Balaam -- 122
	"balak" => "Balak",  ##  Balak -- 86
	"balkan" => "Balkan",  ##  Balkan -- 80
	"balkans" => "Balkans",  ##  Balkans -- 89
	"baltic" => "Baltic",  ##  Baltic -- 158 :: baltic -- 1
	"baltimore" => "Baltimore",  ##  Baltimore -- 90
	"bangladesh" => "Bangladesh",  ##  Bangladesh -- 75
	"barack" => "Barack",  ##  Barack -- 85 :: barack -- 1
	"barbara" => "Barbara",  ##  Barbara -- 163
	"barcelona" => "Barcelona",  ##  Barcelona -- 191
	# "baron" => "Baron",  ##  Baron -- 164 :: baron -- 33
	"baruch" => "Baruch",  ##  Baruch -- 74
	"bashan" => "Bashan",  ##  Bashan -- 118
	"batman" => "Batman",  ##  Batman -- 190
	"bavaria" => "Bavaria",  ##  Bavaria -- 99
	"bay" => "Bay",  ##  Bay -- 332 :: bay -- 76
	"beebe" => "Beebe",  ##  Beebe -- 76
	"beijing" => "Beijing",  ##  Beijing -- 199
	"belarus" => "Belarus",  ##  Belarus -- 104
	"belfast" => "Belfast",  ##  Belfast -- 73
	"belgian" => "Belgian",  ##  Belgian -- 326
	"belgium" => "Belgium",  ##  Belgium -- 333
	"belgrade" => "Belgrade",  ##  Belgrade -- 71
	"ben" => "Ben",  ##  Ben -- 274 :: ben -- 66
	"benaiah" => "Benaiah",  ##  Benaiah -- 84
	"benjamin" => "Benjamin",  ##  Benjamin -- 488
	"bennett" => "Bennett",  ##  Bennett -- 83
	"berlin" => "Berlin",  ##  Berlin -- 738
	"bernard" => "Bernard",  ##  Bernard -- 133
	"bessie" => "Bessie",  ##  Bessie -- 130
	"beth" => "Beth",  ##  Beth -- 261 :: beth -- 12
	"bethel" => "Bethel",  ##  Bethel -- 139
	"bethlehem" => "Bethlehem",  ##  Bethlehem -- 110
	"betsy" => "Betsy",  ##  Betsy -- 90
	"bible" => "Bible",  ##  Bible -- 353 :: bible -- 11
	"billy" => "Billy",  ##  Billy -- 151 :: billy -- 1
	"birmingham" => "Birmingham",  ##  Birmingham -- 134 :: birmingham -- 1
	"bob" => "Bob",  ##  Bob -- 178
	"boeing" => "Boeing",  ##  Boeing -- 135 :: boeing -- 1
	"bologna" => "Bologna",  ##  Bologna -- 126
	"bosnia" => "Bosnia",  ##  Bosnia -- 148 :: bosnia -- 1
	"boston" => "Boston",  ##  Boston -- 351
	# "brainiac" => "Brainiac",  ##  Brainiac -- 81
	"brazil" => "Brazil",  ##  Brazil -- 404 :: brazil -- 2
	"brian" => "Brian",  ##  Brian -- 149 :: brian -- 1
	"brisbane" => "Brisbane",  ##  Brisbane -- 77
	"bristol" => "Bristol",  ##  Bristol -- 74
	"britain" => "Britain",  ##  Britain -- 854
	"british" => "British",  ##  British -- 3209 :: british -- 7
	"broadway" => "Broadway",  ##  Broadway -- 135
	"brooklyn" => "Brooklyn",  ##  Brooklyn -- 137
	"brown" => "Brown",  ##  Brown -- 375 :: brown -- 68
	"bruce" => "Bruce",  ##  Bruce -- 176
	"brussels" => "Brussels",  ##  Brussels -- 244
	"bucharest" => "Bucharest",  ##  Bucharest -- 86
	"budapest" => "Budapest",  ##  Budapest -- 96
	"buddha" => "Buddha",  ##  Buddha -- 99 :: buddha -- 1
	"buddhism" => "Buddhism",  ##  Buddhism -- 188
	"buddhist" => "Buddhist",  ##  Buddhist -- 278 :: buddhist -- 3
	# "buenos" => "Buenos",  ##  Buenos -- 168
	# "buffalo" => "Buffalo",  ##  Buffalo -- 82 :: buffalo -- 9
	"bulgaria" => "Bulgaria",  ##  Bulgaria -- 245 :: bulgaria -- 1
	"bulgarian" => "Bulgarian",  ##  Bulgarian -- 285
	# "bureau" => "Bureau",  ##  Bureau -- 137 :: bureau -- 26
	"byzantine" => "Byzantine",  ##  Byzantine -- 359 :: byzantine -- 2
	"byzantines" => "Byzantines",  ##  Byzantines -- 91
	"caesar" => "Caesar",  ##  Caesar -- 122
	"cairo" => "Cairo",  ##  Cairo -- 118 :: cairo -- 1
	"caleb" => "Caleb",  ##  Caleb -- 78
	"california" => "California",  ##  California -- 754 :: california -- 2
	"cambodia" => "Cambodia",  ##  Cambodia -- 84 :: cambodia -- 1
	"cambridge" => "Cambridge",  ##  Cambridge -- 201
	"cameron" => "Cameron",  ##  Cameron -- 133
	"campbell" => "Campbell",  ##  Campbell -- 103
	"canaan" => "Canaan",  ##  Canaan -- 209
	"canaanites" => "Canaanites",  ##  Canaanites -- 103
	"canada" => "Canada",  ##  Canada -- 873 :: canada -- 3
	"canadian" => "Canadian",  ##  Canadian -- 463
	"canary" => "Canary",  ##  Canary -- 79 :: canary -- 4
	"cape" => "Cape",  ##  Cape -- 174 :: cape -- 16
	"caribbean" => "Caribbean",  ##  Caribbean -- 172 :: caribbean -- 5
	"carl" => "Carl",  ##  Carl -- 276
	"carlo" => "Carlo",  ##  Carlo -- 185
	"carlos" => "Carlos",  ##  Carlos -- 184 :: carlos -- 1
	"carnegie" => "Carnegie",  ##  Carnegie -- 73
	"carolina" => "Carolina",  ##  Carolina -- 277 :: carolina -- 3
	"caroline" => "Caroline",  ##  Caroline -- 78
	"carter" => "Carter",  ##  Carter -- 161
	"castile" => "Castile",  ##  Castile -- 79
	"castro" => "Castro",  ##  Castro -- 157
	"catalan" => "Catalan",  ##  Catalan -- 96
	"catania" => "Catania",  ##  Catania -- 108
	"catherine" => "Catherine",  ##  Catherine -- 168
	"catholic" => "Catholic",  ##  Catholic -- 938 :: catholic -- 29
	"catholicism" => "Catholicism",  ##  Catholicism -- 71 :: catholicism -- 1
	"catholics" => "Catholics",  ##  Catholics -- 174
	"caucasus" => "Caucasus",  ##  Caucasus -- 93
	"celtic" => "Celtic",  ##  Celtic -- 82 :: celtic -- 1
	"chaldeans" => "Chaldeans",  ##  Chaldeans -- 143
	"chamberlain" => "Chamberlain",  ##  Chamberlain -- 87 :: chamberlain -- 11
	"charles" => "Charles",  ##  Charles -- 1127 :: charles -- 2
	"charlie" => "Charlie",  ##  Charlie -- 137
	"charlotte" => "Charlotte",  ##  Charlotte -- 172
	"chavez" => "Chavez",  ##  Chavez -- 88
	"chen" => "Chen",  ##  Chen -- 88
	"cherokee" => "Cherokee",  ##  Cherokee -- 95
	"chiang" => "Chiang",  ##  Chiang -- 104
	"chicago" => "Chicago",  ##  Chicago -- 442 :: chicago -- 2
	"chile" => "Chile",  ##  Chile -- 216
	"china" => "China",  ##  China -- 1636 :: china -- 26
	"chinese" => "Chinese",  ##  Chinese -- 1613 :: chinese -- 8
	"chisciotti" => "Chisciotti",  ##  Chisciotti -- 80
	"chris" => "Chris",  ##  Chris -- 148
	"christ" => "Christ",  ##  Christ -- 1474 :: christ -- 1
	"christian" => "Christian",  ##  Christian -- 1265 :: christian -- 2
	"christianity" => "Christianity",  ##  Christianity -- 347
	"christians" => "Christians",  ##  Christians -- 396 :: christians -- 4
	"christie" => "Christie",  ##  Christie -- 78
	"christmas" => "Christmas",  ##  Christmas -- 320 :: christmas -- 7
	"christopher" => "Christopher",  ##  Christopher -- 157
	"chuck" => "Chuck",  ##  Chuck -- 79 :: chuck -- 5
	"churchill" => "Churchill",  ##  Churchill -- 229 :: churchill -- 1
	"clark" => "Clark",  ##  Clark -- 167
	"clarke" => "Clarke",  ##  Clarke -- 76
	"claude" => "Claude",  ##  Claude -- 93
	"cleveland" => "Cleveland",  ##  Cleveland -- 109
	"clinton" => "Clinton",  ##  Clinton -- 135
	"collins" => "Collins",  ##  Collins -- 94
	"cologne" => "Cologne",  ##  Cologne -- 84 :: cologne -- 1
	"colombia" => "Colombia",  ##  Colombia -- 138
	"colombian" => "Colombian",  ##  Colombian -- 89
	# "colonel" => "Colonel",  ##  Colonel -- 316 :: colonel -- 104
	"colorado" => "Colorado",  ##  Colorado -- 139
	"columbia" => "Columbia",  ##  Columbia -- 283 :: columbia -- 1
	"columbus" => "Columbus",  ##  Columbus -- 105
	# "commissioner" => "Commissioner",  ##  Commissioner -- 214 :: commissioner -- 71
	# "commons" => "Commons",  ##  Commons -- 150 :: commons -- 23
	# "commonwealth" => "Commonwealth",  ##  Commonwealth -- 164 :: commonwealth -- 9
	# "confederate" => "Confederate",  ##  Confederate -- 147 :: confederate -- 7
	# "confederation" => "Confederation",  ##  Confederation -- 86 :: confederation -- 26
	"congo" => "Congo",  ##  Congo -- 133
	# "congress" => "Congress",  ##  Congress -- 694 :: congress -- 110
	"connecticut" => "Connecticut",  ##  Connecticut -- 109
	# "conservatory" => "Conservatory",  ##  Conservatory -- 115 :: conservatory -- 29
	"constantine" => "Constantine",  ##  Constantine -- 157
	"constantinople" => "Constantinople",  ##  Constantinople -- 219
	"copenhagen" => "Copenhagen",  ##  Copenhagen -- 122 :: copenhagen -- 1
	"cornell" => "Cornell",  ##  Cornell -- 118
	# "corporation" => "Corporation",  ##  Corporation -- 295 :: corporation -- 69
	# "costa" => "Costa",  ##  Costa -- 81
	# "council" => "Council",  ##  Council -- 1587 :: council -- 521
	# "countess" => "Countess",  ##  Countess -- 223 :: countess -- 22
	# "creek" => "Creek",  ##  Creek -- 165 :: creek -- 33
	"crete" => "Crete",  ##  Crete -- 71
	"crimea" => "Crimea",  ##  Crimea -- 125 :: crimea -- 1
	"crimean" => "Crimean",  ##  Crimean -- 93
	"croatia" => "Croatia",  ##  Croatia -- 143
	"croatian" => "Croatian",  ##  Croatian -- 161
	"cruz" => "Cruz",  ##  Cruz -- 83
	"cuba" => "Cuba",  ##  Cuba -- 255
	"cuban" => "Cuban",  ##  Cuban -- 148
	"cyprus" => "Cyprus",  ##  Cyprus -- 207
	"cyrus" => "Cyrus",  ##  Cyrus -- 85 :: cyrus -- 1
	"czech" => "Czech",  ##  Czech -- 246 :: czech -- 1
	"czechoslovakia" => "Czechoslovakia",  ##  Czechoslovakia -- 125
	"dakota" => "Dakota",  ##  Dakota -- 102 :: dakota -- 1
	"dallas" => "Dallas",  ##  Dallas -- 122
	"damascus" => "Damascus",  ##  Damascus -- 237 :: damascus -- 1
	"dan" => "Dan",  ##  Dan -- 277 :: dan -- 10
	"daniel" => "Daniel",  ##  Daniel -- 464
	"danish" => "Danish",  ##  Danish -- 377
	"danube" => "Danube",  ##  Danube -- 71
	"darius" => "Darius",  ##  Darius -- 79
	"dave" => "Dave",  ##  Dave -- 77
	"david" => "David",  ##  David -- 3036 :: david -- 3
	"davis" => "Davis",  ##  Davis -- 195 :: davis -- 1
	"december" => "December",  ##  December -- 2517 :: december -- 1
	"democrats" => "Democrats",  ##  Democrats -- 144 :: democrats -- 11
	"denmark" => "Denmark",  ##  Denmark -- 363 :: denmark -- 1
	"denver" => "Denver",  ##  Denver -- 80
	"derby" => "Derby",  ##  Derby -- 90 :: derby -- 12
	"detroit" => "Detroit",  ##  Detroit -- 146
	"deutsche" => "Deutsche",  ##  Deutsche -- 91 :: deutsche -- 4
	"diana" => "Diana",  ##  Diana -- 243
	"dick" => "Dick",  ##  Dick -- 88
	"diego" => "Diego",  ##  Diego -- 215 :: diego -- 1
	"dion" => "Dion",  ##  Dion -- 90
	"disney" => "Disney",  ##  Disney -- 271 :: disney -- 1
	"dolly" => "Dolly",  ##  Dolly -- 437
	"dominican" => "Dominican",  ##  Dominican -- 81
	"don" => "Don",  ##  Don -- 474 :: don -- 32
	"donald" => "Donald",  ##  Donald -- 222 :: donald -- 3
	"douglas" => "Douglas",  ##  Douglas -- 184 :: douglas -- 1
	"dr" => "Dr",  ##  Dr -- 609
	"dresden" => "Dresden",  ##  Dresden -- 79
	"dubai" => "Dubai",  ##  Dubai -- 73 :: dubai -- 1
	"dublin" => "Dublin",  ##  Dublin -- 184
	"duchess" => "Duchess",  ##  Duchess -- 204 :: duchess -- 20
	"duke" => "Duke",  ##  Duke -- 534 :: duke -- 123
	"duncan" => "Duncan",  ##  Duncan -- 74
	"dutch" => "Dutch",  ##  Dutch -- 828 :: dutch -- 1
	"dylan" => "Dylan",  ##  Dylan -- 80
	"earl" => "Earl",  ##  Earl -- 183 :: earl -- 4
	"easter" => "Easter",  ##  Easter -- 114 :: easter -- 1
	"ecuador" => "Ecuador",  ##  Ecuador -- 78 :: ecuador -- 2
	"eden" => "Eden",  ##  Eden -- 105
	"edinburgh" => "Edinburgh",  ##  Edinburgh -- 150
	"edmund" => "Edmund",  ##  Edmund -- 79
	"edom" => "Edom",  ##  Edom -- 203 :: edom -- 20
	"edward" => "Edward",  ##  Edward -- 463
	"egypt" => "Egypt",  ##  Egypt -- 1809
	"egyptian" => "Egyptian",  ##  Egyptian -- 376
	"egyptians" => "Egyptians",  ##  Egyptians -- 252 :: egyptians -- 1
	"einstein" => "Einstein",  ##  Einstein -- 98
	"el" => "El",  ##  El -- 513 :: el -- 97
	"eleazar" => "Eleazar",  ##  Eleazar -- 163
	"elena" => "Elena",  ##  Elena -- 78
	"eli" => "Eli",  ##  Eli -- 92 :: eli -- 1
	"elias" => "Elias",  ##  Elias -- 77
	"elijah" => "Elijah",  ##  Elijah -- 202
	"elisabeth" => "Elisabeth",  ##  Elisabeth -- 97
	"elisha" => "Elisha",  ##  Elisha -- 126
	"eliza" => "Eliza",  ##  Eliza -- 75
	"elizabeth" => "Elizabeth",  ##  Elizabeth -- 417
	"ellis" => "Ellis",  ##  Ellis -- 84
	"england" => "England",  ##  England -- 1501 :: england -- 4
	"english" => "English",  ##  English -- 2205 :: english -- 2
	"ephraim" => "Ephraim",  ##  Ephraim -- 343
	"eric" => "Eric",  ##  Eric -- 170
	"erik" => "Erik",  ##  
	"eryk" => "Eryk",  ##  
	"ernest" => "Ernest",  ##  Ernest -- 98
	"ernst" => "Ernst",  ##  Ernst -- 98
	"esau" => "Esau",  ##  Esau -- 188
	"esther" => "Esther",  ##  Esther -- 154
	"estonia" => "Estonia",  ##  Estonia -- 140
	"estonian" => "Estonian",  ##  Estonian -- 109
	"ethiopia" => "Ethiopia",  ##  Ethiopia -- 181
	"ethiopian" => "Ethiopian",  ##  Ethiopian -- 138
	"eugene" => "Eugene",  ##  Eugene -- 111
	"europe" => "Europe",  ##  Europe -- 2603 :: europe -- 8
	"european" => "European",  ##  European -- 2740 :: european -- 2
	"europeans" => "Europeans",  ##  Europeans -- 161
	"evans" => "Evans",  ##  Evans -- 92
	"eyre" => "Eyre",  ##  Eyre -- 103
	"ezra" => "Ezra",  ##  Ezra -- 83
	"facebook" => "Facebook",  ##  Facebook -- 192 :: facebook -- 9
	"fairfax" => "Fairfax",  ##  Fairfax -- 142
	"fe" => "Fe",  ##  Fe -- 118 :: fe -- 4
	"february" => "February",  ##  February -- 2234 :: february -- 2
	# "federation" => "Federation",  ##  Federation -- 292 :: federation -- 76
	"felix" => "Felix",  ##  Felix -- 111 :: felix -- 4
	"ferdinand" => "Ferdinand",  ##  Ferdinand -- 167
	"fernando" => "Fernando",  ##  Fernando -- 85
	"finland" => "Finland",  ##  Finland -- 238
	"finnish" => "Finnish",  ##  Finnish -- 207
	"flemish" => "Flemish",  ##  Flemish -- 75
	"florence" => "Florence",  ##  Florence -- 231
	"florida" => "Florida",  ##  Florida -- 375 :: florida -- 1
	# "ford" => "Ford",  ##  Ford -- 161 :: ford -- 5
	# "fox" => "Fox",  ##  Fox -- 165 :: fox -- 26
	"france" => "France",  ##  France -- 2420 :: france -- 4
	"francesco" => "Francesco",  ##  Francesco -- 173
	"francis" => "Francis",  ##  Francis -- 277 :: francis -- 2
	"francisco" => "Francisco",  ##  Francisco -- 588 :: francisco -- 1
	"franco" => "Franco",  ##  Franco -- 220 :: franco -- 1
	"francois" => "Francois",  ##  Francois -- 169
	"frank" => "Frank",  ##  Frank -- 340 :: frank -- 21
	"frankfurt" => "Frankfurt",  ##  Frankfurt -- 105
	"franklin" => "Franklin",  ##  Franklin -- 139 :: franklin -- 1
	"franz" => "Franz",  ##  Franz -- 142 :: franz -- 1
	"fred" => "Fred",  ##  Fred -- 86
	"frederick" => "Frederick",  ##  Frederick -- 238
	"french" => "French",  ##  French -- 3646 :: french -- 4
	"friday" => "Friday",  ##  Friday -- 279 :: friday -- 1
	"friedrich" => "Friedrich",  ##  Friedrich -- 173 :: friedrich -- 1
	# "furthermore" => "Furthermore",  ##  Furthermore -- 305 :: furthermore -- 22
	"gabriel" => "Gabriel",  ##  Gabriel -- 103
	"gad" => "Gad",  ##  Gad -- 150 :: gad -- 6
	"gaetano" => "Gaetano",  ##  Gaetano -- 81
	"galicia" => "Galicia",  ##  Galicia -- 76 :: galicia -- 1
	"galilee" => "Galilee",  ##  Galilee -- 197
	"garcia" => "Garcia",  ##  Garcia -- 97
	"gary" => "Gary",  ##  Gary -- 75 :: gary -- 1
	"gath" => "Gath",  ##  Gath -- 78 :: gath -- 1
	"gaza" => "Gaza",  ##  Gaza -- 120 :: gaza -- 2
	"genesis" => "Genesis",  ##  Genesis -- 84 :: genesis -- 7
	"geneva" => "Geneva",  ##  Geneva -- 166 :: geneva -- 2
	"genoa" => "Genoa",  ##  Genoa -- 100
	"gentiles" => "Gentiles",  ##  Gentiles -- 221 :: gentiles -- 7
	"georg" => "Georg",  ##  Georg -- 95
	"george" => "George",  ##  George -- 1472 :: george -- 1
	"georgia" => "Georgia",  ##  Georgia -- 409
	"georgian" => "Georgian",  ##  Georgian -- 199
	"german" => "German",  ##  German -- 2808 :: german -- 4
	"germanic" => "Germanic",  ##  Germanic -- 72
	"germans" => "Germans",  ##  Germans -- 401
	"germany" => "Germany",  ##  Germany -- 1836 :: germany -- 1
	"gibeah" => "Gibeah",  ##  Gibeah -- 91
	"gibeon" => "Gibeon",  ##  Gibeon -- 74
	"gideon" => "Gideon",  ##  Gideon -- 89
	"gilbert" => "Gilbert",  ##  Gilbert -- 93
	"gilead" => "Gilead",  ##  Gilead -- 233 :: gilead -- 31
	"gilgal" => "Gilgal",  ##  Gilgal -- 82
	"giovanni" => "Giovanni",  ##  Giovanni -- 240
	"giuseppe" => "Giuseppe",  ##  Giuseppe -- 216
	"glasgow" => "Glasgow",  ##  Glasgow -- 101
	"god" => "God",  ##  God -- 9893 :: god -- 424
	"google" => "Google",  ##  Google -- 366 :: google -- 8
	"gordon" => "Gordon",  ##  Gordon -- 182
	"gothic" => "Gothic",  ##  Gothic -- 88 :: gothic -- 14
	"graham" => "Graham",  ##  Graham -- 171
	"granada" => "Granada",  ##  Granada -- 92
	"grand" => "Grand",  ##  Grand -- 697 :: grand -- 221
	"grande" => "Grande",  ##  Grande -- 117 :: grande -- 11
	"greece" => "Greece",  ##  Greece -- 609 :: greece -- 1
	"greek" => "Greek",  ##  Greek -- 1348 :: greek -- 2
	"greeks" => "Greeks",  ##  Greeks -- 286 :: greeks -- 1
	"greenland" => "Greenland",  ##  Greenland -- 77
	"gregory" => "Gregory",  ##  Gregory -- 127
	"griffin" => "Griffin",  ##  Griffin -- 83 :: griffin -- 2
	"guardians" => "Guardians",  ##  Guardians -- 125 :: guardians -- 25
	"guatemala" => "Guatemala",  ##  Guatemala -- 97
	"guinea" => "Guinea",  ##  Guinea -- 113 :: guinea -- 12
	"gulf" => "Gulf",  ##  Gulf -- 194 :: gulf -- 17
	"gustav" => "Gustav",  ##  Gustav -- 129
	"hague" => "Hague",  ##  Hague -- 95
	"hal" => "Hal",  ##  Hal -- 90
	"haman" => "Haman",  ##  Haman -- 102
	"hamath" => "Hamath",  ##  Hamath -- 74
	"hamburg" => "Hamburg",  ##  Hamburg -- 106
	"hamilton" => "Hamilton",  ##  Hamilton -- 161
	"han" => "Han",  ##  Han -- 158 :: han -- 11
	"handel" => "Handel",  ##  Handel -- 141
	"hannah" => "Hannah",  ##  Hannah -- 106
	"hans" => "Hans",  ##  Hans -- 194 :: hans -- 2
	"harold" => "Harold",  ##  Harold -- 78
	"harris" => "Harris",  ##  Harris -- 368
	"harry" => "Harry",  ##  Harry -- 216 :: harry -- 1
	"hart" => "Hart",  ##  Hart -- 79 :: hart -- 17
	"harvard" => "Harvard",  ##  Harvard -- 115
	"harvey" => "Harvey",  ##  Harvey -- 72
	"hawaii" => "Hawaii",  ##  Hawaii -- 130
	"hebrew" => "Hebrew",  ##  Hebrew -- 341
	"hebron" => "Hebron",  ##  Hebron -- 151
	"heinrich" => "Heinrich",  ##  Heinrich -- 98
	"helen" => "Helen",  ##  Helen -- 121
	"helsinki" => "Helsinki",  ##  Helsinki -- 84 :: helsinki -- 1
	"henri" => "Henri",  ##  Henri -- 119 :: henri -- 1
	"henry" => "Henry",  ##  Henry -- 754 :: henry -- 1
	"herbert" => "Herbert",  ##  Herbert -- 100
	"hermann" => "Hermann",  ##  Hermann -- 89
	"herod" => "Herod",  ##  Herod -- 100
	"herzegovina" => "Herzegovina",  ##  Herzegovina -- 99 :: herzegovina -- 1
	"heshbon" => "Heshbon",  ##  Heshbon -- 74
	"hezekiah" => "Hezekiah",  ##  Hezekiah -- 269
	"hindu" => "Hindu",  ##  Hindu -- 111
	"hitler" => "Hitler",  ##  Hitler -- 322
	"hittite" => "Hittite",  ##  Hittite -- 71
	"holland" => "Holland",  ##  Holland -- 124 :: holland -- 4
	"hollywood" => "Hollywood",  ##  Hollywood -- 235
	"holmes" => "Holmes",  ##  Holmes -- 127 :: holmes -- 1
	"holocaust" => "Holocaust",  ##  Holocaust -- 109 :: holocaust -- 5
	"hong" => "Hong",  ##  Hong -- 293 :: hong -- 2
	"houston" => "Houston",  ##  Houston -- 138 :: houston -- 1
	"howard" => "Howard",  ##  Howard -- 213
	"hudson" => "Hudson",  ##  Hudson -- 103
	"hugh" => "Hugh",  ##  Hugh -- 101
	"hugo" => "Hugo",  ##  Hugo -- 96
	"hungarian" => "Hungarian",  ##  Hungarian -- 352
	"hungary" => "Hungary",  ##  Hungary -- 363
	"iceland" => "Iceland",  ##  Iceland -- 159
	"icelandic" => "Icelandic",  ##  Icelandic -- 82
	"illinois" => "Illinois",  ##  Illinois -- 128
	"inc" => "Inc",  ##  Inc -- 211 :: inc -- 7
	"india" => "India",  ##  India -- 1099 :: india -- 4
	"indian" => "Indian",  ##  Indian -- 952 :: indian -- 2
	"indiana" => "Indiana",  ##  Indiana -- 86 :: indiana -- 1
	"indians" => "Indians",  ##  Indians -- 273
	"indies" => "Indies",  ##  Indies -- 139
	"indonesia" => "Indonesia",  ##  Indonesia -- 148 :: indonesia -- 1
	"indonesian" => "Indonesian",  ##  Indonesian -- 93
	"ingram" => "Ingram",  ##  Ingram -- 87
	# "institute" => "Institute",  ##  Institute -- 746 :: institute -- 126
	"iowa" => "Iowa",  ##  Iowa -- 127
	"iran" => "Iran",  ##  Iran -- 443 :: iran -- 1
	"iranian" => "Iranian",  ##  Iranian -- 266 :: iranian -- 1
	"iraq" => "Iraq",  ##  Iraq -- 409
	"iraqi" => "Iraqi",  ##  Iraqi -- 211
	"ireland" => "Ireland",  ##  Ireland -- 661 :: ireland -- 2
	"irene" => "Irene",  ##  Irene -- 72
	"irish" => "Irish",  ##  Irish -- 479
	"isaac" => "Isaac",  ##  Isaac -- 399 :: isaac -- 1
	"isabella" => "Isabella",  ##  Isabella -- 116
	"isaiah" => "Isaiah",  ##  Isaiah -- 148
	"ishmael" => "Ishmael",  ##  Ishmael -- 108
	"islam" => "Islam",  ##  Islam -- 341 :: islam -- 2
	"islamic" => "Islamic",  ##  Islamic -- 550 :: islamic -- 1
	"israel" => "Israel",  ##  Israel -- 6103
	"israeli" => "Israeli",  ##  Israeli -- 497
	"israelites" => "Israelites",  ##  Israelites -- 90
	"issachar" => "Issachar",  ##  Issachar -- 87
	"istanbul" => "Istanbul",  ##  Istanbul -- 174
	"italian" => "Italian",  ##  Italian -- 2222 :: italian -- 10
	"italians" => "Italians",  ##  Italians -- 175
	"italy" => "Italy",  ##  Italy -- 1810 :: italy -- 2
	"ivan" => "Ivan",  ##  Ivan -- 157
	"ivanovna" => "Ivanovna",  ##  Ivanovna -- 71
	"jack" => "Jack",  ##  Jack -- 398 :: jack -- 6
	"jackson" => "Jackson",  ##  Jackson -- 314
	"jacob" => "Jacob",  ##  Jacob -- 855
	"jacques" => "Jacques",  ##  Jacques -- 206 :: jacques -- 1
	"jake" => "Jake",  ##  Jake -- 74
	"jamaica" => "Jamaica",  ##  Jamaica -- 81
	"james" => "James",  ##  James -- 929 :: james -- 1
	"jan" => "Jan",  ##  Jan -- 156 :: jan -- 1
	"jane" => "Jane",  ##  Jane -- 467
	"january" => "January",  ##  January -- 2401 :: january -- 3
	"japan" => "Japan",  ##  Japan -- 1337
	"japanese" => "Japanese",  ##  Japanese -- 1525 :: japanese -- 2
	"jason" => "Jason",  ##  Jason -- 74
	"java" => "Java",  ##  Java -- 100 :: java -- 1
	"jay" => "Jay",  ##  Jay -- 102 :: jay -- 1
	"jean" => "Jean",  ##  Jean -- 502 :: jean -- 3
	"jeff" => "Jeff",  ##  Jeff -- 89
	"jefferson" => "Jefferson",  ##  Jefferson -- 112 :: jefferson -- 2
	"jehoiada" => "Jehoiada",  ##  Jehoiada -- 104
	"jehoiakim" => "Jehoiakim",  ##  Jehoiakim -- 74
	"jehoshaphat" => "Jehoshaphat",  ##  Jehoshaphat -- 176
	"jehu" => "Jehu",  ##  Jehu -- 120
	"jennifer" => "Jennifer",  ##  Jennifer -- 138 :: jennifer -- 13
	"jeremiah" => "Jeremiah",  ##  Jeremiah -- 330
	"jericho" => "Jericho",  ##  Jericho -- 231
	"jeroboam" => "Jeroboam",  ##  Jeroboam -- 204
	"jerry" => "Jerry",  ##  Jerry -- 111
	"jersey" => "Jersey",  ##  Jersey -- 230 :: jersey -- 13
	"jerusalem" => "Jerusalem",  ##  Jerusalem -- 2055
	"jesse" => "Jesse",  ##  Jesse -- 171
	"jesus" => "Jesus",  ##  Jesus -- 2726 :: jesus -- 5
	"jew" => "Jew",  ##  Jew -- 178
	"jewish" => "Jewish",  ##  Jewish -- 1620 :: jewish -- 1
	"jews" => "Jews",  ##  Jews -- 1620 :: jews -- 2
	"jezreel" => "Jezreel",  ##  Jezreel -- 71
	"jim" => "Jim",  ##  Jim -- 212
	"jimmy" => "Jimmy",  ##  Jimmy -- 147
	"jin" => "Jin",  ##  Jin -- 71 :: jin -- 4
	"joab" => "Joab",  ##  Joab -- 277
	"joan" => "Joan",  ##  Joan -- 82
	"joash" => "Joash",  ##  Joash -- 98
	"joe" => "Joe",  ##  Joe -- 210
	"joel" => "Joel",  ##  Joel -- 89
	"johann" => "Johann",  ##  Johann -- 160
	"johannes" => "Johannes",  ##  Johannes -- 75
	"john" => "John",  ##  John -- 2891 :: john -- 8
	"johnny" => "Johnny",  ##  Johnny -- 122 :: johnny -- 2
	"johnson" => "Johnson",  ##  Johnson -- 464
	"jon" => "Jon",  ##  Jon -- 77
	"jonathan" => "Jonathan",  ##  Jonathan -- 332
	"jones" => "Jones",  ##  Jones -- 295 :: jones -- 1
	"jordan" => "Jordan",  ##  Jordan -- 694
	"jose" => "Jose",  ##  Jose -- 266
	"joseph" => "Joseph",  ##  Joseph -- 1065 :: joseph -- 1
	"josh" => "Josh",  ##  Josh -- 77
	"joshua" => "Joshua",  ##  Joshua -- 506
	"josiah" => "Josiah",  ##  Josiah -- 133
	"jr" => "Jr",  ##  Jr -- 173 :: jr -- 2
	"juan" => "Juan",  ##  Juan -- 296 :: juan -- 1
	"judah" => "Judah",  ##  Judah -- 1683
	"judaism" => "Judaism",  ##  Judaism -- 329
	"judas" => "Judas",  ##  Judas -- 90
	"judea" => "Judea",  ##  Judea -- 79
	"julia" => "Julia",  ##  Julia -- 88
	"julian" => "Julian",  ##  Julian -- 85
	"julius" => "Julius",  ##  Julius -- 105
	"july" => "July",  ##  July -- 2671 :: july -- 4
	"june" => "June",  ##  June -- 2844
	"kabbalah" => "Kabbalah",  ##  Kabbalah -- 72 :: kabbalah -- 8
	"kai" => "Kai",  ##  Kai -- 71 :: kai -- 9
	"kansas" => "Kansas",  ##  Kansas -- 196 :: kansas -- 1
	"karenin" => "Karenin",  ##  Karenin -- 441
	"karl" => "Karl",  ##  Karl -- 196 :: karl -- 1
	"kate" => "Kate",  ##  Kate -- 106
	"kelly" => "Kelly",  ##  Kelly -- 77 :: kelly -- 1
	"kennedy" => "Kennedy",  ##  Kennedy -- 189 :: kennedy -- 1
	"kent" => "Kent",  ##  Kent -- 108
	"kentucky" => "Kentucky",  ##  Kentucky -- 102
	"kenya" => "Kenya",  ##  Kenya -- 94
	"kevin" => "Kevin",  ##  Kevin -- 85
	"khan" => "Khan",  ##  Khan -- 265 :: khan -- 17
	"khmer" => "Khmer",  ##  Khmer -- 84
	"kiev" => "Kiev",  ##  Kiev -- 103
	"kim" => "Kim",  ##  Kim -- 231
	"kitty" => "Kitty",  ##  Kitty -- 610
	"kong" => "Kong",  ##  Kong -- 276 :: kong -- 3
	"korea" => "Korea",  ##  Korea -- 492 :: korea -- 5
	"korean" => "Korean",  ##  Korean -- 419
	"kosovo" => "Kosovo",  ##  Kosovo -- 213
	"koznyshev" => "Koznyshev",  ##  Koznyshev -- 222
	"kurt" => "Kurt",  ##  Kurt -- 73
	"kuwait" => "Kuwait",  ##  Kuwait -- 79
	"kyoto" => "Kyoto",  ##  Kyoto -- 117
	"laban" => "Laban",  ##  Laban -- 102
	# "lane" => "Lane",  ##  Lane -- 121 :: lane -- 28
	# "lantern" => "Lantern",  ##  Lantern -- 160 :: lantern -- 18
	# "lanterns" => "Lanterns",  ##  Lanterns -- 76 :: lanterns -- 12
	# "las" => "Las",  ##  Las -- 181 :: las -- 40
	"latin" => "Latin",  ##  Latin -- 930 :: latin -- 9
	"laura" => "Laura",  ##  Laura -- 92
	"lawrence" => "Lawrence",  ##  Lawrence -- 139
	# "league" => "League",  ##  League -- 848 :: league -- 264
	"leah" => "Leah",  ##  Leah -- 96 :: leah -- 1
	"lebanese" => "Lebanese",  ##  Lebanese -- 80
	"lebanon" => "Lebanon",  ##  Lebanon -- 345
	"lee" => "Lee",  ##  Lee -- 405 :: lee -- 5
	"legion" => "Legion",  ##  Legion -- 390 :: legion -- 33
	"legionnaires" => "Legionnaires",  ##  Legionnaires -- 71 :: legionnaires -- 6
	"leipzig" => "Leipzig",  ##  Leipzig -- 84
	"lenin" => "Lenin",  ##  Lenin -- 71
	"leo" => "Leo",  ##  Leo -- 189
	"leon" => "Leon",  ##  Leon -- 142
	"leonard" => "Leonard",  ##  Leonard -- 79
	"leopold" => "Leopold",  ##  Leopold -- 117
	"levi" => "Levi",  ##  Levi -- 208
	"levin" => "Levin",  ##  Levin -- 1414
	"levites" => "Levites",  ##  Levites -- 534
	"lewis" => "Lewis",  ##  Lewis -- 180
	# "li" => "Li",  ##  Li -- 138 :: li -- 13
	"libya" => "Libya",  ##  Libya -- 100
	"lima" => "Lima",  ##  Lima -- 107 :: lima -- 2
	"lincoln" => "Lincoln",  ##  Lincoln -- 278
	"linux" => "Linux",  ##  Linux -- 164 :: linux -- 5
	"lisa" => "Lisa",  ##  Lisa -- 102 :: lisa -- 1
	"lisbon" => "Lisbon",  ##  Lisbon -- 159
	"liszt" => "Liszt",  ##  Liszt -- 77
	"lithuania" => "Lithuania",  ##  Lithuania -- 196 :: lithuania -- 1
	"lithuanian" => "Lithuanian",  ##  Lithuanian -- 144
	"liverpool" => "Liverpool",  ##  Liverpool -- 132
	"lloyd" => "Lloyd",  ##  Lloyd -- 118
	"london" => "London",  ##  London -- 1852 :: london -- 5
	"lopez" => "Lopez",  ##  Lopez -- 74
	"lord" => "Lord",  ##  Lord -- 3292 :: lord -- 599
	"lorenzo" => "Lorenzo",  ##  Lorenzo -- 93
	# "los" => "Los",  ##  Los -- 679 :: los -- 55
	"louis" => "Louis",  ##  Louis -- 775 :: louis -- 1
	"louise" => "Louise",  ##  Louise -- 115
	"louisiana" => "Louisiana",  ##  Louisiana -- 117
	"ltd" => "Ltd",  ##  Ltd -- 145 :: ltd -- 2
	# "lu" => "Lu",  ##  Lu -- 82 :: lu -- 17
	"lucas" => "Lucas",  ##  Lucas -- 97 :: lucas -- 1
	"lucia" => "Lucia",  ##  Lucia -- 71
	"lucy" => "Lucy",  ##  Lucy -- 72 :: lucy -- 1
	"ludwig" => "Ludwig",  ##  Ludwig -- 105
	"luigi" => "Luigi",  ##  Luigi -- 120
	"luis" => "Luis",  ##  Luis -- 112
	"luxembourg" => "Luxembourg",  ##  Luxembourg -- 131
	"lydia" => "Lydia",  ##  Lydia -- 113
	"lyon" => "Lyon",  ##  Lyon -- 72
	# "ma" => "Ma",  ##  Ma -- 106 :: ma -- 32
	"macedonia" => "Macedonia",  ##  Macedonia -- 248
	"macedonian" => "Macedonian",  ##  Macedonian -- 126 :: macedonian -- 1
	"madame" => "Madame",  ##  Madame -- 199
	"madison" => "Madison",  ##  Madison -- 95
	"madonna" => "Madonna",  ##  Madonna -- 76 :: madonna -- 1
	"madrid" => "Madrid",  ##  Madrid -- 273
	"magnus" => "Magnus",  ##  Magnus -- 94
	"maimonides" => "Maimonides",  ##  Maimonides -- 110
	"malay" => "Malay",  ##  Malay -- 94
	"malaysia" => "Malaysia",  ##  Malaysia -- 110
	"malta" => "Malta",  ##  Malta -- 193
	"manasseh" => "Manasseh",  ##  Manasseh -- 280
	"manchester" => "Manchester",  ##  Manchester -- 127
	"manhattan" => "Manhattan",  ##  Manhattan -- 110
	"manuel" => "Manuel",  ##  Manuel -- 136
	"march" => "March",  ##  March -- 2768 :: march -- 190
	"marco" => "Marco",  ##  Marco -- 146
	"marcus" => "Marcus",  ##  Marcus -- 98 :: marcus -- 1
	"margaret" => "Margaret",  ##  Margaret -- 165
	"maria" => "Maria",  ##  Maria -- 731
	"marie" => "Marie",  ##  Marie -- 289 :: marie -- 1
	"mario" => "Mario",  ##  Mario -- 154
	# "marquis" => "Marquis",  ##  Marquis -- 75 :: marquis -- 14
	"mars" => "Mars",  ##  Mars -- 167
	"marshal" => "Marshal",  ##  Marshal -- 126 :: marshal -- 31
	"marshall" => "Marshall",  ##  Marshall -- 95
	"martha" => "Martha",  ##  Martha -- 164
	"martin" => "Martin",  ##  Martin -- 508
	"marvel" => "Marvel",  ##  Marvel -- 102 :: marvel -- 28
	"marx" => "Marx",  ##  Marx -- 81
	"marxist" => "Marxist",  ##  Marxist -- 89
	"mary" => "Mary",  ##  Mary -- 964 :: mary -- 2
	"maryland" => "Maryland",  ##  Maryland -- 89
	"mason" => "Mason",  ##  Mason -- 111 :: mason -- 4
	"massachusetts" => "Massachusetts",  ##  Massachusetts -- 205
	"matt" => "Matt",  ##  Matt -- 80
	"matthew" => "Matthew",  ##  Matthew -- 147 :: matthew -- 1
	"maurice" => "Maurice",  ##  Maurice -- 97
	"max" => "Max",  ##  Max -- 187 :: max -- 9
	"maxwell" => "Maxwell",  ##  Maxwell -- 77
	"maya" => "Maya",  ##  Maya -- 117 :: maya -- 2
	# "meanwhile" => "Meanwhile",  ##  Meanwhile -- 355 :: meanwhile -- 67
	"mediterranean" => "Mediterranean",  ##  Mediterranean -- 371 :: mediterranean -- 1
	"meiji" => "Meiji",  ##  Meiji -- 73
	"melbourne" => "Melbourne",  ##  Melbourne -- 100
	"meli" => "Meli",  ##  Meli -- 71
	"mendoza" => "Mendoza",  ##  Mendoza -- 74
	"merari" => "Merari",  ##  Merari -- 76
	"mercury" => "Mercury",  ##  Mercury -- 96 :: mercury -- 24
	"messina" => "Messina",  ##  Messina -- 126
	"mexican" => "Mexican",  ##  Mexican -- 397 :: mexican -- 1
	"mexico" => "Mexico",  ##  Mexico -- 854 :: mexico -- 5
	"miami" => "Miami",  ##  Miami -- 116
	"michael" => "Michael",  ##  Michael -- 692 :: michael -- 2
	"michel" => "Michel",  ##  Michel -- 93 :: michel -- 1
	"michigan" => "Michigan",  ##  Michigan -- 148 :: michigan -- 2
	"microsoft" => "Microsoft",  ##  Microsoft -- 180 :: microsoft -- 4
	"midian" => "Midian",  ##  Midian -- 94
	"miguel" => "Miguel",  ##  Miguel -- 149
	"mike" => "Mike",  ##  Mike -- 156
	"milan" => "Milan",  ##  Milan -- 310 :: milan -- 1
	"miller" => "Miller",  ##  Miller -- 200 :: miller -- 2
	"ming" => "Ming",  ##  Ming -- 137 :: ming -- 1
	"minnesota" => "Minnesota",  ##  Minnesota -- 114
	"mishnah" => "Mishnah",  ##  Mishnah -- 75 :: mishnah -- 1
	# "miss" => "Miss",  ##  Miss -- 530 :: miss -- 71
	"mississippi" => "Mississippi",  ##  Mississippi -- 139 :: mississippi -- 1
	"missouri" => "Missouri",  ##  Missouri -- 144 :: missouri -- 1
	"mitchell" => "Mitchell",  ##  Mitchell -- 113
	"moab" => "Moab",  ##  Moab -- 342 :: moab -- 6
	"moldova" => "Moldova",  ##  Moldova -- 142
	"monday" => "Monday",  ##  Monday -- 105
	"mongol" => "Mongol",  ##  Mongol -- 137
	"mongolia" => "Mongolia",  ##  Mongolia -- 106
	"mongols" => "Mongols",  ##  Mongols -- 93
	"montana" => "Montana",  ##  Montana -- 82
	# "monte" => "Monte",  ##  Monte -- 107 :: monte -- 4
	"montgomery" => "Montgomery",  ##  Montgomery -- 71
	"montreal" => "Montreal",  ##  Montreal -- 118
	"moore" => "Moore",  ##  Moore -- 117
	"mordecai" => "Mordecai",  ##  Mordecai -- 127
	# "moreover" => "Moreover",  ##  Moreover -- 494 :: moreover -- 94
	"morgan" => "Morgan",  ##  Morgan -- 148
	"morocco" => "Morocco",  ##  Morocco -- 192 :: morocco -- 4
	"morris" => "Morris",  ##  Morris -- 122
	"moscow" => "Moscow",  ##  Moscow -- 625 :: moscow -- 1
	"moses" => "Moses",  ##  Moses -- 1834 :: moses -- 1
	"mozart" => "Mozart",  ##  Mozart -- 73
	"mr" => "Mr",  ##  Mr -- 939 :: mr -- 2
	"mrs" => "Mrs",  ##  Mrs -- 478
	"muhammad" => "Muhammad",  ##  Muhammad -- 157
	"muller" => "Muller",  ##  Muller -- 74
	"munich" => "Munich",  ##  Munich -- 105
	"murphy" => "Murphy",  ##  Murphy -- 78
	"murray" => "Murray",  ##  Murray -- 75
	"muslim" => "Muslim",  ##  Muslim -- 554
	"muslims" => "Muslims",  ##  Muslims -- 320 :: muslims -- 2
	"mussolini" => "Mussolini",  ##  Mussolini -- 72
	"nancy" => "Nancy",  ##  Nancy -- 98
	"naphtali" => "Naphtali",  ##  Naphtali -- 113 :: naphtali -- 1
	"naples" => "Naples",  ##  Naples -- 268
	"napoleon" => "Napoleon",  ##  Napoleon -- 282
	"napoleonic" => "Napoleonic",  ##  Napoleonic -- 80
	"nassau" => "Nassau",  ##  Nassau -- 73
	"nathan" => "Nathan",  ##  Nathan -- 143
	"nazareth" => "Nazareth",  ##  Nazareth -- 83 :: nazareth -- 2
	"nazi" => "Nazi",  ##  Nazi -- 447 :: nazi -- 1
	"nazis" => "Nazis",  ##  Nazis -- 164
	"nebraska" => "Nebraska",  ##  Nebraska -- 76
	"nebuchadnezzar" => "Nebuchadnezzar",  ##  Nebuchadnezzar -- 153
	"nelson" => "Nelson",  ##  Nelson -- 110 :: nelson -- 1
	"nepal" => "Nepal",  ##  Nepal -- 88
	"netherlands" => "Netherlands",  ##  Netherlands -- 485
	"nevada" => "Nevada",  ##  Nevada -- 104
	"newton" => "Newton",  ##  Newton -- 102 :: newton -- 1
	"nicaragua" => "Nicaragua",  ##  Nicaragua -- 77
	"nicholas" => "Nicholas",  ##  Nicholas -- 213
	"nick" => "Nick",  ##  Nick -- 137 :: nick -- 2
	"nicolas" => "Nicolas",  ##  Nicolas -- 96
	"nigeria" => "Nigeria",  ##  Nigeria -- 81
	"nile" => "Nile",  ##  Nile -- 72
	"nina" => "Nina",  ##  Nina -- 81
	"noah" => "Noah",  ##  Noah -- 147
	"nobel" => "Nobel",  ##  Nobel -- 232 :: nobel -- 3
	"norman" => "Norman",  ##  Norman -- 190 :: norman -- 1
	"norway" => "Norway",  ##  Norway -- 339
	"norwegian" => "Norwegian",  ##  Norwegian -- 312
	"nova" => "Nova",  ##  Nova -- 88 :: nova -- 14
	"november" => "November",  ##  November -- 2527 :: november -- 1
	"obama" => "Obama",  ##  Obama -- 214 :: obama -- 3
	"obed" => "Obed",  ##  Obed -- 71
	"oblonsky" => "Oblonsky",  ##  Oblonsky -- 552
	"october" => "October",  ##  October -- 2685 :: october -- 2
	"odessa" => "Odessa",  ##  Odessa -- 75
	# "oh" => "Oh",  ##  Oh -- 782 :: oh -- 60
	"ohio" => "Ohio",  ##  Ohio -- 168 :: ohio -- 1
	"oklahoma" => "Oklahoma",  ##  Oklahoma -- 98 :: oklahoma -- 3
	"oliver" => "Oliver",  ##  Oliver -- 116
	"olympic" => "Olympic",  ##  Olympic -- 241 :: olympic -- 1
	"olympics" => "Olympics",  ##  Olympics -- 119 :: olympics -- 1
	"ontario" => "Ontario",  ##  Ontario -- 132
	"oregon" => "Oregon",  ##  Oregon -- 95
	"orlando" => "Orlando",  ##  Orlando -- 75
	"orleans" => "Orleans",  ##  Orleans -- 219 :: orleans -- 2
	"orthodox" => "Orthodox",  ##  Orthodox -- 365 :: orthodox -- 50
	"oscar" => "Oscar",  ##  Oscar -- 92
	"oslo" => "Oslo",  ##  Oslo -- 82
	"otto" => "Otto",  ##  Otto -- 128 :: otto -- 2
	"ottoman" => "Ottoman",  ##  Ottoman -- 557 :: ottoman -- 3
	"ottomans" => "Ottomans",  ##  Ottomans -- 111 :: ottomans -- 2
	"oxford" => "Oxford",  ##  Oxford -- 198
	"pacific" => "Pacific",  ##  Pacific -- 489 :: pacific -- 7
	"pakistan" => "Pakistan",  ##  Pakistan -- 248 :: pakistan -- 2
	"palazzo" => "Palazzo",  ##  Palazzo -- 74 :: palazzo -- 18
	"palermo" => "Palermo",  ##  Palermo -- 277
	"palestine" => "Palestine",  ##  Palestine -- 251
	"palestinian" => "Palestinian",  ##  Palestinian -- 199
	"panama" => "Panama",  ##  Panama -- 104
	"paolo" => "Paolo",  ##  Paolo -- 76
	"paris" => "Paris",  ##  Paris -- 1378 :: paris -- 1
	"parker" => "Parker",  ##  Parker -- 117 :: parker -- 1
	"patrick" => "Patrick",  ##  Patrick -- 99
	"paul" => "Paul",  ##  Paul -- 1093 :: paul -- 7
	"pedro" => "Pedro",  ##  Pedro -- 161
	"pennsylvania" => "Pennsylvania",  ##  Pennsylvania -- 198 :: pennsylvania -- 1
	"perez" => "Perez",  ##  Perez -- 98
	"persia" => "Persia",  ##  Persia -- 242 :: persia -- 5
	"persian" => "Persian",  ##  Persian -- 417
	"persians" => "Persians",  ##  Persians -- 95
	"peru" => "Peru",  ##  Peru -- 211 :: peru -- 3
	"peruvian" => "Peruvian",  ##  Peruvian -- 73
	"pete" => "Pete",  ##  Pete -- 73
	"peter" => "Peter",  ##  Peter -- 1132 :: peter -- 1
	"petersburg" => "Petersburg",  ##  Petersburg -- 316
	"pharaoh" => "Pharaoh",  ##  Pharaoh -- 461 :: pharaoh -- 11
	"pharisees" => "Pharisees",  ##  Pharisees -- 231
	"philadelphia" => "Philadelphia",  ##  Philadelphia -- 241
	"philharmonic" => "Philharmonic",  ##  Philharmonic -- 239 :: philharmonic -- 2
	"philip" => "Philip",  ##  Philip -- 520 :: philip -- 1
	"philippe" => "Philippe",  ##  Philippe -- 119
	"philippines" => "Philippines",  ##  Philippines -- 181
	"philistines" => "Philistines",  ##  Philistines -- 513 :: philistines -- 1
	"phoenix" => "Phoenix",  ##  Phoenix -- 75 :: phoenix -- 2
	"pierre" => "Pierre",  ##  Pierre -- 285 :: pierre -- 1
	"pietro" => "Pietro",  ##  Pietro -- 84
	"pilate" => "Pilate",  ##  Pilate -- 134
	"pittsburgh" => "Pittsburgh",  ##  Pittsburgh -- 125
	"poland" => "Poland",  ##  Poland -- 686
	"polish" => "Polish",  ##  Polish -- 951 :: polish -- 6
	"pope" => "Pope",  ##  Pope -- 501 :: pope -- 135
	"portugal" => "Portugal",  ##  Portugal -- 367
	"portuguese" => "Portuguese",  ##  Portuguese -- 498
	"prague" => "Prague",  ##  Prague -- 189
	"princess" => "Princess",  ##  Princess -- 596 :: princess -- 112
	# "prix" => "Prix",  ##  Prix -- 83 :: prix -- 4
	"protestant" => "Protestant",  ##  Protestant -- 224 :: protestant -- 1
	"prussia" => "Prussia",  ##  Prussia -- 197
	"prussian" => "Prussian",  ##  Prussian -- 194 :: prussian -- 1
	"psalm" => "Psalm",  ##  Psalm -- 90 :: psalm -- 20
	# "puerto" => "Puerto",  ##  Puerto -- 128 :: puerto -- 1
	"putin" => "Putin",  ##  Putin -- 89
	"qing" => "Qing",  ##  Qing -- 124
	"quebec" => "Quebec",  ##  Quebec -- 170
	# "rabbi" => "Rabbi",  ##  Rabbi -- 241 :: rabbi -- 67
	"rachel" => "Rachel",  ##  Rachel -- 146
	"ralph" => "Ralph",  ##  Ralph -- 89
	"ramah" => "Ramah",  ##  Ramah -- 77
	"raymond" => "Raymond",  ##  Raymond -- 87
	# "reformation" => "Reformation",  ##  Reformation -- 71 :: reformation -- 20
	"rehoboam" => "Rehoboam",  ##  Rehoboam -- 105
	"reich" => "Reich",  ##  Reich -- 114
	"renaissance" => "Renaissance",  ##  Renaissance -- 221 :: renaissance -- 39
	# "republic" => "Republic",  ##  Republic -- 1421 :: republic -- 185
	"republican" => "Republican",  ##  Republican -- 253 :: republican -- 64
	"republicans" => "Republicans",  ##  Republicans -- 94 :: republicans -- 8
	"reuben" => "Reuben",  ##  Reuben -- 160
	"rhine" => "Rhine",  ##  Rhine -- 76
	"rhodes" => "Rhodes",  ##  Rhodes -- 72
	"richard" => "Richard",  ##  Richard -- 659 :: richard -- 1
	"richmond" => "Richmond",  ##  Richmond -- 83
	"rick" => "Rick",  ##  Rick -- 100 :: rick -- 1
	# "rico" => "Rico",  ##  Rico -- 94 :: rico -- 1
	# "rio" => "Rio",  ##  Rio -- 207 :: rio -- 4
	"robert" => "Robert",  ##  Robert -- 933 :: robert -- 2
	"roberts" => "Roberts",  ##  Roberts -- 96
	"robin" => "Robin",  ##  Robin -- 136 :: robin -- 5
	"robinson" => "Robinson",  ##  Robinson -- 118
	"rochester" => "Rochester",  ##  Rochester -- 345
	"roger" => "Roger",  ##  Roger -- 186 :: roger -- 1
	"rogers" => "Rogers",  ##  Rogers -- 76 :: rogers -- 1
	"roma" => "Roma",  ##  Roma -- 81
	"roman" => "Roman",  ##  Roman -- 1216 :: roman -- 9
	"romania" => "Romania",  ##  Romania -- 309 :: romania -- 1
	"romanian" => "Romanian",  ##  Romanian -- 345
	"romans" => "Romans",  ##  Romans -- 240 :: romans -- 1
	"rome" => "Rome",  ##  Rome -- 1150 :: rome -- 1
	"roosevelt" => "Roosevelt",  ##  Roosevelt -- 157 :: roosevelt -- 2
	"rosa" => "Rosa",  ##  Rosa -- 107 :: rosa -- 3
	"ross" => "Ross",  ##  Ross -- 135
	"roy" => "Roy",  ##  Roy -- 126 :: roy -- 4
	"rudolf" => "Rudolf",  ##  Rudolf -- 82
	"rus" => "Rus",  ##  Rus -- 76
	"russell" => "Russell",  ##  Russell -- 138
	"russia" => "Russia",  ##  Russia -- 1350 :: russia -- 2
	"russian" => "Russian",  ##  Russian -- 1929 :: russian -- 4
	"russians" => "Russians",  ##  Russians -- 205
	"ruth" => "Ruth",  ##  Ruth -- 95 :: ruth -- 4
	"ryan" => "Ryan",  ##  Ryan -- 113
	# "saint" => "Saint",  ##  Saint -- 769 :: saint -- 121
	"salvador" => "Salvador",  ##  Salvador -- 75
	"sam" => "Sam",  ##  Sam -- 202 :: sam -- 1
	"samaria" => "Samaria",  ##  Samaria -- 256
	"samson" => "Samson",  ##  Samson -- 104
	"samsung" => "Samsung",  ##  Samsung -- 76 :: samsung -- 1
	"samuel" => "Samuel",  ##  Samuel -- 532
	"san" => "San",  ##  San -- 1330 :: san -- 8
	"santa" => "Santa",  ##  Santa -- 455 :: santa -- 2
	"santiago" => "Santiago",  ##  Santiago -- 129
	"santo" => "Santo",  ##  Santo -- 77 :: santo -- 1
	"sarah" => "Sarah",  ##  Sarah -- 211
	# "satan" => "Satan",  ##  Satan -- 150 :: satan -- 1
	"saturday" => "Saturday",  ##  Saturday -- 138
	"saturn" => "Saturn",  ##  Saturn -- 102
	"saudi" => "Saudi",  ##  Saudi -- 387
	"saul" => "Saul",  ##  Saul -- 810
	"saxon" => "Saxon",  ##  Saxon -- 78
	"scotland" => "Scotland",  ##  Scotland -- 517
	"scots" => "Scots",  ##  Scots -- 93
	"scott" => "Scott",  ##  Scott -- 290
	"scottish" => "Scottish",  ##  Scottish -- 378
	"seattle" => "Seattle",  ##  Seattle -- 146
	"sebastian" => "Sebastian",  ##  Sebastian -- 82
	"seir" => "Seir",  ##  Seir -- 78
	"selah" => "Selah",  ##  Selah -- 150
	"senate" => "Senate",  ##  Senate -- 334 :: senate -- 41
	"september" => "September",  ##  September -- 2730 :: september -- 2
	"serbia" => "Serbia",  ##  Serbia -- 203
	"serbian" => "Serbian",  ##  Serbian -- 212
	"serbs" => "Serbs",  ##  Serbs -- 75
	"serezha" => "Serezha",  ##  Serezha -- 102
	"shah" => "Shah",  ##  Shah -- 224 :: shah -- 6
	"shakespeare" => "Shakespeare",  ##  Shakespeare -- 106 :: shakespeare -- 1
	"shanghai" => "Shanghai",  ##  Shanghai -- 179
	"shaw" => "Shaw",  ##  Shaw -- 78
	"shechem" => "Shechem",  ##  Shechem -- 126
	"shemaiah" => "Shemaiah",  ##  Shemaiah -- 80
	"shiloh" => "Shiloh",  ##  Shiloh -- 72 :: shiloh -- 1
	"shimei" => "Shimei",  ##  Shimei -- 86
	"shirley" => "Shirley",  ##  Shirley -- 76
	"siberia" => "Siberia",  ##  Siberia -- 102
	"sicilian" => "Sicilian",  ##  Sicilian -- 1382 :: sicilian -- 2
	"sicilians" => "Sicilians",  ##  Sicilians -- 230
	"sicily" => "Sicily",  ##  Sicily -- 887
	# "sicula" => "Sicula",  ##  Sicula -- 118
	"sierra" => "Sierra",  ##  Sierra -- 98
	"sihon" => "Sihon",  ##  Sihon -- 74
	"simeon" => "Simeon",  ##  Simeon -- 139
	"simon" => "Simon",  ##  Simon -- 406
	"sinai" => "Sinai",  ##  Sinai -- 128
	"singapore" => "Singapore",  ##  Singapore -- 137
	"singh" => "Singh",  ##  Singh -- 82 :: singh -- 2
	"slavic" => "Slavic",  ##  Slavic -- 106
	"slovak" => "Slovak",  ##  Slovak -- 114
	"slovakia" => "Slovakia",  ##  Slovakia -- 94 :: slovakia -- 1
	"slovenia" => "Slovenia",  ##  Slovenia -- 82
	"smith" => "Smith",  ##  Smith -- 544 :: smith -- 6
	"sodom" => "Sodom",  ##  Sodom -- 107
	"solomon" => "Solomon",  ##  Solomon -- 652 :: solomon -- 1
	"sony" => "Sony",  ##  Sony -- 83
	"sophie" => "Sophie",  ##  Sophie -- 71
	"soros" => "Soros",  ##  Soros -- 76
	"soviet" => "Soviet",  ##  Soviet -- 1672 :: soviet -- 5
	"soviets" => "Soviets",  ##  Soviets -- 134 :: soviets -- 1
	"spain" => "Spain",  ##  Spain -- 1426 :: spain -- 16
	"spaniards" => "Spaniards",  ##  Spaniards -- 118
	"spanish" => "Spanish",  ##  Spanish -- 1665 :: spanish -- 7
	"sparta" => "Sparta",  ##  Sparta -- 79 :: sparta -- 1
	"spencer" => "Spencer",  ##  Spencer -- 98
	# "sri" => "Sri",  ##  Sri -- 75
	"st" => "St",  ##  St -- 1218 :: st -- 2
	"stalin" => "Stalin",  ##  Stalin -- 137
	"stanford" => "Stanford",  ##  Stanford -- 82
	"stanley" => "Stanley",  ##  Stanley -- 85
	"stephen" => "Stephen",  ##  Stephen -- 245
	"steve" => "Steve",  ##  Steve -- 215
	"stewart" => "Stewart",  ##  Stewart -- 107
	"stockholm" => "Stockholm",  ##  Stockholm -- 151 :: stockholm -- 1
	"strasbourg" => "Strasbourg",  ##  Strasbourg -- 115
	"stuart" => "Stuart",  ##  Stuart -- 131
	"sudan" => "Sudan",  ##  Sudan -- 134
	"sultan" => "Sultan",  ##  Sultan -- 306 :: sultan -- 57
	"sunday" => "Sunday",  ##  Sunday -- 253 :: sunday -- 2
	# "super" => "Super",  ##  Super -- 321 :: super -- 105
	# "superboy" => "Superboy",  ##  Superboy -- 133
	"superman" => "Superman",  ##  Superman -- 241 :: superman -- 2
	"sviyazhsky" => "Sviyazhsky",  ##  Sviyazhsky -- 113
	"sweden" => "Sweden",  ##  Sweden -- 514
	"swedish" => "Swedish",  ##  Swedish -- 550 :: swedish -- 1
	"swiss" => "Swiss",  ##  Swiss -- 281
	"switzerland" => "Switzerland",  ##  Switzerland -- 400
	"sydney" => "Sydney",  ##  Sydney -- 232
	# "symphony" => "Symphony",  ##  Symphony -- 596 :: symphony -- 149
	"syracuse" => "Syracuse",  ##  Syracuse -- 93 :: syracuse -- 3
	"syria" => "Syria",  ##  Syria -- 415
	"syrian" => "Syrian",  ##  Syrian -- 199 :: syrian -- 1
	"syrians" => "Syrians",  ##  Syrians -- 136
	"taiwan" => "Taiwan",  ##  Taiwan -- 441
	"taiwanese" => "Taiwanese",  ##  Taiwanese -- 149
	"talmud" => "Talmud",  ##  Talmud -- 246 :: talmud -- 1
	"tang" => "Tang",  ##  Tang -- 125
	"taormina" => "Taormina",  ##  Taormina -- 73
	"taylor" => "Taylor",  ##  Taylor -- 285 :: taylor -- 2
	"teatro" => "Teatro",  ##  Teatro -- 111 :: teatro -- 2
	"ted" => "Ted",  ##  Ted -- 84
	# "tel" => "Tel",  ##  Tel -- 96 :: tel -- 1
	"tennessee" => "Tennessee",  ##  Tennessee -- 126 :: tennessee -- 1
	# "testament" => "Testament",  ##  Testament -- 153 :: testament -- 46
	"texas" => "Texas",  ##  Texas -- 639 :: texas -- 1
	"thailand" => "Thailand",  ##  Thailand -- 135
	"theodore" => "Theodore",  ##  Theodore -- 103 :: theodore -- 1
	"thomas" => "Thomas",  ##  Thomas -- 903 :: thomas -- 5
	"thompson" => "Thompson",  ##  Thompson -- 118
	"thomson" => "Thomson",  ##  Thomson -- 85
	"thornfield" => "Thornfield",  ##  Thornfield -- 96
	"tibet" => "Tibet",  ##  Tibet -- 144
	"tibetan" => "Tibetan",  ##  Tibetan -- 144 :: tibetan -- 1
	"tim" => "Tim",  ##  Tim -- 107 :: tim -- 4
	# "titans" => "Titans",  ##  Titans -- 197 :: titans -- 2
	"tokugawa" => "Tokugawa",  ##  Tokugawa -- 71
	"tokyo" => "Tokyo",  ##  Tokyo -- 326 :: tokyo -- 1
	"tom" => "Tom",  ##  Tom -- 287
	"tommy" => "Tommy",  ##  Tommy -- 129
	"tony" => "Tony",  ##  Tony -- 151
	"torah" => "Torah",  ##  Torah -- 300 :: torah -- 2
	"toronto" => "Toronto",  ##  Toronto -- 130
	"trieste" => "Trieste",  ##  Trieste -- 83
	# "trinity" => "Trinity",  ##  Trinity -- 105 :: trinity -- 4
	# "trump" => "Trump",  ##  Trump -- 161 :: trump -- 7
	# "tsar" => "Tsar",  ##  Tsar -- 75 :: tsar -- 24
	"turin" => "Turin",  ##  Turin -- 91
	# "turkey" => "Turkey",  ##  Turkey -- 439 :: turkey -- 9
	"turkic" => "Turkic",  ##  Turkic -- 138
	"turkish" => "Turkish",  ##  Turkish -- 545
	"turks" => "Turks",  ##  Turks -- 200
	"turner" => "Turner",  ##  Turner -- 83 :: turner -- 1
	"twitter" => "Twitter",  ##  Twitter -- 130 :: twitter -- 3
	"tyre" => "Tyre",  ##  Tyre -- 118
	"ukraine" => "Ukraine",  ##  Ukraine -- 403 :: ukraine -- 1
	"ukrainian" => "Ukrainian",  ##  Ukrainian -- 308
	"ulster" => "Ulster",  ##  Ulster -- 74
	# "unfortunately" => "Unfortunately",  ##  Unfortunately -- 134 :: unfortunately -- 32
	# "union" => "Union",  ##  Union -- 1712 :: union -- 362
	# "united" => "United",  ##  United -- 4789 :: united -- 238
	# "university" => "University",  ##  University -- 2463 :: university -- 746
	"utah" => "Utah",  ##  Utah -- 100
	"vancouver" => "Vancouver",  ##  Vancouver -- 104
	"varenka" => "Varenka",  ##  Varenka -- 137
	"vatican" => "Vatican",  ##  Vatican -- 140 :: vatican -- 4
	# "vegas" => "Vegas",  ##  Vegas -- 128 :: vegas -- 1
	"venetian" => "Venetian",  ##  Venetian -- 123
	"venezuela" => "Venezuela",  ##  Venezuela -- 191 :: venezuela -- 1
	"venezuelan" => "Venezuelan",  ##  Venezuelan -- 85
	"venice" => "Venice",  ##  Venice -- 305 :: venice -- 1
	"venus" => "Venus",  ##  Venus -- 99 :: venus -- 2
	"veracruz" => "Veracruz",  ##  Veracruz -- 73
	"verdi" => "Verdi",  ##  Verdi -- 77
	"versailles" => "Versailles",  ##  Versailles -- 121
	"veslovsky" => "Veslovsky",  ##  Veslovsky -- 110
	# "victor" => "Victor",  ##  Victor -- 198 :: victor -- 17
	"victoria" => "Victoria",  ##  Victoria -- 274 :: victoria -- 1
	"vienna" => "Vienna",  ##  Vienna -- 469
	"vietnam" => "Vietnam",  ##  Vietnam -- 302 :: vietnam -- 2
	"vietnamese" => "Vietnamese",  ##  Vietnamese -- 130
	"vincent" => "Vincent",  ##  Vincent -- 99
	"virginia" => "Virginia",  ##  Virginia -- 274 :: virginia -- 1
	"vladimir" => "Vladimir",  ##  Vladimir -- 184
	"vronsky" => "Vronsky",  ##  Vronsky -- 735
	"wagner" => "Wagner",  ##  Wagner -- 111
	"wales" => "Wales",  ##  Wales -- 329 :: wales -- 2
	"walker" => "Walker",  ##  Walker -- 155 :: walker -- 4
	"wallace" => "Wallace",  ##  Wallace -- 98
	"walt" => "Walt",  ##  Walt -- 92 :: walt -- 1
	"walter" => "Walter",  ##  Walter -- 250
	"wang" => "Wang",  ##  Wang -- 73
	"warner" => "Warner",  ##  Warner -- 85
	"warren" => "Warren",  ##  Warren -- 85
	"warsaw" => "Warsaw",  ##  Warsaw -- 188
	"washington" => "Washington",  ##  Washington -- 897
	"watson" => "Watson",  ##  Watson -- 104
	"wayne" => "Wayne",  ##  Wayne -- 119
	"westminster" => "Westminster",  ##  Westminster -- 90
	"wikipedia" => "Wikipedia",  ##  Wikipedia -- 282 :: wikipedia -- 26
	"wilhelm" => "Wilhelm",  ##  Wilhelm -- 141
	"william" => "William",  ##  William -- 1060 :: william -- 4
	"williams" => "Williams",  ##  Williams -- 249 :: williams -- 2
	"wilson" => "Wilson",  ##  Wilson -- 227 :: wilson -- 1
	"windsor" => "Windsor",  ##  Windsor -- 81
	"winston" => "Winston",  ##  Winston -- 83 :: winston -- 1
	"wisconsin" => "Wisconsin",  ##  Wisconsin -- 132
	"wolfgang" => "Wolfgang",  ##  Wolfgang -- 89
	"wright" => "Wright",  ##  Wright -- 145
	"wu" => "Wu",  ##  Wu -- 86 :: wu -- 1
	"wyoming" => "Wyoming",  ##  Wyoming -- 84
	"xinjiang" => "Xinjiang",  ##  Xinjiang -- 78
	"yahweh" => "Yahweh",  ##  Yahweh -- 6588
	"yale" => "Yale",  ##  Yale -- 107
	"yemen" => "Yemen",  ##  Yemen -- 95
	"yerevan" => "Yerevan",  ##  Yerevan -- 73
	# "yes" => "Yes",  ##  Yes -- 1202 :: yes -- 393
	"york" => "York",  ##  York -- 2330 :: york -- 9
	"youtube" => "YouTube",  ##  
	"yuan" => "Yuan",  ##  Yuan -- 168 :: yuan -- 18
	"yugoslav" => "Yugoslav",  ##  Yugoslav -- 104
	"yugoslavia" => "Yugoslavia",  ##  Yugoslavia -- 215
	"zadok" => "Zadok",  ##  Zadok -- 107
	"zealand" => "Zealand",  ##  Zealand -- 200
	"zebulun" => "Zebulun",  ##  Zebulun -- 100
	"zechariah" => "Zechariah",  ##  Zechariah -- 88
	"zedekiah" => "Zedekiah",  ##  Zedekiah -- 123
	"zhang" => "Zhang",  ##  Zhang -- 130
	"zhou" => "Zhou",  ##  Zhou -- 76
	"zion" => "Zion",  ##  Zion -- 343
	"zionist" => "Zionist",  ##  Zionist -- 74
	"zohar" => "Zohar",  ##  Zohar -- 74 :: zohar -- 1
    );
    
    return %encaps;
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

1;
