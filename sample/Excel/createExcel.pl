#!/usr/bin/perl
use strict;
use warnings;
use Win32::OLE;
use Win32::OLE::Const 'Microsoft Excel';
use Encode;

# エラー発生時のWin32::OLE モジュールの動きを指定（Carp::croak）
Win32::OLE->Option(Warn => 3);

# Excelの有無確認
eval {
	Win32::OLE->GetActiveObject('Excel.Application');
};
if ($@) {
	die "Excelが入っていません $@";
}

# Excelの起動
# ただし、実行するExcelのバージョンは2007を想定
my $excel = Win32::OLE->GetActiveObject('Excel.Application') || Win32::OLE->new('Excel.Application', 'Quit');
if (!defined($excel)) {
	die "Excelが起動できません";
}

# メッセージを抑制する（これをしないといろんなところでダイアログが出てしまう）
$excel->{DisplayAlerts} = 'False';

# workbookを作成する
$excel->{SheetsInNewWorkbook} = 1;
my $book = $excel->Workbooks->Add;

# 作った段階で付与される余計なものを調整
# xlRDIPrinterPath,xlRDIDocumentProperties,xlRDIRemovePersonalInformationをRemoveDocumentInformationで削除
$book->RemoveDocumentInformation(xlRDIPrinterPath);
$book->RemoveDocumentInformation(xlRDIDocumentProperties);
$book->RemoveDocumentInformation(xlRDIRemovePersonalInformation);


# sheetを作成する
my $sheet = $book->Worksheets(1);
my $ExcelFileName = 'c:\test.xls';

# utf8でベタに文字を書いているので、Excelに出す場合はShiftJIS(CP932)に変換する必要有
my $value = "て～すと①";
Encode::from_to($value, "utf8", "CP932");

# セルに出力
$sheet->Cells(1,1)->{Value} = $value;


# 保存してclose（2003以前の形式:xlExcel8(=56) で保存）
$book->SaveAs({Filename => "$ExcelFileName", Fileformat => 56});
$book->Close();

# Excelの終了
$excel->Quit();

__END__
