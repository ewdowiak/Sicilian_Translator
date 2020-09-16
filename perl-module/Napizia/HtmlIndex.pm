package Napizia::HtmlIndex;

use strict;
use warnings;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(mk_header mk_footer mk_form mk_ottrans);

##  ##  ##  ##  ##  ##  ##  ##  ##  ##

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
    $ottxt .= '    <meta name="DESCRIPTION" content="Traduci tra Ngrisi e Sicilianu. '."\n";
    $ottxt .= '          Translate between English and Sicilian.">' ."\n";
    $ottxt .= '    <meta name="KEYWORDS" content="translate, translations, translation, translator, '."\n";
    $ottxt .= '          machine translation, online translation, Sicilian, English">' ."\n";
    $ottxt .= '    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">' . "\n" ;
    $ottxt .= '    <meta name="Author" content="Eryk Wdowiak">' . "\n" ;
    $ottxt .= '    <link rel="stylesheet" type="text/css" href="/css/eryk.css">' ."\n";
    $ottxt .= '    <link rel="stylesheet" type="text/css" href="/css/eryk_theme-blue.css">' ."\n";
    $ottxt .= '    <link rel="stylesheet" type="text/css" href="/css/eryk_widenme.css">' ."\n";
    $ottxt .= '    <link rel="stylesheet" type="text/css" href="/css/dieli_forms.css">' ."\n";
    $ottxt .= '    <link rel="stylesheet" type="text/css" href="/css/napizia_translator.css">' ."\n";
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
    $othtml .= '<div class="row" style="margin: 5px 0px 5px 0px; border: 1px solid black; background-color: rgb(255,255,204);">'."\n";

    $othtml .= '<div class="col-m-12 bnotes1" style="padding: 0px 5px;">'."\n";
    $othtml .= '<p class="bnotes">'; ## ."\n";
    ## $othtml .= 'Sta màchina è ancora nta na fasi di sviluppu. '."\n";##, ma traduci beni quacchi frasi. '."\n";
    $othtml .= 'Si&nbsp;preja di leggiri la '."\n";
    $othtml .= '<a href="https://www.napizia.com/pages/sicilian/translator.shtml">documentazioni</a>, taliari lu '."\n";
    $othtml .= '<a href="https://youtu.be/w5_InALARi0" target="_blank">video</a> o veniri '."\n";
    $othtml .= '<a href="/cgi-bin/darreri.pl"><i>Darreri lu Sipariu</i></a>.</p>'."\n";
    $othtml .= '  </div>'."\n";

    $othtml .= '<div class="col-m-12 bnotes2" style="padding: 0px 5px;">'."\n";
    $othtml .= '<p class="bnotes">'; ## ."\n";
    ## $othtml .= 'This machine is still under development. '."\n";##, but translates some sentences well. '."\n";
    $othtml .= 'Please read the '."\n";
    $othtml .= '<a href="https://www.napizia.com/pages/sicilian/translator.shtml">documentation</a>, watch the '."\n";
    $othtml .= '<a href="https://youtu.be/w5_InALARi0" target="_blank">video</a> or come '."\n";
    $othtml .= '<a href="/cgi-bin/darreri.pl"><i>Behind the Curtain</i></a>.</p>'."\n";
    $othtml .= '</div>'."\n";
    
    $othtml .= '<div class="col-m-12 bnotes3" style="padding: 0px 5px;">'."\n";
    $othtml .= '<p class="bnotes">Grazzi a '."\n";
    $othtml .= '<a href="http://www.arbasicula.org/" target="_blank">Arba Sicula</a>,'."\n";
    $othtml .= '<a href="https://en.wikipedia.org/wiki/Gaetano_Cipolla" target="_blank">Gaetano Cipolla</a>,'."\n";
    $othtml .= '<a href="http://www.dieli.net" target="_blank">Arthur Dieli</a> e '."\n";
    $othtml .= '<a href="https://awslabs.github.io/sockeye/" target="_blank">Sockeye</a>.</p>'."\n";
    #$othtml .= '</div>'."\n";
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
    $ottxt .= '<div class="col-m-12 col-5 intrans">' ."\n";

    $ottxt .= '<form enctype="multipart/form-data" action="/cgi-bin/index.pl" method="post">'."\n";
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
    my $switch  = $_[2];
    $switch = ( ! defined $switch || $switch ne "FALSE" ) ? "TRUE" : "FALSE";

    ##  spoken form
    my $spoken_form = $_[3];
    
    ##  last update
    my $last_update = $_[4];
    
    ##  prepare quotes for form value
    ( my $ottrans_form = $ottrans ) =~ s/"/\&quot;/g;

    ##  set form to empty if False
    $ottrans_form = ( $switch eq "FALSE" ) ? "" : $ottrans_form ;
    
    ##  initialize output
    my $ottxt ;
    
    ##  switch direction
    $ottxt .= '<!-- begin switch -->'."\n";
    $ottxt .= '<div class="col-m-12 col-1 switch">'."\n";
    $ottxt .= '  <form enctype="multipart/form-data" action="/cgi-bin/index.pl" method="post">'."\n";
    $ottxt .= '    <table><tbody><tr><td>'."\n";
    $ottxt .= '	    <input type="submit" value="&harr;" class="switchlr">'."\n";
    $ottxt .= '	    <input type="submit" value="&#8597;" class="switchud">'."\n";
    $ottxt .= '    </td></tr></tbody></table>'."\n";
    $ottxt .= '    <input type="hidden" name="langs" value="'. $new_lgparm .'">'."\n";
    $ottxt .= '    <input type="hidden" name="intext" value="'. $ottrans_form .'">'."\n";
    $ottxt .= '  </form>'."\n";
    $ottxt .= '</div>'."\n";
    $ottxt .= '<!-- end switch -->'."\n";

    ##  if English to Sicilian, prepare spoken voice
    my $spoken = ( $new_lgparm eq "ensc" ) ? $ottrans : $spoken_form;
    
    ##  output translation
    $ottxt .= '<!-- begin ottrans div -->' . "\n";
    $ottxt .= '<div class="col-m-12 col-6">'."\n";
    $ottxt .= '<div class="ottrans">'."\n";
    
    ##  if Sicilian to English, just output translation
    ##  if English to Sicilian AND difference between literary and spoken voices, then offer switch
    if ( $ottrans eq $spoken ) {
	$ottxt .= '<p style="margin-top: 0.5em; margin-bottom: 0.5em;">' . $ottrans . '</p>'."\n";
    } else {
	$ottxt .= '<input type=radio id="spoken" name="voice">'."\n";
	$ottxt .= '<input type=radio id="literary" name="voice" checked>'."\n";
	$ottxt .= "\n";
	$ottxt .= '<span id="spkvoice">' . $spoken . '</span>'."\n";
	$ottxt .= '<span id="litvoice">' . $ottrans . '</span>'."\n";
	$ottxt .= "\n";
	$ottxt .= '<label for="spoken" id="showspk">'."\n";
	$ottxt .= '  <span>Mostra la forma parrata.</span>'."\n";
	$ottxt .= '</label>'."\n";
	$ottxt .= '<input type=radio id="spoken" name="voice">'."\n";
	$ottxt .= '<label for="literary" id="showlit">'."\n";
	$ottxt .= '  <span>Mostra la forma litteraria.</span>'."\n";
	$ottxt .= '</label>'."\n";
	$ottxt .= '<input type=radio id="literary" name="voice">'."\n";
    }
    
    $ottxt .= '</div>' . "\n" ;
    $ottxt .= '</div>' . "\n" ;
    $ottxt .= '<!-- end ottrans div -->' ."\n";
    $ottxt .= '<p class="lastupdate">'. $last_update .'</p>'."\n";
    $ottxt .= '</div>' . "\n" ;
    $ottxt .= '<!-- end row div -->' ."\n";

    return $ottxt ;
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

1;
