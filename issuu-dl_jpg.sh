#!/usr/bin/env bash
# updated 04FEB2024

if (curl -s ifconfig.co > /dev/null;) then  
	html=$(wget --quiet --retry-connrefused  --waitretry=1  --read-timeout=20 --tries=0 --output-document=- "$1")
	html0=$(echo "$html" | echo $html | grep -oE "pageCount.*more" | sed -re "s/\&quot.//g" )
	echo $html0
	else     
	echo "1"; sleep 10
fi




page_count=$(echo "$html0" |\
    grep --only-matching --perl-regexp 'pageCount:\K\d+')
[[ $page_count > 0 ]] || { echo 'no pages' && exit 1; }

echo $page_count


publication_id=$(echo "$html0" |\
    grep --only-matching --perl-regexp 'publicationId:\K[a-z0-9]+(?=)')
[[ -n $publication_id ]] || { echo 'no publication_id' && exit 1; }

echo $publication_id


revision_id=$(echo "$html0" |\
    grep --only-matching --perl-regexp 'revisionId:\K[a-z0-9]+(?=)')
[[ -n $revision_id ]] || { echo 'no revision_id' && exit 1; }

echo $revision_id


# whatever hack works for title
title0=$(echo "$html" |\
    grep --only-matching --perl-regexp 'title&quot;:&quot;\K.*?(?=&quot;)')
[[ -z $title ]] && title=issuu

title1=$(echo $html | grep -ohE ".{0}title>.{230}" |  grep -oh ">.*by.*Issuu" | sed "s/>//" | sed "s/\//-/g" | sed "s/amp;//g");
[[ -z $title ]] && title=issuu

echo $title1


mkdir "${title1}"


for ((i = 1; i <= page_count; i++)); do
    foo=$(printf "%04d" ${i});
    wget  --limit-rate=800k  --retry-connrefused  --waitretry=1  --read-timeout=20 --tries=0 --output-document="$title1/"${foo}".jpg" \
        "https://image.issuu.com/${revision_id}-${publication_id}/jpg/page_${i}.jpg" 
done

echo "--------------------------------------------------------------------------";
numb_files="$(ls "${title1}" | wc -l)";
echo "title: $title1";
echo "the number of jpg files that were downloaded are: $numb_files";
echo "while it was counted that online exists: $page_count";
