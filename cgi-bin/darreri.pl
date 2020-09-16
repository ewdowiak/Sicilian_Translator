#!/usr/bin/perl

##  Perl script to call machine translator

##  Eryk Wdowiak
##  21 Feb 2020

use strict;
use warnings;
no warnings qw(uninitialized numeric void);
use CGI qw(:standard);

use lib '/home/soul/.perl/lib/perl5';
use Napizia::Translator;
use Napizia::HtmlDarreri;

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
	print mk_otmenu( \@scores , \@ottrans , $lgparm , $last_update , $nbest);
    } else {
	print mk_ottrans( $empty , $lgparm , $last_update );
    }
    print mk_footer( $footnv );
    
}
