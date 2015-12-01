@rem !/system/bin/sh

@rem Buchgenerierung

cd src
perl -I../../../AndroidPerl/spartanic/lib book.pl

call pod2html gen/DatenWaesche_book.pod > gen/DatenWaesche_book.html
@rem call perl ../pod2pdf.pl gen/DatenWaesche_book.pod
cd ..

pause