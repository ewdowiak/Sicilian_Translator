#!/usr/bin/perl

##  Perl script to call machine translator

##  Eryk Wdowiak
##  21 Feb 2020

use strict;
use warnings;
no warnings qw(uninitialized numeric void);
use CGI qw(:standard);

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  CONFIG
##  ======

my $nbest  = 5;
my $topnav = '../config/topnav.html';
my $footnv = '../config/navbar-footer.html';

#my $last_update = 'urtimu aggiurnamentu: 2020.08.05';
my $last_update = 'urtimu agg.: 2020.09.07';

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  CHECK BLOCKED IP LIST
##  ===== ======= == ====

my $ip_addr = remote_addr();
my $block = "/home/soul/website/block.list";
my $blbkp = "/home/soul/website/block.list.bkp";

my $blocked = "FALSE";
open( CHECK , $block ) || open( CHECK , $blbkp );
while (<CHECK>) {
    chomp;
    my $line = $_;
    if ( $ip_addr eq $line ) {
	$blocked = "TRUE";
    }
}
close CHECK;

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  if on blocked IP list return block page
##  otherwise, translate

if ( $blocked ne "FALSE" ) {

    my $lgparm = "scen";
    my $intext = "Scusami! Lu tò IP ha statu bluccatu picchì sta facennu troppi richiesti.";
    my $ottrans = "I'm sorry! Your IP has been blocked because it is making too many requests. ";
    $ottrans .= '<br><br>';
    $ottrans .= "When bots make too many requests, human beings do not get served. ";
    $ottrans .= "So if you are a human being, please accept our apologies and write to: ";
    $ottrans .= '<a href='."'".'mailto:admin@napizia.com'."'".'>admin@napizia.com</a> for assistance.';
    my $switch = "FALSE";

    ##  PRINT HTML
    ##  ===== ====
    
    print mk_header( $topnav );
    print mk_form( $lgparm , $intext ,"","", "EMPTY");
    print mk_ottrans( $ottrans , $lgparm , $last_update );
    print mk_footer( $footnv );

} else {

    ##  INPUT
    ##  =====

    my $lgparm = ( ! defined param('langs')  ) ? "scen" : lc( param('langs'));
    $lgparm = ( $lgparm ne "scen" && $lgparm ne "ensc" ) ? "scen" : $lgparm;
    
    my $intext = ( ! defined param('intext') ) ? "" : param('intext');
    $intext = rm_malice( $intext );
    $intext = ( $intext !~ /[0-9A-Za-zÀàÂâÁáÇçÈèÊêÉéÌìÎîÍíÏïÒòÔôÓóÙùÛûÚú]/ ) ? "" : $intext;
    $intext =~ s/\n/ /g;
    $intext =~ s/\s+/ /g;
    $intext =~ s/^ //g;
    $intext =~ s/ $//g;
    
    ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
    
    ##  TRANSLATE and DETOKENIZE
    ##  ========= === ==========
    
    my $sockeye  = "/home/soul/.local/bin/sockeye-translate";
    my $subwdnmt = "/home/soul/.local/bin/subword-nmt";
    my $subwords = ( $lgparm eq "scen" ) ? "subwords/subwords.sc" : "subwords/subwords.en";
    my $tnfmodel = ( $lgparm eq "scen" ) ? "tnf_scen" : "tnf_ensc";
    
    ##  reserve for input form
    my $tokenized;
    my $subsplit;

    ##  reserve for output form
    my @scores;
    my @ottrans;
    
    if ( $intext ne "" ) {
	##  tokenization
	$tokenized = ( $lgparm eq "scen" ) ? sc_tokenizer($intext) : en_tokenizer($intext);
	$tokenized =~ s/"/\\"/g;

	##  subword splitting
	$subsplit  = `/bin/echo "$tokenized" | $subwdnmt apply-bpe -c $subwords`;
	chomp( $subsplit );
	$subsplit =~ s/"/\\"/g;

	##  translation
	my $output    = `/bin/echo "$subsplit" | $sockeye --models $tnfmodel --nbest-size $nbest --use-cpu 2> /dev/null`;
	chomp( $output );
	$output =~ s/\@\@ //g;
	$output =~ s/ ~~'s/'s/g;

	##  separate translations
	my $raw_tran = $output;
	$raw_tran =~ s/^.*"translations": \[//;
	$raw_tran =~ s/\]}$//;
	$raw_tran =~ s/\\"/"/g;
	$raw_tran =~ s/^"//;
	$raw_tran =~ s/", "/~/g;
	$raw_tran =~ s/"$//;
	my @raw_trans = split( /~/ , $raw_tran );
	
	##  separate scores
	my $raw_score = $output;
	$raw_score =~ s/^.*scores": \[//;
	$raw_score =~ s/\].*$//;
	$raw_score =~ s/,//g;
	my @raw_scores = split( /\s+/ , $raw_score );

	##  scores and detokenization
	foreach my $raw (@raw_scores) {
	    my $score = sprintf("%.03f",$raw);
	    push( @scores , $score );
	}
	foreach my $raw (@raw_trans) {
	    my $ottran  = ( $lgparm eq "scen" ) ? en_detokenizer($raw) : sc_detokenizer($raw);
	    push( @ottrans , $ottran );
	}
    }
    
    ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

    ##  what to do if no input
    my $empty = 'On this page, you can see the tokenization and subword splitting of an input sentence. ';
    $empty .= 'And you can see the Top&nbsp;5 translations with their scores.'."\n";
    $empty .= '<br><br>'."\n";
    $empty .= 'Type a sentence into the box, then press "Translate."'."\n";
    
    ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
    
    ##  PRINT HTML
    ##  ===== ====
    print mk_header( $topnav );
    print mk_form( $lgparm , $intext , $tokenized , $subsplit );
    if ( $intext ne "" ) {
	print mk_otmenu( \@scores , \@ottrans , $lgparm , $last_update );
    } else {
	print mk_ottrans( $empty , $lgparm , $last_update );
    }
    print mk_footer( $footnv );
    
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  

##  SUBROUTINES
##  ===========

##  remove efforts to run Perl code with this script
##  and fix quotes and braces
sub rm_malice {
    my $str = $_[0] ;

    ##  remove malice
    $str =~ s/\@/ /g;
    $str =~ s/([\$\%\&])/$1 /g;
    $str =~ s/\`/'/g ;

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

##  DETOKENIZATION SUBROUTINES
##  ============== ===========

sub sc_detokenizer {

    my $line = $_[0];
    $line = '<BOS> ' . $line . ' <EOS>';

    ##  reinsert spaces before and after punctuation
    #$line =~ s/([\,\.\?\!\:\;\%\}\]\)])/ $1 /g;
    
    ##  remove excess space
    $line =~ s/\s+/ /g;
    $line =~ s/^ //;
    $line =~ s/ $//;
    
    ##  capitalize and accent
    my $newline = sc_capitalize( $line );
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

sub sc_capitalize {

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
	my $female_names = '^maria$|^maddalena$|^lucia$|^andria$';
	my $male_names = '^antoni$|^agustinu$|^nicola$|^calogiru$|^caloiru$|^franciscu$|^giuseppi$|^luca$|';
	$male_names .= '^jachinu$|^gaitanu$|^binidittu$|^martinu$|^tumasi$|^marcu$|^arthur$|^gaetano$';
	$male_names .= '^gesu$|^cristu$';
	
	##  saints and names
	$word = ( ( $word eq "santu" || $word eq "san" ) && $nxtw =~ /$male_names/ ) ? ucfirst($word) : $word ;
	$word = ( $word eq "santa" && $nxtw =~ /$female_names/  ) ? ucfirst($word) : $word ;
	$word = ( $word =~ /$male_names/ || $word =~ /$female_names/ ) ? ucfirst($word) : $word ;
	
	##  The Lord and Saint Francis of Paola
	$word = ( $prev eq "lu" && $word eq "signuri" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "diu" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "Gesu" || $word eq "gesu" ) ? "Gesù" : $word ;
	$word = ( $word eq "paula" ) ? ucfirst($word) : $word ;
	
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

	##  United States and American cities	
	$word = ( $prev eq "nord" && $word eq "america" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "nord" && $nxtw eq "america" ) ? ucfirst($word) : $word ;

	$word = ( $prev eq "sud" && $word eq "america" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "sud" && $nxtw eq "america" ) ? ucfirst($word) : $word ;

	$word = ( $word eq "america" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "amirica" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "merica" ) ? ucfirst($word) : $word ;
	$word = ( $word eq "mirica" ) ? ucfirst($word) : $word ;

	$word = ( $word eq "brucculinu" ) ? ucfirst($word) : $word ;
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
	$word = ( $word eq "picchi" ) ? "picchì" : $word ;
	$word = ( $word eq "pirchi" ) ? "picchì" : $word ;  ## Mi piaci "picchì." ;-)
	$word = ( $word eq "cca" ) ? "ccà" : $word ;
	$word = ( $word eq "chiu" ) ? "chiù" : $word ;
	$word = ( $word eq "autru" ) ? "àutru" : $word ;
	$word = ( $word eq "autra" ) ? "àutra" : $word ;
	$word = ( $word eq "autri" ) ? "àutri" : $word ;
	$word = ( $word eq "me" ) ? "mè" : $word ;
	$word = ( $word eq "to" ) ? "tò" : $word ;
	$word = ( $word eq "so" ) ? "sò" : $word ;
	$word = ( $word eq "po" ) ? "pò" : $word ;
	$word = ( $word eq "virita" ) ? "virità" : $word ;
	$word = ( $word eq "citta" ) ? "città" : $word ;

	##  more fixes
	$word = ( $word eq "in" ) ? "n" : $word ;

	##  capitalize beginning of sentences
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

sub en_capitalize {
    
    my $line = $_[0];
    
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
	
	##  capitalize beginning of sentences
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

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  TOKENIZATION SUBROUTINES
##  ============ ===========

##  Sicilian tokenizer
sub sc_tokenizer {

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
    
    ##  make sure there are no double double quotes
    $line =~ s/"\s+"/ " /g;
    
    ##  remove excess space
    $line =~ s/\s+/ /g;

    ##  remove spaces after an apostrophe, except "è"
    $line =~ s/' /'/g;
    $line =~ s/'è /' e' /g;
    $line =~ s/'e'/' e' /g;
    $line =~ s/ c' e' / c'e' /g;
    
    ##  contractions of conjunctive pronouns
    $line =~ s/ mû / mi lu /g;
    $line =~ s/ tû / ti lu /g;
    $line =~ s/ ciû / ci lu /g;
    $line =~ s/ cciû / ci lu /g;
    $line =~ s/ sû / si lu /g;
    $line =~ s/ nû / ni lu /g;
    $line =~ s/ vû / vi lu /g;

    $line =~ s/ m'û / mi lu /g;
    $line =~ s/ t'û / ti lu /g;
    $line =~ s/ ci'û / ci lu /g;
    $line =~ s/ cci'û / ci lu /g;
    $line =~ s/ s'û / si lu /g;
    $line =~ s/ n'û / ni lu /g;
    $line =~ s/ v'û / vi lu /g;

    $line =~ s/ mâ / mi la /g;
    $line =~ s/ tâ / ti la /g;
    $line =~ s/ ciâ / ci la /g;
    $line =~ s/ cciâ / ci la /g;
    $line =~ s/ sâ / si la /g;
    $line =~ s/ nâ / ni la /g;
    $line =~ s/ vâ / vi la /g;

    $line =~ s/ m'â / mi la /g;
    $line =~ s/ t'â / ti la /g;
    $line =~ s/ ci'â / ci la /g;
    $line =~ s/ cci'â / ci la /g;
    $line =~ s/ s'â / si la /g;
    $line =~ s/ n'â / ni la /g;
    $line =~ s/ v'â / vi la /g;

    $line =~ s/ mî / mi li /g;
    $line =~ s/ tî / ti li /g;
    $line =~ s/ cî / ci li /g;
    $line =~ s/ ccî / ci li /g;
    $line =~ s/ sî / si li /g;
    $line =~ s/ nî / ni li /g;
    $line =~ s/ vî / vi li /g;

    $line =~ s/ m'î / mi li /g;
    $line =~ s/ t'î / ti li /g;
    $line =~ s/ c'î / ci li /g;
    $line =~ s/ cc'î / ci li /g;
    $line =~ s/ s'î / si li /g;
    $line =~ s/ n'î / ni li /g;
    $line =~ s/ v'î / vi li /g;

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

	    ##  replace abbreviated article with full form
	    $new_word = ( $new_word eq "'u" ) ? "lu" : $new_word;
	    $new_word = ( $new_word eq "'a" ) ? "la" : $new_word;
	    $new_word = ( $new_word eq "'i" ) ? "li" : $new_word;

	    ##  more uncontractions
	    $new_word = ( $new_word eq "'n" ) ? "in" : $new_word;
	    $new_word = ( $new_word eq "n" ) ? "in" : $new_word;

	    ##  replacements
 	    $new_word = ( $new_word eq "cchiu" ) ? "chiu" : $new_word;
 	    $new_word = ( $new_word eq "cci" ) ? "ci" : $new_word;
 	    $new_word = ( $new_word eq "dopu" ) ? "doppu" : $new_word;
 	    $new_word = ( $new_word eq "libru" ) ? "libbru" : $new_word;
 	    $new_word = ( $new_word eq "non" ) ? "nun" : $new_word;
	    $new_word = ( $new_word eq "peggiu" ) ? "peju" : $new_word;
 	    $new_word = ( $new_word eq "pir" ) ? "pi" : $new_word;
 	    $new_word = ( $new_word eq "pri" ) ? "pi" : $new_word;
 	    $new_word = ( $new_word eq "pirchi" ) ? "picchi" : $new_word;
 	    $new_word = ( $new_word eq "soccu" ) ? "zoccu" : $new_word;
 	    $new_word = ( $new_word eq "sunu" ) ? "sunnu" : $new_word;
	    
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
    
    ##  separate "apostrophe S"
    $line =~ s/([a-z])'s /$1 ~~'s /g;
    
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

##  contract for "spoken voice"
##  see tables at bottom of this script
sub mk_spoken {
    my $str  = $_[0] ;
    
    ##  make it all lower case
    $str = lc( $str );

    ##  add markers
    $str = '<BOS> ' . $str . ' <EOS>';
    
    ##  separate punctuation, except apostrophe
    $str =~ s/([\-"\.,:;\!\?\(\)])/ $1 /g;
    
    ##  remove excess space
    $str =~ s/\s+/ /g;
    $str =~ s/^ //;
    $str =~ s/ $//;

    ##  prepositions plus definite article
    $str=~ s/ a lu / ô /g;
    $str=~ s/ a la / â /g;
    $str=~ s/ a li / ê /g;
    		    		             
    $str=~ s/ cu lu / cû /g;
    #$str=~ s/ cu lu / cô /g;
    $str=~ s/ cu la / câ /g;
    $str=~ s/ cu li / chî /g;
    #$str=~ s/ cu li / chê /g;
    		    		             
    $str=~ s/ di lu / dû /g;
    #$str=~ s/ di lu / dô /g;
    $str=~ s/ di la / dâ /g;
    $str=~ s/ di li / dî /g;
    #$str=~ s/ di li / dê /g;
    		    		             
    $str=~ s/ pi lu / pû /g;
    #$str=~ s/ pi lu / pô /g;
    $str=~ s/ pi la / pâ /g;
    $str=~ s/ pi li / pî /g;
    #$str=~ s/ pi li / pê /g;
    		    		             
    #$str=~ s/ nni lu / nnû /g;
    $str=~ s/ nni lu / nnô /g;
    $str=~ s/ nni la / nnâ /g;
    $str=~ s/ nni li / nnî /g;
    #$str=~ s/ nni li / nnê /g;
    		    		             
    #$str=~ s/ nta lu / ntû /g;
    $str=~ s/ nta lu / ntô /g;
    $str=~ s/ nta la / ntâ /g;
    $str=~ s/ nta li / ntî /g;
    #$str=~ s/ nta li / ntê /g;
    		    		             
    #$str=~ s/ ntra lu / ntrû /g;
    $str=~ s/ ntra lu / ntrô /g;
    $str=~ s/ ntra la / ntrâ /g;
    $str=~ s/ ntra li / ntrî /g;
    #$str=~ s/ ntra li / ntrê /g;
    
    ##  prepositions plus indefinite article
    $str =~ s/ a un / ôn /g;
    $str =~ s/ cu un / c'un /g;
    $str =~ s/ di un / d'un /g;
    $str =~ s/ pi un / p'un /g;
    
    $str =~ s/ nni un / nn'un /g;
    $str =~ s/ nna un / nn'un /g;

    #$str =~ s/ nta un / ntûn /g;
    $str =~ s/ nta un / ntôn /g;
    
    $str =~ s/ ntra un / ntrôn /g;
    #$str =~ s/ ntra un / ntrûn /g;
    
    ##  conjunctive pronoun contractions
    $str =~ s/ mi lu / mû /g;
    $str =~ s/ mi la / mâ /g;
    $str =~ s/ mi li / mî /g;

    $str =~ s/ ti lu / tû /g;
    $str =~ s/ ti la / tâ /g;
    $str =~ s/ ti li / tî /g;

    $str =~ s/ ci lu / ciû /g;
    $str =~ s/ ci la / ciâ /g;
    $str =~ s/ ci li / cî /g;

    $str =~ s/ ni lu / nû /g;
    $str =~ s/ ni la / nâ /g;
    $str =~ s/ ni li / nî /g;

    $str =~ s/ vi lu / vû /g;
    $str =~ s/ vi la / vâ /g;
    $str =~ s/ vi li / vî /g;

    ##  third person reflexive + direct
    ##  difficult because "si" could either be pronoun or "if"
    ##  so we'll use apostrophe to cover both cases -- BAD HACK!
    $str =~ s/ si lu / s'û /g;
    $str =~ s/ si la / s'â /g;
    $str =~ s/ si li / s'î /g;
    
    ##  contractions of "aviri"
    $str =~ s/ haiu a ([a-z]*[ai]ri) / hê $1 /g;
    $str =~ s/ hai a ([a-z]*[ai]ri) / hâ $1 /g;
    $str =~ s/ havi a ([a-z]*[ai]ri) / hâ $1 /g;
    $str =~ s/ avemu a ([a-z]*[ai]ri) / amâ $1 /g;
    $str =~ s/ aviti a ([a-z]*[ai]ri) / atâ $1 /g;
    $str =~ s/ hannu a ([a-z]*[ai]ri) / hannâ $1 /g;

    ##  shorten definite articles
    $str =~ s/ lu / u /g;
    $str =~ s/ la / a /g;
    $str =~ s/ li / i /g;

    ##  capitalize and accent
    my $newline = sc_capitalize( $str );
    $newline = fix_punctuation( $newline );
    
    ##  remaining punctuation
    $newline =~ s/' /'/g;
    $newline =~ s/ '/'/g;
    
    ##  remove excess space
    $newline =~ s/\s+/ /g;
    $newline =~ s/^ //;
    $newline =~ s/ $//;   

    ##  return contracted string
    return $newline ;
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
    $ottxt .= '    <title>Darreri lu Sipariu :: Tradutturi Sicilianu :: Napizia</title>' ."\n";
    $ottxt .= '    <meta name="DESCRIPTION" content="Behind the curtain of '."\n";
    $ottxt .= '          Napizia'."'".'s Sicilian Translator.">' ."\n";
    $ottxt .= '    <meta name="KEYWORDS" content="translate, translations, translation, translator, '."\n";
    $ottxt .= '          machine translation, online translation, Sicilian, English">' ."\n";
    $ottxt .= '    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">' . "\n" ;
    $ottxt .= '    <meta name="Author" content="Eryk Wdowiak">' . "\n" ;
    $ottxt .= '    <link rel="stylesheet" type="text/css" href="/css/eryk.css">' ."\n";
    $ottxt .= '    <link rel="stylesheet" type="text/css" href="/css/eryk_theme-blue.css">' ."\n";
    $ottxt .= '    <link rel="stylesheet" type="text/css" href="/css/eryk_widenme.css">' ."\n";
    $ottxt .= '    <link rel="stylesheet" type="text/css" href="/css/dieli_forms.css">' ."\n";
    $ottxt .= '    <link rel="stylesheet" type="text/css" href="/css/napizia_translator.css">' ."\n";
    $ottxt .= '    <link rel="stylesheet" type="text/css" href="/css/napizia_darreri.css">' ."\n";
    $ottxt .= '    <link rel="icon" type="image/png" href="/config/napizia-icon.png">' ."\n";
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
    $ottxt .= '      p.lastupdate {'."\n";
    $ottxt .= '        font-size: 0.75em;'."\n";
    $ottxt .= '        text-align: right;'."\n";
    $ottxt .= '        margin: 0px 10px 0px 0px;'."\n";
    $ottxt .= '      }'."\n";
    $ottxt .= '      @media only screen and (max-width: 599px) {'."\n";
    $ottxt .= '        p.lastupdate {'."\n";
    $ottxt .= '          margin: 0px 5px 0px 0px;'."\n";
    $ottxt .= '        }'."\n";
    $ottxt .= '      }'."\n";
    $ottxt .= '    </style>' . "\n" ;
    $ottxt .= '  </head>' . "\n" ;

    open( TOPNAV , $topnav ) || die "could not read:  $topnav";
    while(<TOPNAV>){ chomp;  $ottxt .= $_ . "\n" ; };
    close TOPNAV ;

    $ottxt .= '  <!-- begin row div -->' . "\n" ;
    $ottxt .= '  <div class="row">' . "\n" ;
    $ottxt .= '    <div class="col-m-12 col-12">' . "\n" ;
    ##  $ottxt .= '      <h1>Darreri lu Sipariu</h1>'."\n";
    $ottxt .= '      <h1 style="margin-bottom: 0.15em;">Darreri lu Sipariu</h1>'."\n";
    $ottxt .= '      <h2 style="margin-top: 0.15em;">dû Tradutturi Sicilianu</h2>'."\n";
    ##  $ottxt .= '      <h2 style="margin-top: 0.15em; font-family: Arial, '."'Liberation Sans'".',';
    ##  $ottxt .= ' sans-serif;">Behind the Curtain</h2>'."\n";
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
    $othtml .= '<p style="margin-top: 0.5em; margin-bottom: 0.5em; padding-left: 0px;">'."\n";
    $othtml .= 'Back here, "behind the curtain," you can see how the ';
    $othtml .= '<a href="/cgi-bin/index.pl"><i>Sicilian Translator</i></a> works.</p>'."\n";

    $othtml .= '<p style="margin-top: 0.5em; margin-bottom: 0.25em; padding-left: 0px;">'."\n";
    $othtml .= 'First, it tokenizes the input sentence to a reduced form. '."\n";
    $othtml .= 'Then subword splitting breaks the words into shorter units, '."\n";
    $othtml .= 'which are then passed to the translator.</p>'."\n";
    $othtml .= '</div>'."\n";

    $othtml .= '<div class="col-m-12 col-6" style="padding: 0px 10px;">'."\n";
    $othtml .= '<p style="margin-top: 0.5em; margin-bottom: 0.5em; padding-left: 0px;">'."\n";
    $othtml .= 'The translator returns the Top&nbsp;5 translations of the input sentence, '."\n";
    $othtml .= 'which this page displays in detokenized form along with the translation score. '."\n";
    $othtml .= 'Like golf, a lower score is a better score.</p>'."\n";
    
    $othtml .= '<p style="margin-top: 0.5em; margin-bottom: 0.5em; padding-left: 0px;">'."\n";
    $othtml .= 'For more information, please read the '."\n";
    $othtml .= '<a href="https://www.napizia.com/pages/sicilian/translator.shtml">documentation</a>.</p>'."\n";
    
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
    my $lgparm     = $_[0]; 
    my $intext     = $_[1];
    (my $tokenized = $_[2]) =~ s/\\"/"/g;
    (my $subsplit  = $_[3]) =~ s/\\"/"/g;
    my $empty = $_[4] ;
    $empty = ( ! defined $empty || $empty ne "EMPTY" ) ? "FALSE" : "EMPTY";
    
    my $ottxt ;
    $ottxt .= '<!-- begin row div -->' . "\n";
    $ottxt .= '<div class="row">' ."\n";
    $ottxt .= '<!-- begin box div -->' . "\n";
    $ottxt .= '<div class="col-m-12 col-5 intrans">' ."\n";

    $ottxt .= '<form enctype="multipart/form-data" action="/cgi-bin/darreri.pl" method="post">'."\n";
    $ottxt .= '<table style="width: 100%; padding: 0px 3px 0px 0px;"><tbody>'."\n";

    $ottxt .= '<tr>' ;
    $ottxt .= '<td colspan="2">' ;
    $ottxt .= '<textarea name="intext" maxlength="500" class="intrans">'."\n";
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

    if ( $intext =~ /[a-z0-9]/ && $empty eq "FALSE" ) {
	$ottxt .= '<p style="margin: 0.25em 0px 0em 5px;"><i>tokenization:</i></p>'."\n";
	$ottxt .= '<p style="margin: 0em 0px 0.5em 20px;"><span class="code">';
	$ottxt .= $tokenized . '</span></p>'."\n";
	$ottxt .= '<p style="margin: 0.5em 0px 0em 5px;"><i>subwords:</i></p>'."\n";
	$ottxt .= '<p style="margin: 0em 0px 0.25em 20px;"><span class="code">'."\n";
	$ottxt .= $subsplit . '</span></p>'."\n";
    }
    
    $ottxt .= '</div>' . "\n" ;
    $ottxt .= '<!-- end box div -->' ."\n";

    return $ottxt ;
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

sub mk_ottrans {

    ##  output translation and language direction
    my $ottrans = $_[0];
    my $org_lgparm = $_[1];
    my $new_lgparm = ( $org_lgparm eq "scen" ) ? "ensc" : "scen";
    
    ##  last update
    my $last_update = $_[2];

    ##  initialize output
    my $ottxt ;
        
    ##  output translation
    $ottxt .= '<!-- begin ottrans div -->' . "\n";
    $ottxt .= '<div class="col-m-12 col-7">'."\n";
    $ottxt .= '<div class="ottrans">'."\n";
    
    $ottxt .= '<p style="margin-top: 0.5em; margin-bottom: 0.5em;">' . $ottrans . '</p>'."\n";
    
    $ottxt .= '</div>' . "\n" ;
    $ottxt .= '</div>' . "\n" ;
    $ottxt .= '<!-- end ottrans div -->' ."\n";
    $ottxt .= '<p class="lastupdate">'. $last_update .'</p>'."\n";
    $ottxt .= '</div>' . "\n" ;
    $ottxt .= '<!-- end row div -->' ."\n";

    return $ottxt ;
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

sub mk_otmenu {

    ##  output scores
    my @scores = @{ $_[0] };
    
    ##  output translations
    my @ottrans = @{ $_[1] };

    ##  language direction
    my $org_lgparm = $_[2];
    my $new_lgparm = ( $org_lgparm eq "scen" ) ? "ensc" : "scen";

    ##  last update
    my $last_update = $_[3];
    
    ##  initialize output
    my $ottxt ;
    
    ##  output translation menu
    $ottxt .= '<!-- begin ottrans div -->' . "\n";
    $ottxt .= '<div class="col-m-12 col-7 darreri">'."\n";
    $ottxt .= '<form enctype="multipart/form-data" action="/cgi-bin/darreri.pl" method="post">'."\n";
    $ottxt .= '<input type="hidden" name="langs" value="'. $new_lgparm .'">'."\n";
    $ottxt .= '<table class="darreri">'."\n";

    ##  create each row
    for my $i (0..$nbest-1) {
	my $score  = $scores[$i];
	my $ottran = $ottrans[$i];
	
	##  prepare quotes for form value
	( my $ottran_form = $ottran ) =~ s/"/\&quot;/g;

	$ottxt .= '  <tr>'."\n";
	$ottxt .= '  <td class="darreri">'."\n";
	$ottxt .= '  <label class="container">'."\n";
	$ottxt .= '    <input type="radio" name="intext" value="'. $ottran_form .'">'."\n";
	$ottxt .= '    <span class="checkmark"></span>'."\n";
	$ottxt .= '  </label>'."\n";
	$ottxt .= '  </td>'."\n";
	$ottxt .= '  <td class="score">'. $score .'</td>'."\n";
	$ottxt .= '  <td class="darreri">'."\n";
	$ottxt .= '    ' . $ottran ."\n";
	$ottxt .= '  </td>'."\n";
	$ottxt .= '  </tr>'."\n";
    }
    
    ##  close it up
    $ottxt .= '</table>'."\n";
    $ottxt .= '<input type="submit" value="Traduci">'."\n";    
    $ottxt .= '</form>' . "\n" ;
    $ottxt .= '</div>' . "\n" ;
    $ottxt .= '<!-- end ottrans div -->' ."\n";
    $ottxt .= '<p class="lastupdate">'. $last_update .'</p>'."\n";
    $ottxt .= '</div>' . "\n" ;
    $ottxt .= '<!-- end row div -->' ."\n";

    return $ottxt ;
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
