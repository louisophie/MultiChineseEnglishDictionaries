#!/usr/bin/perl
use strict;
#use warnings;
use utf8;
binmode STDOUT,':encoding(UTF-8)';
binmode STDERR,':encoding(UTF-8)';
use open ':std', ':encoding(UTF-8)';
sub say{if(@_){print"@_\n";}else{print;print"\n";}}
use Encode qw(decode encode); # $_=decode("utf8",$_); 

say"Space as delimiters and '\e[01;31mfell off\e[m' as phases; ctrl+v and Regex .+* permitted";
open(FH,"<:encoding(UTF-8)","Dic_ahd_93559-items.xml")  or die "Can't open:$!";
open(GH,"<:encoding(UTF-8)","Dic_21th-etymonlin-zigen.xml")  or die "Can't open:$!";

local $/="\r";
my%_ahd=map{
	s/\r/\n\n/;
	/<key>(.+?)<\/key>/;
	$1 => $_; 
}<FH>;
my%_21=map{
	s/\r/\n/;
	/<key>(.+?)<\/key>/;
	$1 => $_; 
}<GH>;
local $/="\n";

chomp($_=<>);
my$t;
{
	$t++;
	chomp($_=<>) unless $t==1;
	s/^(.+?200~)|(.+?201~)//sg;		#ctrl+v permitted, ^[[200~(word)^[[201~, 230801
	s/'([^']+?)'/
		($_=$1)=~s{\s+}{@}g;
		$_;
	/gex;
	@_=map{s/@/ /g;$_;}split/ +/;

	open my $less,'|-','less -R' or die $!;
	foreach my$stdin(@_){
		print$less "---------- $stdin ----------\n";
		if($stdin=~/[.+*]/){
			map{$_ahd{$_}=~s/<key>.+<\/key>\n//g;print$less "$_ahd{$_}" if /$stdin/}keys(%_ahd);
			print$less "===========================\n";
			map{$_21{$_}=~s/<key>(.+)<\/key>/$1/g;print$less "$_21{$_}" if /$stdin/}keys(%_21);
		}else{
			$_ahd{$stdin}=~s/<key>.+<\/key>\n//g;print$less "$_ahd{$stdin}";
			print$less "===========================\n";
			$_21{$stdin}=~s/<key>(.+)<\/key>/$1/g;print$less "$_21{$stdin}";
		}
	}
redo;}
