use strict;
use warnings;
use utf8;
use Term::UI;
use Term::ReadLine;
use Travel::Routing::DE::EFA;

binmode STDOUT, 'utf8';

my $term = Term::ReadLine->new('Bim.pl');
my $attr = $term->Attribs;
$attr->{attempted_completion_function} = \&complete;

our @keywords;
chop and push @keywords, split while <DATA>;

my $from = $term->get_reply( prompt => 'Von' );
my $to   = $term->get_reply( prompt => 'Nach' );
my $time = $term->get_reply( prompt => 'Abfahrt' );

sub complete {
    my ($text) = @_;

    return $term->completion_matches($text,\&keyword);
};

{
    my $i;
    sub keyword {
        my ($text, $state) = @_;
        return unless $text;
        if($state) {
            $i++;
        }
        else { # first call
            $i = 0;
        }
        for (; $i <= $#keywords; $i++) {
            return $keywords[$i] if $keywords[$i] =~ /^\Q$text/i;
        };
        return undef;
    }
};

my $efa = Travel::Routing::DE::EFA->new(
    efa_url        => 'http://www.linzag.at/static/XSLT_TRIP_REQUEST2',
    origin         => [ 'Linz/Donau', $from ],
    destination    => [ 'Linz/Donau', $to   ],
    departure_time => $time,
);

for my $route ( $efa->routes ) {
    for my $part ( $route->parts ) {
        printf(
            "%s at %s -> %s at %s, via %s to %s\n",
            $part->departure_time, $part->departure_stop,
            $part->arrival_time,   $part->arrival_stop,
            $part->train_line,     $part->train_destination,
        );
    }
    print "\n";
}

__DATA__

Aichinger
Aichwiesen
Aloisianum
Altenberger_Strasse
Am_Bachlberg
Am_Bindermichl
Am_Sonnenhang
Aubergstrasse
Auerguetlweg
Auerspergplatz
Aumuellerweg
Auwiesen
Bachlbergweg
Bahnhof_Ebelsberg
Bahnhof_Kleinmuenchen
Baintwiese
Bannerstrasse
Baumgaertelstrasse
Betriebsgebaeude_02
Betriebsgebaeude_34
Betriebsgebaeude_41
Betriebsgebaeude_47
Biberweg
Biegung
Binderlandweg
Blumauerplatz
Blumauerstrasse
Botanischer_Garten
Broschgasse
Brucknerhaus
Bulgariplatz
Buergerstrasse
Chemiepark
Darrgutstrasse
Dauphinestrasse
Deutlweg
Diessenleitenweg
Dinghoferstrasse
Don_Bosco
Donautal
Donnererweg
Dornach
Drosselweg
Duererstrasse
Ebelsberg
Edmund-Aigner-Strasse
Eduard-Suess-Strasse
Ehrentletzbergerstrasse
Eichendorffstrasse
Einschnitt
Eisenhof
Eisenwerkstrasse
Enenkelstrasse
Ennsfeld
Esterbachbruecke
Europaplatz
Europastrasse
Fa._Plasser
Fadingerstrasse
Falterweg
Ferdinand_Markl_Strasse
Fernheizkraftwerk
Florianer_Strasse
Floetzerweg
FMA
Frachtenbahnhof
Franckstrasse
Franzosenhausweg
Freinberg
Friedhofstrasse
Froschberg
Further_Weg
Gallanderstrasse
Garnisonstrasse
Ghegastrasse
Glaserstrasse
Glimpfingerstrasse
Goethekreuzung
Gruberstrasse
Gruendberg
Hafen
Hagen
Hamerlingstrasse
Hanriederstrasse
Hanuschstrasse
Harbach
Harbachsiedlung
Harruckerstrasse
Hartheimer_Strasse
Hatschekstrasse
Hauderweg
Hauptbahnhof
Hauptbahnhof/Busterminal
Hauptbahnhof/Kaerntnerstrasse
Hauptplatz
Hausleitnerweg
Haydnstrasse
Heilhamer_Weg
Helmholtzstrasse
Herz-Jesu-Kirche
Hessenplatz
Hillerstrasse
Hoher_Damm
Hollabererstrasse
Holzstrasse
Hopfengasse
Hoerschingergutstrasse
Hoerzingerstrasse
Humboldtstrasse
Im_Haidgattern
Im_Huetterland
Im_Schlantenfeld
Industriezeile
Jaeger_im_Tal
Jaegermayr
Johann-Strauss-Strasse
Kaplanhofstrasse
Kaplitzstrasse
Karl-Wiser-Strasse
Karlhof
Karlhofschule
Kaserne
Katzbach
Katzbachweg
Keferfeld
Klammstrasse
Klettfischerweg
Knabenseminarstrasse
Kokerei
Kopernikusstrasse
Kudlichstrasse
Lamprechtgang
Landgutstrasse
Landwiedstrasse
Laskahofstrasse
Lederergasse
Leitenbauerstrasse
Lenkstrasse
Leondinger_Strasse
Leonfeldner_Strasse
Lettner
Linke_Brueckenstrasse
Lissfeld
Lonstorferplatz
Luefteneggerstrasse
Maderleithnerweg
Magdalenastrasse
Marienberg
Mariendom
Mayrhoferstrasse
Meggauerstrasse
Metzstrasse
Mitterweg
Mozartkreuzung
Mozartschule
Muehlkreisbahnhof
Muldenstrasse
Mueller-Guttenbrunn-Strasse
Muellerweg
Museumstrasse
Nebingerstrasse
Neubauzeile
Neue_Heimat
Neue_Welt
Neufelderstrasse
Neuhoferstrasse
Neupeint
Nisslstrasse
Novaragasse
Obere_Donaulaende
Oberschableder
Obersteg
Oed
Oidener_Strasse
Ontlstrasse
Parkbad
Paul-Hahn-Strasse
Paula-Scherleitner-Weg
Pergheimerweg
Petzoldstrasse
Peuerbachstrasse
Pichling
Pichlinger_See
Posthofstrasse
Poestlingberg
Poestlingberg Schloessl
Prinz-Eugen-Strasse
Pummererstr.
Raedlerweg
Raffelstettner_Strasse
Ramsauerstrasse
Regerstrasse
Reiherweg
Remise_Kleinmuenchen
Riesenhof
Rilkestrasse
Robert-Stolz-Strasse
Rohrauerweg
Roemerbergschule
Rudolfstrasse
Salesianumweg
Salzburger_Strasse
Saporoshjestrasse
Schableder
Scharlinz
Schatzweg
Schickenedersteig
Schiffswerft
Schlachthof
Schoergenhubbad
Schueckbauerweg
Schulertal
Schumpeterstrasse
Schwaigaustrasse
Seidelbastweg
Sennweg
Siemensstrasse
Simonystrasse
Siriusweg
solarCity
solarCity-Zentrum
Sonnbergerstrasse
Sophiengutstrasse
Spallerhof
Spazgasse
Spechtweg
Sportanlage_Auwiesen
St._Magdalena
St._Margarethen
Stadion
Stadlerstrasse
Stahlbau
Stahlwerk
Steg
Stiblerweg
Stieglbauernstrasse
Suedpark
Taubenmarkt
Teistlergutstrasse
Theater
Theatergasse
Tiergarten
Turmleitenweg
Unionkreuzung
Universitaet_Nord
Untergaumberg
Urnenhain_Urfahr
Urnenhainweg
Vergeinerstrasse
VOEST-Alpine
Volksfeststrasse
Volksgarten
Wagner-Jauregg-Weg
Wahringerstrasse
Waldeggstrasse
Waldesruh
Wallseerstrasse
Wambacher Strasse
Wambachsiedlung
Wattstrasse
Wegscheider_Strasse
Weikhartweg
Weinheberstrasse
Werksposten_1
WIFI/Linz_AG
Wildbergstrasse
Wimhoelzelstrasse
Wimmerstrasse
Winetzhammerstrasse
Winklerbruecke
Worathweg
Zeppelinstrasse
Ziererfeldstrasse
Zoehrdorferfeld

Untergaumberg
Gaumberg
Larnhauserweg
Haag
Poststrasse
Meixnerkreuzung
Harterfeldsiedlung
Doblerholz
Im_Baeckerfeld
Langholzfeld
Plus_City
Wagram
Trauner_Kreuzung
