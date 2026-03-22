package Napizia::HtmlIndex;

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
our @EXPORT = ("mk_footer","mk_form","mk_ottrans");

##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  make footer
sub mk_footer {

    ##  prepare output
    my $othtml ;
    
    ##  open instruction div
    $othtml .= '<div class="row" style="margin: 5px 0px 3px 0px; border: 1px solid black; background-color: rgb(255,255,204);">'."\n";

    $othtml .= '<div class="col-m-12 bnotes1" style="padding: 0px 5px;">'."\n";
    $othtml .= '<p class="bnotes">'; ## ."\n";
    $othtml .= 'Si&nbsp;preja di leggiri la '."\n";
    $othtml .= '<a href="https://www.napizia.com/pages/sicilian/translator-sc.shtml">documentazioni</a>';
    $othtml .= ', '."\n".'di taliari lu ';
    #$othtml .= '<a href="https://youtu.be/w5_InALARi0" target="_blank">videu</a>';
    #$othtml .= '<a href="https://youtu.be/bPVuQ9CjfrA" target="_blank">videu</a>';
    $othtml .= '<a href="https://youtu.be/nVf3tMEDtwo" target="_blank">videu</a>';
    $othtml .= ' '."\n".'o di veniri <a href="/cgi-bin/darreri.pl"><i>Darreri lu Sipariu</i></a>.</p>'."\n";
    $othtml .= '  </div>'."\n";
    $othtml .= '<div class="col-m-12 bnotes2" style="padding: 0px 5px;">'."\n";
    $othtml .= '<p class="bnotes">'; ## ."\n";
    $othtml .= 'Please read the '."\n";
    $othtml .= '<a href="https://www.napizia.com/pages/sicilian/translator.shtml">documentation</a>';
    $othtml .= ', '."\n".'watch the ';
    $othtml .= '<a href="https://youtu.be/nVf3tMEDtwo" target="_blank">video</a>';
    $othtml .= ' '."\n".'or come <a href="/cgi-bin/darreri.pl"><i>Behind the Curtain</i></a>.</p>'."\n";
    $othtml .= '</div>'."\n";
    $othtml .= '<div class="col-m-12 bnotes3" style="padding: 0px 5px;">'."\n";
    $othtml .= '<p class="bnotes">Grazzii a '."\n";
    $othtml .= '<a href="http://www.arbasicula.org/" target="_blank">Arba Sicula</a>,'."\n";
    $othtml .= '<a href="https://en.wikipedia.org/wiki/Gaetano_Cipolla" target="_blank">Gaetano Cipolla</a>'."\n";
    $othtml .= ' e <a href="http://www.dieli.net" target="_blank">Arthur Dieli</a>.';
    $othtml .= '</p>'."\n";
    $othtml .= '</div>'."\n";

    ##  close instruction div
    $othtml .= '</div>'."\n";

    ##  social media shares
    $othtml .= '<div class="message" style="margin: 0em auto; width: 100%;">'."\n";
    $othtml .= '<p style="text-align: center; margin-top: 0.15em; margin-bottom: 0.25em;">'."\n";
    $othtml .= '<a href="https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Ftranslate.napizia.com%2Fcgi-bin%2Findex.pl"'."\n";
    $othtml .= '   class="fa fa-facebook" style="color:white;"'."\n";
    $othtml .= '   target="_blank"></a>'."\n";
    $othtml .= '<a href="https://bsky.app/intent/compose?text=Tradutturi%20Sicilianu%20%3A%3A%20Napizia%0Ahttps%3A%2F%2Ftranslate.napizia.com%2Fcgi-bin%2Findex.pl"'."\n";
    $othtml .= '   class="fa fa-bluesky" style="color:white;"'."\n";
    $othtml .= '   target="_blank"></a>'."\n";
    $othtml .= '<a href="https://www.linkedin.com/sharing/share-offsite/?url=https%3A%2F%2Ftranslate.napizia.com%2Fcgi-bin%2Findex.pl"'."\n";
    $othtml .= '   class="fa fa-linkedin" style="color:white;"'."\n";
    $othtml .= '   target="_blank"></a>'."\n";
    $othtml .= '<a href="mailto:?subject=Tradutturi%20Sicilianu%20%3A%3A%20Napizia&body=https%3A%2F%2Ftranslate.napizia.com%2Fcgi-bin%2Findex.pl"'."\n";
    $othtml .= '   class="fa fa-envelope" style="color:white;"'."\n";
    $othtml .= '   target="_blank"></a>'."\n";
    $othtml .= '</p>'."\n";
    $othtml .= '</div>'."\n";

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
    $ottxt .= '<div class="col-m-12 col-fivehalf intrans">' ."\n";

    $ottxt .= '<form enctype="multipart/form-data" action="/cgi-bin/index.pl" method="post">'."\n";
    $ottxt .= '<table style="width: 100%; padding: 0px 3px 0px 0px;"><tbody>'."\n";

    $ottxt .= '<tr>' ;
    $ottxt .= '<td colspan="2">'."\n";
    $ottxt .= '<div class="txtacont">'."\n";

    $ottxt .= '<textarea name="intext" rows="7" maxlength="500" class="intrans" id="intxtbox" autofocus>';
    $ottxt .= $intext ;
    $ottxt .= '</textarea>'."\n";

    $ottxt .= '<input class="clrbtn" type="button" value="x" onclick="javascript:eraseText();">'."\n";
    $ottxt .= '<div class="buttonsud">'."\n";
    $ottxt .= '<input class="accent accentud" type="button" value="à" onclick="javascript:accent_a();">'."\n";
    $ottxt .= '<input class="accent accentud" type="button" value="è" onclick="javascript:accent_e();">'."\n";
    $ottxt .= '<input class="accext accentud" type="button" value="ì" onclick="javascript:accent_i();">'."\n";
    $ottxt .= '<input class="accent accentud" type="button" value="ò" onclick="javascript:accent_o();">'."\n";
    $ottxt .= '<input class="accent accentud" type="button" value="ù" onclick="javascript:accent_u();">'."\n";
    $ottxt .= "\n";
    $ottxt .= '&nbsp;&nbsp;'."\n";
    $ottxt .= "\n";
    $ottxt .= '<input class="accent accentud" type="button" value="â" onclick="javascript:circum_a();">'."\n";
    $ottxt .= '<input class="accent accentud" type="button" value="ê" onclick="javascript:circum_e();">'."\n";
    $ottxt .= '<input class="accext accentud" type="button" value="î" onclick="javascript:circum_i();">'."\n";
    $ottxt .= '<input class="accent accentud" type="button" value="ô" onclick="javascript:circum_o();">'."\n";
    $ottxt .= '<input class="accent accentud" type="button" value="û" onclick="javascript:circum_u();">'."\n";
    $ottxt .= '</div>'."\n";
    
    $ottxt .= '</div>'."\n";
    $ottxt .= '</td></tr>'."\n";
    $ottxt .= '<tr>'."\n"; 
    $ottxt .= '<td>'."\n"; 

    $ottxt .= '<select name="langs">'."\n";

    if ( $lgparm ne "ensc" && $lgparm ne "iten" && $lgparm ne "enit" && $lgparm ne "itsc" && $lgparm ne "scit" ) {

	##  the default case where lgparm is "scen"
	$ottxt .= '<option value="scen">Sicilianu-Nglisi</option>'."\n";
	$ottxt .= '<option value="scit">Sicilianu-Talianu</option>'."\n";
	$ottxt .= '<option value="ensc">Nglisi-Sicilianu</option>'."\n";
	$ottxt .= '<option value="enit">Nglisi-Talianu</option>'."\n";
	$ottxt .= '<option value="itsc">Talianu-Sicilianu</option>'."\n";
	$ottxt .= '<option value="iten">Talianu-Nglisi</option>'."\n";


    } elsif ( $lgparm ne "iten" && $lgparm ne "enit" && $lgparm ne "itsc" && $lgparm ne "scit" ) {

	##  english to sicilian
	$ottxt .= '<option value="ensc">Nglisi-Sicilianu</option>'."\n";
	$ottxt .= '<option value="enit">Nglisi-Talianu</option>'."\n";
	$ottxt .= '<option value="scen">Sicilianu-Nglisi</option>'."\n";
	$ottxt .= '<option value="scit">Sicilianu-Talianu</option>'."\n";
	$ottxt .= '<option value="iten">Talianu-Nglisi</option>'."\n";
	$ottxt .= '<option value="itsc">Talianu-Sicilianu</option>'."\n";

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
        
    $ottxt .= '</div>' . "\n" ;
    $ottxt .= '<!-- end box div -->' ."\n";

    return $ottxt ;
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

sub mk_ottrans {

    ##  output translation and language direction
    my $ottrans = $_[0];
    my $orgl    = $_[1];

    ##  new and original language parameters
    my $org_lgparm = ( ! defined $orgl || ( $orgl ne "ensc" && $orgl ne "iten" && $orgl ne "enit" &&
					    $orgl ne "itsc" && $orgl ne "scit" ) ) ? "scen" : $orgl;
    my %newhash = ( "scen" => "ensc", "ensc" => "scen",
		    "iten" => "enit", "enit" => "iten",
		    "itsc" => "scit", "scit" => "itsc");
    my $new_lgparm = $newhash{$org_lgparm};

    ##  switch, spoken form and last update
    my $switch  = $_[2];
    $switch = ( ! defined $switch || $switch ne "FALSE" ) ? "TRUE" : "FALSE";
    
    my $spoken_form = $_[3];
    my $last_update = $_[4];
    
    ##  prepare quotes for form value
    ( my $ottrans_form = $ottrans ) =~ s/"/\&quot;/g;

    ##  set form to empty if False
    $ottrans_form = ( $switch eq "FALSE" ) ? "" : $ottrans_form ;
    
    ##  initialize output
    my $ottxt ;
    
    ##  switch direction
    $ottxt .= '<!-- begin switch -->'."\n";
    $ottxt .= '<div class="col-m-12 col-onlyhalf switch">'."\n";
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

    ##  if En->Sc or It->Sc, prepare spoken voice
    my $spoken = ( $new_lgparm eq "ensc" || $new_lgparm eq "itsc" ||
		   $new_lgparm eq "enit" || $new_lgparm eq "iten" ) ? $ottrans : $spoken_form;
    
    ##  output translation
    $ottxt .= '<!-- begin ottrans div -->' . "\n";
    $ottxt .= '<div class="col-m-12 col-sixplus">'."\n";
    $ottxt .= '<div class="ottrans">'."\n";
    
    ##  if Sicilian to English, just output translation
    ##  if English to Sicilian AND difference between literary and spoken voices, then offer switch
    if ( $ottrans eq $spoken ) {
	$ottxt .= '<p style="margin-top: 0.5em; margin-bottom: 0.5em;">' . $ottrans . '</p>'."\n";
    } else {
	$ottxt .= '<input type=radio id="spoken" name="voice" checked>'."\n";
	$ottxt .= '<input type=radio id="literary" name="voice">'."\n";
	$ottxt .= "\n";
	$ottxt .= '<span id="spkvoice">' . $spoken . '</span>'."\n";
	$ottxt .= '<span id="litvoice">' . $ottrans . '</span>'."\n";
	$ottxt .= "\n";
	$ottxt .= '<label for="spoken" id="showspk">'."\n";
	$ottxt .= '  <span>Mostra la forma contratta.</span>'."\n";
	$ottxt .= '</label>'."\n";
	$ottxt .= '<input type=radio id="spoken" name="voice">'."\n";
	$ottxt .= '<label for="literary" id="showlit">'."\n";
	$ottxt .= '  <span>Mostra la forma littiraria.</span>'."\n";
	$ottxt .= '</label>'."\n";
	$ottxt .= '<input type=radio id="literary" name="voice">'."\n";
    }

    $ottxt .= '</div>'."\n";
    $ottxt .= "\n";
    $ottxt .= '<div class="txtacont buttonslr" style="margin: 0px 0px 0px 10px;">'."\n";
    $ottxt .= '<input class="accent accentlr" type="button" value="à" onclick="javascript:accent_a();">'."\n";
    $ottxt .= '<input class="accent accentlr" type="button" value="è" onclick="javascript:accent_e();">'."\n";
    $ottxt .= '<input class="accext accentlr" type="button" value="ì" onclick="javascript:accent_i();">'."\n";
    $ottxt .= '<input class="accent accentlr" type="button" value="ò" onclick="javascript:accent_o();">'."\n";
    $ottxt .= '<input class="accent accentlr" type="button" value="ù" onclick="javascript:accent_u();">'."\n";
    $ottxt .= "\n";
    $ottxt .= '&nbsp;&nbsp;'."\n";
    $ottxt .= "\n";
    $ottxt .= '<input class="accent accentlr" type="button" value="â" onclick="javascript:circum_a();">'."\n";
    $ottxt .= '<input class="accent accentlr" type="button" value="ê" onclick="javascript:circum_e();">'."\n";
    $ottxt .= '<input class="accext accentlr" type="button" value="î" onclick="javascript:circum_i();">'."\n";
    $ottxt .= '<input class="accent accentlr" type="button" value="ô" onclick="javascript:circum_o();">'."\n";
    $ottxt .= '<input class="accent accentlr" type="button" value="û" onclick="javascript:circum_u();">'."\n";
    $ottxt .= '&nbsp;&nbsp;'."\n";
    $ottxt .= '</div>'."\n";
    
    $ottxt .= '<span style="display: none;">'."\n";
    # $ottxt .= '<input type="text" value="'. $spoken .'" id="myTranslation">'."\n";
    my $js_str = $spoken;  $js_str =~ s/"/&quot;/g;
    $ottxt .= '<input type="text" value="'. $js_str .'" id="myTranslation">'."\n";
    $ottxt .= '</span>'."\n";
    $ottxt .= '<div class="txtacont tooltip">'."\n";
    $ottxt .= '<input type="button" value="Copia" onclick="javascript:copyTranslation();">'."\n";
    $ottxt .= '<span class="tooltiptext" id="myTooltip">copia la traduzzioni</span>'."\n";
    $ottxt .= '</div>'."\n";

    $ottxt .= "\n";
    $ottxt .= '</div>' . "\n" ;
    $ottxt .= '<!-- end ottrans div -->' ."\n";

    $ottxt .= '<p class="lastupdate">'. $last_update .'</p>'."\n";
    $ottxt .= '</div>' . "\n" ;
    $ottxt .= '<!-- end row div -->' ."\n";

    return $ottxt ;
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

1;
