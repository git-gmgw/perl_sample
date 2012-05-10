#!/usr/bin/perl
use strict;
use warnings;
use Net::SMTP;
use Encode;
use MIME::Base64;

my $fromadd = 'hoge@example.com';
my $mailto = 'hoge@example.com';
my $subject = 'てすとソッ～ス';

# $fromadd = encode('MIME-Header',$fromadd,"");
# $mailto = encode('MIME-Header',$mailto,"");
$subject = encode('MIME-Header',$subject,"");
# $subject = '=?UTF-8?B?'.encode_base64($subject,"").'?=';

# Encode::from_to($subject, "utf8", "cp932");
# $subject = '=?SHIFT-JIS?B?'.encode_base64($subject,"").'?=';

my $mail_header = << "MAILHEADER";
From: $fromadd
To: $mailto
Subject: $subject
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64

MAILHEADER

my $mail_body = 'ﾃｽﾄてすとソッス＠＠～＠' . "\n\n";
# Encode::from_to($mail_body, "utf8", "cp932");
$mail_body = encode_base64($mail_body,"");

print $mail_header . $mail_body;

# メール送信
my $smtp = Net::SMTP->new('smtp.example.com');
if ($smtp) {
	$smtp->mail($fromadd);
	$smtp->to($mailto);
	$smtp->data();
	$smtp->datasend($mail_header);
	$smtp->datasend($mail_body);
	$smtp->dataend();
	$smtp->quit;
}

__END__
