#!/usr/bin/perl
use strict;
use warnings;
use Net::SMTP;
use Encode;

my $fromadd = 'hoge@example.com';
my $mailto = 'hoge@example.com';
my $subject = 'てすと￡ソッ～ス';
$subject = UTF8MAP($subject);
Encode::from_to($subject, "utf8", "iso-2022-jp");

my $mail_header = << "MAILHEADER";
From: $fromadd
To: $mailto
Subject: $subject
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit

MAILHEADER

my $mail_body = 'ﾃｽﾄてすとソッス＠￡＠～＠' . "\n\n";
$mail_body = UTF8MAP($mail_body);

# Encode::from_toでiso-2022-jpを指定すると半角カナは全角に変換してしまうので注意。7bit-jisを使う
#（基本的に上記のencodeでは半角カナはダメ。携帯向けならば、charset=Shift-JIS、Transfer-Encoding:base64 にして、必要なところをbase64化（encode_base64）する）
Encode::from_to($mail_body, "utf8", "iso-2022-jp");

# print $mail_header . $mail_body;

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

exit(0);


sub UTF8MAP{
	my $val = decode_utf8($_[0]);

	# UTF8->CP932はOKだが、UTF8->ISO-2022-JPでは以下の文字が?になる。UTF8の段階で対応する文字にマップする
	# ※対応するモジュール（Encode::ISO2022JPMS (ISO-2022-JP-MS) とか、Encode::EUCJPMS）があればこれ使わなくてもいいが、ないので個別対応
	#
	#	"\x{ff5e}" => "\x{301c}", # ～ (1-33, WAVE DASH)
	#	"\x{2225}" => "\x{2016}", # ∥ (1-34, DOUBLE VERTICAL LINE)
	#	"\x{ff0d}" => "\x{2212}", # － (1-61, MINUS SIGN)
	#	"\x{ffe0}" => "\x{00a2}", # ￠ (1-81, CENT SIGN)
	#	"\x{ffe1}" => "\x{00a3}", # ￡ (1-82, POUND SIGN)
	#	"\x{ffe2}" => "\x{00ac}", # ￢ (2-44, NOT SIGN)

	$val =~ tr/[\x{ff5e}\x{2225}\x{ff0d}\x{ffe0}\x{ffe1}\x{ffe2}]/[\x{301c}\x{2016}\x{2212}\x{00a2}\x{00a3}\x{00ac}]/;

	return encode_utf8($val);
}

__END__
