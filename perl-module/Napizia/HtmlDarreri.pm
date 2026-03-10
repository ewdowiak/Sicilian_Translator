package Napizia::HtmlDarreri;

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

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(mk_header mk_footer mk_form mk_ottrans mk_otmenu);

##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  make HTML header
sub mk_header {

    ##  top navigation panel
    my $topnav = $_[0] ;

    ##  landing page
    my $landing   = $_[1];
    $landing = ( ! defined $landing ) ? "index.pl" : $landing;

    ##  landing hash
    my %lh = (
	"darreri.pl" => {
	    name => "Tradutturi Sicilianu",
	    enname => "Sicilian Translator",
	    langs => "Sicilian, English, Italian",
	},
	"darreri-usa.pl" => {
	    name => "Tradutturi Miricanu",
	    enname => "American Translator",
	    langs => "Sicilian, English, Italian",
	},
	);

    ##  prepare output HTML
    my $ottxt ;
    ## $ottxt .= "Content-type: text/html\n\n";
    $ottxt .= '<!DOCTYPE html>' . "\n" ;
    $ottxt .= '<html>' . "\n" ;
    $ottxt .= '  <head>' . "\n" ;
    $ottxt .= '    <title>Darreri lu Sipariu :: Napizia</title>' ."\n";
    $ottxt .= '    <meta name="DESCRIPTION" content="Behind the curtain of Napizia'."'".'s ';
    $ottxt .= $lh{$landing}{enname} .'.">'."\n";
    $ottxt .= '    <meta name="KEYWORDS" content="translate, translations, translation, translator, '."\n";
    $ottxt .= '          machine translation, online translation, '. $lh{$landing}{langs} .'">' ."\n";

    $ottxt .= '    <meta property="og:title" content="Darreri lu Sipariu :: Napizia">'."\n";
    $ottxt .= '    <meta name="twitter:title" content="Darreri lu Sipariu :: Napizia">'."\n";

    $ottxt .= '    <meta property="og:description" content="Behind the curtain of Napizia'."'".'s ';
    $ottxt .= $lh{$landing}{enname} .'">'."\n";
    $ottxt .= '    <meta name="twitter:description" content="Behind the curtain of Napizia'."'".'s ';
    $ottxt .= $lh{$landing}{enname} .'">'."\n";

    $ottxt .= '    <meta property="og:url" content="https://translate.napizia.com/cgi-bin/darreri.pl">'."\n";
    $ottxt .= '    <meta name="twitter:url" content="https://translate.napizia.com/cgi-bin/darreri.pl">'."\n";
    
    $ottxt .= '    <meta property="og:image" ';
    ## $ottxt .= 'content="https://translate.napizia.com/config/napizia_logo-w-descrip.jpg">'."\n";
    $ottxt .= 'content="https://translate.napizia.com/config/darreri-lu-sipariu.jpg">'."\n";
    $ottxt .= '    <meta name="twitter:image" ';
    ## $ottxt .= 'content="https://translate.napizia.com/config/napizia_logo-w-descrip.jpg">'."\n";
    $ottxt .= 'content="https://translate.napizia.com/config/darreri-lu-sipariu.jpg">'."\n";

    $ottxt .= '    <meta property="og:type" content="website">'."\n";
    $ottxt .= '    <meta name="twitter:site" content="@ProjectNapizia">'."\n";
    $ottxt .= '    <meta name="twitter:card" content="summary_large_image">'."\n";

    $ottxt .= '    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">' . "\n" ;
    $ottxt .= '    <meta name="Author" content="Eryk Wdowiak">' . "\n" ;
    $ottxt .= '    <link rel="stylesheet" type="text/css" href="/css/eryk.css">' ."\n";
    $ottxt .= '    <link rel="stylesheet" type="text/css" href="/css/eryk_theme-blue.css">' ."\n";
    $ottxt .= '    <link rel="stylesheet" type="text/css" href="/css/eryk_widenme.css">' ."\n";
    $ottxt .= '    <link rel="stylesheet" type="text/css" href="/css/dieli_forms.css">' ."\n";
    $ottxt .= '    <link rel="stylesheet" type="text/css" href="/css/napizia_translator.css">' ."\n";
    $ottxt .= '    <link rel="stylesheet" type="text/css" href="/css/napizia_darreri.css">' ."\n";
    $ottxt .= '    <link rel="stylesheet" type="text/css" href="/css/napizia_textarea.css">' ."\n";
    $ottxt .= '    <link rel="stylesheet" type="text/css" href="/css/font-awesome.min.css">'."\n";
    $ottxt .= '    <link rel="stylesheet" type="text/css" href="/css/w3-fa-styles.css">'."\n";
    $ottxt .= '    <link rel="icon" type="image/png" href="/config/napizia-icon.png">' ."\n";
    ##  $ottxt .= "\n";
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
    $ottxt .= '    <script type="text/javascript" src="/js/textarea-buttons.js"></script>'."\n";
    ## $ottxt .= "\n";
    $ottxt .= '    <meta name="viewport" content="width=device-width, initial-scale=1">' . "\n" ;
    $ottxt .= '  </head>' . "\n" ;
    $ottxt .= '  <body>'."\n";

    ##  top navigation panel
    open( my $fh_topnav , "<:encoding(utf-8)" , $topnav ); ## || die "could not read:  $topnav";
    while(<$fh_topnav>){ chomp;  $ottxt .= $_ ."\n";};
    close $fh_topnav ;

    $ottxt .= '  <!-- begin row div -->' . "\n" ;
    $ottxt .= '  <div class="row">' . "\n" ;
    $ottxt .= '    <div class="col-m-12 col-12">' . "\n" ;
    ##  $ottxt .= '      <h1>Darreri lu Sipariu</h1>'."\n";
    $ottxt .= '      <h1 style="margin-bottom: 0.15em;">Darreri lu Sipariu</h1>'."\n";
    $ottxt .= '      <h2 style="margin-top: 0.15em;">dû '. $lh{$landing}{name} .'</h2>'."\n";
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

    ##  landing page
    my $landing  = $_[1];
    $landing = ( ! defined $landing ) ? "darreri.pl" : $landing;

    ##  landing hash
    my %lh = (
	"darreri.pl" => {
	    name => "Tradutturi Sicilianu",
	    enname => "Sicilian Translator",
	    front => "index.pl",
	},
	"darreri-usa.pl" => {
	    name => "Tradutturi Miricanu",
	    enname => "American Translator",
	    front => "miricanu.pl",
	},
	);
    
    ##  prepare output
    my $othtml ;
    
    ##  open instruction div
    $othtml .= '<div class="row" style="margin: 15px 0px 2px 0px; border: 1px solid black; background-color: rgb(255,255,204);">'."\n";

    $othtml .= '<div class="col-m-12 col-6" style="padding: 0px 10px;">'."\n";
    $othtml .= '<p style="margin-top: 0.5em; margin-bottom: 0.5em; padding-left: 0px;">'."\n";
    $othtml .= 'Back here, "behind the curtain," you can see how the ';
    $othtml .= '<a href="/cgi-bin/'. $lh{$landing}{front} .'"><i>'. $lh{$landing}{enname} .'</i></a> works.</p>'."\n";

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
    $othtml .= 'For more information, please see the '."\n";
    $othtml .= '<a href="https://www.napizia.com/pages/sicilian/translator.shtml">documentation</a> '."\n";
    $othtml .= 'and the <a href="https://www.doviak.net/pages/ml-sicilian/index.shtml">Sicilian NLP</a> pages.</p>'."\n";
    
    $othtml .= '</div>'."\n";

    ##  close instruction div
    $othtml .= '</div>'."\n";

    ##  social media shares
    $othtml .= ''."\n";
    $othtml .= '<div class="message" style="margin: 0em auto; width: 100%;">'."\n";
    $othtml .= '<p style="text-align: center; margin-top: 0.15em; margin-bottom: 0.25em;">'."\n";
    $othtml .= '<a href="https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Ftranslate.napizia.com%2Fcgi-bin%2Fdarreri.pl"'."\n";
    $othtml .= '   class="fa fa-facebook" style="color:white;"'."\n";
    $othtml .= '   target="_blank"></a>'."\n";
    $othtml .= '<a href="https://bsky.app/intent/compose?text=Darreri%20lu%20Sipariu%20%3A%3A%20Napizia%0Ahttps%3A%2F%2Ftranslate.napizia.com%2Fcgi-bin%2Fdarreri.pl"'."\n";
    $othtml .= '   class="fa fa-bluesky" style="color:white;"'."\n";
    $othtml .= '   target="_blank"></a>'."\n";
    $othtml .= '<a href="https://www.linkedin.com/sharing/share-offsite/?url=https%3A%2F%2Ftranslate.napizia.com%2Fcgi-bin%2Fdarreri.pl"'."\n";
    $othtml .= '   class="fa fa-linkedin" style="color:white;"'."\n";
    $othtml .= '   target="_blank"></a>'."\n";
    $othtml .= '<a href="mailto:?subject=Darreri%20lu%20Sipariu%20%3A%3A%20Napizia&body=https%3A%2F%2Ftranslate.napizia.com%2Fcgi-bin%2Fdarreri.pl"'."\n";
    $othtml .= '   class="fa fa-envelope" style="color:white;"'."\n";
    $othtml .= '   target="_blank"></a>'."\n";
    $othtml .= '</p>'."\n";
    $othtml .= '</div>'."\n";

    ##  bottom navigation panel
    open( my $fh_footnav , "<:encoding(utf-8)" , $footnv ); ## || die "could not read:  $footnv";
    while(<$fh_footnav>){ chomp;  $othtml .= $_ ."\n";};
    close $fh_footnav ;
    
    $othtml .= '</body>'."\n";
    $othtml .= '</html>'."\n";

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

    my $empty      = $_[4] ;
    $empty = ( ! defined $empty || $empty ne "EMPTY" ) ? "FALSE" : "EMPTY";

    my $italian    = $_[5];
    $italian = ( ! defined $italian ) ? "FALSE" : $italian;
    
    my $landing    = $_[6];
    $landing = ( ! defined $landing ) ? "darreri.pl" : $landing;
    
    my $ottxt ;
    $ottxt .= '<!-- begin row div -->' . "\n";
    $ottxt .= '<div class="row">' ."\n";
    $ottxt .= '<!-- begin box div -->' . "\n";
    $ottxt .= '<div class="col-m-12 col-5 intrans">' ."\n";
    
    $ottxt .= '<form enctype="multipart/form-data" action="/cgi-bin/'. $landing .'" method="post">'."\n";
    $ottxt .= '<table style="width: 100%; padding: 0px 3px 0px 0px;"><tbody>'."\n";

    $ottxt .= '<tr>' ;
    $ottxt .= '<td colspan="2">'."\n";
    $ottxt .= '<div class="txtacont">'."\n";
    
    $ottxt .= '<textarea name="intext" rows="6" maxlength="500" class="intrans" id="intxtbox" autofocus>';
    $ottxt .= $intext ;
    $ottxt .= '</textarea>'."\n";

    $ottxt .= '<input class="clrbtn" type="button" value="x" onclick="javascript:eraseText();">'."\n";
    ##  ##  do NOT hide on small screen
    ##  $ottxt .= '<div class="buttonsud">'."\n";
    $ottxt .= '<input class="accent" type="button" value="à" onclick="javascript:accent_a();">'."\n";
    $ottxt .= '<input class="accent" type="button" value="è" onclick="javascript:accent_e();">'."\n";
    $ottxt .= '<input class="accext" type="button" value="ì" onclick="javascript:accent_i();">'."\n";
    $ottxt .= '<input class="accent" type="button" value="ò" onclick="javascript:accent_o();">'."\n";
    $ottxt .= '<input class="accent" type="button" value="ù" onclick="javascript:accent_u();">'."\n";
    $ottxt .= "\n";
    $ottxt .= '&nbsp;&nbsp;'."\n";
    $ottxt .= "\n";
    $ottxt .= '<input class="accent" type="button" value="â" onclick="javascript:circum_a();">'."\n";
    $ottxt .= '<input class="accent" type="button" value="ê" onclick="javascript:circum_e();">'."\n";
    $ottxt .= '<input class="accext" type="button" value="î" onclick="javascript:circum_i();">'."\n";
    $ottxt .= '<input class="accent" type="button" value="ô" onclick="javascript:circum_o();">'."\n";
    $ottxt .= '<input class="accent" type="button" value="û" onclick="javascript:circum_u();">'."\n";
    ##  $ottxt .= '</div>'."\n";
    $ottxt .= '</div>'."\n";

    $ottxt .= '</td></tr>'."\n";    
    $ottxt .= '<tr>'."\n"; 
    $ottxt .= '<td>'."\n"; 

    $ottxt .= '<select name="langs">'."\n";

    if ( $lgparm ne "ensc" && $lgparm ne "iten" && $lgparm ne "enit" && $lgparm ne "itsc" && $lgparm ne "scit" ) {

	##  the default case where lgparm is "scen"
	$ottxt .= '<option value="scen">Sicilianu-Nglisi</option>'."\n";
	if ( $italian eq "enable" ) {
	    $ottxt .= '<option value="scit">Sicilianu-Talianu</option>'."\n";
	}
	$ottxt .= '<option value="ensc">Nglisi-Sicilianu</option>'."\n";
	if ( $italian eq "enable" ) {
	    $ottxt .= '<option value="enit">Nglisi-Talianu</option>'."\n";
	    $ottxt .= '<option value="itsc">Talianu-Sicilianu</option>'."\n";
	    $ottxt .= '<option value="iten">Talianu-Nglisi</option>'."\n";
	}

    } elsif ( $lgparm ne "iten" && $lgparm ne "enit" && $lgparm ne "itsc" && $lgparm ne "scit" ) {

	##  english to sicilian
	$ottxt .= '<option value="ensc">Nglisi-Sicilianu</option>'."\n";
	if ( $italian eq "enable" ) {
	    $ottxt .= '<option value="enit">Nglisi-Talianu</option>'."\n";
	}
	$ottxt .= '<option value="scen">Sicilianu-Nglisi</option>'."\n";
	if ( $italian eq "enable" ) {
	    $ottxt .= '<option value="scit">Sicilianu-Talianu</option>'."\n";
	    $ottxt .= '<option value="iten">Talianu-Nglisi</option>'."\n";
	    $ottxt .= '<option value="itsc">Talianu-Sicilianu</option>'."\n";
	}

    } elsif ( $lgparm ne "enit" && $lgparm ne "itsc" && $lgparm ne "scit" ) {

	##  italian to english
	$ottxt .= '<option value="iten">Talianu-Nglisi</option>'."\n";
	$ottxt .= '<option value="itsc">Talianu-Sicilianu</option>'."\n";
	$ottxt .= '<option value="enit">Nglisi-Talianu</option>'."\n";
	$ottxt .= '<option value="ensc">Nglisi-Sicilianu</option>'."\n";
	$ottxt .= '<option value="scit">Sicilianu-Talianu</option>'."\n";
	$ottxt .= '<option value="scen">Sicilianu-Nglisi</option>'."\n";

    } elsif ( $lgparm ne "itsc" && $lgparm ne "scit" ) {

	##  english to italian
	$ottxt .= '<option value="enit">Nglisi-Talianu</option>'."\n";
	$ottxt .= '<option value="ensc">Nglisi-Sicilianu</option>'."\n";
	$ottxt .= '<option value="iten">Talianu-Nglisi</option>'."\n";
	$ottxt .= '<option value="itsc">Talianu-Sicilianu</option>'."\n";
	$ottxt .= '<option value="scen">Sicilianu-Nglisi</option>'."\n";
	$ottxt .= '<option value="scit">Sicilianu-Talianu</option>'."\n";

    } elsif ( $lgparm ne "itsc" ) {

	##  sicilian to italian
	$ottxt .= '<option value="scit">Sicilianu-Talianu</option>'."\n";
	$ottxt .= '<option value="scen">Sicilianu-Nglisi</option>'."\n";
	$ottxt .= '<option value="itsc">Talianu-Sicilianu</option>'."\n";
	$ottxt .= '<option value="iten">Talianu-Nglisi</option>'."\n";
	$ottxt .= '<option value="ensc">Nglisi-Sicilianu</option>'."\n";
	$ottxt .= '<option value="enit">Nglisi-Talianu</option>'."\n";	

    } else {
	##  italian to sicilian
	$ottxt .= '<option value="itsc">Talianu-Sicilianu</option>'."\n";
	$ottxt .= '<option value="iten">Talianu-Nglisi</option>'."\n";
	$ottxt .= '<option value="scit">Sicilianu-Talianu</option>'."\n";
	$ottxt .= '<option value="scen">Sicilianu-Nglisi</option>'."\n";
	$ottxt .= '<option value="enit">Nglisi-Talianu</option>'."\n";
	$ottxt .= '<option value="ensc">Nglisi-Sicilianu</option>'."\n";
    }    
    $ottxt .= '</select>'."\n";

    $ottxt .= '</td>'."\n";
    $ottxt .= '<td align="right">'.'<input type="submit" value="Traduci">'."\n";
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
    my $ottrans     = $_[0];
    my $orgl        = $_[1];
    my $last_update = $_[2];

    ##  new and original language parameters
    # my $org_lgparm = ( ! defined $orgl || ( $orgl ne "ensc" && $orgl ne "iten" && $orgl ne "enit" ) ) ? "scen" : $orgl;
    # my %newhash = ( "scen" => "ensc", "ensc" => "scen", "iten" => "enit", "enit" => "iten");
    # my $new_lgparm = $newhash{$org_lgparm};
    
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

    ##  original language direction
    my $orgl = $_[2];

    ##  new and original language parameters
    my $org_lgparm = ( ! defined $orgl || ( $orgl ne "ensc" && $orgl ne "iten" && $orgl ne "enit" &&
					    $orgl ne "itsc" && $orgl ne "scit" ) ) ? "scen" : $orgl;
    my %newhash = ( "scen" => "ensc", "ensc" => "scen",
		    "iten" => "enit", "enit" => "iten",
		    "itsc" => "scit", "scit" => "itsc");
    my $new_lgparm = $newhash{$org_lgparm};

    ##  last update
    my $last_update = $_[3];
    
    ##  and the number to return
    my $nbest   = $_[4];

    ##  landing page
    my $landing = $_[5];
    $landing = ( ! defined $landing ) ? "darreri.pl" : $landing;

    ##  initialize output
    my $ottxt ;
    
    ##  output translation menu
    $ottxt .= '<!-- begin ottrans div -->' . "\n";
    $ottxt .= '<div class="col-m-12 col-7 darreri">'."\n";
    $ottxt .= '<form enctype="multipart/form-data" action="/cgi-bin/'. $landing .'" method="post">'."\n";
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

1;
