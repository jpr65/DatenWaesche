#!/system/bin/sh

# Buchgenerierung

cd src
perl book.pl
pod2html gen/DatenWaesche_book.pod > gen/DatenWaesche_book.html
cd ..

