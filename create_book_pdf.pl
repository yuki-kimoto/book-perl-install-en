# 本のPDFを作成する手順
# HTML全体のビルド
# 見開きのPDFを作成
# 初めにのPDFを作成
# 各章の扉と本文のPDFを作成
# 本文全体(扉含む)を作成するために、各章の扉と本文を結合しながら、ページ番号を振っていく。
# 目次のHTMLを作成
# HTML全体のビルド(目次のため)
# 目次のPDFを作成
# 書籍全体を作成するために、見開きPDFとはじめにのPDFと目次のPDFと本文全体のPDFを結合。

use strict;
use warnings;
use FindBin;
use utf8;
use Encode 'encode', 'decode';
use Giblog;

use PDF::API2;

# wkhtmltopdfコマンド
my $wkhtmltopdf_cmd = '/usr/local/bin/wkhtmltopdf';

# ページサイズ
my $page_size = 'A5';

# マージン
my $margin_top = '13mm';
my $margin_bottom = '7mm';
my $margin_left = '13mm';
my $margin_right = '13mm';

# 低品質(これを指定しないと、見出しの文字が正しく描画されないバグがある)
my $lowquality = '--lowquality';

# HTMLをPDFに変換
my $wkhtmltopdf_cmd_with_opt = "$wkhtmltopdf_cmd $lowquality --page-size $page_size --margin-bottom $margin_bottom --margin-left $margin_left --margin-right $margin_right --margin-top $margin_top";

# 最終章
my $chapter_number_last = 6;

# 章のタイトルの一覧
my $chapter_titles = [];

# 目次を自動作成(h1とh2を取得)
create_toc_html_file();

# HTMLのビルド
Giblog->build;

# 見開きPDFを作成
create_top_pdf_file();

# はじめにPDFを作成
create_beginning_pdf_file();

print "Start create_toc_pdf_file()\n";

# 目次PDFを作成
create_toc_pdf_file();

print "Start create_each_chapter_pdf_files()\n";

# 各章の扉PDFと本文PDFを作成
create_each_chapter_pdf_files();

print "Start concat_pdf_file()\n";

# PDFを結合して完成原稿を作成
concat_pdf_file();

print "End\n";

# ファイル内容を取得
sub slurp {
  my ($file) = @_;
  
  open my $fh, '<', $file
    or die "Can't open file $file:$!";
  
  my $content = do { local $/; <$fh> };
  
  $content = decode('UTF-8', $content);
  
  return $content;
}

sub create_toc_html_file {
  my $toc_content = qq|<div class="toc">\n|;
  $toc_content .= "<h2>目次</h2>\n";
  for my $chapter_number (1 .. $chapter_number_last) {
    
    # 章扉から章見出しを取得
    my $chapter_title_file = sprintf("$FindBin::Bin/templates/chapter%02d_title.html", $chapter_number);
    my $chapter_title_content = slurp($chapter_title_file);
    if ($chapter_title_content =~ m|<h1>(.*)?</h1>|s) {
      my $h1 = $1;
      $h1 =~ s|<br>| |g;
      $toc_content .= qq|<div class="toc_h1">$h1</div>\n|;
      push @$chapter_titles, $h1;
    }
    # 章本文から副見出しを取得
    my $chapter_file = sprintf("$FindBin::Bin/templates/chapter%02d.html", $chapter_number);
    my $chapter_content = slurp($chapter_file);
    my $h2_count = 0;
    my $h3_count = 0;
    while ($chapter_content =~ m#<h(2|3)>([^\<]*)</h(?:2|3)>#gs) {
      my $head = $1;
      my $title = $2;
      if ($head =~ /2/) {
        $h2_count++;
        $toc_content .= qq|<div class="toc_h2">$chapter_number.$h2_count $title</div>\n|;
        $h3_count = 0;
      }
      else {
        $h3_count++;
        $toc_content .= qq|<div class="toc_h3">$chapter_number.$h2_count.$h3_count $title</div>\n|;
      }
    }
  }
  $toc_content .= "</div>\n";
  
  # ファイルに出力
  my $toc_file = "$FindBin::Bin/templates/toc.html";
  open my $toc_fh, '>', $toc_file
    or die "Can't open file $toc_file:$!";
  
  print $toc_fh encode('UTF-8', $toc_content);
}

sub create_top_pdf_file {
  # 見開きPDFを作成
  create_pdf_file($wkhtmltopdf_cmd_with_opt, 'public/top.html', 'public/top.pdf');
}

sub create_beginning_pdf_file {
  # はじめにPDFを作成
  create_pdf_file($wkhtmltopdf_cmd_with_opt, 'public/beginning.html', 'public/beginning.pdf');
}

sub create_toc_pdf_file {
  # 目次のPDFを作成
  create_pdf_file($wkhtmltopdf_cmd_with_opt, 'public/toc.html', 'public/toc.pdf');
}

sub create_each_chapter_pdf_files {
  
  # 各章の扉PDFと本文PDFを作成
  for my $chapter_number (1 .. $chapter_number_last) {
    
    # 扉PDFの作成(背景色で埋めるためマージンを0にする)
    {
      # HTMLをPDFに変換
      my $wkhtmltopdf_cmd_with_opt = "$wkhtmltopdf_cmd $lowquality --page-size $page_size --margin-bottom 0mm --margin-left 0mm --margin-right 0mm --margin-top 0mm";
      my $chapter_html_file_base = sprintf("chapter%02d_title.html", $chapter_number);
      my $chapter_pdf_file_base = $chapter_html_file_base;
      $chapter_pdf_file_base =~ s/\.html$/.pdf/;
      create_pdf_file($wkhtmltopdf_cmd_with_opt, "public/$chapter_html_file_base", "public/$chapter_pdf_file_base");
    }
    
    # 本文PDFの作成
    {
      my $chapter_html_file_base = sprintf("chapter%02d.html", $chapter_number);
      my $chapter_pdf_file_base = $chapter_html_file_base;
      $chapter_pdf_file_base =~ s/\.html$/.pdf/;
      create_pdf_file($wkhtmltopdf_cmd_with_opt, "public/$chapter_html_file_base", "public/$chapter_pdf_file_base");
    }
  }
}

# HTMLからPDFを作成する関数
sub create_pdf_file {
  my ($wkhtmltopdf_cmd_with_opt, $input_html_file, $output_pdf_file) = @_;
  
  # 静的ファイルのコピーロジックが現在のGiblogでは間違っているために、キャッシュロジックを一時的に解除
  # if (-M $input_html_file < -M $output_pdf_file) {
    my $wkhtmltopdf_cmd_with_opt_and_args = "$wkhtmltopdf_cmd_with_opt $input_html_file $output_pdf_file";
    
    system($wkhtmltopdf_cmd_with_opt_and_args) == 0
      or die "Can't create PDF file from $input_html_file to $output_pdf_file: $wkhtmltopdf_cmd_with_opt_and_args";
  # }
}

sub concat_pdf_file {
  my $all_pdf = PDF::API2->new();
  
  # フォント
  my $font = $all_pdf->ttfont('/usr/share/fonts/truetype/fonts-japanese-gothic.ttf');

  # A5サイズ
  $all_pdf->mediabox('A5');
  
  # 見開き(ページを偶数にする)
  my $top_pdf = PDF::API2->open("$FindBin::Bin/public/top.pdf");
  $all_pdf->import_page($top_pdf);
  if ($all_pdf->pages % 2 != 0) {
    $all_pdf->page;
  }

  # はじめに(ページを偶数にする)
  my $beginning_pdf = PDF::API2->open("$FindBin::Bin/public/beginning.pdf");
  $all_pdf->import_page($beginning_pdf);
  if ($all_pdf->pages % 2 != 0) {
    $all_pdf->page;
  }

  # 目次(ページを偶数にする)
  my $toc_pdf = PDF::API2->open("$FindBin::Bin/public/toc.pdf");
  for my $page_number (1 .. $toc_pdf->pages) {
    $all_pdf->import_page($toc_pdf, $page_number);
  }
  if ($all_pdf->pages % 2 != 0) {
    $all_pdf->page;
  }
  
  # 各章の扉と本文を結合
  for my $chapter_number (1 .. $chapter_number_last) {
    
    # 扉を結合
    {
      my $chapter_html_file_base = sprintf("chapter%02d_title.pdf", $chapter_number);
      my $chapter_pdf = PDF::API2->open("$FindBin::Bin/public/$chapter_html_file_base");
      $all_pdf->import_page($chapter_pdf, 1);
    }
    
    # 本文を結合
    {
      my $chapter_html_file_base = sprintf("chapter%02d.pdf", $chapter_number);
      
      my $chapter_pdf = PDF::API2->open("$FindBin::Bin/public/$chapter_html_file_base");
      for my $page_number (1 .. $chapter_pdf->pages) {
        # 本文ページをインポート
        $all_pdf->import_page($chapter_pdf, $page_number);
        
        # ページ番号が偶数だった場合(右側ページ)に、章のタイトルを追加
        if ($all_pdf->pages % 2 != 0) {
          my $page_all_pdf = $all_pdf->openpage($all_pdf->pages);
          my $text_all_pdf = $page_all_pdf->text();
          $text_all_pdf->font($font, 8.5);
          $text_all_pdf->translate(400, 561);
          my $chapter_title = $chapter_titles->[$chapter_number - 1];
          $text_all_pdf->text_right($chapter_title);
        }
      }
    }
    
    # 余白ページ調整(4の倍数にする)
    my $all_pdf_pages_mod = $all_pdf->pages % 4;
    if ($all_pdf_pages_mod != 0) {
      my $add_pages = 4 - $all_pdf_pages_mod;
      for (my $i = 0; $i < $add_pages; $i++) {
        $all_pdf->page;
      }
    }
  }
  
  # ページ番号を挿入(はじめにから)
  for (my $page_number = 3; $page_number <= $all_pdf->pages; $page_number++) {
    my $page = $all_pdf->openpage($page_number);
    my $text_page_number = $page->text();
    $text_page_number->font($font, 8.5);
    
    # 表示ページ番号
    my $display_page_number = $page_number - 2;

    # 右開き奇数
    if ($display_page_number % 2 != 0) {
      $text_page_number->translate(388, 18);
    }
    # 左開き偶数
    else {
      $text_page_number->translate(20, 18);
    }
    $text_page_number->text($display_page_number);
  }

  # 全体を出力
  my $all_pdf_file = "$FindBin::Bin/public/book.pdf";
  $all_pdf->saveas($all_pdf_file);
}
