package Tradutturi::Controller::Darreri;

##  makes the Darreri lu Sipariu page
##  Copyright (C) 2018-2026 Eryk Wdowiak
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
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  

use strict;
use warnings;
no warnings qw(uninitialized numeric void);
use utf8;

use URI::Escape;
use Mojo::Base 'Mojolicious::Controller', -signatures;

use Napizia::Translator;
use Napizia::HtmlDarreri;
use Napizia::SicilianLS2;
use Napizia::English;
use Napizia::Italian;

my $home = "/home/eryk";

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  CONFIG
##  ======

my $nbest  = 5;
my $topnav = '/home/eryk/website/translate/public/config/eryk2-topnav.html';
my $footnv = '/home/eryk/website/translate/public/config/eryk2-navbar.html';
my $italian = "enable";
my $landing = "darreri.pl";

#my $last_update = 'urtimu aggiurnamentu: 2023.05.20';
my $last_update = 'ultimu agg.: 2024.12.31';

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
# ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ## #
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  WELCOME
##  =======

sub welcome ($self) {

    my $par_intext = $self->param('intext') || '';
    my $par_langs  = $self->param('langs')  || '';
    
    $par_intext = ( $par_intext eq '') ? undef : $par_intext ;
    $par_langs  = ( $par_langs  eq '') ? undef : $par_langs  ;

    my $otpage = mk_htmlpage( $par_intext , $par_langs );
    $self->render( htmlpage => $otpage );
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  CREATE WEBPAGE
##  ====== =======

sub mk_htmlpage{ 

    my $par_intext = $_[0];
    my $par_langs  = $_[1];
    
    my $lgparm = ( ! defined $par_langs ) ? "ensc" : lc($par_langs);
    $lgparm = ( $lgparm ne "scen" && $lgparm ne "ensc" &&
		$lgparm ne "iten" && $lgparm ne "enit" &&
		$lgparm ne "itsc" && $lgparm ne "scit") ? "ensc" : $lgparm;
    
    my $intext = ( ! defined $par_intext ) ? "" : $par_intext;


##  CHECK BLOCKED IP LIST
##  ===== ======= == ====

## my $ip_addr = remote_addr();
my $ip_addr = $ENV{REMOTE_ADDR};

my $block = $home ."/website/logs/translate/lists/block.list";
my $blbkp = $home ."/website/logs/translate/lists/block.list.bkp";

my $blocked = "FALSE";
open( my $fh_check , "<:encoding(utf-8)" , $block );
# || open( my $fh_check , "<:encoding(utf-8)" , $blbkp );
while (<$fh_check>) {
    chomp;
    my $line = $_;
    if ( $ip_addr eq $line ) {
	$blocked = "TRUE";
    }
}
close $fh_check;

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  if on blocked IP list return block page
##  otherwise, translate

if ( $blocked ne "FALSE" ) {

    $lgparm = "ensc";
    $intext = "Scusami! Lu tò IP ha statu bluccatu picchì sta facennu troppi richiesti.";
    my $ottrans = "I'm sorry! Your IP has been blocked because it is making too many requests. ";
    $ottrans .= '<br><br>';
    $ottrans .= "When bots make too many requests, human beings do not get served. ";
    $ottrans .= "So if you are a human being, please accept our apologies and write to: ";
    $ottrans .= '<a href='."'".'mailto:admin@napizia.com'."'".'>admin@napizia.com</a> for assistance.';
    my $switch = "FALSE";

    ##  PRINT HTML
    ##  ===== ====
    
    my $othtml;
    $othtml .= mk_header( $topnav );
    $othtml .= mk_form( $lgparm , $intext ,"","", "EMPTY", $italian);
    $othtml .= mk_ottrans( $ottrans , $lgparm , $last_update );
    $othtml .= mk_footer( $footnv );

    return $othtml;

} else {

    ##  INPUT
    ##  =====

    $intext = rm_malice( $intext );
    $intext = ( $intext !~ /[0-9A-Za-zÀàÂâÁáÇçÈèÊêÉéÌìÎîÍíÏïÒòÔôÓóÙùÛûÚú]/ ) ? "" : $intext;
    $intext =~ s/\n/ /g;
    $intext =~ s/\s+/ /g;
    $intext =~ s/^ //g;
    $intext =~ s/ $//g;
    
    ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
    
    ##  TRANSLATE and DETOKENIZE
    ##  ========= === ==========
    
    my $sockeye  = $home ."/.local/bin/sockeye-translate";
    my $subwdnmt = $home ."/.local/bin/subword-nmt";

    my %sbwhash = ( "scen" => "subwords/subwords.sc", "ensc" => "subwords/subwords.en",
		    "iten" => "subwords/subwords.it", "enit" => "subwords/subwords.en",
		    "itsc" => "subwords/subwords.it", "scit" => "subwords/subwords.sc");
    my %tnfhash = ( "scen" => "tnf_scen", "ensc" => "tnf_ensc",
		    "iten" => "tnf_iten", "enit" => "tnf_enit",
		    "itsc" => "tnf_itsc", "scit" => "tnf_scit");
    my %dirhash = ( "scen" => "<2en> ", "ensc" => "<2sc> ",
		    "iten" => "<2en> ", "enit" => "<2it> ",
		    "itsc" => "<2sc> ", "scit" => "<2it> ");

    my $subwords = $home .'/website/translate/lib/model/'. $sbwhash{$lgparm};
    my $tnfmodel = $home .'/website/translate/lib/model/'. $tnfhash{$lgparm};
    my $dirtoken = $dirhash{$lgparm};
    
    ##  reserve for input form
    my $tokenized;
    my $subsplit;

    ##  reserve for output form
    my @scores;
    my @ottrans;
    
    if ( $intext ne "" ) {

	##  tokenization
	if (  $lgparm ne "ensc" && $lgparm ne "enit" && $lgparm ne "iten" && $lgparm ne "itsc" ) {
	    ##  cases:  Sc->En and Sc->It
	    $tokenized = sc_tokenizer($intext);
	} elsif ($lgparm ne "ensc" && $lgparm ne "enit" ) {
	    ##  cases:  It->En and It->Sc
	    $tokenized = it_tokenizer($intext) ;
	} else {
	    ##  cases:  En->Sc and En->It
	    $tokenized = en_tokenizer($intext);
	}
	$tokenized =~ s/ '/ ' /g;
	$tokenized =~ s/^'/ ' /g;
	$tokenized =~ s/\s+/ /g;
	$tokenized =~ s/^ //;
	$tokenized =~ s/ $//;
	$tokenized =~ s/"/\\"/g;

	##  subword splitting
	$subsplit  = `/bin/echo "$tokenized" | $subwdnmt apply-bpe -c $subwords`;
	chomp( $subsplit );

	##  append directional token
	my $intrans = $dirtoken . $subsplit;
	
	##  translation
	my $output ;
	my @raw_trans ;
	my @raw_scores ;

	##  first try local URL
	my $local_url = 'http://127.0.0.1:8000/'. uri_escape($intrans) ;
	$output = `/usr/bin/curl "$local_url" 2> /dev/null`;
	chomp( $output );
	$output =~ s/^"//;
	$output =~ s/"$//;
	$output =~ s/\\"/"/g;

	##  fall back if FastAPI not running
	if ( ! defined $output || $output eq "" ) {

	    $subsplit =~ s/"/\\"/g;
	    my $in2trans = $dirtoken . $subsplit;

	    ##  translation
	    $output    = `/bin/echo "$in2trans" | $sockeye --models $tnfmodel --nbest-size $nbest --use-cpu 2> /dev/null`;
	    chomp( $output );
	    $output =~ s/\@\@ //g;
	    $output =~ s/\@\@$//;
	    $output =~ s/ ~~'s/'s/g;

	    ##  separate translations
	    my $raw_tran = $output;
	    $raw_tran =~ s/^.*translations": \[//;
	    $raw_tran =~ s/\].*}$//;
	    $raw_tran =~ s/\\"/"/g;
	    $raw_tran =~ s/^"//;
	    $raw_tran =~ s/"$//;
	    @raw_trans = split( /", "/ , $raw_tran );
	    
	    ##  separate scores
	    my $raw_score = $output;
	    $raw_score =~ s/^.*scores": \[//;
	    $raw_score =~ s/\]\].*$//;
	    $raw_score =~ s/\[//g;
	    $raw_score =~ s/\]//g;
	    $raw_score =~ s/,//g;
	    @raw_scores = split( /\s+/ , $raw_score );

	} else {

	    my $lmt = $nbest - 1;
	    my @topfive = split( / <SEP> / , $output);

	    foreach my $i (0..$lmt) {

		my @single = split( / <TAB> / , $topfive[$i]);

		my $ot_score = $single[0];
		push( @raw_scores , $ot_score );

		my $ot_trans = $single[1];
		$ot_trans =~ s/\@\@ //g;
		$ot_trans =~ s/\@\@$//;
		$ot_trans =~ s/ ~~'s/'s/g;
		push( @raw_trans  , $ot_trans );
	    }
	}

	
	##  scores and detokenization
	foreach my $raw (@raw_scores) {
	    my $score = sprintf("%.03f",$raw);
	    push( @scores , $score );
	}
	foreach my $raw (@raw_trans) {
	    my $ottran;
	    if (  $lgparm ne "scen" && $lgparm ne "iten" && $lgparm ne "enit" && $lgparm ne "scit" ) {
		##  cases:  En->Sc and It->Sc
		$ottran = sc_detokenizer($raw);
	    } elsif ( $lgparm ne "scen" && $lgparm ne "iten" ) {
		##  cases:  Sc->It and En->It
		$ottran = it_detokenizer($raw);
	    } else {
		##  cases:  Sc->En and It->En
		$ottran = en_detokenizer($raw);
	    }	    

	    ##  tighten up the text and push it to array
	    $ottran = tighten_text( $ottran );
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

    my $othtml;
    $othtml .= mk_header( $topnav , $landing );
    $othtml .= mk_form( $lgparm , $intext , $tokenized , $subsplit , "FALSE", $italian , $landing );
    if ( $intext ne "" ) {
    	$othtml .= mk_otmenu( \@scores , \@ottrans , $lgparm , $last_update , $nbest , $landing );
    } else {
    	$othtml .= mk_ottrans( $empty , $lgparm , $last_update );
    }
    $othtml .= mk_footer( $footnv , $landing );

    return $othtml;
}
}

1;
