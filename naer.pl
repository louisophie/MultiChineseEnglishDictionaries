#!/usr/bin/perl
use strict;
use warnings;
use utf8;
sub say{if(@_){print"@_\n";}else{print;print"\n";}}
#1558741	"鏻","金部","ㄌㄧㄣˊ","磷","化學名詞-化學名詞用字之讀音"
#1558741  6462435 93816997 naer-171117-sorted_1558741-items.dic


say"One item only for each search; ctrl+v permitted";
my($RED,$GREEN,$END)=("\e[01;31m","\e[32m","\e[m");
{

chomp(my$stdin=<>);
$stdin=~s/^(.+?200~)|(.+?201~)//sg;		#ctrl+v permitted, ^[[200~(word)^[[201~, 230801
open my $f,'|-','less -R' or die $!;
my$t;

my@a=map{
	if(/"$stdin"/){
		$t++;
		print$f "---------------------------\n" if $t==1;
		print$f "$t $_";
	}else{
		$_;
	}
}`egrep -i "$stdin" NAER-sorted_1558741-items.dic`;
$t++ and s/$stdin/$RED$stdin$END/i and print$f "$t $_" foreach @a;
redo;

}

