package TAPORlib;

=head1 NAME

C<TAPORlib> - TAPORlib is a Perl module that contains some useful functions.

=head1 DESCRIPTION

This library used by some great modules as WWW::Promotion, etc.
It is provided by TAPOR, Inc.

=cut

##############################################################################
use strict;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK $eol @rndletters %countrycodes);

require Exporter;

use Socket;
use Carp;

@ISA = qw(Exporter);
@EXPORT = qw(&Delete_CRLF_from_End_Of_String
	     &add_string_to_file
	     &GetAllFilesInDir
	     &GetPageNow_4
	     &uri_escape
	     &HTMLdie
	     &isrunninglocaly
	     &newsocketto
	     &GenerateRandomString
	     &CreateAndSendOutHtmlPage
	     &CheckForDomain
	     &SendToDomainIfNotThisDomain
	     &MassiveToString
	     &GetCountryCodes
	     );
@EXPORT_OK = qw();

$VERSION = "8.50";

$eol        = "\x0D\x0A"; # "\r\n";
@rndletters = qw(q w e r t y u i o p a s d f g h j k l z x c v b n m);

%countrycodes = (
    'ca' => 'Canada',
    'af' => 'Afghanistan',
    'al' => 'Albania',
    'dz' => 'Algeria',
    'as' => 'American Samoa',
    'ad' => 'Andorra',
    'ao' => 'Angola',
    'ai' => 'Anguilla',
    'aq' => 'Antarctica',
    'ag' => 'Antigua and Barbuda',
    'ar' => 'Argentina',
    'am' => 'Armenia',
    'aw' => 'Aruba',
    'au' => 'Australia',
    'at' => 'Austria',
    'az' => 'Azerbaijan',
    'bs' => 'Bahamas',
    'bh' => 'Bahrain',
    'bd' => 'Bangladesh',
    'bb' => 'Barbados',
    'by' => 'Belarus',
    'be' => 'Belgium',
    'bz' => 'Belize',
    'bj' => 'Benin',
    'bm' => 'Bermuda',
    'bt' => 'Bhutan',
    'bo' => 'Bolivia',
    'ba' => 'Bosnia and Herzegovina',
    'bw' => 'Botswana',
    'bv' => 'Bouvet Island',
    'br' => 'Brazil',
    'io' => 'British Indian Ocean Territory',
    'vg' => 'British Virgin Islands',
    'bn' => 'Brunei',
    'bg' => 'Bulgaria',
    'bf' => 'Burkina Faso',
    'bi' => 'Burundi',
    'kh' => 'Cambodia',
    'cm' => 'Cameroon',
    'cv' => 'Cape Verde',
    'ky' => 'Cayman Islands',
    'cf' => 'Central African Republic',
    'td' => 'Chad',
    'cl' => 'Chile',
    'cn' => 'China',
    'cx' => 'Christmas Island',
    'cc' => 'Cocos Islands',
    'co' => 'Colombia',
    'km' => 'Comoros',
    'cg' => 'Congo',
    'ck' => 'Cook Islands',
    'cr' => 'Costa Rica',
    'hr' => 'Croatia',
    'cu' => 'Cuba',
    'cy' => 'Cyprus',
    'cz' => 'Czech Republic',
    'dk' => 'Denmark',
    'dj' => 'Djibouti',
    'dm' => 'Dominica',
    'do' => 'Dominican Republic',
    'tp' => 'East Timor',
    'ec' => 'Ecuador',
    'eg' => 'Egypt',
    'sv' => 'El Salvador',
    'gq' => 'Equatorial Guinea',
    'er' => 'Eritrea',
    'ee' => 'Estonia',
    'et' => 'Ethiopia',
    'fk' => 'Falkland Islands',
    'fo' => 'Faroe Islands',
    'fj' => 'Fiji',
    'fi' => 'Finland',
    'fr' => 'France',
    'gf' => 'French Guiana',
    'pf' => 'French Polynesia',
    'tf' => 'French Southern Territories',
    'ga' => 'Gabon',
    'gm' => 'Gambia',
    'ge' => 'Georgia',
    'de' => 'Germany',
    'gh' => 'Ghana',
    'gi' => 'Gibraltar',
    'gr' => 'Greece',
    'gl' => 'Greenland',
    'gd' => 'Grenada',
    'gp' => 'Guadeloupe',
    'gu' => 'Guam',
    'gt' => 'Guatemala',
    'gn' => 'Guinea',
    'gw' => 'Guinea-Bissau',
    'gy' => 'Guyana',
    'ht' => 'Haiti',
    'hm' => 'Heard and McDonald Islands',
    'hn' => 'Honduras',
    'hk' => 'Hong Kong',
    'hu' => 'Hungary',
    'is' => 'Iceland',
    'in' => 'India',
    'id' => 'Indonesia',
    'ir' => 'Iran',
    'iq' => 'Iraq',
    'ie' => 'Ireland',
    'il' => 'Israel',
    'it' => 'Italy',
    'ci' => 'Ivory Coast',
    'jm' => 'Jamaica',
    'jp' => 'Japan',
    'jo' => 'Jordan',
    'kz' => 'Kazakhstan',
    'ke' => 'Kenya',
    'ki' => 'Kiribati',
    'kp' => 'Korea, North',
    'kr' => 'Korea, South',
    'kw' => 'Kuwait',
    'kg' => 'Kyrgyzstan',
    'la' => 'Laos',
    'lv' => 'Latvia',
    'lb' => 'Lebanon',
    'ls' => 'Lesotho',
    'lr' => 'Liberia',
    'ly' => 'Libya',
    'li' => 'Liechtenstein',
    'lt' => 'Lithuania',
    'lu' => 'Luxembourg',
    'mo' => 'Macau',
    'mk' => 'Macedonia, Former Yugoslav Republic of',
    'mg' => 'Madagascar',
    'mw' => 'Malawi',
    'my' => 'Malaysia',
    'mv' => 'Maldives',
    'ml' => 'Mali',
    'mt' => 'Malta',
    'mh' => 'Marshall Islands',
    'mq' => 'Martinique',
    'mr' => 'Mauritania',
    'mu' => 'Mauritius',
    'yt' => 'Mayotte',
    'mx' => 'Mexico',
    'fm' => 'Micronesia, Federated States of',
    'md' => 'Moldova',
    'mc' => 'Monaco',
    'mn' => 'Mongolia',
    'ms' => 'Montserrat',
    'ma' => 'Morocco',
    'mz' => 'Mozambique',
    'mm' => 'Myanmar',
    'na' => 'Namibia',
    'nr' => 'Nauru',
    'np' => 'Nepal',
    'nl' => 'Netherlands',
    'an' => 'Netherlands Antilles',
    'nc' => 'New Caledonia',
    'nz' => 'New Zealand',
    'ni' => 'Nicaragua',
    'ne' => 'Niger',
    'ng' => 'Nigeria',
    'nu' => 'Niue',
    'nf' => 'Norfolk Island',
    'mp' => 'Northern Mariana Islands',
    'no' => 'Norway',
    'om' => 'Oman',
    'pk' => 'Pakistan',
    'pw' => 'Palau',
    'pa' => 'Panama',
    'pg' => 'Papua New Guinea',
    'py' => 'Paraguay',
    'pe' => 'Peru',
    'ph' => 'Philippines',
    'pn' => 'Pitcairn Island',
    'pl' => 'Poland',
    'pt' => 'Portugal',
    'pr' => 'Puerto Rico',
    'qa' => 'Qatar',
    're' => 'Reunion',
    'ro' => 'Romania',
    'ru' => 'Russia',
    'rw' => 'Rwanda',
    'gs' => 'S. Georgia and S. Sandwich Isls.',
    'kn' => 'Saint Kitts & Nevis',
    'lc' => 'Saint Lucia',
    'vc' => 'Saint Vincent and The Grenadines',
    'ws' => 'Samoa',
    'sm' => 'San Marino',
    'st' => 'Sao Tome and Principe',
    'sa' => 'Saudi Arabia',
    'sn' => 'Senegal',
    'sc' => 'Seychelles',
    'sl' => 'Sierra Leone',
    'sg' => 'Singapore',
    'sk' => 'Slovakia',
    'si' => 'Slovenia',
    'so' => 'Somalia',
    'za' => 'South Africa',
    'es' => 'Spain',
    'lk' => 'Sri Lanka',
    'sh' => 'St. Helena',
    'pm' => 'St. Pierre and Miquelon',
    'sd' => 'Sudan',
    'sr' => 'Suriname',
    'sj' => 'Svalbard and Jan Mayen Islands',
    'sz' => 'Swaziland',
    'se' => 'Sweden',
    'ch' => 'Switzerland',
    'sy' => 'Syria',
    'tw' => 'Taiwan',
    'tj' => 'Tajikistan',
    'tz' => 'Tanzania',
    'th' => 'Thailand',
    'tg' => 'Togo',
    'tk' => 'Tokelau',
    'to' => 'Tonga',
    'tt' => 'Trinidad and Tobago',
    'tn' => 'Tunisia',
    'tr' => 'Turkey',
    'tm' => 'Turkmenistan',
    'tc' => 'Turks and Caicos Islands',
    'tv' => 'Tuvalu',
    'um' => 'U.S. Minor Outlying Islands',
    'ug' => 'Uganda',
    'ua' => 'Ukraine',
    'ae' => 'United Arab Emirates',
    'uk' => 'United Kingdom',
    'us' => 'United States of America',
    'uy' => 'Uruguay',
    'uz' => 'Uzbekistan',
    'vu' => 'Vanuatu',
    'va' => 'Vatican City',
    've' => 'Venezuela',
    'vn' => 'Vietnam',
    'vi' => 'Virgin Islands',
    'wf' => 'Wallis and Futuna Islands',
    'eh' => 'Western Sahara',
    'ye' => 'Yemen',
    'yu' => 'Yugoslavia (Former)',
    'zr' => 'Zaire',
    'zm' => 'Zambia',
    'zw' => 'Zimbabwe',
);
##############################################################################

=head1 IMPORTED FUNCTIONS/VARS

=head1

=head2 $string = &Delete_CRLF_from_End_Of_String($string);
 
 Description:

 Function removes trailing "r" and "\n" from end of $string.

=cut  

sub Delete_CRLF_from_End_Of_String {
    my ($string) = shift;

    while(1)
	{
	if($string=~ m/\r$/)
	    {
	    $string = substr($string,0,-1);
	    }
	elsif($string=~ m/\n$/)
	    {
	    $string = substr($string,0,-1);
	    }
	else
	    {
    	    return $string;
	    }	
	}
}
###############################################################################

=head2 &add_string_to_file("filename",$string);

 Description:

 This function adds $string to the end of file "filename".

=cut  

sub add_string_to_file {
    my $file = shift;
    my $string = shift;
    
    if(open(FILE,">>$file"))
	{
        print FILE $string;
        close(FILE);
	}
}
###############################################################################

=head2 @allfiles = &GetAllFilesInDir($dirname);

 Description:

 This function returns massive that contains filenames with 
 path in directory $dirname and filenames with path in subdirs also.

=cut  

sub GetAllFilesInDir {
my($usedir) = @_;
my(@allfiles,@bodydir,$fileindir);

@allfiles = ();
if(opendir(DIR,$usedir))
    {
    @bodydir = readdir(DIR);
    close(DIR);
    foreach $fileindir (@bodydir)
    	{
	if($fileindir eq '.' || $fileindir eq '..') {next;}
	if(-d $usedir . "/" . $fileindir)
	    {
	    push(@allfiles,&GetAllFilesInDir("$usedir/$fileindir"));
	    }
	else
	    {
	    push(@allfiles,"$usedir/$fileindir");
	    }
	}
    }
return @allfiles;
}
##############################################################################

=head2 %out = &GetPageNow_4(%pagenow);

 Description:
 
 Use this function to get page from website. 

 Usage:

 $pagenow{'url'}     = "http://www.any.com/anyware";
 $pagenow{'method'}  = "POST|GET";
 $pagenow{'referer'} = "http://www.any.com/anyware/ref";
 $pagenow{'content'} = "user=blah\&info=blah-blah";

 # If defined this agent string will be used insted Netscape
 $pagenow{'agent'}

 # If specified Print some useful information to this logfile;
 $pagenow{'logfile'} = "logfile.log";

 # If proxy not specified then Get Page without usage of proxy.
 $pagenow{'proxy'} = "proxy.online.ru:8080";

 # If specified then send to page this cookies
 $pagenow{'cookies'} = "C: 12345";

 # TimeOut to Connect To Proxy/Host. Default: 60
 $pagenow{'timeoutconnect'} = 60;

 # TimeOut to Request Page. Default: 300
 $pagenow{'timeoutrequest'} = 180;

 # No Request Page Return Simple 'FAST MODE' page.
 $pagenow{'norequest'} = 1;

 # Show Error Page If Error Detected
 $pagenow{'showerrors'} = 1;

 %out = &GetPageNow_4(%pagenow);

 Output:
 
 $out{'error'} == 0 - No errors
 $out{'error'} == 1 - Some Error.
 $out{'errortxt'}   - Error description if $out{'error'} == 1
 $out{'status'}  - Status of downloaded page
 $out{'headers'} - Header of downloaded page
 $out{'body'}    - Body of downloaded page
 $out{'cookies'} - Cookies If page return some cookies

=cut

sub GetPageNow_4 {
    my(%pagenow) = @_;
    my(%out);

next_url:

    my($logfile) = $pagenow{'logfile'};
    
    if(!defined($pagenow{'timeoutconnect'}))
	{
	$pagenow{'timeoutconnect'} = 60;
	}
    if(!defined($pagenow{'timeoutrequest'}))
	{
	$pagenow{'timeoutrequest'} = 300;
	}

    my($key);

    add_string_to_file($logfile,"\n--- GetPageNow_4(): --------- Input Data ---------\n");
    foreach $key (keys %pagenow)
        {
        $pagenow{$key} = Delete_CRLF_from_End_Of_String($pagenow{$key});
        add_string_to_file($logfile,"$key = '$pagenow{$key}'\n");
        }

    if($pagenow{'method'} ne 'POST' && $pagenow{'method'} ne 'GET')
        {
        $out{'errortxt'} = "GetPageNow_4(): Invalid method: $pagenow{'method'}";
	goto print_error_to_log_and_exit;
        }
    if($pagenow{'method'} eq 'POST' && !defined($pagenow{'content'}))
        {
        $out{'errortxt'} = "GetPageNow_4(): POST without content not allowed";
	goto print_error_to_log_and_exit;
        }

    if(!($pagenow{'url'} =~ m|^(http://)([^/\?\\]*)|i))
        {
        $out{'errortxt'} = "GetPageNow_4(): Invalid url format: $pagenow{'url'}";
        goto print_error_to_log_and_exit;
        }	
    my($hostaddr,$hostport) = split(/\:/,$2);
    $hostport = defined($hostport) ? $hostport : 80;
    
    $pagenow{'savedurl'} = $pagenow{'url'};
    
    $out{'error'}=1;

    #----------------- Change Reserved syms to %xx -----------------------
    if(defined($pagenow{'content'}))
	{
	my($reserved)    = ";\\/?:\\@#";
	my($unsafe)      = "\x00-\x20{}|\\\\^\\[\\]`<>\"\x7F-\xFF";
	$pagenow{'content'} =~ s/ /+/g;
	$pagenow{'content'} = &uri_escape($pagenow{'content'},$reserved . $unsafe);
	$pagenow{'contentlen'} = length($pagenow{'content'});
	}
    #---------------------------------------------------------------------

    my($hostconnectaddr,$hostconnectport);
    
    if(defined($pagenow{'proxy'}))
	{
        ($hostconnectaddr,$hostconnectport) = split(/\:/,$pagenow{'proxy'});
        $hostconnectport = defined($hostconnectport) ? $hostconnectport : 80;
	}
    else
	{
        ($hostconnectaddr,$hostconnectport) = ($hostaddr,$hostport);
	$pagenow{'url'} =~ m|^(http://)([^/\?\\]*)([^\r]*)$|i;
	$pagenow{'url'} = $3;
	if($pagenow{'url'} eq "") { $pagenow{'url'} = "/";}
	}	

    add_string_to_file($logfile,"\nnewsocketto(ADDR:$hostconnectaddr,PORT:$hostconnectport,TIMEOUT:$pagenow{'timeoutconnect'})\n");
    
    my %outsocket = newsocketto(*S,$hostconnectaddr,$hostconnectport,$pagenow{'timeoutconnect'});
    if($outsocket{'error'}==1)
        {
        $out{'errortxt'} = $outsocket{'errortxt'};
	goto print_error_to_log_and_exit;
        }
	    	    	    
    select(S); $| = 1;
    select(STDOUT); $| = 1;

# POST ------------------------------------------------------------------------
my(@data);

if($pagenow{'method'} eq 'POST') {

@data   = ("POST $pagenow{'url'} HTTP/1.0$eol");

if(defined($pagenow{'referer'})) {push(@data,("Referer: $pagenow{'referer'}$eol"));}

if(defined($pagenow{'proxy'})) 
    { 
    push(@data,("Proxy-Connection: Keep-Alive$eol")); 
    }    
else 
    { 
#   push(@data,("Connection: Keep-Alive$eol")); 
    push(@data,("Connection: Close$eol")); 
    }

if(defined($pagenow{'agent'})) 
    {
    push(@data,("User-Agent: $pagenow{'agent'}$eol"));
    }
else    
    {
    push(@data,("User-Agent: Mozilla/4.7 [en] (Win98; I)$eol"));
    }

if($hostport==80)
    {
    push(@data,("Host: $hostaddr$eol"));
    }
else
    {
    push(@data,("Host: $hostaddr:$hostport$eol"));
    }    

push(@data,("Accept: image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, image/png, */*$eol",
#           "Accept-Encoding: gzip$eol",
            "Accept-Language: en$eol",
            "Accept-Charset: iso-8859-1,*,utf-8$eol",
            ));

if(defined($pagenow{'cookies'})) 
    {
    push(@data,("Cookie: $pagenow{'cookies'})$eol"));
    }

push(@data,("Content-type: application/x-www-form-urlencoded$eol",
            "Content-length: $pagenow{'contentlen'}$eol$eol",
	    ));
	    
push(@data,("$pagenow{'content'}"));

add_string_to_file($logfile,"\n----------------------- Request -------------------\n");
foreach (@data) {add_string_to_file($logfile,$_);}
add_string_to_file($logfile,"\n--------------------- Request end -----------------\n");
}

# GET ------------------------------------------------------------------------
if($pagenow{'method'} eq 'GET') {

if(!defined($pagenow{'content'})) {@data = ("GET $pagenow{'url'} HTTP/1.0$eol");}
else {@data = ("GET $pagenow{'url'}?$pagenow{'content'} HTTP/1.0$eol");}

if(defined($pagenow{'referer'})) {push(@data,("Referer: $pagenow{'referer'}$eol"));}

if(defined($pagenow{'proxy'})) 
    { 
    push(@data,("Proxy-Connection: Keep-Alive$eol")); 
    }    
else 
    { 
#   push(@data,("Connection: Keep-Alive$eol")); 
    push(@data,("Connection: Close$eol")); 
    }

if(defined($pagenow{'agent'})) 
    {
    push(@data,("User-Agent: $pagenow{'agent'}$eol"));
    }
else    
    {
    push(@data,("User-Agent: Mozilla/4.7 [en] (Win98; I)$eol"));
    }

if($hostport==80)
    {
    push(@data,("Host: $hostaddr$eol"));
    }
else
    {
    push(@data,("Host: $hostaddr:$hostport$eol"));
    }    

push(@data,("Accept: image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, image/png, */*$eol",
#           "Accept-Encoding: gzip$eol",
            "Accept-Language: en$eol",
            "Accept-Charset: iso-8859-1,*,utf-8$eol",
	    "Pragma: No-Cache$eol"));

if(defined($pagenow{'cookies'})) 
    {
    push(@data,("Cookie: $pagenow{'cookies'})$eol$eol"));
    }
else
    {
    push(@data,("$eol"));
    }

add_string_to_file($logfile,"\n----------------------- Request -------------------\n");
foreach (@data) {add_string_to_file($logfile,$_);}
add_string_to_file($logfile,"\n--------------------- Request end -----------------\n");
}

# SEND REQUEST ---------------------------------------------------------------
my($timeout) = $pagenow{'timeoutrequest'};
local($SIG{ALRM}) = $timeout ? sub {die;} : $SIG{ALRM} || 'DEFAULT';

my($result,$status,$headers,@body);
    
$result = eval {
alarm($timeout) if($timeout);
foreach (@data) {print S $_;}
alarm(0) if($timeout);
1;
};

unless($result) 
    {
    close(S);
    $out{'errortxt'} = "GetPageNow_4(): TimeOut Send to Socket after $timeout seconds";
    goto print_error_to_log_and_exit;
    }

# GET PAGE ---------------------------------------------------------------
if(defined($pagenow{'norequest'}))    
    {
    close(S);
    @body = ();
    push @body, <<FASTBODY;
    
<HTML>
<BODY>
<CENTER>FAST</CENTER>
</BODY>
</HTML>
    
FASTBODY

    $out{'error'} = 0;
    $out{'status'} = "HTTP/1.1 200 OK";
    delete($out{'headers'});
    $out{'body'} = &MassiveToString(@body);
    return %out;
    }

$result = eval {
alarm($timeout) if($timeout);
$status  = <S>;
alarm(0) if($timeout);
1;
};

unless($result) 
    {
    close(S);
    $out{'errortxt'} = "GetPageNow_4(): TimeOut Req Status after $timeout seconds";
    goto print_error_to_log_and_exit;
    }
$out{'status'} = $status;
    
$headers = '';

$result = eval {
alarm($timeout) if($timeout);

do
    {
    $headers.= $_ = <S> ;    # $headers includes last blank line
    } until (/^(\015\012|\012)$/) ;   # lines may be terminated with LF or CRLF
	
alarm(0) if($timeout);
1;
};

unless($result) 
    {
    close(S);
    $out{'errortxt'} = "GetPageNow_4(): TimeOut Req Header after $timeout seconds";
    goto print_error_to_log_and_exit;
    }
	
# Unfold long header lines, a la RFC 822 section 3.1.1
$headers=~ s/(\015\012|\012)[ \t]/ /g ;

$out{'headers'} = $headers;

$result = eval {
alarm($timeout) if($timeout);
@body=<S>;
alarm(0) if($timeout);
1;
};

$out{'body'} = "@body";

unless($result) 
    {
    close(S);
    $out{'errortxt'} = "GetPageNow_4(): TimeOut Req Body after $timeout seconds";
    goto print_error_to_log_and_exit;
    }
    
close(S);

my($cookies)=getcookies($headers);

if($cookies && !defined($pagenow{'cookies'}))
    {
    $pagenow{'cookies'} = $cookies;
    }
elsif($cookies && defined($pagenow{'cookies'}))    
    {
    $pagenow{'cookies'} = joincookies($pagenow{'cookies'},$cookies);
    }
    
add_string_to_file($logfile,"$status\n");
add_string_to_file($logfile,"$headers\n");

if(defined($pagenow{'cookies'})) 
    {
    add_string_to_file($logfile,"Cookies: $pagenow{'cookies'}\n\n");
    }
else 
    {
    add_string_to_file($logfile,"Cookies: <NONE>\n\n");
    }

add_string_to_file($logfile,"@body\n\n");

if ($status=~ m#^HTTP/[0-9.]*\s*[45]\d\d#) 
	{
	if(defined($pagenow{'showerrors'})) 
	    {
	    &HTMLdie("@body");
	    }
	else 
	    {
	    $out{'errortxt'} = "GetPageNow_4(): Server answer: $status";
	    goto print_error_to_log_and_exit;
	    }
	}

if($headers=~ m|(^Location:\s+)([^\r\n ]+)|im)
        {
	add_string_to_file($logfile,"------------->>>>> REDIRECT ---------->>>>\n");

	my($location) = $2;
	
	if(!($location =~ m|^(http://)|i))
	    {
	    $location = $pagenow{'savedurl'} . "/" . $location;
	    }
	$pagenow{'url'}	= $location;
	
	add_string_to_file($logfile,"TO: $location\n\n");

        if($location=~ m|^(http://)([^\?]*)\?([^\r\n]*)|i)
	    {
	    $pagenow{'content'} = $3;
	    add_string_to_file($logfile,"NEW CONTENT: $pagenow{'content'}\n");
	    }
	else
	    {
	    delete($pagenow{'content'});
	    delete($pagenow{'contentlen'});
	    delete($pagenow{'savedurl'});
	    }	    

	$pagenow{'method'} = "GET";
        goto next_url;
        }

if(defined($pagenow{'cookies'})) {$out{'cookies'} = $pagenow{'cookies'};}
$out{'error'} = 0;
return %out;

print_error_to_log_and_exit:
add_string_to_file($logfile,"\n$out{'errortxt'}\n");
return %out;
}
###############################################################################

=head2 $text = &uri_escape($text,$pattern);

 Description:

 This function escapes url, commonly used to changes 
 special symbols in url.

 Usage:

 $text    = "sss"
 $pattern = "\x00-\xFF";
 $text = &uri_escape($text,$pattern);
 
 Output:
 
 $text = "%73%73%73";

=cut  

sub uri_escape {
    my($text,$patn) = @_;
    return undef unless defined $text;

    my %escapes;
    # Build a char->hex map
    for (0..255) 
	{
        $escapes{chr($_)} = sprintf("%%%02X", $_);
	}

    my %subst;
    if(defined $patn)
	{
	unless (exists $subst{$patn}) 
	    {
	    # Because we can't compile regex we fake it with a cached sub
	    $subst{$patn} =
	      eval "sub {\$_[0] =~ s/([$patn])/\$escapes{\$1}/g; }";
	      Carp::croak("uri_escape: $@") if $@;
	    }
	&{$subst{$patn}}($text);
	} 
    else 
	{
	# Default unsafe characters. (RFC1738 section 2.2)
	$text =~ s/([\x00-\x20"#%;<>?{}|\\\\^~`\[\]\x7F-\xFF])/$escapes{$1}/g; #"
	}
    return $text;
}
###############################################################################

=head2 &HTMLdie($text);

 Description:

 Send HTML page with $text to STDOUT and exit program.

=cut  

sub HTMLdie {
	my($msg)= @_ ;
	printHTMLheader();
	print "$msg\n";
	printHTMLfooter();
	exit;
}
##############################################################################
sub printHTMLheader {
    if(!isrunninglocaly())
	{
	print "Content-type: text/html\n\n";
	print "<html><body>\n";
	print "Goto <A HREF=http://sex.tapor.com target=_top>http://sex.tapor.com</A> to view best video sex on the net!<br><br>\n\n";
	}
    else
	{
	print "Goto http://sex.tapor.com to view best video sex on the net!\n\n";
	}
}
##############################################################################
sub bhprintHTMLfooter {
    if(!isrunninglocaly())
	{
	print "</body></html>\n";
	}
}
##############################################################################

=head2 &isrunninglocaly()

 Description:

 Function returns TRUE if script executed in console, FALSE 
 otherwise, e.g. when running under Apache.

=cut  

sub isrunninglocaly {
    my($method) = defined($ENV{'REQUEST_METHOD'}) ? $ENV{'REQUEST_METHOD'} : 'LOCAL';
    
    if ($method eq 'GET' || $method eq 'POST') 
	{
        return 0;
	}
    return 1;
}
##############################################################################
sub getcookies {
    my($string)= @_ ;

    my @mhead = split(/(\015\012|\012)/, $string);
    my $flag  = 0;

    my($cookies) = '';

    foreach my $line (@mhead)
        {
        if($line=~ m|(^Set-Cookie:\s+)([^\r\n ]+)|im)
                {
                my $cookie = $2;
                my @mcook = split(/;/, $cookie);
                if($flag==0)
                        {
                        $cookies="$mcook[0]";
                        $flag=1;
                        }
                else
                        {
                        $cookies="$cookies; $mcook[0]";
                        }
                }
        }
    return $cookies;

}
##############################################################################

=head2 $rndstring = &GenerateRandomString($number);

 Description:

 This function returns string with $number random chars.
 
=cut  

sub GenerateRandomString {
    my($num)= @_ ;
 
    my $outstring ='';
    my $y;
    for($y=0;$y<$num;$y++)
	{
	my $rndnum  = int rand($#rndletters);
	my $letter  = $rndletters[$rndnum];
	$outstring = "$outstring$letter";
	}
   return $outstring; 
}
##############################################################################

=head2 &CreateAndSendOutHtmlPage($a,$type);

 Description:

 This function will create HTML page, print it to stdout and exit.
 $type may be:
 1 - CreateAndSendOutHtmlPage() will execute script in
     $a path, print it output to stdout and exit.
 2 - CreateAndSendOutHtmlPage() will read file $a,
     print it contents to stdout and exit.
 3 - CreateAndSendOutHtmlPage() will print string
     "Location: $a\n\n" to stdout and exit.

 Examples:
 CreateAndSendOutHtmlPage("/path/index.cgi",1);
 CreateAndSendOutHtmlPage("/path/index.html",2);
 CreateAndSendOutHtmlPage("http://www.tapor.com",3);
 
=cut  

sub CreateAndSendOutHtmlPage {
    my($a,$type)= @_ ;

    my $output;
    
    if($type == 1)
	{
	$output = `$a`;
	print $output;
	exit;
	}

    my @body;

    if($type == 2)
	{
	if(open(FILE,$a))
	    {
	    @body = <FILE>;
	    close(FILE);
	    }
    
	print "Content-type: text/html\n\n";
	print @body;
	exit;
	}

    if($type == 3)
	{
	print "Location: http://$a\n\n";
	exit;
	}
	
}
##############################################################################

=head2 &CheckForDomain($domain);

 Description:
 
 This function does very simple task, it compare $domain with $ENV{'HTTP_HOST'}.
 If equal function returns TRUE otherwise it returns FALSE.

=cut  
 
sub CheckForDomain {
    my($domain)= @_;
    
    if($domain ne $ENV{'HTTP_HOST'}) {return 0;}

    return 1;
}
###############################################################################

=head2 &SendToDomainIfNotThisDomain($domain);

 Description:

 This function resend Web user to new location if domain not $domain.
 See previous function description.

=cut  

sub SendToDomainIfNotThisDomain {
    my($domain)= @_;

    if(!&CheckForDomain($domain))
	{
	print "Location: http://$domain\n\n";
	exit;
	}
}
###############################################################################

=head2 $string = &MassiveToString(@massive);

 Description:
 
 This function does very simple task, it convert massive @massive to string
 $string.

=cut  

sub MassiveToString {
	my(@body) = @_;
	my($commonline);
	
	foreach (@body) { $commonline = $commonline . $_; }
	return $commonline; 
}
###############################################################################

=head2 %cc=&GetCountryCodes();

 Description:
 Returns hash with Country codes as:

 %countrycodes = (
    'ca' => 'Canada',
    'af' => 'Afghanistan',
    'al' => 'Albania',
     ...
     );
 
=cut  

sub GetCountryCodes {
    return %countrycodes;
}
##############################################################################

=head2 %out = &newsocketto(*S,$host,$port,$timeoutconnect);

 Description:

 This function returns connected socket to $host:$port if no error.
 $timeoutconnect is time limit to connect to $host:$port.
 
 Usage:

 %out = &newsocketto(*S,$host,$port,$timeoutconnect);
 
 Output:

 $out{'error'} == 0 - No errors
 $out{'error'} == 1 - Some Error.
 $out{'errortxt'}   - Error description if $out{'error'} == 1
 S - connected socket to $host:$port.

=cut  

sub newsocketto {
    local(*S) = shift;
    my($host,$port,$timeout) = @_;
    my($ok,$result);
    
    my(%out);
    $out{'error'} = 1; 

    local($SIG{ALRM}) = $timeout ? sub { $out{'errortxt'} = "newsocketto(): Error connecting to $host:$port after $timeout seconds";die;} : $SIG{ALRM} || 'DEFAULT';
    
    $result = eval {
    alarm($timeout) if($timeout);

    my $iaddr;
    if(!($iaddr=inet_aton($host))) 
	{
	$out{'errortxt'} = "newsocketto(): Error resolving '$host'";
        alarm(0) if($timeout);
	die;
	}
    my $paddr = sockaddr_in($port,$iaddr);
    if(!socket(S, AF_INET, SOCK_STREAM, 0))
	{
	$out{'errortxt'} = "newsocketto(): Error getting socket()"; 
        alarm(0) if($timeout);
	die;
	}
    $ok = connect(S, $paddr);
    if(!$ok)
	{
	$out{'errortxt'} = "newsocketto(): Can't connect to '$host'";
        alarm(0) if($timeout);
	die;
	}
    alarm(0) if($timeout);
    1;
    };
    unless($result) {return %out;}
    $out{'error'} = 0; 
    return %out;
}
###############################################################################

=head1 COPYRIGHT

Copyright (c) 2000-2001 TAPOR, Inc. All rights reserved.
This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

http://www.tapor.com/TAPORlib/

=cut
